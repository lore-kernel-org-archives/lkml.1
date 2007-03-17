Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXCQX0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXCQX0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbXCQX0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:26:01 -0400
Received: from www.osadl.org ([213.239.205.134]:38866 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751924AbXCQX0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:26:00 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Maxim <maximlevitsky@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200703180100.01889.maximlevitsky@gmail.com>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <200703161919.44458.lenb@kernel.org>
	 <200703180100.01889.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 00:32:54 +0100
Message-Id: <1174174374.13341.448.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim,

On Sun, 2007-03-18 at 01:00 +0200, Maxim wrote:
> >Mar 14 00:22:23 MAIN kernel: [    2.072931] checking TSC synchronization [CPU#0 -> CPU#1]:
> >Mar 14 00:22:23 MAIN kernel: [    2.092922] Measured 72051818872 cycles TSC warp between CPUs, turning off
> 
> ^ This one I don't think is related to NO_HZ, maybe it is hardware
> problem, but it exist without NO_HZ

The TSC is checked for synchronization between the CPUs. It's nothing to
worry about. We switch off the TSC and use a different clocksource.

Is this after resume ? If yes, then something (probably BIOS) is
fiddling with the TSC of one CPU when the resume happens.

> >[   36.217405] ENABLING IO-APIC IRQs
> >[   36.217587] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> >[   36.433917] APIC timer disabled due to verification failure.
> 
> This one is now discussed, I will look at it and it is not related to NO_HZ

I sent a patch for this yesterday:

http://marc.info/?l=linux-kernel&m=117408952322631&w=2

> And I forgot to tell about another problem with (now I know ,hi-resolution timers)
> That before suspend to ram APIC timer is used and HPET is not used :
> 
> root@MAIN:/home/maxim# cat /sys/devices/system/clockevents/clockevents0/registered
> lapic                F:0007 M:3(periodic) C: 1
> hpet                 F:0003 M:1(shutdown) C: 0
> lapic                F:0007 M:3(periodic) C: 0
> root@MAIN:/home/maxim#   
> 
> But after suspend to ram HPET is 'woken'
> 
> root@MAIN:/home/maxim# cat /sys/devices/system/clockevents/clockevents0/registered
> lapic                F:0007 M:3(one shoot) C: 1
> hpet                 F:0003 M:3(one shoot) C: 0
> lapic                F:0007 M:3(one shoot) C: 0

This is unrelated to suspend / resume. The local apic timers stop
(hardware madness), when the CPU enters C3 power state. In this case we
switch to HPET (or PIT when HPET is not available) and broadcast the
events via Inter Processor Interrupts. This is nothing to worry about. 

I'm a bit surprised though, that your system was in periodic mode before
suspend and switched to one shot mode on resume.

Is this reproducible ? If yes, can you please provide the dmesg output
from boot to resume ?

> Note that I added those (one shoot), (periodic) descriptions, would be
> nice to have them in kernel, can I send a patch ?  ;-)

Sure, just s/shoot/shot/ :)

> and I see average of 18 IRQs/sec on IRQ 0

So dynticks are working as expected.

	tglx


