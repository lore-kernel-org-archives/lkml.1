Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbXJDQI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbXJDQI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759780AbXJDP7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:59:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759990AbXJDP7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:59:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/32] IGET: Stop OPENPROMFS from using iget() and
	read_inode() [try #2]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 04 Oct 2007 16:58:30 +0100
Message-ID: <20071004155830.2814.3158.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the OPENPROMFS filesystem from using iget() and read_inode().  Replace
openpromfs_read_inode() with openpromfs_iget(), and call that instead of
iget().  openpromfs_iget() then uses iget_locked() directly and returns a
proper error code instead of an inode in the event of an error.

openpromfs_fill_super() returns any error incurred when getting the root inode
instead of ENOMEM (not that it currently incurs any other error).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/openpromfs/inode.c |   45 ++++++++++++++++++++++++++++++---------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index dd86be2..9c6017b 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -38,6 +38,8 @@ struct op_inode_info {
 	union op_inode_data	u;
 };
 
+static struct inode *openprom_iget(struct super_block *sb, ino_t ino);
+
 static inline struct op_inode_info *OP_I(struct inode *inode)
 {
 	return container_of(inode, struct op_inode_info, vfs_inode);
@@ -226,10 +228,10 @@ static struct dentry *openpromfs_lookup(struct inode *dir, struct dentry *dentry
 	return ERR_PTR(-ENOENT);
 
 found:
-	inode = iget(dir->i_sb, ino);
+	inode = openprom_iget(dir->i_sb, ino);
 	mutex_unlock(&op_mutex);
-	if (!inode)
-		return ERR_PTR(-EINVAL);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 	ent_oi = OP_I(inode);
 	ent_oi->type = ent_type;
 	ent_oi->u = ent_data;
@@ -348,14 +350,23 @@ static void openprom_destroy_inode(struct inode *inode)
 	kmem_cache_free(op_inode_cachep, OP_I(inode));
 }
 
-static void openprom_read_inode(struct inode * inode)
+static struct inode *openprom_iget(struct super_block *sb, ino_t ino)
 {
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-	if (inode->i_ino == OPENPROM_ROOT_INO) {
-		inode->i_op = &openprom_inode_operations;
-		inode->i_fop = &openprom_operations;
-		inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+		if (inode->i_ino == OPENPROM_ROOT_INO) {
+			inode->i_op = &openprom_inode_operations;
+			inode->i_fop = &openprom_operations;
+			inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
+		}
+		unlock_new_inode(inode);
 	}
+	return inode;
 }
 
 static int openprom_remount(struct super_block *sb, int *flags, char *data)
@@ -367,7 +378,6 @@ static int openprom_remount(struct super_block *sb, int *flags, char *data)
 static const struct super_operations openprom_sops = {
 	.alloc_inode	= openprom_alloc_inode,
 	.destroy_inode	= openprom_destroy_inode,
-	.read_inode	= openprom_read_inode,
 	.statfs		= simple_statfs,
 	.remount_fs	= openprom_remount,
 };
@@ -376,6 +386,7 @@ static int openprom_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct inode *root_inode;
 	struct op_inode_info *oi;
+	int ret;
 
 	s->s_flags |= MS_NOATIME;
 	s->s_blocksize = 1024;
@@ -383,9 +394,11 @@ static int openprom_fill_super(struct super_block *s, void *data, int silent)
 	s->s_magic = OPENPROM_SUPER_MAGIC;
 	s->s_op = &openprom_sops;
 	s->s_time_gran = 1;
-	root_inode = iget(s, OPENPROM_ROOT_INO);
-	if (!root_inode)
+	root_inode = openprom_iget(s, OPENPROM_ROOT_INO);
+	if (IS_ERR(root_inode)) {
+		ret = PTR_ERR(root_inode);
 		goto out_no_root;
+	}
 
 	oi = OP_I(root_inode);
 	oi->type = op_inode_node;
@@ -393,13 +406,15 @@ static int openprom_fill_super(struct super_block *s, void *data, int silent)
 
 	s->s_root = d_alloc_root(root_inode);
 	if (!s->s_root)
-		goto out_no_root;
+		goto out_no_root_dentry;
 	return 0;
 
+out_no_root_dentry:
+	iput(root_inode);
+	ret = -ENOMEM;
 out_no_root:
 	printk("openprom_fill_super: get root inode failed\n");
-	iput(root_inode);
-	return -ENOMEM;
+	return ret;
 }
 
 static int openprom_get_sb(struct file_system_type *fs_type,

