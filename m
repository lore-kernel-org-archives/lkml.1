Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbXGXIjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbXGXIjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXGXIjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:39:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51794 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765495AbXGXIjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:39:31 -0400
Date: Tue, 24 Jul 2007 10:38:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: [patch] mm: reduce pagetable-freeing latencies
Message-ID: <20070724083855.GA858@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


the patch below has been tested in -rt for a long time - lets get it 
upstream please. It fixes some bad latencies on PREEMPT too.

	Ingo

----------------------->
From: Hugh Dickins <hugh@veritas.com>
Subject: mm: reduce pagetable-freeing latencies

2.6.15-rc1 moved the unlinking of a vma from its prio_tree and anon_vma
into free_pgtables: so the vma is hidden from rmap and vmtruncate before
freeing its page tables, allowing safe descent without page table lock.
But free_pgtables is still called with preemption disabled, and Lee
Revell has now detected high latency there.

The right fix will be to rework the mmu_gathering, not to need preemption
disabled; but for now an ugly CONFIG_PREEMPT block in free_pgtables, to
make an initial unlinking pass with preemption enabled - made uglier by
CONFIG_IA64 definitions (only ia64 actually uses the start and end given
to tlb_finish_mmu, and our floor and ceiling don't quite work for those).
These CONFIG choices being to minimize the additional TLB flushing.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
--

 mm/memory.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: linux-rt-rebase.q/mm/memory.c
===================================================================
--- linux-rt-rebase.q.orig/mm/memory.c
+++ linux-rt-rebase.q/mm/memory.c
@@ -264,18 +264,48 @@ void free_pgd_range(struct mmu_gather **
 		flush_tlb_pgtables((*tlb)->mm, start, end);
 }
 
+#ifdef CONFIG_IA64
+#define tlb_start_addr(tlb)	(tlb)->start_addr
+#define tlb_end_addr(tlb)	(tlb)->end_addr
+#else
+#define tlb_start_addr(tlb)	0UL	/* only ia64 really uses it */
+#define tlb_end_addr(tlb)	0UL	/* only ia64 really uses it */
+#endif
+
 void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *vma,
 		unsigned long floor, unsigned long ceiling)
 {
+#ifdef CONFIG_PREEMPT
+	struct vm_area_struct *unlink = vma;
+	int fullmm = (*tlb)->fullmm;
+
+	if (!vma)	/* Sometimes when exiting after an oops */
+		return;
+	if (vma->vm_next)
+		tlb_finish_mmu(*tlb, tlb_start_addr(*tlb), tlb_end_addr(*tlb));
+	/*
+	 * Hide vma from rmap and vmtruncate before freeeing pgtables,
+	 * with preemption enabled, except when unmapping just one area.
+	 */
+	while (unlink) {
+		anon_vma_unlink(unlink);
+		unlink_file_vma(unlink);
+		unlink = unlink->vm_next;
+	}
+	if (vma->vm_next)
+		*tlb = tlb_gather_mmu(vma->vm_mm, fullmm);
+#endif
 	while (vma) {
 		struct vm_area_struct *next = vma->vm_next;
 		unsigned long addr = vma->vm_start;
 
+#ifndef CONFIG_PREEMPT
 		/*
 		 * Hide vma from rmap and vmtruncate before freeing pgtables
 		 */
 		anon_vma_unlink(vma);
 		unlink_file_vma(vma);
+#endif
 
 		if (is_vm_hugetlb_page(vma)) {
 			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
@@ -288,8 +318,10 @@ void free_pgtables(struct mmu_gather **t
 			       && !is_vm_hugetlb_page(next)) {
 				vma = next;
 				next = vma->vm_next;
+#ifndef CONFIG_PREEMPT
 				anon_vma_unlink(vma);
 				unlink_file_vma(vma);
+#endif
 			}
 			free_pgd_range(tlb, addr, vma->vm_end,
 				floor, next? next->vm_start: ceiling);
