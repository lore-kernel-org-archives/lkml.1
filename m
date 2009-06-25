Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZFYMB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZFYMB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZFYMBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:01:40 -0400
Received: from nox.protox.org ([88.191.38.29]:51091 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbZFYMBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:01:38 -0400
Subject: TTM page pool allocator
From: Jerome Glisse <glisse@freedesktop.org>
To: thomas@shipmail.org, Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: multipart/mixed; boundary="=-d9MaQFk/Et/qjR/4w4wU"
Date: Thu, 25 Jun 2009 14:01:38 +0200
Message-Id: <1245931298.13359.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d9MaQFk/Et/qjR/4w4wU
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Thomas i attach a reworked page pool allocator based on Dave works,
this one should be ok with ttm cache status tracking. It definitely
helps on AGP system, now the bottleneck is in mesa vertex's dma
allocation.

Cheers,
Jerome

--=-d9MaQFk/Et/qjR/4w4wU
Content-Disposition: attachment; filename="0001-ttm-add-pool-wc-uc-page-allocator.patch"
Content-Type: text/x-patch; name="0001-ttm-add-pool-wc-uc-page-allocator.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From d2581e2a97e9c694fd1238f1a5652e1f385b5636 Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Wed, 24 Jun 2009 16:31:43 +1000
Subject: [PATCH] ttm: add pool wc/uc page allocator

On AGP system we might allocate/free routinely uncached or wc memory,
changing page from cached (wb) to uc or wc is very expensive and involves
a lot of flushing. To improve performance this allocator use a pool
of uc,wc pages.

Currently each pool (wc, uc) is 256 pages big, improvement would be
to tweak this according to memory pressure so we can give back memory
to system.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/ttm/Makefile         |    2 +-
 drivers/gpu/drm/ttm/ttm_memory.c     |    3 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c |  255 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_page_alloc.h |   43 ++++++
 drivers/gpu/drm/ttm/ttm_tt.c         |   42 +++++-
 include/drm/ttm/ttm_bo_driver.h      |    6 +
 6 files changed, 342 insertions(+), 9 deletions(-)
 create mode 100644 drivers/gpu/drm/ttm/ttm_page_alloc.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_page_alloc.h

diff --git a/drivers/gpu/drm/ttm/Makefile b/drivers/gpu/drm/ttm/Makefile
index b0a9de7..93e002c 100644
--- a/drivers/gpu/drm/ttm/Makefile
+++ b/drivers/gpu/drm/ttm/Makefile
@@ -3,6 +3,6 @@
 
 ccflags-y := -Iinclude/drm
 ttm-y := ttm_agp_backend.o ttm_memory.o ttm_tt.o ttm_bo.o \
-	ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o
+	ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o ttm_page_alloc.o
 
 obj-$(CONFIG_DRM_TTM) += ttm.o
diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index 87323d4..6da4a08 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -32,6 +32,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 
+#include "ttm_page_alloc.h"
 #define TTM_PFX "[TTM] "
 #define TTM_MEMORY_ALLOC_RETRIES 4
 
@@ -124,6 +125,7 @@ int ttm_mem_global_init(struct ttm_mem_global *glob)
 	printk(KERN_INFO TTM_PFX "TTM available object memory: %llu MiB\n",
 	       glob->max_memory >> 20);
 
+	ttm_page_alloc_init();
 	return 0;
 }
 EXPORT_SYMBOL(ttm_mem_global_init);
@@ -135,6 +137,7 @@ void ttm_mem_global_release(struct ttm_mem_global *glob)
 	flush_workqueue(glob->swap_queue);
 	destroy_workqueue(glob->swap_queue);
 	glob->swap_queue = NULL;
+	ttm_page_alloc_fini();
 }
 EXPORT_SYMBOL(ttm_mem_global_release);
 
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
new file mode 100644
index 0000000..f841637
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -0,0 +1,255 @@
+/*
+ * Copyright (c) Red Hat Inc.
+
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sub license,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Dave Airlie <airlied@redhat.com>
+ */
+
+/* simple list based uncached page allocator
+ * - Add chunks of 1MB to the allocator at a time.
+ * - Use page->lru to keep a free list
+ * - doesn't track currently in use pages
+ *
+ *  TODO: Add shrinker support
+ */
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/mm_types.h>
+
+#include <asm/agp.h>
+#include "ttm/ttm_bo_driver.h"
+#include "ttm_page_alloc.h"
+
+static struct list_head wc_free_list;
+static struct list_head uc_free_list;
+
+static struct mutex page_alloc_mutex;
+static int page_alloc_inited;
+
+struct ttm_page_alloc_usage ttm_page_alloc_data;
+
+/* add 1MB at a time */
+#define NUM_PAGES_TO_ADD 256
+
+static inline void ttm_page_put(struct page *page, bool setwb)
+{
+#ifdef CONFIG_X86
+	if (setwb && !PageHighMem(page)) {
+		set_memory_wb((unsigned long)page_address(page), 1);
+	}
+#else
+	if (setwb) {
+		/* This is a generic interface on non x86 to handle
+		 * wc/uc page */
+		unmap_page_from_agp(page);
+	}
+#endif
+	put_page(page);
+	__free_page(page);
+}
+
+static int ttm_add_pages_locked(int num_pages, int flags)
+{
+	struct page *page;
+	int gfp_flags = GFP_HIGHUSER;
+	int i, cflag;
+
+	cflag = (flags & TTM_PAGE_FLAG_CACHE_MASK) >> TTM_PAGE_FLAG_CACHE_SHIFT;
+	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
+		gfp_flags |= __GFP_ZERO;
+	if (flags & TTM_PAGE_FLAG_DMA32)
+		gfp_flags |= GFP_DMA32;
+	switch (cflag) {
+	case TTM_PAGE_FLAG_CACHE_UC:
+		for (i = 0; i < num_pages; i++) {
+			page = alloc_page(gfp_flags);
+			if (!page) {
+				printk(KERN_ERR "unable to get page %d\n", i);
+				return i;
+			}
+			get_page(page);
+#ifdef CONFIG_X86
+			if (!PageHighMem(page))
+				set_memory_uc((unsigned long)page_address(page), 1);
+#else
+			map_page_into_agp(page);
+#endif
+			ttm_tt_cache_flush(&page, 1);
+			list_add(&page->lru, &uc_free_list);
+			ttm_page_alloc_data.total_uc_pages++;
+			ttm_page_alloc_data.uc_pages_in_list++;
+		}
+		break;
+	case TTM_PAGE_FLAG_CACHE_WC:
+		for (i = 0; i < num_pages; i++) {
+			page = alloc_page(gfp_flags);
+			if (!page) {
+				printk(KERN_ERR "unable to get page %d\n", i);
+				return i;
+			}
+			get_page(page);
+#ifdef CONFIG_X86
+			if (!PageHighMem(page))
+				set_memory_wc((unsigned long)page_address(page), 1);
+#else
+			map_page_into_agp(page);
+#endif
+			ttm_tt_cache_flush(&page, 1);
+			list_add(&page->lru, &wc_free_list);
+			ttm_page_alloc_data.total_wc_pages++;
+			ttm_page_alloc_data.wc_pages_in_list++;
+		}
+		break;
+	default:
+		printk(KERN_ERR "Wrong caching flags %d'n", cflag);
+		return 0;
+	}
+	return i;
+}
+
+struct page *ttm_get_page(int flags)
+{
+	struct page *page = NULL;
+	int ret;
+	struct list_head *free_list;
+	int *pages_in_list;
+	int cflag;
+	int gfp_flags = GFP_HIGHUSER;
+
+	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
+		gfp_flags |= __GFP_ZERO;
+	if (flags & TTM_PAGE_FLAG_DMA32)
+		gfp_flags |= GFP_DMA32;
+	cflag = (flags & TTM_PAGE_FLAG_CACHE_MASK) >> TTM_PAGE_FLAG_CACHE_SHIFT;
+	switch (cflag) {
+	case TTM_PAGE_FLAG_CACHE_UC:
+		free_list = &uc_free_list;
+		pages_in_list = &ttm_page_alloc_data.uc_pages_in_list;
+		break;
+	case TTM_PAGE_FLAG_CACHE_WC:
+		free_list = &wc_free_list;
+		pages_in_list = &ttm_page_alloc_data.wc_pages_in_list;
+		break;
+	case TTM_PAGE_FLAG_CACHE_WB:
+	default:
+		page = alloc_page(gfp_flags);
+		if (!page) {
+			return NULL;
+		}
+		get_page(page);
+		return page;
+	}
+
+	mutex_lock(&page_alloc_mutex);
+	if (list_empty(free_list)) {
+		ret = ttm_add_pages_locked(NUM_PAGES_TO_ADD, flags);
+		if (ret == 0) {
+			mutex_unlock(&page_alloc_mutex);
+			return NULL;
+		}
+	}
+
+	page = list_first_entry(free_list, struct page, lru);
+	list_del(&page->lru);
+	(*pages_in_list)--;
+	mutex_unlock(&page_alloc_mutex);
+
+	return page;
+}
+
+void ttm_put_page(struct page *page, int flags)
+{
+	struct list_head *free_list;
+	int *pages_in_list;
+	int cflag;
+	bool setwb;
+
+	cflag = (flags & TTM_PAGE_FLAG_CACHE_MASK) >> TTM_PAGE_FLAG_CACHE_SHIFT;
+	switch (cflag) {
+	case TTM_PAGE_FLAG_CACHE_UC:
+		free_list = &uc_free_list;
+		pages_in_list = &ttm_page_alloc_data.uc_pages_in_list;
+		setwb = true;
+		break;
+	case TTM_PAGE_FLAG_CACHE_WC:
+		free_list = &wc_free_list;
+		pages_in_list = &ttm_page_alloc_data.wc_pages_in_list;
+		setwb = true;
+		break;
+	case TTM_PAGE_FLAG_CACHE_WB:
+	default:
+		put_page(page);
+		__free_page(page);
+		return;
+	}
+
+	mutex_lock(&page_alloc_mutex);
+	if ((*pages_in_list) > NUM_PAGES_TO_ADD) {
+		ttm_page_put(page, setwb);
+		mutex_unlock(&page_alloc_mutex);
+		return;
+	}
+	list_add(&page->lru, free_list);
+	(*pages_in_list)++;
+	mutex_unlock(&page_alloc_mutex);
+}
+
+void ttm_release_all_pages(struct list_head *free_list, bool setwb)
+{
+	struct page *page, *tmp;
+
+	list_for_each_entry_safe(page, tmp, free_list, lru) {
+		list_del(&page->lru);
+		ttm_page_put(page, setwb);
+	}
+}
+
+int ttm_page_alloc_init(void)
+{
+	if (page_alloc_inited)
+		return 0;
+
+	INIT_LIST_HEAD(&wc_free_list);
+	INIT_LIST_HEAD(&uc_free_list);
+	ttm_page_alloc_data.total_uc_pages = 0;
+	ttm_page_alloc_data.total_wc_pages = 0;
+	ttm_page_alloc_data.uc_pages_in_list = 0;
+	ttm_page_alloc_data.wc_pages_in_list = 0;
+
+	mutex_init(&page_alloc_mutex);
+	page_alloc_inited = 1;
+	return 0;
+}
+
+void ttm_page_alloc_fini(void)
+{
+	if (!page_alloc_inited)
+		return;
+
+	ttm_release_all_pages(&wc_free_list, true);
+	ttm_release_all_pages(&uc_free_list, true);
+	ttm_page_alloc_data.total_uc_pages = 0;
+	ttm_page_alloc_data.total_wc_pages = 0;
+	ttm_page_alloc_data.uc_pages_in_list = 0;
+	ttm_page_alloc_data.wc_pages_in_list = 0;
+	page_alloc_inited = 0;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.h b/drivers/gpu/drm/ttm/ttm_page_alloc.h
new file mode 100644
index 0000000..1e103ba
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) Red Hat Inc.
+
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sub license,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Dave Airlie <airlied@redhat.com>
+ */
+
+#ifndef TTM_PAGE_ALLOC
+#define TTM_PAGE_ALLOC
+
+struct ttm_page_alloc_usage {
+	int total_uc_pages;
+	int total_wc_pages;
+	int uc_pages_in_list;
+	int wc_pages_in_list;
+};
+
+extern struct ttm_page_alloc_usage ttm_page_alloc_data;
+
+void ttm_put_page(struct page *page, int flags);
+struct page *ttm_get_page(int flags);
+int ttm_page_alloc_init(void);
+void ttm_page_alloc_fini(void);
+
+#endif
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 0331fa7..0df3fa3 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -38,6 +38,7 @@
 #include "ttm/ttm_module.h"
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_placement.h"
+#include "ttm_page_alloc.h"
 
 static int ttm_tt_swapin(struct ttm_tt *ttm);
 
@@ -132,10 +133,10 @@ static void ttm_tt_free_page_directory(struct ttm_tt *ttm)
 
 static struct page *ttm_tt_alloc_page(unsigned page_flags)
 {
-	if (page_flags & TTM_PAGE_FLAG_ZERO_ALLOC)
-		return alloc_page(GFP_HIGHUSER | __GFP_ZERO);
+	struct page *page;
 
-	return alloc_page(GFP_HIGHUSER);
+	page = ttm_get_page(page_flags);
+	return page;
 }
 
 static void ttm_tt_free_user_pages(struct ttm_tt *ttm)
@@ -180,10 +181,23 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
 	struct page *p;
 	struct ttm_bo_device *bdev = ttm->bdev;
 	struct ttm_mem_global *mem_glob = bdev->mem_glob;
+	unsigned cache_flag;
 	int ret;
 
+	ttm->page_flags &= ~TTM_PAGE_FLAG_CACHE_MASK; 
+	switch (ttm->caching_state) {
+	case tt_uncached:
+		cache_flag = TTM_PAGE_FLAG_CACHE_UC << TTM_PAGE_FLAG_CACHE_SHIFT;
+		break;
+	case tt_wc:
+		cache_flag = TTM_PAGE_FLAG_CACHE_WC << TTM_PAGE_FLAG_CACHE_SHIFT;
+		break;
+	default:
+		cache_flag = TTM_PAGE_FLAG_CACHE_WB << TTM_PAGE_FLAG_CACHE_SHIFT;
+		break;
+	}
 	while (NULL == (p = ttm->pages[index])) {
-		p = ttm_tt_alloc_page(ttm->page_flags);
+		p = ttm_tt_alloc_page(ttm->page_flags | cache_flag);
 
 		if (!p)
 			return NULL;
@@ -344,21 +358,33 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
 	int i;
 	struct page *cur_page;
 	struct ttm_backend *be = ttm->be;
+	unsigned cache_flag;
 
 	if (be)
 		be->func->clear(be);
-	(void)ttm_tt_set_caching(ttm, tt_cached);
+	switch (ttm->caching_state) {
+	case tt_uncached:
+		cache_flag = TTM_PAGE_FLAG_CACHE_UC << TTM_PAGE_FLAG_CACHE_SHIFT;
+		break;
+	case tt_wc:
+		cache_flag = TTM_PAGE_FLAG_CACHE_WC << TTM_PAGE_FLAG_CACHE_SHIFT;
+		break;
+	default:
+		cache_flag = TTM_PAGE_FLAG_CACHE_WB << TTM_PAGE_FLAG_CACHE_SHIFT;
+		break;
+	}
 	for (i = 0; i < ttm->num_pages; ++i) {
 		cur_page = ttm->pages[i];
 		ttm->pages[i] = NULL;
 		if (cur_page) {
-			if (page_count(cur_page) != 1)
+			if (page_count(cur_page) != 2)
 				printk(KERN_ERR TTM_PFX
 				       "Erroneous page count. "
-				       "Leaking pages.\n");
+				       "Leaking pages (%d).\n",
+				       page_count(cur_page));
+			ttm_put_page(cur_page, cache_flag);
 			ttm_mem_global_free(ttm->bdev->mem_glob, PAGE_SIZE,
 					    PageHighMem(cur_page));
-			__free_page(cur_page);
 		}
 	}
 	ttm->state = tt_unpopulated;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 62ed733..0dac8a8 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -121,6 +121,12 @@ struct ttm_backend {
 #define TTM_PAGE_FLAG_SWAPPED         (1 << 4)
 #define TTM_PAGE_FLAG_PERSISTANT_SWAP (1 << 5)
 #define TTM_PAGE_FLAG_ZERO_ALLOC      (1 << 6)
+#define TTM_PAGE_FLAG_DMA32           (1 << 7)
+#define TTM_PAGE_FLAG_CACHE_MASK      (3 << 8)
+#define TTM_PAGE_FLAG_CACHE_SHIFT     8
+#define TTM_PAGE_FLAG_CACHE_UC        0
+#define TTM_PAGE_FLAG_CACHE_WC        1
+#define TTM_PAGE_FLAG_CACHE_WB        2
 
 enum ttm_caching_state {
 	tt_uncached,
-- 
1.6.2.2


--=-d9MaQFk/Et/qjR/4w4wU--

