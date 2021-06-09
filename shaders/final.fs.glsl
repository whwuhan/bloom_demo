#version 330 core
out vec4 frag_color;
in vec2 tex_coords;

uniform sampler2D scene;            // 原始场景
uniform sampler2D bloom_blur;       // 经过模糊后的高光部分
uniform float exposure;             // 曝光度，用于进行tone mapping

void main()
{
    const float gamma = 2.2;
    vec3 hdr_color = texture(scene, tex_coords).rgb;            // 原图色彩
    vec3 bloom_color = texture(bloom_blur, tex_coords).rgb;     // 模糊后的高光色彩
    hdr_color += bloom_color;                                   // 叠加到一起
    // tone mapping
    vec3 result = vec3(1.0) - exp(-hdr_color * exposure);
    // gamma校正
    result = pow(result, vec3(1.0 / gamma));
    frag_color = vec4(result, 1.0);
}