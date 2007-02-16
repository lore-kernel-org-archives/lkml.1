Return-Path: <linux-kernel-owner+w=401wt.eu-S1946249AbXBPWa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946249AbXBPWa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946253AbXBPWa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:30:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:52700 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946249AbXBPWa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:30:26 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 09:29:52 +1100
Message-Id: <1171664993.5644.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 05:10 -0700, Eric W. Biederman wrote:

> Getting the drivers changed actually looks to be pretty straight
> forward it will just be a very large mechanical change.  We change the
> type where of variables where appropriate and every once in a while
> introduce an irq_nr(irq) to get the actual irq number for the places
> that care (ISA or print statements).

Dunno about that irq_nr thingy. If we go that way, I'd be tempted to
remove the number completely from the "public" side of irq_desc... or
not.

On powerpc, we have this remapped thingy because we completely separate
the linux "virtual" interrupt domain from the physical numbering domains
of each PIC. Your change would turn the linux virtual domain into
pointers, removing the need for an array and associated limitations,
which is nice.

So to a given irq_desc / irq "virtual" number today, I match a pair HW
number (which is a special typedef which is currently defined as an
unsigned long) and a pointer to the irq "host" (which is the entity that
define a HW number domain).

That means that you can have multiple hosts and a given HW number can
exist multiple times, once per host.

Do you think the irq_hwnumber_t thingy I have should then be generalized
and put into the irq_desc ? I would need an additional void * pointer to
the irq host as well (it's not a 1:1 relationship to an irq chip and
need to be accessed by generic code).

Having the HW number be clearly specific to a "domain controller" makes
also a lot of sense in the embedded field with lots of cascaded
interrupt controllers. It avoids having to play all sorts of tricks to
assign ranges of numbers to various controllers in the system. Only the
local number on a given controller matters, the rest is dynamically
assigned.
 
Another option would be to have the irq_desc be created by the arch and
"embedded" in a larger data structure, in which case the HW number would
be part of the private part of that data structure. Though I suppose
that could be a problem with ISA...

I suspect that for backward compatibility, we will need to keep
something (optionally maybe via CONFIG_*) for ISA/legacy interrupts.
That is a 16 entries irq_desc* array, so we can go from a legacy IRQ
number to an irq_desc on platform that have legacy/ISA crap floating
around.

On powerpc, what I do is that I always reserve entries 0...15 of my
remapping array in such a way that linux virtual irq 0 is always
reserved, and 1...15 are only ever assigned to legacy interrupts if they
exist in the system, or left unassigned if they don't.

> I think we can make this change fairly smoothly if before the code is
> merged into Linus's tree we have a patchset prepared with a all of the
> core infrastructure changes and a best effort at all of the driver
> changes.  Then early some merge window we merge the patchset, and
> fixup the drivers that were missed.

As long as we do things properly and not with a big "DESIGNED FOR x86"
hack in the middle that makes it hard for everybody else, I agree.

Cheers,
Ben.

