Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYHGMfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYHGMfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbYHGMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:34:37 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26464 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753439AbYHGMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:34:34 -0400
X-SourceIP: 80.57.229.25
Subject: [RFC][PATCH 9/7] mm: fix mm_take_all_locks() locking order
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20080804130317.994042639@chello.nl>
References: <20080804130317.994042639@chello.nl>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 13:25:49 +0200
Message-Id: <1218108349.8625.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: mm: fix mm_take_all_locks() locking order

Lockdep spotted:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27-rc1 #270
-------------------------------------------------------
qemu-kvm/2033 is trying to acquire lock:
 (&inode->i_data.i_mmap_lock){----}, at: [<ffffffff802996cc>] mm_take_all_locks+0xc2/0xea

but task is already holding lock:
 (&anon_vma->lock){----}, at: [<ffffffff8029967a>] mm_take_all_locks+0x70/0xea

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&anon_vma->lock){----}:
       [<ffffffff8025cd37>] __lock_acquire+0x11be/0x14d2
       [<ffffffff8025d0a9>] lock_acquire+0x5e/0x7a
       [<ffffffff804c655b>] _spin_lock+0x3b/0x47
       [<ffffffff8029a2ef>] vma_adjust+0x200/0x444
       [<ffffffff8029a662>] split_vma+0x12f/0x146
       [<ffffffff8029bc60>] mprotect_fixup+0x13c/0x536
       [<ffffffff8029c203>] sys_mprotect+0x1a9/0x21e
       [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&inode->i_data.i_mmap_lock){----}:
       [<ffffffff8025ca54>] __lock_acquire+0xedb/0x14d2
       [<ffffffff8025d397>] lock_release_non_nested+0x1c2/0x219
       [<ffffffff8025d515>] lock_release+0x127/0x14a
       [<ffffffff804c6403>] _spin_unlock+0x1e/0x50
       [<ffffffff802995d9>] mm_drop_all_locks+0x7f/0xb0
       [<ffffffff802a965d>] do_mmu_notifier_register+0xe2/0x112
       [<ffffffff802a96a8>] mmu_notifier_register+0xe/0x10
       [<ffffffffa0043b6b>] kvm_dev_ioctl+0x11e/0x287 [kvm]
       [<ffffffff802bd0ca>] vfs_ioctl+0x2a/0x78
       [<ffffffff802bd36f>] do_vfs_ioctl+0x257/0x274
       [<ffffffff802bd3e1>] sys_ioctl+0x55/0x78
       [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

5 locks held by qemu-kvm/2033:
 #0:  (&mm->mmap_sem){----}, at: [<ffffffff802a95d0>] do_mmu_notifier_register+0x55/0x112
 #1:  (mm_all_locks_mutex){--..}, at: [<ffffffff8029963e>] mm_take_all_locks+0x34/0xea
 #2:  (&anon_vma->lock){----}, at: [<ffffffff8029967a>] mm_take_all_locks+0x70/0xea
 #3:  (&anon_vma->lock){----}, at: [<ffffffff8029967a>] mm_take_all_locks+0x70/0xea
 #4:  (&anon_vma->lock){----}, at: [<ffffffff8029967a>] mm_take_all_locks+0x70/0xea

stack backtrace:
Pid: 2033, comm: qemu-kvm Not tainted 2.6.27-rc1 #270

Call Trace:
 [<ffffffff8025b7c7>] print_circular_bug_tail+0xb8/0xc3
 [<ffffffff8025ca54>] __lock_acquire+0xedb/0x14d2
 [<ffffffff80259bb1>] ? add_lock_to_list+0x7e/0xad
 [<ffffffff8029967a>] ? mm_take_all_locks+0x70/0xea
 [<ffffffff8029967a>] ? mm_take_all_locks+0x70/0xea
 [<ffffffff8025d397>] lock_release_non_nested+0x1c2/0x219
 [<ffffffff802996cc>] ? mm_take_all_locks+0xc2/0xea
 [<ffffffff802996cc>] ? mm_take_all_locks+0xc2/0xea
 [<ffffffff8025b202>] ? trace_hardirqs_on_caller+0x4d/0x115
 [<ffffffff802995d9>] ? mm_drop_all_locks+0x7f/0xb0
 [<ffffffff8025d515>] lock_release+0x127/0x14a
 [<ffffffff804c6403>] _spin_unlock+0x1e/0x50
 [<ffffffff802995d9>] mm_drop_all_locks+0x7f/0xb0
 [<ffffffff802a965d>] do_mmu_notifier_register+0xe2/0x112
 [<ffffffff802a96a8>] mmu_notifier_register+0xe/0x10
 [<ffffffffa0043b6b>] kvm_dev_ioctl+0x11e/0x287 [kvm]
 [<ffffffff8033f9f2>] ? file_has_perm+0x83/0x8e
 [<ffffffff802bd0ca>] vfs_ioctl+0x2a/0x78
 [<ffffffff802bd36f>] do_vfs_ioctl+0x257/0x274
 [<ffffffff802bd3e1>] sys_ioctl+0x55/0x78
 [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b

Which the locking hierarchy in mm/rmap.c confirms as 'valid'.

Although I don't think there are any users of these two locks that don't
hold the mmap_sem, therefore the nesting is strictly ok, but since we
already have an established order, we might as well respect it.

Fix this by first taking all the mapping->i_mmap_lock instances and then
take all anon_vma->lock instances.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/mmap.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -2358,11 +2358,17 @@ int mm_take_all_locks(struct mm_struct *
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (signal_pending(current))
 			goto out_unlock;
-		if (vma->anon_vma)
-			vm_lock_anon_vma(mm, vma->anon_vma);
 		if (vma->vm_file && vma->vm_file->f_mapping)
 			vm_lock_mapping(mm, vma->vm_file->f_mapping);
 	}
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (signal_pending(current))
+			goto out_unlock;
+		if (vma->anon_vma)
+			vm_lock_anon_vma(mm, vma->anon_vma);
+	}
+
 	ret = 0;
 
 out_unlock:


