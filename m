Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYI0PpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYI0PpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYI0Poj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:44:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33187 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbYI0Poi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:44:38 -0400
From: Avi Kivity <avi@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ioctl: extensible ioctl dispatch
Date: Sat, 27 Sep 2008 18:44:01 +0300
Message-Id: <1222530242-1272-3-git-send-email-avi@redhat.com>
In-Reply-To: <1222530242-1272-1-git-send-email-avi@redhat.com>
References: <1222530242-1272-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctls (as traditionally implemented) are very brittle; one cannot add
a field to the argument structure without breaking the ABI.  In many
cases, this is a good thing as the ABI was not designed for extension.

In other cases, however, it makes sense to design an ABI with extension
in mind.  This patch provides a new ioctl_dispatch_extensible(), which
is designed to cope with evolving interfaces:

- the ioctl number is matched only by its number and type, allowing
  size and direction to change
- buffer space is allocated for the size the kernel expects, even if
  the user passed a smaller buffer
- copying is limited by the size the kernel expects, even if the user
  passed a larger buffer
- buffer size mismatches are handled by zeroing

The ABI can account for new fields either by recognizing zero as a "missing"
value, or by implementing bitflags for feature availability.  Both an old
kernel with new userspace and a new kernel with old userspace are accomodated.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 fs/ioctl.c            |   87 +++++++++++++++++++++++++++++++++++++++++-------
 include/linux/ioctl.h |    4 ++
 2 files changed, 78 insertions(+), 13 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index f63d5ce..5a354fc 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -225,12 +225,13 @@ asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
  * Locates and calls ioctl handler in @handlers; if none exist, calls
  * @fallback; if that does not exist, return -ENOTTY.
  */
-long dispatch_ioctl(struct inode *inode, struct file *filp,
-		    unsigned cmd, unsigned long arg,
-		    const struct ioctl_handler *handlers,
-		    long (*fallback)(const struct ioctl_arg *arg))
+static long __dispatch_ioctl(struct inode *inode, struct file *filp,
+			     unsigned cmd, unsigned long arg,
+			     const struct ioctl_handler *handlers,
+			     long (*fallback)(const struct ioctl_arg *arg),
+			     unsigned cmd_mask)
 {
-	unsigned dir, size;
+	unsigned dir, size, usize, copysize;
 	long ret;
 	long stackbuf[IOCTL_STACK_BUF / sizeof(long)];
 	struct ioctl_arg iarg;
@@ -242,7 +243,7 @@ long dispatch_ioctl(struct inode *inode, struct file *filp,
 	 * used (and performance sensitive) items are in the front.
 	 */
 	for (; handlers->handler; ++handlers)
-		if (handlers->cmd == cmd) {
+		if ((handlers->cmd & cmd_mask) == (cmd & cmd_mask)) {
 			handler = handlers->handler;
 			break;
 		}
@@ -255,10 +256,14 @@ long dispatch_ioctl(struct inode *inode, struct file *filp,
 	iarg.inode = inode;
 	iarg.argl = arg;
 
-	size = 0;
+	size = usize = 0;
 	dir = _IOC_DIR(cmd);
-	if (dir != _IOC_NONE)
-		size = _IOC_SIZE(cmd);
+	if (dir != _IOC_NONE) {
+		size = _IOC_SIZE(handlers->cmd);
+		usize = _IOC_SIZE(cmd);
+		if (!handlers->handler)
+			size = usize;
+	}
 
 	iarg.argp = stackbuf;
 	if (size > sizeof(stackbuf)) {
@@ -266,18 +271,28 @@ long dispatch_ioctl(struct inode *inode, struct file *filp,
 		if (!iarg.argp)
 			return -ENOMEM;
 	}
-	if (dir & _IOC_WRITE)
-		if (copy_from_user(iarg.argp, (void __user *)arg, size))
+
+	if (dir & _IOC_WRITE) {
+		copysize = min(size, usize);
+		if (copy_from_user(iarg.argp, (void __user *)arg, copysize))
 			goto out_fault;
+		if (copysize < size)
+			memset(iarg.argp + copysize, 0, size - copysize);
+	}
 
 	ret = handler(&iarg);
 
 	if (ret < 0)
 		goto out;
 
-	if (dir & _IOC_READ)
-		if (copy_to_user((void __user *)arg, iarg.argp, size))
+	if (dir & _IOC_READ) {
+		copysize = min(size, usize);
+		if (copy_to_user((void __user *)arg, iarg.argp, copysize))
 			goto out_fault;
+		for (; copysize < usize; ++copysize)
+			if (put_user(0, (u8 __user *)iarg.argp + copysize))
+				goto out_fault;
+	}
 out:
 	if (iarg.argp != stackbuf)
 		kfree(iarg.argp);
@@ -288,4 +303,50 @@ out_fault:
 	ret = -EFAULT;
 	goto out;
 }
+
+/**
+ * dispatch_ioctl - dispatch to an ioctl handler based on ioctl number
+ * @inode:	inode to invoke ioctl method on
+ * @filp:	open file to invoke ioctl method on
+ * @cmd:	ioctl command to execute
+ * @arg:	command-specific argument for ioctl
+ * @handlers:	list of potential handlers for @cmd; null terminated;
+ *              place frequently used cmds first
+ * @fallback:   optional function to call if @cmd not found in @handlers
+ *
+ * Locates and calls ioctl handler in @handlers; if none exist, calls
+ * @fallback; if that does not exist, return -ENOTTY.
+ */
+long dispatch_ioctl(struct inode *inode, struct file *filp,
+		    unsigned cmd, unsigned long arg,
+		    const struct ioctl_handler *handlers,
+		    long (*fallback)(const struct ioctl_arg *arg))
+{
+	return __dispatch_ioctl(inode, filp, cmd, arg, handlers, fallback, ~0);
+}
 EXPORT_SYMBOL_GPL(dispatch_ioctl);
+
+/**
+ * dispatch_ioctl_extensible - dispatch to an ioctl handler based on ioctl
+ *                             number; adjust for differing buffer sizes
+ *                             between user and kernel
+ * @inode:	inode to invoke ioctl method on
+ * @filp:	open file to invoke ioctl method on
+ * @cmd:	ioctl command to execute
+ * @arg:	command-specific argument for ioctl
+ * @handlers:	list of potential handlers for @cmd; null terminated;
+ *              place frequently used cmds first
+ * @fallback:   optional function to call if @cmd not found in @handlers
+ *
+ * Locates and calls ioctl handler in @handlers; if none exist, calls
+ * @fallback; if that does not exist, return -ENOTTY.
+ */
+long dispatch_ioctl_extensible(struct inode *inode, struct file *filp,
+			       unsigned cmd, unsigned long arg,
+			       const struct ioctl_handler *handlers,
+			       long (*fallback)(const struct ioctl_arg *arg))
+{
+	return __dispatch_ioctl(inode, filp, cmd, arg, handlers, fallback,
+				~(_IOC_SIZEMASK << _IOC_SIZESHIFT));
+}
+EXPORT_SYMBOL_GPL(dispatch_ioctl_extensible);
diff --git a/include/linux/ioctl.h b/include/linux/ioctl.h
index 881974a..5e73fbf 100644
--- a/include/linux/ioctl.h
+++ b/include/linux/ioctl.h
@@ -33,6 +33,10 @@ long dispatch_ioctl(struct inode *inode, struct file *filp,
 		    unsigned int cmd, unsigned long arg,
 		    const struct ioctl_handler *handlers,
 		    long (*fallback)(const struct ioctl_arg *arg));
+long dispatch_ioctl_extensible(struct inode *inode, struct file *filp,
+			       unsigned int cmd, unsigned long arg,
+			       const struct ioctl_handler *handlers,
+			       long (*fallback)(const struct ioctl_arg *arg));
 
 #endif
 
-- 
1.6.0.1

