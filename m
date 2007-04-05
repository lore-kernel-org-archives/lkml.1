Return-Path: <linux-kernel-owner+w=401wt.eu-S1767386AbXDEWhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767386AbXDEWhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767382AbXDEWha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:37:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36251 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767378AbXDEWhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:37:00 -0400
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <clameter@sgi.com>, dgc@sgi.com,
       linux-kernel@vger.kernel.org
Message-Id: <20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
Subject: [PATCH 2/2] Optimize compound_head() by avoiding a shared page flag
Date: Thu,  5 Apr 2007 15:36:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unalias PG_tail for performance reasons

If PG_tail is an alias then we need to check PageCompound before PageTail.
This is particularly bad because the slab and others have to use these tests
in performance critical paths. 

This patch uses one of the freed up software suspend flags that is defined
next to PG_compound.

Excerpt from kfree (page = compound_head(page)) before patch:

r33 = pointer to page struct.

0xa000000100170271 <kfree+49>:              ld4.acq r14=[r33]
0xa000000100170272 <kfree+50>:              nop.i 0x0;;
0xa000000100170280 <kfree+64>:  [MIB]       nop.m 0x0
0xa000000100170281 <kfree+65>:              tbit.z p9,p8=r14,14
0xa000000100170282 <kfree+66>:        (p09) br.cond.dptk.few 0xa0000001001702c0 <kfree+128>
0xa000000100170290 <kfree+80>:  [MMI]       ld4.acq r9=[r33]
0xa000000100170291 <kfree+81>:              nop.m 0x0
0xa000000100170292 <kfree+82>:              adds r8=16,r33;;
0xa0000001001702a0 <kfree+96>:  [MII]       nop.m 0x0
0xa0000001001702a1 <kfree+97>:              tbit.z p10,p11=r9,17
0xa0000001001702a2 <kfree+98>:              nop.i 0x0
0xa0000001001702b0 <kfree+112>: [MMI]       nop.m 0x0;;
0xa0000001001702b1 <kfree+113>:       (p11) ld8 r33=[r8]
0xa0000001001702b2 <kfree+114>:             nop.i 0x0;;
0xa0000001001702c0 <kfree+128>: [MII]   ...

After patch:

r34 pointer to page struct

0xa00000010016f541 <kfree+65>:              ld4.acq r3=[r34]
0xa00000010016f542 <kfree+66>:              nop.i 0x0
0xa00000010016f550 <kfree+80>:  [MMI]       adds r2=16,r34;;
0xa00000010016f551 <kfree+81>:              nop.m 0x0
0xa00000010016f552 <kfree+82>:              tbit.z p10,p11=r3,13;;
0xa00000010016f560 <kfree+96>:  [MII] (p11) ld8 r34=[r2]

No branch anymore.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm4/include/linux/page-flags.h
===================================================================
--- linux-2.6.21-rc5-mm4.orig/include/linux/page-flags.h	2007-04-05 15:18:33.000000000 -0700
+++ linux-2.6.21-rc5-mm4/include/linux/page-flags.h	2007-04-05 15:18:39.000000000 -0700
@@ -82,6 +82,7 @@
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
+#define PG_tail			13	/* Page is tail of a compound page */
 #define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
@@ -95,12 +96,6 @@
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
-/*
- * Marks tail portion of a compound page. We currently do not reclaim
- * compound pages so we can reuse a flag only used for reclaim here.
- */
-#define PG_tail			PG_reclaim
-
 #if (BITS_PER_LONG > 32)
 /*
  * 64-bit-only flags build down from bit 31
@@ -220,10 +215,6 @@ static inline void SetPageUptodate(struc
 #define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
 #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
 
-/*
- * Note: PG_tail is an alias of another page flag. The result of PageTail()
- * is only valid if PageCompound(page) is true.
- */
 #define PageTail(page)	test_bit(PG_tail, &(page)->flags)
 #define __SetPageTail(page)	__set_bit(PG_tail, &(page)->flags)
 #define __ClearPageTail(page)	__clear_bit(PG_tail, &(page)->flags)
Index: linux-2.6.21-rc5-mm4/mm/page_alloc.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/page_alloc.c	2007-04-05 15:18:33.000000000 -0700
+++ linux-2.6.21-rc5-mm4/mm/page_alloc.c	2007-04-05 15:18:39.000000000 -0700
@@ -500,18 +500,13 @@ static inline int free_pages_check(struc
 			1 << PG_private |
 			1 << PG_locked	|
 			1 << PG_active	|
+			1 << PG_reclaim |
 			1 << PG_slab	|
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
 			1 << PG_buddy ))))
 		bad_page(page);
-	/*
-	 * PageReclaim == PageTail. It is only an error
-	 * for PageReclaim to be set if PageCompound is clear.
-	 */
-	if (unlikely(!PageCompound(page) && PageReclaim(page)))
-		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
 	/*
Index: linux-2.6.21-rc5-mm4/mm/internal.h
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/internal.h	2007-04-05 15:18:33.000000000 -0700
+++ linux-2.6.21-rc5-mm4/mm/internal.h	2007-04-05 15:18:39.000000000 -0700
@@ -24,7 +24,7 @@ static inline void set_page_count(struct
  */
 static inline void set_page_refcounted(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page) && PageTail(page));
+	VM_BUG_ON(PageTail(page));
 	VM_BUG_ON(atomic_read(&page->_count));
 	set_page_count(page, 1);
 }
Index: linux-2.6.21-rc5-mm4/include/linux/mm.h
===================================================================
--- linux-2.6.21-rc5-mm4.orig/include/linux/mm.h	2007-04-05 15:18:51.000000000 -0700
+++ linux-2.6.21-rc5-mm4/include/linux/mm.h	2007-04-05 15:19:09.000000000 -0700
@@ -299,14 +299,7 @@ static inline int get_page_unless_zero(s
 
 static inline struct page *compound_head(struct page *page)
 {
-	/*
-	 * We could avoid the PageCompound(page) check if
-	 * we would not overload PageTail().
-	 *
-	 * This check has to be done in several performance critical
-	 * paths of the slab etc. IMHO PageTail deserves its own flag.
-	 */
-	if (unlikely(PageCompound(page) && PageTail(page)))
+	if (unlikely(PageTail(page)))
 		return page->first_page;
 	return page;
 }
