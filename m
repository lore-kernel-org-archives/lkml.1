Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYEaPj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYEaPj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYEaPio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYEaPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:09 -0400
Message-Id: <20080531153511.204364754@arndb.de>
References: <20080531152013.031903990@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 17:20:19 +0200
From: arnd@arndb.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [RFC 6/7] cramfs: read directory entries from dcache
Content-Disposition: inline; filename=0006-cramfs-read-directory-entries-from-dcache.patch
X-Provags-ID: V01U2FsdGVkX1/cmQ+tHNWRyqGAo52swqxG8U+YPqvot3yYcMC
 HWWXex+68HR0ApQ99MfYkxlbDQewTrAlwXCFE2FEYK7my90bYU
 KMb3mkkRybBGY9xTlATuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we create new files in a mounted cramfs, they
only appear in the dcache, so we need to have a combined
dcache_readdir plus cramfs_readdir to get all of them.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cramfs/inode.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 0d3ac80..e7d2b47 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -324,6 +324,46 @@ static int cramfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
+/* Relationship between i_mode and the DT_xxx types */
+static inline unsigned char dt_type(struct inode *inode)
+{
+	return (inode->i_mode >> 12) & 15;
+}
+
+static int cramfs_readdir_cache(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct dentry *dentry = filp->f_path.dentry;
+	struct dentry *cursor = filp->private_data;
+	struct list_head *p, *q = &cursor->d_u.d_child;
+
+	/* taken from dcache_readdir */
+	spin_lock(&dcache_lock);
+	if (filp->f_pos == 2)
+		list_move(q, &dentry->d_subdirs);
+
+	for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
+		struct dentry *next;
+		next = list_entry(p, struct dentry, d_u.d_child);
+		if (d_unhashed(next) || !next->d_inode ||
+		    next->d_inode->i_private) // FIXME: renames are broken
+			continue;
+
+		spin_unlock(&dcache_lock);
+		if (filldir(dirent, next->d_name.name,
+			    next->d_name.len, filp->f_pos,
+			    next->d_inode->i_ino,
+			    dt_type(next->d_inode)) < 0)
+			return 0;
+		spin_lock(&dcache_lock);
+		/* next is still alive */
+		list_move(q, p);
+		p = q;
+		filp->f_pos++;
+	}
+	spin_unlock(&dcache_lock);
+	return 0;
+}
+
 /*
  * Read a cramfs directory entry.
  */
@@ -407,8 +447,59 @@ static int cramfs_readdir_ondisk(struct dentry *dentry, void *dirent,
 
 static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	return cramfs_readdir_ondisk(filp->f_dentry, dirent,
+	loff_t offset = filp->f_pos;
+	struct dentry *dentry = filp->f_path.dentry;
+	int ret;
+
+	ret = 0;
+	if (offset < dentry->d_inode->i_size)
+		ret = cramfs_readdir_ondisk(dentry, dirent,
 					filldir, &filp->f_pos);
+	if (ret)
+		return ret;
+
+	return cramfs_readdir_cache(filp, dirent, filldir);
+}
+
+static loff_t cramfs_dir_lseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+		case 1:
+			offset += file->f_pos;
+		case 0:
+			if (offset >= 0)
+				break;
+		default:
+			mutex_unlock(&inode->i_mutex);
+			return -EINVAL;
+	}
+
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		if (file->f_pos >= inode->i_size) {
+			struct list_head *p;
+			struct dentry *cursor = file->private_data;
+			loff_t n = file->f_pos - inode->i_size;
+
+			spin_lock(&dcache_lock);
+			list_del(&cursor->d_u.d_child);
+			p = file->f_path.dentry->d_subdirs.next;
+			while (n && p != &file->f_path.dentry->d_subdirs) {
+				struct dentry *next;
+				next = list_entry(p, struct dentry, d_u.d_child);
+				if (!d_unhashed(next) && next->d_inode &&
+				    !next->d_inode->i_private) // FIXME: renames are broken)
+					n--;
+				p = p->next;
+			}
+			list_add_tail(&cursor->d_u.d_child, p);
+			spin_unlock(&dcache_lock);
+		}
+	}
+	mutex_unlock(&inode->i_mutex);
+	return offset;
 }
 
 int cramfs_unlink(struct inode *dir, struct dentry *dentry)
@@ -588,9 +679,12 @@ static const struct address_space_operations cramfs_aops = {
  * A directory can only readdir
  */
 static const struct file_operations cramfs_directory_operations = {
-	.llseek		= generic_file_llseek,
-	.read		= generic_read_dir,
+	.open		= dcache_dir_open,
+	.release	= dcache_dir_close,
+	.llseek		= cramfs_dir_lseek,
+	.fsync		= simple_sync_file,
 	.readdir	= cramfs_readdir,
+	.read		= generic_read_dir,
 };
 
 static const struct inode_operations cramfs_dir_inode_operations = {
-- 
1.5.4.3

-- 

