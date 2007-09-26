Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbXIZBVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbXIZBVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXIZBVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:21:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41252 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbXIZBVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:21:12 -0400
Subject: Re: missing mnt_drop_write() on open error
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 18:21:09 -0700
Message-Id: <1190769669.26982.325.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 01:14 +0200, Miklos Szeredi wrote:
> I get this at umount, if there was a failed open():
> 
> WARNING: at fs/namespace.c:586 __mntput()
> 
> I think the problem is that may_open() calls mnt_want_write(), but if
> open doesn't succeed, mnt_drop_write() will not be called.

Does this help?  I'm also thinking that we should change the open_namei*
functions to simply return 'struct file *'.  Those are the only users
other than NFS, and forcing the return of a file like that will force
users to do the fput() on it if they don't want it any more.  We'd just
need to make sure no new may_open() users pop up.  Any thoughts on that?

--

The r/o bind mount patches have an error in them:
they unconditionally take a mnt_want_write() on
all may_open() requests for writeable files.  They
mistakenly do not mnt_drop_write() if may_open()
encounters an error.

---

 lxc-dave/fs/namei.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN fs/namei.c~drop-write-if-may_open-fails fs/namei.c
--- lxc/fs/namei.c~drop-write-if-may_open-fails	2007-09-25 18:16:59.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-25 18:16:59.000000000 -0700
@@ -1594,11 +1594,23 @@ int vfs_create(struct inode *dir, struct
 	return error;
 }
 
+/*
+ * If you call this with FMODE_WRITE set in flag,
+ * and get a successful return, you will have
+ * acquired a write on nd->mnt.
+ *
+ * Basically, if you use this function, you either
+ * need to fix up that write count manually, or just
+ * return a 'struct file' from your function.  When
+ * you __fput() that 'struct file' it will get fixed
+ * up automatically.
+ */
 int may_open(struct nameidata *nd, int acc_mode, int flag)
 {
 	struct dentry *dentry = nd->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
+	int took_mnt_write = 0;
 
 	if (!inode)
 		return -ENOENT;
@@ -1624,42 +1636,48 @@ int may_open(struct nameidata *nd, int a
 	} else if (flag & FMODE_WRITE) {
 		/*
 		 * effectively: !special_file()
-		 * balanced by __fput()
+		 * Balanced by __fput() and
+		 * released on error at the end
+		 * of this function.
 		 */
 		error = mnt_want_write(nd->mnt);
 		if (error)
 			return error;
+		took_mnt_write = 1;
 	}
 
 	error = vfs_permission(nd, acc_mode);
 	if (error)
-		return error;
+		goto out_err;
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
 	if (IS_APPEND(inode)) {
+		error = -EPERM;
 		if  ((flag & FMODE_WRITE) && !(flag & O_APPEND))
-			return -EPERM;
+			goto out_err;
+		error = -EPERM;
 		if (flag & O_TRUNC)
-			return -EPERM;
+			goto out_err;
 	}
 
 	/* O_NOATIME can only be set by the owner or superuser */
+	error = -EPERM;
 	if (flag & O_NOATIME)
 		if (!is_owner_or_cap(inode))
-			return -EPERM;
+			goto out_err;
 
 	/*
 	 * Ensure there are no outstanding leases on the file.
 	 */
 	error = break_lease(inode, flag);
 	if (error)
-		return error;
+		goto out_err;
 
 	if (flag & O_TRUNC) {
 		error = get_write_access(inode);
 		if (error)
-			return error;
+			goto out_err;
 
 		/*
 		 * Refuse to truncate files with mandatory locks held on them.
@@ -1672,12 +1690,15 @@ int may_open(struct nameidata *nd, int a
 		}
 		put_write_access(inode);
 		if (error)
-			return error;
+			goto out_err;
 	} else
 		if (flag & FMODE_WRITE)
 			DQUOT_INIT(inode);
 
-	return 0;
+out_err:
+	if (error && took_mnt_write)
+		mnt_drop_write(nd->mnt);
+	return error;
 }
 
 static int open_namei_create(struct nameidata *nd, struct path *path,

-- Dave

