Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYCAEKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYCAEKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 23:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbYCAEGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 23:06:55 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46590 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751757AbYCAEGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 23:06:24 -0500
Message-Id: <20080301040621.484085808@sgi.com>
References: <20080301040534.797979115@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Feb 2008 20:05:41 -0800
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@shadowen.org
Cc: linux-mm@kback.org
Subject: [rfc 07/10] Pageflags: Get rid of FLAGS_RESERVED
Content-Disposition: inline; filename=pageflags-get-rid-of-flags-reserved
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NR_PAGEFLAGS specifies the number of page flags we are using.
>From that we can calculate the number of bits leftover that can
be used for zone, node (and maybe the sections id). There is
no need anymore for FLAGS_RESERVED if we use NR_PAGEFLAGS.

Use the new methods to make NR_PAGEFLAGS available via
the preprocessor. NR_PAGEFLAGS is used to calculate field
boundaries in the page flags fields. These field widths have
to be available to the preprocessor.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/bounds.h     |    2 ++
 include/linux/mm.h         |    6 +++---
 include/linux/mmzone.h     |   19 -------------------
 include/linux/page-flags.h |   14 +++++++-------
 kernel/bounds.c            |    1 +
 5 files changed, 13 insertions(+), 29 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-02-29 19:21:35.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-02-29 19:29:53.000000000 -0800
@@ -402,7 +402,7 @@ static inline void set_compound_order(st
 
 #define ZONES_WIDTH		ZONES_SHIFT
 
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= FLAGS_RESERVED
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
 #define NODES_WIDTH		NODES_SHIFT
 #else
 #define NODES_WIDTH		0
@@ -447,8 +447,8 @@ static inline void set_compound_order(st
 
 #define ZONEID_PGSHIFT		(ZONEID_PGOFF * (ZONEID_SHIFT != 0))
 
-#if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
-#error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
+#if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
+#error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
 #endif
 
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h	2008-02-29 19:13:55.000000000 -0800
+++ linux-2.6/include/linux/mmzone.h	2008-02-29 19:29:53.000000000 -0800
@@ -735,25 +735,6 @@ extern struct zone *next_zone(struct zon
 #include <asm/sparsemem.h>
 #endif
 
-#if BITS_PER_LONG == 32
-/*
- * with 32 bit page->flags field, we reserve 9 bits for node/zone info.
- * there are 4 zones (3 bits) and this leaves 9-3=6 bits for nodes.
- */
-#define FLAGS_RESERVED		9
-
-#elif BITS_PER_LONG == 64
-/*
- * with 64 bit flags field, there's plenty of room.
- */
-#define FLAGS_RESERVED		32
-
-#else
-
-#error BITS_PER_LONG not defined
-
-#endif
-
 #if !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) && \
 	!defined(CONFIG_ARCH_POPULATES_NODE_MAP)
 #define early_pfn_to_nid(nid)  (0UL)
Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2008-02-29 19:20:11.000000000 -0800
+++ linux-2.6/include/linux/page-flags.h	2008-02-29 19:29:53.000000000 -0800
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/mm_types.h>
+#include <linux/bounds.h>
 
 /*
  * Various page->flags bits:
@@ -59,13 +60,12 @@
  * extends from the high bits downwards.
  *
  *  | FIELD | ... | FLAGS |
- *  N-1     ^             0
- *          (N-FLAGS_RESERVED)
+ *  N-1           ^       0
+ *               (NR_PAGEFLAGS)
  *
- * The fields area is reserved for fields mapping zone, node and SPARSEMEM
- * section.  The boundry between these two areas is defined by
- * FLAGS_RESERVED which defines the width of the fields section
- * (see linux/mmzone.h).  New flags must _not_ overlap with this area.
+ * The fields area is reserved for fields mapping zone, node (for NUMA) and
+ * SPARSEMEM section (for variants of SPARSEMEM that require section ids like
+ * SPARSEMEM_EXTREME with !SPARSEMEM_VMEMMAP).
  */
 enum pageflags {
 	PG_locked,		/* Page is locked. Don't touch. */
@@ -86,7 +86,6 @@ enum pageflags {
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
-	NR_PAGEFLAGS,		/* For verification purposes */
 
 #if (BITS_PER_LONG > 32)
 /*
@@ -98,6 +97,7 @@ enum pageflags {
  */
 	PG_uncached = 31,		/* Page has been mapped as uncached */
 #endif
+	__NR_PAGEFLAGS,
 };
 
 /*
Index: linux-2.6/kernel/bounds.c
===================================================================
--- linux-2.6.orig/kernel/bounds.c	2008-02-29 19:29:38.000000000 -0800
+++ linux-2.6/kernel/bounds.c	2008-02-29 19:29:53.000000000 -0800
@@ -13,4 +13,5 @@
 
 void foo(void)
 {
+	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 }
Index: linux-2.6/include/linux/bounds.h
===================================================================
--- linux-2.6.orig/include/linux/bounds.h	2008-02-29 19:30:04.000000000 -0800
+++ linux-2.6/include/linux/bounds.h	2008-02-29 19:30:08.000000000 -0800
@@ -7,4 +7,6 @@
  *
  */
 
+#define NR_PAGEFLAGS 32 /* __NR_PAGEFLAGS	# */
+
 #endif

-- 
