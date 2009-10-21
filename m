Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbZJUTWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbZJUTWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbZJUTWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:22:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbZJUTVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:47 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 40/41] union-mount: Make truncate work in all its glorious UNIX variations
Date: Wed, 21 Oct 2009 12:19:38 -0700
Message-Id: <1256152779-10054-41-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-40-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
 <1256152779-10054-28-git-send-email-vaurora@redhat.com>
 <1256152779-10054-29-git-send-email-vaurora@redhat.com>
 <1256152779-10054-30-git-send-email-vaurora@redhat.com>
 <1256152779-10054-31-git-send-email-vaurora@redhat.com>
 <1256152779-10054-32-git-send-email-vaurora@redhat.com>
 <1256152779-10054-33-git-send-email-vaurora@redhat.com>
 <1256152779-10054-34-git-send-email-vaurora@redhat.com>
 <1256152779-10054-35-git-send-email-vaurora@redhat.com>
 <1256152779-10054-36-git-send-email-vaurora@redhat.com>
 <1256152779-10054-37-git-send-email-vaurora@redhat.com>
 <1256152779-10054-38-git-send-email-vaurora@redhat.com>
 <1256152779-10054-39-git-send-email-vaurora@redhat.com>
 <1256152779-10054-40-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement truncate(), ftruncate(), and open(O_TRUNC) for union mounts.

This moves the union_copyup() in do_filp_open() down below may_open()
- this way you don't copy up a file you don't even have permission to
open.

may_open() now takes a nameidata * because it may have to do a
union_copyup() internally if O_TRUNC is specified.  It's a trivial
change, all callers were just doing "may_open(&nd.path, ...)" anyway.
It kinda sucks, but may_open() auto-magically doing a truncate also
sucks (may open? may truncate, too!).

XXX - Only copy up the bytes that won't be truncated.
XXX - Re-organize code. may_open() especially blah.
XXX - truncate() implemented as in-kernel file open and ftruncate()
XXX - Split up into smaller pieces

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c         |   22 +++++----
 fs/nfsctl.c        |    6 +-
 fs/open.c          |  124 ++++++++++++++++++++--------------------------------
 include/linux/fs.h |    2 +-
 4 files changed, 64 insertions(+), 90 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a8d3acf..e3e8e98 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2115,8 +2115,9 @@ int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	return error;
 }
 
-int may_open(struct path *path, int acc_mode, int flag)
+int may_open(struct nameidata *nd, int acc_mode, int flag)
 {
+	struct path *path = &nd->path;
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -2188,6 +2189,9 @@ int may_open(struct path *path, int acc_mode, int flag)
 		if (!error)
 			error = security_path_truncate(path, 0,
 					       ATTR_MTIME|ATTR_CTIME|ATTR_OPEN);
+		/* XXX don't copy up file data */
+		if (is_unionized(path->dentry, path->mnt))
+			error = union_copyup(nd, flag /* XXX not used */);
 		if (!error) {
 			vfs_dq_init(inode);
 
@@ -2234,7 +2238,7 @@ out_unlock:
 	if (error)
 		return error;
 	/* Don't check for write permission, don't truncate */
-	return may_open(&nd->path, 0, flag & ~O_TRUNC);
+	return may_open(nd, 0, flag & ~O_TRUNC);
 }
 
 /*
@@ -2309,12 +2313,6 @@ struct file *do_filp_open(int dfd, const char *pathname,
 					 &nd, flag);
 		if (error)
 			return ERR_PTR(error);
-		if (unlikely(flag & FMODE_WRITE)) {
-			/* Check for union, etc. in union_copyup */
-			error = union_copyup(&nd, flag /* XXX not used */);
-			if (error)
-				return ERR_PTR(error);
-		}
 		goto ok;
 	}
 
@@ -2452,12 +2450,18 @@ ok:
 		if (error)
 			goto exit;
 	}
-	error = may_open(&nd.path, acc_mode, flag);
+	error = may_open(&nd, acc_mode, flag);
 	if (error) {
 		if (will_write)
 			mnt_drop_write(nd.path.mnt);
 		goto exit;
 	}
+	/* Okay, all permissions go, now copy up */
+	if (!(flag & O_CREAT) && (flag & FMODE_WRITE)) {
+		error = union_copyup(&nd, flag /* XXX not used */);
+		if (error)
+			goto exit;
+	}
 	filp = nameidata_to_filp(&nd, open_flag);
 	if (IS_ERR(filp))
 		ima_counts_put(&nd.path,
diff --git a/fs/nfsctl.c b/fs/nfsctl.c
index 8f9a205..e3b733e 100644
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -38,10 +38,10 @@ static struct file *do_open(char *name, int flags)
 		return ERR_PTR(error);
 
 	if (flags == O_RDWR)
-		error = may_open(&nd.path, MAY_READ|MAY_WRITE,
-					   FMODE_READ|FMODE_WRITE);
+		error = may_open(&nd, MAY_READ|MAY_WRITE,
+				 FMODE_READ|FMODE_WRITE);
 	else
-		error = may_open(&nd.path, MAY_WRITE, FMODE_WRITE);
+		error = may_open(&nd, MAY_WRITE, FMODE_WRITE);
 
 	if (!error)
 		return dentry_open(nd.path.dentry, nd.path.mnt, flags,
diff --git a/fs/open.c b/fs/open.c
index 3df5a1b..a1da3a0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -223,69 +223,69 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	return err;
 }
 
-static long do_sys_truncate(const char __user *pathname, loff_t length)
+static int __do_ftruncate(struct file *file, unsigned long length, int small)
 {
-	struct path path;
-	struct inode *inode;
+	struct inode * inode;
+	struct dentry *dentry;
 	int error;
 
 	error = -EINVAL;
-	if (length < 0)	/* sorry, but loff_t says... */
+	if (length < 0)
 		goto out;
+	/* explicitly opened as large or we are on 64-bit box */
+	if (file->f_flags & O_LARGEFILE)
+		small = 0;
 
-	error = user_path(pathname, &path);
-	if (error)
+	dentry = file->f_path.dentry;
+	inode = dentry->d_inode;
+	error = -EINVAL;
+	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
 		goto out;
-	inode = path.dentry->d_inode;
-
-	/* For directories it's -EISDIR, for other non-regulars - -EINVAL */
-	error = -EISDIR;
-	if (S_ISDIR(inode->i_mode))
-		goto dput_and_out;
 
 	error = -EINVAL;
-	if (!S_ISREG(inode->i_mode))
-		goto dput_and_out;
-
-	error = mnt_want_write(path.mnt);
-	if (error)
-		goto dput_and_out;
+	/* Cannot ftruncate over 2^31 bytes without large file support */
+	if (small && length > MAX_NON_LFS)
 
-	error = inode_permission(inode, MAY_WRITE);
-	if (error)
-		goto mnt_drop_write_and_out;
+		goto out;
 
 	error = -EPERM;
 	if (IS_APPEND(inode))
-		goto mnt_drop_write_and_out;
+		goto out;
 
-	error = get_write_access(inode);
-	if (error)
-		goto mnt_drop_write_and_out;
+	error = locks_verify_truncate(inode, file, length);
+	if (!error)
+		error = security_path_truncate(&file->f_path, length,
+					       ATTR_MTIME|ATTR_CTIME);
+	if (!error)
+		/* Already copied up for union, opened with write */
+		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+out:
+	return error;
+}
 
-	/*
-	 * Make sure that there are no leases.  get_write_access() protects
-	 * against the truncate racing with a lease-granting setlease().
-	 */
-	error = break_lease(inode, FMODE_WRITE);
-	if (error)
-		goto put_write_and_out;
+static long do_sys_truncate(const char __user *pathname, loff_t length)
+{
+	struct file *file;
+	char *tmp;
+	int error;
 
-	error = locks_verify_truncate(inode, NULL, length);
-	if (!error)
-		error = security_path_truncate(&path, length, 0);
-	if (!error) {
-		vfs_dq_init(inode);
-		error = do_truncate(path.dentry, length, 0, NULL);
-	}
+	error = -EINVAL;
+	if (length < 0)	/* sorry, but loff_t says... */
+		return error;
 
-put_write_and_out:
-	put_write_access(inode);
-mnt_drop_write_and_out:
-	mnt_drop_write(path.mnt);
-dput_and_out:
-	path_put(&path);
-out:
+	tmp = getname(pathname);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+
+	file = filp_open(tmp, O_RDWR | O_LARGEFILE, 0);
+	putname(tmp);
+
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	error = __do_ftruncate(file, length, 0);
+
+	fput(file);
 	return error;
 }
 
@@ -297,46 +297,16 @@ SYSCALL_DEFINE2(truncate, const char __user *, path, unsigned long, length)
 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
-	struct inode * inode;
-	struct dentry *dentry;
 	struct file * file;
 	int error;
 
-	error = -EINVAL;
-	if (length < 0)
-		goto out;
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
 		goto out;
 
-	/* explicitly opened as large or we are on 64-bit box */
-	if (file->f_flags & O_LARGEFILE)
-		small = 0;
+	error = __do_ftruncate(file, length, small);
 
-	dentry = file->f_path.dentry;
-	inode = dentry->d_inode;
-	error = -EINVAL;
-	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
-		goto out_putf;
-
-	error = -EINVAL;
-	/* Cannot ftruncate over 2^31 bytes without large file support */
-	if (small && length > MAX_NON_LFS)
-		goto out_putf;
-
-	error = -EPERM;
-	if (IS_APPEND(inode))
-		goto out_putf;
-
-	error = locks_verify_truncate(inode, file, length);
-	if (!error)
-		error = security_path_truncate(&file->f_path, length,
-					       ATTR_MTIME|ATTR_CTIME);
-	if (!error)
-		/* Already copied up for union, opened with write */
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
-out_putf:
 	fput(file);
 out:
 	return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 38fb113..8eb0e0e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2134,7 +2134,7 @@ extern void free_write_pipe(struct file *);
 
 extern struct file *do_filp_open(int dfd, const char *pathname,
 		int open_flag, int mode, int acc_mode);
-extern int may_open(struct path *, int, int);
+extern int may_open(struct nameidata *, int, int);
 
 extern int kernel_read(struct file *, loff_t, char *, unsigned long);
 extern struct file * open_exec(const char *);
-- 
1.6.3.3

