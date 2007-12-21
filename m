Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbXLUPxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbXLUPxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXLUPxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:53:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:28524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbXLUPxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 10:53:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=iLXANQiDhXIxrKLBduZe6UtgeSQhK3RDOIXIHW3eGLjWQJ2JXZvonoQyXq80AoYvDiuaWzzGijU88Fzwqcr5iVUbRpXhYra49y7QmSiKsxTyXTmN4BiZiZoUE9alrSU29e9/lng9/zfMgf/3oVsUUF7Mu56riA7N964vAtvCmts=
Date: Fri, 21 Dec 2007 16:55:03 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/5] udf: remove wrong prototype of udf_readdir
Message-ID: <20071221155453.GA8575@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse generated:
fs/udf/dir.c:78:5: warning: symbol 'udf_readdir' was not declared. Should it be static?
there are 2 different prototypes of udf_readdir - remove them and move
code around to make it still compile

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c |  118 +++++++++++++++++++++++++++------------------------------
 1 files changed, 56 insertions(+), 62 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 9e3b9f9..174d2fc 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -36,68 +36,8 @@
 #include "udf_i.h"
 #include "udf_sb.h"

-/* Prototypes for file operations */
-static int udf_readdir(struct file *, void *, filldir_t);
-static int do_udf_readdir(struct inode *, struct file *, filldir_t, void *);
-
-/* readdir and lookup functions */
-
-const struct file_operations udf_dir_operations = {
-	.read			= generic_read_dir,
-	.readdir		= udf_readdir,
-	.ioctl			= udf_ioctl,
-	.fsync			= udf_fsync_file,
-};
-
-/*
- * udf_readdir
- *
- * PURPOSE
- *	Read a directory entry.
- *
- * DESCRIPTION
- *	Optional - sys_getdents() will return -ENOTDIR if this routine is not
- *	available.
- *
- *	Refer to sys_getdents() in fs/readdir.c
- *	sys_getdents() -> .
- *
- * PRE-CONDITIONS
- *	filp			Pointer to directory file.
- *	buf			Pointer to directory entry buffer.
- *	filldir			Pointer to filldir function.
- *
- * POST-CONDITIONS
- *	<return>		>=0 on success.
- *
- * HISTORY
- *	July 1, 1997 - Andrew E. Mileski
- *	Written, tested, and released.
- */
-
-int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
-{
-	struct inode *dir = filp->f_path.dentry->d_inode;
-	int result;
-
-	lock_kernel();
-
-	if (filp->f_pos == 0) {
-		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
-			unlock_kernel();
-			return 0;
-		}
-		filp->f_pos++;
-	}
-
-	result = do_udf_readdir(dir, filp, filldir, dirent);
-	unlock_kernel();
- 	return result;
-}
-
-static int
-do_udf_readdir(struct inode *dir, struct file *filp, filldir_t filldir,
-	       void *dirent)
+static int do_udf_readdir(struct inode *dir, struct file *filp,
+			  filldir_t filldir, void *dirent)
 {
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc *fi = NULL;
@@ -244,3 +184,57 @@ do_udf_readdir(struct inode *dir, struct file *filp, filldir_t filldir,

 	return 0;
 }
+
+/*
+ * udf_readdir
+ *
+ * PURPOSE
+ *	Read a directory entry.
+ *
+ * DESCRIPTION
+ *	Optional - sys_getdents() will return -ENOTDIR if this routine is not
+ *	available.
+ *
+ *	Refer to sys_getdents() in fs/readdir.c
+ *	sys_getdents() -> .
+ *
+ * PRE-CONDITIONS
+ *	filp			Pointer to directory file.
+ *	buf			Pointer to directory entry buffer.
+ *	filldir			Pointer to filldir function.
+ *
+ * POST-CONDITIONS
+ *	<return>		>=0 on success.
+ *
+ * HISTORY
+ *	July 1, 1997 - Andrew E. Mileski
+ *	Written, tested, and released.
+ */
+
+static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct inode *dir = filp->f_path.dentry->d_inode;
+	int result;
+
+	lock_kernel();
+
+	if (filp->f_pos == 0) {
+		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
+			unlock_kernel();
+			return 0;
+		}
+		filp->f_pos++;
+	}
+
+	result = do_udf_readdir(dir, filp, filldir, dirent);
+	unlock_kernel();
+ 	return result;
+}
+
+/* readdir and lookup functions */
+const struct file_operations udf_dir_operations = {
+	.read			= generic_read_dir,
+	.readdir		= udf_readdir,
+	.ioctl			= udf_ioctl,
+	.fsync			= udf_fsync_file,
+};
--
1.5.3.4

