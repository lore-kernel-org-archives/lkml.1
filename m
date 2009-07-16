Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbZGPQNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbZGPQNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbZGPQNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:13:48 -0400
Received: from nox.protox.org ([88.191.38.29]:43464 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbZGPQNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:13:47 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH] ttm: add pool wc/uc page allocator
Date: Thu, 16 Jul 2009 18:13:41 +0200
Message-Id: <1247760821-12122-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/gpu/drm/ttm/ttm_page_alloc.c |  342 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_page_alloc.h |   36 ++++
 drivers/gpu/drm/ttm/ttm_tt.c         |   32 +---
 5 files changed, 391 insertions(+), 24 deletions(-)
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
index 0000000..bf2ca42
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -0,0 +1,342 @@
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
+ *          Jerome Glisse <jglisse@redhat.com>
+ */
+
+/* simple list based uncached page allocator
+ * - Add chunks of 1MB to the allocator at a time.
+ * - Use page->lru to keep a free list
+ * - doesn't track currently in use pages
+ */
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/mm_types.h>
+
+#include <asm/agp.h>
+#include "ttm/ttm_bo_driver.h"
+#include "ttm_page_alloc.h"
+
+/* add 1MB at a time */
+#define NUM_PAGES_TO_ADD 256
+
+struct page_pool {
+	struct list_head	list;
+	int			npages;
+	int			gfp_flags;
+};
+
+static struct page	*_pages[NUM_PAGES_TO_ADD];
+static int		_npages_to_free;
+static struct page_pool	_wc_pool;
+static struct page_pool	_uc_pool;
+static struct page_pool	_hm_pool;
+static struct page_pool	_wc_pool_dma32;
+static struct page_pool	_uc_pool_dma32;
+static struct page_pool	_hm_pool_dma32;
+static struct mutex	page_alloc_mutex;
+static bool		page_alloc_inited = false;
+
+
+#ifdef CONFIG_X86
+/* TODO: add this to x86 like _uc, this version here is inefficient */
+static int set_pages_array_wc(struct page **pages, int addrinarray)
+{
+	int i;
+
+	for (i = 0; i < addrinarray; i++) {
+		set_memory_wc((unsigned long)page_address(pages[i]), 1);
+	}
+	return 0;
+}
+#else
+static int set_pages_array_wb(struct page **pages, int addrinarray)
+{
+#ifdef TTM_HAS_AGP
+	int i;
+
+	for (i = 0; i < addrinarray; i++) {
+		unmap_page_from_agp(pages[i]);
+	}
+#endif
+	return 0;
+}
+
+static int set_pages_array_wc(struct page **pages, int addrinarray)
+{
+#ifdef TTM_HAS_AGP
+	int i;
+
+	for (i = 0; i < addrinarray; i++) {
+		map_page_into_agp(pages[i]);
+	}
+#endif
+	return 0;
+}
+
+static int set_pages_array_uc(struct page **pages, int addrinarray)
+{
+#ifdef TTM_HAS_AGP
+	int i;
+
+	for (i = 0; i < addrinarray; i++) {
+		map_page_into_agp(pages[i]);
+	}
+#endif
+	return 0;
+}
+#endif
+
+
+void pages_free_locked(void)
+{
+	int i;
+
+	set_pages_array_wb(_pages, _npages_to_free);
+	for (i = 0; i < _npages_to_free; i++) {
+		__free_page(_pages[i]);
+	}
+	_npages_to_free = 0;
+}
+
+static void ttm_page_pool_init_locked(struct page_pool *pool)
+{
+	INIT_LIST_HEAD(&pool->list);
+	pool->npages = 0;	
+}
+
+static int page_pool_fill_locked(struct page_pool *pool,
+				enum ttm_caching_state cstate)
+{
+	struct page *page;
+	int i, cpages;
+
+	/* We need the _pages table to change page cache status so empty it */
+	if (cstate != tt_cached && _npages_to_free)
+		pages_free_locked();
+
+	for (i = 0, cpages = 0; i < (NUM_PAGES_TO_ADD - pool->npages); i++) {
+		page = alloc_page(pool->gfp_flags);
+		if (!page) {
+			printk(KERN_ERR "unable to get page %d\n", i);
+			return -ENOMEM;
+		}
+#ifdef CONFIG_X86
+		/* gfp flags of highmem page should never be dma32 so we
+		 * we should be fine in such case
+		 */
+		if (PageHighMem(page)) {
+			if (pool->gfp_flags & GFP_DMA32) {
+				list_add(&page->lru, &_hm_pool_dma32.list);
+				_hm_pool_dma32.npages++;
+			} else {
+				list_add(&page->lru, &_hm_pool.list);
+				_hm_pool.npages++;
+			}
+		} else
+#endif
+		{
+			list_add(&page->lru, &pool->list);
+			pool->npages++;
+			_pages[i] = page;
+			cpages++;
+		}
+	}
+	switch(cstate) {
+	case tt_uncached:
+		set_pages_array_uc(_pages, cpages);
+		break;
+	case tt_wc:
+		set_pages_array_wc(_pages, cpages);
+		break;
+	case tt_cached:
+	default:
+		break;
+	}
+	return 0;
+}
+
+static inline void ttm_page_put_locked(struct page *page)
+{
+	if (_npages_to_free >= NUM_PAGES_TO_ADD)
+		pages_free_locked();
+	_pages[_npages_to_free++] = page;
+}
+
+static void ttm_page_pool_empty_locked(struct page_pool *pool, bool hm)
+{
+	struct page *page, *tmp;
+
+	if (hm) {
+		list_for_each_entry_safe(page, tmp, &pool->list, lru) {
+			list_del(&page->lru);
+			__free_page(page);
+		}
+	} else {
+		list_for_each_entry_safe(page, tmp, &pool->list, lru) {
+			list_del(&page->lru);
+			ttm_page_put_locked(page);
+		}
+	}
+	pool->npages = 0;
+}
+
+
+struct page *ttm_get_page(int flags, enum ttm_caching_state cstate)
+{
+	struct page_pool *pool;
+	struct page_pool *hm_pool;
+	struct page *page = NULL;
+	int gfp_flags = GFP_HIGHUSER;
+	int r;
+
+	hm_pool = &_hm_pool;
+	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
+		gfp_flags |= __GFP_ZERO;
+	if (flags & TTM_PAGE_FLAG_DMA32) {
+		gfp_flags |= GFP_DMA32;
+		hm_pool = &_hm_pool_dma32;
+	}
+	switch (cstate) {
+	case tt_uncached:
+		if (gfp_flags & GFP_DMA32)
+			pool = & _uc_pool_dma32;
+		else
+			pool = & _uc_pool;
+		break;
+	case tt_wc:
+		if (gfp_flags & GFP_DMA32)
+			pool = & _wc_pool_dma32;
+		else
+			pool = & _wc_pool;
+		break;
+	case tt_cached:
+	default:
+		return alloc_page(gfp_flags);
+	}
+	mutex_lock(&page_alloc_mutex);
+	if (!pool->npages && !hm_pool->npages) {
+		r = page_pool_fill_locked(pool, cstate);
+		if (r == 0) {
+			mutex_unlock(&page_alloc_mutex);
+			return NULL;
+		}
+	}
+	if (hm_pool->npages) {
+		page = list_first_entry(&hm_pool->list, struct page, lru);
+		list_del(&page->lru);
+		hm_pool->npages--;
+	} else {
+		page = list_first_entry(&pool->list, struct page, lru);
+		list_del(&page->lru);
+		pool->npages--;
+	}
+	mutex_unlock(&page_alloc_mutex);
+	return page;
+}
+
+void ttm_put_page(struct page *page, int flags, enum ttm_caching_state cstate)
+{
+	struct page_pool *pool;
+	struct page_pool *hm_pool;
+	int gfp_flags = GFP_HIGHUSER;
+
+	hm_pool = &_hm_pool;
+	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
+		gfp_flags |= __GFP_ZERO;
+	if (flags & TTM_PAGE_FLAG_DMA32) {
+		gfp_flags |= GFP_DMA32;
+		hm_pool = &_hm_pool_dma32;
+	}
+	switch (cstate) {
+	case tt_uncached:
+		if (gfp_flags & GFP_DMA32)
+			pool = & _uc_pool_dma32;
+		else
+			pool = & _uc_pool;
+		break;
+	case tt_wc:
+		if (gfp_flags & GFP_DMA32)
+			pool = & _wc_pool_dma32;
+		else
+			pool = & _wc_pool;
+		break;
+	case tt_cached:
+	default:
+		__free_page(page);
+		return;
+	}
+	mutex_lock(&page_alloc_mutex);
+#ifdef CONFIG_X86
+	if (!PageHighMem(page)) {
+		if (hm_pool->npages > NUM_PAGES_TO_ADD) {
+			__free_page(page);
+		} else {
+			list_add(&page->lru, &hm_pool->list);
+			hm_pool->npages++;
+		}
+	} else
+#endif
+	{
+		if (pool->npages > NUM_PAGES_TO_ADD) {
+			ttm_page_put_locked(page);
+		} else {
+			list_add(&page->lru, &pool->list);
+			pool->npages++;
+		}
+	}
+	mutex_unlock(&page_alloc_mutex);
+}
+
+int ttm_page_alloc_init(void)
+{
+	if (page_alloc_inited)
+		return 0;
+
+	mutex_init(&page_alloc_mutex);
+	ttm_page_pool_init_locked(&_wc_pool);
+	ttm_page_pool_init_locked(&_uc_pool);
+	ttm_page_pool_init_locked(&_hm_pool);
+	ttm_page_pool_init_locked(&_wc_pool_dma32);
+	ttm_page_pool_init_locked(&_uc_pool_dma32);
+	ttm_page_pool_init_locked(&_hm_pool_dma32);
+	_npages_to_free = 0;
+	page_alloc_inited = 1;
+	return 0;
+}
+
+void ttm_page_alloc_fini(void)
+{
+	if (!page_alloc_inited)
+		return;
+	mutex_lock(&page_alloc_mutex);
+	ttm_page_pool_empty_locked(&_wc_pool, false);
+	ttm_page_pool_empty_locked(&_uc_pool, false);
+	ttm_page_pool_empty_locked(&_hm_pool, true);
+	ttm_page_pool_empty_locked(&_wc_pool_dma32, false);
+	ttm_page_pool_empty_locked(&_uc_pool_dma32, false);
+	ttm_page_pool_empty_locked(&_hm_pool_dma32, true);
+	pages_free_locked();
+	page_alloc_inited = 0;
+	mutex_unlock(&page_alloc_mutex);
+}
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.h b/drivers/gpu/drm/ttm/ttm_page_alloc.h
new file mode 100644
index 0000000..9212554
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.h
@@ -0,0 +1,36 @@
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
+ *          Jerome Glisse <jglisse@redhat.com>
+ */
+#ifndef TTM_PAGE_ALLOC
+#define TTM_PAGE_ALLOC
+
+#include "ttm/ttm_bo_driver.h"
+
+void ttm_put_page(struct page *page, int flags, enum ttm_caching_state cstate);
+struct page *ttm_get_page(int flags, enum ttm_caching_state cstate);
+int ttm_page_alloc_init(void);
+void ttm_page_alloc_fini(void);
+
+#endif
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index b106b1d..b084dbb 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -38,6 +38,7 @@
 #include "ttm/ttm_module.h"
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_placement.h"
+#include "ttm_page_alloc.h"
 
 static int ttm_tt_swapin(struct ttm_tt *ttm);
 
@@ -72,21 +73,6 @@ static void ttm_tt_free_page_directory(struct ttm_tt *ttm)
 	ttm->pages = NULL;
 }
 
-static struct page *ttm_tt_alloc_page(unsigned page_flags)
-{
-	gfp_t gfp_flags = GFP_USER;
-
-	if (page_flags & TTM_PAGE_FLAG_ZERO_ALLOC)
-		gfp_flags |= __GFP_ZERO;
-
-	if (page_flags & TTM_PAGE_FLAG_DMA32)
-		gfp_flags |= __GFP_DMA32;
-	else
-		gfp_flags |= __GFP_HIGHMEM;
-
-	return alloc_page(gfp_flags);
-}
-
 static void ttm_tt_free_user_pages(struct ttm_tt *ttm)
 {
 	int write;
@@ -132,7 +118,7 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
 	int ret;
 
 	while (NULL == (p = ttm->pages[index])) {
-		p = ttm_tt_alloc_page(ttm->page_flags);
+		p = ttm_get_page(ttm->page_flags, ttm->caching_state);
 
 		if (!p)
 			return NULL;
@@ -240,10 +226,10 @@ static int ttm_tt_set_caching(struct ttm_tt *ttm,
 	if (ttm->caching_state == c_state)
 		return 0;
 
-	if (c_state != tt_cached) {
-		ret = ttm_tt_populate(ttm);
-		if (unlikely(ret != 0))
-			return ret;
+	if (ttm->state == tt_unpopulated) {
+		/* Change caching but don't populate */
+		ttm->caching_state = c_state;
+		return 0;
 	}
 
 	if (ttm->caching_state == tt_cached)
@@ -296,7 +282,6 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
 
 	if (be)
 		be->func->clear(be);
-	(void)ttm_tt_set_caching(ttm, tt_cached);
 	for (i = 0; i < ttm->num_pages; ++i) {
 		cur_page = ttm->pages[i];
 		ttm->pages[i] = NULL;
@@ -304,10 +289,11 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
 			if (page_count(cur_page) != 1)
 				printk(KERN_ERR TTM_PFX
 				       "Erroneous page count. "
-				       "Leaking pages.\n");
+				       "Leaking pages (%d).\n",
+				       page_count(cur_page));
 			ttm_mem_global_free(ttm->bdev->mem_glob, PAGE_SIZE,
 					    PageHighMem(cur_page));
-			__free_page(cur_page);
+			ttm_put_page(cur_page, ttm->page_flags, ttm->caching_state);
 		}
 	}
 	ttm->state = tt_unpopulated;
-- 
1.6.2.5

