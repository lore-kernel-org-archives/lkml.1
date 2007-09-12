Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbXILJRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbXILJRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 05:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXILJRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 05:17:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbXILJR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 05:17:29 -0400
Date: Wed, 12 Sep 2007 02:16:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070912021627.5b85a75f.akpm@linux-foundation.org>
In-Reply-To: <1189547387.5235.69.camel@chaos>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<200709111323.56030.rjw@sisk.pl>
	<20070911042228.1ef690e0.akpm@linux-foundation.org>
	<200709111409.13796.rjw@sisk.pl>
	<20070911112531.80bac380.akpm@linux-foundation.org>
	<1189535883.5235.13.camel@chaos>
	<20070911114417.3f6e9e1b.akpm@linux-foundation.org>
	<1189540321.5235.21.camel@chaos>
	<1189547387.5235.69.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 23:49:47 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 2007-09-11 at 21:52 +0200, Thomas Gleixner wrote:
> > >     C1:                  type[C1] promotion[C2] demotion[--] latency[001] usage[00000010] duration[00000000000000000000]
> > >    *C2:                  type[C2] promotion[--] demotion[C1] latency[001] usage[00008316] duration[00000000000170717293]
> > 
> > Ok, here we are. The bad one uses C2 which stops the local apic on the
> > VAIO. I suspect we end up in the suspend/resume with going into C2
> > without the broadcast active.
> > 
> > Can you try to get the output of SysRq-Q during the "it needs help from
> > keyboard" period ?
> 
> Summary of the oddities we are seing:
> 
> 1.) disabling local apic timer makes the problem go away
> 2.) disabling nohz and highres makes the problem go away
> 3.) adding the cpuidle patches from the acpi tree makes the problem go
> away

Only the fist cpuidle patch, actually.  I'd have though this was a big hint?

> The obvious conclusion is, that in all other cases we run into a state,
> where the local apic timer is not working.
> 
> 1) we do not use it
> 2) it is used in periodic mode
> 3) the cpu does not enter C2 (which turns the lapic timer off on the
> VAIO)
> 
> While 1) and 3) are understandable, the reason why 2) is working is a
> mystery because the periodic mode is affected by the C state as well.
> 
> Andrew, can you please provide the output of /proc/timer_list when you
> boot the kernel with "nohz=off highres=off", but honestly I do not
> expect a lot of enlightenment from it.

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 91231842576 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 4000250 nsecs
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 4000250 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f67d5eb0>, hrtimer_wakeup, S:01, do_nanosleep, cpuspeed/1685
 # expires at 91415336182 nsecs [in 183493606 nsecs]
 #1: <f67d5eb0>, it_real_fn, S:01, do_setitimer, ntpd/2182
 # expires at 91859626754 nsecs [in 627784178 nsecs]
 #2: <f67d5eb0>, hrtimer_wakeup, S:01, do_nanosleep, hald-addon-stor/2321
 # expires at 92102929614 nsecs [in 871087038 nsecs]
 #3: <f67d5eb0>, it_real_fn, S:01, do_setitimer, automount/2115
 # expires at 105148251993 nsecs [in 13916409417 nsecs]
 #4: <f67d5eb0>, hrtimer_wakeup, S:01, do_nanosleep, crond/2228
 # expires at 111446499472 nsecs [in 20214656896 nsecs]
 #5: <f67d5eb0>, it_real_fn, S:01, do_setitimer, syslogd/1886
 # expires at 114439083561 nsecs [in 23207240985 nsecs]
 #6: <f67d5eb0>, hrtimer_wakeup, S:01, do_nanosleep, atd/2280
 # expires at 343127174592 nsecs [in 251895332016 nsecs]
 #7: <f67d5eb0>, it_real_fn, S:01, do_setitimer, sendmail/2917
 # expires at 3659006407026 nsecs [in 3567774564450 nsecs]
 #8: <f67d5eb0>, it_real_fn, S:01, do_setitimer, sendmail/2927
 # expires at 3659252445429 nsecs [in 3568020602853 nsecs]
 #9: <f67d5eb0>, it_real_fn, S:01, do_setitimer, anacron/2272
 # expires at 3941983748056 nsecs [in 3850751905480 nsecs]
  .expires_next   : 9223372036854775807 nsecs
  .hres_active    : 0
  .nr_events      : 0
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294915081


Tick Device: mode:     0
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           2
 next_event:     9223372036854775807 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_periodic_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   1009158122
 min_delta_ns:   1804
 mult:           35701831
 shift:          32
 mode:           1
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic


