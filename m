Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbXFRQfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbXFRQfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXFRQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:35:24 -0400
Received: from mailhost.igel.co.jp ([219.106.231.130]:39376 "EHLO
	mailhost.igel.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbXFRQfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:35:23 -0400
X-Greylist: delayed 1235 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 12:35:23 EDT
Date: Tue, 19 Jun 2007 01:14:40 +0900 (JST)
Message-Id: <20070619.011440.260207451.matsu@igel.co.jp>
To: tglx@linutronix.de
Cc: nelsoneci@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21.4-rt11
From: Katsuya MATSUBARA <matsu@igel.co.jp>
In-Reply-To: <1182099558.8176.436.camel@chaos>
References: <1182098605.8176.422.camel@chaos>
	<2accc2ff0706170949j26c391aek7ed32e0e55d9a3d1@mail.gmail.com>
	<1182099558.8176.436.camel@chaos>
X-Mailer: Mew version 5.2 on Emacs 21.3.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 17 Jun 2007 18:59:18 +0200

> On Sun, 2007-06-17 at 11:49 -0500, Nelson Castillo wrote:
> > > > There are many choices and
> > > > I don't know what is the more friendly. By friendly I mean the one that
> > > > is likely to be merged and that cooperate with you.
> > >
> > > Which choices do you mean ?
> > 
> > I mean implementations. I've seen lot of them but i don't know which one
> > to try (I'm new to RT and the implementation in this thread seems to
> > be very nice).
> 
> Thanks :)
> 
> > > >   http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.4-rt14
> > > >
> > > > : undefined reference to `usecs_to_cycles'
> > > > make: *** [.tmp_vmlinux1] Error 1
> > >
> > > Which ARM sub arch ?
> > 
> > sub arch AT91 -- (Atmel AT91RM9200 processor).
> 
> It lacks support for the generic timeofday and clock event layers, which
> causes the compile breakage.

 I am working on Renesas SuperH platforms.
 I faced the similar compile errors
 because 2.6.21.X in SH does not support GENERIC_TIME yet.
 I made a workaround patch. Is this correct?

 Thanks,
---
 Katsuya Matsubara @ Igel Co., Ltd
 matsu@igel.co.jp
 
 diff -cr linux-2.6.21.5-rt14/kernel/hrtimer.c linux-2.6.21.5-rt14-nogt/kernel/hrtimer.c
*** linux-2.6.21.5-rt14/kernel/hrtimer.c	2007-06-18 19:55:55.000000000 +0900
--- linux-2.6.21.5-rt14-nogt/kernel/hrtimer.c	2007-06-16 16:36:10.000000000 +0900
***************
*** 119,127 ****
--- 119,131 ----
  
  	do {
  		seq = read_seqbegin(&xtime_lock);
+ #ifdef CONFIG_GENERIC_TIME
  		*ts = xtime;
  		nsecs = __get_nsec_offset();
  		timespec_add_ns(ts, nsecs);
+ #else
+ 		getnstimeofday(ts);
+ #endif
  		tomono = wall_to_monotonic;
  
  	} while (read_seqretry(&xtime_lock, seq));
diff -cr linux-2.6.21.5-rt14/kernel/time/ntp.c linux-2.6.21.5-rt14-nogt/kernel/time/ntp.c
*** linux-2.6.21.5-rt14/kernel/time/ntp.c	2007-06-18 19:55:56.000000000 +0900
--- linux-2.6.21.5-rt14-nogt/kernel/time/ntp.c	2007-06-16 16:37:46.000000000 +0900
***************
*** 120,126 ****
--- 120,128 ----
  			 */
  			time_interpolator_update(-NSEC_PER_SEC);
  			time_state = TIME_OOP;
+ #ifdef CONFIG_GENERIC_TIME
  			warp_check_clock_was_changed();
+ #endif
  			clock_was_set();
  			printk(KERN_NOTICE "Clock: inserting leap second "
  					"23:59:60 UTC\n");
***************
*** 136,142 ****
--- 138,146 ----
  			 */
  			time_interpolator_update(NSEC_PER_SEC);
  			time_state = TIME_WAIT;
+ #ifdef CONFIG_GENERIC_TIME
  			warp_check_clock_was_changed();
+ #endif
  			clock_was_set();
  			printk(KERN_NOTICE "Clock: deleting leap second "
  					"23:59:59 UTC\n");
diff -cr linux-2.6.21.5-rt14/kernel/time.c linux-2.6.21.5-rt14-nogt/kernel/time.c
*** linux-2.6.21.5-rt14/kernel/time.c	2007-06-18 19:55:56.000000000 +0900
--- linux-2.6.21.5-rt14-nogt/kernel/time.c	2007-06-16 16:36:10.000000000 +0900
***************
*** 135,141 ****
--- 135,143 ----
  	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
  	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
  	time_interpolator_reset();
+ #ifdef CONFIG_GENERIC_TIME
  	warp_check_clock_was_changed();
+ #endif
  	write_sequnlock_irq(&xtime_lock);
  	clock_was_set();
  }
***************
*** 320,326 ****
--- 322,330 ----
  		time_esterror = NTP_PHASE_LIMIT;
  		time_interpolator_reset();
  	}
+ #ifdef CONFIG_GENERIC_TIME
  	warp_check_clock_was_changed();
+ #endif
  	write_sequnlock_irq(&xtime_lock);
  	clock_was_set();
  	return 0;
diff -cr linux-2.6.21.5-rt14/kernel/timer.c linux-2.6.21.5-rt14-nogt/kernel/timer.c
*** linux-2.6.21.5-rt14/kernel/timer.c	2007-06-18 19:55:56.000000000 +0900
--- linux-2.6.21.5-rt14-nogt/kernel/timer.c	2007-06-16 16:36:10.000000000 +0900
***************
*** 1165,1171 ****
--- 1165,1173 ----
  	clock->cycle_accumulated = 0;
  	clock->error = 0;
  	timekeeping_suspended = 0;
+ #ifdef CONFIG_GENERIC_TIME
  	warp_check_clock_was_changed();
+ #endif
  	write_sequnlock_irqrestore(&xtime_lock, flags);
  
  	touch_softlockup_watchdog();
***************
*** 1728,1736 ****
--- 1730,1742 ----
  		 * too.
  		 */
  
+ #ifdef CONFIG_GENERIC_TIME
  		tp = xtime;
  		nsecs = __get_nsec_offset();
  		timespec_add_ns(&tp, nsecs);
+ #else
+ 		getnstimeofday(&tp);
+ #endif
  
  		tp.tv_sec += wall_to_monotonic.tv_sec;
  		tp.tv_nsec += wall_to_monotonic.tv_nsec;

