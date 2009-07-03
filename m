Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZGCMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZGCMSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZGCMSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:18:31 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51571 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbZGCMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:18:30 -0400
Subject: [PATCH] kmemleak: Trace the kmalloc_large* functions in slub
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Date: Fri, 03 Jul 2009 13:18:26 +0100
Message-ID: <20090703121825.18771.79975.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2009 12:18:26.0496 (UTC) FILETIME=[5DFA4400:01C9FBD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kmalloc_large() and kmalloc_large_node() functions were missed when
adding the kmemleak hooks to the slub allocator. However, they should be
traced to avoid false positives.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slub_def.h |    2 ++
 mm/slub.c                |   10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 4dcbc2c..c1c862b 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -11,6 +11,7 @@
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
 #include <linux/kmemtrace.h>
+#include <linux/kmemleak.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
@@ -233,6 +234,7 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 	unsigned int order = get_order(size);
 	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
 
+	kmemleak_alloc(ret, size, 1, flags);
 	trace_kmalloc(_THIS_IP_, ret, size, PAGE_SIZE << order, flags);
 
 	return ret;
diff --git a/mm/slub.c b/mm/slub.c
index 819f056..f8d6df8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -21,7 +21,6 @@
 #include <linux/kmemcheck.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
-#include <linux/kmemleak.h>
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
 #include <linux/debugobjects.h>
@@ -2833,13 +2832,15 @@ EXPORT_SYMBOL(__kmalloc);
 static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
 	struct page *page;
+	void *ptr = NULL;
 
 	flags |= __GFP_COMP | __GFP_NOTRACK;
 	page = alloc_pages_node(node, flags, get_order(size));
 	if (page)
-		return page_address(page);
-	else
-		return NULL;
+		ptr = page_address(page);
+
+	kmemleak_alloc(ptr, size, 1, flags);
+	return ptr;
 }
 
 #ifdef CONFIG_NUMA
@@ -2924,6 +2925,7 @@ void kfree(const void *x)
 	page = virt_to_head_page(x);
 	if (unlikely(!PageSlab(page))) {
 		BUG_ON(!PageCompound(page));
+		kmemleak_free(x);
 		put_page(page);
 		return;
 	}

