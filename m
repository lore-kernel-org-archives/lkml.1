Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYI0Ppd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYI0Ppd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYI0Pol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:44:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33191 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYI0Poj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:44:39 -0400
From: Avi Kivity <avi@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ioctl: generic ioctl dispatcher
Date: Sat, 27 Sep 2008 18:44:00 +0300
Message-Id: <1222530242-1272-2-git-send-email-avi@redhat.com>
In-Reply-To: <1222530242-1272-1-git-send-email-avi@redhat.com>
References: <1222530242-1272-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctl handler writers currently have the following tasks:

- allocate a buffer for the data, either in memory or on the heap, depending
  on the buffer size
- handle errors
- copy the data from userspace
- handle errors
- actually perform the intended operation
- copy data back to userspace
- handle errors
- free the buffer, in case it was allocated on the heap

This patch provides a dispatch_ioctl() helper, which will do all of these
things for the caller, except for performing the intended operation.  The
caller need only provide a list of ioctl commands and handler functions.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 fs/ioctl.c            |   78 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ioctl.h |   33 ++++++++++++++++++++
 2 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 7db32b3..f63d5ce 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -211,3 +211,81 @@ asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
  out:
 	return error;
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
+	unsigned dir, size;
+	long ret;
+	long stackbuf[IOCTL_STACK_BUF / sizeof(long)];
+	struct ioctl_arg iarg;
+	long (*handler)(const struct ioctl_arg *arg) = fallback;
+
+	/*
+	 * Yes, we use a linear search.  That's actually the fastest
+	 * algorithm around if the list is small, or if the frequently
+	 * used (and performance sensitive) items are in the front.
+	 */
+	for (; handlers->handler; ++handlers)
+		if (handlers->cmd == cmd) {
+			handler = handlers->handler;
+			break;
+		}
+
+	if (!handler)
+		return -ENOTTY;
+
+	iarg.cmd = cmd;
+	iarg.file = filp;
+	iarg.inode = inode;
+	iarg.argl = arg;
+
+	size = 0;
+	dir = _IOC_DIR(cmd);
+	if (dir != _IOC_NONE)
+		size = _IOC_SIZE(cmd);
+
+	iarg.argp = stackbuf;
+	if (size > sizeof(stackbuf)) {
+		iarg.argp = kmalloc(size, GFP_KERNEL);
+		if (!iarg.argp)
+			return -ENOMEM;
+	}
+	if (dir & _IOC_WRITE)
+		if (copy_from_user(iarg.argp, (void __user *)arg, size))
+			goto out_fault;
+
+	ret = handler(&iarg);
+
+	if (ret < 0)
+		goto out;
+
+	if (dir & _IOC_READ)
+		if (copy_to_user((void __user *)arg, iarg.argp, size))
+			goto out_fault;
+out:
+	if (iarg.argp != stackbuf)
+		kfree(iarg.argp);
+
+	return ret;
+
+out_fault:
+	ret = -EFAULT;
+	goto out;
+}
+EXPORT_SYMBOL_GPL(dispatch_ioctl);
diff --git a/include/linux/ioctl.h b/include/linux/ioctl.h
index aa91eb3..881974a 100644
--- a/include/linux/ioctl.h
+++ b/include/linux/ioctl.h
@@ -3,5 +3,38 @@
 
 #include <asm/ioctl.h>
 
+#ifdef __KERNEL__
+
+struct inode;
+struct file;
+
+/*
+ * for dispatch_ioctl(), how many bytes we allow to be allocated on stack.
+ * Arch may override.
+ */
+#ifndef IOCTL_STACK_BUF
+#define IOCTL_STACK_BUF 128
+#endif
+
+struct ioctl_arg {
+	unsigned cmd;
+	struct file *file;
+	struct inode *inode;
+	long argl;
+	void *argp;
+};
+
+struct ioctl_handler {
+	unsigned cmd;
+	long (*handler)(const struct ioctl_arg *arg);
+};
+
+long dispatch_ioctl(struct inode *inode, struct file *filp,
+		    unsigned int cmd, unsigned long arg,
+		    const struct ioctl_handler *handlers,
+		    long (*fallback)(const struct ioctl_arg *arg));
+
+#endif
+
 #endif /* _LINUX_IOCTL_H */
 
-- 
1.6.0.1

