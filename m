Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbYFTR3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbYFTR3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbYFTR3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:29:18 -0400
Received: from vena.lwn.net ([206.168.112.25]:44164 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528AbYFTR3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:29:16 -0400
Date: Fri, 20 Jun 2008 11:29:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH, RFC] fasync() BKL pushdown
Message-ID: <20080620112914.783be428@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I put together the bkl-removal tree, I didn't add Andi's fasync()
patches because the addition of an unlocked_fasync() function was not
universally accepted.  Recently I decided to take a look and see what would
be involved in just pushing the BKL down into fasync() implementations.  It
turns out that it wasn't too hard.

The majority of fasync() functions just call fasync_helper() with a pointer
to an fasync_struct reachable from the file structure.  Given that (1) the
struct file will not go away while fasync() is running, and (2) the
VFS-level fasync() stuff is protected with the Big Fasync Lock, I contend
that these simple implementations have no need for the BKL.  Once those are
filtered out, there's really only a half-dozen places which need to be
fixed.

(As an aside, fasync_helper() can return a positive value on success.  A
number of fasync() implementations remap that to zero, but quite a few
others return it directly.  That, in turn, will cause fcntl() to return
said positive value to user space, which is contrary to what the man page
says.  There is one user of the positive return value (tty_io.c), so maybe
some aspiring janitor would like to clean up the various fasync() functions
that just do "return fasync_helper(...);"?)

The set of patches is this:

Jonathan Corbet (7):
      mpt: fasync BKL pushdown
      i2o: fasync BKL pushdown
      tun: fasync BKL pushdown
      tty_io: fasync BKL pushdown
      Bluetooth VHCI: fasync BKL pushdown
      ecryptfs: fasync BKL pushdown
      Call fasync() functions without the BKL

And the actual patch is appended.  If nobody objects, I'll pull these into
the bkl-removal tree shortly.

jon

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 7734bc9..d97700a 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -318,18 +318,21 @@ static int vhci_release(struct inode *inode, struct file *file)
 static int vhci_fasync(int fd, struct file *file, int on)
 {
 	struct vhci_data *data = file->private_data;
-	int err;
+	int err = 0;
 
+	lock_kernel();
 	err = fasync_helper(fd, file, on, &data->fasync);
 	if (err < 0)
-		return err;
+		goto out;
 
 	if (on)
 		data->flags |= VHCI_FASYNC;
 	else
 		data->flags &= ~VHCI_FASYNC;
 
-	return 0;
+out:
+	unlock_kernel();
+	return err;
 }
 
 static const struct file_operations vhci_fops = {
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index fd182f2..eda2789 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2909,15 +2909,16 @@ static int tty_fasync(int fd, struct file *filp, int on)
 {
 	struct tty_struct *tty;
 	unsigned long flags;
-	int retval;
+	int retval = 0;
 
+	lock_kernel();
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
-		return 0;
+		goto out;
 
 	retval = fasync_helper(fd, filp, on, &tty->fasync);
 	if (retval <= 0)
-		return retval;
+		goto out;
 
 	if (on) {
 		enum pid_type type;
@@ -2935,12 +2936,15 @@ static int tty_fasync(int fd, struct file *filp, int on)
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
 		if (retval)
-			return retval;
+			goto out;
 	} else {
 		if (!tty->fasync && !waitqueue_active(&tty->read_wait))
 			tty->minimum_to_wake = N_TTY_BUF_SIZE;
 	}
-	return 0;
+	retval = 0;
+out:
+	unlock_kernel();
+	return retval;
 }
 
 /**
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index e630b50..c594656 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -548,11 +548,15 @@ static int
 mptctl_fasync(int fd, struct file *filep, int mode)
 {
 	MPT_ADAPTER	*ioc;
+	int ret;
 
+	lock_kernel();
 	list_for_each_entry(ioc, &ioc_list, list)
 		ioc->aen_event_read_flag=0;
 
-	return fasync_helper(fd, filep, mode, &async_queue);
+	ret = fasync_helper(fd, filep, mode, &async_queue);
+	unlock_kernel();
+	return ret;
 }
 
 static int
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 95b4c10..4238de9 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -1084,15 +1084,17 @@ static int cfg_fasync(int fd, struct file *fp, int on)
 {
 	ulong id = (ulong) fp->private_data;
 	struct i2o_cfg_info *p;
+	int ret = -EBADF;
 
+	lock_kernel();
 	for (p = open_files; p; p = p->next)
 		if (p->q_id == id)
 			break;
 
-	if (!p)
-		return -EBADF;
-
-	return fasync_helper(fd, fp, on, &p->fasync);
+	if (p)
+		ret = fasync_helper(fd, fp, on, &p->fasync);
+	unlock_kernel();
+	return ret;
 }
 
 static int cfg_release(struct inode *inode, struct file *file)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ce5af2a..4c0c597 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -782,18 +782,21 @@ static int tun_chr_fasync(int fd, struct file *file, int on)
 
 	DBG(KERN_INFO "%s: tun_chr_fasync %d\n", tun->dev->name, on);
 
+	lock_kernel();
 	if ((ret = fasync_helper(fd, file, on, &tun->fasync)) < 0)
-		return ret;
+		goto out;
 
 	if (on) {
 		ret = __f_setown(file, task_pid(current), PIDTYPE_PID, 0);
 		if (ret)
-			return ret;
+			goto out;
 		tun->flags |= TUN_FASYNC;
 	} else
 		tun->flags &= ~TUN_FASYNC;
-
-	return 0;
+	ret = 0;
+out:
+	unlock_kernel();
+	return ret;
 }
 
 static int tun_chr_open(struct inode *inode, struct file * file)
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 2258b8f..24749bf 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -30,6 +30,7 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/fs_stack.h>
+#include <linux/smp_lock.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -277,9 +278,11 @@ static int ecryptfs_fasync(int fd, struct file *file, int flag)
 	int rc = 0;
 	struct file *lower_file = NULL;
 
+	lock_kernel();
 	lower_file = ecryptfs_file_to_lower(file);
 	if (lower_file->f_op && lower_file->f_op->fasync)
 		rc = lower_file->f_op->fasync(fd, lower_file, flag);
+	unlock_kernel();
 	return rc;
 }
 
diff --git a/fs/fcntl.c b/fs/fcntl.c
index bfd7765..330a7d7 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -12,7 +12,6 @@
 #include <linux/fdtable.h>
 #include <linux/capability.h>
 #include <linux/dnotify.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/security.h>
@@ -227,7 +226,6 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 	if (error)
 		return error;
 
-	lock_kernel();
 	if ((arg ^ filp->f_flags) & FASYNC) {
 		if (filp->f_op && filp->f_op->fasync) {
 			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
@@ -238,7 +236,6 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
  out:
-	unlock_kernel();
 	return error;
 }
 

