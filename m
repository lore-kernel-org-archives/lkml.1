Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbXI1SP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbXI1SP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbXI1SNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:13:47 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51637 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbXI1SNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:13:46 -0400
Subject: [RFC][PATCH 6/8] kill do_filp_open()
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 28 Sep 2007 11:13:38 -0700
References: <20070928181330.27B367AC@kernel>
In-Reply-To: <20070928181330.27B367AC@kernel>
Message-Id: <20070928181338.29146487@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This kills off the almost empty do_filp_open().  The indenting
change in do_sys_open() is because we would have gone over our
80 characters otherwise.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/open.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff -puN fs/open.c~kill-do_filp_open fs/open.c
--- lxc/fs/open.c~kill-do_filp_open	2007-09-28 11:03:24.000000000 -0700
+++ lxc-dave/fs/open.c	2007-09-28 11:03:24.000000000 -0700
@@ -840,17 +840,10 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-static struct file *do_filp_open(int dfd, const char *filename, int flags,
-				 int mode)
-{
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
 
@@ -1049,20 +1042,24 @@ long do_sys_open(int dfd, const char __u
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
