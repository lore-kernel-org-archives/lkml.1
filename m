Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbXBERdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbXBERdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXBERdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:33:54 -0500
Received: from verein.lst.de ([213.95.11.210]:35548 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXBERdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:33:53 -0500
Date: Mon, 5 Feb 2007 18:32:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, haveblue@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH[RFC] kill sysrq-u (emergency remount r/o)
Message-ID: <20070205173247.GA25790@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

in two recent discussions (file_list_lock scalability and remount r/o
on suspend) I stumbled over this emergency remount feature.  It's not
actually useful because it tries a potentially dangerous remount
despite writers still beeing in progress, which we can't get rid.

I've attached one patch in this mail that simply kills the
functionality, and in a reply to this mail I'll send a second one
that keeps the sysrq functionality, but removes the force argument
from do_remount_sb that overrides the still busy check.  This version
is currently not useful, but makes a lot of sense once Dave Hansens
per-mountpoint r/o patches get in, as we can check for a real write
in progress instead of simply a file opened with write permission.

Any ideas and comments?


Index: linux-2.6/drivers/char/sysrq.c
===================================================================
--- linux-2.6.orig/drivers/char/sysrq.c	2007-02-05 18:05:11.000000000 +0100
+++ linux-2.6/drivers/char/sysrq.c	2007-02-05 18:12:47.000000000 +0100
@@ -159,17 +159,6 @@
 	.enable_mask	= SYSRQ_ENABLE_SYNC,
 };
 
-static void sysrq_handle_mountro(int key, struct tty_struct *tty)
-{
-	emergency_remount();
-}
-static struct sysrq_key_op sysrq_mountro_op = {
-	.handler	= sysrq_handle_mountro,
-	.help_msg	= "Unmount",
-	.action_msg	= "Emergency Remount R/O",
-	.enable_mask	= SYSRQ_ENABLE_REMOUNT,
-};
-
 #ifdef CONFIG_LOCKDEP
 static void sysrq_handle_showlocks(int key, struct tty_struct *tty)
 {
@@ -340,7 +329,7 @@
 	&sysrq_unraw_op,		/* r */
 	&sysrq_sync_op,			/* s */
 	&sysrq_showstate_op,		/* t */
-	&sysrq_mountro_op,		/* u */
+	NULL,				/* u */
 	/* v: May be registered at init time by SMP VOYAGER */
 	NULL,				/* v */
 	&sysrq_showstate_blocked_op,	/* w */
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2007-02-05 18:03:23.000000000 +0100
+++ linux-2.6/fs/namespace.c	2007-02-05 18:04:24.000000000 +0100
@@ -597,7 +597,7 @@
 		if (!(sb->s_flags & MS_RDONLY)) {
 			lock_kernel();
 			DQUOT_OFF(sb);
-			retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);
+			retval = do_remount_sb(sb, MS_RDONLY, NULL);
 			unlock_kernel();
 		}
 		up_write(&sb->s_umount);
@@ -964,7 +964,7 @@
 		return -EINVAL;
 
 	down_write(&sb->s_umount);
-	err = do_remount_sb(sb, flags, data, 0);
+	err = do_remount_sb(sb, flags, data);
 	if (!err)
 		nd->mnt->mnt_flags = mnt_flags;
 	up_write(&sb->s_umount);
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2007-02-05 18:03:23.000000000 +0100
+++ linux-2.6/fs/super.c	2007-02-05 18:04:54.000000000 +0100
@@ -557,35 +557,14 @@
 }
 
 /**
- *	mark_files_ro
- *	@sb: superblock in question
- *
- *	All files are marked read/only.  We don't care about pending
- *	delete files so this should be used in 'force' mode only
- */
-
-static void mark_files_ro(struct super_block *sb)
-{
-	struct file *f;
-
-	file_list_lock();
-	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
-		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
-			f->f_mode &= ~FMODE_WRITE;
-	}
-	file_list_unlock();
-}
-
-/**
  *	do_remount_sb - asks filesystem to change mount options.
  *	@sb:	superblock in question
  *	@flags:	numeric part of options
  *	@data:	the rest of options
- *      @force: whether or not to force the change
  *
  *	Alters the mount options of a mounted file system.
  */
-int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
+int do_remount_sb(struct super_block *sb, int flags, void *data)
 {
 	int retval;
 	
@@ -601,9 +580,7 @@
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
-		if (force)
-			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
+		if (!fs_may_remount_ro(sb))
 			return -EBUSY;
 	}
 
@@ -618,37 +595,6 @@
 	return 0;
 }
 
-static void do_emergency_remount(unsigned long foo)
-{
-	struct super_block *sb;
-
-	spin_lock(&sb_lock);
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		sb->s_count++;
-		spin_unlock(&sb_lock);
-		down_read(&sb->s_umount);
-		if (sb->s_root && sb->s_bdev && !(sb->s_flags & MS_RDONLY)) {
-			/*
-			 * ->remount_fs needs lock_kernel().
-			 *
-			 * What lock protects sb->s_flags??
-			 */
-			lock_kernel();
-			do_remount_sb(sb, MS_RDONLY, NULL, 1);
-			unlock_kernel();
-		}
-		drop_super(sb);
-		spin_lock(&sb_lock);
-	}
-	spin_unlock(&sb_lock);
-	printk("Emergency Remount complete\n");
-}
-
-void emergency_remount(void)
-{
-	pdflush_operation(do_emergency_remount, 0);
-}
-
 /*
  * Unnamed block devices are dummy devices used by virtual
  * filesystems which don't use real block-devices.  -- jrs
@@ -861,7 +807,7 @@
 		}
 		s->s_flags |= MS_ACTIVE;
 	}
-	do_remount_sb(s, flags, data, 0);
+	do_remount_sb(s, flags, data);
 	return simple_set_mnt(mnt, s);
 }
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2007-02-05 18:03:23.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2007-02-05 18:05:16.000000000 +0100
@@ -1599,9 +1599,7 @@
 extern void sync_filesystems(int wait);
 extern void __fsync_super(struct super_block *sb);
 extern void emergency_sync(void);
-extern void emergency_remount(void);
-extern int do_remount_sb(struct super_block *sb, int flags,
-			 void *data, int force);
+extern int do_remount_sb(struct super_block *sb, int flags, void *data);
 #ifdef CONFIG_BLOCK
 extern sector_t bmap(struct inode *, sector_t);
 #endif
