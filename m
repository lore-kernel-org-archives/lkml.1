Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYGaMKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYGaMKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYGaMKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:10:22 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34642 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYGaMKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:10:21 -0400
Date: Thu, 31 Jul 2008 14:10:29 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: michael@ellerman.id.au, tinytim@us.ibm.com, linux-rt-users@vger.kernel.org,
       jean-pierre.dion@bull.net, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       gilles.carry@ext.bull.net, tglx@linutronix.de
Subject: Re: [PATCH] powerpc - Initialize the irq radix tree earlier
Message-ID: <20080731141029.0a9dd4cf@bull.net>
In-Reply-To: <20080731140002.31bbe4a0@bull.net>
References: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
	<1217497241-10685-2-git-send-email-sebastien.dugue@bull.net>
	<1217504456.9817.22.camel@localhost>
	<20080731140002.31bbe4a0@bull.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 14:00:02 +0200 Sebastien Dugue <sebastien.dugue@bull.net> wrote:

> 
>   Hi Michael,
> 
> On Thu, 31 Jul 2008 21:40:56 +1000 Michael Ellerman <michael@ellerman.id.au> wrote:
> 
> > On Thu, 2008-07-31 at 11:40 +0200, Sebastien Dugue wrote:
> > > The radix tree used for fast irq reverse mapping by the XICS is initialized
> > > late in the boot process, after the first interrupt (IPI) gets registered
> > > and after the first IPI is received.
> > > 
> > >   This patch moves the initialization of the XICS radix tree earlier into
> > > the boot process in smp_xics_probe() (the mm is already up but no interrupts
> > > have been registered at that point) to avoid having to insert a mapping into
> > > the tree in interrupt context. This will help in simplifying the locking
> > > constraints and move to a lockless radix tree in subsequent patches.
> > > 
> > >   As a nice side effect, there is no need any longer to check for
> > > (host->revmap_data.tree.gfp_mask != 0) to know if the tree have been
> > > initialized.
> > 
> > Hi Sebastien,
> > 
> > This is a nice cleanup, I think :)
> 
>   Thanks.
> 
> > 
> > > diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> > > index 6ac8612..0a1445c 100644
> > > --- a/arch/powerpc/kernel/irq.c
> > > +++ b/arch/powerpc/kernel/irq.c
> > > @@ -893,28 +890,28 @@ unsigned int irq_find_mapping(struct irq_host *host,
> > >  }
> > >  EXPORT_SYMBOL_GPL(irq_find_mapping);
> > >  
> > > +void __init irq_radix_revmap_init(void)
> > > +{
> > > + 	struct irq_host *h;
> > > +
> > > +	list_for_each_entry(h, &irq_hosts, link) {
> > > +		if (h->revmap_type == IRQ_HOST_MAP_TREE)
> > > +			INIT_RADIX_TREE(&h->revmap_data.tree, GFP_ATOMIC);
> > > +	}
> > > +}
> > 
> > Note irq_radix_revmap_init() loops over all irq_hosts ...
> 
>   Yep, but there's only one host (xics)
> 
> > 
> > > diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
> > > index 9d8f8c8..b143fe7 100644
> > > --- a/arch/powerpc/platforms/pseries/smp.c
> > > +++ b/arch/powerpc/platforms/pseries/smp.c
> > > @@ -130,6 +130,7 @@ static void smp_xics_message_pass(int target, int msg)
> > >  
> > >  static int __init smp_xics_probe(void)
> > >  {
> > > +	irq_radix_revmap_init();
> > >  	xics_request_IPIs();
> > 
> > But now it's only called from the xics setup code.
> > 
> > Which seems a bit ugly. In practice it doesn't matter because at the
> > moment xics is the only user of the radix revmap. But if we're going to
> > switch to this sort of initialisation I think xics should only be
> > init'ing the revmap for itself.
> 
>   You're right, that's what I intended to do from the beginning but
> stumbled upon ... hmm, can't remember what, that made me change
> my mind.

  Ah yes, I wanted to do it from xics_init_host() but backed off
because at that point the mm is not up. But it does not make a difference
as the first request_irq() happens after the mm is up. A bit shaky I
concede.

> But I agree, I'm not particularly proud of that. Will look
> again into that.
> 
> > 
> > 
> > This boot ordering stuff is pretty hairy, so I might have missed
> > something, but this is how the code is ordered AFAICT:
> > ﻿
> > start_kernel()
> > 	init_IRQ()
> > 	...
> > 	local_irq_enable()
> > 	...
> > 	rest_init()
> > 		kernel_thread()
> > 			kernel_init()
> > 				smp_prepare_cpus()
> > 					smp_xics_probe()	(via smp_ops->probe())
> > 
> > 
> > What's stopping us from taking an irq between local_irq_enable() and
> > smp_xics_probe() ?  Is it just that no one's request_irq()'ed them yet?
> 
>   It's hairy, I agree, but as you've mentioned no one has done a request_irq()
> at that point. The first one to do it is smp_xics_probe() for the IPI.
> 
>   Thanks for your comments.
> 
>   Sebastien.
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
