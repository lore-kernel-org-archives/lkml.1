Return-Path: <linux-kernel-owner+w=401wt.eu-S1031453AbXDZTEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031453AbXDZTEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031455AbXDZTEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:04:37 -0400
Received: from www.osadl.org ([213.239.205.134]:54187 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031453AbXDZTEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:04:36 -0400
Subject: Re: [PATCH] pcmcia: irq probe can be done without risking an IRQ
	storm
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1177608704.25960.21.camel@localhost.localdomain>
References: <20070405140936.46fb6ba4@the-village.bc.nu>
	 <20070425211808.54b86293.akpm@linux-foundation.org>
	 <1177608704.25960.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 21:06:31 +0200
Message-Id: <1177614391.25960.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 19:31 +0200, Thomas Gleixner wrote:
> > >  #ifdef CONFIG_PCMCIA_PROBE
> > > +	if (!(req->Attributes & IRQ_HANDLE_PRESENT))
> > > +		type |= IRQ_NOAUTOEN;
> > > +
> > >  	if (s->irq.AssignedIRQ != 0) {
> > >  		/* If the interrupt is already assigned, it must be the same */
> > >  		irq = s->irq.AssignedIRQ;
> > 
> > alpha:
> > 
> > drivers/pcmcia/pcmcia_resource.c: In function 'pcmcia_request_irq':
> > drivers/pcmcia/pcmcia_resource.c:816: error: 'IRQ_NOAUTOEN' undeclared (first use in this function)
> > drivers/pcmcia/pcmcia_resource.c:816: error: (Each undeclared identifier is reported only once
> > drivers/pcmcia/pcmcia_resource.c:816: error: for each function it appears in.)
> > 
> > Problem is, IRQ_NOAUTOEN is a generic-irq thing, so architectures which
> > don't use generic-irqs break.  And it's defined in linux/irq.h which
> > (stupidly) cannot be included in generic code.
> 
> Hrmpf. We need a IRQF_NOAUTOEN, which can be handed to reqeust_irq().
> 
> I cook a patch.

Not that simple. For non shared interrupts it is straight forward, but
for shared ones we have to decide, whether we 

A) reject the request
B) disable the interrupt and rely on the caller, that it reenables it
C) ignore it

sorted by ugliness order :)

A) is definitely the most safe bet, but B) might work as well.

	tglx


