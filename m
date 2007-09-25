Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbXIYVOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbXIYVOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXIYVOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:14:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbXIYVOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:14:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Tue, 25 Sep 2007 23:28:54 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <200709252207.02532.rjw@sisk.pl> <1190753192.17409.62.camel@chaos>
In-Reply-To: <1190753192.17409.62.camel@chaos>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_W2X+GZZobfxA2MI"
Message-Id: <200709252328.54843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_W2X+GZZobfxA2MI
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thomas,

On Tuesday, 25 September 2007 22:46, Thomas Gleixner wrote:
> Rafael,
> 
> On Tue, 2007-09-25 at 22:07 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 25 September 2007 15:17, Thomas Gleixner wrote:
> > > On Tue, 2007-09-25 at 15:16 +0200, Rafael J. Wysocki wrote:
> > [--snip--]
> > > 
> > > I start to get desperate. Below is a patch, which moves the apic timer
> > > disable check after the calibration routine. Can you please apply on top
> > > of -hrt and add "noapictimer" to the command line ? Does it boot ?
> >
> > 2.6.23-rc7 with patch-2.6.23-rc7-hrt1.patch and the patch below applied boots
> > with noapictimer and doesn't boot without it.
> 
> That was expected. I explicitly asked to add "noapictimer" to the kernel
> command line.
> 
> Ok, so we ruled out the apic timer calibration routine. I did not expect
> that this would be the culprit, but with "dark screen" as the only debug
> info, I need to resort to small steps.
> 
> Can you please send me the output of /proc/timer_list of 2.6.23-rc7-hrt1
> after booting with "noapictimer" ?

Sure, attached.  [Note: the kernel has been compiled with both NO_HZ and
HIGH_RES_TIMERS unset.]

> I'm a bit confused by your earlier confirmation, that mainline w/o the
> -hrt patches boots fine, when you add "apicmaintimer" to the kernel
> command line. "apicmaintimer" stops the PIT like we do in -hrt and we
> just use the local APIC timer for everything. Can you please retest and
> confirm that this is correct ?

No, it's not.  The mainline _usually_ doesn't boot with "apicmaintimer".

It seems to me that _sometimes_ the CPU just doesn't enter this C1E state
and then everything goes fine ...

> Is the 32 bit kernel working on that box ?

Can't tell, I have only 64-bit userland here.

> Thanks for your patience.

Well, I'm only making sure that future kernels will run on my box. ;-)

> 	tglx
> 
> PS: I just sent out the "disable APIC timer for AMD C1E boxen" patch.

Yes, I've already tested it and sent a reply.  It works. :-)

> We debugged this half a year ago on a nx6325, but I completely forgot about
> that. The explanation from AMD was sensible, but your "apicmaintimer"
> works statement is contradictory.

Well, it was wrong.

I have some problems with resuming from suspend to RAM using 2.6.23-rc8-mm1
with this patch applied, but I think they are related to something else.  I'll
wait for the next -mm with debugging that.

For now, I'm going to build 2.6.23-rc8 with my collection of suspend patches
plus patch-2.6.23-rc7-hrt1.patch and the "disable APIC timer for AMD C1E boxes"
patch applied.  I'll play with that a bit and let you know how it's behaving.

Greetings,
Rafael

--Boundary-00=_W2X+GZZobfxA2MI
Content-Type: text/plain;
  charset="iso-8859-15";
  name="timer_list.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="timer_list.txt"

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 279792107058 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 4000250 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .index:      1
  .resolution: 4000250 nsecs
  .get_time:   ktime_get
active timers:
 #0: <ffff81004f98bda8>, hrtimer_wakeup, S:01, do_nanosleep, kwrapper/4664
 # expires at 280207419178 nsecs [in 415312120 nsecs]
 #1: <ffff81004f98bda8>, hrtimer_wakeup, S:01, futex_wait, nscd/4080
 # expires at 282678021548 nsecs [in 2885914490 nsecs]
 #2: <ffff81004f98bda8>, hrtimer_wakeup, S:01, futex_wait, nscd/4082
 # expires at 282678129670 nsecs [in 2886022612 nsecs]
 #3: <ffff81004f98bda8>, it_real_fn, S:01, do_setitimer, qmgr/4239
 # expires at 378654389676 nsecs [in 98862282618 nsecs]
 #4: <ffff81004f98bda8>, it_real_fn, S:01, do_setitimer, pickup/4238
 # expires at 557809025993 nsecs [in 278016918935 nsecs]
 #5: <ffff81004f98bda8>, it_real_fn, S:01, do_setitimer, master/4216
 # expires at 557809137746 nsecs [in 278017030688 nsecs]

cpu: 1
 clock 0:
  .index:      0
  .resolution: 4000250 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .index:      1
  .resolution: 4000250 nsecs
  .get_time:   ktime_get
active timers:
 #0: <ffff81004f98bda8>, it_real_fn, S:01, do_setitimer, Xorg/4355
 # expires at 279804542721 nsecs [in 12435663 nsecs]
 #1: <ffff81004f98bda8>, it_real_fn, S:01, do_setitimer, ssh-agent/4611
 # expires at 279962268496 nsecs [in 170161438 nsecs]
 #2: <ffff81004f98bda8>, hrtimer_wakeup, S:01, do_nanosleep, hald-addon-stor/4148
 # expires at 280071774352 nsecs [in 279667294 nsecs]
 #3: <ffff81004f98bda8>, hrtimer_wakeup, S:01, futex_wait, nscd/4081
 # expires at 282678034680 nsecs [in 2885927622 nsecs]
 #4: <ffff81004f98bda8>, hrtimer_wakeup, S:01, do_nanosleep, cron/4241
 # expires at 335311096287 nsecs [in 55518989229 nsecs]
 #5: <ffff81004f98bda8>, it_real_fn, S:01, do_setitimer, dhcpcd/5128
 # expires at 604918992928181 nsecs [in 604639200821123 nsecs]
 #6: <ffff81004f98bda8>, hrtimer_wakeup, S:01, do_nanosleep, dhcpcd/5128
 # expires at 604918992950531 nsecs [in 604639200843473 nsecs]


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
tick_broadcast_mask: 00000003


Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   0
 min_delta_ns:   0
 mult:           0
 shift:          32
 mode:           1
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic

Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   0
 min_delta_ns:   0
 mult:           0
 shift:          32
 mode:           1
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic


--Boundary-00=_W2X+GZZobfxA2MI--
