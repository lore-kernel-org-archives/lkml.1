Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbXKVKJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbXKVKJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 05:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXKVKJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 05:09:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54216 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXKVKJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 05:09:04 -0500
Date: Thu, 22 Nov 2007 11:09:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071122100941.GA1724@elf.ucw.cz>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain> <20071120225246.GA24380@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120225246.GA24380@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > and send us the output? (Enabling CONFIG_TIMER_STATS, 
> > > > > CONFIG_SCHED_DEBUG and CONFIG_SCHEDSTATS would maximize the amount 
> > > > > of information.)
> > > > 
> > > > This was w/o hpet=disable . Do you want me to test with hpet=disable?
> > > 
> > > no, this is fine. You've got a hpet clockevents driver and two lapic 
> > > drivers:
> > > 
> > > Clock Event Device: hpet
> > >  set_next_event: hpet_legacy_next_event
> > >  set_mode:       hpet_legacy_set_mode
> > >  event_handler:  tick_handle_oneshot_broadcast
> > > 
> > > Clock Event Device: lapic
> > >  set_next_event: lapic_next_event
> > >  set_mode:       lapic_timer_setup
> > >  event_handler:  hrtimer_interrupt
> > > 
> > > Clock Event Device: lapic
> > >  set_next_event: lapic_next_event
> > >  set_mode:       lapic_timer_setup
> > >  event_handler:  hrtimer_interrupt
> > > 
> > > to me this has the feeling of lapic breakage in C2 mode. Does it get any 
> > > better if you boot with 'nolapic'? (but that might in turn turn off 
> > > high-res timers and nohz in essence) Thomas, any ideas?
> > 
> > Hmm, lapic is considered unstable in c2 by default. You have to tell 
> > the kernel that you trust it in C2 on the command line.
> 
> yeah, i was wondering about that too. ACPI enumerated them properly at a 
> certain stage:
> 
>  ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
>  ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> 
> but perhaps somehow we miss this fact and fail to turn off the lapic 
> clockevents drivers?

I tried to add nolapic_timer manually, and that helped, but:

checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 627605 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
net_namespace: 64 bytes
...
Bluetooth: HCI socket layer initialized
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
Clockevents: could not switch to one-shot mode:<6>Clockevents: could
not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
 lapic is not functional.
Could not switch to high resolution mode on CPU 0
system 00:00: iomem range 0x0-0x9ffff could not be reserved

...and result is nohz is not functional :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
