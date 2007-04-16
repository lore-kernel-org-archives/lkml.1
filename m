Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXDPSAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXDPSAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXDPR77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:59:59 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:9724 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXDPR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:59:58 -0400
X-AuditID: d80ac287-a0943bb000002c59-71-4623b99b954d 
Date: Mon, 16 Apr 2007 18:59:46 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Zachary Amsden <zach@vmware.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
In-Reply-To: <461FEF1C.5010806@vmware.com>
Message-ID: <Pine.LNX.4.64.0704161831500.8213@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
 <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
 <461FD9BF.90609@vmware.com> <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com>
 <461FEF1C.5010806@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 16 Apr 2007 17:59:55.0725 (UTC) FILETIME=[0A52BFD0:01C78051]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Zachary Amsden wrote:
> 
> If the logic is too difficult to reason about without entering ganda
> bherundasana, then it is simpler to just drop the _defer suffix.  Old / young
> actually is just as serious, not because A-bit is critical (although
> misvirtualizing it will do strange things to the page clocking), but because
> the entire PTE update is delayed - and thus an intervening PTE update which
> remaps the physical page can come in before the A-bit update is flushed.  The
> A-bit update carries the PPN of the original physical page, destroying the
> remap.

Hmm, that is serious.  Perhaps a dangerous divergence from how real
hardware would work, which will get you into trouble down the line?
When, as now, core mm people make some change, failing to take your
case into account.

> So pte_update does the update immediately; it is always safe.  For select
> cases, where there is an immediate pte_update + flush combination, it is
> beneficial to combine the two into one hypercall, saving the several thousand
> cycle round trip into the hypervisor from happening twice.  This is why
> pte_update_defer was used close to the flushes.  I thought David was just
> defining the ptep_test_and_clear_xxx functions properly; I didn't realize he
> was actually using them to decouple the flush across a spinlock or logically
> complex code region.  If that is the case, I agree pte_update instead of defer
> is absolutely the right thing to do.

You're right to want to defer your pte_updates, David is right to want
to batch his TLB flushes.  It bothers me that you have a surprising case,
and that unless you abandon your optimization, it imposes a new constraint
on how to proceed in common code (without #ifdef'ing around).

But perhaps in this case David might concede that the longer we delay
the TLB flush, the more likely a referenced bit is to be missed - that is,
it gets cleared from the pte, but if that page is accessed again before
the TLB is flushed, the processor may well omit to reinstate the accessed
bit, and our stats drift away from reality.

Compromise patch below: would that be satisfactory to you, David?

> 
> I'm a little worried about the TLB consistency here, on real hardware.  If you
> drop the spinlock, you could end up preempted.  If the preemption runs a
> kernel thread, which accesses the same memory for which you just modified the
> page table mappings, the TLB could still have a stale entry.  So, a clear of a
> dirty bit might happen in a writeback thread, but get preempted before the
> flush, then the hardware TLB still has a dirty entry.  This means writes
> through the same virtual address will skip the A/D bit update in the pte.
> Now, for regular user memory access, that might not be a problem, but if it is
> the kernel touching user memory through kmap, the kernel virtual address might
> well ..  I'm off in the weeds.  But still slightly concerned about leaving
> that TLB entry stale across a possible preemption.

I don't see your kernel/kmap case, but certainly it could be a problem
for regular user memory access: the dirty bit could get lost that way,
just as the accessed bit can.  If the accessed bit gets lost, memory
management just makes a bad decision (one amidst many!) about which
page to recycle; if the dirty bit gets lost, user data can vanish
(though usually the write of the dirty page will happen long after
both modifications have been included, with no visible problem).

> 
> As an aside, in the tree I'm looking at, I don't see any users of
> ptep_clear_flush_dirty at all.. doesn't that mean writeback which undirties
> pages will leave the PTEs with latent dirty bits, causing them to get written
> back again when the process exits?  Or does rmap take care of this.  Ahh, I
> just discovered page_mkclean_one.  Never mind.  But still no users of
> ptep_clear_flush_dirty.

ptep_clear_flush_dirty used to be used in msync.c, but page_mkclean_one
etc. has now displaced that use.  Perhaps it'll come back into use again:
it's a primitive we do expect to have around.

Hugh

--- 2.6.21-rc6-mm1/fs/proc/task_mmu.c	2007-04-09 12:18:01.000000000 +0100
+++ linux/fs/proc/task_mmu.c	2007-04-16 18:27:58.000000000 +0100
@@ -432,6 +432,8 @@ static int clear_refs_pte_range(pmd_t *p
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
+	unsigned long flush_start;
+	unsigned long flush_end = 0;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -444,9 +446,22 @@ static int clear_refs_pte_range(pmd_t *p
 			continue;
 
 		/* Clear accessed and referenced bits. */
-		ptep_test_and_clear_young(vma, addr, pte);
+		if (ptep_test_and_clear_young(vma, addr, pte)) {
+			if (!flush_end)
+				flush_start = addr;
+			flush_end = addr + PAGE_SIZE;
+		}
 		ClearPageReferenced(page);
 	}
+	/*
+	 * If we're running over a shadow mode hypervisor, pte updates have
+	 * been deferred, and corruption might ensue if we don't flush TLB
+	 * before dropping page table lock.  In other cases, although repeated
+	 * TLB flushes will be wasteful while this mm is running, the longer
+	 * we delay them, the more likely a referenced bit is to be missed.
+	 */
+	if (flush_end)
+		flush_tlb_range(vma, flush_start, flush_end);
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 	return 0;
@@ -481,7 +496,6 @@ static ssize_t clear_refs_write(struct f
 			if (!is_vm_hugetlb_page(vma))
 				walk_page_range(mm, vma->vm_start, vma->vm_end,
 						&clear_refs_walk, vma);
-		flush_tlb_mm(mm);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
