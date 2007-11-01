Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXKAXIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXKAXIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXKAXIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44340 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXKAXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:35 -0400
Subject: [PATCH 02/27] make open_namei() return a filp
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:28 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230828.B1162D60@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


open_namei() will, in the future, need to take mount write counts
over its creation and truncation (via may_open()) operations.  It
needs to keep these write counts until any potential filp that is
created gets __fput()'d.

This gets complicated in the error handling and becomes very murky
as to how far open_namei() actually got, and whether or not that
mount write count was taken.

Creating the filps inside of open_namei() lets us shift the write
count to be taken and released along with the filp.  We can hold
a temporary write count during those creation and truncation
operations, then release them once the write for the filp has
been established.

Any caller who gets a 'struct file' back must consider that filp
instantiated and fput() it normally.  The callers no longer
have to worry about ever manually releasing a mnt write count.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namei.c         |   16 ++++++++--------
 linux-2.6.git-dave/fs/open.c          |    7 +------
 linux-2.6.git-dave/include/linux/fs.h |    2 +-
 3 files changed, 10 insertions(+), 15 deletions(-)

diff -puN fs/namei.c~make-open_namei-return-a-filp fs/namei.c
--- linux-2.6.git/fs/namei.c~make-open_namei-return-a-filp	2007-11-01 14:46:05.000000000 -0700
+++ linux-2.6.git-dave/fs/namei.c	2007-11-01 14:46:05.000000000 -0700
@@ -1730,8 +1730,8 @@ static inline int sys_open_flags_to_name
  * system call.  See sys_open_flags_to_namei_flags().
  * SMP-safe
  */
-int open_namei(int dfd, const char *pathname, int sys_open_flag,
-		int mode, struct nameidata *nd)
+struct file *open_namei(int dfd, const char *pathname, int sys_open_flag,
+			int mode, struct nameidata *nd)
 {
 	int acc_mode, error;
 	struct path path;
@@ -1757,7 +1757,7 @@ int open_namei(int dfd, const char *path
 		error = path_lookup_open(dfd, pathname, lookup_flags(flag),
 					 nd, flag);
 		if (error)
-			return error;
+			return ERR_PTR(error);
 		goto ok;
 	}
 
@@ -1766,7 +1766,7 @@ int open_namei(int dfd, const char *path
 	 */
 	error = path_lookup_create(dfd,pathname,LOOKUP_PARENT,nd,flag,mode);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 
 	/*
 	 * We have the parent and last component. First of all, check
@@ -1801,7 +1801,7 @@ do_last:
 		error = __open_namei_create(nd, &path, flag, mode);
 		if (error)
 			goto exit;
-		return 0;
+		return nameidata_to_filp(nd, sys_open_flag);
 	}
 
 	/*
@@ -1834,7 +1834,7 @@ ok:
 	error = may_open(nd, acc_mode, flag);
 	if (error)
 		goto exit;
-	return 0;
+	return nameidata_to_filp(nd, sys_open_flag);
 
 exit_dput:
 	dput_path(&path, nd);
@@ -1842,7 +1842,7 @@ exit:
 	if (!IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
 	path_release(nd);
-	return error;
+	return ERR_PTR(error);
 
 do_link:
 	error = -ELOOP;
@@ -1869,7 +1869,7 @@ do_link:
 		 * with "intent.open".
 		 */
 		release_open_intent(nd);
-		return error;
+		return ERR_PTR(error);
 	}
 	nd->flags &= ~LOOKUP_PARENT;
 	if (nd->last_type == LAST_BIND)
diff -puN fs/open.c~make-open_namei-return-a-filp fs/open.c
--- linux-2.6.git/fs/open.c~make-open_namei-return-a-filp	2007-11-01 14:46:05.000000000 -0700
+++ linux-2.6.git-dave/fs/open.c	2007-11-01 14:46:05.000000000 -0700
@@ -803,14 +803,9 @@ cleanup_file:
 static struct file *do_filp_open(int dfd, const char *filename, int flags,
 				 int mode)
 {
-	int error;
 	struct nameidata nd;
 
-	error = open_namei(dfd, filename, flags, mode, &nd);
-	if (!error)
-		return nameidata_to_filp(&nd, flags);
-
-	return ERR_PTR(error);
+	return open_namei(dfd, filename, flags, mode, &nd);
 }
 
 struct file *filp_open(const char *filename, int flags, int mode)
diff -puN include/linux/fs.h~make-open_namei-return-a-filp include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~make-open_namei-return-a-filp	2007-11-01 14:46:05.000000000 -0700
+++ linux-2.6.git-dave/include/linux/fs.h	2007-11-01 14:46:05.000000000 -0700
@@ -1714,7 +1714,7 @@ extern struct file *create_read_pipe(str
 extern struct file *create_write_pipe(void);
 extern void free_write_pipe(struct file *);
 
-extern int open_namei(int dfd, const char *, int, int, struct nameidata *);
+extern struct file *open_namei(int dfd, const char *, int, int, struct nameidata *);
 extern int may_open(struct nameidata *, int, int);
 
 extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
_
