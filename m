Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZIZSfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZIZSfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZIZSfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:35:08 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:57131 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbZIZSfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:35:02 -0400
From: Anders Larsen <al@alarsen.net>
Subject: [PATCH] qnx4fs: add missing KERN_xxx to printk() calls
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: trivial@kernel.org
Date: Sat, 26 Sep 2009 20:15:09 +0200
Message-ID: <20090926181508.5461.7686.stgit@oscar.alarsen.net>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed printk calls to consistently specify a KERN_xxx level.

Signed-off-by: Anders Larsen <al@alarsen.net>
---

 fs/qnx4/bitmap.c |    2 +-
 fs/qnx4/dir.c    |    6 +++---
 fs/qnx4/inode.c  |   26 +++++++++++++-------------
 fs/qnx4/namei.c  |    6 +++---
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/qnx4/bitmap.c b/fs/qnx4/bitmap.c
index 0afba06..32f5d13 100644
--- a/fs/qnx4/bitmap.c
+++ b/fs/qnx4/bitmap.c
@@ -67,7 +67,7 @@ unsigned long qnx4_count_free_blocks(struct super_block *sb)
 
 	while (total < size) {
 		if ((bh = sb_bread(sb, start + offset)) == NULL) {
-			printk("qnx4: I/O error in counting free blocks\n");
+			printk(KERN_ERR "qnx4: I/O error in counting free blocks\n");
 			break;
 		}
 		count_bits(bh->b_data, size - total, &total_free);
diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index 86cc39c..6f30c3d 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -26,8 +26,8 @@ static int qnx4_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	int ix, ino;
 	int size;
 
-	QNX4DEBUG(("qnx4_readdir:i_size = %ld\n", (long) inode->i_size));
-	QNX4DEBUG(("filp->f_pos         = %ld\n", (long) filp->f_pos));
+	QNX4DEBUG((KERN_INFO "qnx4_readdir:i_size = %ld\n", (long) inode->i_size));
+	QNX4DEBUG((KERN_INFO "filp->f_pos         = %ld\n", (long) filp->f_pos));
 
 	lock_kernel();
 
@@ -50,7 +50,7 @@ static int qnx4_readdir(struct file *filp, void *dirent, filldir_t filldir)
 					size = QNX4_NAME_MAX;
 
 				if ( ( de->di_status & (QNX4_FILE_USED|QNX4_FILE_LINK) ) != 0 ) {
-					QNX4DEBUG(("qnx4_readdir:%.*s\n", size, de->di_fname));
+					QNX4DEBUG((KERN_INFO "qnx4_readdir:%.*s\n", size, de->di_fname));
 					if ( ( de->di_status & QNX4_FILE_LINK ) == 0 )
 						ino = blknum * QNX4_INODES_PER_BLOCK + ix - 1;
 					else {
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index d2cd179..c406fe1 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -107,7 +107,7 @@ static int qnx4_get_block( struct inode *inode, sector_t iblock, struct buffer_h
 {
 	unsigned long phys;
 
-	QNX4DEBUG(("qnx4: qnx4_get_block inode=[%ld] iblock=[%ld]\n",inode->i_ino,iblock));
+	QNX4DEBUG((KERN_INFO "qnx4: qnx4_get_block inode=[%ld] iblock=[%ld]\n",inode->i_ino,iblock));
 
 	phys = qnx4_block_map( inode, iblock );
 	if ( phys ) {
@@ -142,12 +142,12 @@ unsigned long qnx4_block_map( struct inode *inode, long iblock )
 				// read next xtnt block.
 				bh = sb_bread(inode->i_sb, i_xblk - 1);
 				if ( !bh ) {
-					QNX4DEBUG(("qnx4: I/O error reading xtnt block [%ld])\n", i_xblk - 1));
+					QNX4DEBUG((KERN_ERR "qnx4: I/O error reading xtnt block [%ld])\n", i_xblk - 1));
 					return -EIO;
 				}
 				xblk = (struct qnx4_xblk*)bh->b_data;
 				if ( memcmp( xblk->xblk_signature, "IamXblk", 7 ) ) {
-					QNX4DEBUG(("qnx4: block at %ld is not a valid xtnt\n", qnx4_inode->i_xblk));
+					QNX4DEBUG((KERN_ERR "qnx4: block at %ld is not a valid xtnt\n", qnx4_inode->i_xblk));
 					return -EIO;
 				}
 			}
@@ -168,7 +168,7 @@ unsigned long qnx4_block_map( struct inode *inode, long iblock )
 			brelse( bh );
 	}
 
-	QNX4DEBUG(("qnx4: mapping block %ld of inode %ld = %ld\n",iblock,inode->i_ino,block));
+	QNX4DEBUG((KERN_INFO "qnx4: mapping block %ld of inode %ld = %ld\n",iblock,inode->i_ino,block));
 	return block;
 }
 
@@ -209,7 +209,7 @@ static const char *qnx4_checkroot(struct super_block *sb)
 	if (*(qnx4_sb(sb)->sb->RootDir.di_fname) != '/') {
 		return "no qnx4 filesystem (no root dir).";
 	} else {
-		QNX4DEBUG(("QNX4 filesystem found on dev %s.\n", sb->s_id));
+		QNX4DEBUG((KERN_NOTICE "QNX4 filesystem found on dev %s.\n", sb->s_id));
 		rd = le32_to_cpu(qnx4_sb(sb)->sb->RootDir.di_first_xtnt.xtnt_blk) - 1;
 		rl = le32_to_cpu(qnx4_sb(sb)->sb->RootDir.di_first_xtnt.xtnt_size);
 		for (j = 0; j < rl; j++) {
@@ -220,7 +220,7 @@ static const char *qnx4_checkroot(struct super_block *sb)
 			for (i = 0; i < QNX4_INODES_PER_BLOCK; i++) {
 				rootdir = (struct qnx4_inode_entry *) (bh->b_data + i * QNX4_DIR_ENTRY_SIZE);
 				if (rootdir->di_fname != NULL) {
-					QNX4DEBUG(("Rootdir entry found : [%s]\n", rootdir->di_fname));
+					QNX4DEBUG((KERN_INFO "rootdir entry found : [%s]\n", rootdir->di_fname));
 					if (!strncmp(rootdir->di_fname, QNX4_BMNAME, sizeof QNX4_BMNAME)) {
 						found = 1;
 						qnx4_sb(sb)->BitMap = kmalloc( sizeof( struct qnx4_inode_entry ), GFP_KERNEL );
@@ -265,12 +265,12 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 	   if we don't belong here... */
 	bh = sb_bread(s, 1);
 	if (!bh) {
-		printk("qnx4: unable to read the superblock\n");
+		printk(KERN_ERR "qnx4: unable to read the superblock\n");
 		goto outnobh;
 	}
 	if ( le32_to_cpup((__le32*) bh->b_data) != QNX4_SUPER_MAGIC ) {
 		if (!silent)
-			printk("qnx4: wrong fsid in superblock.\n");
+			printk(KERN_ERR "qnx4: wrong fsid in superblock.\n");
 		goto out;
 	}
 	s->s_op = &qnx4_sops;
@@ -284,14 +284,14 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 	errmsg = qnx4_checkroot(s);
 	if (errmsg != NULL) {
  		if (!silent)
- 			printk("qnx4: %s\n", errmsg);
+ 			printk(KERN_ERR "qnx4: %s\n", errmsg);
 		goto out;
 	}
 
  	/* does root not have inode number QNX4_ROOT_INO ?? */
 	root = qnx4_iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);
 	if (IS_ERR(root)) {
- 		printk("qnx4: get inode failed\n");
+ 		printk(KERN_ERR "qnx4: get inode failed\n");
 		ret = PTR_ERR(root);
  		goto out;
  	}
@@ -374,7 +374,7 @@ struct inode *qnx4_iget(struct super_block *sb, unsigned long ino)
 	qnx4_inode = qnx4_raw_inode(inode);
 	inode->i_mode = 0;
 
-	QNX4DEBUG(("Reading inode : [%d]\n", ino));
+	QNX4DEBUG((KERN_INFO "reading inode : [%d]\n", ino));
 	if (!ino) {
 		printk(KERN_ERR "qnx4: bad inode number on dev %s: %lu is "
 				"out of range\n",
@@ -385,7 +385,7 @@ struct inode *qnx4_iget(struct super_block *sb, unsigned long ino)
 	block = ino / QNX4_INODES_PER_BLOCK;
 
 	if (!(bh = sb_bread(sb, block))) {
-		printk("qnx4: major problem: unable to read inode from dev "
+		printk(KERN_ERR "qnx4: major problem: unable to read inode from dev "
 		       "%s\n", sb->s_id);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
@@ -499,7 +499,7 @@ static int __init init_qnx4_fs(void)
 		return err;
 	}
 
-	printk("QNX4 filesystem 0.2.3 registered.\n");
+	printk(KERN_INFO "QNX4 filesystem 0.2.3 registered.\n");
 	return 0;
 }
 
diff --git a/fs/qnx4/namei.c b/fs/qnx4/namei.c
index ae1e7ed..58703eb 100644
--- a/fs/qnx4/namei.c
+++ b/fs/qnx4/namei.c
@@ -30,7 +30,7 @@ static int qnx4_match(int len, const char *name,
 	int namelen, thislen;
 
 	if (bh == NULL) {
-		printk("qnx4: matching unassigned buffer !\n");
+		printk(KERN_WARNING "qnx4: matching unassigned buffer !\n");
 		return 0;
 	}
 	de = (struct qnx4_inode_entry *) (bh->b_data + *offset);
@@ -66,7 +66,7 @@ static struct buffer_head *qnx4_find_entry(int len, struct inode *dir,
 
 	*res_dir = NULL;
 	if (!dir->i_sb) {
-		printk("qnx4: no superblock on dir.\n");
+		printk(KERN_WARNING "qnx4: no superblock on dir.\n");
 		return NULL;
 	}
 	bh = NULL;
@@ -124,7 +124,7 @@ struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	foundinode = qnx4_iget(dir->i_sb, ino);
 	if (IS_ERR(foundinode)) {
 		unlock_kernel();
-		QNX4DEBUG(("qnx4: lookup->iget -> error %ld\n",
+		QNX4DEBUG((KERN_ERR "qnx4: lookup->iget -> error %ld\n",
 			   PTR_ERR(foundinode)));
 		return ERR_CAST(foundinode);
 	}

