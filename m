Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbXKGHPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbXKGHPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 02:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbXKGHPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 02:15:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:46872 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbXKGHPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 02:15:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,382,1188802800"; 
   d="scan'208";a="197613854"
Subject: [Patch] Allocate sparse vmemmap block above 4G
From: Zou Nan hai <nanhai.zou@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Suresh.b.siddha@intel.com
Content-Type: text/plain
Organization: 
Message-Id: <1194419267.3046.1412.camel@linux-znh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 07 Nov 2007 15:07:47 +0800
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Try to allocate sparse vmemmap block above 4G on x64 system.

On some single node x64 system with huge amount of physical memory e.g >
64G. the memmap size maybe very big. 

If the memmap is allocated from low pages, it may occupies too much
memory below 4G. 
then swiotlb could fail to reserve bounce buffer under 4G which will
lead to boot failure.

This patch will first try to allocate memmap memory above 4G in sparse
vmemmap code. 
If it failed, it will allocate memmap above MAX_DMA_ADDRESS. 
This patch is against 2.6.24-rc1-git14

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>


diff -Nraup a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c	2007-11-06 15:16:12.000000000 +0800
+++ b/arch/x86/mm/init_64.c	2007-11-06 15:55:50.000000000 +0800
@@ -448,6 +448,13 @@ void online_page(struct page *page)
 	num_physpages++;
 }
 
+void * __meminit alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size,
+        unsigned long align)
+{
+        return __alloc_bootmem_core(pgdat->bdata, size,
+                        align, (4UL*1024*1024*1024), 0, 1);
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * Memory is added always to NORMAL zone. This means you will never get
diff -Nraup a/include/linux/bootmem.h b/include/linux/bootmem.h
--- a/include/linux/bootmem.h	2007-11-06 16:06:31.000000000 +0800
+++ b/include/linux/bootmem.h	2007-11-06 15:50:36.000000000 +0800
@@ -61,6 +61,10 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long limit,
 				  int strict_goal);
 
+extern void *alloc_bootmem_high_node(pg_data_t *pgdat,
+                unsigned long size,
+                unsigned long align);
+
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 extern void reserve_bootmem(unsigned long addr, unsigned long size);
 #define alloc_bootmem(x) \
diff -Nraup a/mm/bootmem.c b/mm/bootmem.c
--- a/mm/bootmem.c	2007-11-06 16:06:31.000000000 +0800
+++ b/mm/bootmem.c	2007-11-06 15:49:20.000000000 +0800
@@ -492,3 +492,11 @@ void * __init __alloc_bootmem_low_node(p
 	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
 				    ARCH_LOW_ADDRESS_LIMIT, 0);
 }
+
+__attribute__((weak)) __meminit
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size,
+        unsigned long align)
+{
+        return NULL;
+}
+
diff -Nraup a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c	2007-11-06 15:16:12.000000000 +0800
+++ b/mm/sparse-vmemmap.c	2007-11-06 16:08:52.000000000 +0800
@@ -43,9 +43,13 @@ void * __meminit vmemmap_alloc_block(uns
 		if (page)
 			return page_address(page);
 		return NULL;
-	} else
+	} else {
+		void *p = alloc_bootmem_high_node(NODE_DATA(node), size, size);
+		if (p)
+			return p;
 		return __alloc_bootmem_node(NODE_DATA(node), size, size,
 				__pa(MAX_DMA_ADDRESS));
+	}
 }
 
 void __meminit vmemmap_verify(pte_t *pte, int node,


