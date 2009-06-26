Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbZFZN7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbZFZN7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZFZN7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:59:39 -0400
Received: from nox.protox.org ([88.191.38.29]:59009 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbZFZN7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:59:38 -0400
Subject: Re: TTM page pool allocator
From: Jerome Glisse <glisse@freedesktop.org>
To: Dave Airlie <airlied@gmail.com>
Cc: thomas@shipmail.org, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-34xQy7F4ZkZpyQgzTXW3"
Date: Fri, 26 Jun 2009 15:59:35 +0200
Message-Id: <1246024775.2371.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-34xQy7F4ZkZpyQgzTXW3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2009-06-26 at 10:00 +1000, Dave Airlie wrote:
> On Thu, Jun 25, 2009 at 10:01 PM, Jerome Glisse<glisse@freedesktop.org> wrote:
> > Hi,
> >
> > Thomas i attach a reworked page pool allocator based on Dave works,
> > this one should be ok with ttm cache status tracking. It definitely
> > helps on AGP system, now the bottleneck is in mesa vertex's dma
> > allocation.
> >
> 
> My original version kept a list of wb pages as well, this proved to be
> quite a useful
> optimisation on my test systems when I implemented it, without it I
> was spending ~20%
> of my CPU in getting free pages, granted I always used WB pages on
> PCIE/IGP systems.
> 
> Another optimisation I made at the time was around the populate call,
> (not sure if this
> is what still happens):
> 
> Allocate a 64K local BO for DMA object.
> Write into the first 5 pages from userspace - get WB pages.
> Bind to GART, swap those 5 pages to WC + flush.
> Then populate the rest with WC pages from the list.
> 
> Granted I think allocating WC in the first place from the pool might
> work just as well since most of the DMA buffers are write only.
> 
> Dave.
> --

Attached a new version of the patch, which integrate changes discussed.

Cheers,
Jerome

--=-34xQy7F4ZkZpyQgzTXW3
Content-Disposition: attachment; filename="0001-ttm-add-pool-wc-uc-page-allocator.patch"
Content-Type: text/x-patch; name="0001-ttm-add-pool-wc-uc-page-allocator.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 9083e5466a7b81edcc989ac22d6ccdebef63116d Mon Sep 17 00:00:00 2001
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
 drivers/gpu/drm/ttm/ttm_page_alloc.c |  352 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_page_alloc.h |   34 ++++
 drivers/gpu/drm/ttm/ttm_tt.c         |   50 ++++--
 include/drm/ttm/ttm_bo_driver.h      |    6 +
 6 files changed, 434 insertions(+), 13 deletions(-)
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
index 0000000..860541f
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -0,0 +1,352 @@
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
+#include <asm/cacheflush.h>
+#include <ttm/ttm_module.h>
+#include <ttm/ttm_bo_driver.h>
+#include "ttm_page_alloc.h"
+
+#ifdef TTM_HAS_AGP
+#include <asm/agp.h>
+#endif
+
+#define NUM_PAGES_TO_ADD 128
+
+
+struct ttm_page_alloc_usage {
+	int total_uc_pages;
+	int total_wc_pages;
+	int total_wb_pages;
+	int total_hm_pages;
+	int count_uc_pages;
+	int count_wc_pages;
+	int count_wb_pages;
+	int count_hm_pages;
+};
+
+static struct page *wb_pages[NUM_PAGES_TO_ADD];
+static struct page *wc_pages[NUM_PAGES_TO_ADD];
+static struct page *uc_pages[NUM_PAGES_TO_ADD];
+static struct page *hm_pages[NUM_PAGES_TO_ADD];
+static struct mutex page_alloc_mutex;
+static int page_alloc_inited;
+struct ttm_page_alloc_usage ttm_page_alloc;
+
+
+static inline void ttm_page_put(struct page *page, bool setwb)
+{
+#ifdef CONFIG_X86
+	if (setwb && !PageHighMem(page)) {
+		set_memory_wb((unsigned long)page_address(page), 1);
+	}
+#else
+#ifdef TTM_HAS_AGP
+	if (setwb) {
+		/* This is a generic interface on non x86 to handle
+		 * wc/uc page */
+		unmap_page_from_agp(page);
+	}
+#endif
+#endif
+	put_page(page);
+	__free_page(page);
+}
+
+static void ttm_release_all_pages(struct page **pages, int count, bool setwb)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		ttm_page_put(pages[i], setwb);
+		pages[i] = NULL;
+	}
+}
+
+static int ttm_add_pages_locked(int flags)
+{
+	struct page *page;
+	int gfp_flags = GFP_HIGHUSER;
+	int i, cflag, r;
+
+	cflag = (flags & TTM_PAGE_FLAG_CACHE_MASK) >> TTM_PAGE_FLAG_CACHE_SHIFT;
+	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
+		gfp_flags |= __GFP_ZERO;
+	if (flags & TTM_PAGE_FLAG_DMA32)
+		gfp_flags |= GFP_DMA32;
+	switch (cflag) {
+	case TTM_PAGE_FLAG_CACHE_UC:
+		for (i = ttm_page_alloc.count_uc_pages; i < NUM_PAGES_TO_ADD; i++) {
+			page = alloc_page(gfp_flags);
+			if (!page) {
+				printk(KERN_ERR TTM_PFX "unable to get page %d\n", i);
+				return i;
+			}
+			get_page(page);
+#ifdef CONFIG_X86
+			if (!PageHighMem(page)) {
+				uc_pages[ttm_page_alloc.count_uc_pages++] = page;
+				ttm_page_alloc.total_uc_pages++;
+			} else {
+				if (ttm_page_alloc.count_hm_pages < NUM_PAGES_TO_ADD) {
+					hm_pages[ttm_page_alloc.count_hm_pages++] = page;
+					ttm_page_alloc.total_hm_pages++;
+				} else {
+					put_page(page);
+					__free_page(page);
+				}
+			}
+#else
+#ifdef TTM_HAS_AGP
+			map_page_into_agp(page);
+#endif
+#endif
+		}
+#ifdef CONFIG_X86
+		r = set_pages_array_uc(uc_pages, ttm_page_alloc.count_uc_pages);
+		if (r) {
+			/* On error we don't need to set page back to WB.
+			 * Or should we do that to be extra safe ?
+			 */
+			ttm_release_all_pages(uc_pages, ttm_page_alloc.count_uc_pages, false);
+			return r;
+		}
+#endif
+		ttm_tt_cache_flush(uc_pages, ttm_page_alloc.count_uc_pages);
+		break;
+	case TTM_PAGE_FLAG_CACHE_WC:
+		for (i = ttm_page_alloc.count_wc_pages; i < NUM_PAGES_TO_ADD; i++) {
+			page = alloc_page(gfp_flags);
+			if (!page) {
+				printk(KERN_ERR TTM_PFX "unable to get page %d\n", i);
+				return i;
+			}
+			get_page(page);
+#ifdef CONFIG_X86
+			if (!PageHighMem(page)) {
+				wc_pages[ttm_page_alloc.count_wc_pages++] = page;
+				set_memory_wc((unsigned long)page_address(page), 1);
+				ttm_page_alloc.total_wc_pages++;
+			} else {
+				if (ttm_page_alloc.count_hm_pages < NUM_PAGES_TO_ADD) {
+					hm_pages[ttm_page_alloc.count_hm_pages++] = page;
+					ttm_page_alloc.total_hm_pages++;
+				} else {
+					put_page(page);
+					__free_page(page);
+				}
+			}
+#else
+#ifdef TTM_HAS_AGP
+			map_page_into_agp(page);
+#endif
+#endif
+		}
+		ttm_tt_cache_flush(wc_pages, ttm_page_alloc.count_wc_pages);
+		break;
+	case TTM_PAGE_FLAG_CACHE_WB:
+		for (i = ttm_page_alloc.count_wb_pages; i < NUM_PAGES_TO_ADD; i++) {
+			page = alloc_page(gfp_flags);
+			if (!page) {
+				printk(KERN_ERR TTM_PFX "unable to get page %d\n", i);
+				return i;
+			}
+			get_page(page);
+#ifdef CONFIG_X86
+			if (!PageHighMem(page)) {
+				wb_pages[ttm_page_alloc.count_wb_pages++] = page;
+				ttm_page_alloc.total_wb_pages++;
+			} else {
+				if (ttm_page_alloc.count_hm_pages < NUM_PAGES_TO_ADD) {
+					hm_pages[ttm_page_alloc.count_hm_pages++] = page;
+					ttm_page_alloc.total_hm_pages++;
+				} else {
+					put_page(page);
+					__free_page(page);
+				}
+			}
+#endif
+		}
+		break;
+	default:
+		printk(KERN_ERR TTM_PFX "Wrong caching flags %d'n", cflag);
+		return 0;
+	}
+	return i;
+}
+
+struct page *ttm_get_page(int flags)
+{
+	struct page *page = NULL;
+	int ret;
+	struct page **pages;
+	int *count_pages;
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
+		pages = uc_pages;
+		count_pages = &ttm_page_alloc.count_uc_pages;
+		break;
+	case TTM_PAGE_FLAG_CACHE_WC:
+		pages = wc_pages;
+		count_pages = &ttm_page_alloc.count_wc_pages;
+		break;
+	case TTM_PAGE_FLAG_CACHE_WB:
+	default:
+		pages = wb_pages;
+		count_pages = &ttm_page_alloc.count_wb_pages;
+		break;
+	}
+
+	mutex_lock(&page_alloc_mutex);
+	if (!(*count_pages) && !ttm_page_alloc.count_hm_pages) {
+		ret = ttm_add_pages_locked(flags);
+		if (ret == 0) {
+			mutex_unlock(&page_alloc_mutex);
+			return NULL;
+		}
+	}
+	if (ttm_page_alloc.count_hm_pages) {
+		page = hm_pages[--ttm_page_alloc.count_hm_pages];
+	} else {
+		page = pages[--(*count_pages)];
+	}
+	mutex_unlock(&page_alloc_mutex);
+	return page;
+}
+
+void ttm_put_page(struct page *page, int flags)
+{
+	struct page **pages;
+	int *count_pages;
+	int cflag;
+	bool setwb;
+
+	if (PageHighMem(page)) {
+		mutex_lock(&page_alloc_mutex);
+		if (ttm_page_alloc.count_hm_pages < NUM_PAGES_TO_ADD) {
+			hm_pages[ttm_page_alloc.count_hm_pages++] = page;
+			ttm_page_alloc.total_hm_pages++;
+			mutex_unlock(&page_alloc_mutex);
+			return;
+		} else {
+			put_page(page);
+			__free_page(page);
+			mutex_unlock(&page_alloc_mutex);
+			return;
+		}
+	}
+
+	cflag = (flags & TTM_PAGE_FLAG_CACHE_MASK) >> TTM_PAGE_FLAG_CACHE_SHIFT;
+	switch (cflag) {
+	case TTM_PAGE_FLAG_CACHE_UC:
+		pages = uc_pages;
+		count_pages = &ttm_page_alloc.count_uc_pages;
+		setwb = true;
+		break;
+	case TTM_PAGE_FLAG_CACHE_WC:
+		pages = wc_pages;
+		count_pages = &ttm_page_alloc.count_wc_pages;
+		setwb = true;
+		break;
+	case TTM_PAGE_FLAG_CACHE_WB:
+	default:
+		pages = wb_pages;
+		count_pages = &ttm_page_alloc.count_wb_pages;
+		setwb = false;
+		break;
+	}
+
+	mutex_lock(&page_alloc_mutex);
+	if ((*count_pages) >= NUM_PAGES_TO_ADD) {
+		ttm_page_put(page, setwb);
+		mutex_unlock(&page_alloc_mutex);
+		return;
+	}
+	pages[(*count_pages)++] = page;
+	mutex_unlock(&page_alloc_mutex);
+}
+
+int ttm_page_alloc_init(void)
+{
+	int i;
+
+	if (page_alloc_inited)
+		return 0;
+
+	for (i = 0; i < NUM_PAGES_TO_ADD; i++) {
+		wb_pages[i] = NULL;
+		wc_pages[i] = NULL;
+		uc_pages[i] = NULL;
+		hm_pages[i] = NULL;
+	}
+	ttm_page_alloc.total_uc_pages = 0;
+	ttm_page_alloc.total_wc_pages = 0;
+	ttm_page_alloc.total_wb_pages = 0;
+	ttm_page_alloc.total_hm_pages = 0;
+	ttm_page_alloc.count_uc_pages = 0;
+	ttm_page_alloc.count_wc_pages = 0;
+	ttm_page_alloc.count_wb_pages = 0;
+	ttm_page_alloc.count_hm_pages = 0;
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
+	ttm_release_all_pages(wc_pages, ttm_page_alloc.total_wc_pages, true);
+	ttm_release_all_pages(wb_pages, ttm_page_alloc.total_wb_pages, true);
+	ttm_release_all_pages(uc_pages, ttm_page_alloc.total_uc_pages, true);
+	ttm_page_alloc.total_uc_pages = 0;
+	ttm_page_alloc.total_wc_pages = 0;
+	ttm_page_alloc.total_wb_pages = 0;
+	ttm_page_alloc.total_hm_pages = 0;
+	ttm_page_alloc.count_uc_pages = 0;
+	ttm_page_alloc.count_wc_pages = 0;
+	ttm_page_alloc.count_wb_pages = 0;
+	ttm_page_alloc.count_hm_pages = 0;
+	page_alloc_inited = 0;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.h b/drivers/gpu/drm/ttm/ttm_page_alloc.h
new file mode 100644
index 0000000..3d079a8
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.h
@@ -0,0 +1,34 @@
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
+void ttm_put_page(struct page *page, int flags);
+struct page *ttm_get_page(int flags);
+int ttm_page_alloc_init(void);
+void ttm_page_alloc_fini(void);
+
+#endif
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 75dc8bd..6402ec9 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -37,6 +37,7 @@
 #include "ttm/ttm_module.h"
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_placement.h"
+#include "ttm_page_alloc.h"
 
 static int ttm_tt_swapin(struct ttm_tt *ttm);
 
@@ -131,10 +132,10 @@ static void ttm_tt_free_page_directory(struct ttm_tt *ttm)
 
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
@@ -179,10 +180,23 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
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
@@ -290,10 +304,10 @@ static int ttm_tt_set_caching(struct ttm_tt *ttm,
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
@@ -343,21 +357,33 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
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


--=-34xQy7F4ZkZpyQgzTXW3--

