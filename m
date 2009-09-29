Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZI2FQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZI2FQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZI2FQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:16:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:5481 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbZI2FQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:16:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,471,1249282800"; 
   d="scan'208";a="192754807"
Date: Tue, 29 Sep 2009 13:16:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090929051620.GA3882@localhost>
References: <20090926031537.GA10176@localhost> <20090926034936.GK30185@one.firstfloor.org> <20090926105259.GA5496@localhost> <20090926113156.GA12240@localhost> <20090927104739.GA1666@localhost> <20090927192025.GA6327@wotan.suse.de> <20090928084401.GA22131@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928084401.GA22131@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 04:44:01PM +0800, Wu Fengguang wrote:
> On Mon, Sep 28, 2009 at 03:20:25AM +0800, Nick Piggin wrote:

> > One other thing to keep in mind that I will mention is that I am
> > going to push in a patch to the page allocator to allow callers
> > to avoid the refcounting (atomic_dec_and_test) in page lifetime,
> > which is especially important for SLUB and takes more cycles off
> > the page allocator...
> >
> > I don't know exactly what you're going to do after that to get a
> > stable reference to slab pages. I guess you can read the page
> > flags and speculatively take some slab locks and recheck etc...
> 
> For reliably we could skip page lock on zero refcounted pages.
> 
> We may lose the PG_hwpoison bit on races with __SetPageSlub*, however
> it should be an acceptable imperfection.

I'd like to propose this fix for 2.6.32, which can do 100% correctness
for the discussed races :)

In brief it is

        if (is not lru page)
                return and don't touch page lock;

Any comments?

Thanks,
Fengguang

---
HWPOISON: return early on non-LRU pages

This avoids unnecessary races with __set_page_locked() and
__SetPageSlab*() and maybe more non-atomic page flag operations.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   54 ++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 35 deletions(-)

--- sound-2.6.orig/mm/memory-failure.c	2009-09-29 12:27:36.000000000 +0800
+++ sound-2.6/mm/memory-failure.c	2009-09-29 12:32:52.000000000 +0800
@@ -327,16 +327,6 @@ static const char *action_name[] = {
 };
 
 /*
- * Error hit kernel page.
- * Do nothing, try to be lucky and not touch this instead. For a few cases we
- * could be more sophisticated.
- */
-static int me_kernel(struct page *p, unsigned long pfn)
-{
-	return DELAYED;
-}
-
-/*
  * Already poisoned page.
  */
 static int me_ignore(struct page *p, unsigned long pfn)
@@ -370,9 +360,6 @@ static int me_pagecache_clean(struct pag
 	int ret = FAILED;
 	struct address_space *mapping;
 
-	if (!isolate_lru_page(p))
-		page_cache_release(p);
-
 	/*
 	 * For anonymous pages we're done the only reference left
 	 * should be the one m_f() holds.
@@ -498,30 +485,18 @@ static int me_pagecache_dirty(struct pag
  */
 static int me_swapcache_dirty(struct page *p, unsigned long pfn)
 {
-	int ret = FAILED;
-
 	ClearPageDirty(p);
 	/* Trigger EIO in shmem: */
 	ClearPageUptodate(p);
 
-	if (!isolate_lru_page(p)) {
-		page_cache_release(p);
-		ret = DELAYED;
-	}
-
-	return ret;
+	return DELAYED;
 }
 
 static int me_swapcache_clean(struct page *p, unsigned long pfn)
 {
-	int ret = FAILED;
-
-	if (!isolate_lru_page(p)) {
-		page_cache_release(p);
-		ret = RECOVERED;
-	}
 	delete_from_swap_cache(p);
-	return ret;
+
+	return RECOVERED;
 }
 
 /*
@@ -576,13 +551,6 @@ static struct page_state {
 	{ reserved,	reserved,	"reserved kernel",	me_ignore },
 	{ buddy,	buddy,		"free kernel",	me_free },
 
-	/*
-	 * Could in theory check if slab page is free or if we can drop
-	 * currently unused objects without touching them. But just
-	 * treat it as standard kernel for now.
-	 */
-	{ slab,		slab,		"kernel slab",	me_kernel },
-
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
 	{ head,		head,		"huge",		me_huge_page },
 	{ tail,		tail,		"huge",		me_huge_page },
@@ -775,6 +743,22 @@ int __memory_failure(unsigned long pfn, 
 	}
 
 	/*
+	 * We ignore non-LRU pages for good reasons.
+	 * - PG_locked is only well defined for LRU pages and a few others
+	 * - to avoid races with __set_page_locked()
+	 * - to avoid races with __SetPageSlab*() (and more non-atomic ops)
+	 * The check (unnecessarily) ignores LRU pages being isolated and
+	 * walked by the page reclaim code, however that's not a big loss.
+	 */
+        if (!PageLRU(p))
+                lru_add_drain_all();
+        if (isolate_lru_page(p)) {
+                action_result(pfn, "non LRU", IGNORED);
+                return -EBUSY;
+        }
+	page_cache_release(p);
+
+	/*
 	 * Lock the page and wait for writeback to finish.
 	 * It's very difficult to mess with pages currently under IO
 	 * and in many cases impossible, so we just avoid it here.
