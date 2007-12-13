Return-Path: <linux-kernel-owner+w=401wt.eu-S934457AbXLMW76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934457AbXLMW76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764154AbXLMW7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:59:51 -0500
Received: from saeurebad.de ([85.214.36.134]:33487 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762561AbXLMW7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:59:50 -0500
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
References: <20071214004710.03f37774@linux360.ro>
Date: Thu, 13 Dec 2007 23:58:50 +0100
In-Reply-To: <20071214004710.03f37774@linux360.ro> (Eduard-Gabriel Munteanu's
	message of "Fri, 14 Dec 2007 00:47:10 +0200")
Message-ID: <x77ijiryl1.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro> writes:

> diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
> index 30d94d1..15556a0 100644
> --- a/arch/x86/kernel/setup_64.c
> +++ b/arch/x86/kernel/setup_64.c
> @@ -583,6 +583,17 @@ static void __init amd_detect_cmp(struct cpuinfo_x86 *c)
>  #endif
>  }
>  
> +#ifdef CONFIG_X86_AMD_C1E_WORKAROUND
> +static int __cpuinit disable_amd_c1e = 1;
> +
> +static int __cpuinit force_amd_c1e(char *str) {
> +	disable_amd_c1e = 0;
> +	return 1;
> +}
> +
> +__setup("force_amd_c1e", force_amd_c1e);
> +#endif /* CONFIG_X86_AMD_C1E_WORKAROUND */
> +
>  #define ENABLE_C1E_MASK		0x18000000
>  #define CPUID_PROCESSOR_SIGNATURE	1
>  #define CPUID_XFAM		0x0ff00000
> @@ -597,6 +608,7 @@ static __cpuinit int amd_apic_timer_broken(void)
>  {
>  	u32 lo, hi;
>  	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
> +
>  	switch (eax & CPUID_XFAM) {
>  	case CPUID_XFAM_K8:
>  		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
> @@ -604,8 +616,19 @@ static __cpuinit int amd_apic_timer_broken(void)
>  	case CPUID_XFAM_10H:
>  	case CPUID_XFAM_11H:
>  		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
> -		if (lo & ENABLE_C1E_MASK)
> -			return 1;
> +#ifdef CONFIG_X86_AMD_C1E_WORKAROUND
> +		if ((lo & ENABLE_C1E_MASK) && disable_amd_c1e) {
> +			printk(KERN_INFO "Disabling AMD C1E on CPU %d\n",
> +			       smp_processor_id());
> +			/* 
> +			 * See AMD's "BIOS and Kernel Developer's Guide for AMD
> +			 * NPT Family 0Fh Processors", publication #32559,
> +			 * for details.
> +			 */
> +			wrmsr(MSR_K8_ENABLE_C1E, lo & ~ENABLE_C1E_MASK, hi); 
> +		} else 
> +#endif /* CONFIG_X86_AMD_C1E_WORKAROUND */
> +		if (lo & ENABLE_C1E_MASK) return 1;

I would find this way more readable:

	if (lo & ENABLE_C1E_MASK) {
#ifdef CONFIG_X86_AMD_C1E_WORKAROUND
		if (disable_amd_c1e) {
			...
#else
		return 1;
#endif
	}

Why does it require to be enabled by compile-time AND run-time?  Is that
something you might want to decide on every boot?  Could we make it
settable at boot-time xor at compile-time?

	Hannes
