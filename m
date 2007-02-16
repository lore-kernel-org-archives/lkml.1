Return-Path: <linux-kernel-owner+w=401wt.eu-S1946141AbXBPWd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946141AbXBPWd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946263AbXBPWd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:33:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:57065 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946141AbXBPWd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:33:57 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070216124117.GB4218@elte.hu>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <20070216124117.GB4218@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 09:33:10 +1100
Message-Id: <1171665190.5644.96.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 13:41 +0100, Ingo Molnar wrote:
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > So I propose we remove all assumptions from the code that we actually 
> > have an array of irqs.  That will allow for irq_desc to be dynamically 
> > allocated instead of statically allocated saving memory and reducing 
> > kernel complexity.
> 
> hm. I'd suggest to do this without changing request_irq() - and then we 
> could avoid the 'massive, every driver affected' change, right?
> 
> i.e. because we'll (have to) have an nr_to_desc() and desc_to_nr() 
> mapping facility anyway, lets just not change the driver APIs massively. 
> There dont seem to be that many drivers that assume that irq_desc[] is 
> an array - are there?
> 
> otherwise, in terms of the irqchips infrastructure and the API between 
> genirq and the irqchip arch-level drivers, this change makes quite a bit 
> of sense i think.
> 
> or am i missing something fundamental?

Well, I don't want to see anything like desc_to_nr / nr_to_desc unless
the number in question is a virtual number. That is, there is no way we
should go that way and keep passing a HW number through request_irq.
That would just be a total nightmare for powerpc and sparc at least.

What we can do is generalize the powerpc virtual irq scheme though. You
can see the implementation in arch/powerpc/kernel/irq.c starting from
the definition of irq_alloc_host() though for some stupid reason, I've
put all the documentation in include/asm-powerpc/irq.h so you might want
to start there.

Once the IRQ numbers are virtualized, it becomes easier to slowly
migrate things to use irq_desc_t * while still having a virutal number
available.

Once everything has been migrated, we can then get rid of the virtual
numbers completely except maybe for an optional 16 entries array for
legacy cruft.

Ben.


