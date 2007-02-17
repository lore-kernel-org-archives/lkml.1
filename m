Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbXBQVUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbXBQVUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXBQVUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:20:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:56269 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbXBQVUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:20:53 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <m1k5yhb00g.fsf@ebiederm.dsl.xmission.com>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <200702162045.58857.arnd@arndb.de>
	 <20070216195256.GE2572@flint.arm.linux.org.uk>
	 <m1k5yhb00g.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 08:20:22 +1100
Message-Id: <1171747222.5644.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > #define NO_IRQ	<architecture-defined-int-constant>
> 
> When did you need a magic constant NO_IRQ in generic code.
> One of the reasons I want to convert the drivers is so we can
> kill the NO_IRQ nonsense.
> 
> As for struct irq.  Instead of struct irq_desc I really don't
> care, although the C++ camp hasn't not yet weighed in and mentioned
> how that creates a namespace conflict for them. 

Yeah, NO_IRQ would be NULL here...

What I do on the powerpc code is since IRQ HW numbers are defined
locally to a domain/PIC, when creating a new domain, The PIC code passes
a value to use as an "illegal" value in that domain. It's not exposed
outside of the core though, it's really only used to initialize the
remapping table with something before any interrupt on that PIC has been
mapped. 

> We might need this.  But I don't think we need reference counting in
> the traditional sense.  For all practical purpose we already have
> dynamic irq allocation and it hasn't proven necessary.  I would
> prefer to go to lengths to avoid having to expose that kind of
> an issue to driver code.

I think we do need proper refcounting, but I also think that most
drivers will not need to see it.

For example, a PCI driver will most probably just do something along the
lines of the existing request_irq(pdev->irq), the liftime of pdev->irq
is managed by the PCI core.

Same goes with MSIs imho, the MSI core can manage the lifetime
transparently.

Ben.


