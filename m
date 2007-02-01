Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbXBAWc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbXBAWc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbXBAWc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:32:28 -0500
Received: from www.osadl.org ([213.239.205.134]:45623 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932803AbXBAWc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:32:27 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mattia Dongili <malattia@linux.it>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <20070201211137.GA2830@inferi.kami.home>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <20070131215241.GB2890@inferi.kami.home>
	 <20070131232130.GC4137@inferi.kami.home>
	 <1170358572.29240.292.camel@localhost.localdomain>
	 <1170360101.29240.297.camel@localhost.localdomain>
	 <20070201211137.GA2830@inferi.kami.home>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 23:33:22 +0100
Message-Id: <1170369202.29240.339.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mattia,

On Thu, 2007-02-01 at 22:11 +0100, Mattia Dongili wrote:
> > It might be helpful if you could try with your original config again.
> > Please enable printk timestamps and SysRq. Once the slowness kicks in
> > please issue a SysRq-Q, so we can look at the internal state of the tick
> > code.
> 
> dmesg is below. I need to say that the printk times are bogus wrt the
> actual time passing and at one point I was sick waiting and killed all
> tasks. Ah, I have Ingo's resume-fix patch applied here.

Ok, does not affect your problem. 

Thanks for testing.

> [   13.117670] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> [   13.391218] APIC calibration not consistent with PM Timer: 228ms instead of 100ms
> [   13.391315] APIC delta adjusted to PM-Timer: 1041737 (2375299)

Sigh. This APIC calibration madness seems to be spreading (especially on
Sony laptops). But this is not the cause of the problem.

> [   14.448611] ACPI: (supports S0 S3 S4 S5)
> [   14.449145] Time: acpi_pm clocksource has been installed.
> [   14.449254] Switched to NOHz mode on CPU #1
> [   14.449258] Switched to NOHz mode on CPU #0

> [   20.937884] usb-storage: device scan complete
> [   22.644599] SysRq : Show Pending Timers
> [   22.644753] Timer List Version: v0.3
> [   22.644833] HRTIMER_MAX_CLOCK_BASES: 2
> [   22.644913] now at 21927904003 nsecs

> [   22.646105] active timers:
> [   22.646183]   .nohz_mode      : 1
> [   22.646343]   .tick_stopped   : 1
> [   22.646823]   .last_jiffies   : 4294897777
> [   22.646903]   .next_jiffies   : 4294897996
> [   22.646984]   .idle_expires   : 22800000000 nsecs
> [   22.647065] jiffies: 4294897777

Looks consistent.

> [   22.647144] cpu: 1
> [   22.648252] active timers:
> [   22.648330]  #0: <c037fd9c>, hrtimer_wakeup, S:01
> [   22.648738]  # expires at 16066999784 nsecs [in -5860904219 nsecs]
> [   22.648821]  #1: <c037fd9c>, hrtimer_wakeup, S:01
> [   22.649218]  # expires at 16325154918 nsecs [in -5602749085 nsecs]

ouch. that's 5 seconds over time

> [   22.649301]   .nohz_mode      : 1
> [   22.649380]   .idle_tick      : 15324783000 nsecs
> [   22.649461]   .tick_stopped   : 1
> [   22.649540]   .idle_jiffies   : 4294896127
> [   22.649619]   .idle_calls     : 2080
> [   22.649698]   .idle_sleeps    : 363
> [   22.649778]   .idle_entrytime : 15325159667 nsecs
> [   22.649858]   .idle_sleeptime : 10015150422 nsecs
> [   22.649940]   .last_jiffies   : 4294896127
> [   22.650020]   .next_jiffies   : 4294896189

delta is 62 jiffies = 62 * 4ms which is consistent with the idle_expires
time below:

> [   22.650100]   .idle_expires   : 15572000000 nsecs
> [   22.650181] jiffies: 4294897777

CPU 1 got no updates since it went idle.

> [   22.650336] Tick Device: mode:     1
> [   22.650488] Clock Event Device: pit
> [   22.655191]  next_event:     21940398000 nsecs

> [   22.655894] tick_broadcast_mask: 00000003
> [   22.655974] tick_broadcast_oneshot_mask: 00000003

Though the broadcast mode is active for both cpus

> [   22.656131] Tick Device: mode:     1
> [   22.656284] Clock Event Device: lapic
> [   22.656821]  next_event:     22800000000 nsecs

> [   22.657521] Tick Device: mode:     1
> [   22.657675] Clock Event Device: lapic
> [   22.658211]  next_event:     21940398000 nsecs

And the broadcast event is set for the next CPU#1 event, but the expiry
time is far away from the idle_expires time above.

I'm a bit puzzled and too tired to spot the bug right now.

May I ask you for another test ? Please turn on high resolution timers
and check, if the same strange behaviour is happening.

Thanks. 

	tglx


