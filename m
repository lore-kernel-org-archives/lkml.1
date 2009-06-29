Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZF2Br2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZF2Br2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZF2BrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:47:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:1587 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZF2BrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,305,1243839600"; 
   d="scan'208";a="426045294"
Subject: [PATCH 2/5]memhp: exclude isolated page from pco page alloc
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
Content-Type: text/plain
Date: Mon, 29 Jun 2009 09:47:12 +0800
Message-Id: <1246240032.26292.18.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pages marked as isolated should not be allocated again. If such
pages reside in pcp list, they can be allocated too, so there is
a ping-pong memory offline frees some pages to pcp list and the
pages get allocated and then memory offline frees them again,
this loop will happen again and again.

This should have no impact in normal code path, because in normal
code path, pages in pcp list aren't isolated, and below loop will
break in the first entry.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 mm/page_alloc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2009-06-26 09:41:10.000000000 +0800
+++ linux/mm/page_alloc.c	2009-06-26 09:44:07.000000000 +0800
@@ -1137,9 +1137,18 @@ again:
 
 		/* Allocate more to the pcp list if necessary */
 		if (unlikely(&page->lru == &pcp->list)) {
+			int get_one_page = 0;
 			pcp->count += rmqueue_bulk(zone, 0,
 					pcp->batch, &pcp->list, migratetype);
-			page = list_entry(pcp->list.next, struct page, lru);
+			list_for_each_entry(page, &pcp->list, lru) {
+				if (get_pageblock_migratetype(page) !=
+				    MIGRATE_ISOLATE) {
+					get_one_page = 1;
+					break;
+				}
+			}
+			if (!get_one_page)
+				goto failed;
 		}
 
 		list_del(&page->lru);


