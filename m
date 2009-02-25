Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZBYCgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZBYCgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZBYCgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:36:43 -0500
Received: from cmpxchg.org ([85.214.51.133]:38561 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbZBYCgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:36:42 -0500
Date: Wed, 25 Feb 2009 03:38:30 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] mm: move pagevec stripping to save unlock-relock
Message-ID: <20090225023830.GA1611@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In shrink_active_list() after the deactivation loop, we strip buffer
heads from the potentially remaining pages in the pagevec.

Currently, this drops the zone's lru lock for stripping, only to
reacquire it again afterwards to update statistics.

It is not necessary to strip the pages before updating the stats, so
move the whole thing out of the protected region and save the extra
locking.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1298,14 +1298,11 @@ static void shrink_active_list(unsigned 
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 	pgdeactivate += pgmoved;
-	if (buffer_heads_over_limit) {
-		spin_unlock_irq(&zone->lru_lock);
-		pagevec_strip(&pvec);
-		spin_lock_irq(&zone->lru_lock);
-	}
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
 	spin_unlock_irq(&zone->lru_lock);
+	if (buffer_heads_over_limit)
+		pagevec_strip(&pvec);
 	if (vm_swap_full())
 		pagevec_swap_free(&pvec);
 
