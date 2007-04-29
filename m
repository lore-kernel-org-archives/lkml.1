Return-Path: <linux-kernel-owner+w=401wt.eu-S1161506AbXD2WyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161506AbXD2WyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161521AbXD2WyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:54:22 -0400
Received: from neon.samage.net ([85.17.153.66]:44720 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161506AbXD2WyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:54:21 -0400
Message-ID: <1898.81.207.0.53.1177887257.squirrel@secure.samage.net>
In-Reply-To: <1177874733.5791.137.camel@localhost.localdomain>
References: <4655.81.207.0.53.1177863612.squirrel@secure.samage.net>
    <1177874733.5791.137.camel@localhost.localdomain>
Date: Mon, 30 Apr 2007 00:54:17 +0200 (CEST)
Subject: Re: [2.6.21] BUG: clocksource_watchdog isn't reset after resume
From: "Indan Zupancic" <indan@nul.nu>
To: tglx@linutronix.de
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: bbdeaaa4d227adae8d620e69c05793d6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, April 29, 2007 21:25, Thomas Gleixner wrote:
> On Sun, 2007-04-29 at 18:20 +0200, Indan Zupancic wrote:
>> Hello,
>>
>> After s2ram, basically the following happens, which shouldn't happen:
>>
>> [    0.880234] Clocksource tsc unstable (delta = 449782067799 ns)
>> [    0.881221] Time: pit clocksource has been installed.
>>
>> Looking at the source, it seems that clocksource_watchdog isn't reset
>> after resume, while the clock source used is, and hence it thinks that
>> the clock is unstable.
>
> Yup, missed that. I was looking into the resume path anyway for other
> reasons. Does the patch below fix your problem ?

Yes it does, thanks!

Just wondering, but is it expected that tsc doesn't show up in
/proc/timer_list? Output below:

$ cat /proc/timer_list
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 557820361144 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 999848 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .index:      1
  .resolution: 999848 nsecs
  .get_time:   ktime_get
active timers:
 #0: <b6e12f10>, it_real_fn, S:01
 # expires at 557838167583 nsecs [in 17806439 nsecs]
 #1: <b6e12f10>, it_real_fn, S:01
 # expires at 577078756293 nsecs [in 19258395149 nsecs]
 #2: <b6e12f10>, hrtimer_wakeup, S:01
 # expires at 607716759262 nsecs [in 49896398118 nsecs]
 #3: <b6e12f10>, it_real_fn, S:01
 # expires at 3656633914145 nsecs [in 3098813553001 nsecs]


Tick Device: mode:     0
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           4
 next_event:     0 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  clockevents_handle_noop
tick_broadcast_mask: 00000000


Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   674685450
 min_delta_ns:   1206
 mult:           53400874
 shift:          32
 mode:           2
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic

Greetings,

Indan


