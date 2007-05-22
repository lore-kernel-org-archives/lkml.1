Return-Path: <linux-kernel-owner+w=401wt.eu-S1763100AbXEVHUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763100AbXEVHUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 03:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXEVHUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 03:20:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47128 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbXEVHUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 03:20:43 -0400
Date: Tue, 22 May 2007 17:20:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Move three functions that are only needed for
 CONFIG_MEMORY_HOTPLUG
Message-Id: <20070522172041.dab14ed0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

into the appropriate #ifdef.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/sparse.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/mm/sparse.c b/mm/sparse.c
index 1302f83..fdc1454 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -229,6 +229,27 @@ static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 	return NULL;
 }
 
+/*
+ * Allocate the accumulated non-linear sections, allocate a mem_map
+ * for each and record the physical to section mapping.
+ */
+void __init sparse_init(void)
+{
+	unsigned long pnum;
+	struct page *map;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!valid_section_nr(pnum))
+			continue;
+
+		map = sparse_early_mem_map_alloc(pnum);
+		if (!map)
+			continue;
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
+	}
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
 	struct page *page, *ret;
@@ -269,27 +290,6 @@ static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 }
 
 /*
- * Allocate the accumulated non-linear sections, allocate a mem_map
- * for each and record the physical to section mapping.
- */
-void __init sparse_init(void)
-{
-	unsigned long pnum;
-	struct page *map;
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!valid_section_nr(pnum))
-			continue;
-
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
-			continue;
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
-	}
-}
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-/*
  * returns the number of sections whose mem_maps were properly
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
-- 
1.5.1.4

