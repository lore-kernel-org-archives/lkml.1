Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXBQVQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXBQVQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932933AbXBQVQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:16:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:39099 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932AbXBQVQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:16:21 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <m1tzxlb1b0.fsf@ebiederm.dsl.xmission.com>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <20070216195256.GE2572@flint.arm.linux.org.uk>
	 <1171665426.5644.99.camel@localhost.localdomain>
	 <200702170237.42910.arnd@arndb.de>
	 <1171684847.5644.108.camel@localhost.localdomain>
	 <m1tzxlb1b0.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 08:15:49 +1100
Message-Id: <1171746949.5644.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 02:06 -0700, Eric W. Biederman wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > In addition, if we remove the numbers, archs will need basically the
> > exact same services provided by the powerpc irq core for reverse mapping
> > (going from a HW irq number on a given PIC back to an irq_desc *).
> 
> Ben you seem to be under misapprehension that except for the case of
> ISA (0-16) the linux IRQ number is a hardware number.  It is an arbitrary
> software enumeration, and I think it has been that way a very long time.

Did you actually mean "is not a hardware number" ? If not, then I don't
understand your sentence...

> I can only tell you that my impression of this last is that all the
> world's not a PPC.

Yeah and my grandmother is not the pope, thank you.

However, PowerPC is a good example because it has such a diversity of
very different hardware setups to deal with, ranging from the multiple
layers of cascading controllers all over the place, to interrupts
packets encoding vector/target etc... a bit like x86 on cell, to
hypervisors providing a single giant number space etc etc etc...

Thus, it is extremely likely that something that works well for PowerPC
(or for ARM for that matter as it's probably as a "colorful" environment
as PowerPC is) will end up being useful for others.

> I have a version of the x86 code with a partial conversion done and
> I didn't need a reverse mapping.  What you call the hardware interrupt
> number never happens to be interesting to me after the system is setup.

Because you have the ability to tell your PIC to give you your "linux"
interrupt number when actually sending the interrupt to the processor ?
You need a way to get to the irq_desc * when getting an IRQ, either you
have a way to map HW numbers back to irq_desc * in sofrware, or your HW
allows you to do it.

> I do suspect there may be an interesting chunk of your ppc work that
> probably makes sense as a library so other arches could use it.

Guess what, one of the options of my code is to not instanciate a
remapper... for archs where it's not necessary. (We have the case for
example of iSeries whose hypervisor can return us the number we want for
an arbitrary interrupt).

Now, I'm not saying we should take the PowerPC code and say "hey' here's
the new generic code".

I'm saying that if we're going to change the IRQ stuff that deeply, it
would be nice if we looked into some of that stuff I've done that I
beleive would be of use for other archs (though you seem to imply that
it would be of no use on x86, good, still...).

I found it overall very useful to have a generic remapping core and have
cascaded PIC setups have a numbering domain local to a given PIC (pretty
much, a domain != an irq_chip) and I'm convinced it would make life
easier for archs with similar setups. The remapping core also shows its
usefulness on archs with very big interrupt numbers, like sparc or
pSeries ppc, and possibly others.

Now, I -do- have a problem with one aspect of your proposed design which
is to keep the "linux" interrupt number in the generic irq_desc, which I
think defeats most of the purpose of moving away from those linux irq
numbers. If you do so, then I'll have to keep a separate remapping layer
and keep a mecanism for virtualizing linux numbers.

Ben.


