Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZKVINi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZKVINi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZKVINh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:13:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZKVINg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:13:36 -0500
Date: Sun, 22 Nov 2009 09:13:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>, Michal Simek <monstr@monstr.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: Add a high resolution sched_clock() via
 cnt32_to_63().
Message-ID: <20091122081328.GB24558@elte.hu>
References: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Zhangjin <wuzhangjin@gmail.com> wrote:

> +config HR_SCHED_CLOCK
> +	bool "High Resolution sched_clock()"
> +	depends on CSRC_R4K
> +	default n
> +	help
> +	  This option enables the MIPS c0 count based high resolution
> +	  sched_clock().
> +
> +	  If you need a ns precision timestamp, You are recommended to enable
> +	  this option. For example, If you are using the Ftrace subsystem to do
> +	  real time tracing, this option is needed.

s/You/you

> +
> +	  If unsure, disable it.
> +
> +config HR_SCHED_CLOCK_UPDATE
> +	bool "Update sched_clock() automatically"
> +	depends on HR_SCHED_CLOCK
> +	default y
> +	help
> +	  Because Some of the MIPS c0 count period is quite short and because
> +	  cnt32_to_63() needs to be called at least once per half period to
> +	  work properly, a kernel timer is needed to set up to ensure this
> +	  requirement is always met.

s/Some/some

Why is this a config option? I suspect that hardware that _needs_ this 
keep-warm periodic tick we should enable it unconditionally and 
automatically - otherwise the user can misconfigure the kernel with a 
bad clock.


> +
> +	  If unusre, enable it.

s/unusre/unsure

> +
> +#
>  # Timer Interrupt Frequency Configuration
>  #
>  
> diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
> index e95a3cd..4e52cca 100644
> --- a/arch/mips/kernel/csrc-r4k.c
> +++ b/arch/mips/kernel/csrc-r4k.c
> @@ -6,10 +6,64 @@
>   * Copyright (C) 2007 by Ralf Baechle
>   */
>  #include <linux/clocksource.h>
> +#include <linux/cnt32_to_63.h>
> +#include <linux/timer.h>
>  #include <linux/init.h>
>  
>  #include <asm/time.h>
>  
> +/*
> + * MIPS' sched_clock implementation.

s/MIPS'/MIPS's

or

s/MIPS'/MIPS

> + *
> + * because cnt32_to_63() needs to be called at least once per half period to
> + * work properly, and some of the MIPS' frequency is very low, perhaps a kernel
> + * timer is needed to be set up to ensure this requirement is always met.
> + * please refer to  arch/arm/plat-orion/time.c and include/linux/cnt32_to_63.h

s/please/Please

> + */
> +static unsigned long __maybe_unused tclk2ns_scale;
> +static unsigned long __maybe_unused tclk2ns_scale_factor;


__read_mostly?

> +
> +#ifdef CONFIG_HR_SCHED_CLOCK
> +unsigned long long notrace sched_clock(void)
> +{
> +	unsigned long long v = cnt32_to_63(read_c0_count());
> +	return (v * tclk2ns_scale) >> tclk2ns_scale_factor;
> +}
> +#endif
> +
> +static void __init __maybe_unused setup_sched_clock(struct clocksource *cs)
> +{
> +	unsigned long long v;
> +
> +	v = cs->mult;
> +	/*
> +	 * We want an even value to automatically clear the top bit
> +	 * returned by cnt32_to_63() without an additional run time
> +	 * instruction. So if the LSB is 1 then round it up.
> +	 */
> +	if (v & 1)
> +		v++;
>
> +	tclk2ns_scale = v;
> +	tclk2ns_scale_factor = cs->shift;
> +}
> +
> +static struct timer_list __maybe_unused cnt32_to_63_keepwarm_timer;
> +
> +static void __maybe_unused cnt32_to_63_keepwarm(unsigned long data)
> +{
> +	mod_timer(&cnt32_to_63_keepwarm_timer, round_jiffies(jiffies + data));
> +	(void) sched_clock();
>
> +}
> +
> +static void __maybe_unused setup_sched_clock_update(unsigned long tclk)
> +{
> +	unsigned long data;
> +
> +	data = (0xffffffffUL / tclk / 2 - 2) * HZ;
> +	setup_timer(&cnt32_to_63_keepwarm_timer, cnt32_to_63_keepwarm, data);
> +	mod_timer(&cnt32_to_63_keepwarm_timer, round_jiffies(jiffies + data));
> +}
> +
>  static cycle_t c0_hpt_read(struct clocksource *cs)
>  {
>  	return read_c0_count();
> @@ -32,7 +86,13 @@ int __init init_r4k_clocksource(void)
>  
>  	clocksource_set_clock(&clocksource_mips, mips_hpt_frequency);
>  
> +#ifdef CONFIG_HR_SCHED_CLOCK
> +	setup_sched_clock(&clocksource_mips);
> +#endif
>  	clocksource_register(&clocksource_mips);
>  
> +#ifdef CONFIG_HR_SCHED_CLOCK_UPDATE
> +	setup_sched_clock_update(mips_hpt_frequency);
> +#endif
>  	return 0;

You could make the functions inline and move the #ifdef into those 
functions.

That wold also remove those __maybe_unused tags.

Thanks,

	Ingo
