Return-Path: <linux-kernel-owner+w=401wt.eu-S934549AbZGQO41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbZGQO41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934334AbZGQO40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:56:26 -0400
Received: from nox.protox.org ([88.191.38.29]:42402 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934157AbZGQO4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:56:25 -0400
Subject: Re: [PATCH] ttm: add pool wc/uc page allocator
From: Jerome Glisse <glisse@freedesktop.org>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <1247817711.9922.63.camel@thor>
References: <1247760821-12122-1-git-send-email-jglisse@redhat.com>
	 <1247762075.12808.2.camel@localhost>  <1247817711.9922.63.camel@thor>
Content-Type: multipart/mixed; boundary="=-8o/TJ07njQphiZdnCf9W"
Date: Fri, 17 Jul 2009 16:55:08 +0200
Message-Id: <1247842508.2335.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8o/TJ07njQphiZdnCf9W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Fri, 2009-07-17 at 10:01 +0200, Michel Dänzer wrote:
> On Thu, 2009-07-16 at 18:34 +0200, Jerome Glisse wrote: 
> > On Thu, 2009-07-16 at 18:13 +0200, Jerome Glisse wrote:
> > > On AGP system we might allocate/free routinely uncached or wc memory,
> > > changing page from cached (wb) to uc or wc is very expensive and involves
> > > a lot of flushing. To improve performance this allocator use a pool
> > > of uc,wc pages.
> > > 
> > > Currently each pool (wc, uc) is 256 pages big, improvement would be
> > > to tweak this according to memory pressure so we can give back memory
> > > to system.
> > > 
> > > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > > Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> > 
> > Just a follow-up on that one, i haven't been able yet to thoroughly
> > test this patch on AGP system, so i am mostly sending so other people
> > can test. I think i corrected few bugs that were in previous iteration
> > of that patch.
> > 
> > Beside that i think i have addressed all comment previously raisen,
> > but don't hesitate to pin point any things i have miss.
> 
> This one works a little better on my PowerBook than the previous one:
> 
> PCI GART works (failed to allocate the ring buffer before)
> AGP fails to allocate the ring buffer (paniced at KMS init before)
> 

Attached a new version which more or less work on x86 agp (i have
screen corruption haven't tracked done what is causing it yet).
I corrected more bugs from previous version, hopefully i am getting
closer to somethings which works.

Cheers,
Jerome

--=-8o/TJ07njQphiZdnCf9W
Content-Disposition: attachment; filename="0001-ttm-add-pool-wc-uc-page-allocator.patch"
Content-Type: text/x-patch; name="0001-ttm-add-pool-wc-uc-page-allocator.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From af6aa9b4ef5f3f2ee6480ed2ede0170067ac9df0 Mon Sep 17 00:00:00 2001
From: Jerome Glisse <jglisse@redhat.com>
Date: Thu, 16 Jul 2009 18:12:22 +0200
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
 drivers/gpu/drm/ttm/ttm_page_alloc.c |  349 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_page_alloc.h |   36 ++++
 drivers/gpu/drm/ttm/ttm_tt.c         |   32 +---
 5 files changed, 398 insertions(+), 24 deletions(-)
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
index 0000000..1d260bd
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -0,0 +1,349 @@
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
+	int			nzeropages;
+};
+
+static struct page	*_pages[NUM_PAGES_TO_ADD];
+static int		_npages_to_free;
+static struct page_pool	_wc_pool;
+static struct page_pool	_uc_pool;
+static struct page_pool	_wc_pool_dma32;
+static struct page_pool	_uc_pool_dma32;
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
+	pool->nzeropages = 0;
+}
+
+static int page_pool_fill_locked(struct page_pool *pool, int gfp_flags,
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
+		page = alloc_page(gfp_flags);
+		if (!page) {
+			printk(KERN_ERR "unable to get page %d\n", i);
+			return -ENOMEM;
+		}
+		if (gfp_flags & __GFP_ZERO) {
+			list_add(&page->lru, &pool->list);
+			pool->nzeropages++;
+		} else {
+			list_add_tail(&page->lru, &pool->list);
+			pool->npages++;
+		}
+		if (!PageHighMem(page)) {
+			_pages[cpages++] = page;
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
+static void ttm_page_pool_empty_locked(struct page_pool *pool)
+{
+	struct page *page, *tmp;
+
+	list_for_each_entry_safe(page, tmp, &pool->list, lru) {
+		list_del(&page->lru);
+#ifdef CONFIG_X86
+		if (PageHighMem(page)) {
+			__free_page(page);
+		} else
+#endif
+		{
+			ttm_page_put_locked(page);
+		}
+	}
+	pool->npages = 0;
+}
+
+static struct page *ttm_page_pool_get_locked(struct page_pool *pool, int flags)
+{
+	struct page *page = NULL;
+
+	if (flags & __GFP_ZERO) {
+		if (pool->nzeropages) {
+			page = list_first_entry(&pool->list, struct page, lru);
+			list_del(&page->lru);
+			pool->nzeropages--;
+			return page;
+		} else {
+			page = list_first_entry(&pool->list, struct page, lru);
+			list_del(&page->lru);
+			pool->npages--;
+			if (PageHighMem(page)) {
+				/* This should never happen ! */
+				__free_page(page);
+				return NULL;
+			}
+			clear_page(page_address(page));
+			return page;
+		}
+	}
+	if (pool->npages) {
+		page = list_entry(pool->list.prev, struct page, lru);
+		list_del(&page->lru);
+		pool->npages--;
+		return page;
+	}
+	page = list_first_entry(&pool->list, struct page, lru);
+	list_del(&page->lru);
+	pool->nzeropages--;
+	return page;
+}
+
+
+struct page *ttm_get_page(int flags, enum ttm_caching_state cstate)
+{
+	struct page_pool *pool;
+	struct page *page = NULL;
+	int gfp_flags = GFP_USER;
+	int r;
+
+	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
+		gfp_flags |= __GFP_ZERO;
+	if (flags & TTM_PAGE_FLAG_DMA32) {
+		gfp_flags |= __GFP_DMA32;
+	} else {
+		gfp_flags |= __GFP_HIGHMEM;
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
+	if (!pool->npages && !pool->nzeropages) {
+		/* We force to allocate zeroed page so that when we free page
+		 * and only add non highmem page to the pool we know that we
+		 * will be able to clear them.
+		 */
+		r = page_pool_fill_locked(pool, flags | __GFP_ZERO, cstate);
+		if (r) {
+			mutex_unlock(&page_alloc_mutex);
+			return NULL;
+		}
+	}
+	page = ttm_page_pool_get_locked(pool, gfp_flags);
+	mutex_unlock(&page_alloc_mutex);
+	return page;
+}
+
+void ttm_put_page(struct page *page, int flags, enum ttm_caching_state cstate)
+{
+	struct page_pool *pool;
+
+	switch (cstate) {
+	case tt_uncached:
+		if (flags & TTM_PAGE_FLAG_DMA32)
+			pool = & _uc_pool_dma32;
+		else
+			pool = & _uc_pool;
+		break;
+	case tt_wc:
+		if (flags & TTM_PAGE_FLAG_DMA32)
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
+	if (PageHighMem(page)) {
+		/* Free highmem page as we can't easily set them to zero,
+		 * so we know that in non zeroed page we only have page
+		 * we can zero through a mapping prolerly set according
+		 * to cache setting (ie we are missing kmap_wc_atomic|
+		 * kmap_uc_atomic)
+		 */
+		__free_page(page);
+	} else
+#endif
+	{
+		if (pool->npages >= NUM_PAGES_TO_ADD) {
+			ttm_page_put_locked(page);
+		} else {
+			list_add_tail(&page->lru, &pool->list);
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
+	ttm_page_pool_init_locked(&_wc_pool_dma32);
+	ttm_page_pool_init_locked(&_uc_pool_dma32);
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
+	ttm_page_pool_empty_locked(&_wc_pool);
+	ttm_page_pool_empty_locked(&_uc_pool);
+	ttm_page_pool_empty_locked(&_wc_pool_dma32);
+	ttm_page_pool_empty_locked(&_uc_pool_dma32);
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
1.6.2.2


--=-8o/TJ07njQphiZdnCf9W--

