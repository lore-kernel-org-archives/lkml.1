Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZFCSrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZFCSrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZFCSqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:46:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37809 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZFCSql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:46:41 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090603846.816684333@firstfloor.org>
In-Reply-To: <20090603846.816684333@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [1/16] HWPOISON: Add page flag for poisoned pages
Message-Id: <20090603184633.2D78F1D0282@basil.firstfloor.org>
Date: Wed,  3 Jun 2009 20:46:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hardware poisoned pages need special handling in the VM and shouldn't be 
touched again. This requires a new page flag. Define it here.

The page flags wars seem to be over, so it shouldn't be a problem
to get a new one.

v2: Add TestSetHWPoison (suggested by Johannes Weiner)

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/page-flags.h |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

Index: linux/include/linux/page-flags.h
===================================================================
--- linux.orig/include/linux/page-flags.h	2009-06-03 19:36:23.000000000 +0200
+++ linux/include/linux/page-flags.h	2009-06-03 19:36:23.000000000 +0200
@@ -51,6 +51,9 @@
  * PG_buddy is set to indicate that the page is free and in the buddy system
  * (see mm/page_alloc.c).
  *
+ * PG_hwpoison indicates that a page got corrupted in hardware and contains
+ * data with incorrect ECC bits that triggered a machine check. Accessing is
+ * not safe since it may cause another machine check. Don't touch!
  */
 
 /*
@@ -102,6 +105,9 @@
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	PG_uncached,		/* Page has been mapped as uncached */
 #endif
+#ifdef CONFIG_MEMORY_FAILURE
+	PG_hwpoison,		/* hardware poisoned page. Don't touch */
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -263,6 +269,15 @@
 PAGEFLAG_FALSE(Uncached)
 #endif
 
+#ifdef CONFIG_MEMORY_FAILURE
+PAGEFLAG(HWPoison, hwpoison)
+TESTSETFLAG(HWPoison, hwpoison)
+#define __PG_HWPOISON (1UL << PG_hwpoison)
+#else
+PAGEFLAG_FALSE(HWPoison)
+#define __PG_HWPOISON 0
+#endif
+
 static inline int PageUptodate(struct page *page)
 {
 	int ret = test_bit(PG_uptodate, &(page)->flags);
@@ -387,7 +402,7 @@
 	 1 << PG_private | 1 << PG_private_2 | \
 	 1 << PG_buddy	 | 1 << PG_writeback | 1 << PG_reserved | \
 	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
-	 1 << PG_unevictable | __PG_MLOCKED)
+	 1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
