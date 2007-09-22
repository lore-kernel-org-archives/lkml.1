Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbXIVJRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbXIVJRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXIVJRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:17:11 -0400
Received: from 8bytes.org ([88.198.83.132]:50766 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbXIVJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:17:10 -0400
Date: Sat, 22 Sep 2007 11:17:08 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [19/50] Experimental: detect if SVM is disabled by BIOS
Message-ID: <20070922091708.GD8998@8bytes.org>
References: <200709221231.836138000@suse.de> <20070921223218.22A8D13DCD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921223218.22A8D13DCD@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think we need this patch. When SVM is disabled KVM will tell on
module load. Further with SVM-lock it will be possible to re-enable SVM
even if it was disabled by BIOS using a key. In this case the user of
SVM has to clear the capability bit you set in this patch for all cpus.

On Sat, Sep 22, 2007 at 12:32:18AM +0200, Andi Kleen wrote:
> 
> Also allow to set svm lock.
> 
> TBD double check, documentation, i386 support
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86_64/kernel/setup.c    |   25 +++++++++++++++++++++++--
>  include/asm-i386/cpufeature.h |    1 +
>  include/asm-i386/msr-index.h  |    3 +++
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86_64/kernel/setup.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/setup.c
> +++ linux/arch/x86_64/kernel/setup.c
> @@ -565,7 +565,7 @@ static void __cpuinit early_init_amd(str
>  
>  static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  {
> -	unsigned level;
> +	unsigned level, flags, dummy;
>  
>  #ifdef CONFIG_SMP
>  	unsigned long value;
> @@ -634,7 +634,28 @@ static void __cpuinit init_amd(struct cp
>  	/* Family 10 doesn't support C states in MWAIT so don't use it */
>  	if (c->x86 == 0x10 && !force_mwait)
>  		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
> +
> +	if (c->x86 >= 0xf && c->x86 <= 0x11 &&
> +	    !rdmsr_safe(MSR_VM_CR, &flags, &dummy) &&
> +	    (flags & 0x18))
> +		set_bit(X86_FEATURE_VIRT_DISABLED, &c->x86_capability);
> +}
> +
> +static int enable_svm_lock(char *s)
> +{
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
> +		boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x11) {
> +		unsigned a,b;
> +		if (rdmsr_safe(MSR_VM_CR, &a, &b))
> +			return 0;
> +		a |= (1 << 3);	/* set SVM lock */
> +		if (!wrmsr_safe(MSR_VM_CR, &a, &b))
> +			return 1;
> +	}
> +	printk(KERN_ERR "CPU does not support svm_lock\n");
> +	return 0;
>  }
> +__setup("svm_lock", enable_svm_lock);
>  
>  static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
>  {
> @@ -985,7 +1006,7 @@ static int show_cpuinfo(struct seq_file 
>  		NULL, NULL, NULL, NULL,
>  		"constant_tsc", "up", NULL, "arch_perfmon",
>  		"pebs", "bts", NULL, "sync_rdtsc",
> -		"rep_good", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> +		"rep_good", "virtualization_bios_disabled", NULL, NULL, NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  
>  		/* Intel-defined (#2) */
> Index: linux/include/asm-i386/cpufeature.h
> ===================================================================
> --- linux.orig/include/asm-i386/cpufeature.h
> +++ linux/include/asm-i386/cpufeature.h
> @@ -82,6 +82,7 @@
>  /* 14 free */
>  #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
>  #define X86_FEATURE_REP_GOOD   (3*32+16) /* rep microcode works well on this CPU */
> +#define X86_FEATURE_VIRT_DISABLED (3*32+17) /* Hardware virt. BIOS disabled */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
>  #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
> Index: linux/include/asm-i386/msr-index.h
> ===================================================================
> --- linux.orig/include/asm-i386/msr-index.h
> +++ linux/include/asm-i386/msr-index.h
> @@ -98,6 +98,9 @@
>  #define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
>  #define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
>  
> +/* SVM */
> +#define MSR_VM_CR       0xc0010114
> +
>  /* K7 MSRs */
>  #define MSR_K7_EVNTSEL0			0xc0010000
>  #define MSR_K7_PERFCTR0			0xc0010004
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
