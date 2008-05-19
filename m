Return-Path: <linux-kernel-owner+w=401wt.eu-S1765309AbYESWNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765309AbYESWNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763513AbYESWIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:08:45 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64078 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764414AbYESWIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:08:44 -0400
Date: Mon, 19 May 2008 23:08:12 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I/O APIC: Timer through 8259A revamp
In-Reply-To: <483193B3.3090807@firstfloor.org>
Message-ID: <Pine.LNX.4.55.0805192247230.19879@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl>
 <87hccubgni.fsf@basil.nowhere.org> <Pine.LNX.4.55.0805191459220.19879@cliff.in.clinika.pl>
 <483193B3.3090807@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Andi Kleen wrote:

> >  With the ACPI tables, hardware is modern enough the timer interrupt 
> > should be directly available, but is usually wired in the way recommended 
> > by the MP spec.
> 
> I originally had that assumption too, but in practice that doesn't seem
> to be always the case unfortunately. Or sometimes the tests just fail
> for whatever reason and they drop into the fallback path.

 Well, the fallback path was meant to be used with hardware suffering from
limitations and not from broken configuration tables.  If the
configuration recorded in the tables is broken, then who knows what the
hardware looks like?  Anything may happen.  This should really be the case
for: "Fix your *** firmware!"  With Flash memories in wide use today,
there is really no excuse and the technology behind these tables does not
require a rocket scientist.

> >  That is the output of the master 8259A goes to INT0 of 
> > the I/O APIC (or is only connected to local APICs) and the timer is routed 
> > to INT2.  
> 
> There are already a couple of wiring differences in common chipsets.
> Mostly hurts on the fallback path especially when multiple sources are 
> enabled (then you might end up with duplicated interrupts, happened often
> on ATI systems)

 As soon as you hit the through-8259A mode chances are you will start
suffering from things like assumptions about the state of the hardware
made by whoever has written SMM code for this system, which may result in
reassertion of the interrupt that has already been handled (the mode of
operation of the 8254 does not help here).  Otherwise if the timer
interrupt genuinely arrives through multiple I/O APIC inputs, then we have
a piece of sloppy code somewhere -- we should never have more than one
input at a time with the same interrupt vector enabled; this is also a
grey area of operation of the APIC itself, at least with some
implementations.

> >  The use of the local APIC timer as a replacement was recommended back
> > then,
> 
> That was before CPU power saving was invented I guess @)

 Well, the i386SL was *the* power-saving Intel CPU when the i82489DX was
being worked on and certainly back then nobody sane would go through the
pain of putting additional CPUs into a system only to make them go to
sleep. ;-)  The SMM had already been committed in that CPU in case you
were asking...

> > but I think IRQ8 from the RTC was also a good solution, 
> 
> Trouble on Linux is that RTC doesn't support any of the traditional HZ 
> values. I considered writing a RTC driver back then, but didn't do
> it because of this. 
> 
> On the other hand with wider use of tickless kernels and hrtimers it might 
> be tolerable to use non standard HZ,

 I don't think the value of HZ should be a problem anymore now that we
have a separate user-visible HZ -- and it's been a while like that.  We
have a choice of three values of HZ already and for example the MIPS port
uses the closest powers of two to the usual values of 100, 250 and 1000
where necessary because of the very same reason and I haven't heard about
any problems resulting from that.

 Note some systems have the polarity reported incorrectly for the RTC 
interrupt -- that can be easily solved, but care has to be taken.

  Maciej
