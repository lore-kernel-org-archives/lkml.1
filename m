Return-Path: <linux-kernel-owner+w=401wt.eu-S1751867AbZHHPUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbZHHPUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZHHPUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:20:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62937 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZHHPUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=RjD82Yp6zw9hgcvquxw+pi6s7DBzWuDejkyLA9go/WjEDNhMfSQnhD4oSNrI0Bv495
         A/PVnnUjkxBIwA3fK9EbIeuGAM0LTVSp0aFnQgk8as2ldtwgJtW7z5EL0k6I+jOfBL66
         RFG/jKETC3ntBCZb+gMrd/A02QEZ/PdinsqT4=
Date: Sat, 8 Aug 2009 17:20:16 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
Subject: Re: [PATCH] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
Message-ID: <20090808152016.GB25374@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Kevin Winchester <kjwinchester@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
References: <4A7D673A.1090401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A7D673A.1090401@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Aug 08, 2009 at 08:53:30AM -0300, Kevin Winchester wrote:
> Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
> need to force enable the LAHF_LM capability.  Unfortunately, in at
> least one case, the BIOS does this even for processors that do not
> support the functionality.
> 
> Add a specific check that will clear the feature bit for processors
> known not to support the LAHF/SAHF instructions.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
> 
> While making this change, I noticed the clause above my code:
> 
>     if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
> 
> It does not seem concerned with the possibility that some of the
> upper 16 bits of level will be non-zero.  Is this intentional, or
> should the upper 16 bits be masked off before the comparisons?

This should be ok because the upper 16 bits are 0x0000 for those
revisions and therefore the whole u32 matches. Later revisions have the
extended model bumped and they also match.

> 
>  arch/x86/kernel/cpu/amd.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index e2485b0..a2f0fe4 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -400,6 +400,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  		level = cpuid_eax(1);
>  		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>  			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> +
> +		/*
> +		 * Some BIOSes incorrectly set this feature, but only
> +		 * Revision E (with Extended Model = 2) actually supports
> +		 * it.
> +		 */
> +		if (!(level & 0x00020000))
> +			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);

let me check this internally next week because
it seems that according to the Fam 0xf RevGuide
(http://support.amd.com/us/Processor_TechDocs/25759.pdf) erratum 110
applies to atleast 3 CPU revisions with extended model 0x1 too.

By the way, what does /proc/cpuinfo say on your machine?

-- 
Regards/Gruss,
    Boris.
