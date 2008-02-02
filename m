Return-Path: <linux-kernel-owner+w=401wt.eu-S1765836AbYBBJKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765836AbYBBJKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbYBBJHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:07:05 -0500
Received: from gw.goop.org ([64.81.55.164]:56648 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759844AbYBBJHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:07:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 7] x86: move all the pgd_list handling to one place
X-Mercurial-Node: 759b2b371102c251f4ae34a6df750de9a8897125
Message-Id: <759b2b371102c251f4ae.1201943119@localhost>
In-Reply-To: <patchbomb.1201943112@localhost>
Date: Sat, 02 Feb 2008 01:05:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pgtable.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -39,32 +39,30 @@
 #endif	/* PAGETABLE_LEVELS > 3 */
 #endif	/* PAGETABLE_LEVELS > 2 */
 
-#ifdef CONFIG_X86_64
 static inline void pgd_list_add(pgd_t *pgd)
 {
 	struct page *page = virt_to_page(pgd);
 
-	spin_lock(&pgd_lock);
 	list_add(&page->lru, &pgd_list);
-	spin_unlock(&pgd_lock);
 }
 
 static inline void pgd_list_del(pgd_t *pgd)
 {
 	struct page *page = virt_to_page(pgd);
 
-	spin_lock(&pgd_lock);
 	list_del(&page->lru);
-	spin_unlock(&pgd_lock);
 }
 
+#ifdef CONFIG_X86_64
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	unsigned boundary;
 	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
 	if (!pgd)
 		return NULL;
+	spin_lock(&pgd_lock);
 	pgd_list_add(pgd);
+	spin_unlock(&pgd_lock);
 	/*
 	 * Copy kernel pointers in from init.
 	 * Could keep a freelist or slab cache of those because the kernel
@@ -81,7 +79,9 @@
 void pgd_free(pgd_t *pgd)
 {
 	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
+	spin_lock(&pgd_lock);
 	pgd_list_del(pgd);
+	spin_unlock(&pgd_lock);
 	free_page((unsigned long)pgd);
 }
 
@@ -96,20 +96,6 @@
  * vmalloc faults work because attached pagetables are never freed.
  * -- wli
  */
-static inline void pgd_list_add(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	list_add(&page->lru, &pgd_list);
-}
-
-static inline void pgd_list_del(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	list_del(&page->lru);
-}
-
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
 


