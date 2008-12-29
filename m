Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYL2LQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYL2LQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYL2LQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:16:12 -0500
Received: from vena.lwn.net ([206.168.112.25]:57224 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYL2LQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:16:11 -0500
Date: Mon, 29 Dec 2008 04:13:52 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@ZenIV.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
       bfields@fieldses.org, xfs-masters@oss.sgi.com
Subject: RFC: Fix f_flags races without the BKL
Message-ID: <20081229041352.6bbdf57c@tpl>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accesses to the f_flags field have always involved a read-modify-write
operation, and have always been racy in the absence of the BKL.  The recent
BKL-removal work made this problem worse, but it has been there for a very
long time.  The race is quite small, and, arguably, has never affected
anybody, but it's still worth fixing.

After pondering for a while, I couldn't come up with anything better than a
global file->f_flags mutex.  There's no point in bloating struct file with
a mutex just for this purpose; it's hard to imagine that there will be any
real contention for this lock.

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
index 549daf8..d7870db 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -19,12 +19,15 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
+/* Serialize access to file->f_flags */
+DEFINE_MUTEX(file_flags_mutex);
+
 void set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
@@ -176,11 +179,7 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 	if (error)
 		return error;
 
-	/*
-	 * We still need a lock here for now to keep multiple FASYNC calls
-	 * from racing with each other.
-	 */
-	lock_kernel();
+	lock_file_flags();
 	if ((arg ^ filp->f_flags) & FASYNC) {
 		if (filp->f_op && filp->f_op->fasync) {
 			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
@@ -191,7 +190,7 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
  out:
-	unlock_kernel();
+	unlock_file_flags();
 	return error;
 }
 
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 43e8b2c..df15365 100644
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
 
@@ -399,6 +401,7 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 	flag = on ? FASYNC : 0;
 
 	/* Did FASYNC state change ? */
+	lock_file_flags();
 	if ((flag ^ filp->f_flags) & FASYNC) {
 		if (filp->f_op && filp->f_op->fasync)
 			error = filp->f_op->fasync(fd, filp, on);
@@ -406,12 +409,14 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 			error = -ENOTTY;
 	}
 	if (error)
-		return error;
+		goto out;
 
 	if (on)
 		filp->f_flags |= FASYNC;
 	else
 		filp->f_flags &= ~FASYNC;
+out:
+	unlock_file_flags();
 	return error;
 }
 
@@ -438,17 +443,11 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
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
diff --git a/fs/pipe.c b/fs/pipe.c
index 7aea8b8..23ae227 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -945,7 +945,9 @@ struct file *create_write_pipe(int flags)
 		goto err_dentry;
 	f->f_mapping = inode->i_mapping;
 
+	lock_file_flags();
 	f->f_flags = O_WRONLY | (flags & O_NONBLOCK);
+	unlock_file_flags();
 	f->f_version = 0;
 
 	return f;
@@ -981,7 +983,9 @@ struct file *create_read_pipe(struct file *wrf, int flags)
 	f->f_mapping = wrf->f_path.dentry->d_inode->i_mapping;
 
 	f->f_pos = 0;
+	lock_file_flags();
 	f->f_flags = O_RDONLY | (flags & O_NONBLOCK);
+	unlock_file_flags();
 	f->f_op = &read_pipefifo_fops;
 	f->f_mode = FMODE_READ;
 	f->f_version = 0;
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index d3438c7..5f31ae5 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -328,7 +328,9 @@ xfs_open_by_handle(
 	}
 	if (inode->i_mode & S_IFREG) {
 		/* invisible operation should not change atime */
+		lock_file_flags();
 		filp->f_flags |= O_NOATIME;
+		unlock_file_flags();
 		filp->f_op = &xfs_invis_file_operations;
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a853ef..dec5c30 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -854,6 +854,23 @@ extern spinlock_t files_lock;
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
+/*
+ * Serialize access to f_flags and f_op->fasync().  These need to
+ * be used for modifications to f_flags once a file descriptor is
+ * visible to user space.
+ */
+extern struct mutex file_flags_mutex;
+
+static inline void lock_file_flags(void)
+{
+	mutex_lock(&file_flags_mutex);
+}
+
+static inline void unlock_file_flags(void)
+{
+	mutex_unlock(&file_flags_mutex);
+}
+
 #ifdef CONFIG_DEBUG_WRITECOUNT
 static inline void file_take_write(struct file *f)
 {
