Return-Path: <linux-kernel-owner+w=401wt.eu-S2992796AbXCHAQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992796AbXCHAQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992798AbXCHAQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:16:45 -0500
Received: from www.osadl.org ([213.239.205.134]:49731 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992796AbXCHAQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:16:44 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45EF49E9.7040509@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>
	 <45EF0CF5.5090305@goop.org>  <45EF175D.6030609@vmware.com>
	 <1173302503.24738.795.camel@localhost.localdomain>
	 <45EF372E.7030600@goop.org>
	 <1173308717.24738.898.camel@localhost.localdomain>
	 <45EF49E9.7040509@vmware.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 01:22:53 +0100
Message-Id: <1173313373.24738.937.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 15:25 -0800, Zachary Amsden wrote:
> > Looking at vmitimer.c and the number of hardcoded assumptions are
> > telling me, that we are heading in exactly the opposite direction.
> >   
> 
> No, VMI timer is unique because for SMP, it is based on the APIC.  On 
> i386, SMP is hardwired to depend on the APIC, and so we simply re-use 
> the pieces of it which are there, with the same assumptions about irqs, 
> and hardware behavior, good or bad.  We just have a different way of 
> telling the LAPIC when to deliver interrupts.

This is exactly the point. There is no benfit in reusing 3 lines of
lapic interrupt handler code and therefor reaching into it. clockevents
are not connected to lapic on SMP by any means. They are designed to be
self contained and so please use them as designed.

> The alternative is to pretty much completely copy apic.c into vmi.c or 
> vmitimer.c, which seems a rather bad idea, since now two copies of 
> nearly identical code need to be maintained.

You managed to avoid the usage of other code (i.e. PIT / HPET) already,
so why is it sooo desireable to emulate apics instead of substituting it
by a small and sane replacement ? Just because you happen to have an
LAPIC emulator ? That's no reason to wire yourself into the kernel code
and make it harder to change and maintain.

> > Yes, if they are used in a sane and self contained way without reaching
> > all over the place and expecting that those functions, which are not
> > part of the paravirt interfaces will work for ever.
> >   
> 
> But we definitely need pieces of the core APIC dependent code.  Xen 
> needs pieces of it too, but very select pieces for SMP boot.  The 
> ugliness you point out is there, but the reason it is there is not 
> because the paravirt code is cluttered, it is because the i386 code is 
> so hardwired to use the APIC model that there is pain separating from it.
>
> The correct solution here is to properly separate the APIC, SMP, and 
> timer code so the logic of it which we want to reuse is separated from 
> the hardware dependence.  Clock events and clocksources take care of 
> most of the timer issues, but there is still ugliness from SMP timer 
> events depending on having part of the APIC infrastructure for wiring 
> the interrupt gates.

Again: clockevents do not require APIC and do not depend on any APIC
wiring. Your hypervisor is working that way.

> > No it's not an absolute blocker, as long as we can take care, that the
> > number of incarnations is 
> >
> > - designed to be shareable between hypervisors which have the same time
> > model
> > - common code like the 128 bit math is in a shared library
> > - self contained and not reaching out into core kernel code for no good
> > reason
> >   
> > Same goes for clock events, interrupts and other core facilities.
> 
> I think that is what everyone wants.  This is an iterative process.  We 
> certainly don't want to reach out into core kernel code unless there is 
> a good reason to do so, and with every development of clock events, 
> sources, and interrupts, we have less of a reason to do so, and the code 
> gets cleaner and more maintainable.

We have to avoid this reachout in the first place. It just adds more
hardwires into the hairball and makes it harder to distangle. 

If you want the virtualization support in the kernel, then please
understand that we hardwire now and we'll fix it up once the core kernel
developers serve us the solution on the silver tablet is not going to
work. Please work with us on a proper solution upfront instead of
throwing random hackery with the lame excuse "for a good reason" at us.

You knew exactly, that clockevents & co are on the way to mainline and
there was enough time to work with us on a proper solution. No, you
decided to ignore it, even after people pointed it out to you way before
the 2.6.21 merge window. Now we have the hardwire in place and we can
wait for you to fix it whenever it seems to fit into the vmware business
plan.

I'm not going to accept any further reachout unless there is an urgent
bugfix in the release cycle, which does not allow a proper solution. But
be sure, that the backout patch will hit -mm immidiately.

	tglx


