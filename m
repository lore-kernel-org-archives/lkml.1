Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXEQCjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXEQCjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 22:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbXEQCjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 22:39:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:9517 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbXEQCjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 22:39:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,545,1170662400"; 
   d="scan'208";a="244070889"
Subject: [Patch] Allocate sparsemem memmap above 4G on X86_64
From: Zou Nan hai <nanhai.zou@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ak@suse.de, suresh.b.siddha@intel.com, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Organization: 
Message-Id: <1179369607.4103.158.camel@linux-znh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 17 May 2007 10:40:07 +0800
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On system with huge amount of physical memory. 
VFS cache and memory memmap may eat all available system memory under
4G, then system may fail to allocated swiotlb bounce buffer. 

There was a fix in arch/x86_64/mm/numa.c, but that fix does not cover
sparsemem model.
This patch add fix to sparsemem model.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Acked-by: Siddha, Suresh <suresh.b.siddha@intel.com>
---
 include/asm-x86_64/mmzone.h |    5 +++++
 include/linux/bootmem.h     |    3 +++
 mm/sparse.c                 |    5 +++++
 3 files changed, 13 insertions(+)

diff -Nraup a/include/asm-x86_64/mmzone.h b/include/asm-x86_64/mmzone.h
--- a/include/asm-x86_64/mmzone.h	2007-05-17 09:38:02.000000000 +0800
+++ b/include/asm-x86_64/mmzone.h	2007-05-17 09:54:10.000000000 +0800
@@ -52,5 +52,10 @@ extern int pfn_valid(unsigned long pfn);
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1uL))
 #endif
 
+#define ARCH_HAS_ALLOC_BOOTMEM_HIGH_NODE 1
+#define alloc_bootmem_high_node(pgdat,size) \
+({__alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);})
+
+
 #endif
 #endif
diff -Nraup a/include/linux/bootmem.h b/include/linux/bootmem.h
--- a/include/linux/bootmem.h	2007-05-17 09:38:02.000000000 +0800
+++ b/include/linux/bootmem.h	2007-05-17 09:37:00.000000000 +0800
@@ -131,5 +131,8 @@ extern void *alloc_large_system_hash(con
 #endif
 extern int hashdist;		/* Distribute hashes across NUMA nodes? */
 
+#ifndef ARCH_HAS_ALLOC_BOOTMEM_HIGH_NODE
+#define alloc_bootmem_high_node(pgdat, size) ({NULL;})
+#endif
 
 #endif /* _LINUX_BOOTMEM_H */
diff -Nraup a/mm/sparse.c b/mm/sparse.c
--- a/mm/sparse.c	2007-05-17 09:38:03.000000000 +0800
+++ b/mm/sparse.c	2007-05-17 09:54:27.000000000 +0800
@@ -219,6 +219,11 @@ static struct page __init *sparse_early_
 	if (map)
 		return map;
 
+	map = alloc_bootmem_high_node(NODE_DATA(nid),
+			sizeof(struct page) * PAGES_PER_SECTION);
+        if (map)
+                return map;
+
 	map = alloc_bootmem_node(NODE_DATA(nid),
 			sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)




