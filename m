Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbXIXLuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbXIXLuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbXIXLup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:50:45 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43026 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbXIXLuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:50:44 -0400
Date: Mon, 24 Sep 2007 13:50:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC][PATCH] mm: couple rcu and memory reclaim
Message-ID: <20070924135035.1e02d4fa@twins>
In-Reply-To: <46F79DE7.40402@linux.vnet.ibm.com>
References: <20070924104517.7d8126ae@twins>
	<46F7948B.7000802@linux.vnet.ibm.com>
	<20070924130616.4141a084@twins>
	<46F79DE7.40402@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 16:52:15 +0530 Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:

> Peter Zijlstra wrote:
> > On Mon, 24 Sep 2007 16:12:19 +0530 Balbir Singh
> > <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> Peter Zijlstra wrote:
> >>> Just an idea I had, it seems like a good idea to wait for RCU callbacks
> >>> in reclaim so that we won't get all of memory stuck there.
> >>>
> >>> If this location is too aggressive we might stick it next to
> >>> disable_swap_token().
> >>>
> >>> ---
> >>> Couple RCU and reclaim.
> >>>
> >>> There could be a lot of memory stuck in RCU callbacks. Wait for RCU to
> >>> finish before giving it another go.
> >>>
> >>> Placed in kswapd and not direct reclaim path because kswapd never holds
> >>> rcu_read_lock() at this point and can thus not deadlock. Direct reclaim
> >>> callers might hold rcu_read_lock() and would suffer from deadlocks if
> >>> sync_rcu() were to be called.
> >>>
> >>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >>> ---

---
 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c
+++ linux-2.6/mm/vmscan.c
@@ -1527,8 +1527,10 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
+		if (total_scanned && priority < DEF_PRIORITY - 2) {
+			synchronize_rcu();
 			congestion_wait(WRITE, HZ/10);
+		}
 
 		/*
 		 * We do this so kswapd doesn't build up large priorities for

> > Only kswapd can do this, direct reclaim has deadlock potential.
> 
> Yes, but not in all cases, do you want to add any gfp_mask
> based smartness for direct reclaim?

gfp_mask doesn't carry the needed information. It depends on whether
the current context holds a rcu_read_lock().

so something like:

   rcu_read_lock()
   foo = kmalloc(sizeof(foo))
      new_slab()
        __alloc_pages()
          try_to_free_pages()
            synchronise_rcu() <-- deadlock
   rcu_read_unlock()
