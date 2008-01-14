Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYANWUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYANWUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbYANWQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:49 -0500
Received: from mx1.suse.de ([195.135.220.2]:59729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425AbYANWQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:44 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [11/31] CPA: Change 32bit back to init_mm semaphore locking
Message-Id: <20080114221643.6F55B14F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that debug pagealloc uses a separate function it is better
to change standard change_page_attr back to init_mm semaphore locking like 64bit.
Various things are simpler when sleeping is allowed.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -14,10 +14,9 @@
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 
-static DEFINE_SPINLOCK(cpa_lock);
+/* Protected by init_mm.mmap_sem */
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
 
-
 pte_t *lookup_address(unsigned long address, int *level)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
@@ -46,9 +45,7 @@ static struct page *split_large_page(uns
 	struct page *base;
 	pte_t *pbase;
 
-	spin_unlock_irq(&cpa_lock);
 	base = alloc_pages(GFP_KERNEL, 0);
-	spin_lock_irq(&cpa_lock);
 	if (!base) 
 		return NULL;
 
@@ -224,15 +221,14 @@ int change_page_attr(struct page *page, 
 {
 	int err = 0; 
 	int i; 
-	unsigned long flags;
 
-	spin_lock_irqsave(&cpa_lock, flags);
+	down_write(&init_mm.mmap_sem);
 	for (i = 0; i < numpages; i++, page++) { 
 		err = __change_page_attr(page, prot);
 		if (err) 
 			break; 
 	}	
-	spin_unlock_irqrestore(&cpa_lock, flags);
+	up_write(&init_mm.mmap_sem);
 	return err;
 }
 
@@ -243,9 +239,9 @@ void global_flush_tlb(void)
 
 	BUG_ON(irqs_disabled());
 
-	spin_lock_irq(&cpa_lock);
+	down_write(&init_mm.mmap_sem);
 	list_replace_init(&df_list, &l);
-	spin_unlock_irq(&cpa_lock);
+	up_write(&init_mm.mmap_sem);
 	flush_map(&l);
 	list_for_each_entry_safe(pg, next, &l, lru) {
 		list_del(&pg->lru);
