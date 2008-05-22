Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbYEVW2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbYEVW2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbYEVW14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:27:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34717 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758618AbYEVW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:27:53 -0400
Date: Thu, 22 May 2008 23:15:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] fs code: Push the BKL down into the file system ioctl
 handlers
Message-ID: <20080522231524.52e21eb8@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is in many ways for comment - I'm not 100% up on the internal
locking of the file system layer so probably the changes here are
extremely conservative.

I'd appreciate improvements from fs people, and I suspect in many cases
the BKL isn't needed at all.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index bbfa0e2..d0d8cf4 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -116,13 +116,15 @@ static int raw_release(struct inode *inode, struct file *filp)
 /*
  * Forward ioctls to the underlying block device.
  */
-static int
-raw_ioctl(struct inode *inode, struct file *filp,
-		  unsigned int command, unsigned long arg)
+static long raw_ioctl(struct file *filp, unsigned int command,
+						unsigned long arg)
 {
+	long ret;
 	struct block_device *bdev = filp->private_data;
-
-	return blkdev_ioctl(bdev->bd_inode, NULL, command, arg);
+	lock_kernel();
+	ret = blkdev_ioctl(bdev->bd_inode, NULL, command, arg);
+	unlock_kernel();
+	return ret;
 }
 
 static void bind_device(struct raw_config_request *rq)
@@ -136,13 +138,15 @@ static void bind_device(struct raw_config_request *rq)
  * Deal with ioctls against the raw-device control interface, to bind
  * and unbind other raw devices.
  */
-static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
-			unsigned int command, unsigned long arg)
+static long raw_ctl_ioctl(struct file *filp, unsigned int command,
+							unsigned long arg)
 {
 	struct raw_config_request rq;
 	struct raw_device_data *rawdev;
 	int err = 0;
 
+	lock_kernel();
+
 	switch (command) {
 	case RAW_SETBIND:
 	case RAW_GETBIND:
@@ -231,28 +235,29 @@ static int raw_ctl_ioctl(struct inode *inode, struct file *filp,
 		}
 		break;
 	default:
-		err = -EINVAL;
+		err = -ENOTTY;
 		break;
 	}
 out:
+	unlock_kernel();
 	return err;
 }
 
 static const struct file_operations raw_fops = {
-	.read	=	do_sync_read,
-	.aio_read = 	generic_file_aio_read,
-	.write	=	do_sync_write,
-	.aio_write = 	generic_file_aio_write_nolock,
-	.open	=	raw_open,
-	.release=	raw_release,
-	.ioctl	=	raw_ioctl,
-	.owner	=	THIS_MODULE,
+	.read		=	do_sync_read,
+	.aio_read	= 	generic_file_aio_read,
+	.write		=	do_sync_write,
+	.aio_write	= 	generic_file_aio_write_nolock,
+	.open		=	raw_open,
+	.release	=	raw_release,
+	.unlocked_ioctl	=	raw_ioctl,
+	.owner		=	THIS_MODULE,
 };
 
 static const struct file_operations raw_ctl_fops = {
-	.ioctl	=	raw_ctl_ioctl,
-	.open	=	raw_open,
-	.owner	=	THIS_MODULE,
+	.unlocked_ioctl	=	raw_ctl_ioctl,
+	.open		=	raw_open,
+	.owner		=	THIS_MODULE,
 };
 
 static struct cdev raw_cdev;
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 8aacade..a81b0f3 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -24,12 +24,12 @@ static int autofs_root_symlink(struct inode *,struct dentry *,const char *);
 static int autofs_root_unlink(struct inode *,struct dentry *);
 static int autofs_root_rmdir(struct inode *,struct dentry *);
 static int autofs_root_mkdir(struct inode *,struct dentry *,int);
-static int autofs_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
 
 const struct file_operations autofs_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= autofs_root_readdir,
-	.ioctl		= autofs_root_ioctl,
+	.unlocked_ioctl	= autofs_root_ioctl,
 };
 
 const struct inode_operations autofs_root_inode_operations = {
@@ -499,11 +499,12 @@ static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
 	    put_user(sbi->exp_timeout / HZ, p))
 		return -EFAULT;
 
+	lock_kernel();
 	if (ntimeout > ULONG_MAX/HZ)
 		sbi->exp_timeout = 0;
 	else
 		sbi->exp_timeout = ntimeout * HZ;
-
+	unlock_kernel();
 	return 0;
 }
 
@@ -524,16 +525,20 @@ static inline int autofs_expire_run(struct super_block *sb,
 
 	memset(&pkt,0,sizeof pkt);
 
+	lock_kernel();
+
 	pkt.hdr.proto_version = AUTOFS_PROTO_VERSION;
 	pkt.hdr.type = autofs_ptype_expire;
 
-	if (!sbi->exp_timeout || !(ent = autofs_expire(sb,sbi,mnt)))
+	if (!sbi->exp_timeout || !(ent = autofs_expire(sb,sbi,mnt))) {
+		unlock_kernel();
 		return -EAGAIN;
+	}
 
 	pkt.len = ent->len;
 	memcpy(pkt.name, ent->name, pkt.len);
 	pkt.name[pkt.len] = '\0';
-
+	unlock_kernel();
 	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
 		return -EFAULT;
 
@@ -544,9 +549,10 @@ static inline int autofs_expire_run(struct super_block *sb,
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs_root_ioctl(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg)
+static long autofs_root_ioctl(struct file *filp, unsigned int cmd,
+							unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
 	void __user *argp = (void __user *)arg;
 
diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
index be46805..f4291e0 100644
--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -14,6 +14,7 @@
 #include <linux/time.h>
 #include <linux/signal.h>
 #include <linux/file.h>
+#include <linux/smp_lock.h>
 #include "autofs_i.h"
 
 /* We make this a static variable rather than a part of the superblock; it
@@ -29,6 +30,7 @@ void autofs_catatonic_mode(struct autofs_sb_info *sbi)
 
 	DPRINTK(("autofs: entering catatonic mode\n"));
 
+	lock_kernel();
 	sbi->catatonic = 1;
 	wq = sbi->queues;
 	sbi->queues = NULL;	/* Erase all wait queues */
@@ -43,6 +45,7 @@ void autofs_catatonic_mode(struct autofs_sb_info *sbi)
 	fput(sbi->pipe);	/* Close the pipe */
 	sbi->pipe = NULL;
 	autofs_hash_dputall(&sbi->dirhash); /* Remove all dentry pointers */
+	unlock_kernel();
 }
 
 static int autofs_write(struct file *file, const void *addr, int bytes)
@@ -182,12 +185,16 @@ int autofs_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_toke
 {
 	struct autofs_wait_queue *wq, **wql;
 
+	lock_kernel();
+
 	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
 		if ( wq->wait_queue_token == wait_queue_token )
 			break;
 	}
-	if ( !wq )
+	if ( !wq ) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
 	*wql = wq->next;	/* Unlink from chain */
 	kfree(wq->name);
@@ -199,7 +206,7 @@ int autofs_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_toke
 		kfree(wq);
 	else
 		wake_up(&wq->queue);
-
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index edf5b6b..605e36c 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -17,13 +17,14 @@
 #include <linux/stat.h>
 #include <linux/param.h>
 #include <linux/time.h>
+#include <linux/smp_lock.h>
 #include "autofs_i.h"
 
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
 static int autofs4_dir_unlink(struct inode *,struct dentry *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
-static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static int autofs4_dir_close(struct inode *inode, struct file *file);
 static int autofs4_dir_readdir(struct file * filp, void * dirent, filldir_t filldir);
@@ -36,7 +37,7 @@ const struct file_operations autofs4_root_operations = {
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
 	.readdir	= autofs4_root_readdir,
-	.ioctl		= autofs4_root_ioctl,
+	.unlocked_ioctl	= autofs4_root_ioctl,
 };
 
 const struct file_operations autofs4_dir_operations = {
@@ -901,11 +902,12 @@ static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 	     (rv = put_user(sbi->exp_timeout/HZ, p)))
 		return rv;
 
+	lock_kernel();
 	if (ntimeout > ULONG_MAX/HZ)
 		sbi->exp_timeout = 0;
 	else
 		sbi->exp_timeout = ntimeout * HZ;
-
+	unlock_kernel();
 	return 0;
 }
 
@@ -931,12 +933,12 @@ static inline int autofs4_ask_reghost(struct autofs_sb_info *sbi, int __user *p)
 
 	DPRINTK("returning %d", sbi->needs_reghost);
 
+	lock_kernel();
 	status = put_user(sbi->needs_reghost, p);
-	if (status)
-		return status;
-
-	sbi->needs_reghost = 0;
-	return 0;
+	if (status == 0)
+		sbi->needs_reghost = 0;
+	unlock_kernel();
+	return status;
 }
 
 /*
@@ -955,7 +957,9 @@ static inline int autofs4_toggle_reghost(struct autofs_sb_info *sbi, int __user
 		return status;
 
 	/* turn on/off reghosting, with the val */
+	lock_kernel();
 	sbi->reghost_enabled = val;
+	unlock_kernel();
 	return 0;
 }
 
@@ -992,9 +996,10 @@ int is_autofs4_dentry(struct dentry *dentry)
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg)
+static long autofs4_root_ioctl(struct file *filp, unsigned int cmd,
+							unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
 	void __user *p = (void __user *)arg;
 
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 75e5955..8cf2756 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -15,6 +15,7 @@
 #include <linux/time.h>
 #include <linux/signal.h>
 #include <linux/file.h>
+#include <linux/smp_lock.h>
 #include "autofs_i.h"
 
 /* We make this a static variable rather than a part of the superblock; it
@@ -30,6 +31,8 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 
 	DPRINTK("entering catatonic mode");
 
+	lock_kernel();
+
 	sbi->catatonic = 1;
 	wq = sbi->queues;
 	sbi->queues = NULL;	/* Erase all wait queues */
@@ -43,6 +46,8 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 	}
 	fput(sbi->pipe);	/* Close the pipe */
 	sbi->pipe = NULL;
+
+	unlock_kernel();
 }
 
 static int autofs4_write(struct file *file, const void *addr, int bytes)
@@ -375,6 +380,7 @@ int autofs4_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_tok
 {
 	struct autofs_wait_queue *wq, **wql;
 
+	lock_kernel();
 	mutex_lock(&sbi->wq_mutex);
 	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
 		if (wq->wait_queue_token == wait_queue_token)
@@ -383,6 +389,7 @@ int autofs4_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_tok
 
 	if (!wq) {
 		mutex_unlock(&sbi->wq_mutex);
+		unlock_kernel();
 		return -EINVAL;
 	}
 
@@ -397,7 +404,7 @@ int autofs4_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_tok
 		kfree(wq);
 	else
 		wake_up_interruptible(&wq->queue);
-
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 8ca3bfd..c626acf 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -42,7 +42,7 @@ const struct file_operations ext3_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext3_readdir,		/* we take BKL. needed?*/
-	.ioctl		= ext3_ioctl,		/* BKL held */
+	.unlocked_ioctl	= ext3_ioctl,		/* BKL not held */
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index acc4913..49798ed 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -112,7 +112,7 @@ const struct file_operations ext3_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext3_file_write,
-	.ioctl		= ext3_ioctl,
+	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index 0d0c701..4a9132c 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -18,18 +18,21 @@
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
-int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext3_ioctl(struct file * filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
+	long ret;
 
 	ext3_debug ("cmd = %u, arg = %lu\n", cmd, arg);
 
 	switch (cmd) {
 	case EXT3_IOC_GETFLAGS:
+		lock_kernel();
 		ext3_get_inode_flags(ei);
+		unlock_kernel();
 		flags = ei->i_flags & EXT3_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT3_IOC_SETFLAGS: {
@@ -39,9 +42,13 @@ int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		unsigned int oldflags;
 		unsigned int jflag;
 
+		lock_kernel();
+		
 		err = mnt_want_write(filp->f_path.mnt);
-		if (err)
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 
 		if (!is_owner_or_cap(inode)) {
 			err = -EACCES;
@@ -119,6 +126,7 @@ flags_err:
 		ext3_journal_stop(handle);
 		if (err) {
 			mutex_unlock(&inode->i_mutex);
+			unlock_kernel();
 			return err;
 		}
 
@@ -127,11 +135,16 @@ flags_err:
 		mutex_unlock(&inode->i_mutex);
 flags_out:
 		mnt_drop_write(filp->f_path.mnt);
+		unlock_kernel();
 		return err;
 	}
 	case EXT3_IOC_GETVERSION:
 	case EXT3_IOC_GETVERSION_OLD:
-		return put_user(inode->i_generation, (int __user *) arg);
+		/* Probably not needed but might need inode lock instead */
+		lock_kernel();
+		ret = put_user(inode->i_generation, (int __user *) arg);
+		unlock_kernel();
+		return ret;
 	case EXT3_IOC_SETVERSION:
 	case EXT3_IOC_SETVERSION_OLD: {
 		handle_t *handle;
@@ -141,9 +154,13 @@ flags_out:
 
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
+
+		lock_kernel();
 		err = mnt_want_write(filp->f_path.mnt);
-		if (err)
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 		if (get_user(generation, (int __user *) arg)) {
 			err = -EFAULT;
 			goto setversion_out;
@@ -162,6 +179,7 @@ flags_out:
 		ext3_journal_stop(handle);
 setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
+		unlock_kernel();
 		return err;
 	}
 #ifdef CONFIG_JBD_DEBUG
@@ -189,22 +207,30 @@ setversion_out:
 		}
 #endif
 	case EXT3_IOC_GETRSVSZ:
+		lock_kernel();
 		if (test_opt(inode->i_sb, RESERVATION)
 			&& S_ISREG(inode->i_mode)
 			&& ei->i_block_alloc_info) {
 			rsv_window_size = ei->i_block_alloc_info->rsv_window_node.rsv_goal_size;
+			unlock_kernel();
 			return put_user(rsv_window_size, (int __user *)arg);
 		}
+		unlock_kernel();
 		return -ENOTTY;
 	case EXT3_IOC_SETRSVSZ: {
 		int err;
 
-		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
+		lock_kernel();
+		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode)) {
+			unlock_kernel();
 			return -ENOTTY;
+		}
 
 		err = mnt_want_write(filp->f_path.mnt);
-		if (err)
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 
 		if (!is_owner_or_cap(inode)) {
 			err = -EACCES;
@@ -234,6 +260,7 @@ setversion_out:
 		mutex_unlock(&ei->truncate_mutex);
 setrsvsz_out:
 		mnt_drop_write(filp->f_path.mnt);
+		unlock_kernel();
 		return err;
 	}
 	case EXT3_IOC_GROUP_EXTEND: {
@@ -244,9 +271,12 @@ setrsvsz_out:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
+		lock_kernel();
 		err = mnt_want_write(filp->f_path.mnt);
-		if (err)
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 
 		if (get_user(n_blocks_count, (__u32 __user *)arg)) {
 			err = -EFAULT;
@@ -258,6 +288,7 @@ setrsvsz_out:
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 group_extend_out:
 		mnt_drop_write(filp->f_path.mnt);
+		unlock_kernel();
 		return err;
 	}
 	case EXT3_IOC_GROUP_ADD: {
@@ -268,9 +299,12 @@ group_extend_out:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
+		lock_kernel();
 		err = mnt_want_write(filp->f_path.mnt);
-		if (err)
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 
 		if (copy_from_user(&input, (struct ext3_new_group_input __user *)arg,
 				sizeof(input))) {
@@ -284,6 +318,7 @@ group_extend_out:
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 group_add_out:
 		mnt_drop_write(filp->f_path.mnt);
+		unlock_kernel();
 		return err;
 	}
 
@@ -338,9 +373,7 @@ long ext3_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
-	ret = ext3_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
+	ret = ext3_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 	return ret;
 }
 #endif
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 486725e..7d6e32d 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -738,11 +738,13 @@ static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
 	return ret;
 }
 
-static int fat_dir_ioctl(struct inode *inode, struct file *filp,
-			 unsigned int cmd, unsigned long arg)
+static long fat_dir_ioctl(struct file *filp, unsigned int cmd,
+						unsigned long arg)
 {
 	struct dirent __user *d1 = (struct dirent __user *)arg;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int short_only, both;
+	int ret;
 
 	switch (cmd) {
 	case VFAT_IOCTL_READDIR_SHORT:
@@ -754,7 +756,7 @@ static int fat_dir_ioctl(struct inode *inode, struct file *filp,
 		both = 1;
 		break;
 	default:
-		return fat_generic_ioctl(inode, filp, cmd, arg);
+		return fat_generic_ioctl(filp, cmd, arg);
 	}
 
 	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct dirent[2])))
@@ -767,8 +769,11 @@ static int fat_dir_ioctl(struct inode *inode, struct file *filp,
 	if (put_user(0, &d1->d_reclen))
 		return -EFAULT;
 
-	return fat_ioctl_readdir(inode, filp, d1, fat_ioctl_filldir,
+	lock_kernel();
+	ret = fat_ioctl_readdir(inode, filp, d1, fat_ioctl_filldir,
 				 short_only, both);
+	unlock_kernel();
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -815,7 +820,7 @@ static long fat_compat_dir_ioctl(struct file *filp, unsigned cmd,
 const struct file_operations fat_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= fat_readdir,
-	.ioctl		= fat_dir_ioctl,
+	.unlocked_ioctl	= fat_dir_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= fat_compat_dir_ioctl,
 #endif
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 27cc116..e947748 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -17,9 +17,9 @@
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 
-int fat_generic_ioctl(struct inode *inode, struct file *filp,
-		      unsigned int cmd, unsigned long arg)
+long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	u32 __user *user_attr = (u32 __user *)arg;
 
@@ -28,11 +28,12 @@ int fat_generic_ioctl(struct inode *inode, struct file *filp,
 	{
 		u32 attr;
 
+		lock_kernel();
 		if (inode->i_ino == MSDOS_ROOT_INO)
 			attr = ATTR_DIR;
 		else
 			attr = fat_attr(inode);
-
+		unlock_kernel();
 		return put_user(attr, user_attr);
 	}
 	case FAT_IOCTL_SET_ATTRIBUTES:
@@ -45,6 +46,7 @@ int fat_generic_ioctl(struct inode *inode, struct file *filp,
 		if (err)
 			return err;
 
+		lock_kernel();
 		mutex_lock(&inode->i_mutex);
 
 		err = mnt_want_write(filp->f_path.mnt);
@@ -109,6 +111,7 @@ up:
 		mnt_drop_write(filp->f_path.mnt);
 up_no_drop_write:
 		mutex_unlock(&inode->i_mutex);
+		unlock_kernel();
 		return err;
 	}
 	default:
@@ -134,7 +137,7 @@ const struct file_operations fat_file_operations = {
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.release	= fat_file_release,
-	.ioctl		= fat_generic_ioctl,
+	.unlocked_ioctl	= fat_generic_ioctl,
 	.fsync		= file_fsync,
 	.splice_read	= generic_file_splice_read,
 };
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 5f40236..764fd1b 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -494,7 +494,7 @@ const struct inode_operations hfsplus_dir_inode_operations = {
 const struct file_operations hfsplus_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= hfsplus_readdir,
-	.ioctl          = hfsplus_ioctl,
+	.unlocked_ioctl = hfsplus_ioctl,
 	.llseek		= generic_file_llseek,
 	.release	= hfsplus_dir_release,
 };
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 9e59537..a4b7f69 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -336,8 +336,7 @@ struct inode *hfsplus_new_inode(struct super_block *, int);
 void hfsplus_delete_inode(struct inode *);
 
 /* ioctl.c */
-int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		  unsigned long arg);
+long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 int hfsplus_setxattr(struct dentry *dentry, const char *name,
 		     const void *value, size_t size, int flags);
 ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index d53b2af..df3862d 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -298,7 +298,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.fsync		= file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
-	.ioctl          = hfsplus_ioctl,
+	.unlocked_ioctl = hfsplus_ioctl,
 };
 
 struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index f457d2c..2faca3d 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -18,28 +18,35 @@
 #include <linux/sched.h>
 #include <linux/xattr.h>
 #include <asm/uaccess.h>
+#include <linux/smp_lock.h>
 #include "hfsplus_fs.h"
 
-int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		  unsigned long arg)
+long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int flags;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	switch (cmd) {
 	case HFSPLUS_IOC_EXT2_GETFLAGS:
 		flags = 0;
+		lock_kernel();
 		if (HFSPLUS_I(inode).rootflags & HFSPLUS_FLG_IMMUTABLE)
 			flags |= FS_IMMUTABLE_FL; /* EXT2_IMMUTABLE_FL */
 		if (HFSPLUS_I(inode).rootflags & HFSPLUS_FLG_APPEND)
 			flags |= FS_APPEND_FL; /* EXT2_APPEND_FL */
 		if (HFSPLUS_I(inode).userflags & HFSPLUS_FLG_NODUMP)
 			flags |= FS_NODUMP_FL; /* EXT2_NODUMP_FL */
+		unlock_kernel();
 		return put_user(flags, (int __user *)arg);
 	case HFSPLUS_IOC_EXT2_SETFLAGS: {
 		int err = 0;
+
+		lock_kernel();
 		err = mnt_want_write(filp->f_path.mnt);
-		if (err)
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 
 		if (!is_owner_or_cap(inode)) {
 			err = -EACCES;
@@ -85,6 +92,7 @@ int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		mark_inode_dirty(inode);
 setflags_out:
 		mnt_drop_write(filp->f_path.mnt);
+		unlock_kernel();
 		return err;
 	}
 	default:
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index e6b03d2..f267cf9 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -20,7 +20,7 @@ const struct file_operations reiserfs_dir_operations = {
 	.read = generic_read_dir,
 	.readdir = reiserfs_readdir,
 	.fsync = reiserfs_dir_fsync,
-	.ioctl = reiserfs_ioctl,
+	.unlocked_ioctl = reiserfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = reiserfs_compat_ioctl,
 #endif
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index a804903..e4d415c 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -284,7 +284,7 @@ static ssize_t reiserfs_file_write(struct file *file,	/* the file we are going t
 const struct file_operations reiserfs_file_operations = {
 	.read = do_sync_read,
 	.write = reiserfs_file_write,
-	.ioctl = reiserfs_ioctl,
+	.unlocked_ioctl = reiserfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = reiserfs_compat_ioctl,
 #endif
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 8303320..dd73dd5 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -20,37 +20,47 @@
 **  2) REISERFS_IOC_[GS]ETFLAGS, REISERFS_IOC_[GS]ETVERSION
 **  3) That's all for a while ...
 */
-int reiserfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		   unsigned long arg)
+long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int flags;
-	int err = 0;
+	long err = 0;
 
 	switch (cmd) {
 	case REISERFS_IOC_UNPACK:
+		lock_kernel();
 		if (S_ISREG(inode->i_mode)) {
 			if (arg)
-				return reiserfs_unpack(inode, filp);
-			else
-				return 0;
+				err = reiserfs_unpack(inode, filp);
 		} else
-			return -ENOTTY;
+			err = -ENOTTY;
+		unlock_kernel();
+		return err;
 		/* following two cases are taken from fs/ext2/ioctl.c by Remy
 		   Card (card@masi.ibp.fr) */
 	case REISERFS_IOC_GETFLAGS:
+		lock_kernel();
 		if (!reiserfs_attrs(inode->i_sb))
-			return -ENOTTY;
-
-		flags = REISERFS_I(inode)->i_attrs;
-		i_attrs_to_sd_attrs(inode, (__u16 *) & flags);
-		return put_user(flags, (int __user *)arg);
+			err = -ENOTTY;
+		else {
+			flags = REISERFS_I(inode)->i_attrs;
+			i_attrs_to_sd_attrs(inode, (__u16 *) & flags);
+			err = put_user(flags, (int __user *)arg);
+		}
+		unlock_kernel();
+		return err;
 	case REISERFS_IOC_SETFLAGS:{
-			if (!reiserfs_attrs(inode->i_sb))
+			lock_kernel();
+			if (!reiserfs_attrs(inode->i_sb)) {
+				unlock_kernel();
 				return -ENOTTY;
+			}
 
 			err = mnt_want_write(filp->f_path.mnt);
-			if (err)
+			if (err) {
+				unlock_kernel();
 				return err;
+			}
 
 			if (!is_owner_or_cap(inode)) {
 				err = -EPERM;
@@ -90,16 +100,24 @@ int reiserfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			mark_inode_dirty(inode);
 setflags_out:
 			mnt_drop_write(filp->f_path.mnt);
+			unlock_kernel();
 			return err;
 		}
 	case REISERFS_IOC_GETVERSION:
-		return put_user(inode->i_generation, (int __user *)arg);
+		lock_kernel();
+		err = put_user(inode->i_generation, (int __user *)arg);
+		unlock_kernel();
+		return err;
 	case REISERFS_IOC_SETVERSION:
+		lock_kernel();
 		if (!is_owner_or_cap(inode))
-			return -EPERM;
-		err = mnt_want_write(filp->f_path.mnt);
-		if (err)
+			err = -EPERM;
+		else
+			err = mnt_want_write(filp->f_path.mnt);
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 		if (get_user(inode->i_generation, (int __user *)arg)) {
 			err = -EFAULT;
 			goto setversion_out;
@@ -108,6 +126,7 @@ setflags_out:
 		mark_inode_dirty(inode);
 setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
+		unlock_kernel();
 		return err;
 	default:
 		return -ENOTTY;
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 62dc270..a54557a 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -209,6 +209,6 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 const struct file_operations udf_dir_operations = {
 	.read			= generic_read_dir,
 	.readdir		= udf_readdir,
-	.ioctl			= udf_ioctl,
+	.unlocked_ioctl		= udf_ioctl,
 	.fsync			= udf_fsync_file,
 };
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 0ed6e14..52edc5c 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -143,11 +143,11 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	return retval;
 }
 
-int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-	      unsigned long arg)
+long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	long old_block, new_block;
 	int result = -EINVAL;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	if (file_permission(filp, MAY_READ) != 0) {
 		udf_debug("no permission to access inode %lu\n",
@@ -162,6 +162,7 @@ int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 
 	switch (cmd) {
 	case UDF_GETVOLIDENT:
+		/* Could block anyway so no BKL ? */
 		if (copy_to_user((char __user *)arg,
 				 UDF_SB(inode->i_sb)->s_volume_ident, 32))
 			return -EFAULT;
@@ -172,15 +173,20 @@ int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			return -EACCES;
 		if (get_user(old_block, (long __user *)arg))
 			return -EFAULT;
+		lock_kernel();
 		result = udf_relocate_blocks(inode->i_sb,
 						old_block, &new_block);
+		unlock_kernel();
 		if (result == 0)
 			result = put_user(new_block, (long __user *)arg);
 		return result;
 	case UDF_GETEASIZE:
+		lock_kernel();
 		result = put_user(UDF_I(inode)->i_lenEAttr, (int __user *)arg);
+		unlock_kernel();
 		break;
 	case UDF_GETEABLOCK:
+		/* Could block anyway so no BKL ? */
 		result = copy_to_user((char __user *)arg,
 				      UDF_I(inode)->i_ext.i_data,
 				      UDF_I(inode)->i_lenEAttr) ? -EFAULT : 0;
@@ -203,7 +209,7 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 const struct file_operations udf_file_operations = {
 	.read			= do_sync_read,
 	.aio_read		= generic_file_aio_read,
-	.ioctl			= udf_ioctl,
+	.unlocked_ioctl		= udf_ioctl,
 	.open			= generic_file_open,
 	.mmap			= generic_file_mmap,
 	.write			= do_sync_write,
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 8fa9c2d..e9ae67c 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -120,8 +120,7 @@ extern int udf_write_fi(struct inode *inode, struct fileIdentDesc *,
 			uint8_t *, uint8_t *);
 
 /* file.c */
-extern int udf_ioctl(struct inode *, struct file *, unsigned int,
-		     unsigned long);
+extern long udf_ioctl(struct file *, unsigned int, unsigned long);
 
 /* inode.c */
 extern struct inode *udf_iget(struct super_block *, kernel_lb_addr);
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 36c5403..5aa14c2 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -838,8 +838,7 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 
 /* ioctl.c */
-extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern long ext3_ioctl (struct file *, unsigned int, unsigned long);
 extern long ext3_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* namei.c */
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index b03b274..43ad2c2 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -403,8 +403,8 @@ extern int fat_free_clusters(struct inode *inode, int cluster);
 extern int fat_count_free_clusters(struct super_block *sb);
 
 /* fat/file.c */
-extern int fat_generic_ioctl(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg);
+extern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
+							unsigned long arg);
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
 extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 4aacaee..807b6ed 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2172,8 +2172,7 @@ __u32 r5_hash(const signed char *msg, int len);
 #define SPARE_SPACE 500
 
 /* prototypes from ioctl.c */
-int reiserfs_ioctl(struct inode *inode, struct file *filp,
-		   unsigned int cmd, unsigned long arg);
+long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long reiserfs_compat_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
 int reiserfs_unpack(struct inode *inode, struct file *filp);
