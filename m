Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbXFTPBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbXFTPBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbXFTPA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:00:57 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14950 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbXFTPAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:00:55 -0400
Subject: Re: [RFC] clocksouce implementation for powerpc
From: Daniel Walker <dwalker@mvista.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <20070620065710.GR9768@bakeyournoodle.com>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
	 <20070616101637.107940593@inhelltoy.tec.linutronix.de>
	 <1182009083.11539.369.camel@imap.mvista.com>
	 <20070620065710.GR9768@bakeyournoodle.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 07:57:19 -0700
Message-Id: <1182351439.18168.79.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 16:57 +1000, Tony Breeds wrote:
> On Sat, Jun 16, 2007 at 08:51:23AM -0700, Daniel Walker wrote:
> > On Sat, 2007-06-16 at 10:36 +0000, Thomas Gleixner wrote:
> > > plain text document attachment
> > > (clocksource-add-settimeofday-hook.patch)
> > > From: Tony Breeds <tony@bakeyournoodle.com >
> > > 
> > > I'm working on a clocksource implementation for all powerpc platforms.
> > > some of these platforms needs to do a little work as part of the
> > > settimeofday() syscall and I can't see a way to do that without adding
> > > this hook to clocksource.
> > > 
> > 
> > 
> > I'd like to see how this is used? If the code that uses this API change
> > isn't ready yet, then this patch should really wait..
> 
> This is my current patch to rework arch/powerpc/kernel/time.c to create
> a clocksource.  It's not ready for inclusion.
> 
> powerpc needs to keep the vdso in sync whenener settimeodfay() is
> called.  Adding the hook the to the clocksource structure was my way of
> allowing this to happen.  There are other approaches, but this seemed to
> best allow for runtime.  Initially I considered using update_vsyscall()
> but this is called from do_timer(), and I don't need this code run then
> :(

As I said in our private thread, I do think you should be using
update_vsyscall() .. update_vsyscall() is just called when the time is
set, usually that happens in the timer interrupt and sometimes that
happens in settimeofday() ..

> This has been booted on pSeries and iSeries (I'm using glibc 2.5, which
> uses the vdso gettimeoday())
> 
> All comments appreiated.

At least some of your code is duplications over what is already being
worked on inside the powerpc community.. For instance, I know there is
already a timebase clocksource,

http://people.redhat.com/~mingo/realtime-preempt/patch-2.6.21.5-rt17


> Index: working/arch/powerpc/Kconfig
> ===================================================================
> --- working.orig/arch/powerpc/Kconfig
> +++ working/arch/powerpc/Kconfig
> @@ -31,6 +31,12 @@ config MMU
>  	bool
>  	default y
>  
> +config GENERIC_TIME
> +	def_bool y
> +
> +config GENERIC_TIME_VSYSCALL
> +	def_bool y
> +
>  config GENERIC_HARDIRQS
>  	bool
>  	default y
> Index: working/arch/powerpc/kernel/time.c
> ===================================================================
> --- working.orig/arch/powerpc/kernel/time.c
> +++ working/arch/powerpc/kernel/time.c
> @@ -74,6 +74,30 @@
>  #endif
>  #include <asm/smp.h>
>  
> +/* powerpc clocksource/clockevent code */
> +
> +/* TODO:
> + *  o Code style
> + *    * Variable names ... be consistent.
> + *
> + * TODO: Clocksource
> + *  o Need a _USE_RTC() clocksource impelementation
> + *  o xtime:  Either time.c manages it, or clocksource does, not both
> + */
> +
> +#include <linux/clocksource.h>
> +
> +static struct clocksource clocksource_timebase = {
> +	.name         = "timebase",
> +	.rating       = 200,
> +	.flags        = CLOCK_SOURCE_IS_CONTINUOUS,
> +	.mask         = CLOCKSOURCE_MASK(64),
> +	.shift        = 22,
> +	.mult         = 0,	/* To be filled in */
> +	.read         = NULL,   /* To be filled in */
> +	.settimeofday = NULL,   /* To be filled in */
> +};
> +
>  /* keep track of when we need to update the rtc */
>  time_t last_rtc_update;
>  #ifdef CONFIG_PPC_ISERIES
> @@ -376,65 +400,6 @@ static __inline__ void timer_check_rtc(v
>          }
>  }
>  
> -/*
> - * This version of gettimeofday has microsecond resolution.
> - */
> -static inline void __do_gettimeofday(struct timeval *tv)
> -{
> -	unsigned long sec, usec;
> -	u64 tb_ticks, xsec;
> -	struct gettimeofday_vars *temp_varp;
> -	u64 temp_tb_to_xs, temp_stamp_xsec;
> -
> -	/*
> -	 * These calculations are faster (gets rid of divides)
> -	 * if done in units of 1/2^20 rather than microseconds.
> -	 * The conversion to microseconds at the end is done
> -	 * without a divide (and in fact, without a multiply)
> -	 */
> -	temp_varp = do_gtod.varp;
> -
> -	/* Sampling the time base must be done after loading
> -	 * do_gtod.varp in order to avoid racing with update_gtod.
> -	 */
> -	data_barrier(temp_varp);
> -	tb_ticks = get_tb() - temp_varp->tb_orig_stamp;
> -	temp_tb_to_xs = temp_varp->tb_to_xs;
> -	temp_stamp_xsec = temp_varp->stamp_xsec;
> -	xsec = temp_stamp_xsec + mulhdu(tb_ticks, temp_tb_to_xs);
> -	sec = xsec / XSEC_PER_SEC;
> -	usec = (unsigned long)xsec & (XSEC_PER_SEC - 1);
> -	usec = SCALE_XSEC(usec, 1000000);
> -
> -	tv->tv_sec = sec;
> -	tv->tv_usec = usec;
> -}
> -
> -void do_gettimeofday(struct timeval *tv)
> -{
> -	if (__USE_RTC()) {
> -		/* do this the old way */
> -		unsigned long flags, seq;
> -		unsigned int sec, nsec, usec;
> -
> -		do {
> -			seq = read_seqbegin_irqsave(&xtime_lock, flags);
> -			sec = xtime.tv_sec;
> -			nsec = xtime.tv_nsec + tb_ticks_since(tb_last_jiffy);
> -		} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
> -		usec = nsec / 1000;
> -		while (usec >= 1000000) {
> -			usec -= 1000000;
> -			++sec;
> -		}
> -		tv->tv_sec = sec;
> -		tv->tv_usec = usec;
> -		return;
> -	}
> -	__do_gettimeofday(tv);
> -}
> -
> -EXPORT_SYMBOL(do_gettimeofday);
>  
>  /*
>   * There are two copies of tb_to_xs and stamp_xsec so that no
> @@ -666,8 +631,8 @@ void timer_interrupt(struct pt_regs * re
>  		if (per_cpu(last_jiffy, cpu) >= tb_next_jiffy) {
>  			tb_last_jiffy = tb_next_jiffy;
>  			do_timer(1);
> -			timer_recalc_offset(tb_last_jiffy);
> -			timer_check_rtc();
> +			/* timer_recalc_offset() && timer_check_rtc()
> +			 * are now called from update_vsyscall() */
>  		}
>  		write_sequnlock(&xtime_lock);
>  	}
> @@ -739,77 +704,6 @@ unsigned long long sched_clock(void)
>  	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
>  }
>  
> -int do_settimeofday(struct timespec *tv)
> -{
> -	time_t wtm_sec, new_sec = tv->tv_sec;
> -	long wtm_nsec, new_nsec = tv->tv_nsec;
> -	unsigned long flags;
> -	u64 new_xsec;
> -	unsigned long tb_delta;
> -
> -	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
> -		return -EINVAL;
> -
> -	write_seqlock_irqsave(&xtime_lock, flags);
> -
> -	/*
> -	 * Updating the RTC is not the job of this code. If the time is
> -	 * stepped under NTP, the RTC will be updated after STA_UNSYNC
> -	 * is cleared.  Tools like clock/hwclock either copy the RTC
> -	 * to the system time, in which case there is no point in writing
> -	 * to the RTC again, or write to the RTC but then they don't call
> -	 * settimeofday to perform this operation.
> -	 */
> -#ifdef CONFIG_PPC_ISERIES
> -	if (firmware_has_feature(FW_FEATURE_ISERIES) && first_settimeofday) {
> -		iSeries_tb_recal();
> -		first_settimeofday = 0;
> -	}
> -#endif
> -
> -	/* Make userspace gettimeofday spin until we're done. */
> -	++vdso_data->tb_update_count;
> -	smp_mb();
> -
> -	/*
> -	 * Subtract off the number of nanoseconds since the
> -	 * beginning of the last tick.
> -	 */
> -	tb_delta = tb_ticks_since(tb_last_jiffy);
> -	tb_delta = mulhdu(tb_delta, do_gtod.varp->tb_to_xs); /* in xsec */
> -	new_nsec -= SCALE_XSEC(tb_delta, 1000000000);
> -
> -	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - new_sec);
> -	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - new_nsec);
> -
> - 	set_normalized_timespec(&xtime, new_sec, new_nsec);
> -	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
> -
> -	/* In case of a large backwards jump in time with NTP, we want the 
> -	 * clock to be updated as soon as the PLL is again in lock.
> -	 */
> -	last_rtc_update = new_sec - 658;
> -
> -	ntp_clear();
> -
> -	new_xsec = xtime.tv_nsec;
> -	if (new_xsec != 0) {
> -		new_xsec *= XSEC_PER_SEC;
> -		do_div(new_xsec, NSEC_PER_SEC);
> -	}
> -	new_xsec += (u64)xtime.tv_sec * XSEC_PER_SEC;
> -	update_gtod(tb_last_jiffy, new_xsec, do_gtod.varp->tb_to_xs);
> -
> -	vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
> -	vdso_data->tz_dsttime = sys_tz.tz_dsttime;
> -
> -	write_sequnlock_irqrestore(&xtime_lock, flags);
> -	clock_was_set();
> -	return 0;
> -}
> -
> -EXPORT_SYMBOL(do_settimeofday);
> -
>  static int __init get_freq(char *name, int cells, unsigned long *val)
>  {
>  	struct device_node *cpu;
> @@ -878,6 +772,78 @@ unsigned long get_boot_time(void)
>  		      tm.tm_hour, tm.tm_min, tm.tm_sec);
>  }
>  
> +/* clocksource code */
> +static cycle_t timebase_read(void)
> +{
> +	return (cycle_t)get_tb();
> +}
> +
> +static void clocksource_settimeofday(struct clocksource *cs,
> +                                     struct timespec *ts)
> +{
> +	u64 new_xsec;
> +
> +#ifdef CONFIG_PPC_ISERIES
> +	if (firmware_has_feature(FW_FEATURE_ISERIES) && first_settimeofday) {
> +		iSeries_tb_recal();
> +		first_settimeofday = 0;
> +	}
> +#endif
> +
> +	/* Make userspace gettimeofday spin until we're done. */
> +	++vdso_data->tb_update_count;
> +	smp_mb();
> +
> +	/* In case of a large backwards jump in time with NTP, we want the
> +	 * clock to be updated as soon as the PLL is again in lock.
> +	 */
> +	last_rtc_update = xtime.tv_sec - 658;
> +
> +	new_xsec = xtime.tv_nsec;
> +	if (new_xsec != 0) {
> +		new_xsec *= XSEC_PER_SEC;
> +		do_div(new_xsec, NSEC_PER_SEC);
> +	}
> +
> +	new_xsec += (u64)xtime.tv_sec * XSEC_PER_SEC;
> +
> +	vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
> +	vdso_data->tz_dsttime = sys_tz.tz_dsttime;
> +
> +	update_gtod(tb_last_jiffy, new_xsec, do_gtod.varp->tb_to_xs);
> +}

It does look too large to run from interrupt context, but it also looks
like it could get cleaned out more ..

> +void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
> +{
> +	timer_recalc_offset(tb_last_jiffy);
> +	timer_check_rtc();
> +}

Hmm .. This doesn't look like it's taking into account that the time has
changed .. Your time has effectively incremented by one jiffie .. The
vdso_data doesn't appear to be updated ..

> +void __init clocksource_init(void)
> +{
> +	int mult;
> +
> +	if (__USE_RTC())
> +		return;
> +
> +	mult = clocksource_hz2mult(tb_ticks_per_sec,
> +	                           clocksource_timebase.shift);
> +	clocksource_timebase.mult = mult;
> +
> +	clocksource_timebase.read = timebase_read;
> +	clocksource_timebase.settimeofday = clocksource_settimeofday;
> +
> +	if (clocksource_register(&clocksource_timebase)) {
> +		printk(KERN_ERR "clocksource: %s is already registered\n",
> +		       clocksource_timebase.name);
> +		return;
> +	}
> +
> +	printk(KERN_INFO "clocksource: %s mult[%x] shift[%d] registered\n",
> +	       clocksource_timebase.name,
> +	       clocksource_timebase.mult, clocksource_timebase.shift);
> +}
> +
>  /* This function is only called on the boot processor */
>  void __init time_init(void)
>  {
> @@ -999,6 +965,9 @@ void __init time_init(void)
>  	                        -xtime.tv_sec, -xtime.tv_nsec);
>  	write_sequnlock_irqrestore(&xtime_lock, flags);
>  
> +	/* Register the clocksource */
> +	clocksource_init();
> +
>  	/* Not exact, but the timer interrupt takes care of this */
>  	set_dec(tb_ticks_per_jiffy);
>  }
> Yours Tony
> 
>   linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
>   Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
> 

