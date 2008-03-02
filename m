Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYCBQEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYCBQEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 11:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbYCBQEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 11:04:04 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41177
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYCBQEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 11:04:01 -0500
Date: Sun, 2 Mar 2008 17:03:51 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v8 + xpmem
Message-ID: <20080302160351.GL8091@v2.random>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302155457.GK8091@v2.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here an example of the futher orthogonal work to do on top of #v8
during .26-rc to make the whole mmu notifier API sleep capable.

1) Every single ptep_clear_flush_young_notify and
ptep_clear_flush_notify must be converted like the below. The below is
the conversion of a single one. do_wp_page has been converted by
Christoph already but with invalidate_range (should be changed to
invalidate_page by releasing the refcount on the page after calling
invalidate_page). Hope it's clear why I'd rather not depend on these
changes to be merged in .25 in order to have the mmu notifier included
in .25.

2) Then after all this conversion work is finished, it's trivial to
delete ptep_clear_flush_young_notify and ptep_clear_flush_notify from
mmu_notifier.h (they will be unused macros once the conversion is
complete).

3) After that the VM has to be changed to convert anon_vma lock and
i_mmap_lock spinlocks to mutex/rwsemaphore.

4) Then finally the mmu_notifier_unregister must be dropped to make the
mmu notifier sleep capable with RCU in the mmu_notifier() fast path.

It's unclear at this point if 3/4 should be switchable and happening
under a CONFIG_XPMEM or similar or if everyone will benefit from those
spinlock becoming mutex (the only one that is certain to appreciate
such a change is preempt-rt, the rest of the userbase I don't know for
sure and I'd be more confortable with a TPC number comparison before
doing such a chance by default, but I leave the commentary on such a
change to linux-mm in a separate thread).

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

diff --git a/mm/rmap.c b/mm/rmap.c
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -274,7 +274,7 @@ static int page_referenced_one(struct pa
 	unsigned long address;
 	pte_t *pte;
 	spinlock_t *ptl;
-	int referenced = 0;
+	int referenced = 0, clear_flush_young = 0;
 
 	address = vma_address(page, vma);
 	if (address == -EFAULT)
@@ -287,8 +287,11 @@ static int page_referenced_one(struct pa
 	if (vma->vm_flags & VM_LOCKED) {
 		referenced++;
 		*mapcount = 1;	/* break early from loop */
-	} else if (ptep_clear_flush_young_notify(vma, address, pte))
-		referenced++;
+	} else {
+		clear_flush_young = 1;
+		if (ptep_clear_flush_young(vma, address, pte))
+			referenced++;
+	}
 
 	/* Pretend the page is referenced if the task has the
 	   swap token and is in the middle of a page fault. */
@@ -298,6 +301,11 @@ static int page_referenced_one(struct pa
 
 	(*mapcount)--;
 	pte_unmap_unlock(pte, ptl);
+
+	if (clear_flush_young)
+		referenced += mmu_notifier_clear_flush_young(vma->vm_mm,
+							     address);
+
 out:
 	return referenced;
 }

