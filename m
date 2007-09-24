Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbXIXM7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbXIXM7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXIXM7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:59:07 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47225 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbXIXM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:59:06 -0400
Date: Mon, 24 Sep 2007 14:58:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC][PATCH] mm: couple rcu and memory reclaim
Message-ID: <20070924145855.662b1489@twins>
In-Reply-To: <46F7B21E.3030007@linux.vnet.ibm.com>
References: <20070924104517.7d8126ae@twins>
	<46F7948B.7000802@linux.vnet.ibm.com>
	<20070924130616.4141a084@twins>
	<46F79DE7.40402@linux.vnet.ibm.com>
	<20070924135035.1e02d4fa@twins>
	<46F7B21E.3030007@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 18:18:30 +0530 Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:

> Peter Zijlstra wrote:
> >>> Only kswapd can do this, direct reclaim has deadlock potential.
> >> Yes, but not in all cases, do you want to add any gfp_mask
> >> based smartness for direct reclaim?
> > 
> > gfp_mask doesn't carry the needed information. It depends on whether
> > the current context holds a rcu_read_lock().
> > 
> 
> What I meant was that nobody would hold rcu_read_lock() and pass
> gfp_mask of GFP_KERNEL in scan_control or to do_try_to_free_pages()
> 
> > so something like:
> > 
> >    rcu_read_lock()
> >    foo = kmalloc(sizeof(foo))
> 
> At this point, you really can't use GFP_KERNEL, since rcu_read_lock()
> disables pre-emption in the current kernel, ideally you should see
> a might_sleep() BUG.
> 
> >       new_slab()
> >         __alloc_pages()
> >           try_to_free_pages()
> >             synchronise_rcu() <-- deadlock
> >    rcu_read_unlock()

I guess I've been using preemptibe rcu for way too long. Would need to
clean up some of -rt to make this true there, but should be doable
indeed.

