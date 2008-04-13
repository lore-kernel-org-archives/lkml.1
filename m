Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYDMWBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYDMWBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYDMWA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:00:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:44571 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYDMWA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:00:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 13 Apr 2008 15:00:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch] F_GETPATH for linux
Message-ID: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was working on some bsd/linux compatibility code, and I noticed that we 
do not have F_GETPATH. I know we can readlink /proc/PID/fd/FD (that is 
what I'm doing now, under #ifdef), but I gave a patch a shot anyway.
Here it is, building but untested ...



- Davide


---
 fs/fcntl.c                  |   27 +++++++++++++++++++++++++++
 fs/proc/base.c              |   26 +-------------------------
 include/asm-generic/fcntl.h |    1 +
 include/linux/fs.h          |    1 +
 4 files changed, 30 insertions(+), 25 deletions(-)

Index: linux-2.6.mod/fs/fcntl.c
===================================================================
--- linux-2.6.mod.orig/fs/fcntl.c	2008-04-13 14:17:39.000000000 -0700
+++ linux-2.6.mod/fs/fcntl.c	2008-04-13 14:54:00.000000000 -0700
@@ -316,6 +316,29 @@
 	return pid;
 }
 
+int fcntl_getpath(struct path *fpath, char __user *path, int maxsize)
+{
+	int size;
+	char *buf, *pathname;
+
+	buf = (char *) __get_free_page(GFP_TEMPORARY);
+	if (!buf)
+		return -ENOMEM;
+	pathname = d_path(fpath, buf, PAGE_SIZE);
+	size = PTR_ERR(pathname);
+	if (IS_ERR(pathname))
+		goto error;
+	size = buf + PAGE_SIZE - 1 - pathname;
+	if (size > maxsize)
+		size = maxsize;
+	if (copy_to_user(path, pathname, size))
+		size = -EFAULT;
+error:
+	free_page((unsigned long) buf);
+	return size;
+}
+EXPORT_SYMBOL(fcntl_getpath);
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -381,6 +404,10 @@
 	case F_NOTIFY:
 		err = fcntl_dirnotify(fd, filp, arg);
 		break;
+	case F_GETPATH:
+		err = fcntl_getpath(&filp->f_path, (char __user *) arg,
+				    PATH_MAX);
+		break;
 	default:
 		break;
 	}
Index: linux-2.6.mod/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.mod.orig/include/asm-generic/fcntl.h	2008-04-13 14:17:33.000000000 -0700
+++ linux-2.6.mod/include/asm-generic/fcntl.h	2008-04-13 14:18:17.000000000 -0700
@@ -73,6 +73,7 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+#define F_GETPATH	12
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
Index: linux-2.6.mod/fs/proc/base.c
===================================================================
--- linux-2.6.mod.orig/fs/proc/base.c	2008-04-13 14:41:03.000000000 -0700
+++ linux-2.6.mod/fs/proc/base.c	2008-04-13 14:42:12.000000000 -0700
@@ -1192,30 +1192,6 @@
 	return ERR_PTR(error);
 }
 
-static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
-{
-	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
-	char *pathname;
-	int len;
-
-	if (!tmp)
-		return -ENOMEM;
-
-	pathname = d_path(path, tmp, PAGE_SIZE);
-	len = PTR_ERR(pathname);
-	if (IS_ERR(pathname))
-		goto out;
-	len = tmp + PAGE_SIZE - 1 - pathname;
-
-	if (len > buflen)
-		len = buflen;
-	if (copy_to_user(buffer, pathname, len))
-		len = -EFAULT;
- out:
-	free_page((unsigned long)tmp);
-	return len;
-}
-
 static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int buflen)
 {
 	int error = -EACCES;
@@ -1230,7 +1206,7 @@
 	if (error)
 		goto out;
 
-	error = do_proc_readlink(&path, buffer, buflen);
+	error = fcntl_getpath(&path, buffer, buflen);
 	path_put(&path);
 out:
 	return error;
Index: linux-2.6.mod/include/linux/fs.h
===================================================================
--- linux-2.6.mod.orig/include/linux/fs.h	2008-04-13 14:40:01.000000000 -0700
+++ linux-2.6.mod/include/linux/fs.h	2008-04-13 14:40:34.000000000 -0700
@@ -960,6 +960,7 @@
 /* only for net: no internal synchronization */
 extern void __kill_fasync(struct fasync_struct *, int, int);
 
+extern int fcntl_getpath(struct path *fpath, char __user *path, int maxsize);
 extern int __f_setown(struct file *filp, struct pid *, enum pid_type, int force);
 extern int f_setown(struct file *filp, unsigned long arg, int force);
 extern void f_delown(struct file *filp);
