Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYAXGMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYAXGMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYAXGMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:12:16 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:30089 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYAXGMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:12:15 -0500
Date: Wed, 23 Jan 2008 23:12:12 -0700
From: dann frazier <dannf@dannf.org>
To: Willy TARREAU <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] 2.4: fix memory corruption from misinterpreted
	bad_inode_ops return values
Message-ID: <20080124061212.GA22079@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 2.4 backport of a linux-2.6 change by Eric Sandeen
(commit be6aab0e9fa6d3c6d75aa1e38ac972d8b4ee82b8)

CVE-2006-5753 was assigned for this issue.

I've built and boot-tested this, but I'm not sure how to exercise
these codepaths.

Commit log from 2.6 follows.

  CVE-2006-5753 is for a case where an inode can be marked bad, switching
  the ops to bad_inode_ops, which are all connected as:

  static int return_EIO(void)
  {
          return -EIO;
  }

  #define EIO_ERROR ((void *) (return_EIO))

  static struct inode_operations bad_inode_ops =
  {
          .create         = bad_inode_create
  ...etc...

  The problem here is that the void cast causes return types to not be
  promoted, and for ops such as listxattr which expect more than 32 bits of
  return value, the 32-bit -EIO is interpreted as a large positive 64-bit
  number, i.e. 0x00000000fffffffa instead of 0xfffffffa.

  This goes particularly badly when the return value is taken as a number of
  bytes to copy into, say, a user's buffer for example...

  I originally had coded up the fix by creating a return_EIO_<TYPE> macro
  for each return type, like this:

  static int return_EIO_int(void)
  {
  	return -EIO;
  }
  #define EIO_ERROR_INT ((void *) (return_EIO_int))

  static struct inode_operations bad_inode_ops =
  {
  	.create		= EIO_ERROR_INT,
  ...etc...

  but Al felt that it was probably better to create an EIO-returner for each
  actual op signature.  Since so few ops share a signature, I just went ahead
  & created an EIO function for each individual file & inode op that returns
  a value.

Signed-off-by: dann frazier <dannf@hp.com>
---
 fs/bad_inode.c |  191 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 161 insertions(+), 30 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 850ba5e..b6b1d7d 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -9,6 +9,76 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/sched.h>
+#include <linux/poll.h>
+
+static loff_t bad_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	return -EIO;
+}
+
+static ssize_t bad_file_read(struct file *filp, char __user *buf,
+			size_t size, loff_t *ppos)
+{
+        return -EIO;
+}
+
+static ssize_t bad_file_write(struct file *filp, const char __user *buf,
+			size_t siz, loff_t *ppos)
+{
+        return -EIO;
+}
+
+static int bad_file_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	return -EIO;
+}
+
+static unsigned int bad_file_poll(struct file *filp, poll_table *wait)
+{
+	return POLLERR;
+}
+
+static int bad_file_ioctl (struct inode *inode, struct file *filp,
+			unsigned int cmd, unsigned long arg)
+{
+	return -EIO;
+}
+
+static int bad_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return -EIO;
+}
+
+static int bad_file_open(struct inode *inode, struct file *filp)
+{
+	return -EIO;
+}
+
+static int bad_file_flush(struct file *file)
+{
+	return -EIO;
+}
+
+static int bad_file_release(struct inode *inode, struct file *filp)
+{
+	return -EIO;
+}
+
+static int bad_file_fsync(struct file *file, struct dentry *dentry,
+			int datasync)
+{
+	return -EIO;
+}
+
+static int bad_file_fasync(int fd, struct file *filp, int on)
+{
+	return -EIO;
+}
+
+static int bad_file_lock(struct file *file, int cmd, struct file_lock *fl)
+{
+	return -EIO;
+}
 
 /*
  * The follow_link operation is special: it must behave as a no-op
@@ -20,46 +90,107 @@ static int bad_follow_link(struct dentry *dent, struct nameidata *nd)
 	return vfs_follow_link(nd, ERR_PTR(-EIO));
 }
 
-static int return_EIO(void)
+static struct file_operations bad_file_ops =
+{
+	llseek:		bad_file_llseek,
+	read:		bad_file_read,
+	write:		bad_file_write,
+	readdir:	bad_file_readdir,
+	poll:		bad_file_poll,
+	ioctl:		bad_file_ioctl,
+	mmap:		bad_file_mmap,
+	open:		bad_file_open,
+	flush:		bad_file_flush,
+	release:	bad_file_release,
+	fsync:		bad_file_fsync,
+	fasync:		bad_file_fasync,
+	lock:		bad_file_lock,
+};
+
+static int bad_inode_create (struct inode *dir, struct dentry *dentry,
+		int mode)
 {
 	return -EIO;
 }
+  
+static struct dentry *bad_inode_lookup(struct inode *dir,
+			struct dentry *dentry)
+{
+	return ERR_PTR(-EIO);
+}
 
-#define EIO_ERROR ((void *) (return_EIO))
+static int bad_inode_link (struct dentry *old_dentry, struct inode *dir,
+		struct dentry *dentry)
+{
+	return -EIO;
+}
 
-static struct file_operations bad_file_ops =
+static int bad_inode_unlink(struct inode *dir, struct dentry *dentry)
 {
-	llseek:		EIO_ERROR,
-	read:		EIO_ERROR,
-	write:		EIO_ERROR,
-	readdir:	EIO_ERROR,
-	poll:		EIO_ERROR,
-	ioctl:		EIO_ERROR,
-	mmap:		EIO_ERROR,
-	open:		EIO_ERROR,
-	flush:		EIO_ERROR,
-	release:	EIO_ERROR,
-	fsync:		EIO_ERROR,
-	fasync:		EIO_ERROR,
-	lock:		EIO_ERROR,
-};
+	return -EIO;
+}
+
+static int bad_inode_symlink (struct inode *dir, struct dentry *dentry,
+		const char *symname)
+{
+	return -EIO;
+}
+
+static int bad_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			int mode)
+{
+	return -EIO;
+}
+
+static int bad_inode_rmdir (struct inode *dir, struct dentry *dentry)
+{
+	return -EIO;
+}
+
+static int bad_inode_mknod (struct inode *dir, struct dentry *dentry,
+			int mode, int rdev)
+{
+	return -EIO;
+}
+
+static int bad_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	return -EIO;
+}
+
+static int bad_inode_readlink(struct dentry *dentry, char __user *buffer,
+		int buflen)
+{
+	return -EIO;
+}
+
+static int bad_inode_permission(struct inode *inode, int mask)
+{
+	return -EIO;
+}
+
+static int bad_inode_revalidate(struct dentry *dentry)
+{
+	return -EIO;
+}
 
 struct inode_operations bad_inode_ops =
 {
-	create:		EIO_ERROR,
-	lookup:		EIO_ERROR,
-	link:		EIO_ERROR,
-	unlink:		EIO_ERROR,
-	symlink:	EIO_ERROR,
-	mkdir:		EIO_ERROR,
-	rmdir:		EIO_ERROR,
-	mknod:		EIO_ERROR,
-	rename:		EIO_ERROR,
-	readlink:	EIO_ERROR,
+	create:		bad_inode_create,
+	lookup:		bad_inode_lookup,
+	link:		bad_inode_link,
+	unlink:		bad_inode_unlink,
+	symlink:	bad_inode_symlink,
+	mkdir:		bad_inode_mkdir,
+	rmdir:		bad_inode_rmdir,
+	mknod:		bad_inode_mknod,
+	rename:		bad_inode_rename,
+	readlink:	bad_inode_readlink,
 	follow_link:	bad_follow_link,
-	truncate:	EIO_ERROR,
-	permission:	EIO_ERROR,
-	revalidate:	EIO_ERROR,
+	/* truncate returns void */
+	permission:	bad_inode_permission,
+	revalidate:	bad_inode_revalidate,
 };
 
 
-- 
1.5.3.8


