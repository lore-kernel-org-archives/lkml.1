Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbXHTV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbXHTV4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXHTVxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:53:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59796 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751559AbXHTVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:18 -0400
Message-Id: <20070820215317.441134723@sgi.com>
References: <20070820215040.937296148@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 14:50:47 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 7/7] Switch of PF_MEMALLOC during writeout
Content-Disposition: inline; filename=nopfmemalloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch off PF_MEMALLOC during both direct and kswapd reclaim.

This works because we are not holding any locks at that point because
reclaim is essentially complete. The write occurs when the memory on
the zones is at the high water mark so it is unlikely that writeout
will get into trouble. If so then reclaim can be called recursively to
reclaim more pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-19 23:53:47.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-19 23:55:29.000000000 -0700
@@ -1227,8 +1227,16 @@ out:
 
 		zone->prev_priority = priority;
 	}
+
+	/*
+	 * Trigger writeout. Drop PF_MEMALLOC for writeback
+	 * since we are holding no locks. Callbacks into
+	 * reclaim should be fine
+	 */
+	current->flags &= ~PF_MEMALLOC;
 	nr_reclaimed += shrink_page_list(&laundry, &sc, NULL);
 	release_lru_pages(&laundry);
+	current->flags |= PF_MEMALLOC;
 	return ret;
 }
 
@@ -1406,8 +1414,10 @@ out:
 
 		goto loop_again;
 	}
+	current->flags &= ~PF_MEMALLOC;
 	nr_reclaimed += shrink_page_list(&laundry, &sc, NULL);
 	release_lru_pages(&laundry);
+	current->flags |= PF_MEMALLOC;
 	return nr_reclaimed;
 }
 

-- 
