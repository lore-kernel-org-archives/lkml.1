Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZLDIof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZLDIof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZLDIoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:44:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50822 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbZLDIod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:44:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] Don't deactivate the page if trylock_page() is failed.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091204173233.5891.A69D9226@jp.fujitsu.com>
References: <20091204173233.5891.A69D9226@jp.fujitsu.com>
Message-Id: <20091204174347.58A0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Dec 2009 17:44:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7635eaa033cfcce7f351b5023952f23f0daffefe Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 4 Dec 2009 12:03:07 +0900
Subject: [PATCH 5/7] Don't deactivate the page if trylock_page() is failed.

Currently, wipe_page_reference() increment refctx->referenced variable
if trylock_page() is failed. but it is meaningless at all.
shrink_active_list() deactivate the page although the page was
referenced. The page shouldn't be deactivated with young bit. it
break reclaim basic theory and decrease reclaim throughput.

This patch introduce new SWAP_AGAIN return value to
wipe_page_reference().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/rmap.c   |    5 ++++-
 mm/vmscan.c |   15 +++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 2f4451b..b84f350 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -539,6 +539,9 @@ static int wipe_page_reference_file(struct page *page,
  *
  * Quick test_and_clear_referenced for all mappings to a page,
  * returns the number of ptes which referenced the page.
+ *
+ * SWAP_SUCCESS  - success to wipe all ptes
+ * SWAP_AGAIN    - temporary busy, try again later
  */
 int wipe_page_reference(struct page *page,
 			struct mem_cgroup *memcg,
@@ -555,7 +558,7 @@ int wipe_page_reference(struct page *page,
 		    (!PageAnon(page) || PageKsm(page))) {
 			we_locked = trylock_page(page);
 			if (!we_locked) {
-				refctx->referenced++;
+				ret = SWAP_AGAIN;
 				goto out;
 			}
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0db9c06..9684e40 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -577,6 +577,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		struct address_space *mapping;
 		struct page *page;
 		int may_enter_fs;
+		int ret;
 		struct page_reference_context refctx = {
 			.is_page_locked = 1,
 		};
@@ -621,7 +622,11 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 				goto keep_locked;
 		}
 
-		wipe_page_reference(page, sc->mem_cgroup, &refctx);
+		ret = wipe_page_reference(page, sc->mem_cgroup, &refctx);
+		if (ret == SWAP_AGAIN)
+			goto keep_locked;
+		VM_BUG_ON(ret != SWAP_SUCCESS);
+
 		/*
 		 * In active use or really unfreeable?  Activate it.
 		 * If page which have PG_mlocked lost isoltation race,
@@ -1326,6 +1331,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	spin_unlock_irq(&zone->lru_lock);
 
 	while (!list_empty(&l_hold)) {
+		int ret;
 		struct page_reference_context refctx = {
 			.is_page_locked = 0,
 		};
@@ -1345,7 +1351,12 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			continue;
 		}
 
-		wipe_page_reference(page, sc->mem_cgroup, &refctx);
+		ret = wipe_page_reference(page, sc->mem_cgroup, &refctx);
+		if (ret == SWAP_AGAIN) {
+			list_add(&page->lru, &l_active);
+			continue;
+		}
+		VM_BUG_ON(ret != SWAP_SUCCESS);
 
 		if (refctx.referenced)
 			nr_rotated++;
-- 
1.6.5.2



