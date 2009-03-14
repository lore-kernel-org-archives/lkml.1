Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZCNNJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZCNNJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZCNNJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:09:46 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:58444 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZCNNJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:09:45 -0400
Date: Sat, 14 Mar 2009 14:11:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/intel.c cleanup
Message-ID: <20090314131142.GA29582@uranus.ravnborg.org>
References: <1237034492.4546.1.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237034492.4546.1.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  #include <asm/processor.h>
> +#include <asm/topology.h>
>  #include <asm/pgtable.h>
> -#include <asm/msr.h>
> -#include <asm/uaccess.h>
> -#include <asm/ds.h>
> +#ifdef CONFIG_X86_LOCAL_APIC
> +#include <asm/mpspec.h>
> +#include <asm/apic.h>
> +#endif

If these header files are only relevant for CONFIG_X86_LOCAL_APIC
then we should move the ifdef down into the header file,
so users do not forget it.

	Sam

>  static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  {
> +#ifdef CONFIG_X86_32
>  	unsigned long lo, hi;
>  
>  #ifdef CONFIG_X86_F00F_BUG
>  	/*
> -	 * All current models of Pentium and Pentium with MMX technology CPUs
> -	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
> +	 * All current models of Pentium and Pentium with MMX technology
> +	 * CPUs have the F0 0F bug, which lets nonprivileged users lock
> +	 * up the system.
>  	 * Note that the workaround only should be initialized once...
>  	 */
>  	c->f00f_bug = 0;
> @@ -184,7 +207,8 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  		c->f00f_bug = 1;
>  		if (!f00f_workaround_enabled) {
>  			trap_init_f00f_bug();
> -			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
> +			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - "
> +				"workaround enabled.\n");
>  			f00f_workaround_enabled = 1;
>  		}
>  	}
> @@ -194,7 +218,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  	 * SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until
>  	 * model 3 mask 3
>  	 */
> -	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
> +	if ((c->x86 << 8 | c->x86_model << 4 | c->x86_mask) < 0x633)
>  		clear_cpu_cap(c, X86_FEATURE_SEP);
>  
>  	/*
> @@ -204,10 +228,10 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
>  		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
>  		if ((lo & MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE) == 0) {
> -			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
> -			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
> +			pr_info("CPU: C0 stepping P4 Xeon detected.\n");
> +			pr_info("CPU: Disabling hardware prefetching (Errata 037)\n");
>  			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
> -			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
> +			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
>  		}
>  	}
>  
> @@ -217,7 +241,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  	 * integrated APIC (see 11AP erratum in "Pentium Processor
>  	 * Specification Update").
>  	 */
> -	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
> +	if (cpu_has_apic && (c->x86 << 8 | c->x86_model << 4) == 0x520 &&
>  	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
>  		set_cpu_cap(c, X86_FEATURE_11AP);
>  
> @@ -245,28 +269,26 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  #endif
>  
>  	intel_smp_check(c);
> -}
> -#else
> -static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
> -{
> -}
>  #endif
> +}

To me it is more obvious with the old style.
Having ifdef's inside the block is less obvious.

But I have not checked what is the common pattern.

	Sam
