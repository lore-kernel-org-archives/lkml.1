Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbXFTTkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbXFTTkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXFTTjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:39:53 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:56949 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbXFTTjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:39:52 -0400
Date: Wed, 20 Jun 2007 15:39:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@redhat.com,
       mbligh@google.com
Subject: [PATCH] fix x86_64-mm-cpa-cache-flush.patch in 2.6.22-rc4-mm2
Message-ID: <20070620193912.GA20578@Krystal>
References: <20070619170914.GA30623@Krystal> <200706201101.20673.ak@suse.de> <20070620164614.GA8916@Krystal> <200706201953.54322.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200706201953.54322.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:34:09 up 23 days,  4:12,  5 users,  load average: 2.48, 2.16, 1.67
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> On Wednesday 20 June 2007 18:46, Mathieu Desnoyers wrote:
> > * Andi Kleen (ak@suse.de) wrote:
> > > On Tuesday 19 June 2007 22:01:36 Mathieu Desnoyers wrote:
> > > > Looking more closely into the code to find the cause of the
> > > > change_page_addr()/global_flush_tlb() inconsistency, I see where the
> > > > problem could be:
> > >
> > > Yes it's a known problem. I have a hack queued for .22 and there
> > > are proposed patches for .23 too.
> > >
> > > ftp://ftp.firstfloor.org/pub/ak/x86_64/late-merge/patches/cpa-flush
> > >
> > > -ANdi
> >
> > Hi Andi,
> >
> > Although I cannot find it at the specified URL, I suspect it is already
> > in Andrew's tree, in 2.6.22-rc4-mm2, under the name
> 
> Try again
> 
> > "x86_64-mm-cpa-cache-flush.patch"
> 
> No, that's a different patch with also at least one known bug.
> 
> -Andi

I just fixed x86_64 and i386, using a high order bit of private as a
flag "page needs deferred flush". It works well on i386, not tested on
x86_64.


x86_64 mm CPA cache flush fix for i386 and x86_64

Andi's patch introduced a hang for i386 machines when write protecting pages.

1st fix : use the appropritate checks in global flush tlb.
2nd fix : the hang was caused by multiple list_add of the same
kpte_page. Use a high order bit to keep track of which kpte_pages are
currently in the list and waiting for deferred flush.

This patch applies on top of the x86_64-mm-cpa-cache-flush.patch in the -mm
tree (2.6.22-rc4-mm2).

(note: the revert-x86_64-mm-cpa-cache-flush.patch must be discarded from the -mm
tree)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/mm/pageattr.c         |   24 +++++++++++++++++++-----
 arch/x86_64/mm/pageattr.c       |   16 ++++++++++++----
 include/asm-i386/cacheflush.h   |   11 +++++++++++
 include/asm-x86_64/cacheflush.h |   11 +++++++++++
 4 files changed, 53 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/pageattr.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/pageattr.c	2007-06-20 12:51:10.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/pageattr.c	2007-06-20 15:28:56.000000000 -0400
@@ -53,6 +53,9 @@
 	/*
 	 * page_private is used to track the number of entries in
 	 * the page table page that have non standard attributes.
+	 * We use the highest bit to tell is the page needs to be flushed,
+	 * therefore page_private_cpa_count() must be used to read the count.
+	 * Count increment and decrement never overflow on the highest bit.
 	 */
 	SetPagePrivate(base);
 	page_private(base) = 0;
@@ -160,7 +163,7 @@
 		page_private(kpte_page)++;
 	} else if (!pte_huge(*kpte)) {
 		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
-		BUG_ON(page_private(kpte_page) == 0);
+		BUG_ON(page_private_cpa_count(kpte_page) == 0);
 		page_private(kpte_page)--;
 	} else
 		BUG();
@@ -170,10 +173,12 @@
 	 * time (not via split_large_page) and in turn we must not
 	 * replace it with a largepage.
 	 */
-
-	list_add(&kpte_page->lru, &df_list);
+	if (!(page_private(kpte_page) & CPA_FLUSH)) {
+		page_private(kpte_page) |= CPA_FLUSH;
+		list_add(&kpte_page->lru, &df_list);
+	}
 	if (!PageReserved(kpte_page)) {
-		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
+		if (cpu_has_pse && (page_private_cpa_count(kpte_page) == 0)) {
 			paravirt_release_pt(page_to_pfn(kpte_page));
 			revert_page(kpte_page, address);
 		}
@@ -228,9 +233,13 @@
 	if (!cpu_has_clflush)
 		flush_map(NULL);
 	list_for_each_entry_safe(pg, next, &l, lru) {
+		list_del(&pg->lru);
+		page_private(pg) &= ~CPA_FLUSH;
 		if (cpu_has_clflush)
 			flush_map(page_address(pg));
-		if (page_private(pg) != 0)
+
+		if (PageReserved(pg) || !cpu_has_pse
+				|| page_private_cpa_count(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
 		__free_page(pg);
@@ -252,6 +261,11 @@
 	change_page_attr(page, numpages, enable ? PAGE_KERNEL : __pgprot(0));
 	/* we should perform an IPI and flush all tlbs,
 	 * but that can deadlock->flush only current cpu.
+	 *
+	 * FIXME : this is utterly buggy; it does not clean the df_list
+	 * populated by change_page_attr and could cause a double addition to
+	 * this list. With what exactly would the IPI deadlock ?
+	 * Mathieu Desnoyers
 	 */
 	__flush_tlb_all();
 }
Index: linux-2.6-lttng/include/asm-i386/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/cacheflush.h	2007-06-20 14:53:39.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/cacheflush.h	2007-06-20 15:23:07.000000000 -0400
@@ -4,6 +4,17 @@
 /* Keep includes the same across arches.  */
 #include <linux/mm.h>
 
+/* Use the highest bit of the page's private field to flag the kpte page as
+ * needing a flush. The lower bits are used as a counter of the number of ptes
+ * with special flags, within the page, which will never use the highest bit.
+ * pte_t being 8 bytes in size,
+ * 4096/sizeof(pte_t) = 512, which holds in 9 bits.
+ * For Large pages:
+ * 4MB/sizeof(pte_t) = 524288, which holds in 19 bits.
+ */
+#define CPA_FLUSH	(1UL<<31)
+#define page_private_cpa_count(page)	(page_private(page) & (~CPA_FLUSH))
+
 /* Caches aren't brain-dead on the intel. */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
Index: linux-2.6-lttng/include/asm-x86_64/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/cacheflush.h	2007-06-20 14:55:23.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/cacheflush.h	2007-06-20 15:22:49.000000000 -0400
@@ -4,6 +4,17 @@
 /* Keep includes the same across arches.  */
 #include <linux/mm.h>
 
+/* Use the highest bit of the page's private field to flag the kpte page as
+ * needing a flush. The lower bits are used as a counter of the number of ptes
+ * with special flags, within the page, which will never use the highest bit.
+ * pte_t being 8 bytes in size,
+ * 4096/sizeof(pte_t) = 512, which holds in 9 bits.
+ * For Large pages:
+ * 4MB/sizeof(pte_t) = 524288, which holds in 19 bits.
+ */
+#define CPA_FLUSH	(1UL<<63)
+#define page_private_cpa_count(page)	(page_private(page) & (~CPA_FLUSH))
+
 /* Caches aren't brain-dead on the intel. */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
Index: linux-2.6-lttng/arch/x86_64/mm/pageattr.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/mm/pageattr.c	2007-06-20 15:00:04.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/mm/pageattr.c	2007-06-20 15:24:35.000000000 -0400
@@ -47,6 +47,9 @@
 	/*
 	 * page_private is used to track the number of entries in
 	 * the page table page have non standard attributes.
+	 * We use the highest bit to tell is the page needs to be flushed,
+	 * therefore page_private_cpa_count() must be used to read the count.
+	 * Count increment and decrement never overflow on the highest bit.
 	 */
 	SetPagePrivate(base);
 	page_private(base) = 0;
@@ -79,6 +82,7 @@
 		asm volatile("wbinvd" ::: "memory");
 	list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
+		page_private(pg) &= ~CPA_FLUSH;
 		if (cpu_has_clflush)
 			cache_flush_page(adr);
 	}
@@ -94,7 +98,10 @@
 
 static inline void save_page(struct page *fpage)
 {
-	list_add(&fpage->lru, &deferred_pages);
+	if (!(page_private(fpage) & CPA_FLUSH)) {
+		page_private(kpte_page) |= CPA_FLUSH;
+		list_add(&fpage->lru, &deferred_pages);
+	}
 }
 
 /* 
@@ -150,7 +157,7 @@
 		page_private(kpte_page)++;
 	} else if (!pte_huge(*kpte)) {
 		set_pte(kpte, pfn_pte(pfn, ref_prot));
-		BUG_ON(page_private(kpte_page) == 0);
+		BUG_ON(page_private_cpa_count(kpte_page) == 0);
 		page_private(kpte_page)--;
 	} else
 		BUG();
@@ -159,7 +166,7 @@
  	BUG_ON(PageReserved(kpte_page));
 
 	save_page(kpte_page);
-	if (page_private(kpte_page) == 0)
+	if (page_private_cpa_count(kpte_page) == 0)
 		revert_page(address, ref_prot);
 	return 0;
 } 
@@ -232,7 +239,8 @@
 	flush_map(&l);
 
 	list_for_each_entry_safe(pg, next, &l, lru) {
-		if (page_private(pg) != 0)
+		list_del(&pg->lru);
+		if (page_private_cpa_count(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
 		__free_page(pg);
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
