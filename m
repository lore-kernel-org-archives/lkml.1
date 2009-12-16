Return-Path: <linux-kernel-owner+w=401wt.eu-S935037AbZLPQfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935037AbZLPQfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbZLPQfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:35:50 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:63779 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022AbZLPQft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:35:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAHubKEuuWOl3/2dsb2JhbACBS9UkhCsEgWOEAA
Date: Wed, 16 Dec 2009 11:35:22 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ltt-dev] [RELEASE] LTTng 0.181 for Linux kernel 2.6.32
Message-ID: <20091216163522.GB12113@Krystal>
References: <20091204160633.GA29864@Krystal> <20091213194210.GA3149@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091213194210.GA3149@nokia.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:31:41 up 50 min,  4 users,  load average: 0.04, 0.10, 0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi (felipe.balbi@nokia.com) wrote:
> Hi,
>
> On Fri, Dec 04, 2009 at 05:06:33PM +0100, ext Mathieu Desnoyers wrote:
>> I just released LTTng 0.181 for Linux kernel 2.6.32. All packages and
>> links to the git tree can be found at:
>>
>> http://www.lttng.org
>>
>> Comment and feedback are always welcome.
>
> with the two attached patches, omap tree should be fine.
>

Hi Felipe,

I am currently working in the linux-2.6-omap pm tree to support power
management and DVFS for the omap3. Given the changes I made in the omap
tree, I think it's best if I merge the parts that fit back into the
lttng tree based on mainline rather than merging your patches.

I agree with your suggestion to move the header to
arch/arm/mach-omap2/include/mach/trace-clock.h

> I changed the extern clocksource pointer to clocksource_default_clock()
> hope that's correct.

Hrm, I really need this one to be the 32k clock. I am making sure LTTng
depends on this clock being available on the omap3. I use the low-level
value and expect it to run at 32768 HZ. I also need it to stay active
when the system is in standby mode.

Thanks,

Mathieu

>
> -- 
> balbi

> arm: omap: lttng: fix build breakage
> 
> Fix compilation with lttng patches applied on omap.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> Index: linux-omap-2.6/arch/arm/mach-omap2/trace-clock.c
> ===================================================================
> --- linux-omap-2.6.orig/arch/arm/mach-omap2/trace-clock.c	2009-12-13 21:22:09.554137130 +0200
> +++ linux-omap-2.6/arch/arm/mach-omap2/trace-clock.c	2009-12-13 21:31:59.482441303 +0200
> @@ -12,12 +12,9 @@
>  #include <linux/timer.h>
>  #include <linux/spinlock.h>
>  #include <linux/init.h>
> -#include <mach/dmtimer.h>
> +#include <plat/dmtimer.h>
>  #include <mach/trace-clock.h>
>  
> -/* Need direct access to the clock from kernel/time/timekeeping.c */
> -extern struct clocksource *clock;
> -
>  /* 32KHz counter count save upon PM sleep */
>  static u32 saved_32k_count;
>  static u64 saved_trace_clock;
> @@ -124,6 +121,7 @@
>  
>  void _start_trace_clock(void)
>  {
> +	struct clocksource *clock = clocksource_default_clock();
>  	unsigned long flags;
>  	unsigned int count_32k, count_trace_clock;
>  	u32 regval;
> @@ -149,7 +147,7 @@
>  	 */
>  	ref_time = saved_trace_clock;
>  	local_irq_save(flags);
> -	count_32k = clocksource_read(clock);
> +	count_32k = clock->read(clock);
>  	prev_time = trace_clock_read64();
>  	/*
>  	 * Delta done on 32-bits, then casted to u64. Must guarantee
> @@ -190,7 +188,9 @@
>  
>  void _stop_trace_clock(void)
>  {
> -	saved_32k_count = clocksource_read(clock);
> +	struct clocksource *clock = clocksource_default_clock();
> +
> +	saved_32k_count = clock->read(clock);
>  	saved_trace_clock = trace_clock_read64();
>  	del_timer_sync(&clear_ccnt_ms_timer);
>  	put_synthetic_tsc();
> Index: linux-omap-2.6/arch/arm/plat-omap/include/mach/trace-clock.h
> ===================================================================
> --- linux-omap-2.6.orig/arch/arm/plat-omap/include/mach/trace-clock.h	2009-12-13 21:22:16.818137314 +0200
> +++ linux-omap-2.6/arch/arm/plat-omap/include/mach/trace-clock.h	2009-12-13 21:36:09.926137740 +0200
> @@ -9,7 +9,7 @@
>  
>  #include <linux/clk.h>
>  #include <asm/system.h>
> -#include <mach/dmtimer.h>
> +#include <plat/dmtimer.h>
>  
>  /*
>   * Number of hardware clock bits. The higher order bits are expected to be 0.

> arm: omap: lttng: move to mach-omap2/include/mach
> 
> Move the file to expected location
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> Index: linux-omap-2.6/arch/arm/plat-omap/include/mach/trace-clock.h
> ===================================================================
> --- linux-omap-2.6.orig/arch/arm/plat-omap/include/mach/trace-clock.h	2009-12-13 21:38:57.794137510 +0200
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,96 +0,0 @@
> -/*
> - * Copyright (C) 2009 Mathieu Desnoyers
> - *
> - * Trace clock ARM OMAP3 definitions.
> - */
> -
> -#ifndef _ASM_ARM_TRACE_CLOCK_OMAP3_H
> -#define _ASM_ARM_TRACE_CLOCK_OMAP3_H
> -
> -#include <linux/clk.h>
> -#include <asm/system.h>
> -#include <plat/dmtimer.h>
> -
> -/*
> - * Number of hardware clock bits. The higher order bits are expected to be 0.
> - * If the hardware clock source has more than 32 bits, the bits higher than the
> - * 32nd will be truncated by a cast to a 32 bits unsigned. Range : 1 - 32.
> - * (too few bits would be unrealistic though, since we depend on the timer to
> - * detect the overflows).
> - * OMAP3-specific : we clear bit 31 periodically so it never overflows. There is
> - * a hardware bug with CP14 and CP15 being executed at the same time a ccnt overflow
> - * occurs.
> - *
> - * Siarhei Siamashka <siarhei.siamashka@nokia.com> :
> - * Performance monitoring unit breaks if somebody is accessing CP14/CP15
> - * coprocessor register exactly at the same time as CCNT overflows (regardless
> - * of the fact if generation of interrupts is enabled or not). A workaround
> - * suggested by ARM was to never allow it to overflow and reset it
> - * periodically.
> - */
> -#define TC_HW_BITS			31
> -
> -/* Expected maximum interrupt latency in ms : 15ms, *2 for security */
> -#define TC_EXPECTED_INTERRUPT_LATENCY	30
> -
> -extern u64 trace_clock_read_synthetic_tsc(void);
> -extern void _trace_clock_write_synthetic_tsc(u64 value);
> -extern struct omap_dm_timer *trace_clock_timer;
> -extern unsigned long long cpu_hz;
> -
> -/*
> - * ARM OMAP3 timers only return 32-bits values. We ened to extend it to a
> - * 64-bit value, which is provided by trace-clock-32-to-64.
> - */
> -extern u64 trace_clock_async_tsc_read(void);
> -/*
> - * Update done by the architecture upon wakeup.
> - */
> -extern void _trace_clock_write_synthetic_tsc(u64 value);
> -
> -static inline u32 read_ccnt(void)
> -{
> -	u32 val;
> -        __asm__ __volatile__ ("mrc p15, 0, %0, c9, c13, 0" : "=r" (val));
> -	return val & ~(1 << TC_HW_BITS);
> -}
> -
> -static inline u32 trace_clock_read32(void)
> -{
> -	u32 val;
> -
> -	isb();
> -	val = read_ccnt();
> -	isb();
> -	return val;
> -}
> -
> -static inline u64 trace_clock_read64(void)
> -{
> -	return trace_clock_read_synthetic_tsc();
> -}
> -
> -static inline u64 trace_clock_frequency(void)
> -{
> -	return cpu_hz;
> -}
> -
> -static inline u32 trace_clock_freq_scale(void)
> -{
> -	return 1;
> -}
> -
> -extern void get_trace_clock(void);
> -extern void put_trace_clock(void);
> -extern void get_synthetic_tsc(void);
> -extern void put_synthetic_tsc(void);
> -
> -/* Used by the architecture upon wakeup from PM idle */
> -extern void start_trace_clock(void);
> -/* Used by the architecture when going to PM idle */
> -extern void stop_trace_clock(void);
> -
> -static inline void set_trace_clock_is_sync(int state)
> -{
> -}
> -#endif /* _ASM_MIPS_TRACE_CLOCK_OMAP3_H */
> Index: linux-omap-2.6/arch/arm/mach-omap2/include/mach/trace-clock.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-omap-2.6/arch/arm/mach-omap2/include/mach/trace-clock.h	2009-12-13 21:22:23.394136616 +0200
> @@ -0,0 +1,96 @@
> +/*
> + * Copyright (C) 2009 Mathieu Desnoyers
> + *
> + * Trace clock ARM OMAP3 definitions.
> + */
> +
> +#ifndef _ASM_ARM_TRACE_CLOCK_OMAP3_H
> +#define _ASM_ARM_TRACE_CLOCK_OMAP3_H
> +
> +#include <linux/clk.h>
> +#include <asm/system.h>
> +#include <plat/dmtimer.h>
> +
> +/*
> + * Number of hardware clock bits. The higher order bits are expected to be 0.
> + * If the hardware clock source has more than 32 bits, the bits higher than the
> + * 32nd will be truncated by a cast to a 32 bits unsigned. Range : 1 - 32.
> + * (too few bits would be unrealistic though, since we depend on the timer to
> + * detect the overflows).
> + * OMAP3-specific : we clear bit 31 periodically so it never overflows. There is
> + * a hardware bug with CP14 and CP15 being executed at the same time a ccnt overflow
> + * occurs.
> + *
> + * Siarhei Siamashka <siarhei.siamashka@nokia.com> :
> + * Performance monitoring unit breaks if somebody is accessing CP14/CP15
> + * coprocessor register exactly at the same time as CCNT overflows (regardless
> + * of the fact if generation of interrupts is enabled or not). A workaround
> + * suggested by ARM was to never allow it to overflow and reset it
> + * periodically.
> + */
> +#define TC_HW_BITS			31
> +
> +/* Expected maximum interrupt latency in ms : 15ms, *2 for security */
> +#define TC_EXPECTED_INTERRUPT_LATENCY	30
> +
> +extern u64 trace_clock_read_synthetic_tsc(void);
> +extern void _trace_clock_write_synthetic_tsc(u64 value);
> +extern struct omap_dm_timer *trace_clock_timer;
> +extern unsigned long long cpu_hz;
> +
> +/*
> + * ARM OMAP3 timers only return 32-bits values. We ened to extend it to a
> + * 64-bit value, which is provided by trace-clock-32-to-64.
> + */
> +extern u64 trace_clock_async_tsc_read(void);
> +/*
> + * Update done by the architecture upon wakeup.
> + */
> +extern void _trace_clock_write_synthetic_tsc(u64 value);
> +
> +static inline u32 read_ccnt(void)
> +{
> +	u32 val;
> +        __asm__ __volatile__ ("mrc p15, 0, %0, c9, c13, 0" : "=r" (val));
> +	return val & ~(1 << TC_HW_BITS);
> +}
> +
> +static inline u32 trace_clock_read32(void)
> +{
> +	u32 val;
> +
> +	isb();
> +	val = read_ccnt();
> +	isb();
> +	return val;
> +}
> +
> +static inline u64 trace_clock_read64(void)
> +{
> +	return trace_clock_read_synthetic_tsc();
> +}
> +
> +static inline u64 trace_clock_frequency(void)
> +{
> +	return cpu_hz;
> +}
> +
> +static inline u32 trace_clock_freq_scale(void)
> +{
> +	return 1;
> +}
> +
> +extern void get_trace_clock(void);
> +extern void put_trace_clock(void);
> +extern void get_synthetic_tsc(void);
> +extern void put_synthetic_tsc(void);
> +
> +/* Used by the architecture upon wakeup from PM idle */
> +extern void start_trace_clock(void);
> +/* Used by the architecture when going to PM idle */
> +extern void stop_trace_clock(void);
> +
> +static inline void set_trace_clock_is_sync(int state)
> +{
> +}
> +#endif /* _ASM_MIPS_TRACE_CLOCK_OMAP3_H */

> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
