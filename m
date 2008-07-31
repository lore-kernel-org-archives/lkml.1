Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYGaNZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYGaNZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYGaNZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:25:37 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51244 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYGaNZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:25:36 -0400
Date: Thu, 31 Jul 2008 15:26:06 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: michael@ellerman.id.au
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org, jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org
Subject: Re: [PATCH] powerpc - Initialize the irq radix tree earlier
Message-ID: <20080731152606.5ae7c379@bull.net>
In-Reply-To: <1217509299.19050.15.camel@localhost>
References: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
	<1217497241-10685-2-git-send-email-sebastien.dugue@bull.net>
	<1217504456.9817.22.camel@localhost>
	<20080731140002.31bbe4a0@bull.net>
	<1217509104.19050.11.camel@localhost>
	<1217509299.19050.15.camel@localhost>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 23:01:39 +1000 Michael Ellerman <michael@ellerman.id.au> wrote:

> On Thu, 2008-07-31 at 22:58 +1000, Michael Ellerman wrote:
> > On Thu, 2008-07-31 at 14:00 +0200, Sebastien Dugue wrote:
> > > On Thu, 31 Jul 2008 21:40:56 +1000 Michael Ellerman <michael@ellerman.id.au> wrote:
> > > > 
> > > > This boot ordering stuff is pretty hairy, so I might have missed
> > > > something, but this is how the code is ordered AFAICT:
> > > > ﻿
> > > > start_kernel()
> > > > 	init_IRQ()
> > > > 	...
> > > > 	local_irq_enable()
> > > > 	...
> > > > 	rest_init()
> > > > 		kernel_thread()
> > > > 			kernel_init()
> > > > 				smp_prepare_cpus()
> > > > 					smp_xics_probe()	(via smp_ops->probe())
> > > > 
> > > > 
> > > > What's stopping us from taking an irq between local_irq_enable() and
> > > > smp_xics_probe() ?  Is it just that no one's request_irq()'ed them yet?
> > > 
> > >   It's hairy, I agree, but as you've mentioned no one has done a request_irq()
> > > at that point. The first one to do it is smp_xics_probe() for the IPI.
> > 
> > Hmm, I don't think that's strong enough. I can trivially cause irqs to
> > fire during a kexec reboot just by mashing the keyboard.
> > 
> > And during a kdump boot all sorts of stuff could be firing. Even during
> > a clean boot, from firmware, I don't think we can guarantee that
> > nothing's going to fire.
> > 
> > .. after a bit of testing ..
> > 
> > It seems it actually works (sort of). 
> > 
> > xics_remap_irq() calls irq_radix_revmap_lookup(), which calls:
> > 
> > ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
> > 
> > And because ﻿host->revmap_data.tree was zalloc'ed we trip on the first
> > check here:
> 
> @#$% ctrl-enter == send!
> 
> Continuing ...
> 
> void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index)
> {
>         unsigned int height, shift;
>         struct radix_tree_node *node, **slot;
> 
>         node = rcu_dereference(root->rnode);
>         if (node == NULL)
>                 return NULL;
> 
> Which means ﻿irq_radix_revmap_lookup() will return NO_IRQ, which is cool.

  Which is what I intended so that as long as no IRQ is registered we
return NO_IRQ.

> 
> 
> So I think it can fly, as long as we're happy that we can't reverse map
> anything until smp_xics_probe() - and I think that's true, as any irq we
> take will be invalid.

  That's true as no IRQs are registered before smp_xics_probe() and for any
interrupt we might get before that, irq_radix_revmap_lookup() will return
NO_IRQ.

  Thanks,

  Sebastien.
