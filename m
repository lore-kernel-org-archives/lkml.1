Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbXIXIph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbXIXIph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXIXIpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:45:30 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42942 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbXIXIp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:45:29 -0400
Date: Mon, 24 Sep 2007 10:45:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Rik van Riel <riel@redhat.com>
Subject: [RFC][PATCH] mm: couple rcu and memory reclaim
Message-ID: <20070924104517.7d8126ae@twins>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Just an idea I had, it seems like a good idea to wait for RCU callbacks
in reclaim so that we won't get all of memory stuck there.

If this location is too aggressive we might stick it next to
disable_swap_token().

---
Couple RCU and reclaim.

There could be a lot of memory stuck in RCU callbacks. Wait for RCU to
finish before giving it another go.

Placed in kswapd and not direct reclaim path because kswapd never holds
rcu_read_lock() at this point and can thus not deadlock. Direct reclaim
callers might hold rcu_read_lock() and would suffer from deadlocks if
sync_rcu() were to be called.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c
+++ linux-2.6/mm/vmscan.c
@@ -1435,8 +1435,10 @@ loop_again:
 		unsigned long lru_pages = 0;
 
 		/* The swap token gets in the way of swapout... */
-		if (!priority)
+		if (!priority) {
+			synchronize_rcu();
 			disable_swap_token();
+		}
 
 		all_zones_ok = 1;
 
