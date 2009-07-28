Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZG1Xyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZG1Xyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZG1XuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:24 -0400
Received: from kroah.org ([198.145.64.141]:35866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbZG1XuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:58 2009
Message-Id: <20090728234158.605712163@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>
Subject: [patch 47/71] parisc: ensure broadcast tlb purge runs single threaded
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=parisc-ensure-broadcast-tlb-purge-runs-single-threaded.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Helge Deller <deller@gmx.de>

commit e82a3b75127188f20c7780bec580e148beb29da7 upstream.

The TLB flushing functions on hppa, which causes PxTLB broadcasts on the system
bus, needs to be protected by irq-safe spinlocks to avoid irq handlers to deadlock
the kernel. The deadlocks only happened during I/O intensive loads and triggered
pretty seldom, which is why this bug went so long unnoticed.

Signed-off-by: Helge Deller <deller@gmx.de>
[edited to use spin_lock_irqsave on UP as well since we'd been locking there
 all this time anyway, --kyle]
Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/tlbflush.h |   14 +++++++-------
 arch/parisc/kernel/cache.c         |   23 +++++++++++++++--------
 arch/parisc/kernel/pci-dma.c       |   12 ++++++++----
 3 files changed, 30 insertions(+), 19 deletions(-)

--- a/arch/parisc/include/asm/tlbflush.h
+++ b/arch/parisc/include/asm/tlbflush.h
@@ -12,14 +12,12 @@
  * N class systems, only one PxTLB inter processor broadcast can be
  * active at any one time on the Merced bus.  This tlb purge
  * synchronisation is fairly lightweight and harmless so we activate
- * it on all SMP systems not just the N class.  We also need to have
- * preemption disabled on uniprocessor machines, and spin_lock does that
- * nicely.
+ * it on all systems not just the N class.
  */
 extern spinlock_t pa_tlb_lock;
 
-#define purge_tlb_start(x) spin_lock(&pa_tlb_lock)
-#define purge_tlb_end(x) spin_unlock(&pa_tlb_lock)
+#define purge_tlb_start(flags)	spin_lock_irqsave(&pa_tlb_lock, flags)
+#define purge_tlb_end(flags)	spin_unlock_irqrestore(&pa_tlb_lock, flags)
 
 extern void flush_tlb_all(void);
 extern void flush_tlb_all_local(void *);
@@ -63,14 +61,16 @@ static inline void flush_tlb_mm(struct m
 static inline void flush_tlb_page(struct vm_area_struct *vma,
 	unsigned long addr)
 {
+	unsigned long flags;
+
 	/* For one page, it's not worth testing the split_tlb variable */
 
 	mb();
 	mtsp(vma->vm_mm->context,1);
-	purge_tlb_start();
+	purge_tlb_start(flags);
 	pdtlb(addr);
 	pitlb(addr);
-	purge_tlb_end();
+	purge_tlb_end(flags);
 }
 
 void __flush_tlb_range(unsigned long sid,
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -398,12 +398,13 @@ EXPORT_SYMBOL(flush_kernel_icache_range_
 
 void clear_user_page_asm(void *page, unsigned long vaddr)
 {
+	unsigned long flags;
 	/* This function is implemented in assembly in pacache.S */
 	extern void __clear_user_page_asm(void *page, unsigned long vaddr);
 
-	purge_tlb_start();
+	purge_tlb_start(flags);
 	__clear_user_page_asm(page, vaddr);
-	purge_tlb_end();
+	purge_tlb_end(flags);
 }
 
 #define FLUSH_THRESHOLD 0x80000 /* 0.5MB */
@@ -444,20 +445,24 @@ extern void clear_user_page_asm(void *pa
 
 void clear_user_page(void *page, unsigned long vaddr, struct page *pg)
 {
+	unsigned long flags;
+
 	purge_kernel_dcache_page((unsigned long)page);
-	purge_tlb_start();
+	purge_tlb_start(flags);
 	pdtlb_kernel(page);
-	purge_tlb_end();
+	purge_tlb_end(flags);
 	clear_user_page_asm(page, vaddr);
 }
 EXPORT_SYMBOL(clear_user_page);
 
 void flush_kernel_dcache_page_addr(void *addr)
 {
+	unsigned long flags;
+
 	flush_kernel_dcache_page_asm(addr);
-	purge_tlb_start();
+	purge_tlb_start(flags);
 	pdtlb_kernel(addr);
-	purge_tlb_end();
+	purge_tlb_end(flags);
 }
 EXPORT_SYMBOL(flush_kernel_dcache_page_addr);
 
@@ -490,8 +495,10 @@ void __flush_tlb_range(unsigned long sid
 	if (npages >= 512)  /* 2MB of space: arbitrary, should be tuned */
 		flush_tlb_all();
 	else {
+		unsigned long flags;
+
 		mtsp(sid, 1);
-		purge_tlb_start();
+		purge_tlb_start(flags);
 		if (split_tlb) {
 			while (npages--) {
 				pdtlb(start);
@@ -504,7 +511,7 @@ void __flush_tlb_range(unsigned long sid
 				start += PAGE_SIZE;
 			}
 		}
-		purge_tlb_end();
+		purge_tlb_end(flags);
 	}
 }
 
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -90,12 +90,14 @@ static inline int map_pte_uncached(pte_t
 	if (end > PMD_SIZE)
 		end = PMD_SIZE;
 	do {
+		unsigned long flags;
+
 		if (!pte_none(*pte))
 			printk(KERN_ERR "map_pte_uncached: page already exists\n");
 		set_pte(pte, __mk_pte(*paddr_ptr, PAGE_KERNEL_UNC));
-		purge_tlb_start();
+		purge_tlb_start(flags);
 		pdtlb_kernel(orig_vaddr);
-		purge_tlb_end();
+		purge_tlb_end(flags);
 		vaddr += PAGE_SIZE;
 		orig_vaddr += PAGE_SIZE;
 		(*paddr_ptr) += PAGE_SIZE;
@@ -168,11 +170,13 @@ static inline void unmap_uncached_pte(pm
 	if (end > PMD_SIZE)
 		end = PMD_SIZE;
 	do {
+		unsigned long flags;
 		pte_t page = *pte;
+
 		pte_clear(&init_mm, vaddr, pte);
-		purge_tlb_start();
+		purge_tlb_start(flags);
 		pdtlb_kernel(orig_vaddr);
-		purge_tlb_end();
+		purge_tlb_end(flags);
 		vaddr += PAGE_SIZE;
 		orig_vaddr += PAGE_SIZE;
 		pte++;


