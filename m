Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYGYId7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYGYId7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYGYIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:33:50 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41406 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYGYIdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:33:49 -0400
Date: Fri, 25 Jul 2008 10:34:18 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux-rt <linux-rt-users@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: Re: [PATCH 2/2][RT] powerpc - Make the irq reverse mapping radix
 tree lockless
Message-ID: <20080725103418.2ae898f5@bull.net>
In-Reply-To: <1216972177.7257.351.camel@twins>
References: <20080724122352.3bc76bda@bull.net>
	<20080724125044.53b604cb@bull.net>
	<200807242111.35338.nickpiggin@yahoo.com.au>
	<20080724141839.477de30b@bull.net>
	<1216972177.7257.351.camel@twins>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Peter,

On Fri, 25 Jul 2008 09:49:37 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2008-07-24 at 14:18 +0200, Sebastien Dugue wrote:
> > On Thu, 24 Jul 2008 21:11:34 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > 
> > > On Thursday 24 July 2008 20:50, Sebastien Dugue wrote:
> > > > From: Sebastien Dugue <sebastien.dugue@bull.net>
> > > > Date: Tue, 22 Jul 2008 11:56:41 +0200
> > > > Subject: [PATCH][RT] powerpc - Make the irq reverse mapping radix tree
> > > > lockless
> > > >
> > > >   The radix tree used by interrupt controllers for their irq reverse
> > > > mapping (currently only the XICS found on pSeries) have a complex locking
> > > > scheme dating back to before the advent of the concurrent radix tree on
> > > > preempt-rt.
> > > >
> > > >   Take advantage of this and of the fact that the items of the tree are
> > > > pointers to a static array (irq_map) elements which can never go under us
> > > > to simplify the locking.
> > > >
> > > >   Concurrency between readers and writers are handled by the intrinsic
> > > > properties of the concurrent radix tree. Concurrency between the tree
> > > > initialization which is done asynchronously with readers and writers access
> > > > is handled via an atomic variable (revmap_trees_allocated) set when the
> > > > tree has been initialized and checked before any reader or writer access
> > > > just like we used to check for tree.gfp_mask != 0 before.
> > > 
> > > Hmm, RCU radix tree is in mainline too for quite a while. I thought
> > > Ben had already converted this code over ages ago...
> > 
> >   Mainline does not have the concurrent radix tree which this patch
> > is based on, but maybe it's overkill and the RCU radix tree is enough.
> > Not sure, will have to think about it a bit more.
> 
> Should be. The model of the concurrent radix tree can be mapped to
> spinlock + rcu radix tree.
> 
> So instead of:
> 
> > ﻿+               DEFINE_RADIX_TREE_CONTEXT(ctx, tree);
> > +               radix_tree_lock(&ctx);
> > +               radix_tree_insert(ctx.tree, hwirq, &irq_map[virq]);
> > +               radix_tree_unlock(&ctx);
> 
> 
> you then write:
> 
> 	spin_lock(&host->revmap_data.tree_lock);
> 	radix_tree_insert(&host->revmap_data.tree, hwirq, &irq_map[virq]);
> 	spin_unlock(&host->revmap_data.tree_lock);
> 

  Cool, that will indeed makes it much easier to have something applicable
to mainline which works with preempt-rt.

> 
> The only advantage of the concurrent radix tree over this model is that
> it can potentially do multiple modification operations at the same time.

  Well in theory that can happen if a module is loaded which creates a mapping
while another one is unloaded at the same time. The time window is pretty narrow,
but still present nonetheless. That's why I chose to use the concurrent version.

> 
> Still, cool that you used it ;-)


  Yep, looked like what was needed until I realized it was not available in
mainline. Nice work though and good paper for explaining it all.

  Sebastien.


