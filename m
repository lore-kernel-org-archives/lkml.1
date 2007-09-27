Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbXI0Sxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbXI0Sxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbXI0SwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:52:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36170 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbXI0SwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:52:22 -0400
Subject: [RFC][PATCH 4/5] do namei_flags calculation inside open_namei()
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 27 Sep 2007 11:52:14 -0700
References: <20070927185210.FD980C90@kernel>
In-Reply-To: <20070927185210.FD980C90@kernel>
Message-Id: <20070927185214.466F6DB9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


My end goal here is to make sure all users of may_open()
return filps.  This will ensure that we properly release
mount write counts which were taken for the filp in
may_open().

This patch moves the sys_open flags to namei flags
calculation into fs/namei.c.  We'll shortly be moving
the nameidata_to_filp() calls into namei.c, and this
gets the sys_open flags to a place where we can get
at them when we need them.

---

 lxc-dave/fs/namei.c |   43 ++++++++++++++++++++++++++++++++++---------
 lxc-dave/fs/open.c  |   22 ++--------------------
 2 files changed, 36 insertions(+), 29 deletions(-)

diff -puN fs/namei.c~do-namei_flags-calculation-inside-open_namei fs/namei.c
--- lxc/fs/namei.c~do-namei_flags-calculation-inside-open_namei	2007-09-27 11:51:33.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-27 11:51:33.000000000 -0700
@@ -1672,7 +1672,12 @@ int may_open(struct nameidata *nd, int a
 	return 0;
 }
 
-static int open_namei_create(struct nameidata *nd, struct path *path,
+/*
+ * Be careful about ever adding any more callers of this
+ * function.  Its flags must be in the namei format, not
+ * what get passed to sys_open().
+ */
+static int __open_namei_create(struct nameidata *nd, struct path *path,
 				int flag, int mode)
 {
 	int error;
@@ -1713,26 +1718,46 @@ static inline int write_may_occur_to_fil
 }
 
 /*
+ * Note that while the flag value (low two bits) for sys_open means:
+ *	00 - read-only
+ *	01 - write-only
+ *	10 - read-write
+ *	11 - special
+ * it is changed into
+ *	00 - no permissions needed
+ *	01 - read-permission
+ *	10 - write-permission
+ *	11 - read-write
+ * for the internal routines (ie open_namei()/follow_link() etc)
+ * This is more logical, and also allows the 00 "no perm needed"
+ * to be used for symlinks (where the permissions are checked
+ * later).
+ *
+*/
+static inline int sys_open_flags_to_namei_flags(int flag)
+{
+	if ((flag+1) & O_ACCMODE)
+		flag++;
+	return flag;
+}
+
+/*
  *	open_namei()
  *
  * namei for open - this is in fact almost the whole open-routine.
  *
  * Note that the low bits of "flag" aren't the same as in the open
- * system call - they are 00 - no permissions needed
- *			  01 - read permission needed
- *			  10 - write permission needed
- *			  11 - read/write permissions needed
- * which is a lot more logical, and also allows the "no perm" needed
- * for symlinks (where the permissions are checked later).
+ * system call.  See sys_open_flags_to_namei_flags().
  * SMP-safe
  */
-int open_namei(int dfd, const char *pathname, int flag,
+int open_namei(int dfd, const char *pathname, int sys_open_flag,
 		int mode, struct nameidata *nd)
 {
 	int acc_mode, error;
 	struct path path;
 	struct dentry *dir;
 	int count = 0;
+	int flag = sys_open_flags_to_namei_flags(sys_open_flag);
 
 	acc_mode = ACC_MODE(flag);
 
@@ -1792,7 +1817,7 @@ do_last:
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = open_namei_create(nd, &path, flag, mode);
+		error = __open_namei_create(nd, &path, flag, mode);
 		if (error)
 			goto exit;
 		return 0;
diff -puN fs/open.c~do-namei_flags-calculation-inside-open_namei fs/open.c
--- lxc/fs/open.c~do-namei_flags-calculation-inside-open_namei	2007-09-27 11:51:33.000000000 -0700
+++ lxc-dave/fs/open.c	2007-09-27 11:51:33.000000000 -0700
@@ -840,31 +840,13 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-/*
- * Note that while the flag value (low two bits) for sys_open means:
- *	00 - read-only
- *	01 - write-only
- *	10 - read-write
- *	11 - special
- * it is changed into
- *	00 - no permissions needed
- *	01 - read-permission
- *	10 - write-permission
- *	11 - read-write
- * for the internal routines (ie open_namei()/follow_link() etc). 00 is
- * used by symlinks.
- */
 static struct file *do_filp_open(int dfd, const char *filename, int flags,
 				 int mode)
 {
-	int namei_flags, error;
+	int error;
 	struct nameidata nd;
 
-	namei_flags = flags;
-	if ((namei_flags+1) & O_ACCMODE)
-		namei_flags++;
-
-	error = open_namei(dfd, filename, namei_flags, mode, &nd);
+	error = open_namei(dfd, filename, flags, mode, &nd);
 	if (!error)
 		return nameidata_to_filp(&nd, flags);
 
_
