Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYCCRBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYCCRBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYCCRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:01:27 -0500
Received: from panic.printk.net ([217.147.83.20]:55834 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYCCRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:01:26 -0500
Subject: Re: 2.6.24-rt1 IRQ routing anomaly
From: Jon Masters <jonathan@jonmasters.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mark Hounschell <markh@compro.net>, Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.58.0803030852460.13556@gandalf.stny.rr.com>
References: <47BD6802.60604@cfl.rr.com>
	 <Pine.LNX.4.58.0802210743080.9890@gandalf.stny.rr.com>
	 <47BD7D09.9050106@compro.net>
	 <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
	 <1204518711.22885.68.camel@perihelion>
	 <Pine.LNX.4.58.0803030820580.20684@gandalf.stny.rr.com>
	 <47CBFED1.7090903@compro.net>
	 <Pine.LNX.4.58.0803030852460.13556@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 03 Mar 2008 12:00:55 -0500
Message-Id: <1204563655.3052.47.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 09:31 -0500, Steven Rostedt wrote:
> 
> On Mon, 3 Mar 2008, Mark Hounschell wrote:
> 5B> >
> > >
> > Steve is correct. I have plenty of other choices. Steve, you mentioned, a "work around"
> > is in -rt3. My only concern is does the current "work around" for other hardware really
> > work or may I see this again with other "non cheap" hardware?
> 
> We have a work around for secondary IOAPICS, which sometimes shows this
> behaviour (on non-cheap hardware).

Yeah, and weirdly, we never see it on the primary IO-APIC. However, I
think that's just wonderfully convenient. It usually happens on IO-APICs
integrated into e.g. a PCIe chipset that do weird legacy mode support,
but those can equally well happen at the root node of modern systems
(and hence it could happen on the primary one in theory too).

As you can see, we've had a lot of trouble actually tracking down
exactly what circumstances cause this to happen - and it depends upon
the overall system design for what legacy lines are wired together :)

> The problem we have is that for some reason, IO-APICS with PCI-X chips

*and* PCIe, in fact it's happening in chipsets that either have or are
closely connected with another that provides an IO-APIC. For example,
the HT-1000/HT-2000 combos, that talk to oneanother over HT can be
affected by this problem too.

> The work around that we
> currently have (besides noapic) is to switch the interrupt to an edged
> level interrupt instead of masking. We mark the interrupt as IN_PROGRESS
> and if new interrupts come in from the same line, we can just flag them as
> pending and return.

Yup. That works quite well, for some boxen.

> This works for some boxes. But this can cause problems for other boxes
> that don't like having the interrupt being switched from level to edge and
> back. For these boxes, the workaround must be disabled.

Yup. And there are some errata too that mean some chips explicitly won't
support masking as we do, some won't support level/edge/level, some
won't do both, some will just put their fingers in their ears.

> Then we have a third set of boxes where the masking causes wrong
> interrupts (like what you were seeing) and the level/edge hack also causes
> problems. For these boxes the only current solution is noapic.

And a specific warning message in the RHEL-RT Red Hat kernel. I can put
together a semi-upstream acceptable patch for this, but the quirk we
have is really a temporary workaround at the moment. We abuse PCI
quirking code to enable a global IO-APIC level/edge/level hack.

Note that we can't do what "mainstream" Linux does in -RT, namely using
the fastEOI path, because Fast EOI interrupt handling (in which Linux
talks directly to the LAPIC (local APIC within the CPU) and tells it to
shut the hell up the IO-APIC that just raised an interrupt) relies upon
serial interrupt delivery and complete handling of an interrupt before
handling of the next one. The "new world order" basically completely
screws over the design of this hardware, but does the right thing (IMHO
the way EOI is implemented actually needs rethinking anyway).

Also note that, for completeness, I wrote a blog entry on modern IO-APIC
handling a while back, for when this issue would finally come up here:
http://www.jonmasters.org/blog/?p=641

> The last solution to this, which is also our long term fix, is to add a
> new interface for devices to let them disable the interrupt at the device
> level (not masked at the IO-APIC). The disadvantage to this is the longer
> time to traverse the PCI Bus, and added traffic on it. But the advantage
> is not only a fix to this problem, but a way to figrane the priorities of
> interrupts further than just the interrupt line. With this fix we can
> create an interrupt thread per device. Also making the use of tasklets and
> softirqs obsolete.  But this has a long way to go still.

Indeed. I have submitted a paper to OLS on this, and will followup with
a patch series in due course, once I have time to get a test system
fully converted over. We don't plan to re-introduce top and bottom
halves, but we do plan on this:

*). Interrupt is asserted.
*). Quiesce handler called to shut up device, verify interrupt source,
subsequently calls the regular EOI handling path to shutup IO-APIC.
*). Linux schedules the corresponding per-device interrupt thread.
*). Interrupt thread runs, is schedulable, can do away with lots of
pointless use of tasklets, and other "DPC" in kernel IRQ paths.

Besides, I quite like this for actually getting interrupt threads
upstream in due course. We can make a really nice and compelling
argument that splitting interrupts into two pieces like this (really
just making the threads work "right" - one thread per device, and not
one thread per line...which doesn't scale) makes IRQ threads the right
solution for Linux, removes complexity, and is just a good idea. Also,
we can even make systems more robust once interrupt threads that lock
hard can't actually always bring down the system around you.

> >
> > Is there a known list of hardware this problem is seen on?
> 
> We know of some, the list is still growing.
> 
> Jon, where are we on the "blacklist"?

The blacklist is simply a list of PCI quirks. Do you think I should
clean this up for upstream? I mean, really, I was just hoping to get the
longer term interrupt rewrite done, quietly sneak it out before OLS,
then wait for the flamewar...I guess you let the cat out of the bag.

:)

Jon.


