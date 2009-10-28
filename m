Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbZJ1GzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbZJ1GzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbZJ1Gy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:54:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:54085 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507AbZJ1Gy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:26 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 07/10] bootmem: add free_bootmem_late
Date: Wed, 28 Oct 2009 15:47:41 +0900
Message-Id: <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Add a new function for freeing bootmem after the bootmem allocator has
been released and the unreserved pages given to the page allocator.
This allows us to reserve bootmem and then release it if we later
discover it was not needed.

Reviewed-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/bootmem.h |    1 +
 mm/bootmem.c            |   43 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index dd97fb8..b10ec49 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -53,6 +53,7 @@ extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
 			      unsigned long size);
 extern void free_bootmem(unsigned long addr, unsigned long size);
+extern void free_bootmem_late(unsigned long addr, unsigned long size);
 
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 94ef2e7..6c04e6e 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -151,7 +151,9 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
  *
  * This will free the pages in the range @start to @end, making them
  * available to the page allocator.  The @map will be used to skip
- * reserved pages.  Returns the count of pages freed.
+ * reserved pages.  In the case that @map is NULL, the bootmem allocator
+ * is already free and the range is contiguous.  Returns the count of
+ * pages freed.
  */
 static unsigned long __init free_bootmem_pages(unsigned long start,
 					       unsigned long end,
@@ -164,13 +166,23 @@ static unsigned long __init free_bootmem_pages(unsigned long start,
 	 * If the start is aligned to the machines wordsize, we might
 	 * be able to free pages in bulks of that order.
 	 */
-	aligned = !(start & (BITS_PER_LONG - 1));
+	if (map)
+		aligned = !(start & (BITS_PER_LONG - 1));
+	else
+		aligned = 1;
 
 	for (cursor = start; cursor < end; cursor += BITS_PER_LONG) {
-		unsigned long idx, vec;
+		unsigned long vec;
 
-		idx = cursor - start;
-		vec = ~map[idx / BITS_PER_LONG];
+		if (map) {
+			unsigned long idx = cursor - start;
+			vec = ~map[idx / BITS_PER_LONG];
+		} else {
+			if (end - cursor >= BITS_PER_LONG)
+				vec = ~0UL;
+			else
+				vec = (1UL << (end - cursor)) - 1;
+		}
 
 		if (aligned && vec == ~0UL && cursor + BITS_PER_LONG < end) {
 			int order = ilog2(BITS_PER_LONG);
@@ -387,6 +399,27 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 }
 
 /**
+ * free_bootmem_late - free bootmem pages directly to page allocator
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * This is only useful when the bootmem allocator has already been torn
+ * down, but we are still initializing the system.  Pages are given directly
+ * to the page allocator, no bootmem metadata is updated because it is gone.
+ */
+void __init free_bootmem_late(unsigned long addr, unsigned long size)
+{
+	unsigned long start, end;
+
+	kmemleak_free_part(__va(addr), size);
+
+	start = PFN_UP(addr);
+	end = PFN_DOWN(addr + size);
+
+	totalram_pages += free_bootmem_pages(start, end, NULL);
+}
+
+/**
  * reserve_bootmem_node - mark a page range as reserved
  * @pgdat: node the range resides on
  * @physaddr: starting address of the range
-- 
1.5.6.5

