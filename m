Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZH2RWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZH2RWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 13:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZH2RWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 13:22:44 -0400
Received: from www.tglx.de ([62.245.132.106]:49933 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZH2RWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 13:22:44 -0400
Date: Sat, 29 Aug 2009 19:20:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Subject: Re: [RFC PATCH 3/7] x86: add moorestown specific platform setup
 code
In-Reply-To: <43F901BD926A4E43B106BF17856F07556A5EA874@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908291900090.19335@localhost.localdomain>
References: <20090821205008.518392436@linutronix.de> <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org> <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain> <43F901BD926A4E43B106BF17856F07556A5EA874@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Pan, Jacob jun wrote:

> >From dbb97928dc27061b56fc86b9b37f71f54bbafb59 Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Fri, 28 Aug 2009 08:31:45 -0700
> Subject: [PATCH] x86: add moorestown specific platform setup code
> 
> This patch fills in platform_setup functions for Moorestown. The abstraction
> is used to integarte into pc compaitible boot flow.

Your patch series is horrible as it breaks left and right. Patches
need to be ordered so they compile and boot in any stage.
 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  arch/x86/include/asm/setup.h |    8 ++
>  arch/x86/kernel/Makefile     |    1 +
>  arch/x86/kernel/mrst.c       |  149 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/setup.c      |    1 +
>  4 files changed, 159 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/kernel/mrst.c
> 
> diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
> index 055b778..2ef1514 100644
> --- a/arch/x86/include/asm/setup.h
> +++ b/arch/x86/include/asm/setup.h
> @@ -49,6 +49,14 @@ extern void reserve_standard_io_resources(void);
>  extern void i386_reserve_resources(void);
>  extern void setup_default_timer_irq(void);
>  
> +#ifdef CONFIG_MRST
> +extern void mrst_early_detect(void);
> +extern void setup_mrst_default_feature(void);

Why ? The function is inline in mrst.c.

> +++ b/arch/x86/kernel/mrst.c
> @@ -0,0 +1,149 @@
> +/*
> + * mrst.c: Intel Moorestown platform specific setup code
> + *
> + * (C) Copyright 2008 Intel Corporation
> + * Author: Jacob Pan (jacob.jun.pan@intel.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + *
> + * Note:
> + *
> + */
> +
> +#include <linux/stackprotector.h>
> +#include <linux/spi/spi.h>
> +#include <linux/i2c.h>
> +#include <linux/sfi.h>
> +#include <linux/i2c/pca953x.h>
> +#include <linux/spi/langwell_pmic_gpio.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
> +#include <linux/platform_device.h>
> +#include <linux/pci.h>
> +
> +#include <asm/platform_feature.h>
> +#include <asm/apb_timer.h>
> +#include <asm/apic.h>
> +#include <asm/hw_irq.h>
> +#include <asm/setup.h>
> +#include <asm/io.h>

Do we really need that whole bunch of includes ?

> +#define LANGWELL_GPIO_ALT_ADDR	0xff12c038
> +#define MRST_I2C_BUSNUM		3

That should be in the appropriate header file aside of being unused.

> +static inline void __init mrst_pre_intr_init(void)
> +{
> +	pre_init_apic_IRQ();
> +}

Later on you assign that function to:

> +	platform_setup.irqs.pre_vector_init = mrst_pre_intr_init;

I don't think that's correct. You need the early setup of the APIC
when you setup the APBT timer, but that's way after pre_vector_init.

Please do not use random platform functions just because they are
available.

The setup of the APIC to make your timer work should be done either in
context of the timer init function or in some appropriate place before
that.

> +/*
> + * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
> + * APBT but cmdline option can also override it.

We have the platform functions to avoid constructs like this. If you
set the function pointer to mrst_setup_secondary_clock in your
platform init the you can check the disable_apbt_percpu there or
restore the default in the function which evaluates the command line
option.

> + */
> +static void __init mrst_setup_secondary_clock(void)

Needs to be __cpuinit. If you have CPU_HOTPLUG enabled, which you need
for suspend/hibernate this function will be gone at the point you
access it.

> +{
> +	if (disable_apbt_percpu)
> +		return setup_secondary_APIC_clock();
> +	else {
> +#ifdef CONFIG_CC_STACKPROTECTOR
> +		/*
> +		  * TBD:
> +		 * this is to avoid false stack corruption panic since
> +		 * request_irq will be called early for secondary apbt clock.
> +		*/
> +		boot_init_stack_canary();
  
Eeek. Why is this related to request_irq ?

> +#endif
> +		apbt_setup_secondary_clock();
> +	}
> +}
> +
> +static void __init mrst_check_timer(void)
> +{
> +	if (timer_irq_works())
> +		printk(KERN_INFO "APB timer works\n");
> +	else
> +		panic("Check APB timer failed\n");
> +}

Errm. You add a new platform function just to add printk debug noise ?

> +static unsigned long __init mrst_calibrate_tsc(void)
> +{
> +	unsigned long flags, fast_calibrate;
> +
> +	local_irq_save(flags);
> +	fast_calibrate = apbt_quick_calibrate();
> +	local_irq_restore(flags);
> +
> +	if (fast_calibrate)
> +		return fast_calibrate;
> +
> +	return 0;

  	return fast_calibrate;

	might do the same with less obfuscation.

> +}

> +inline void setup_mrst_default_feature(void)
> +{
> +	/*
> +	 * x86pc default platform setup ops are setup prior to start_kernel
> +	 * we override default platform_setup calls for Moorestown
> +	 */
> +	platform_setup.resources.reserve_ebda_region = platform_setup_noop;

  See below.

> +void __init mrst_early_detect(void)
> +{
> +	int subarch_id = boot_params.hdr.hardware_subarch;
> +
> +	if ((subarch_id >= 0) && (subarch_id < N_X86_SUBARCHS)) {

  What's the purpose of this check ? Either it's X86_SUBARCH_MRST or
  not.

> +		if (subarch_id == X86_SUBARCH_MRST) {
> +			setup_mrst_default_feature();
> @@ -692,6 +692,7 @@ void __init setup_arch(char **cmdline_p)
>  #ifdef CONFIG_X86_32
>  	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
>  	visws_early_detect();
> +	mrst_early_detect();

That call is too late.

You override platform_setup.resources.reserve_ebda_region _AFTER_ it
has been called.

Thanks,

	tglx
