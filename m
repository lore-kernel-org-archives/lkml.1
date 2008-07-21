Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYGUUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYGUUxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYGUUxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:53:23 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:38557 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbYGUUxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:53:22 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eric miao <eric.y.miao@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jack Ren <jack.ren@marvell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
	<20080718102446.GV6875@elte.hu>
	<alpine.LFD.1.10.0807181548290.4316@apollo.tec.linutronix.de>
	<f17812d70807180738r75696e0ak120a884328b68ed3@mail.gmail.com>
	<alpine.LFD.1.10.0807181647500.4316@apollo.tec.linutronix.de>
	<87abgb3vay.fsf@old-tantale.fifi.org>
	<alpine.LFD.1.10.0807212154420.4316@apollo.tec.linutronix.de>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 21 Jul 2008 13:53:12 -0700
In-Reply-To: <alpine.LFD.1.10.0807212154420.4316@apollo.tec.linutronix.de>
Message-ID: <8763qz3qo7.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Mon, 21 Jul 2008, Philippe Troin wrote:
> > Thomas Gleixner <tglx@linutronix.de> writes:
> > I've seen weird timer behavior on both i386 and x86_64 on SMP
> > machines.  By weird I mean:
> > 
> >  - time stops for a few hours, then resumes as if nothing happened;
> > 
> >  - time flows too fast or slow (4x faster to 2x slower depending on
> >    phase of the moon);
> > 
> >  - the last one I've seen (yesterday), was: 
> >       sleep(1) sleeps for 1 second, but
> >       select(0, NULL, NULL, NULL, 0.5) sleeps for nine seconds.
> > 
> > I have been trying to track this problem for a few weeks now, without
> > success.  Booting a CONFIG_NO_HZ-enabled kernel with "highres=off
> > nohz=off" does not make a difference.  However booting a kernel with
> > CONFIG_NO_HZ and CONFIG_HIGH_RES_TIMERS disabled seems to be working
> > (I cannot garantee that since I've been using that for 48h so far, but
> > sometimes the problem takes a few days to manifest itself).
> > 
> > After a cursory reading of your patch, it looks to me that the race
> > could happen on a kernel compiled with CONFIG_NO_HZ and
> > CONFIG_HIGH_RES_TIMERS and booted with "nohz=off highres=off".  Can
> > you confirm that?
> 
> No, I can not confirm that. With nohz=off / highres=off that code path
> is not invoked.

Darn. You're right, on a more detailed reading:

  With CONFIG_NO_HZ set, the tick_nohz_stop_sched_tick() function is
  defined (declared in tick.h and defined in tick-sched.c).

  There's nothing to prevent tick_nohz_stop_sched_tick() to be called
  from cpu_idle().

  However in tick_nohz_stop_sched_tick(), ts->nohz_mode ==
  NOHZ_MODE_INACTIVE is true and the function bails out early.  And
  just before the section which was patched.

> > If you need more details (dmesg, lspci, etc), I have posted some
> > details on LKML ( http://lkml.org/lkml/2008/7/9/330 ) and I have a bug
> > posted on the Fedora/RH bugzilla (
> > https://bugzilla.redhat.com/show_bug.cgi?id=451824 ).
> 
> Will have a look. 
> 
> Question: which clocksource is active ?
> 
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource

As mentionned earlier I found two systems showing up the problem, a
dual Pentium III system (i386) and a dual Opteron system running in
64-bit (x86_64).

On the i386:

  current_clocksource is jiffies

  On this one, the symptoms tend to be that the clock goes too fast or
  too slow, always by an integer multiple (seen 2x slower and 4x
  faster so far). 

  Once on this system, while the clock was running 4x faster, changing
  current_clocksource to tsc (the only other available choice)
  reestablished the "normal flow of time" :)  Back to jiffies, and the
  clock went back to 4x faster.  I could switch back and forth.

On the x86_64:

  current_clocksource is hpet
 
  On the dual Opteron system, the symptoms I've seen are that the
  system becomes unresponsive, with some "stuck" processes, and the
  time not changing for long periods of time (like a few hours).

  It's also on this sytem that I saw yesterday:

     sleep(1) takes 1 seconds.
     select(0, NULL, NULL, NULL, .5) takes 9 seconds.
     date was reporting a wall time flowing normally.

A question I had was: when the system(s) gets wedged, what kind of
debugging information could I gather on the live system before I
reboot?

Phil.
