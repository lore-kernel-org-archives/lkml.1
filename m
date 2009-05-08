Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbZEHWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbZEHWA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZEHWAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:00:03 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:53370 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbZEHWAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:00:01 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 18:00:00 EDT
From: Ondrej Zary <linux@rainbow-software.org>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: TSC marked unstable on suspend and resume
Date: Fri, 8 May 2009 23:53:12 +0200
User-Agent: KMail/1.9.10
Cc: David Fries <david@fries.net>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@tglx.de>
References: <20090221023943.GA4894@spacedout.fries.net> <20090429232523.GO2862@spacedout.fries.net> <1241062653.7270.44.camel@localhost.localdomain>
In-Reply-To: <1241062653.7270.44.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905082353.15962.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009 05:37:33 john stultz wrote:
> On Wed, 2009-04-29 at 18:25 -0500, David Fries wrote:
> > On Wed, Apr 29, 2009 at 09:45:40AM -0700, john stultz wrote:
> > > On Fri, Feb 20, 2009 at 7:39 PM, David Fries <david@fries.net> wrote:
> > > > I'm getting TSC marked as unsable on hibernate to disk with
> > > > 2.6.29-rc3. ?The last kernel I ran 2.6.24.4 ran 300+ days without a
> > > > problem and does not loose TSC on hibernate.
> > > >
> > > > I'm hibernating with `echo disk > /sys/power/state`.
> > > > These look like the relavant messages,
> > > >
> > > > CPU 0 irqstacks, hard=c0379000 soft=c0378000
> > > > PID hash table entries: 1024 (order: 10, 4096 bytes)
> > > > Fast TSC calibration using PIT
> > > > Detected 300.705 MHz processor.
> > > > Calibrating delay loop (skipped), value calculated using timer
> > > > frequency.. 601.41 BogoMIPS (lpj=300705) hibernate to disk,
> > > > Restarting tasks ... done.
> > > > Clocksource tsc unstable (delta = 499883531 ns)
> > >
> > > Hmm. Seems like the clocksource watchdog is having some problem
> > > handling state around hibernate.
>
> Yea. This seems to be the case here. There's watchdog code and variables
> to handle resume properly, but there isn't a corresponding suspend hook,
> so the resume path doesn't actually change anything.
>
> Here's a patch you can try, I only had time to compile test it today, so
> its untested. Hopefully I didn't miss anything obvious.

I have the same problem and the patch does not solve it for me too.

I noticed that after resume, ping is unable to measue short time correctly:
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.000 ms

"echo tsc >/sys/devices/system/clocksource/clocksource0/current_clocksource" 
fixes the problem until next hibernation:
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.223 ms


>
> Thomas, I suspect you intended to have something like the following?
>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
>
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index 5a40d14..450431f 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -360,6 +360,7 @@ extern void clocksource_touch_watchdog(void);
>  extern struct clocksource* clocksource_get_next(void);
>  extern void clocksource_change_rating(struct clocksource *cs, int rating);
>  extern void clocksource_resume(void);
> +extern void clocksource_suspend(void);
>
>  #ifdef CONFIG_GENERIC_TIME_VSYSCALL
>  extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index ecfd7b5..3dbe55f 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -236,6 +236,11 @@ static void clocksource_resume_watchdog(void)
>  	set_bit(0, &watchdog_resumed);
>  }
>
> +static void clocksource_suspend_watchdog(void)
> +{
> +	set_bit(1, &watchdog_resumed);
> +}
> +
>  static void clocksource_check_watchdog(struct clocksource *cs)
>  {
>  	struct clocksource *cse;
> @@ -278,6 +283,7 @@ static void clocksource_check_watchdog(struct
> clocksource *cs) }
>  	spin_unlock_irqrestore(&watchdog_lock, flags);
>  }
> +
>  #else
>  static void clocksource_check_watchdog(struct clocksource *cs)
>  {
> @@ -286,6 +292,7 @@ static void clocksource_check_watchdog(struct
> clocksource *cs) }
>
>  static inline void clocksource_resume_watchdog(void) { }
> +static inline void clocksource_suspend_watchdog(void) { }
>  #endif
>
>  /**
> @@ -321,6 +328,18 @@ void clocksource_touch_watchdog(void)
>  }
>
>  /**
> + * clocksource_suspend - suspend the clocksource(s)
> + */
> +void clocksource_suspend(void)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&clocksource_lock, flags);
> +	clocksource_suspend_watchdog();
> +	spin_unlock_irqrestore(&clocksource_lock, flags);
> +}
> +
> +/**
>   * clocksource_get_next - Returns the selected clocksource
>   *
>   */
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 687dff4..e39e3d3 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -368,6 +368,7 @@ static int timekeeping_suspend(struct sys_device *dev,
> pm_message_t state)
>
>  	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
>
> +	clocksource_suspend();
>  	return 0;
>  }
>

-- 
Ondrej Zary
