Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZDPO2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZDPO2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZDPO2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:28:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41823 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZDPO2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=giiGUJ5hek+xjC58RAJcRYFBbVdU7NIPsLIg72AdDQNw6oLBAZt7ntdwpMJA+tO7Jl
         AnsriNh9tVLJkCK4cS0trLELGEKbzQ2V5dyIGRaq0Sxzu/SGMqYtsWakNAMSFTyK8/7a
         pV9NiFrglGDWa0+GPk/ZMyDWxQEXiOOXzPWMM=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH -tip] remove the BKL: Replace BKL in mount/umount syscalls with a mutex
Date: Thu, 16 Apr 2009 16:27:58 +0200
Message-Id: <1239892078-6039-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ths BKL in sys_mount()/sys_umount() syscalls with a regular mutex.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/namespace.c |   16 +++++++++-------
 fs/super.c     |    9 ++++-----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c6f54e4..fcebca1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -11,7 +11,7 @@
 #include <linux/syscalls.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/acct.h>
@@ -51,6 +51,8 @@ static struct rw_semaphore namespace_sem;
 struct kobject *fs_kobj;
 EXPORT_SYMBOL_GPL(fs_kobj);
 
+DEFINE_MUTEX(mount_lock);
+
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 {
 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
@@ -1073,9 +1075,9 @@ static int do_umount(struct vfsmount *mnt, int flags)
 	 */
 
 	if (flags & MNT_FORCE && sb->s_op->umount_begin) {
-		lock_kernel();
+		mutex_lock(&mount_lock);
 		sb->s_op->umount_begin(sb);
-		unlock_kernel();
+		mutex_unlock(&mount_lock);
 	}
 
 	/*
@@ -1094,9 +1096,9 @@ static int do_umount(struct vfsmount *mnt, int flags)
 		 */
 		down_write(&sb->s_umount);
 		if (!(sb->s_flags & MS_RDONLY)) {
-			lock_kernel();
+			mutex_lock(&mount_lock);
 			retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);
-			unlock_kernel();
+			mutex_unlock(&mount_lock);
 		}
 		up_write(&sb->s_umount);
 		return retval;
@@ -2078,10 +2080,10 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 	if (retval < 0)
 		goto out3;
 
-	lock_kernel();
+	mutex_lock(&mount_lock);
 	retval = do_mount((char *)dev_page, dir_page, (char *)type_page,
 			  flags, (void *)data_page);
-	unlock_kernel();
+	mutex_unlock(&mount_lock);
 	free_page(data_page);
 
 out3:
diff --git a/fs/super.c b/fs/super.c
index d9903a3..c503758 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/acct.h>
 #include <linux/blkdev.h>
 #include <linux/quotaops.h>
@@ -46,6 +45,8 @@
 LIST_HEAD(super_blocks);
 DEFINE_SPINLOCK(sb_lock);
 
+extern struct mutex mount_lock;
+
 /**
  *	alloc_super	-	create new superblock
  *	@type:	filesystem type superblock should belong to
@@ -684,13 +685,11 @@ static void do_emergency_remount(struct work_struct *work)
 		down_read(&sb->s_umount);
 		if (sb->s_root && sb->s_bdev && !(sb->s_flags & MS_RDONLY)) {
 			/*
-			 * ->remount_fs needs lock_kernel().
-			 *
 			 * What lock protects sb->s_flags??
 			 */
-			lock_kernel();
+			mutex_lock(&mount_lock);
 			do_remount_sb(sb, MS_RDONLY, NULL, 1);
-			unlock_kernel();
+			mutex_unlock(&mount_lock);
 		}
 		drop_super(sb);
 		spin_lock(&sb_lock);
-- 
1.6.0.4

