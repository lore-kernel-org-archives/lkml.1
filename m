Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbXJJQf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbXJJQf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXJJQfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:35:00 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51799 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbXJJQe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:34:59 -0400
Subject: [RFC][PATCH 5/7] kill do_filp_open()
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 10 Oct 2007 09:34:43 -0700
References: <20071010163439.0F8089F7@kernel>
In-Reply-To: <20071010163439.0F8089F7@kernel>
Message-Id: <20071010163443.1D13D173@kernel>
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
--- lxc/fs/open.c~kill-do_filp_open	2007-10-04 13:59:44.000000000 -0700
+++ lxc-dave/fs/open.c	2007-10-04 13:59:44.000000000 -0700
@@ -863,17 +863,10 @@ cleanup_file:
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
 
@@ -1072,20 +1065,24 @@ long do_sys_open(int dfd, const char __u
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
