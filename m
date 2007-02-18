Return-Path: <linux-kernel-owner+w=401wt.eu-S1030349AbXBRGb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030349AbXBRGb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXBRGb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:31:28 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35775 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030349AbXBRGb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:31:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<20070216195256.GE2572@flint.arm.linux.org.uk>
	<1171665426.5644.99.camel@localhost.localdomain>
	<200702170237.42910.arnd@arndb.de>
	<1171684847.5644.108.camel@localhost.localdomain>
	<m1tzxlb1b0.fsf@ebiederm.dsl.xmission.com>
	<1171746949.5644.137.camel@localhost.localdomain>
Date: Sat, 17 Feb 2007 23:30:37 -0700
In-Reply-To: <1171746949.5644.137.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Sun, 18 Feb 2007 08:15:49 +1100")
Message-ID: <m17iug9dv6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Sat, 2007-02-17 at 02:06 -0700, Eric W. Biederman wrote:

> However, PowerPC is a good example because it has such a diversity of
> very different hardware setups to deal with, ranging from the multiple
> layers of cascading controllers all over the place, to interrupts
> packets encoding vector/target etc... a bit like x86 on cell, to
> hypervisors providing a single giant number space etc etc etc...
>
> Thus, it is extremely likely that something that works well for PowerPC
> (or for ARM for that matter as it's probably as a "colorful" environment
> as PowerPC is) will end up being useful for others.

Sure I agree.  Part of what I'm trying to say is that it appears
that basic interrupt handling assumptions seem to be inherent to the
architectures.  And as much as it surprises me because of basic
assumptions I don't think there is any architecture with every flavor
of color.

>> I have a version of the x86 code with a partial conversion done and
>> I didn't need a reverse mapping.  What you call the hardware interrupt
>> number never happens to be interesting to me after the system is setup.
>
> Because you have the ability to tell your PIC to give you your "linux"
> interrupt number when actually sending the interrupt to the processor ?
> You need a way to get to the irq_desc * when getting an IRQ, either you
> have a way to map HW numbers back to irq_desc * in sofrware, or your HW
> allows you to do it.

I don't think is totally foreign, but in essence I have two kinds of
hardware number.  An (apic, pin) pair that I need when talking to
the hardware itself and a (cpu, vector) pair that I use when handling
an interrupt.  The vector number has never been the linux irq number
but at times it has only needed a simple offset adjustment.  Now that
we are having to handle bigger cases only the (apic, pin) pairs that
are actually used get a (cpumask_t, vector) assigned to them.

It may be that the only difference from the cell is that I have a very
small vector number I have to cope with instead of being able to tell
the irq controller to give me something immediately useful.

> I'm saying that if we're going to change the IRQ stuff that deeply, it
> would be nice if we looked into some of that stuff I've done that I
> beleive would be of use for other archs.

Reasonable. 

For the first pass when I do the genirq conversion passing struct
irq_desc *irq instead of unsigned int irq, I should be able to
do something stupid and correct on all of the architectures.  When
the start taking advantage of the new freedom though generic helpers
can be good.

> I found it overall very useful to have a generic remapping core and have
> cascaded PIC setups have a numbering domain local to a given PIC (pretty
> much, a domain != an irq_chip) and I'm convinced it would make life
> easier for archs with similar setups. The remapping core also shows its
> usefulness on archs with very big interrupt numbers, like sparc or
> pSeries ppc, and possibly others.

Except for the what appears to be instability of the irq numbers on
simpler configurations I don't have a problem with it.

> Now, I -do- have a problem with one aspect of your proposed design which
> is to keep the "linux" interrupt number in the generic irq_desc, which I
> think defeats most of the purpose of moving away from those linux irq
> numbers. If you do so, then I'll have to keep a separate remapping layer
> and keep a mecanism for virtualizing linux numbers.

Until we find a solution for the user space side of things we seem to
need the unsigned int irq number for user space.  Now I don't want
people mapping back and forth which is why I don't intend to provide a
reverse function.

But of course there will be a for_each_irq in the genirq layer so if
people really want to they will be able to go from the linux irq to 
an irq_desc.  But we don't have to export that generically (except
possibly something for the isa irqs).

Eric
