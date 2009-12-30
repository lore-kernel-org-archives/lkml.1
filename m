Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbZL3FVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbZL3FVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZL3FVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:21:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:17866 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZL3FVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B32LSTztUIRImyYiivZAPwrGPLoSxxQsGjeC403w7j7bLFgQkjwu9/WrVUitV1nmP8
         07oAD0e6sSAd/7l9xkxiJ43FRo6x0Coxg8hbImYjoOQDIH1FJCMz47ZhYqdTM5E++qbh
         qnQx6os4cNSCnQB6uH0sh2hVoG+2sRJKxTJSI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/4] reiserfs: Fix reiserfs lock <-> i_xattr_sem dependency inversion
Date: Wed, 30 Dec 2009 06:21:28 +0100
Message-Id: <1262150491-9983-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i_xattr_sem depends on the reiserfs lock. But after we grab
i_xattr_sem, we may relax/relock the reiserfs lock while waiting
on a freezed filesystem, creating a dependency inversion between
the two locks.

In order to avoid the i_xattr_sem -> reiserfs lock dependency, let's
create a reiserfs_down_read_safe() that acts like
reiserfs_mutex_lock_safe(): relax the reiserfs lock while grabbing
another lock to avoid undesired dependencies induced by the
heivyweight reiserfs lock.

This fixes the following warning:

[  990.005931] =======================================================
[  990.012373] [ INFO: possible circular locking dependency detected ]
[  990.013233] 2.6.33-rc1 #1
[  990.013233] -------------------------------------------------------
[  990.013233] dbench/1891 is trying to acquire lock:
[  990.013233]  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<ffffffff81159505>] reiserfs_write_lock+0x35/0x50
[  990.013233]
[  990.013233] but task is already holding lock:
[  990.013233]  (&REISERFS_I(inode)->i_xattr_sem){+.+.+.}, at: [<ffffffff8115899a>] reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233]
[  990.013233] which lock already depends on the new lock.
[  990.013233]
[  990.013233]
[  990.013233] the existing dependency chain (in reverse order) is:
[  990.013233]
[  990.013233] -> #1 (&REISERFS_I(inode)->i_xattr_sem){+.+.+.}:
[  990.013233]        [<ffffffff81063afc>] __lock_acquire+0xf9c/0x1560
[  990.013233]        [<ffffffff8106414f>] lock_acquire+0x8f/0xb0
[  990.013233]        [<ffffffff814ac194>] down_write+0x44/0x80
[  990.013233]        [<ffffffff8115899a>] reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233]        [<ffffffff81158e30>] reiserfs_xattr_set+0xb0/0x150
[  990.013233]        [<ffffffff8115a6aa>] user_set+0x8a/0x90
[  990.013233]        [<ffffffff8115901a>] reiserfs_setxattr+0xaa/0xb0
[  990.013233]        [<ffffffff810e2596>] __vfs_setxattr_noperm+0x36/0xa0
[  990.013233]        [<ffffffff810e26bc>] vfs_setxattr+0xbc/0xc0
[  990.013233]        [<ffffffff810e2780>] setxattr+0xc0/0x150
[  990.013233]        [<ffffffff810e289d>] sys_fsetxattr+0x8d/0xa0
[  990.013233]        [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b
[  990.013233]
[  990.013233] -> #0 (&REISERFS_SB(s)->lock){+.+.+.}:
[  990.013233]        [<ffffffff81063e30>] __lock_acquire+0x12d0/0x1560
[  990.013233]        [<ffffffff8106414f>] lock_acquire+0x8f/0xb0
[  990.013233]        [<ffffffff814aba77>] __mutex_lock_common+0x47/0x3b0
[  990.013233]        [<ffffffff814abebe>] mutex_lock_nested+0x3e/0x50
[  990.013233]        [<ffffffff81159505>] reiserfs_write_lock+0x35/0x50
[  990.013233]        [<ffffffff811340e5>] reiserfs_prepare_write+0x45/0x180
[  990.013233]        [<ffffffff81158bb6>] reiserfs_xattr_set_handle+0x2a6/0x470
[  990.013233]        [<ffffffff81158e30>] reiserfs_xattr_set+0xb0/0x150
[  990.013233]        [<ffffffff8115a6aa>] user_set+0x8a/0x90
[  990.013233]        [<ffffffff8115901a>] reiserfs_setxattr+0xaa/0xb0
[  990.013233]        [<ffffffff810e2596>] __vfs_setxattr_noperm+0x36/0xa0
[  990.013233]        [<ffffffff810e26bc>] vfs_setxattr+0xbc/0xc0
[  990.013233]        [<ffffffff810e2780>] setxattr+0xc0/0x150
[  990.013233]        [<ffffffff810e289d>] sys_fsetxattr+0x8d/0xa0
[  990.013233]        [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b
[  990.013233]
[  990.013233] other info that might help us debug this:
[  990.013233]
[  990.013233] 2 locks held by dbench/1891:
[  990.013233]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff810e2678>] vfs_setxattr+0x78/0xc0
[  990.013233]  #1:  (&REISERFS_I(inode)->i_xattr_sem){+.+.+.}, at: [<ffffffff8115899a>] reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233]
[  990.013233] stack backtrace:
[  990.013233] Pid: 1891, comm: dbench Not tainted 2.6.33-rc1 #1
[  990.013233] Call Trace:
[  990.013233]  [<ffffffff81061639>] print_circular_bug+0xe9/0xf0
[  990.013233]  [<ffffffff81063e30>] __lock_acquire+0x12d0/0x1560
[  990.013233]  [<ffffffff8115899a>] ? reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233]  [<ffffffff8106414f>] lock_acquire+0x8f/0xb0
[  990.013233]  [<ffffffff81159505>] ? reiserfs_write_lock+0x35/0x50
[  990.013233]  [<ffffffff8115899a>] ? reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233]  [<ffffffff814aba77>] __mutex_lock_common+0x47/0x3b0
[  990.013233]  [<ffffffff81159505>] ? reiserfs_write_lock+0x35/0x50
[  990.013233]  [<ffffffff81159505>] ? reiserfs_write_lock+0x35/0x50
[  990.013233]  [<ffffffff81062592>] ? mark_held_locks+0x72/0xa0
[  990.013233]  [<ffffffff814ab81d>] ? __mutex_unlock_slowpath+0xbd/0x140
[  990.013233]  [<ffffffff810628ad>] ? trace_hardirqs_on_caller+0x14d/0x1a0
[  990.013233]  [<ffffffff814abebe>] mutex_lock_nested+0x3e/0x50
[  990.013233]  [<ffffffff81159505>] reiserfs_write_lock+0x35/0x50
[  990.013233]  [<ffffffff811340e5>] reiserfs_prepare_write+0x45/0x180
[  990.013233]  [<ffffffff81158bb6>] reiserfs_xattr_set_handle+0x2a6/0x470
[  990.013233]  [<ffffffff81158e30>] reiserfs_xattr_set+0xb0/0x150
[  990.013233]  [<ffffffff814abcb4>] ? __mutex_lock_common+0x284/0x3b0
[  990.013233]  [<ffffffff8115a6aa>] user_set+0x8a/0x90
[  990.013233]  [<ffffffff8115901a>] reiserfs_setxattr+0xaa/0xb0
[  990.013233]  [<ffffffff810e2596>] __vfs_setxattr_noperm+0x36/0xa0
[  990.013233]  [<ffffffff810e26bc>] vfs_setxattr+0xbc/0xc0
[  990.013233]  [<ffffffff810e2780>] setxattr+0xc0/0x150
[  990.013233]  [<ffffffff81056018>] ? sched_clock_cpu+0xb8/0x100
[  990.013233]  [<ffffffff8105eded>] ? trace_hardirqs_off+0xd/0x10
[  990.013233]  [<ffffffff810560a3>] ? cpu_clock+0x43/0x50
[  990.013233]  [<ffffffff810c6820>] ? fget+0xb0/0x110
[  990.013233]  [<ffffffff810c6770>] ? fget+0x0/0x110
[  990.013233]  [<ffffffff81002ddc>] ? sysret_check+0x27/0x62
[  990.013233]  [<ffffffff810e289d>] sys_fsetxattr+0x8d/0xa0
[  990.013233]  [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b

Reported-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/xattr.c         |    2 +-
 include/linux/reiserfs_fs.h |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 8891cd8..a0e2e7a 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -484,7 +484,7 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	down_write(&REISERFS_I(inode)->i_xattr_sem);
+	reiserfs_down_read_safe(&REISERFS_I(inode)->i_xattr_sem, inode->i_sb);
 
 	xahash = xattr_hash(buffer, buffer_size);
 	while (buffer_pos < buffer_size || buffer_pos == 0) {
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 4351b49..35d3f45 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -106,6 +106,14 @@ reiserfs_mutex_lock_nested_safe(struct mutex *m, unsigned int subclass,
 	reiserfs_write_lock(s);
 }
 
+static inline void
+reiserfs_down_read_safe(struct rw_semaphore *sem, struct super_block *s)
+{
+	reiserfs_write_unlock(s);
+	down_read(sem);
+	reiserfs_write_lock(s);
+}
+
 /*
  * When we schedule, we usually want to also release the write lock,
  * according to the previous bkl based locking scheme of reiserfs.
-- 
1.6.2.3

