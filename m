Return-Path: <linux-kernel-owner+w=401wt.eu-S1031439AbXEDRpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031439AbXEDRpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031453AbXEDRpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:45:09 -0400
Received: from [198.99.130.12] ([198.99.130.12]:51069 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031435AbXEDRor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:44:47 -0400
Date: Fri, 4 May 2007 13:39:57 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Alberto Bertogli <albertito@gmail.com>,
       Blaisorblade <blaisorblade@yahoo.it>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/3] UML - Make hostfs_setattr() support operations on unlinked open files.
Message-ID: <20070504173957.GA7953@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alberto Bertogli <albertito@gmail.com>

This patch allows hostfs_setattr() to work on unlinked open files by
calling set_attr() (the userspace part) with the inode's fd.

Without this, applications that depend on doing attribute changes to
unlinked open files will fail.

It works by using the fd versions instead of the path ones (for example
fchmod() instead of chmod(), fchown() instead of chown()) when an fd is
available.

Signed-off-by: Alberto Bertogli <albertito@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 fs/hostfs/hostfs.h      |    4 -
 fs/hostfs/hostfs_kern.c |    6 +-
 fs/hostfs/hostfs_user.c |  106 ++++++++++++++++++++++++++++++------------------
 3 files changed, 73 insertions(+), 43 deletions(-)

Index: linux-2.6.21-mm/fs/hostfs/hostfs.h
===================================================================
--- linux-2.6.21-mm.orig/fs/hostfs/hostfs.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/fs/hostfs/hostfs.h	2007-05-01 15:10:39.000000000 -0400
@@ -55,7 +55,7 @@ extern int stat_file(const char *path, u
 		     int *mode_out, int *nlink_out, int *uid_out, int *gid_out,
 		     unsigned long long *size_out, struct timespec *atime_out,
 		     struct timespec *mtime_out, struct timespec *ctime_out,
-		     int *blksize_out, unsigned long long *blocks_out);
+		     int *blksize_out, unsigned long long *blocks_out, int fd);
 extern int access_file(char *path, int r, int w, int x);
 extern int open_file(char *path, int r, int w, int append);
 extern int file_type(const char *path, int *maj, int *min);
@@ -71,7 +71,7 @@ extern int lseek_file(int fd, long long 
 extern int fsync_file(int fd, int datasync);
 extern int file_create(char *name, int ur, int uw, int ux, int gr,
 		       int gw, int gx, int or, int ow, int ox);
-extern int set_attr(const char *file, struct hostfs_iattr *attrs);
+extern int set_attr(const char *file, struct hostfs_iattr *attrs, int fd);
 extern int make_symlink(const char *from, const char *to);
 extern int unlink_file(const char *file);
 extern int do_mkdir(const char *file, int mode);
Index: linux-2.6.21-mm/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.21-mm.orig/fs/hostfs/hostfs_kern.c	2007-04-27 11:27:15.000000000 -0400
+++ linux-2.6.21-mm/fs/hostfs/hostfs_kern.c	2007-05-01 15:10:39.000000000 -0400
@@ -147,7 +147,7 @@ static int read_name(struct inode *ino, 
 
 	err = stat_file(name, &i_ino, &i_mode, &i_nlink, &ino->i_uid,
 			&ino->i_gid, &i_size, &ino->i_atime, &ino->i_mtime,
-			&ino->i_ctime, &i_blksize, &i_blocks);
+			&ino->i_ctime, &i_blksize, &i_blocks, -1);
 	if(err)
 		return(err);
 
@@ -820,6 +820,8 @@ int hostfs_setattr(struct dentry *dentry
 	char *name;
 	int err;
 
+	int fd = HOSTFS_I(dentry->d_inode)->fd;
+
 	err = inode_change_ok(dentry->d_inode, attr);
 	if (err)
 		return err;
@@ -864,7 +866,7 @@ int hostfs_setattr(struct dentry *dentry
 	}
 	name = dentry_name(dentry, 0);
 	if(name == NULL) return(-ENOMEM);
-	err = set_attr(name, &attrs);
+	err = set_attr(name, &attrs, fd);
 	kfree(name);
 	if(err)
 		return(err);
Index: linux-2.6.21-mm/fs/hostfs/hostfs_user.c
===================================================================
--- linux-2.6.21-mm.orig/fs/hostfs/hostfs_user.c	2007-04-26 17:41:19.000000000 -0400
+++ linux-2.6.21-mm/fs/hostfs/hostfs_user.c	2007-05-01 15:10:39.000000000 -0400
@@ -21,12 +21,16 @@ int stat_file(const char *path, unsigned
 	      int *nlink_out, int *uid_out, int *gid_out,
 	      unsigned long long *size_out, struct timespec *atime_out,
 	      struct timespec *mtime_out, struct timespec *ctime_out,
-	      int *blksize_out, unsigned long long *blocks_out)
+	      int *blksize_out, unsigned long long *blocks_out, int fd)
 {
 	struct stat64 buf;
 
-	if(lstat64(path, &buf) < 0)
+	if(fd >= 0) {
+		if (fstat64(fd, &buf) < 0)
+			return(-errno);
+	} else if(lstat64(path, &buf) < 0) {
 		return(-errno);
+	}
 
 	if(inode_out != NULL) *inode_out = buf.st_ino;
 	if(mode_out != NULL) *mode_out = buf.st_mode;
@@ -202,58 +206,82 @@ int file_create(char *name, int ur, int 
 	return(fd);
 }
 
-int set_attr(const char *file, struct hostfs_iattr *attrs)
+int set_attr(const char *file, struct hostfs_iattr *attrs, int fd)
 {
-	struct utimbuf buf;
+	struct timeval times[2];
+	struct timespec atime_ts, mtime_ts;
 	int err, ma;
 
-	if(attrs->ia_valid & HOSTFS_ATTR_MODE){
-		if(chmod(file, attrs->ia_mode) != 0) return(-errno);
-	}
-	if(attrs->ia_valid & HOSTFS_ATTR_UID){
-		if(chown(file, attrs->ia_uid, -1)) return(-errno);
+	if (attrs->ia_valid & HOSTFS_ATTR_MODE) {
+		if (fd >= 0) {
+			if (fchmod(fd, attrs->ia_mode) != 0)
+				return (-errno);
+		} else if (chmod(file, attrs->ia_mode) != 0) {
+			return (-errno);
+		}
 	}
-	if(attrs->ia_valid & HOSTFS_ATTR_GID){
-		if(chown(file, -1, attrs->ia_gid)) return(-errno);
+	if (attrs->ia_valid & HOSTFS_ATTR_UID) {
+		if (fd >= 0) {
+			if (fchown(fd, attrs->ia_uid, -1))
+				return (-errno);
+		} else if(chown(file, attrs->ia_uid, -1)) {
+			return (-errno);
+		}
 	}
-	if(attrs->ia_valid & HOSTFS_ATTR_SIZE){
-		if(truncate(file, attrs->ia_size)) return(-errno);
+	if (attrs->ia_valid & HOSTFS_ATTR_GID) {
+		if (fd >= 0) {
+			if (fchown(fd, -1, attrs->ia_gid))
+				return (-errno);
+		} else if (chown(file, -1, attrs->ia_gid)) {
+			return (-errno);
+		}
 	}
-	ma = HOSTFS_ATTR_ATIME_SET | HOSTFS_ATTR_MTIME_SET;
-	if((attrs->ia_valid & ma) == ma){
-		buf.actime = attrs->ia_atime.tv_sec;
-		buf.modtime = attrs->ia_mtime.tv_sec;
-		if(utime(file, &buf) != 0) return(-errno);
+	if (attrs->ia_valid & HOSTFS_ATTR_SIZE) {
+		if (fd >= 0) {
+			if (ftruncate(fd, attrs->ia_size))
+				return (-errno);
+		} else if (truncate(file, attrs->ia_size)) {
+			return (-errno);
+		}
 	}
-	else {
-		struct timespec ts;
 
-		if(attrs->ia_valid & HOSTFS_ATTR_ATIME_SET){
-			err = stat_file(file, NULL, NULL, NULL, NULL, NULL,
-					NULL, NULL, &ts, NULL, NULL, NULL);
-			if(err != 0)
-				return(err);
-			buf.actime = attrs->ia_atime.tv_sec;
-			buf.modtime = ts.tv_sec;
-			if(utime(file, &buf) != 0)
-				return(-errno);
+	/* Update accessed and/or modified time, in two parts: first set
+	 * times according to the changes to perform, and then call futimes()
+	 * or utimes() to apply them. */
+	ma = (HOSTFS_ATTR_ATIME_SET | HOSTFS_ATTR_MTIME_SET);
+	if (attrs->ia_valid & ma) {
+		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
+				&atime_ts, &mtime_ts, NULL, NULL, NULL, fd);
+		if (err != 0)
+			return err;
+
+		times[0].tv_sec = atime_ts.tv_sec;
+		times[0].tv_usec = atime_ts.tv_nsec * 1000;
+		times[1].tv_sec = mtime_ts.tv_sec;
+		times[1].tv_usec = mtime_ts.tv_nsec * 1000;
+
+		if (attrs->ia_valid & HOSTFS_ATTR_ATIME_SET) {
+			times[0].tv_sec = attrs->ia_atime.tv_sec;
+			times[0].tv_usec = attrs->ia_atime.tv_nsec * 1000;
 		}
-		if(attrs->ia_valid & HOSTFS_ATTR_MTIME_SET){
-			err = stat_file(file, NULL, NULL, NULL, NULL, NULL,
-					NULL, &ts, NULL, NULL, NULL, NULL);
-			if(err != 0)
-				return(err);
-			buf.actime = ts.tv_sec;
-			buf.modtime = attrs->ia_mtime.tv_sec;
-			if(utime(file, &buf) != 0)
-				return(-errno);
+		if (attrs->ia_valid & HOSTFS_ATTR_MTIME_SET) {
+			times[1].tv_sec = attrs->ia_mtime.tv_sec;
+			times[1].tv_usec = attrs->ia_mtime.tv_nsec * 1000;
+		}
+
+		if (fd >= 0) {
+			if (futimes(fd, times) != 0)
+				return (-errno);
+		} else if (utimes(file, times) != 0) {
+			return (-errno);
 		}
 	}
+
 	if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
 	if(attrs->ia_valid & (HOSTFS_ATTR_ATIME | HOSTFS_ATTR_MTIME)){
 		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
 				&attrs->ia_atime, &attrs->ia_mtime, NULL,
-				NULL, NULL);
+				NULL, NULL, fd);
 		if(err != 0) return(err);
 	}
 	return(0);
