Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYHUCh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYHUCh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYHUCg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:36:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:33118 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbYHUCg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:36:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,243,1217833200"; 
   d="scan'208";a="35952053"
Subject: [3/4] add agp_generic_destroy_pages()
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 10:46:17 +0800
Message-Id: <1219286777.18007.41.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add agp_generic_destroy_pages(), it uses new pageattr array interface API. 

Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/char/agp/agp.h       |    2 +
 drivers/char/agp/generic.c   |   55 ++++++++++++++++++++++++++++++++++++-------
 drivers/char/agp/intel-agp.c |   14 ++++++++++
 3 files changed, 63 insertions(+), 8 deletions(-)

Index: linux/drivers/char/agp/agp.h
===================================================================
--- linux.orig/drivers/char/agp/agp.h	2008-08-21 10:00:05.000000000 +0800
+++ linux/drivers/char/agp/agp.h	2008-08-21 10:01:40.000000000 +0800
@@ -118,6 +118,7 @@ struct agp_bridge_driver {
 	void *(*agp_alloc_page)(struct agp_bridge_data *);
 	int (*agp_alloc_pages)(struct agp_bridge_data *, struct agp_memory *, size_t);
 	void (*agp_destroy_page)(void *, int flags);
+	void (*agp_destroy_pages)(struct agp_memory *);
 	int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
 	void (*chipset_flush)(struct agp_bridge_data *);
 };
@@ -281,6 +282,7 @@ void *agp_generic_alloc_page(struct agp_
 int agp_generic_alloc_pages(struct agp_bridge_data *agp_bridge,
 			    struct agp_memory *memory, size_t page_count);
 void agp_generic_destroy_page(void *addr, int flags);
+void agp_generic_destroy_pages(struct agp_memory *memory);
 void agp_free_key(int key);
 int agp_num_entries(void);
 u32 agp_collect_device_status(struct agp_bridge_data *bridge, u32 mode, u32 command);
Index: linux/drivers/char/agp/generic.c
===================================================================
--- linux.orig/drivers/char/agp/generic.c	2008-08-21 10:01:34.000000000 +0800
+++ linux/drivers/char/agp/generic.c	2008-08-21 10:01:40.000000000 +0800
@@ -201,14 +201,22 @@ void agp_free_memory(struct agp_memory *
 		return;
 	}
 	if (curr->page_count != 0) {
-		for (i = 0; i < curr->page_count; i++) {
-			curr->memory[i] = (unsigned long)gart_to_virt(curr->memory[i]);
-			curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
-							       AGP_PAGE_DESTROY_UNMAP);
-		}
-		for (i = 0; i < curr->page_count; i++) {
-			curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
-							       AGP_PAGE_DESTROY_FREE);
+		if (curr->bridge->driver->agp_destroy_pages) {
+			curr->bridge->driver->agp_destroy_pages(curr);
+		} else {
+
+			for (i = 0; i < curr->page_count; i++) {
+				curr->memory[i] = (unsigned long)gart_to_virt(
+					curr->memory[i]);
+				curr->bridge->driver->agp_destroy_page(
+					(void *)curr->memory[i],
+					AGP_PAGE_DESTROY_UNMAP);
+			}
+			for (i = 0; i < curr->page_count; i++) {
+				curr->bridge->driver->agp_destroy_page(
+					(void *)curr->memory[i],
+					AGP_PAGE_DESTROY_FREE);
+			}
 		}
 	}
 	agp_free_key(curr->key);
@@ -1261,6 +1269,37 @@ void *agp_generic_alloc_page(struct agp_
 }
 EXPORT_SYMBOL(agp_generic_alloc_page);
 
+void agp_generic_destroy_pages(struct agp_memory *mem)
+{
+	int i;
+	void *addr;
+	struct page *page;
+
+	if (!mem)
+		return;
+
+	for (i = 0; i < mem->page_count; i++)
+		mem->memory[i] = (unsigned long)gart_to_virt(mem->memory[i]);
+
+#ifdef CONFIG_X86
+	set_memory_array_wb(mem->memory, mem->page_count);
+#endif
+
+	for (i = 0; i < mem->page_count; i++) {
+		addr = (void *)mem->memory[i];
+		page = virt_to_page(addr);
+
+#ifndef CONFIG_X86
+		unmap_page_from_agp(page);
+#endif
+
+		put_page(page);
+		free_page((unsigned long)addr);
+		atomic_dec(&agp_bridge->current_memory_agp);
+		mem->memory[i] = 0;
+	}
+}
+EXPORT_SYMBOL(agp_generic_destroy_pages);
 
 void agp_generic_destroy_page(void *addr, int flags)
 {
Index: linux/drivers/char/agp/intel-agp.c
===================================================================
--- linux.orig/drivers/char/agp/intel-agp.c	2008-08-21 10:00:05.000000000 +0800
+++ linux/drivers/char/agp/intel-agp.c	2008-08-21 10:01:41.000000000 +0800
@@ -1713,6 +1713,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1739,6 +1740,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1764,6 +1766,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type	= agp_generic_type_to_mask_type,
 };
 
@@ -1790,6 +1793,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i830_chipset_flush,
 };
@@ -1816,6 +1820,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1841,6 +1846,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1866,6 +1872,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1891,6 +1898,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.chipset_flush		= intel_i830_chipset_flush,
 };
@@ -1917,6 +1925,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1942,6 +1951,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1968,6 +1978,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
 };
@@ -1995,6 +2006,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type	= intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
 };
@@ -2021,6 +2033,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -2047,6 +2060,7 @@ static const struct agp_bridge_driver in
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type	= intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
 };


