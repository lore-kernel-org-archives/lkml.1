Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYKFARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYKFARS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYKFARI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:17:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60691 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbYKFARH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:17:07 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>
Subject: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into pcp
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  6 Nov 2008 09:16:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIGRATE_RESERVE mean that the page is for emergency.
So it shouldn't be cached in pcp.

otherwise, the system have unnecessary memory starvation risk
because other cpu can't use this emergency pages.



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Christoph Lameter <cl@linux-foundation.org>

---
 mm/page_alloc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2008-11-06 06:01:15.000000000 +0900
+++ b/mm/page_alloc.c	2008-11-06 06:27:41.000000000 +0900
@@ -1002,6 +1002,7 @@ static void free_hot_cold_page(struct pa
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
+	int migratetype = get_pageblock_migratetype(page);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -1018,16 +1019,25 @@ static void free_hot_cold_page(struct pa
 	pcp = &zone_pcp(zone, get_cpu())->pcp;
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
+
+	set_page_private(page, migratetype);
+
+	/* the page for emergency shouldn't be cached */
+	if (migratetype == MIGRATE_RESERVE) {
+		free_one_page(zone, page, 0);
+		goto out;
+	}
 	if (cold)
 		list_add_tail(&page->lru, &pcp->list);
 	else
 		list_add(&page->lru, &pcp->list);
-	set_page_private(page, get_pageblock_migratetype(page));
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		free_pages_bulk(zone, pcp->batch, &pcp->list, 0);
 		pcp->count -= pcp->batch;
 	}
+
+out:
 	local_irq_restore(flags);
 	put_cpu();
 }


