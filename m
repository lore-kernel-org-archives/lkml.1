Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZHSP64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZHSP64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZHSP64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:58:56 -0400
Received: from www.tglx.de ([62.245.132.106]:50155 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZHSP6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:58:55 -0400
Date: Wed, 19 Aug 2009 17:57:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 10/10] x86/apic: Early setup IOAPIC for APB timer
In-Reply-To: <43F901BD926A4E43B106BF17856F0755643EBDFC@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908191753040.3361@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F0755643EBDFC@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Jul 2009, Pan, Jacob jun wrote:

> >From ba824feed1fc5aa5029f6506b0d54145b949d48d Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Wed, 15 Jul 2009 11:30:40 -0700
> Subject: [PATCH] x86/apic: Early setup IOAPIC for APB timer
> 
> Intel Moorestown platform uses APB system timers which rely
> on IOAPIC to deliver its interrupts. Early setup the APIC
> system is necessary to allow timer interrupts.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  arch/x86/include/asm/apic.h    |    1 +
>  arch/x86/kernel/apic/io_apic.c |   68 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index bb7d479..a74cb30 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -87,6 +87,7 @@ extern void xapic_wait_icr_idle(void);
>  extern u32 safe_xapic_wait_icr_idle(void);
>  extern void xapic_icr_write(u32, u32);
>  extern int setup_profiling_timer(unsigned int);
> +extern void pre_init_apic_IRQ(void);
>  
>  static inline void native_apic_mem_write(u32 reg, u32 v)
>  {
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 645c8eb..9bcbfa3 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -36,6 +36,7 @@
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
>  #include <linux/jiffies.h>	/* time_after() */
> +#include <linux/sfi.h>
>  #ifdef CONFIG_ACPI
>  #include <acpi/acpi_bus.h>
>  #endif
> @@ -63,6 +64,7 @@
>  #include <asm/uv/uv_hub.h>
>  #include <asm/uv/uv_irq.h>
>  #include <asm/platform_feature.h>
> +#include <asm/apb_timer.h>
>  #include <asm/apic.h>
>  
>  #define __apicdebuginit(type) static type __init
> @@ -2884,6 +2886,13 @@ static inline void __init check_timer(void)
>  
>  	local_irq_save(flags);
>  
> +	if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
> +		if (timer_irq_works()) {
> +			printk(KERN_INFO "APB timer works\n");
> +			return;

  What restores interrupt flags ?

> +		} else
> +			panic("Check APB timer failed\n");
> +	}
>  	/*
>  	 * get/set the timer IRQ vector:
>  	 */
> @@ -4225,3 +4234,62 @@ static int __init ioapic_insert_resources(void)
>  /* Insert the IO APIC resources after PCI initialization has occured to handle
>   * IO APICS that are mapped in on a BAR in PCI space. */
>  late_initcall(ioapic_insert_resources);
> +
> +/* Enable IOAPIC early just for system timer */
> +void __init pre_init_apic_IRQ(void)
> +{
> +	struct irq_cfg *cfg;
> +
> +	printk(KERN_INFO "Early APIC setup for system timer\n");
> +#ifndef CONFIG_SMP
> +	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
> +#endif
> +	setup_local_APIC();
> +	cfg = irq_cfg(0);
> +	add_pin_to_irq_node(cfg, 0, 0, 0);
> +	setup_timer_IRQ0_pin(0, 0, cfg->vector);
> +}
> +
> +#ifdef CONFIG_APB_TIMER
> +int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu)
> +{

  This looks wrong. It's conflicting with the generic affinity
  setting. I need to have a closer look to figure out the details.

Thanks,

	tglx

