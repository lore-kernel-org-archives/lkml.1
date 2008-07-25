Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYGYHtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYGYHtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYGYHth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:49:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:53542 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYGYHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:49:36 -0400
Subject: Re: [PATCH 2/2][RT] powerpc - Make the irq reverse mapping radix
	tree lockless
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastien Dugue <sebastien.dugue@bull.net>
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
In-Reply-To: <20080724141839.477de30b@bull.net>
References: <20080724122352.3bc76bda@bull.net>
	 <20080724125044.53b604cb@bull.net>
	 <200807242111.35338.nickpiggin@yahoo.com.au>
	 <20080724141839.477de30b@bull.net>
Content-Type: text/plain; charset=utf-8
Date: Fri, 25 Jul 2008 09:49:37 +0200
Message-Id: <1216972177.7257.351.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 14:18 +0200, Sebastien Dugue wrote:
> On Thu, 24 Jul 2008 21:11:34 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > On Thursday 24 July 2008 20:50, Sebastien Dugue wrote:
> > > From: Sebastien Dugue <sebastien.dugue@bull.net>
> > > Date: Tue, 22 Jul 2008 11:56:41 +0200
> > > Subject: [PATCH][RT] powerpc - Make the irq reverse mapping radix tree
> > > lockless
> > >
> > >   The radix tree used by interrupt controllers for their irq reverse
> > > mapping (currently only the XICS found on pSeries) have a complex locking
> > > scheme dating back to before the advent of the concurrent radix tree on
> > > preempt-rt.
> > >
> > >   Take advantage of this and of the fact that the items of the tree are
> > > pointers to a static array (irq_map) elements which can never go under us
> > > to simplify the locking.
> > >
> > >   Concurrency between readers and writers are handled by the intrinsic
> > > properties of the concurrent radix tree. Concurrency between the tree
> > > initialization which is done asynchronously with readers and writers access
> > > is handled via an atomic variable (revmap_trees_allocated) set when the
> > > tree has been initialized and checked before any reader or writer access
> > > just like we used to check for tree.gfp_mask != 0 before.
> > 
> > Hmm, RCU radix tree is in mainline too for quite a while. I thought
> > Ben had already converted this code over ages ago...
> 
>   Mainline does not have the concurrent radix tree which this patch
> is based on, but maybe it's overkill and the RCU radix tree is enough.
> Not sure, will have to think about it a bit more.

Should be. The model of the concurrent radix tree can be mapped to
spinlock + rcu radix tree.

So instead of:

> ﻿+               DEFINE_RADIX_TREE_CONTEXT(ctx, tree);
> +               radix_tree_lock(&ctx);
> +               radix_tree_insert(ctx.tree, hwirq, &irq_map[virq]);
> +               radix_tree_unlock(&ctx);


you then write:

	spin_lock(&host->revmap_data.tree_lock);
	radix_tree_insert(&host->revmap_data.tree, hwirq, &irq_map[virq]);
	spin_unlock(&host->revmap_data.tree_lock);


The only advantage of the concurrent radix tree over this model is that
it can potentially do multiple modification operations at the same time.

Still, cool that you used it ;-)

