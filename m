Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXIOCO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXIOCO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 22:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbXIOCOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 22:14:50 -0400
Received: from ozlabs.org ([203.10.76.45]:50950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbXIOCOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 22:14:49 -0400
Subject: Re: [PATCH] Introduce "used_vectors" bitmap which can be used to
	reserve vectors.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070914074458.GA63069@muc.de>
References: <1189746849.7262.29.camel@localhost.localdomain>
	 <20070914074458.GA63069@muc.de>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 12:14:09 +1000
Message-Id: <1189822449.7262.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 09:44 +0200, Andi Kleen wrote:
> On Fri, Sep 14, 2007 at 03:14:09PM +1000, Rusty Russell wrote:
> > This simplifies the io_apic.c __assign_irq_vector() logic and removes
> > the explicit SYSCALL_VECTOR check, and also allows for vectors to be
> > reserved by other mechanisms (ie. lguest).
> 
> Seems reasonable even as a cleanup.
> 
> >  
> >  int panic_on_unrecovered_nmi;
> > +
> > +DECLARE_BITMAP(used_vectors, NR_VECTORS);
> > +EXPORT_SYMBOL_GPL(used_vectors);
> 
> But what is the export good for? Since it's only used at boot
> a module cannot do anything useful with it.

Hmm, maybe I misunderstood.  I assumed that create_irq() was also called
later to get irqs for any devices which appeared later.  Although I can
at least check it's not in use.

The current lguest patch uses it like so (syscall_vector is a module
parameter):

int init_interrupts(void)
{
	/* If they want some strange system call vector, reserve it now */
	if (syscall_vector != SYSCALL_VECTOR
	    && test_and_set_bit(syscall_vector, used_vectors)) {
		printk("lg: couldn't reserve syscall %u\n", syscall_vector);
		return -EBUSY;
	}
	return 0;
}

Thanks,
Rusty.


