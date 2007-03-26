Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbXCZSXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbXCZSXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbXCZSXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:23:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52390 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753664AbXCZSXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:23:13 -0400
Date: Mon, 26 Mar 2007 11:23:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: ak@suse.de
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [x86_64] Use lru instead of page->index and page->private for pgd
 lists management.
Message-ID: <Pine.LNX.4.64.0703261121520.13277@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 currently simulates a list using the index and private fields of the page struct.
Seems that the code was inherited from i386. But x86_64 does not use the slab to
allocate pgds and pmds etc. So the lru field is not used by the slab and therefore
available.

This patch uses standard list operations on page->lru to realize pgd tracking.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc4/arch/x86_64/mm/fault.c
===================================================================
--- linux-2.6.21-rc4.orig/arch/x86_64/mm/fault.c	2007-03-26 11:03:46.000000000 -0700
+++ linux-2.6.21-rc4/arch/x86_64/mm/fault.c	2007-03-26 11:04:43.000000000 -0700
@@ -585,7 +585,7 @@
 }
 
 DEFINE_SPINLOCK(pgd_lock);
-struct page *pgd_list;
+LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
@@ -605,8 +605,7 @@
 			if (pgd_none(*pgd_ref))
 				continue;
 			spin_lock(&pgd_lock);
-			for (page = pgd_list; page;
-			     page = (struct page *)page->index) {
+			list_for_each_entry(page, &pgd_list, lru) {
 				pgd_t *pgd;
 				pgd = (pgd_t *)page_address(page) + pgd_index(address);
 				if (pgd_none(*pgd))
Index: linux-2.6.21-rc4/include/asm-x86_64/pgtable.h
===================================================================
--- linux-2.6.21-rc4.orig/include/asm-x86_64/pgtable.h	2007-03-26 11:03:46.000000000 -0700
+++ linux-2.6.21-rc4/include/asm-x86_64/pgtable.h	2007-03-26 11:04:43.000000000 -0700
@@ -403,7 +403,7 @@
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
 extern spinlock_t pgd_lock;
-extern struct page *pgd_list;
+extern struct list_head pgd_list;
 void vmalloc_sync_all(void);
 
 #endif /* !__ASSEMBLY__ */
Index: linux-2.6.21-rc4/include/asm-x86_64/pgalloc.h
===================================================================
--- linux-2.6.21-rc4.orig/include/asm-x86_64/pgalloc.h	2007-03-26 11:04:52.000000000 -0700
+++ linux-2.6.21-rc4/include/asm-x86_64/pgalloc.h	2007-03-26 11:08:11.000000000 -0700
@@ -45,24 +45,16 @@
 	struct page *page = virt_to_page(pgd);
 
 	spin_lock(&pgd_lock);
-	page->index = (pgoff_t)pgd_list;
-	if (pgd_list)
-		pgd_list->private = (unsigned long)&page->index;
-	pgd_list = page;
-	page->private = (unsigned long)&pgd_list;
+	list_add(&page->lru, &pgd_list);
 	spin_unlock(&pgd_lock);
 }
 
 static inline void pgd_list_del(pgd_t *pgd)
 {
-	struct page *next, **pprev, *page = virt_to_page(pgd);
+	struct page *page = virt_to_page(pgd);
 
 	spin_lock(&pgd_lock);
-	next = (struct page *)page->index;
-	pprev = (struct page **)page->private;
-	*pprev = next;
-	if (next)
-		next->private = (unsigned long)pprev;
+	list_del(&page->lru);
 	spin_unlock(&pgd_lock);
 }
 
