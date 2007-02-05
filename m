Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbXBEReL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbXBEReL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXBEReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:34:11 -0500
Received: from verein.lst.de ([213.95.11.210]:35569 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXBEReJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:34:09 -0500
Date: Mon, 5 Feb 2007 18:34:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, haveblue@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH[RFC] don't force remount in sysrq-u (emergency remount r/o)
Message-ID: <20070205173400.GB25790@lst.de>
References: <20070205173247.GA25790@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205173247.GA25790@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 06:32:47PM +0100, Christoph Hellwig wrote:
> Hi there,
> 
> in two recent discussions (file_list_lock scalability and remount r/o
> on suspend) I stumbled over this emergency remount feature.  It's not
> actually useful because it tries a potentially dangerous remount
> despite writers still beeing in progress, which we can't get rid.
> 
> I've attached one patch in this mail that simply kills the
> functionality, and in a reply to this mail I'll send a second one
> that keeps the sysrq functionality, but removes the force argument
> from do_remount_sb that overrides the still busy check.  This version
> is currently not useful, but makes a lot of sense once Dave Hansens
> per-mountpoint r/o patches get in, as we can check for a real write
> in progress instead of simply a file opened with write permission.

And here is the alternate patch that simply removes the forced remount
r/o hack:


Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2007-02-05 18:21:03.000000000 +0100
+++ linux-2.6/fs/namespace.c	2007-02-05 18:21:18.000000000 +0100
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
--- linux-2.6.orig/fs/super.c	2007-02-05 18:21:03.000000000 +0100
+++ linux-2.6/fs/super.c	2007-02-05 18:21:48.000000000 +0100
@@ -557,26 +557,6 @@
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
@@ -585,7 +565,7 @@
  *
  *	Alters the mount options of a mounted file system.
  */
-int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
+int do_remount_sb(struct super_block *sb, int flags, void *data)
 {
 	int retval;
 	
@@ -601,9 +581,7 @@
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
-		if (force)
-			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
+		if (!fs_may_remount_ro(sb))
 			return -EBUSY;
 	}
 
@@ -634,7 +612,7 @@
 			 * What lock protects sb->s_flags??
 			 */
 			lock_kernel();
-			do_remount_sb(sb, MS_RDONLY, NULL, 1);
+			do_remount_sb(sb, MS_RDONLY, NULL);
 			unlock_kernel();
 		}
 		drop_super(sb);
@@ -861,7 +839,7 @@
 		}
 		s->s_flags |= MS_ACTIVE;
 	}
-	do_remount_sb(s, flags, data, 0);
+	do_remount_sb(s, flags, data);
 	return simple_set_mnt(mnt, s);
 }
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2007-02-05 18:21:03.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2007-02-05 18:21:27.000000000 +0100
@@ -1600,8 +1600,7 @@
 extern void __fsync_super(struct super_block *sb);
 extern void emergency_sync(void);
 extern void emergency_remount(void);
-extern int do_remount_sb(struct super_block *sb, int flags,
-			 void *data, int force);
+extern int do_remount_sb(struct super_block *sb, int flags, void *data);
 #ifdef CONFIG_BLOCK
 extern sector_t bmap(struct inode *, sector_t);
 #endif
