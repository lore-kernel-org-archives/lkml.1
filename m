Return-Path: <linux-kernel-owner+w=401wt.eu-S933469AbXJRBzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbXJRBzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbXJRBzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:55:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:60263 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbXJRBzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:55:40 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20071017184512.a1c647b2.akpm@linux-foundation.org>
References: <1192670742.12879.5.camel@pasglop>
	 <20071017184512.a1c647b2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 11:55:23 +1000
Message-Id: <1192672523.12879.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Index: linux-work/kernel/irq/manage.c
> > ===================================================================
> > --- linux-work.orig/kernel/irq/manage.c	2007-10-18 11:22:16.000000000 +1000
> > +++ linux-work/kernel/irq/manage.c	2007-10-18 11:22:20.000000000 +1000
> > @@ -33,6 +33,7 @@ void synchronize_irq(unsigned int irq)
> >  	if (irq >= NR_IRQS)
> >  		return;
> >  
> > +	smp_mb();
> >  	while (desc->status & IRQ_INPROGRESS)
> >  		cpu_relax();
> >  }
> 
> Anyone reading this code is going to ask "wtf is that for".  It needs a
> comment telling them.
> 
> 
> mb() is the new lock_kernel().  Sigh.

Ugh ?

That sounds fairly obvious to me :-) we are reading a value, that is
totally unordered, nothing to do about lock kernel or whatever, if we
want the above statement to make any sense in any kind of usage
scenario, it needs to be ordered vs. what happens before.

For example, take a construct like:

	device->my_hw_is_off = 1;
	synchronize_irq();
	turn_off_hardware();

That basically makes sure the irq either sees device->my_hw_is_off
being set to 1, or if an irq handler is already in progress and hasn't
seen it, we wait for it to complete.

(You can replace "hw_is_off" with anything that we want to set and make
sure the IRQ handler sees it before proceeding. It could be clearing a
pointer to something and make sure the irq sees it before freeing the
data, etc...).

I think pretty much any use of synchronize_irq() I can imagine needs
such kind of ordering... or it simply doesn't synchronize anything :-)

Cheers,
Ben.


