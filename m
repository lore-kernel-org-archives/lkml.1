Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbXI0Swi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbXI0Swi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbXI0SwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:52:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56469 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbXI0SwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:52:18 -0400
Subject: [RFC][PATCH 5/5] make open_namei() return a filp
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 27 Sep 2007 11:52:15 -0700
References: <20070927185210.FD980C90@kernel>
In-Reply-To: <20070927185210.FD980C90@kernel>
Message-Id: <20070927185215.8ADB5392@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If open_namei() succeeds, there is potentially a mnt_want_write()
that needs to get balanced.  If the caller doesn't create a
'struct file' and eventually __fput() it, or manually drop the
write count on an error, we have a bug.

Forcing open_namei() to return a filp fixes this.  Any caller
getting a 'struct file' back must consider that filp instantiated
and fput() it normally.  The callers no longer have to worry about
ever manually releasing a mnt write count.

---

 lxc-dave/fs/namei.c         |   16 ++++++++--------
 lxc-dave/fs/open.c          |    6 +-----
 lxc-dave/include/linux/fs.h |    2 +-
 3 files changed, 10 insertions(+), 14 deletions(-)

diff -puN fs/namei.c~make-open_namei-return-a-filp fs/namei.c
--- lxc/fs/namei.c~make-open_namei-return-a-filp	2007-09-27 11:51:34.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-27 11:51:34.000000000 -0700
@@ -1750,8 +1750,8 @@ static inline int sys_open_flags_to_name
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
@@ -1777,7 +1777,7 @@ int open_namei(int dfd, const char *path
 		error = path_lookup_open(dfd, pathname, lookup_flags(flag),
 					 nd, flag);
 		if (error)
-			return error;
+			return ERR_PTR(error);
 		goto ok;
 	}
 
@@ -1786,7 +1786,7 @@ int open_namei(int dfd, const char *path
 	 */
 	error = path_lookup_create(dfd,pathname,LOOKUP_PARENT,nd,flag,mode);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 
 	/*
 	 * We have the parent and last component. First of all, check
@@ -1820,7 +1820,7 @@ do_last:
 		error = __open_namei_create(nd, &path, flag, mode);
 		if (error)
 			goto exit;
-		return 0;
+		return nameidata_to_filp(nd, sys_open_flag);
 	}
 
 	/*
@@ -1864,7 +1864,7 @@ ok:
 			mnt_drop_write(nd->mnt);
 		goto exit;
 	}
-	return 0;
+	return nameidata_to_filp(nd, sys_open_flag);
 
 exit_mutex_unlock:
 	mutex_unlock(&dir->d_inode->i_mutex);
@@ -1874,7 +1874,7 @@ exit:
 	if (!IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
 	path_release(nd);
-	return error;
+	return ERR_PTR(error);
 
 do_link:
 	error = -ELOOP;
@@ -1901,7 +1901,7 @@ do_link:
 		 * with "intent.open".
 		 */
 		release_open_intent(nd);
-		return error;
+		return ERR_PTR(error);
 	}
 	nd->flags &= ~LOOKUP_PARENT;
 	if (nd->last_type == LAST_BIND)
diff -puN fs/open.c~make-open_namei-return-a-filp fs/open.c
--- lxc/fs/open.c~make-open_namei-return-a-filp	2007-09-27 11:51:34.000000000 -0700
+++ lxc-dave/fs/open.c	2007-09-27 11:51:34.000000000 -0700
@@ -846,11 +846,7 @@ static struct file *do_filp_open(int dfd
 	int error;
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
--- lxc/include/linux/fs.h~make-open_namei-return-a-filp	2007-09-27 11:51:34.000000000 -0700
+++ lxc-dave/include/linux/fs.h	2007-09-27 11:51:34.000000000 -0700
@@ -1716,7 +1716,7 @@ extern struct file *create_read_pipe(str
 extern struct file *create_write_pipe(void);
 extern void free_write_pipe(struct file *);
 
-extern int open_namei(int dfd, const char *, int, int, struct nameidata *);
+extern struct file *open_namei(int dfd, const char *, int, int, struct nameidata *);
 extern int may_open(struct nameidata *, int, int);
 
 extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
_
