Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYADNEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYADNEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYADNEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:04:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYADNEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:04:46 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH [combined]] Stop the ISOFS filesystem from using read_inode().
	Make isofs_read_inode()
To: viro@ZenIV.linux.org.uk, hidave.darkstar@gmail.com,
       akpm@linux-foundation.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 04 Jan 2008 13:04:34 +0000
Message-ID: <20080104130434.25760.95071.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return an error code, and make isofs_iget() pass it on.  Furthermore
isofs_iget() no longer ever returns NULL for situations where it used to, so
all the places that call it must use IS_ERR() to check its return value.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/isofs/export.c |   14 ++++++------
 fs/isofs/inode.c  |   64 +++++++++++++++++++++++++++++++++++------------------
 fs/isofs/namei.c  |    4 ++-
 fs/isofs/rock.c   |    4 ++-
 4 files changed, 54 insertions(+), 32 deletions(-)


diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index 29f9753..bb21913 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -26,11 +26,9 @@ isofs_export_iget(struct super_block *sb,
 	if (block == 0)
 		return ERR_PTR(-ESTALE);
 	inode = isofs_iget(sb, block, offset);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode)
-	    || (generation && inode->i_generation != generation))
-	{
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -110,8 +108,10 @@ static struct dentry *isofs_export_get_parent(struct dentry *child)
 	parent_inode = isofs_iget(child_inode->i_sb,
 				  parent_block,
 				  parent_offset);
-	if (parent_inode == NULL) {
-		rv = ERR_PTR(-EACCES);
+	if (IS_ERR(parent_inode)) {
+		rv = ERR_CAST(parent_inode);
+		if (rv != ERR_PTR(-ENOMEM))
+			rv = ERR_PTR(-EACCES);
 		goto out;
 	}
 
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 09e3d30..0f5ed8c 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -54,7 +54,7 @@ static void isofs_put_super(struct super_block *sb)
 	return;
 }
 
-static void isofs_read_inode(struct inode *);
+static int isofs_read_inode(struct inode *);
 static int isofs_statfs (struct dentry *, struct kstatfs *);
 
 static struct kmem_cache *isofs_inode_cachep;
@@ -107,7 +107,6 @@ static int isofs_remount(struct super_block *sb, int *flags, char *data)
 static const struct super_operations isofs_sops = {
 	.alloc_inode	= isofs_alloc_inode,
 	.destroy_inode	= isofs_destroy_inode,
-	.read_inode	= isofs_read_inode,
 	.put_super	= isofs_put_super,
 	.statfs		= isofs_statfs,
 	.remount_fs	= isofs_remount,
@@ -552,7 +551,7 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	int joliet_level = 0;
 	int iso_blknum, block;
 	int orig_zonesize;
-	int table;
+	int table, error = -EINVAL;
 	unsigned int vol_desc_start;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
@@ -810,6 +809,8 @@ root_found:
 	 * we then decide whether to use the Joliet descriptor.
 	 */
 	inode = isofs_iget(s, sbi->s_firstdatazone, 0);
+	if (IS_ERR(inode))
+		goto out_no_root;
 
 	/*
 	 * If this disk has both Rock Ridge and Joliet on it, then we
@@ -829,6 +830,8 @@ root_found:
 				"ISOFS: changing to secondary root\n");
 			iput(inode);
 			inode = isofs_iget(s, sbi->s_firstdatazone, 0);
+			if (IS_ERR(inode))
+				goto out_no_root;
 		}
 	}
 
@@ -842,8 +845,6 @@ root_found:
 	sbi->s_joliet_level = joliet_level;
 
 	/* check the root inode */
-	if (!inode)
-		goto out_no_root;
 	if (!inode->i_op)
 		goto out_bad_root;
 
@@ -876,11 +877,14 @@ root_found:
 	 */
 out_bad_root:
 	printk(KERN_WARNING "%s: root inode not initialized\n", __func__);
-	goto out_iput;
-out_no_root:
-	printk(KERN_WARNING "%s: get root inode failed\n", __func__);
 out_iput:
 	iput(inode);
+	goto out_no_inode;
+out_no_root:
+	error = PTR_ERR(inode);
+	if (error != -ENOMEM)
+		printk(KERN_WARNING "%s: get root inode failed\n", __func__);
+out_no_inode:
 #ifdef CONFIG_JOLIET
 	if (sbi->s_nls_iocharset)
 		unload_nls(sbi->s_nls_iocharset);
@@ -908,7 +912,7 @@ out_freesbi:
 	kfree(opt.iocharset);
 	kfree(sbi);
 	s->s_fs_info = NULL;
-	return -EINVAL;
+	return error;
 }
 
 static int isofs_statfs (struct dentry *dentry, struct kstatfs *buf)
@@ -930,7 +934,7 @@ static int isofs_statfs (struct dentry *dentry, struct kstatfs *buf)
 /*
  * Get a set of blocks; filling in buffer_heads if already allocated
  * or getblk() if they are not.  Returns the number of blocks inserted
- * (0 == error.)
+ * (-ve == error.)
  */
 int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 		     struct buffer_head **bh, unsigned long nblocks)
@@ -940,11 +944,12 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 	unsigned int firstext;
 	unsigned long nextblk, nextoff;
 	long iblock = (long)iblock_s;
-	int section, rv;
+	int section, rv, error;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 
 	lock_kernel();
 
+	error = -EIO;
 	rv = 0;
 	if (iblock < 0 || iblock != iblock_s) {
 		printk(KERN_DEBUG "%s: block number too large\n", __func__);
@@ -983,8 +988,10 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 
 			offset += sect_size;
 			ninode = isofs_iget(inode->i_sb, nextblk, nextoff);
-			if (!ninode)
+			if (IS_ERR(ninode)) {
+				error = PTR_ERR(ninode);
 				goto abort;
+			}
 			firstext  = ISOFS_I(ninode)->i_first_extent;
 			sect_size = ISOFS_I(ninode)->i_section_size >> ISOFS_BUFFER_BITS(ninode);
 			nextblk   = ISOFS_I(ninode)->i_next_section_block;
@@ -1017,7 +1024,7 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 
 abort:
 	unlock_kernel();
-	return rv;
+	return rv != 0 ? rv : error;
 }
 
 /*
@@ -1031,7 +1038,7 @@ static int isofs_get_block(struct inode *inode, sector_t iblock,
 		return -EROFS;
 	}
 
-	return isofs_get_blocks(inode, iblock, &bh_result, 1) ? 0 : -EIO;
+	return isofs_get_blocks(inode, iblock, &bh_result, 1);
 }
 
 static int isofs_bmap(struct inode *inode, sector_t block)
@@ -1186,7 +1193,7 @@ out_toomany:
 	goto out;
 }
 
-static void isofs_read_inode(struct inode *inode)
+static int isofs_read_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	struct isofs_sb_info *sbi = ISOFS_SB(sb);
@@ -1199,6 +1206,7 @@ static void isofs_read_inode(struct inode *inode)
 	unsigned int de_len;
 	unsigned long offset;
 	struct iso_inode_info *ei = ISOFS_I(inode);
+	int ret = -EIO;
 
 	block = ei->i_iget5_block;
 	bh = sb_bread(inode->i_sb, block);
@@ -1216,6 +1224,7 @@ static void isofs_read_inode(struct inode *inode)
 		tmpde = kmalloc(de_len, GFP_KERNEL);
 		if (tmpde == NULL) {
 			printk(KERN_INFO "%s: out of memory\n", __func__);
+			ret = -ENOMEM;
 			goto fail;
 		}
 		memcpy(tmpde, bh->b_data + offset, frag1);
@@ -1259,8 +1268,10 @@ static void isofs_read_inode(struct inode *inode)
 
 	ei->i_section_size = isonum_733(de->size);
 	if (de->flags[-high_sierra] & 0x80) {
-		if(isofs_read_level3_size(inode))
+		ret = isofs_read_level3_size(inode);
+		if (ret < 0)
 			goto fail;
+		ret = -EIO;
 	} else {
 		ei->i_next_section_block = 0;
 		ei->i_next_section_offset = 0;
@@ -1346,16 +1357,16 @@ static void isofs_read_inode(struct inode *inode)
 		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 
+	ret = 0;
 out:
 	kfree(tmpde);
 	if (bh)
 		brelse(bh);
-	return;
+	return ret;
 
 out_badread:
 	printk(KERN_WARNING "ISOFS: unable to read i-node block\n");
 fail:
-	make_bad_inode(inode);
 	goto out;
 }
 
@@ -1394,9 +1405,10 @@ struct inode *isofs_iget(struct super_block *sb,
 	unsigned long hashval;
 	struct inode *inode;
 	struct isofs_iget5_callback_data data;
+	long ret;
 
 	if (offset >= 1ul << sb->s_blocksize_bits)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	data.block = block;
 	data.offset = offset;
@@ -1406,9 +1418,17 @@ struct inode *isofs_iget(struct super_block *sb,
 	inode = iget5_locked(sb, hashval, &isofs_iget5_test,
 				&isofs_iget5_set, &data);
 
-	if (inode && (inode->i_state & I_NEW)) {
-		sb->s_op->read_inode(inode);
-		unlock_new_inode(inode);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	if (inode->i_state & I_NEW) {
+		ret = isofs_read_inode(inode);
+		if (ret < 0) {
+			iget_failed(inode);
+			inode = ERR_PTR(ret);
+		} else {
+			unlock_new_inode(inode);
+		}
 	}
 
 	return inode;
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index e2b4dad..344b247 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -179,9 +179,9 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	inode = NULL;
 	if (found) {
 		inode = isofs_iget(dir->i_sb, block, offset);
-		if (!inode) {
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index f3a1db3..6bd48f0 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -474,8 +474,10 @@ repeat:
 			    isofs_iget(inode->i_sb,
 				       ISOFS_I(inode)->i_first_extent,
 				       0);
-			if (!reloc)
+			if (IS_ERR(reloc)) {
+				ret = PTR_ERR(reloc);
 				goto out;
+			}
 			inode->i_mode = reloc->i_mode;
 			inode->i_nlink = reloc->i_nlink;
 			inode->i_uid = reloc->i_uid;

