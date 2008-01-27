Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYA0CWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYA0CWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYA0CRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:55 -0500
Received: from mail.suse.de ([195.135.220.2]:54381 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372AbYA0CRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:21 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: sfrench@samba.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [13/18] BKL-removal: Add compat_ioctl for cifs
Message-Id: <20080127021719.EDB7614D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Similar to the compat handlers of other file systems. The ioctls
are compatible except that they have different numbers.

Cc: sfrench@samba.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/cifs/cifsfs.c |   15 +++++++++++++++
 fs/cifs/cifsfs.h |    2 ++
 fs/cifs/ioctl.c  |   19 +++++++++++++++++++
 3 files changed, 36 insertions(+)

Index: linux/fs/cifs/cifsfs.c
===================================================================
--- linux.orig/fs/cifs/cifsfs.c
+++ linux/fs/cifs/cifsfs.c
@@ -626,6 +626,9 @@ const struct file_operations cifs_file_o
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = cifs_compat_ioctl,
+#endif
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -646,6 +649,9 @@ const struct file_operations cifs_file_d
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl = cifs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = cifs_compat_ioctl,
+#endif
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -666,6 +672,9 @@ const struct file_operations cifs_file_n
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = cifs_compat_ioctl,
+#endif
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -685,6 +694,9 @@ const struct file_operations cifs_file_d
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl = cifs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = cifs_compat_ioctl,
+#endif
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -700,6 +712,9 @@ const struct file_operations cifs_dir_op
 	.dir_notify = cifs_dir_notify,
 #endif /* CONFIG_CIFS_EXPERIMENTAL */
 	.unlocked_ioctl = cifs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = cifs_compat_ioctl,
+#endif
 };
 
 static void
Index: linux/fs/cifs/cifsfs.h
===================================================================
--- linux.orig/fs/cifs/cifsfs.h
+++ linux/fs/cifs/cifsfs.h
@@ -101,6 +101,8 @@ extern ssize_t	cifs_getxattr(struct dent
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
 extern long cifs_ioctl(struct file *filep, unsigned int command,
 		unsigned long arg);
+extern long cifs_compat_ioctl(struct file *filep, unsigned int command,
+			unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 extern const struct export_operations cifs_export_ops;
Index: linux/fs/cifs/ioctl.c
===================================================================
--- linux.orig/fs/cifs/ioctl.c
+++ linux/fs/cifs/ioctl.c
@@ -108,3 +108,22 @@ long cifs_ioctl(struct file *filep, unsi
 	FreeXid(xid);
 	return rc;
 }
+
+#ifdef CONFIG_COMPAT
+#define  FS_IOC_GETFLAGS32		   _IOR('f', 1, int)
+#define  FS_IOC_SETFLAGS32		   _IOR('f', 2, int)
+
+long cifs_compat_ioctl(struct file *f, unsigned int command, unsigned long arg)
+{
+	/* Native ioctl is just mistyped, the real type is always int */
+	switch (command) {
+	case FS_IOC_GETFLAGS32:
+		command = FS_IOC_GETFLAGS;
+		break;
+	case FS_IOC_SETFLAGS32:
+		command = FS_IOC_SETFLAGS;
+		break;
+	}
+	return cifs_ioctl(f, command, arg);
+}
+#endif
