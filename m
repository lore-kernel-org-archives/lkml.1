Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbZAHX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbZAHX2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZAHX2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:28:11 -0500
Received: from vena.lwn.net ([206.168.112.25]:37472 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbZAHX2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:28:10 -0500
Date: Thu, 8 Jan 2009 16:28:06 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       bfields@fieldses.org
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20090108162806.48caaa29@bike.lwn.net>
In-Reply-To: <20081229124151.GA29634@redhat.com>
References: <20081229041352.6bbdf57c@tpl>
	<20081229124151.GA29634@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here is yet another attempt at an fasync() fix.  It really doesn't
seem like it should be so hard...

What I have done this time is to separate the handling of the FASYNC
flag a bit from the rest.  All of the other flags can be tweaked
without side-effects.  In theory, they could now be changed with
bitops, but I've not done that because (1) that would require changing
f_flags to unsigned long, which would grow it on some platforms, and
(2) there are places which want to be able to atomically change more
than one flag at once.  So changes to f_flags are serialized by a
spinlock (rather than the mutex which was used before).

As an additional rule, though, changes to FASYNC *do* require a mutex,
so that we can ensure that the change to the flag and the call to
>fasync() are a single, atomic operation.  I've created a new
change_fasync() function to encapsulate that operation, coalescing the
two places in the code which called >fasync() before.

It all works on my system...

It's worth noting that there is an ABI change implicit in this patch.
On current systems, setting the FASYNC flag via ioctl(FIOASYNC)
behaves a little differently than changing it with fcntl().  In
particular, if there is no >fasync() function, ioctl() will return
-ENOTTY while fcntl() silently (but uselessly) sets the flag and
returns 0. This patch returns -ENOTTY in both places.  It seems better
to me, but it *is* a change, and we may well not want to do that.

Patch is against 2.6.28. 

jon

--

Fix f_flags race problems and remove BKL usage

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 1412a8d..fb022b5 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2170,13 +2170,12 @@ static int fionbio(struct file *file, int __user *p)
 	if (get_user(nonblock, p))
 		return -EFAULT;
 
-	/* file->f_flags is still BKL protected in the fs layer - vomit */
-	lock_kernel();
+	lock_file_flags();
 	if (nonblock)
 		file->f_flags |= O_NONBLOCK;
 	else
 		file->f_flags &= ~O_NONBLOCK;
-	unlock_kernel();
+	unlock_file_flags();
 	return 0;
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 99e0ae1..c258391 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1116,6 +1116,7 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	 * binary needs it. We might want to drop this workaround
 	 * during an unstable branch.
 	 */
+	lock_file_flags();
 	filp->f_flags |= O_LARGEFILE;
 
 	if (filp->f_flags & O_NDELAY)
@@ -1124,6 +1125,7 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 		filp->f_mode |= FMODE_EXCL;
 	if ((filp->f_flags & O_ACCMODE) == 3)
 		filp->f_mode |= FMODE_WRITE_IOCTL;
+	unlock_file_flags();
 
 	bdev = bd_acquire(inode);
 	if (bdev == NULL)
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 549daf8..0ad04fe 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -19,12 +19,15 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
-#include <linux/smp_lock.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
+/* Serialize access to file->f_flags */
+DEFINE_SPINLOCK(file_flags_lock);
+EXPORT_SYMBOL(file_flags_lock);
+
 void set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
@@ -141,7 +144,7 @@ asmlinkage long sys_dup(unsigned int fildes)
 	return ret;
 }
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
@@ -176,25 +179,52 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 	if (error)
 		return error;
 
-	/*
-	 * We still need a lock here for now to keep multiple FASYNC calls
-	 * from racing with each other.
-	 */
-	lock_kernel();
 	if ((arg ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync) {
-			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
-			if (error < 0)
-				goto out;
-		}
+		error = fasync_change(fd, filp, (arg & FASYNC) != 0);
+		if (error < 0)
+			goto out;
 	}
 
+	lock_file_flags();
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
+	unlock_file_flags();
  out:
-	unlock_kernel();
 	return error;
 }
 
+
+
+/*
+ * Change the setting of fasync, let the driver know.
+ * Not static because ioctl_fioasync() uses it too.
+ */
+int fasync_change(int fd, struct file *filp, int on)
+{
+	int ret;
+	static DEFINE_MUTEX(fasync_mutex);
+
+	if (filp->f_op->fasync == NULL)
+		return -ENOTTY;
+
+	mutex_lock(&fasync_mutex);
+	lock_file_flags();
+	if (((filp->f_flags & FASYNC) == 0) == (on == 0)) {
+		unlock_file_flags();
+		return 0;
+	}
+	if (on)
+		filp->f_flags |= FASYNC;
+	else
+		filp->f_flags &= ~FASYNC;
+	unlock_file_flags();
+	ret = filp->f_op->fasync(fd, filp, on);
+	mutex_unlock(&fasync_mutex);
+	return ret;
+}
+
+
+
+
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      uid_t uid, uid_t euid, int force)
 {
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 43e8b2c..be5e591 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -380,10 +380,12 @@ static int ioctl_fionbio(struct file *filp, int __user *argp)
 	if (O_NONBLOCK != O_NDELAY)
 		flag |= O_NDELAY;
 #endif
+	lock_file_flags();
 	if (on)
 		filp->f_flags |= flag;
 	else
 		filp->f_flags &= ~flag;
+	unlock_file_flags();
 	return error;
 }
 
@@ -399,20 +401,9 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 	flag = on ? FASYNC : 0;
 
 	/* Did FASYNC state change ? */
-	if ((flag ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync)
-			error = filp->f_op->fasync(fd, filp, on);
-		else
-			error = -ENOTTY;
-	}
-	if (error)
-		return error;
-
-	if (on)
-		filp->f_flags |= FASYNC;
-	else
-		filp->f_flags &= ~FASYNC;
-	return error;
+	if ((flag ^ filp->f_flags) & FASYNC)
+		return fasync_change(fd, filp, on);
+	return 0;
 }
 
 /*
@@ -438,17 +429,11 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIONBIO:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fionbio(filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOASYNC:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fioasync(fd, filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOQSIZE:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4433c8f..025d8d6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -998,8 +998,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 
 	if (!EX_ISSYNC(exp))
 		stable = 0;
-	if (stable && !EX_WGATHER(exp))
+	if (stable && !EX_WGATHER(exp)) {
+		lock_file_flags();
 		file->f_flags |= O_SYNC;
+		unlock_file_flags();
+	}
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a853ef..1f2734c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -854,6 +854,23 @@ extern spinlock_t files_lock;
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
+/*
+ * Serialize changes to file->f_flags.  These should not be called
+ * from interrupt context.
+ */
+extern spinlock_t file_flags_lock;
+
+static inline void lock_file_flags(void)
+{
+	spin_lock(&file_flags_lock);
+}
+
+static inline void unlock_file_flags(void)
+{
+	spin_unlock(&file_flags_lock);
+}
+extern int fasync_change(int fd, struct file *filp, int on);
+
 #ifdef CONFIG_DEBUG_WRITECOUNT
 static inline void file_take_write(struct file *f)
 {
