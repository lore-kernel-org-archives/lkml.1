Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbXIXRrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbXIXRrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbXIXRrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:47:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35937 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbXIXRrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:47:02 -0400
Subject: [PATCH] make lockdep happy with r/o bind mounts
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, adobriyan@sw.ru, peterz@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 24 Sep 2007 10:46:58 -0700
Message-Id: <20070924174658.2B3D54B8@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With the r/o bind mount patches, we can have as many
spinlocks nested as there are CPUs on the system.
Lockdep freaks out after 8.

So, create a new lockdep class of locks for the
mnt_writer spinlocks, and initialize each of the
cpu locks to be in a different class.

It should shut up warnings like this, while still
allowing some of the lockdep goodness to remain:

=============================================
[ INFO: possible recursive locking detected ]
2.6.23-rc6 #6
---------------------------------------------
swapper/1 is trying to acquire lock:
 (&writer->lock){--..}, at: [<c016c094>] lock_and_coalesce_cpu_mnt_writer_counts+0x29/0x5c

but task is already holding lock:
 (&writer->lock){--..}, at: [<c016c094>] lock_and_coalesce_cpu_mnt_writer_counts+0x29/0x5c

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (&writer->lock){--..}, at: [<c016c094>] lock_and_coalesce_cpu_mnt_writer_counts+0x29/0x5c

stack backtrace:
 [<c01034ab>] show_trace_log_lvl+0x19/0x2e
 [<c01034d2>] show_trace+0x12/0x14
 [<c01035be>] dump_stack+0x14/0x16
 [<c0130ab2>] print_deadlock_bug+0xb7/0xc1
 [<c0130afc>] check_deadlock+0x40/0x54
 [<c013100a>] validate_chain+0x26e/0x319
 [<c0132cca>] __lock_acquire+0x6c4/0x731
 [<c01332da>] lock_acquire+0x7a/0x94
 [<c031bb01>] _spin_lock+0x38/0x62
 [<c016c094>] lock_and_coalesce_cpu_mnt_writer_counts+0x29/0x5c
 [<c016c5f8>] mntput_no_expire+0x38/0xad
 [<c015fbed>] path_release_on_umount+0x15/0x18
 [<c016cc76>] sys_umount+0x67/0x6f
 [<c010058a>] name_to_dev_t+0x22a/0x24c
 [<c0427207>] prepare_namespace+0x89/0x187
 [<c0426cdd>] kernel_init+0x9a/0xa3
 [<c010336f>] kernel_thread_helper+0x7/0x10
 =======================

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namespace.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/namespace.c~make-lockdep-happy-with-ro-bind-mounts fs/namespace.c
--- lxc/fs/namespace.c~make-lockdep-happy-with-ro-bind-mounts	2007-09-24 10:32:23.000000000 -0700
+++ lxc-dave/fs/namespace.c	2007-09-24 10:41:37.000000000 -0700
@@ -116,6 +116,7 @@ struct mnt_writer {
 	 * must be ordered by cpu number.
 	 */
 	spinlock_t lock;
+	struct lock_class_key lock_class; /* compiles out with !lockdep */
 	unsigned long count;
 	struct vfsmount *mnt;
 } ____cacheline_aligned_in_smp;
@@ -127,6 +128,7 @@ static int __init init_mnt_writers(void)
 	for_each_possible_cpu(cpu) {
 		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
 		spin_lock_init(&writer->lock);
+		lockdep_set_class(&writer->lock, &writer->lock_class);
 		writer->count = 0;
 	}
 	return 0;
diff -puN include/linux/lockdep.h~make-lockdep-happy-with-ro-bind-mounts include/linux/lockdep.h
_
