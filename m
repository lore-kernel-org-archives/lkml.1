Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYHWT7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYHWT7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbYHWTrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:47:46 -0400
Received: from aun.it.uu.se ([130.238.12.36]:44775 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbYHWTrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:47:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18608.26903.80591.84111@harpo.it.uu.se>
Date: Sat, 23 Aug 2008 21:46:31 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc: fix deadlock
In-Reply-To: <Pine.LNX.4.55.0808231919450.6466@cliff.in.clinika.pl>
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se>
	<20080823160151.GB27974@elte.hu>
	<18608.16826.607428.203994@harpo.it.uu.se>
	<20080823171139.GA13144@elte.hu>
	<Pine.LNX.4.55.0808231919450.6466@cliff.in.clinika.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki writes:
 > On Sat, 23 Aug 2008, Ingo Molnar wrote:
 > 
 > > > The sporadic nature of the bug means that it will probably take a 
 > > > couple of days of testing and dozens of reboots w/o problems before 
 > > > I'm confident to say that the problem's been fixed.
 > > 
 > > btw., i've seen that lockup too on a testbox - but havent been able to 
 > > track it down yet. You went further and presented the bug on a plate by 
 > > tracking it down to the loop in get_rtc_time() - so now we can both test 
 > > the fix and see whether the lockups are gone.
 > 
 >  Hmm, waiting for 20ms with interrupts disabled sounds like a bad idea --
 > a lot of system timer ticks may be lost and some devices may not be happy
 > about such a delay either (serial?).  I think your proposal only papers
 > over the actual bug and it should simply be forbidden to call this
 > function with interrupts disabled.
 > 
 >  I can see this is a part of the legacy RTC interface, so except from the
 > long delay the function itself may have a chance to work with interrupts
 > disabled.  But with the modern RTC library this is no longer true as some
 > RTC chips it supports can only be accessed with interrupts enabled,
 > because their accessor functions may sleep.  This is for example common
 > with RTC chips wired through I2C.
 > 
 >  Therefore I think to avoid propagating the design problem with places
 > calling get_rtc_time() when they eventually switch to the RTC library it
 > would be better to put:
 > 
 > BUG_ON(irqs_disabled());
 > 
 > into get_rtc_time() now and fix the callers which happen to trigger it.

On my C2D, I've only seen the lockup happen when user-space is
using hwclock to init system time (early init) or to flush system
time to the hw (end of shutdown/reboot). And the lockup is always
in hpet_rtc_interrupt. I've never ever seen the lockup while the
system is up and running normally.

So I suspect a bad interaction between the HPET RTC stuff and
the RTC user-space interface.

/Mikael
