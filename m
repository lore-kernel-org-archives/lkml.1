Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbZKEOkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbZKEOkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbZKEOk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:40:29 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:13698 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbZKEOkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:40:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iuA/ewWbzay2ARgeF9TnpCWcbDXXoJA7erZ9s9K4pH6D4puD+bKyrRKaPqb4RA2tfY
         7gDBuzObUe8LjQ8BB37BO+f6m3XPRv+BXUaQJcFseK4z0E8tC4+F9+O7gS3wyKNv6Hro
         AJGuJecMxCAPR3EtaRaVxCAqb7CD0ajUGEbIY=
MIME-Version: 1.0
In-Reply-To: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com>
References: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com>
Date: Thu, 5 Nov 2009 09:40:28 -0500
Message-ID: <73c1f2160911050640u45f47e46yf6e18101231c2729@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, crypto, Generate .byte code for some new 
	instructions via gas macro
From: Brian Gerst <brgerst@gmail.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Herbert Xu <herbert@gondor.apana.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 5, 2009 at 1:44 AM, Huang Ying <ying.huang@intel.com> wrote:
> It will take some time for binutils (gas) to support some newly added
> instructions, such as SSE4.1 instructions or the AES-NI instructions
> found in upcoming Intel CPU.
>
> To make the source code can be compiled by old binutils, .byte code is
> used instead of the assembly instruction. But the readability and
> flexibility of raw .byte code is not good.
>
> This patch solves the issue of raw .byte code via generating it via
> assembly instruction like gas macro. The syntax is as close as
> possible to real assembly instruction.
>
> Some helper macros such as MODRM is not a full feature
> implementation. It can be extended when necessary.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/include/asm/inst.h |  150 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 150 insertions(+)
>
> --- /dev/null
> +++ b/arch/x86/include/asm/inst.h
> @@ -0,0 +1,150 @@
> +/*
> + * Generate .byte code for some instructions not supported by old
> + * binutils.
> + */
> +#ifndef X86_ASM_INST_H
> +#define X86_ASM_INST_H
> +
> +#ifdef __ASSEMBLY__
> +
> +       .macro XMM_NUM opd xmm
> +       .ifc \xmm,%xmm0
> +       \opd = 0
> +       .endif
> +       .ifc \xmm,%xmm1
> +       \opd = 1
> +       .endif
> +       .ifc \xmm,%xmm2
> +       \opd = 2
> +       .endif
> +       .ifc \xmm,%xmm3
> +       \opd = 3
> +       .endif
> +       .ifc \xmm,%xmm4
> +       \opd = 4
> +       .endif
> +       .ifc \xmm,%xmm5
> +       \opd = 5
> +       .endif
> +       .ifc \xmm,%xmm6
> +       \opd = 6
> +       .endif
> +       .ifc \xmm,%xmm7
> +       \opd = 7
> +       .endif
> +       .ifc \xmm,%xmm8
> +       \opd = 8
> +       .endif
> +       .ifc \xmm,%xmm9
> +       \opd = 9
> +       .endif
> +       .ifc \xmm,%xmm10
> +       \opd = 10
> +       .endif
> +       .ifc \xmm,%xmm11
> +       \opd = 11
> +       .endif
> +       .ifc \xmm,%xmm12
> +       \opd = 12
> +       .endif
> +       .ifc \xmm,%xmm13
> +       \opd = 13
> +       .endif
> +       .ifc \xmm,%xmm14
> +       \opd = 14
> +       .endif
> +       .ifc \xmm,%xmm15
> +       \opd = 15
> +       .endif
> +       .endm
> +
> +       .macro PFX_OPD_SIZE
> +       .byte 0x66
> +       .endm
> +
> +       .macro PFX_REX opd1 opd2
> +       .if (\opd1 | \opd2) & 8
> +       .byte 0x40 | ((\opd1 & 8) >> 3) | ((\opd2 & 8) >> 1)
> +       .endif
> +       .endm
> +
> +       .macro MODRM mod opd1 opd2
> +       .byte \mod | (\opd1 & 7) | ((\opd2 & 7) << 3)
> +       .endm
> +
> +       .macro PSHUFB_XMM xmm1 xmm2
> +       XMM_NUM pshufb_opd1 \xmm1
> +       XMM_NUM pshufb_opd2 \xmm2
> +       PFX_OPD_SIZE
> +       PFX_REX pshufb_opd1 pshufb_opd2
> +       .byte 0x0f, 0x38, 0x00
> +       MODRM 0xc0 pshufb_opd1 pshufb_opd2
> +       .endm
> +
> +       .macro PCLMULQDQ imm8 xmm1 xmm2
> +       XMM_NUM clmul_opd1 \xmm1
> +       XMM_NUM clmul_opd2 \xmm2
> +       PFX_OPD_SIZE
> +       PFX_REX clmul_opd1 clmul_opd2
> +       .byte 0x0f, 0x3a, 0x44
> +       MODRM 0xc0 clmul_opd1 clmul_opd2
> +       .byte \imm8
> +       .endm
> +
> +       .macro AESKEYGENASSIST rcon xmm1 xmm2
> +       XMM_NUM aeskeygen_opd1 \xmm1
> +       XMM_NUM aeskeygen_opd2 \xmm2
> +       PFX_OPD_SIZE
> +       PFX_REX aeskeygen_opd1 aeskeygen_opd2
> +       .byte 0x0f, 0x3a, 0xdf
> +       MODRM 0xc0 aeskeygen_opd1 aeskeygen_opd2
> +       .byte \rcon
> +       .endm
> +
> +       .macro AESIMC xmm1 xmm2
> +       XMM_NUM aesimc_opd1 \xmm1
> +       XMM_NUM aesimc_opd2 \xmm2
> +       PFX_OPD_SIZE
> +       PFX_REX aesimc_opd1 aesimc_opd2
> +       .byte 0x0f, 0x38, 0xdb
> +       MODRM 0xc0 aesimc_opd1 aesimc_opd2
> +       .endm
> +
> +       .macro AESENC xmm1 xmm2
> +       XMM_NUM aesenc_opd1 \xmm1
> +       XMM_NUM aesenc_opd2 \xmm2
> +       PFX_OPD_SIZE
> +       PFX_REX aesenc_opd1 aesenc_opd2
> +       .byte 0x0f, 0x38, 0xdc
> +       MODRM 0xc0 aesenc_opd1 aesenc_opd2
> +       .endm
> +
> +       .macro AESENCLAST xmm1 xmm2
> +       XMM_NUM aesenclast_opd1 \xmm1
> +       XMM_NUM aesenclast_opd2 \xmm2
> +       PFX_OPD_SIZE
> +       PFX_REX aesenclast_opd1 aesenclast_opd2
> +       .byte 0x0f, 0x38, 0xdd
> +       MODRM 0xc0 aesenclast_opd1 aesenclast_opd2
> +       .endm
> +
> +       .macro AESDEC xmm1 xmm2
> +       XMM_NUM aesdec_opd1 \xmm1
> +       XMM_NUM aesdec_opd2 \xmm2
> +       PFX_OPD_SIZE
> +       PFX_REX aesdec_opd1 aesdec_opd2
> +       .byte 0x0f, 0x38, 0xde
> +       MODRM 0xc0 aesdec_opd1 aesdec_opd2
> +       .endm
> +
> +       .macro AESDECLAST xmm1 xmm2
> +       XMM_NUM aesdeclast_opd1 \xmm1
> +       XMM_NUM aesdeclast_opd2 \xmm2
> +       PFX_OPD_SIZE
> +       PFX_REX aesdeclast_opd1 aesdeclast_opd2
> +       .byte 0x0f, 0x38, 0xdf
> +       MODRM 0xc0 aesdeclast_opd1 aesdeclast_opd2
> +       .endm
> +#endif
> +
> +#endif

It would be nice to document which version of GAS added support for
each instruction, so that if/when that version becomes the minimum
supported these macros can be removed.

--
Brian Gerst
