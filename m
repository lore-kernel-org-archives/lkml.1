Return-Path: <linux-kernel-owner+w=401wt.eu-S965738AbXCGXdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738AbXCGXdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992740AbXCGXdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:33:47 -0500
Received: from gw.goop.org ([64.81.55.164]:49557 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965741AbXCGXdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:33:46 -0500
Message-ID: <45EF4BD7.7060400@goop.org>
Date: Wed, 07 Mar 2007 15:33:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Dan Hecht <dhecht@vmware.com>, James Morris <jmorris@namei.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>	 <1173228544.24738.514.camel@localhost.localdomain>	 <45EE0D10.7070807@vmware.com>	 <1173230305.24738.529.camel@localhost.localdomain>	 <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>	 <45EF0CF5.5090305@goop.org>  <45EF175D.6030609@vmware.com>	 <1173302503.24738.795.camel@localhost.localdomain>	 <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain>
In-Reply-To: <1173308717.24738.898.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Still there is a difference between using existing kernel interfaces and
> abusing them in a way which makes modifications to the core kernel code
> hard and unmaintainable. See below.
>   

I completely agree.  "Using the kernel interfaces" doesn't mean "this
random hack happens to work", it means "use the interface as intended as
a fully-fledged client".  If the interface doesn't work for our use,
then we can negotiate with the appropriate people on how to extend it
properly.


> On the other hand we yet see things like:
>
>         /* We use normal irq0 handler on cpu0. */
>         time_init_hook();
>
> Which is just reaching into the kernel code directly and does not handle
> the clock event interrupt self contained. clockevents is not bound to
> IRQ0 and this kind of hackery is exactly what we need to avoid in order
> to get this maintainable.
>   

Yes, I'm definitely not arguing with you about this.  I think the first
cut vmi time code was pretty questionable, but I have confidence they'll
fix it up before submission.

The point is that when you put the xen and vmi implementations next to
each other you find that 1) in each case there's a pretty small
abstraction distance between the clock interface and the hypercall
interface, and 2) there's very little code which can be shared between
the two.  Which means that adding another layer of abstraction to
protect the clock code from paravirtualized time devices is just going
to add fat without much benefit.

> Yes, if they are used in a sane and self contained way without reaching
> all over the place and expecting that those functions, which are not
> part of the paravirt interfaces will work for ever.
>   

100% agree.  If the interfaces change, then we'll change the code using
them like any other kernel code would.  If the new interfaces are hard
to make work then that's a problem, but one would hope that would get
shaken out as part of the normal kernel development process.

The point is that this code under and around the paravirt_ops interface
is just normal Linux code, and we expect to participate in the normal
kernel development process, with all the usual
discussions/arguments/negotiations over interface changes.  If the code
loses all its maintainers and becomes orphaned, unresponsive to
interface changes, then it's like any other dead driver: mark it
CONFIG_BROKEN and wait for someone to fix it.  But for now and the
foreseeable future these are going to be actively supported and
maintained pieces of code.

> You are not increasing the entanglement with the rest of the system,
> when you use a self contained device on top of an existing core kernel
> infrastructure, which has a paravirt backend. Quite the contrary, you
> have one piece of virtual hardware which is connected to the kernel and
> interacts with the various incarnations on the other side, which can as
> well live inside the kernel code. Granted it is another level of
> indirection, but I'd be happy to have only to deal with one of those
> beasts.
>   

Right.  But at that point the interface doesn't really have much of a
technical basis.  It's really a political border at which you can hand
off responsibility and make it ours.  I quite understand your
motivation, but I think you're solving a problem that hasn't happened
yet, and one that we'd all like to avoid.

I know the vmi time code has coloured your view here, but I surely hope
it can be got into a better state before posting.  I'm biased of course,
but I would rather hope that all these drivers we're talking about will
be as stylistically clean as the Xen time code (which has room for
improvement, of course).

There is, however, a median solution which keeps the number of clock
drivers down but also doesn't involve extending pv_ops.  We can just
create paravirt_clocksource/paravirt_clockevent helper wrappers, with
their own internal interfaces to act as a facade for the
hypervisor-specific code.  I don't think there's much point in doing
this now, but maybe it will become appealing once we start dealing with
things like stolen time.

> No it's not an absolute blocker, as long as we can take care, that the
> number of incarnations is 
>
> - designed to be shareable between hypervisors which have the same time
> model
> - common code like the 128 bit math is in a shared library
> - self contained and not reaching out into core kernel code for no good
> reason

Yep.

    J
