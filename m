Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXFZPAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXFZPAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbXFZPAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:00:22 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:48058 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbXFZPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:00:21 -0400
Date: Tue, 26 Jun 2007 17:00:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Dynamic ticks make system jerking
Message-ID: <20070626150015.GA20233@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I implemented GENERIC_TIME and GENERIC_CLOCKEVENTS for
arch-arm/mach-ns9xxx (patches available at

	http://www.modarm9.com/git?p=people/ukleinek/linux-2.6.git;a=shortlog;h=clock

or

	git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git

in the clock branch

). 

If I enable NO_HZ, the system jerks (I hope this is an understandable
term ...).   E.g. 

	# time find /sys
	...
	real    1m 19.52s
	user    0m 0.18s
	sys     0m 0.15s

on a freshly booted machine.  The output comes in several hunks with
pausing between them.  With no_hz=off, I get approx. the same.

If I have NO_HZ disabled however, I get

	# time find /sys
	...
	real    0m 1.53s
	user    0m 0.15s
	sys     0m 0.18s

Another thing is, if I press Enter once, the next prompt appears in a
reasonable time.  If I press twice in a row the 2nd prompt needs
perceptible longer.

Does someone have a hint for me how to debug (or even solve) this problem?

First I wondered why set_next_event is called twice between two timer
interrupts most of the time.  I found out that the timer is programed
for the next tick in any case and if nothing needs the next tick, the
interval is enlarged.  I didn't spend time yet to check if it is
easier/faster to only program the timer once.

Best regards
Uwe

Some addional data:

- ns9xxx_cpuclock() returns 176947200 = 0xa8c0000 for that machine.

- SYS_TR is a read-only register indicating the current timer value.

- SYS_TRC is the start value (and the reload value for auto-reloading
  timers)

- My console is an 8250 clone.

- /proc/timer_list 
	Timer List Version: v0.3
	HRTIMER_MAX_CLOCK_BASES: 2
	now at 15091350847 nsecs

	cpu: 0
	 clock 0:
	  .index:      0
	  .resolution: 1 nsecs
	  .get_time:   ktime_get_real
	  .offset:     0 nsecs
	active timers:
	 clock 1:
	  .index:      1
	  .resolution: 1 nsecs
	  .get_time:   ktime_get
	  .offset:     0 nsecs
	active timers:
	 #0: <c02e5ea0>, tick_sched_timer, S:01
	 # expires at 15100000000 nsecs [in 8649153 nsecs]
	  .expires_next   : 15100000000 nsecs
	  .hres_active    : 1
	  .nr_events      : 424
	  .nohz_mode      : 2
	  .idle_tick      : 14320000000 nsecs
	  .tick_stopped   : 0
	  .idle_jiffies   : 4294938728
	  .idle_calls     : 104
	  .idle_sleeps    : 88
	  .idle_entrytime : 15052376577 nsecs
	  .idle_sleeptime : 10627230732 nsecs
	  .last_jiffies   : 4294938801
	  .next_jiffies   : 4294938802
	  .idle_expires   : 15060000000 nsecs
	jiffies: 4294938805


	Tick Device: mode:     1
	Clock Event Device: ns9xxx-timer2
	 max_delta_ns:   2147483647
	 min_delta_ns:   1000
	 mult:           185542
	 shift:          20
	 mode:           3
	 next_event:     15100000000 nsecs
	 set_next_event: ns9xxx_clockevent_setnextevent
	 set_mode:       ns9xxx_clockevent_setmode
	 event_handler:  hrtimer_interrupt

-- 
Uwe Kleine-König

http://www.google.com/search?q=e+%5E+%28i+pi%29
