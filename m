Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYKGQ3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYKGQ3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYKGQ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:28:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbYKGQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:28:57 -0500
Date: Fri, 7 Nov 2008 17:28:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20081107162843.GA3510@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Xen fixes filed under tip/core/urgent becase they have MM impact.

 Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (2):
      vmap: cope with vm_unmap_aliases before vmalloc_init()
      xen: make sure stray alias mappings are gone before pinning


 arch/x86/xen/enlighten.c |    5 +++--
 arch/x86/xen/mmu.c       |    9 ++++++---
 mm/vmalloc.c             |    7 +++++++
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b61534c..5e4686d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -863,15 +863,16 @@ static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned l
 	if (PagePinned(virt_to_page(mm->pgd))) {
 		SetPagePinned(page);
 
+		vm_unmap_aliases();
 		if (!PageHighMem(page)) {
 			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
 			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
 				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
-		} else
+		} else {
 			/* make sure there are no stray mappings of
 			   this page */
 			kmap_flush_unused();
-			vm_unmap_aliases();
+		}
 	}
 }
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index aba77b2..89f3b6e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -850,13 +850,16 @@ static int xen_pin_page(struct mm_struct *mm, struct page *page,
    read-only, and can be pinned. */
 static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
 {
+	vm_unmap_aliases();
+
 	xen_mc_batch();
 
-	if (xen_pgd_walk(mm, xen_pin_page, USER_LIMIT)) {
-		/* re-enable interrupts for kmap_flush_unused */
+	 if (xen_pgd_walk(mm, xen_pin_page, USER_LIMIT)) {
+		/* re-enable interrupts for flushing */
 		xen_mc_issue(0);
+
 		kmap_flush_unused();
-		vm_unmap_aliases();
+
 		xen_mc_batch();
 	}
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 66fad3f..ba6b0f5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -592,6 +592,8 @@ static void free_unmap_vmap_area_addr(unsigned long addr)
 
 #define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
 
+static bool vmap_initialized __read_mostly = false;
+
 struct vmap_block_queue {
 	spinlock_t lock;
 	struct list_head free;
@@ -828,6 +830,9 @@ void vm_unmap_aliases(void)
 	int cpu;
 	int flush = 0;
 
+	if (unlikely(!vmap_initialized))
+		return;
+
 	for_each_possible_cpu(cpu) {
 		struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
 		struct vmap_block *vb;
@@ -942,6 +947,8 @@ void __init vmalloc_init(void)
 		INIT_LIST_HEAD(&vbq->dirty);
 		vbq->nr_dirty = 0;
 	}
+
+	vmap_initialized = true;
 }
 
 void unmap_kernel_range(unsigned long addr, unsigned long size)
