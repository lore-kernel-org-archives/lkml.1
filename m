Return-Path: <linux-kernel-owner+w=401wt.eu-S2992457AbXCGWFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992457AbXCGWFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992461AbXCGWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:05:41 -0500
Received: from gw.goop.org ([64.81.55.164]:48332 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992457AbXCGWFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:05:40 -0500
Message-ID: <45EF372E.7030600@goop.org>
Date: Wed, 07 Mar 2007 14:05:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Dan Hecht <dhecht@vmware.com>, James Morris <jmorris@namei.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>	 <1173228544.24738.514.camel@localhost.localdomain>	 <45EE0D10.7070807@vmware.com>	 <1173230305.24738.529.camel@localhost.localdomain>	 <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>	 <45EF0CF5.5090305@goop.org>  <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain>
In-Reply-To: <1173302503.24738.795.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> This is tinkering of the best. My understanding of the paravirt
> discussion at Kernel Summit was, that paravirt ops are exactly there to
> prevent the above random hackery in the kernel and to allow _ALL_
> hypervisors to interact via a sane interface inside of the kernel.
>   

No, I don't think that was ever the intent.  The idea was to create a
new interface for things which don't currently have an interface in the
kernel, such as how to run the CPU in ring 1 and manage pagetable
updates.  But an important and explicit intent of the project was to use
existing kernel interfaces where possible, rather than try to make
pv_ops an monster all-encompassing interface.

Using the new time infrastructure was an explicit example of that.  We
anticipated that different hypervisors would have different ways of
doing time, but all would be easily accommodated by the
clocksource/events infrastructure, and so each would have its own
implementation for these interfaces.  From the kernel's perspective,
they're just another time device, and we manage to avoid making any core
kernel changes, or bloating the pv_ops interface.  It seems like a
natural use of the clock subsystem's design.

> You are just perverting the whole idea of a standartized
> paravirtualization interface.
>
> This things can be done for clocksources, clockevents, interrupts (the
> generic irq code allows this) and probaly for a whole bunch of other
> stuff.
>   

Yes, exactly.  The entirety of the Xen support consists of not only an
implementation of the paravirt_ops interface, but also the Xen
clocksource and clockevents and the Xen irqchip.  My hope and intent is
that we can shrink the paravirt_ops interface in favour of using
existing generally useful kernel interfaces.

> The current paravirt interface is completely insane and will explode
> into an unmaintainable nightmare within no time, if we keep accepting
> that crap further.
>   

No, that's exactly what we've been trying to avoid.

If we start patching in new paravirt_ops to deal with time, interrupts,
or whatever piece of functionality which already has a perfectly good
kernel interface, then we're just increasing the size of the pv_ops
interface, its entanglement with the rest of the system and the amount
of potential legacy stuff which gets dragged around as the interface
evolves.

As hardware gets better at supporting virtualization directly, we're
going to see more hybrid para- and fully- virtualized hypervisor
interfaces.  The result will be that more and more of paravirt_ops will
be implemented by the "native" versions of the functions; maybe at some
point the whole thing will evaporate away.

It's not a huge reach to expect the hardware vendors to get a clue about
time hardware (scratch that, of course it is, but we can always hope)
and come up with something that is directly usable from either an OS
running natively or from within a virtual machine.  In that case, I'm
sure you'd agree it would warrant a real clocksource/event
implementation.  In the scheme I'm proposing, that's no big deal; you
just register the hardware driver, and that's that.  But what you're
proposing leaves this vestigial interface sitting in pv_ops, doing
nothing other than being redundant.


My principle goal here is to get the Xen code into the kernel, and I'm
being pragmatic about it.  If you think having a xen_clocksource is an
absolute blocker to merging this stuff, then I'll add the interface to
pv_ops, and we'll work out how to wire all the hypervisors up underneath
that interface.  But I think it's precisely the wrong way to go from an
overall kernel perspective.

    J
