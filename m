Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXI0TIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXI0TIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbXI0TIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:08:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33669 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbXI0TIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:08:46 -0400
Subject: [RFC][PATCH] kill do_filp_open()
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 27 Sep 2007 12:08:23 -0700
Message-Id: <20070927190823.A810E243@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This kills off the almost empty do_filp_open().  However,
let's keep filp_open() around.  It does the nameidata allocation
on the stack, and also adds the AT_FDCWD argument.  I think
that's enough to keep it around.

---

 lxc-dave/fs/open.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff -puN fs/open.c~kill-do_filp_open fs/open.c
--- lxc/fs/open.c~kill-do_filp_open	2007-09-27 12:03:24.000000000 -0700
+++ lxc-dave/fs/open.c	2007-09-27 12:05:31.000000000 -0700
@@ -840,18 +840,10 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-static struct file *do_filp_open(int dfd, const char *filename, int flags,
-				 int mode)
-{
-	int error;
-	struct nameidata nd;
-
-	return open_namei(dfd, filename, flags, mode, &nd);
-}
-
 struct file *filp_open(const char *filename, int flags, int mode)
 {
-	return do_filp_open(AT_FDCWD, filename, flags, mode);
+	struct nameidata nd;
+	return open_namei(AT_FDCWD, filename, flags, mode, &nd);
 }
 EXPORT_SYMBOL(filp_open);
 
@@ -1050,20 +1042,24 @@ long do_sys_open(int dfd, const char __u
 	char *tmp = getname(filename);
 	int fd = PTR_ERR(tmp);
 
-	if (!IS_ERR(tmp)) {
-		fd = get_unused_fd_flags(flags);
-		if (fd >= 0) {
-			struct file *f = do_filp_open(dfd, tmp, flags, mode);
-			if (IS_ERR(f)) {
-				put_unused_fd(fd);
-				fd = PTR_ERR(f);
-			} else {
-				fsnotify_open(f->f_path.dentry);
-				fd_install(fd, f);
-			}
+	if (IS_ERR(tmp))
+		goto out;
+
+	fd = get_unused_fd_flags(flags);
+	if (fd >= 0) {
+		struct nameidata nd;
+		struct file *f = open_namei(dfd, tmp, flags, mode, &nd);
+
+		if (IS_ERR(f)) {
+			put_unused_fd(fd);
+			fd = PTR_ERR(f);
+		} else {
+			fsnotify_open(f->f_path.dentry);
+			fd_install(fd, f);
 		}
-		putname(tmp);
 	}
+	putname(tmp);
+out:
 	return fd;
 }
 
_
