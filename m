Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbXD2KyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbXD2KyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbXD2Kxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:47 -0400
Received: from mail.suse.de ([195.135.220.2]:52202 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337AbXD2Kxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:31 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [40/48] x86_64: use lru instead of page->index and page->private for pgd lists management.
Message-Id: <20070429105330.65C6F15108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Christoph Lameter <clameter@sgi.com>

x86_64 currently simulates a list using the index and private fields of the
page struct.  Seems that the code was inherited from i386.  But x86_64 does
not use the slab to allocate pgds and pmds etc.  So the lru field is not
used by the slab and therefore available.

This patch uses standard list operations on page->lru to realize pgd
tracking.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/fault.c       |    5 ++---
 include/asm-x86_64/pgalloc.h |   14 +++-----------
 include/asm-x86_64/pgtable.h |    2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

Index: linux/arch/x86_64/mm/fault.c
===================================================================
--- linux.orig/arch/x86_64/mm/fault.c
+++ linux/arch/x86_64/mm/fault.c
@@ -585,7 +585,7 @@ do_sigbus:
 }
 
 DEFINE_SPINLOCK(pgd_lock);
-struct page *pgd_list;
+LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
@@ -605,8 +605,7 @@ void vmalloc_sync_all(void)
 			if (pgd_none(*pgd_ref))
 				continue;
 			spin_lock(&pgd_lock);
-			for (page = pgd_list; page;
-			     page = (struct page *)page->index) {
+			list_for_each_entry(page, &pgd_list, lru) {
 				pgd_t *pgd;
 				pgd = (pgd_t *)page_address(page) + pgd_index(address);
 				if (pgd_none(*pgd))
Index: linux/include/asm-x86_64/pgalloc.h
===================================================================
--- linux.orig/include/asm-x86_64/pgalloc.h
+++ linux/include/asm-x86_64/pgalloc.h
@@ -44,24 +44,16 @@ static inline void pgd_list_add(pgd_t *p
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
 
Index: linux/include/asm-x86_64/pgtable.h
===================================================================
--- linux.orig/include/asm-x86_64/pgtable.h
+++ linux/include/asm-x86_64/pgtable.h
@@ -410,7 +410,7 @@ static inline pte_t pte_modify(pte_t pte
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
 extern spinlock_t pgd_lock;
-extern struct page *pgd_list;
+extern struct list_head pgd_list;
 void vmalloc_sync_all(void);
 
 extern int kern_addr_valid(unsigned long addr); 
