Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYA0CWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYA0CWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbYA0CR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:56 -0500
Received: from mail.suse.de ([195.135.220.2]:54373 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbYA0CRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:20 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: sfrench@samba.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [12/18] BKL-removal: Convert CIFS over to unlocked_ioctl
Message-Id: <20080127021718.DDCFE14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cifs_ioctl doesn't seem to need the BKL for anything, so convert it over
to use unlocked_ioctl.

Cc: sfrench@samba.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/cifs/cifsfs.c |   10 +++++-----
 fs/cifs/cifsfs.h |    4 ++--
 fs/cifs/ioctl.c  |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

Index: linux/fs/cifs/cifsfs.c
===================================================================
--- linux.orig/fs/cifs/cifsfs.c
+++ linux/fs/cifs/cifsfs.c
@@ -625,7 +625,7 @@ const struct file_operations cifs_file_o
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl	= cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -645,7 +645,7 @@ const struct file_operations cifs_file_d
 	.flush = cifs_flush,
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -665,7 +665,7 @@ const struct file_operations cifs_file_n
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl	= cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -684,7 +684,7 @@ const struct file_operations cifs_file_d
 	.flush = cifs_flush,
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -699,7 +699,7 @@ const struct file_operations cifs_dir_op
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	.dir_notify = cifs_dir_notify,
 #endif /* CONFIG_CIFS_EXPERIMENTAL */
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 };
 
 static void
Index: linux/fs/cifs/cifsfs.h
===================================================================
--- linux.orig/fs/cifs/cifsfs.h
+++ linux/fs/cifs/cifsfs.h
@@ -99,8 +99,8 @@ extern int 	cifs_setxattr(struct dentry 
 			size_t, int);
 extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
-extern int cifs_ioctl(struct inode *inode, struct file *filep,
-		       unsigned int command, unsigned long arg);
+extern long cifs_ioctl(struct file *filep, unsigned int command,
+		unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 extern const struct export_operations cifs_export_ops;
Index: linux/fs/cifs/ioctl.c
===================================================================
--- linux.orig/fs/cifs/ioctl.c
+++ linux/fs/cifs/ioctl.c
@@ -30,9 +30,9 @@
 
 #define CIFS_IOC_CHECKUMOUNT _IO(0xCF, 2)
 
-int cifs_ioctl (struct inode *inode, struct file *filep,
-		unsigned int command, unsigned long arg)
+long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 {
+	struct inode *inode = filep->f_dentry->d_inode;
 	int rc = -ENOTTY; /* strange error - but the precedent */
 	int xid;
 	struct cifs_sb_info *cifs_sb;
