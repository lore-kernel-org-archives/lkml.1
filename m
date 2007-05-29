Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbXE2Pky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbXE2Pky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbXE2Pkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:40:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbXE2Pkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:40:45 -0400
Date: Tue, 29 May 2007 11:40:42 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] add procfs tunable to enable immediate panic when there are
 busy inodes after umount
Message-Id: <20070529114042.5fe0b810.jlayton@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After spending quite a bit of time tracking down a "VFS: busy inodes
after unmount" problem, it occurs to me that it would be nice to be
able to force a panic when that occurs. While an oops message alone is
not generally helpful for tracking down this sort of problem,
collecting and analyzing a coredump when this occurs can be.

The following patch adds a procfs tunable that allows you to force a
core when a "busy inodes after umount" problem occurs. It also changes
the classic error message to be something a bit less cryptic to users.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/block_dev.c b/fs/block_dev.c
diff --git a/fs/inode.c b/fs/inode.c
index 9a012cc..0e638b0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -327,7 +327,7 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 			count++;
 			continue;
 		}
-		busy = 1;
+		++busy;
 	}
 	/* only unused inodes may be cached with i_count zero */
 	inodes_stat.nr_unused -= count;
diff --git a/fs/super.c b/fs/super.c
index 5260d62..9c2871b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -287,6 +287,8 @@ int fsync_super(struct super_block *sb)
 void generic_shutdown_super(struct super_block *sb)
 {
 	const struct super_operations *sop = sb->s_op;
+	extern int umount_debug;
+	int busy;
 
 	if (sb->s_root) {
 		shrink_dcache_for_umount(sb);
@@ -303,10 +305,15 @@ void generic_shutdown_super(struct super_block *sb)
 			sop->put_super(sb);
 
 		/* Forget any remaining inodes */
-		if (invalidate_inodes(sb)) {
-			printk("VFS: Busy inodes after unmount of %s. "
-			   "Self-destruct in 5 seconds.  Have a nice day...\n",
-			   sb->s_id);
+		if (busy = invalidate_inodes(sb)) {
+			printk("VFS: %d busy inodes after unmount of %s. ",
+				 busy, sb->s_id);
+			if (umount_debug != 0) {
+				printk("Crashing host on request.\n");
+				BUG();
+			} else {
+				printk("This machine will likely crash eventually. Consider a reboot.\n");
+			}
 		}
 
 		unlock_kernel();
diff --git a/include/linux/fs.h b/include/linux/fs.h
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 47f1c53..176b984 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -818,6 +818,7 @@ enum
 	FS_AIO_NR=18,	/* current system-wide number of aio requests */
 	FS_AIO_MAX_NR=19,	/* system-wide maximum number of aio requests */
 	FS_INOTIFY=20,	/* inotify submenu */
+	FS_UMOUNT_DEBUG=21, /* busy inodes on umount debug switch */
 	FS_OCFS2=988,	/* ocfs2 */
 };
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 30ee462..8e62c34 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -156,6 +156,7 @@ extern ctl_table pty_table[];
 extern ctl_table inotify_table[];
 #endif
 
+int umount_debug;
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 int sysctl_legacy_va_layout;
 #endif
@@ -962,6 +963,14 @@ static ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= FS_UMOUNT_DEBUG,
+		.procname	= "umount_debug",
+		.data		= &umount_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_DNOTIFY
 	{
 		.ctl_name	= FS_DIR_NOTIFY,
