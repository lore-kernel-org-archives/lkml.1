Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYIFSct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYIFSct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYIFScl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:32:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYIFSck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:32:40 -0400
Date: Sat, 6 Sep 2008 20:32:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH] rtc: fix deadlock: fixes regression since 2.6.24
Message-ID: <20080906183211.GD21872@elte.hu>
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se> <20080823160151.GB27974@elte.hu> <20080829114829.GA9510@janus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829114829.GA9510@janus>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank van Maarseveen <frankvm@frankvm.com> wrote:

> On Sat, Aug 23, 2008 at 06:01:51PM +0200, Ingo Molnar wrote:
> > 
> > * Mikael Pettersson <mikpe@it.uu.se> wrote:
> > 
> > > Since 2.6.27-rc1 my Core2Duo has been getting sporadic oopses
> > > from hpet_rtc_interrupt, usually during shutdown or reboot,
> > > but occasionally also early in init. Today I finally managed
> > > to capture one via a serial cable:
> > > 
> > > INIT: version 2.86 booting
> > > 		Welcome to Fedora Core
> > > 		Press 'I' to enter interactive startup.
> > > BUG: NMI Watchdog detected LOCKUP on CPU0, ip c0117092, registers:
> > > Modules linked in: ehci_hcd uhci_hcd usbcore
> > > 
> > > Pid: 311, comm: nash-hotplug Not tainted (2.6.27-rc4 #1)
> > > EIP: 0060:[<c0117092>] EFLAGS: 00000097 CPU: 0
> > > EIP is at hpet_rtc_interrupt+0x2d2/0x310
> > > EAX: 00000000 EBX: 00000002 ECX: 00000046 EDX: 00000002
> > > ESI: 000000a6 EDI: ffff8e25 EBP: 00000008 ESP: f7bd7f28
> > >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > > Process nash-hotplug (pid: 311, ti=f7bd6000 task=f7b70460 task.ti=f7bd6000)
> > > Stack: f7bd7f6c c0139cc0 00000000 c035ba04 00000000 00000000 00000000 00000000 
> > >        00000000 00000000 00000000 00000000 00000000 f7b845a0 00000000 00000000 
> > >        00000008 c01478a8 c035bf80 f7b845a0 c035bfb0 00000008 c0148f71 00000400 
> > > Call Trace:
> > >  [<c0139cc0>] hrtimer_run_pending+0x20/0x90
> > >  [<c01478a8>] handle_IRQ_event+0x28/0x50
> > >  [<c0148f71>] handle_edge_irq+0xa1/0x120
> > >  [<c010615b>] do_IRQ+0x3b/0x70
> > >  [<c0113225>] smp_apic_timer_interrupt+0x55/0x80
> > >  [<c0103c4f>] common_interrupt+0x23/0x28
> > >  [<c02c0000>] unix_release_sock+0xc0/0x220
> > >  =======================
> > > Code: 89 44 24 18 0f b6 c2 e8 5d 74 0c 00 8b 0d d8 9c 3b c0 89 44 24 1c 8b 44 24 0c 48 89 44 24 20 e9 84 fd ff ff 90 8d 74 26 00 f3 90 <a1> 80 ba 35 c0 29 f8 83 f8 01 76 f2 e9 e1 fe ff ff 90 8d 74 26 
> > > 
> > > This points to the following loop in hpet_rtc_interrupt:
> > > 
> > > 0xc0117090 <hpet_rtc_interrupt+720>:    pause  
> > > 0xc0117092 <hpet_rtc_interrupt+722>:    mov    0xc035ba80,%eax
> > > 0xc0117097 <hpet_rtc_interrupt+727>:    sub    %edi,%eax
> > > 0xc0117099 <hpet_rtc_interrupt+729>:    cmp    $0x1,%eax
> > > 0xc011709c <hpet_rtc_interrupt+732>:    jbe    0xc0117090 <hpet_rtc_interrupt+720>
> > > 
> > > Note: 0xc035ba80 == &jiffies
> > > 
> > > This loop originates from asm-generic/rtc.h:get_rtc_time()
> > > 
> > > 		while (jiffies - uip_watchdog < 2*HZ/100) {
> > > 			barrier();
> > > 			cpu_relax();
> > > 		}
> > > 
> > > Note: HZ == CONFIG_HZ == 100
> > > 
> > > The bug may not originate from the 2.6.27-rc series as I only recently 
> > > enabled HPET in this machine's kernels (not due to HPET problems, it 
> > > inherited its .config way back from an older machine w/o HPET).
> > 
> > argh, that loop in asm-generic/rtc.h:get_rtc_time looks extremely 
> > fragile, we'll lock up if it's ever called with hardirqs off!
> > 
> > Does the patch below do the trick?
> > 
> > 	Ingo
> > 
> > ----------------->
> > >From 2273cc870b52a7ed09eb225142a6db97299e4f39 Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Sat, 23 Aug 2008 17:59:07 +0200
> > Subject: [PATCH] rtc: fix deadlock
> > 
> > if get_rtc_time() is _ever_ called with IRQs off, we deadlock badly
> > in it, waiting for jiffies to increment.
> > 
> > So make the code more robust by doing an explicit mdelay(20).
> > 
> > This solves a very hard to reproduce/debug hard lockup reported
> > by Mikael Pettersson.
> > 
> > Reported-by: Mikael Pettersson <mikpe@it.uu.se>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  include/asm-generic/rtc.h |   12 ++++--------
> >  1 files changed, 4 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
> > index be4af00..71ef3f0 100644
> > --- a/include/asm-generic/rtc.h
> > +++ b/include/asm-generic/rtc.h
> > @@ -15,6 +15,7 @@
> >  #include <linux/mc146818rtc.h>
> >  #include <linux/rtc.h>
> >  #include <linux/bcd.h>
> > +#include <linux/delay.h>
> >  
> >  #define RTC_PIE 0x40		/* periodic interrupt enable */
> >  #define RTC_AIE 0x20		/* alarm interrupt enable */
> > @@ -43,7 +44,6 @@ static inline unsigned char rtc_is_updating(void)
> >  
> >  static inline unsigned int get_rtc_time(struct rtc_time *time)
> >  {
> > -	unsigned long uip_watchdog = jiffies;
> >  	unsigned char ctrl;
> >  	unsigned long flags;
> >  
> > @@ -53,19 +53,15 @@ static inline unsigned int get_rtc_time(struct rtc_time *time)
> >  
> >  	/*
> >  	 * read RTC once any update in progress is done. The update
> > -	 * can take just over 2ms. We wait 10 to 20ms. There is no need to
> > +	 * can take just over 2ms. We wait 20ms. There is no need to
> >  	 * to poll-wait (up to 1s - eeccch) for the falling edge of RTC_UIP.
> >  	 * If you need to know *exactly* when a second has started, enable
> >  	 * periodic update complete interrupts, (via ioctl) and then 
> >  	 * immediately read /dev/rtc which will block until you get the IRQ.
> >  	 * Once the read clears, read the RTC time (again via ioctl). Easy.
> >  	 */
> > -
> > -	if (rtc_is_updating() != 0)
> > -		while (jiffies - uip_watchdog < 2*HZ/100) {
> > -			barrier();
> > -			cpu_relax();
> > -		}
> > +	if (rtc_is_updating())
> > +		mdelay(20);
> >  
> >  	/*
> >  	 * Only the values that we read from the RTC are set. We leave
> 
> This patch fixes a regression since 2.6.24: 2.6.25 and 2.6.26 occasionally
> locked up hard here without a trace and even alt-sysrq did not work
> anymore. It's easy to reproduce with
> 
> 	while :; do hwclock; done
> 
> Others are experiencing this issue too:
> - http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=494036
> - http://kerneltrap.org/mailarchive/message-id/20080821163920.GA19140@gamma.logic.tuwien.ac.at/linux-kernel
> - people (me included) experienced booting problems because of
>   this (lockup after initscripts says "Setting the system clock").
> 
> maybe this is 2.6.25.x and 2.6.26.x material too?

agreed - stable Cc:-ed.

It's about this upstream commit:

| commit 38c052f8cff1bd323ccfa968136a9556652ee420
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Sat Aug 23 17:59:07 2008 +0200
|
|     rtc: fix deadlock

please backport it into -stable .26 and .25. Thanks,

	Ingo
