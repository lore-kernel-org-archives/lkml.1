Return-Path: <linux-kernel-owner+w=401wt.eu-S1766863AbXDSQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766863AbXDSQfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766866AbXDSQfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:35:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51423 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766862AbXDSQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:36 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070419163535.11948.91100.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 6/8] Account for pages in the page cache in terms of base pages
Date: Thu, 19 Apr 2007 09:35:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache: Account for higher order pages

NR_FILE_PAGES now counts pages of different order. Maybe we need to
account in base page sized pages? If so then we need to change
the way we update the counters. Note that the same would have to be
done for other counters.

Signed-off-by: Christoph Lameter <clameter@sgi.com>


---
 mm/filemap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-19 09:11:13.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-19 09:14:16.000000000 -0700
@@ -119,7 +119,8 @@ void __remove_from_page_cache(struct pag
 	radix_tree_delete(&mapping->page_tree, page->index);
 	page->mapping = NULL;
 	mapping->nrpages--;
-	__dec_zone_page_state(page, NR_FILE_PAGES);
+	__mod_zone_page_state(page_zone(page), NR_FILE_PAGES,
+			-(1 << mapping->order));
 }
 
 void remove_from_page_cache(struct page *page)
@@ -448,7 +449,8 @@ int add_to_page_cache(struct page *page,
 			page->mapping = mapping;
 			page->index = offset;
 			mapping->nrpages++;
-			__inc_zone_page_state(page, NR_FILE_PAGES);
+			__mod_zone_page_state(page_zone(page), NR_FILE_PAGES,
+					1 << mappig->order);
 		}
 		write_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
