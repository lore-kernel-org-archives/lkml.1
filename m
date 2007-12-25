Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbXLYWHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbXLYWHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 17:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbXLYWHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 17:07:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbXLYWHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 17:07:05 -0500
Date: Tue, 25 Dec 2007 14:04:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: rml@google.com (Russell Leidich)
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-Id: <20071225140413.e8b4f2cd.akpm@linux-foundation.org>
In-Reply-To: <20071217185453.C4597CC562@localhost>
References: <20071217185453.C4597CC562@localhost>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 10:54:53 -0800 (PST) rml@google.com (Russell Leidich) wrote:

> Hi,
> 
> This patch to 2.6.24-rc5 enables AMD Barcelona CPUs to register thermal throttling events as machine checks, in the
> same fashion as the analogous Intel code.
> 
> Changed files:
> 
> arch/x86/kernel/cpu/mcheck/Makefile
> arch/x86/kernel/cpu/mcheck/mce_amd_64.c
> arch/x86/kernel/cpu/mcheck/mce_intel_64.c
> include/asm-x86/mce.h
> 
> New files:
> 
> arch/x86/kernel/cpu/mcheck/mce_thermal.c
> 
> ...
>
> +extern int num_k8_northbridges;
> +extern struct pci_dev **k8_northbridges;

Please never add extern declarations in C files - find a suitable header
which is seen by the definition and by all users.

> -static int threshold_cpu_callback(struct notifier_block *nfb,
> +static int amd_cpu_callback(struct notifier_block *nfb,
>  					    unsigned long action, void *hcpu)
>  {
>  	/* cpu was unsigned int to begin with */
>  	unsigned int cpu = (unsigned long)hcpu;
>  
> -	if (cpu >= NR_CPUS)
> -		goto out;
> -
>  	switch (action) {
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
>  		threshold_create_device(cpu);
> -		break;
> +		if (thermal_apic_init_allowed) {
> +			/*
> +			 * We need to run thermal_apic_init() on the core that
> +			 * just came online.  If we're already on that core,
> +			 * then directly run it.  Otherwise
> +			 * smp_call_function_single() to that core.
> +			 */
> +			if (cpu == get_cpu())
> +				thermal_apic_init(NULL);
> +			else
> +				smp_call_function_single(cpu,
> +						&thermal_apic_init, NULL, 1, 0);
> +			put_cpu();
> +		}

smp_call_function_single() already takes care of the
called-on-the-right-cpu case.

> + 		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
>  		threshold_remove_device(cpu);
> @@ -665,12 +692,11 @@ static int threshold_cpu_callback(struct
>  	default:
>  		break;
>  	}
> -      out:
>  	return NOTIFY_OK;
>  }
>  
> +
> +/*
> + * Enable the delivery of thermal interrupts via the local APIC.
> + */
> +static void thermal_apic_init(void *unused) {

eek, google coding "style" ;)

Please feed patches through scripts/checkpatch.pl.

> +	unsigned int apic_lv_therm;
> +
> +	/* Set up APIC_LVTTHMR to issue THERMAL_APIC_VECTOR. */
> +	apic_lv_therm = apic_read(APIC_LVTTHMR);
> +	/*
> +	 * See if some agent other than this routine has already initialized
> +	 * APIC_LVTTHMR, i.e. if it's unmasked, but not equal to the value that
> +	 * we would have programmed, had we been here before on this core.
> +	 */
> +	if ((!(apic_lv_therm & APIC_LVT_MASKED)) && ((apic_lv_therm &
> +		(APIC_MODE_MASK | APIC_VECTOR_MASK)) != (APIC_DM_FIXED |
> +		THERMAL_APIC_VECTOR))) {
> +		unsigned int cpu = smp_processor_id();

afaict this function is called while the calling thread is running
preemptibly.  This smp_processor_id() call should have generated a runtime
warning if it was tested with all debug options enabled?

Please see Documentation/SumitChecklist.

> +		printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
> +			"functional.\n", cpu);
> +		if ((apic_lv_therm & APIC_MODE_MASK) == APIC_DM_SMI)
> +			printk(KERN_DEBUG "Thermal interrupts already "
> +				"handled by SMI according to (((local APIC "
> +				"base) + 0x330) bit 0x9).\n");
> +		else
> +			printk(KERN_DEBUG "Thermal interrupts unexpectedly "
> +				"enabled at (((local APIC base) + 0x330) bit "
> +				"0x10).\n");
> +	} else {
> +		/*
> +		 * Configure the Local Thermal Vector Table Entry to issue
> +		 * issue thermal interrupts to THERMAL_APIC_VECTOR.
> +		 *
> +		 * Start by masking off Delivery Mode and Vector.
> +		 */
> +		apic_lv_therm &= ~(APIC_MODE_MASK | APIC_VECTOR_MASK);
> +		/* Fixed interrupt, masked for now. */
> +		apic_lv_therm |= APIC_LVT_MASKED | APIC_DM_FIXED |
> +							THERMAL_APIC_VECTOR;
> +		apic_write(APIC_LVTTHMR, apic_lv_therm);
> +		/*
> +		 * The Intel thermal kernel code implies that there may be a
> +		 * race involving the mask bit, so clear it only now, after
> +		 * the other bits have settled.
> +		 */
> +		apic_write(APIC_LVTTHMR, apic_lv_therm & ~APIC_LVT_MASKED);
> +	}
> +}
> +
> +
> +/*
> + * Determine whether or not the northbridges support thermal throttling
> + * interrupts.  If so, initialize them for receiving the same, then perform
> + * corresponding APIC initialization on each core.
> + */
> +static int smp_thermal_interrupt_init(void)
> +{
> +	int nb_num;
> +	int thermal_registers_functional;
> +
> +	/*
> +	 * If there are no recognized northbridges, then we can't talk to the
> +	 * thermal registers.
> + 	 */
> +	thermal_registers_functional = num_k8_northbridges; 
> +	/*
> +	 * If any of the northbridges has PCI ID 0x1103, then its thermal
> +	 * hardware suffers from an erratum which prevents this code from working,
> +	 * so abort.
> +	 */
> +	for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
> +		if ((k8_northbridges[nb_num]->device) == 0x1103) {
> +			thermal_registers_functional = 0;
> +			break;
> +		}
> +	}
> +	if (thermal_registers_functional) {
> +		/*
> +		 * Assert that we should log thermal throttling events, whenever
> +		 * we eventually get around to enabling them.
> +		 */
> +		atomic_set(&therm_throt_en, 1);
> +		/*
> +		 * Bind cpu_specific_smp_thermal_interrupt() to
> +		 * amd_smp_thermal_interrupt().
> +		 */
> +		cpu_specific_smp_thermal_interrupt = amd_smp_thermal_interrupt;
> +		smp_thermal_northbridge_init();
> +		/*
> +		 * We've now initialized sufficient fabric to permit the
> +		 * initialization of the thermal interrupt APIC vectors, such as
> +		 * when a core comes online and calls amd_cpu_callback().
> +		 */
> +		thermal_apic_init_allowed = 1;			
> +		/*
> +		 * Call thermal_apic_init() on each core.
> +		 */
> +		on_each_cpu(&thermal_apic_init, NULL, 1, 0);
> +		smp_thermal_early_throttle_check();
> +	}
> +	return 0;
> +}

The logic in this function looks more complex than it needs to be.

	if (num_k8_northbridges == 0)
		goto out;
	for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
		if ((k8_northbridges[nb_num]->device) == 0x1103)
			goto out;
	}

maybe?	

> --- linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/mce_thermal.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_thermal.c	2007-12-13 12:26:13.057412000 -0800
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (c) 2007 Google Inc.
> + *
> + * Written by Mike Waychison <mikew@google.com> and Russell Leidich <rml@google.com>.
> + *
> + * CPU-independent thermal interrupt handler.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include "mce.h"
> +#include <asm/hw_irq.h>
> +#include <asm/idle.h>
> +
> +static void default_smp_thermal_interrupt(void) {}

static void default_smp_thermal_interrupt(void)
{
}

please.


Can this function ever actually be called?

> +cpu_specific_smp_thermal_interrupt_callback cpu_specific_smp_thermal_interrupt =
> +						default_smp_thermal_interrupt;
> +
> +/*
> + * Wrapper for the CPU-specific thermal interrupt service routine.  Without
> + * this, we'd have to discern the CPU brand at runtime (because support could
> + * be installed for more than one).
> + */
> +asmlinkage void smp_thermal_interrupt(void)
> +{
> +	ack_APIC_irq();
> +	exit_idle();
> +	irq_enter();
> +	cpu_specific_smp_thermal_interrupt();
> +	irq_exit();
> +}
> diff -uprN linux-2.6.24-rc5.orig/include/asm-x86/mce.h linux-2.6.24-rc5/include/asm-x86/mce.h
> --- linux-2.6.24-rc5.orig/include/asm-x86/mce.h	2007-12-11 14:31:34.263515000 -0800
> +++ linux-2.6.24-rc5/include/asm-x86/mce.h	2007-12-13 14:10:37.923970000 -0800
> @@ -113,7 +113,10 @@ static inline void mce_amd_feature_init(
>  #endif
>  
>  void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
> +typedef void (*cpu_specific_smp_thermal_interrupt_callback)(void);

Yes, this is the case where typedefs are OK.  But please put a _t at the end
of the name.

> +extern cpu_specific_smp_thermal_interrupt_callback
> +                                       cpu_specific_smp_thermal_interrupt;
>  extern atomic_t mce_entry;
>  
>  extern void do_machine_check(struct pt_regs *, long);

