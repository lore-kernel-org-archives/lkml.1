Return-Path: <linux-kernel-owner+w=401wt.eu-S1946402AbXBQEBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946402AbXBQEBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 23:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946403AbXBQEBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 23:01:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:50711 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946402AbXBQEBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 23:01:40 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <200702170237.42910.arnd@arndb.de>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <20070216195256.GE2572@flint.arm.linux.org.uk>
	 <1171665426.5644.99.camel@localhost.localdomain>
	 <200702170237.42910.arnd@arndb.de>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 15:00:47 +1100
Message-Id: <1171684847.5644.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 02:37 +0100, Arnd Bergmann wrote:
> On Friday 16 February 2007 23:37, Benjamin Herrenschmidt wrote:
> > You might want to have a look at the powerpc API with it's remaping
> > capabilities. It's very nice for handling multiple domain spaces. It
> > might be of some use for you.
> 
> I don't consider the powerpc virtual IRQs a solution for the problem.
> While I believe you did the right thing for powerpc with generalizing
> this over all its platforms, it really isn't more than a workaround
> for the problem that we can't deal well with the static irq_desc
> array.

It's not a solution per-se, though it contains elements of solution like
the reverse mappin, which I use to map HW numbers to virtual irqs but
can trivially adapt to map HW numbers to irq_desc pointers.

Among other things, I want to make sure that we don't end up with just
putting an irq number in a field of the irq_desc and have half of the
drivers peek at it and assume we can convert between irq_desc* and
number in arbitrary ways.

The HW irq number should be as much opaque as possible from the world
outside of the PIC code and/or arch code that assign them. That's an
area where the powerpc and/or sparc code might be of use.


> When that problem is now getting worse on other architectures, we
> should try to get it right on all of them, rather than spreading
> the workaround further.

Yes, but I'd like aspects of my remapping work to be included in
whatever we come up with, which is to have the new irq_desc either hide
the underlying HW number, or at least associate it make it very clear
that it's an opaque token and not guaranteed to be unique accross
multiple PICs in the system.

In addition, if we remove the numbers, archs will need basically the
exact same services provided by the powerpc irq core for reverse mapping
(going from a HW irq number on a given PIC back to an irq_desc *).

Either using a linear array for simple PICs or a radix tree for
platforms with very big interrupt numbers (BTW. I think we have lockless
radix trees nowadays, I can remove the spinlocks to protect it in the
powerpc remapper).

Ben.


