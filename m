Return-Path: <linux-kernel-owner+w=401wt.eu-S1762492AbXHNPgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762492AbXHNPgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbXHNPfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:35:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40793 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758489AbXHNPfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:35:05 -0400
Message-Id: <20070814153502.000534629@sgi.com>
References: <20070814153021.446917377@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Aug 2007 08:30:26 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 5/9] Save irqflags on taking the mapping lock
Content-Disposition: inline; filename=vmscan_mapping_irqsave
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-14 07:34:55.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-14 08:21:58.000000000 -0700
@@ -381,10 +381,12 @@ static pageout_t pageout(struct page *pa
  */
 int remove_mapping(struct address_space *mapping, struct page *page)
 {
+	unsigned long flags;
+
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
 
-	write_lock_irq(&mapping->tree_lock);
+	write_lock_irqsave(&mapping->tree_lock, flags);
 	/*
 	 * The non racy check for a busy page.
 	 *
@@ -419,19 +421,19 @@ int remove_mapping(struct address_space 
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
-		write_unlock_irq(&mapping->tree_lock);
+		write_unlock_irqrestore(&mapping->tree_lock, flags);
 		swap_free(swap);
 		__put_page(page);	/* The pagecache ref */
 		return 1;
 	}
 
 	__remove_from_page_cache(page);
-	write_unlock_irq(&mapping->tree_lock);
+	write_unlock_irqrestore(&mapping->tree_lock, flags);
 	__put_page(page);
 	return 1;
 
 cannot_free:
-	write_unlock_irq(&mapping->tree_lock);
+	write_unlock_irqrestore(&mapping->tree_lock, flags);
 	return 0;
 }
 

-- 
