Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZHMOVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZHMOVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZHMOVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:21:23 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64282 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZHMOVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pWJoAtult5t2N2macEKimcuWXOJsfPvJUc7PzbXw3Q29X5WZ/60oXUOXRCv224hU1i
         AlI6vGqoaNBL7u37uaNQNEX50SbQCaViYlO3tzzviZ56Bed++8EZFCEovxwr/SABn2mK
         GfgWCR+Uz2tzRbISPv5E5XsoOutGNbMnz3gMs=
MIME-Version: 1.0
In-Reply-To: <1250166687-17673-2-git-send-email-borislav.petkov@amd.com>
References: <20090813122337.GB7029@aftab>
	 <1250166687-17673-2-git-send-email-borislav.petkov@amd.com>
Date: Thu, 13 Aug 2009 10:21:22 -0400
Message-ID: <73c1f2160908130721y3c14c4e7h1ff967bac867d7e6@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Clear incorrectly forced X86_FEATURE_LAHF_LM 
	flag
From: Brian Gerst <brgerst@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: kjwinchester@gmail.com, mikpe@it.uu.se, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 8:31 AM, Borislav Petkov<borislav.petkov@amd.com> wrote:
> From: Kevin Winchester <kjwinchester@gmail.com>
>
> Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
> need to force enable the LAHF_LM capability.  Unfortunately, in at
> least one case, the BIOS does this even for processors that do not
> support the functionality.
>
> Add a specific check that will clear the feature bit for processors
> known not to support the LAHF/SAHF instructions.
>
> Borislav: turn off cpuid bit.
>
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index e2485b0..9cd6fc7 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -400,6 +400,22 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>                level = cpuid_eax(1);
>                if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>                        set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> +
> +               /*
> +                * Some BIOSes incorrectly force this feature, but only K8
> +                * revision D (model = 0x14) and later actually support it.
> +                */
> +               if (c->x86_model < 0x14) {

Shouldn't you test that the flag is actually set before trying to clear it?

> +                       u64 val;
> +
> +                       clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
> +                       if (!rdmsrl_amd_safe(0xc001100d, &val)) {
> +                               val &= ~(1ULL << 32);
> +                               wrmsr_amd_safe(0xc001100d, (u32) val,
> +                                                          (u32)(val >> 32));
> +                       }
> +               }
> +
>        }
>        if (c->x86 == 0x10 || c->x86 == 0x11)
>                set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> --
> 1.6.3.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
