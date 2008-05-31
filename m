Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYEaPjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYEaPjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYEaPiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYEaPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:09 -0400
Message-Id: <20080531153510.820446949@arndb.de>
References: <20080531152013.031903990@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 17:20:16 +0200
From: arnd@arndb.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [RFC 3/7] cramfs: allow unlinking of files
Content-Disposition: inline; filename=0003-cramfs-allow-unlinking-of-files.patch
X-Provags-ID: V01U2FsdGVkX1+smFy4gPDGQXmu8s8q7ovhd/4d7vn82Jx6QLQ
 Q6G1PE7LEmCJKjAvFFsrmQTmUXYfVuEVpz6OaAIhpFF/7HlxkW
 Pi5pkwxJUdHG0sIbILDyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new cramfs_unlink function replaces an existing dentry with
a pinned negative dentry in cramfs, so that lookup does not find
it any more.

The readdir function gets changed here to no longer show the file
if a negative dentry exists.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cramfs/inode.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 8aa04d7..6b9f21f 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -348,12 +348,14 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 
 	copied = 0;
 	while (offset < inode->i_size) {
+		struct qstr qstr = { .name = buf, };
 		struct cramfs_inode *de;
 		unsigned long nextoffset;
 		char *name;
 		ino_t ino;
 		mode_t mode;
 		int namelen, error;
+		struct dentry *dentry;
 
 		mutex_lock(&read_mutex);
 		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
@@ -379,7 +381,15 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				break;
 			namelen--;
 		}
-		error = filldir(dirent, buf, namelen, offset, ino, mode >> 12);
+		qstr.len = namelen;
+		dentry = d_hash_and_lookup(filp->f_path.dentry, &qstr);
+
+		error = 0;
+		if (!dentry || (dentry->d_inode))
+				error = filldir(dirent, buf, namelen, offset,
+					ino, mode >> 12);
+
+		dput(dentry);
 		if (error)
 			break;
 
@@ -391,6 +401,19 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	return 0;
 }
 
+int cramfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct dentry *new;
+
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	drop_nlink(inode);
+	new = d_alloc(dentry->d_parent, &dentry->d_name);
+	d_add(new, NULL);
+
+	dget(dentry);
+	return 0;
+}
 /*
  * Lookup and fill in the inode data..
  */
@@ -512,10 +535,12 @@ static const struct file_operations cramfs_directory_operations = {
 };
 
 static const struct inode_operations cramfs_dir_inode_operations = {
+	.unlink		= cramfs_unlink,
 	.lookup		= cramfs_lookup,
 };
 
 static const struct super_operations cramfs_ops = {
+	.drop_inode	= generic_delete_inode,
 	.put_super	= cramfs_put_super,
 	.remount_fs	= cramfs_remount,
 	.statfs		= cramfs_statfs,
-- 
1.5.4.3

-- 

