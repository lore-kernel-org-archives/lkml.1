Return-Path: <linux-kernel-owner+w=401wt.eu-S934384AbYAaWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbYAaWWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbYAaWWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:22:00 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53110 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755917AbYAaWV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:21:59 -0500
Date: Thu, 31 Jan 2008 14:21:58 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: mmu_notifier: Move mmu_notifier_release up to get rid of the
 invalidat_all() callback
In-Reply-To: <Pine.LNX.4.64.0801311355260.27804@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0801311421110.22290@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.785269387@sgi.com>
 <20080131123118.GK7185@v2.random> <Pine.LNX.4.64.0801311355260.27804@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmu_notifier: Move mmu_notifier_release up to get rid of invalidate_all()

It seems that it is safe to call mmu_notifier_release() before we tear down
the pages and the vmas since we are the only executing thread. mmu_notifier_release
can then also tear down all its external ptes and thus we can get rid
of the invalidate_all() callback.

During the final teardown no mmu_notifier calls are registered anymore which
will speed up exit processing.

Is this okay for KVM too?

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mmu_notifier.h |    4 ----
 mm/mmap.c                    |    3 +--
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/include/linux/mmu_notifier.h
===================================================================
--- linux-2.6.orig/include/linux/mmu_notifier.h	2008-01-31 14:17:17.000000000 -0800
+++ linux-2.6/include/linux/mmu_notifier.h	2008-01-31 14:17:28.000000000 -0800
@@ -59,10 +59,6 @@ struct mmu_notifier_ops {
 	void (*release)(struct mmu_notifier *mn,
 			struct mm_struct *mm);
 
-	/* Dummy needed because the mmu_notifier() macro requires it */
-	void (*invalidate_all)(struct mmu_notifier *mn, struct mm_struct *mm,
-				int dummy);
-
 	/*
 	 * age_page is called from contexts where the pte_lock is held
 	 */
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c	2008-01-31 14:16:51.000000000 -0800
+++ linux-2.6/mm/mmap.c	2008-01-31 14:17:10.000000000 -0800
@@ -2036,7 +2036,7 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long end;
 
 	/* mm's last user has gone, and its about to be pulled down */
-	mmu_notifier(invalidate_all, mm, 0);
+	mmu_notifier_release(mm);
 	arch_exit_mmap(mm);
 
 	lru_add_drain();
@@ -2048,7 +2048,6 @@ void exit_mmap(struct mm_struct *mm)
 	vm_unacct_memory(nr_accounted);
 	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
-	mmu_notifier_release(mm);
 
 	/*
 	 * Walk the list again, actually closing and freeing it,

