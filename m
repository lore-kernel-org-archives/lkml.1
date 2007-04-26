Return-Path: <linux-kernel-owner+w=401wt.eu-S1031369AbXDZR3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031369AbXDZR3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXDZR3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:29:51 -0400
Received: from www.osadl.org ([213.239.205.134]:53697 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754876AbXDZR3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:29:49 -0400
Subject: Re: [PATCH] pcmcia: irq probe can be done without risking an IRQ
	storm
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20070425211808.54b86293.akpm@linux-foundation.org>
References: <20070405140936.46fb6ba4@the-village.bc.nu>
	 <20070425211808.54b86293.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 19:31:44 +0200
Message-Id: <1177608704.25960.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 21:18 -0700, Andrew Morton wrote:
> On Thu, 5 Apr 2007 14:09:36 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > Nowdays you can ask for an IRQ to be allocated but not enabled, when
> > PCMCIA was written this was not true and this feature is thus not used
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> > 
> > diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c linux-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c
> > --- linux.vanilla-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c	2007-04-03 16:52:14.000000000 +0100
> > +++ linux-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c	2007-04-03 17:10:42.000000000 +0100
> > @@ -810,8 +810,11 @@
> >  		type = IRQF_SHARED;
> >  	if (req->Attributes & IRQ_TYPE_DYNAMIC_SHARING)
> >  		type = IRQF_SHARED;	
> >  #ifdef CONFIG_PCMCIA_PROBE
> > +	if (!(req->Attributes & IRQ_HANDLE_PRESENT))
> > +		type |= IRQ_NOAUTOEN;
> > +
> >  	if (s->irq.AssignedIRQ != 0) {
> >  		/* If the interrupt is already assigned, it must be the same */
> >  		irq = s->irq.AssignedIRQ;
> 
> alpha:
> 
> drivers/pcmcia/pcmcia_resource.c: In function 'pcmcia_request_irq':
> drivers/pcmcia/pcmcia_resource.c:816: error: 'IRQ_NOAUTOEN' undeclared (first use in this function)
> drivers/pcmcia/pcmcia_resource.c:816: error: (Each undeclared identifier is reported only once
> drivers/pcmcia/pcmcia_resource.c:816: error: for each function it appears in.)
> 
> Problem is, IRQ_NOAUTOEN is a generic-irq thing, so architectures which
> don't use generic-irqs break.  And it's defined in linux/irq.h which
> (stupidly) cannot be included in generic code.

Hrmpf. We need a IRQF_NOAUTOEN, which can be handed to reqeust_irq().

I cook a patch.

	tglx


