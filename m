Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbZIKSvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbZIKSvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbZIKSvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:51:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54018 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbZIKSsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:36 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/21] HWPOISON: check and isolate corrupted free pages v2
Message-Id: <20090911184839.26AD5B1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

If memory corruption hits the free buddy pages, we can safely ignore them.
No one will access them until page allocation time, then prep_new_page()
will automatically check and isolate PG_hwpoison page for us (for 0-order
allocation).

This patch expands prep_new_page() to check every component page in a high
order page allocation, in order to completely stop PG_hwpoison pages from
being recirculated.

Note that the common case -- only allocating a single page, doesn't
do any more work than before. Allocating > order 0 does a bit more work,
but that's relatively uncommon.

This simple implementation may drop some innocent neighbor pages, hopefully
it is not a big problem because the event should be rare enough.

This patch adds some runtime costs to high order page users.

[AK: Improved description]

v2: Andi Kleen:
Port to -mm code
Move check into separate function.
Don't dump stack in bad_pages for hwpoisoned pages.
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/page_alloc.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -234,6 +234,12 @@ static void bad_page(struct page *page)
 	static unsigned long nr_shown;
 	static unsigned long nr_unshown;
 
+	/* Don't complain about poisoned pages */
+	if (PageHWPoison(page)) {
+		__ClearPageBuddy(page);
+		return;
+	}
+
 	/*
 	 * Allow a burst of 60 reports, then keep quiet for that minute;
 	 * or allow a steady drip of one report per second.
@@ -646,7 +652,7 @@ static inline void expand(struct zone *z
 /*
  * This page is about to be returned from the page allocator
  */
-static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
+static inline int check_new_page(struct page *page)
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
@@ -655,6 +661,18 @@ static int prep_new_page(struct page *pa
 		bad_page(page);
 		return 1;
 	}
+	return 0;
+}
+
+static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
+{
+	int i;
+
+	for (i = 0; i < (1 << order); i++) {
+		struct page *p = page + i;
+		if (unlikely(check_new_page(p)))
+			return 1;
+	}
 
 	set_page_private(page, 0);
 	set_page_refcounted(page);
