Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYEaPlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYEaPlD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYEaPiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:64887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYEaPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:15 -0400
Message-Id: <20080531153510.947704691@arndb.de>
References: <20080531152013.031903990@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 17:20:17 +0200
From: arnd@arndb.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [RFC 4/7] cramfs: allow rmdir
Content-Disposition: inline; filename=0004-cramfs-allow-rmdir.patch
X-Provags-ID: V01U2FsdGVkX1/UJAtkHBJEppxvIdQFZQ83UMxi99CPNmW9B2Y
 jL54cv9sDMgcZcyrqaB7oah/rjOGtGtaiG5TseeCgD5vloP9uW
 ZmxkY3SoDxZ7Neorz6Z2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rmdir in cramfs works much like unlink, but we need to check
first that the directory is empty. Since the link count is
always 1, we have to look at the directory contents for that,
but fortunately, we can abuse the readdir logic for that,
to check if at least one entry exists.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cramfs/inode.c |   71 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 6b9f21f..8c3e8bb 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -326,18 +326,20 @@ static int cramfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 /*
  * Read a cramfs directory entry.
  */
-static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+static int cramfs_readdir_ondisk(struct dentry *dentry, void *dirent,
+			filldir_t filldir, loff_t *pos)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
 	char *buf;
 	unsigned int offset;
 	int copied;
 
 	/* Offset within the thing. */
-	offset = filp->f_pos;
+	offset = *pos;
 	if (offset >= inode->i_size)
 		return 0;
+
 	/* Directory entries are always 4-byte aligned */
 	if (offset & 3)
 		return -EINVAL;
@@ -355,7 +357,7 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		ino_t ino;
 		mode_t mode;
 		int namelen, error;
-		struct dentry *dentry;
+		struct dentry *d;
 
 		mutex_lock(&read_mutex);
 		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
@@ -382,25 +384,32 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			namelen--;
 		}
 		qstr.len = namelen;
-		dentry = d_hash_and_lookup(filp->f_path.dentry, &qstr);
+		d = d_hash_and_lookup(dentry, &qstr);
 
 		error = 0;
-		if (!dentry || (dentry->d_inode))
-				error = filldir(dirent, buf, namelen, offset,
-					ino, mode >> 12);
+		if (!d || (d->d_inode))
+			error = filldir(dirent, buf, namelen,
+					offset, ino, mode >> 12);
 
-		dput(dentry);
+		dput(d);
 		if (error)
 			break;
 
 		offset = nextoffset;
-		filp->f_pos = offset;
+		*pos = offset;
 		copied++;
 	}
 	kfree(buf);
+
 	return 0;
 }
 
+static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	return cramfs_readdir_ondisk(filp->f_dentry, dirent,
+					filldir, &filp->f_pos);
+}
+
 int cramfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
@@ -414,6 +423,47 @@ int cramfs_unlink(struct inode *dir, struct dentry *dentry)
 	dget(dentry);
 	return 0;
 }
+
+/*
+ * We use the readdir infrastructure to test whether a directory is
+ * empty or not. cramfs_test_filldir will get called for any on-disk
+ * dentries that have not been unlinked.
+ */
+static int cramfs_test_filldir(void * __buf, const char * name, int namlen,
+				loff_t offset, u64 ino, unsigned int d_type)
+{
+	int *buf = __buf;
+	*buf = 0;
+	return -ENOTEMPTY;
+}
+
+static int cramfs_empty(struct dentry *dentry)
+{
+	loff_t pos = 0;
+	int empty = 1;
+	int ret;
+	if (!dentry->d_inode || !S_ISDIR(dentry->d_inode->i_mode))
+		return 1;
+
+	if (!simple_empty(dentry))
+		return 0;
+
+	ret = cramfs_readdir_ondisk(dentry, &empty, cramfs_test_filldir, &pos);
+	if (ret)
+		return ret;
+
+	return empty;
+}
+
+int cramfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	if (!cramfs_empty(dentry))
+		return -ENOTEMPTY;
+
+	cramfs_unlink(dir, dentry);
+	return 0;
+}
+
 /*
  * Lookup and fill in the inode data..
  */
@@ -536,6 +586,7 @@ static const struct file_operations cramfs_directory_operations = {
 
 static const struct inode_operations cramfs_dir_inode_operations = {
 	.unlink		= cramfs_unlink,
+	.rmdir		= cramfs_rmdir,
 	.lookup		= cramfs_lookup,
 };
 
-- 
1.5.4.3

-- 

