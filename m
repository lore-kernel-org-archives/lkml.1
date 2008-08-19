Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYHSUdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYHSUdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYHSUdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:33:42 -0400
Received: from gw.goop.org ([64.81.55.164]:54878 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbYHSUdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:33:41 -0400
Message-ID: <48AB2DF3.1020207@goop.org>
Date: Tue, 19 Aug 2008 13:32:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH] xen: clarify locking used when pinning a pagetable.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some comments explaining the locking and pinning algorithm when
using split pte locks.  Also implement a minor optimisation of not
pinning the PTE when not using split pte locks.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -590,8 +590,6 @@
 	pmdidx_limit = 0;
 #endif
 
-	flush |= (*func)(virt_to_page(pgd), PT_PGD);
-
 	for (pgdidx = 0; pgdidx <= pgdidx_limit; pgdidx++) {
 		pud_t *pud;
 
@@ -637,7 +635,11 @@
 			}
 		}
 	}
+
 out:
+	/* Do the top level last, so that the callbacks can use it as
+	   a cue to do final things like tlb flushes. */
+	flush |= (*func)(virt_to_page(pgd), PT_PGD);
 
 	return flush;
 }
@@ -691,6 +693,26 @@
 
 		flush = 0;
 
+		/*
+		 * We need to hold the pagetable lock between the time
+		 * we make the pagetable RO and when we actually pin
+		 * it.  If we don't, then other users may come in and
+		 * attempt to update the pagetable by writing it,
+		 * which will fail because the memory is RO but not
+		 * pinned, so Xen won't do the trap'n'emulate.
+		 *
+		 * If we're using split pte locks, we can't hold the
+		 * entire pagetable's worth of locks during the
+		 * traverse, because we may wrap the preempt count (8
+		 * bits).  The solution is to mark RO and pin each PTE
+		 * page while holding the lock.  This means the number
+		 * of locks we end up holding is never more than a
+		 * batch size (~32 entries, at present).
+		 *
+		 * If we're not using split pte locks, we needn't pin
+		 * the PTE pages independently, because we're
+		 * protected by the overall pagetable lock.
+		 */
 		ptl = NULL;
 		if (level == PT_PTE)
 			ptl = lock_pte(page);
@@ -699,10 +721,9 @@
 					pfn_pte(pfn, PAGE_KERNEL_RO),
 					level == PT_PGD ? UVMF_TLB_FLUSH : 0);
 
-		if (level == PT_PTE)
+		if (ptl) {
 			xen_do_pin(MMUEXT_PIN_L1_TABLE, pfn);
 
-		if (ptl) {
 			/* Queue a deferred unlock for when this batch
 			   is completed. */
 			xen_mc_callback(do_unlock, ptl);
@@ -796,10 +817,18 @@
 		spinlock_t *ptl = NULL;
 		struct multicall_space mcs;
 
+		/*
+		 * Do the converse to pin_page.  If we're using split
+		 * pte locks, we must be holding the lock for while
+		 * the pte page is unpinned but still RO to prevent
+		 * concurrent updates from seeing it in this
+		 * partially-pinned state.
+		 */
 		if (level == PT_PTE) {
 			ptl = lock_pte(page);
 
-			xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
+			if (ptl)
+				xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
 		}
 
 		mcs = __xen_mc_entry(0);
@@ -837,7 +866,7 @@
 
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is unpinned */
-	pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+	unpin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
 #endif
 
 	pgd_walk(pgd, unpin_page, USER_LIMIT);


