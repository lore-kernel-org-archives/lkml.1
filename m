Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXJJVwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXJJVwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757661AbXJJVp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:45:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbXJJVpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:45:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/31] IGET: Stop QNX4 from using iget() and read_inode() [try
	#3]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 10 Oct 2007 22:45:10 +0100
Message-ID: <20071010214510.17535.8288.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the QNX4 filesystem from using iget() and read_inode().  Replace
qnx4_read_inode() with qnx4_iget(), and call that instead of iget().
qnx4_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

qnx4_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/qnx4/inode.c         |   45 ++++++++++++++++++++++++++++++---------------
 fs/qnx4/namei.c         |    8 +++++---
 include/linux/qnx4_fs.h |    1 +
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 1bc8d87..3eba8fe 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -125,7 +125,6 @@ static int qnx4_write_inode(struct inode *inode, int unused)
 static void qnx4_put_super(struct super_block *sb);
 static struct inode *qnx4_alloc_inode(struct super_block *sb);
 static void qnx4_destroy_inode(struct inode *inode);
-static void qnx4_read_inode(struct inode *);
 static int qnx4_remount(struct super_block *sb, int *flags, char *data);
 static int qnx4_statfs(struct dentry *, struct kstatfs *);
 
@@ -133,7 +132,6 @@ static const struct super_operations qnx4_sops =
 {
 	.alloc_inode	= qnx4_alloc_inode,
 	.destroy_inode	= qnx4_destroy_inode,
-	.read_inode	= qnx4_read_inode,
 	.put_super	= qnx4_put_super,
 	.statfs		= qnx4_statfs,
 	.remount_fs	= qnx4_remount,
@@ -357,6 +355,7 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 	struct inode *root;
 	const char *errmsg;
 	struct qnx4_sb_info *qs;
+	int ret = -EINVAL;
 
 	qs = kzalloc(sizeof(struct qnx4_sb_info), GFP_KERNEL);
 	if (!qs)
@@ -396,12 +395,14 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 	}
 
  	/* does root not have inode number QNX4_ROOT_INO ?? */
- 	root = iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);
- 	if (!root) {
+ 	root = qnx4_iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);
+ 	if (IS_ERR(root)) {
  		printk("qnx4: get inode failed\n");
+		ret = PTR_ERR(root);
  		goto out;
  	}
 
+	ret = -ENOMEM;
  	s->s_root = d_alloc_root(root);
  	if (s->s_root == NULL)
  		goto outi;
@@ -417,7 +418,7 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
       outnobh:
 	kfree(qs);
 	s->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static void qnx4_put_super(struct super_block *sb)
@@ -457,29 +458,37 @@ static const struct address_space_operations qnx4_aops = {
 	.bmap		= qnx4_bmap
 };
 
-static void qnx4_read_inode(struct inode *inode)
+struct inode *qnx4_iget(struct super_block *sb, unsigned long ino)
 {
 	struct buffer_head *bh;
 	struct qnx4_inode_entry *raw_inode;
-	int block, ino;
-	struct super_block *sb = inode->i_sb;
-	struct qnx4_inode_entry *qnx4_inode = qnx4_raw_inode(inode);
+	int block;
+	struct qnx4_inode_entry *qnx4_inode;
+	struct inode *inode;
 
-	ino = inode->i_ino;
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	qnx4_inode = qnx4_raw_inode(inode);
 	inode->i_mode = 0;
 
 	QNX4DEBUG(("Reading inode : [%d]\n", ino));
 	if (!ino) {
-		printk("qnx4: bad inode number on dev %s: %d is out of range\n",
+		printk("qnx4: bad inode number on dev %s: %lu is out of range\n",
 		       sb->s_id, ino);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	block = ino / QNX4_INODES_PER_BLOCK;
 
 	if (!(bh = sb_bread(sb, block))) {
 		printk("qnx4: major problem: unable to read inode from dev "
 		       "%s\n", sb->s_id);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	raw_inode = ((struct qnx4_inode_entry *) bh->b_data) +
 	    (ino % QNX4_INODES_PER_BLOCK);
@@ -510,9 +519,15 @@ static void qnx4_read_inode(struct inode *inode)
 		inode->i_op = &page_symlink_inode_operations;
 		inode->i_mapping->a_ops = &qnx4_aops;
 		qnx4_i(inode)->mmu_private = inode->i_size;
-	} else
-		printk("qnx4: bad inode %d on dev %s\n",ino,sb->s_id);
+	} else {
+		printk("qnx4: bad inode %lu on dev %s\n",ino,sb->s_id);
+		iget_failed(inode);
+		brelse(bh);
+		return ERR_PTR(-EIO);
+	}
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
 }
 
 static struct kmem_cache *qnx4_inode_cachep;
diff --git a/fs/qnx4/namei.c b/fs/qnx4/namei.c
index 733cdf0..775eed3 100644
--- a/fs/qnx4/namei.c
+++ b/fs/qnx4/namei.c
@@ -128,10 +128,12 @@ struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	}
 	brelse(bh);
 
-	if ((foundinode = iget(dir->i_sb, ino)) == NULL) {
+	foundinode = qnx4_iget(dir->i_sb, ino);
+	if (IS_ERR(foundinode)) {
 		unlock_kernel();
-		QNX4DEBUG(("qnx4: lookup->iget -> NULL\n"));
-		return ERR_PTR(-EACCES);
+		QNX4DEBUG(("qnx4: lookup->iget -> error %ld\n",
+			   PTR_ERR(foundinode)));
+		return ERR_CAST(foundinode);
 	}
 out:
 	unlock_kernel();
diff --git a/include/linux/qnx4_fs.h b/include/linux/qnx4_fs.h
index 19bc9b8..34a196e 100644
--- a/include/linux/qnx4_fs.h
+++ b/include/linux/qnx4_fs.h
@@ -110,6 +110,7 @@ struct qnx4_inode_info {
 	struct inode vfs_inode;
 };
 
+extern struct inode *qnx4_iget(struct super_block *, unsigned long);
 extern struct dentry *qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd);
 extern unsigned long qnx4_count_free_blocks(struct super_block *sb);
 extern unsigned long qnx4_block_map(struct inode *inode, long iblock);

