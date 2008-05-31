Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYEaPiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYEaPiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYEaPiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:64268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbYEaPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:09 -0400
Message-Id: <20080531153510.692084580@arndb.de>
References: <20080531152013.031903990@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 17:20:15 +0200
From: arnd@arndb.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [RFC 2/7] cramfs: create unique inode numbers
Content-Disposition: inline; filename=0002-cramfs-create-unique-inode-numbers.patch
X-Provags-ID: V01U2FsdGVkX1+40GiSbNw1eQIVSea8nBgaKAfJeBxNROiGaAo
 +TcFToiHmk5OY2psvsc/cX9Ha7D/97oagZEo34YlDQrPBheZv4
 7eN8ISXYL8xvgs4SIy6rQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the inode number in cramfs to be based on
the location of the dentry instead of the file, in order
to make inodes unique.
This lets us change and unlink files in a later patch
without changing all other files that contain the same
data, and it fixes a user-visible bug with 'cp -a'
trying to hardlink empty directories when copying from
a cramfs source.

A slight disadvantage is that identical files no longer
share a common page cache, so the data has to be read
from disk for each file individually.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cramfs/inode.c |  100 +++++++++++++++++++++++------------------------------
 1 files changed, 43 insertions(+), 57 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 08f08f9..8aa04d7 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -33,80 +33,60 @@ static const struct address_space_operations cramfs_aops;
 
 static DEFINE_MUTEX(read_mutex);
 
+#define OFFSET(x)	((unsigned long)(x)->i_private)
 
-/* These two macros may change in future, to provide better st_ino
-   semantics. */
-#define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
-#define OFFSET(x)	((x)->i_ino)
-
-
-static int cramfs_iget5_test(struct inode *inode, void *opaque)
+static struct inode *get_cramfs_inode(struct super_block *sb,
+				mode_t mode, dev_t dev)
 {
-	struct cramfs_inode *cramfs_inode = opaque;
-
-	if (inode->i_ino != CRAMINO(cramfs_inode))
-		return 0; /* does not match */
-
-	if (inode->i_ino != 1)
-		return 1;
+	struct inode *inode;
 
-	/* all empty directories, char, block, pipe, and sock, share inode #1 */
-
-	if ((inode->i_mode != cramfs_inode->mode) ||
-	    (inode->i_gid != cramfs_inode->gid) ||
-	    (inode->i_uid != cramfs_inode->uid))
-		return 0; /* does not match */
-
-	if ((S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) &&
-	    (inode->i_rdev != old_decode_dev(cramfs_inode->size)))
-		return 0; /* does not match */
-
-	return 1; /* matches */
-}
+	inode = new_inode(sb);
+	if (!inode)
+		return NULL;
 
-static int cramfs_iget5_set(struct inode *inode, void *opaque)
-{
-	static struct timespec zerotime;
-	struct cramfs_inode *cramfs_inode = opaque;
-	inode->i_mode = cramfs_inode->mode;
-	inode->i_uid = cramfs_inode->uid;
-	inode->i_size = cramfs_inode->size;
-	inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
-	inode->i_gid = cramfs_inode->gid;
-	/* Struct copy intentional */
-	inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
-	inode->i_ino = CRAMINO(cramfs_inode);
+	inode->i_mode = mode;
 	/* inode->i_nlink is left 1 - arguably wrong for directories,
 	   but it's the best we can do without reading the directory
            contents.  1 yields the right result in GNU find, even
 	   without -noleaf option. */
-	if (S_ISREG(inode->i_mode)) {
+	if (S_ISREG(mode)) {
 		inode->i_fop = &generic_ro_fops;
 		inode->i_data.a_ops = &cramfs_aops;
-	} else if (S_ISDIR(inode->i_mode)) {
+	} else if (S_ISDIR(mode)) {
 		inode->i_op = &cramfs_dir_inode_operations;
 		inode->i_fop = &cramfs_directory_operations;
-	} else if (S_ISLNK(inode->i_mode)) {
+	} else if (S_ISLNK(mode)) {
 		inode->i_op = &page_symlink_inode_operations;
 		inode->i_data.a_ops = &cramfs_aops;
 	} else {
 		inode->i_size = 0;
 		inode->i_blocks = 0;
-		init_special_inode(inode, inode->i_mode,
-			old_decode_dev(cramfs_inode->size));
+		init_special_inode(inode, mode, dev);
 	}
-	return 0;
+	return inode;
 }
 
-static struct inode *get_cramfs_inode(struct super_block *sb,
-				struct cramfs_inode * cramfs_inode)
+static struct inode *get_cramfs_inode_ondisk(struct super_block *sb,
+				struct cramfs_inode * cramfs_inode,
+				ino_t ino, off_t offset)
 {
-	struct inode *inode = iget5_locked(sb, CRAMINO(cramfs_inode),
-					    cramfs_iget5_test, cramfs_iget5_set,
-					    cramfs_inode);
-	if (inode && (inode->i_state & I_NEW)) {
-		unlock_new_inode(inode);
-	}
+	static struct timespec zerotime;
+	struct inode *inode;
+
+	inode = get_cramfs_inode(sb, cramfs_inode->mode,
+				old_decode_dev(cramfs_inode->size));
+	if (!inode)
+		return NULL;
+
+	inode->i_ino = ino;
+	inode->i_uid = cramfs_inode->uid;
+	inode->i_size = cramfs_inode->size;
+	inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
+	inode->i_gid = cramfs_inode->gid;
+	/* Struct copy intentional */
+	inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
+	inode->i_private = (void *)offset;
+
 	return inode;
 }
 
@@ -234,6 +214,7 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 	int i;
 	struct cramfs_super super;
 	unsigned long root_offset;
+	unsigned long root_ino;
 	struct cramfs_sb_info *sbi;
 	struct inode *root;
 
@@ -252,6 +233,7 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 	/* Read the first block and get the superblock from it */
 	memcpy(&super, cramfs_read(sb, 0, sizeof(super)), sizeof(super));
 	mutex_unlock(&read_mutex);
+	root_ino = offsetof(struct cramfs_super, root);
 
 	/* Do sanity checks on the superblock */
 	if (super.magic != CRAMFS_MAGIC) {
@@ -266,6 +248,7 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		mutex_lock(&read_mutex);
 		memcpy(&super, cramfs_read(sb, 512, sizeof(super)), sizeof(super));
 		mutex_unlock(&read_mutex);
+		root_ino += 512;
 		if (super.magic != CRAMFS_MAGIC) {
 			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
 				printk(KERN_ERR "cramfs: wrong endianess\n");
@@ -310,7 +293,7 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Set it all up.. */
 	sb->s_op = &cramfs_ops;
-	root = get_cramfs_inode(sb, &super.root);
+	root = get_cramfs_inode_ondisk(sb, &super.root, root_ino, root_offset);
 	if (!root)
 		goto out;
 	sb->s_root = d_alloc_root(root);
@@ -383,7 +366,7 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		 */
 		namelen = de->namelen << 2;
 		memcpy(buf, name, namelen);
-		ino = CRAMINO(de);
+		ino = OFFSET(inode) + offset;
 		mode = de->mode;
 		mutex_unlock(&read_mutex);
 		nextoffset = offset + sizeof(*de) + namelen;
@@ -422,8 +405,10 @@ static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, s
 		struct cramfs_inode *de;
 		char *name;
 		int namelen, retval;
+		ino_t ino;
 
-		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
+		ino = OFFSET(dir) + offset;
+		de = cramfs_read(dir->i_sb, ino, sizeof(*de)+CRAMFS_MAXPATHLEN);
 		name = (char *)(de+1);
 
 		/* Try to take advantage of sorted directories */
@@ -454,7 +439,8 @@ static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, s
 		if (!retval) {
 			struct cramfs_inode entry = *de;
 			mutex_unlock(&read_mutex);
-			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry));
+			d_add(dentry, get_cramfs_inode_ondisk(dir->i_sb,
+					&entry, ino, entry.offset << 2));
 			return NULL;
 		}
 		/* else (retval < 0) */
-- 
1.5.4.3

-- 

