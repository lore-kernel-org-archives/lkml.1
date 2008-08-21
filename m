Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYHUChk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYHUChk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYHUCgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:36:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:23041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbYHUCgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:36:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,243,1217833200"; 
   d="scan'208";a="327901257"
Subject: [2/4]add agp_generic_alloc_pages()
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 10:46:11 +0800
Message-Id: <1219286771.18007.40.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add agp_generic_alloc_pages(), it uses new pageattr array interface API.

Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/char/agp/agp.h       |    3 +++
 drivers/char/agp/generic.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/char/agp/intel-agp.c |   14 ++++++++++++++
 3 files changed, 59 insertions(+)

Index: linux/drivers/char/agp/agp.h
===================================================================
--- linux.orig/drivers/char/agp/agp.h	2008-08-20 17:21:28.000000000 +0800
+++ linux/drivers/char/agp/agp.h	2008-08-21 10:07:39.000000000 +0800
@@ -116,6 +116,7 @@ struct agp_bridge_driver {
 	struct agp_memory *(*alloc_by_type) (size_t, int);
 	void (*free_by_type)(struct agp_memory *);
 	void *(*agp_alloc_page)(struct agp_bridge_data *);
+	int (*agp_alloc_pages)(struct agp_bridge_data *, struct agp_memory *, size_t);
 	void (*agp_destroy_page)(void *, int flags);
 	int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
 	void (*chipset_flush)(struct agp_bridge_data *);
@@ -277,6 +278,8 @@ int agp_generic_remove_memory(struct agp
 struct agp_memory *agp_generic_alloc_by_type(size_t page_count, int type);
 void agp_generic_free_by_type(struct agp_memory *curr);
 void *agp_generic_alloc_page(struct agp_bridge_data *bridge);
+int agp_generic_alloc_pages(struct agp_bridge_data *agp_bridge,
+			    struct agp_memory *memory, size_t page_count);
 void agp_generic_destroy_page(void *addr, int flags);
 void agp_free_key(int key);
 int agp_num_entries(void);
Index: linux/drivers/char/agp/generic.c
===================================================================
--- linux.orig/drivers/char/agp/generic.c	2008-08-20 17:21:28.000000000 +0800
+++ linux/drivers/char/agp/generic.c	2008-08-21 10:07:39.000000000 +0800
@@ -264,6 +264,15 @@ struct agp_memory *agp_allocate_memory(s
 	if (new == NULL)
 		return NULL;
 
+	if (bridge->driver->agp_alloc_pages) {
+		if (bridge->driver->agp_alloc_pages(bridge, new, page_count)) {
+			agp_free_memory(new);
+			return NULL;
+		}
+		new->bridge = bridge;
+		return new;
+	}
+
 	for (i = 0; i < page_count; i++) {
 		void *addr = bridge->driver->agp_alloc_page(bridge);
 
@@ -1203,6 +1212,39 @@ EXPORT_SYMBOL(agp_generic_alloc_user);
  * against a maximum value.
  */
 
+int agp_generic_alloc_pages(struct agp_bridge_data *bridge, struct agp_memory *mem, size_t num_pages)
+{
+	struct page * page;
+	int i, ret = -ENOMEM;
+
+	for (i = 0; i < num_pages; i++) {
+		page = alloc_page(GFP_KERNEL | GFP_DMA32);
+		/* agp_free_memory() needs gart address */
+		if (page == NULL)
+			goto out;
+
+#ifndef CONFIG_X86
+		map_page_into_agp(page);
+#endif
+		get_page(page);
+		atomic_inc(&agp_bridge->current_memory_agp);
+
+		/* set_memory_array_uc() needs virtual address */
+		mem->memory[i] = (unsigned long)page_address(page);
+		mem->page_count++;
+	}
+
+#ifdef CONFIG_X86
+	set_memory_array_uc(mem->memory, num_pages);
+#endif
+	ret = 0;
+out:
+	for (i = 0; i < mem->page_count; i++)
+		mem->memory[i] = virt_to_gart((void *)mem->memory[i]);
+	return ret;
+}
+EXPORT_SYMBOL(agp_generic_alloc_pages);
+
 void *agp_generic_alloc_page(struct agp_bridge_data *bridge)
 {
 	struct page * page;
Index: linux/drivers/char/agp/intel-agp.c
===================================================================
--- linux.orig/drivers/char/agp/intel-agp.c	2008-08-20 17:21:28.000000000 +0800
+++ linux/drivers/char/agp/intel-agp.c	2008-08-21 10:07:39.000000000 +0800
@@ -1711,6 +1711,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
@@ -1736,6 +1737,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= intel_i810_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
@@ -1760,6 +1762,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type	= agp_generic_type_to_mask_type,
 };
@@ -1785,6 +1788,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= intel_i830_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i830_chipset_flush,
@@ -1810,6 +1814,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
@@ -1834,6 +1839,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
@@ -1858,6 +1864,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
@@ -1882,6 +1889,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.chipset_flush		= intel_i830_chipset_flush,
@@ -1907,6 +1915,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
@@ -1931,6 +1940,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
@@ -1956,6 +1966,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= intel_i830_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
@@ -1982,6 +1993,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= intel_i830_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type	= intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
@@ -2007,6 +2019,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
@@ -2032,6 +2045,7 @@ static const struct agp_bridge_driver in
 	.alloc_by_type		= intel_i830_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
 	.agp_type_to_mask_type	= intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,


