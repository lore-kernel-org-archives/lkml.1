Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYHGMgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYHGMgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbYHGMej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:34:39 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26464 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758633AbYHGMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:34:37 -0400
Subject: [RFC][PATCH 8/7] lockdep: annotate mm_take_all_locks()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com, Andrea Arcangeli <andrea@qumranet.com>,
       Roland Dreier <rdreier@cisco.com>
In-Reply-To: <20080804130317.994042639@chello.nl>
References: <20080804130317.994042639@chello.nl>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 13:25:48 +0200
Message-Id: <1218108348.8625.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: annotate mm_take_all_locks()

The nesting is correct due to holding mmap_sem, use the new annotation
to annotate this.

This doesn't solve the MAX_LOCK_DEPTH issue, but 48 seems enough for
the current kvm usage, which does this early on in the life of an mm.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/mmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -2273,14 +2273,14 @@ int install_special_mapping(struct mm_st
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
 
-static void vm_lock_anon_vma(struct anon_vma *anon_vma)
+static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
 	if (!test_bit(0, (unsigned long *) &anon_vma->head.next)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_lock(&anon_vma->lock);
+		spin_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->lock. If some other vma in this mm shares
@@ -2296,7 +2296,7 @@ static void vm_lock_anon_vma(struct anon
 	}
 }
 
-static void vm_lock_mapping(struct address_space *mapping)
+static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
 {
 	if (!test_bit(AS_MM_ALL_LOCKS, &mapping->flags)) {
 		/*
@@ -2310,7 +2310,7 @@ static void vm_lock_mapping(struct addre
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		spin_lock(&mapping->i_mmap_lock);
+		spin_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
 	}
 }
 
@@ -2359,9 +2359,9 @@ int mm_take_all_locks(struct mm_struct *
 		if (signal_pending(current))
 			goto out_unlock;
 		if (vma->anon_vma)
-			vm_lock_anon_vma(vma->anon_vma);
+			vm_lock_anon_vma(mm, vma->anon_vma);
 		if (vma->vm_file && vma->vm_file->f_mapping)
-			vm_lock_mapping(vma->vm_file->f_mapping);
+			vm_lock_mapping(mm, vma->vm_file->f_mapping);
 	}
 	ret = 0;
 


