Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbXLPCFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbXLPCFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbXLPCFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:05:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:33772 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbXLPCE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ORbf9I/BIDSP0/rQjQsUas6YOII/JB0ji4MOOWD4b6wqfhvgykaVUxF7YBUkSgT/+V4ezLIZxP28hhWUyoDfP6ARjwYQGl/3Fx88yGBAnC6lUdaSMfnyOhVsxbk5KO8mjlub8I6USujV3XpkS/iSHV+L3R57UUXugTpSysBQ464=
Date: Sun, 16 Dec 2007 03:06:37 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: [PATCH 1/6] udf: remove wrong prototype of udf_readdir
Message-ID: <20071216020630.GB26986@joi>
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
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
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

