Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbZCPRxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbZCPRxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbZCPRva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:51:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51205 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbZCPRv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:51:27 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 06/27] Move check for disabled anti-fragmentation out of fastpath
Date: Mon, 16 Mar 2009 17:53:20 +0000
Message-Id: <1237226020-14057-7-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On low-memory systems, anti-fragmentation gets disabled as there is nothing
it can do and it would just incur overhead shuffling pages between lists
constantly. Currently the check is made in the free page fast path for every
page. This patch moves it to a slow path. On machines with low memory,
there will be small amount of additional overhead as pages get shuffled
between lists but it should quickly settle.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/mmzone.h |    3 ---
 mm/page_alloc.c        |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1aca6ce..ca000b8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -50,9 +50,6 @@ extern int page_group_by_mobility_disabled;
 
 static inline int get_pageblock_migratetype(struct page *page)
 {
-	if (unlikely(page_group_by_mobility_disabled))
-		return MIGRATE_UNMOVABLE;
-
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7ba7705..d815c8f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -171,6 +171,10 @@ int page_group_by_mobility_disabled __read_mostly;
 
 static void set_pageblock_migratetype(struct page *page, int migratetype)
 {
+
+	if (unlikely(page_group_by_mobility_disabled))
+		migratetype = MIGRATE_UNMOVABLE;
+
 	set_pageblock_flags_group(page, (unsigned long)migratetype,
 					PB_migrate, PB_migrate_end);
 }
-- 
1.5.6.5

