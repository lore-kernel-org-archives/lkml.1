Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbXJLJMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbXJLJMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbXJLJIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:08:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbXJLJH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:07:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/31] IGET: Stop BFS from using iget() and read_inode() [try
	#4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:07:55 +0100
Message-ID: <20071012090755.3442.83472.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the BFS filesystem from using iget() and read_inode().  Replace
bfs_read_inode() with bfs_iget(), and call that instead of iget().
bfs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

bfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/bfs/bfs.h   |    2 ++
 fs/bfs/dir.c   |    6 +++---
 fs/bfs/inode.c |   32 ++++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 130f6c6..5cf50d4 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -46,6 +46,8 @@ static inline struct bfs_inode_info *BFS_I(struct inode *inode)
 #define printf(format, args...) \
 	printk(KERN_ERR "BFS-fs: %s(): " format, __FUNCTION__, ## args)
 
+/* inode.c */
+extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
 
 /* file.c */
 extern const struct inode_operations bfs_file_inops;
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 097f149..03c8bdb 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -141,10 +141,10 @@ static struct dentry * bfs_lookup(struct inode * dir, struct dentry * dentry, st
 	if (bh) {
 		unsigned long ino = (unsigned long)le16_to_cpu(de->ino);
 		brelse(bh);
-		inode = iget(dir->i_sb, ino);
-		if (!inode) {
+		inode = bfs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index f346eb1..76798c9 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -32,25 +32,29 @@ MODULE_LICENSE("GPL");
 
 void dump_imap(const char *prefix, struct super_block * s);
 
-static void bfs_read_inode(struct inode * inode)
+struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
-	unsigned long ino = inode->i_ino;
 	struct bfs_inode * di;
 	struct buffer_head * bh;
+	struct inode *inode;
 	int block, off;
 
+	inode = iget_locked(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
 	if (ino < BFS_ROOT_INO || ino > BFS_SB(inode->i_sb)->si_lasti) {
 		printf("Bad inode number %s:%08lx\n", inode->i_sb->s_id, ino);
-		make_bad_inode(inode);
-		return;
+		goto error;
 	}
 
 	block = (ino - BFS_ROOT_INO)/BFS_INODES_PER_BLOCK + 1;
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
 		printf("Unable to read inode %s:%08lx\n", inode->i_sb->s_id, ino);
-		make_bad_inode(inode);
-		return;
+		goto error;
 	}
 
 	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
@@ -85,6 +89,12 @@ static void bfs_read_inode(struct inode * inode)
 	BFS_I(inode)->i_dsk_ino = le16_to_cpu(di->i_ino); /* can be 0 so we store a copy */
 
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
+
+error:
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static int bfs_write_inode(struct inode * inode, int unused)
@@ -271,7 +281,6 @@ static void destroy_inodecache(void)
 static const struct super_operations bfs_sops = {
 	.alloc_inode	= bfs_alloc_inode,
 	.destroy_inode	= bfs_destroy_inode,
-	.read_inode	= bfs_read_inode,
 	.write_inode	= bfs_write_inode,
 	.delete_inode	= bfs_delete_inode,
 	.put_super	= bfs_put_super,
@@ -306,6 +315,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	struct inode * inode;
 	unsigned i, imap_len;
 	struct bfs_sb_info * info;
+	long ret = -EINVAL;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -340,14 +350,16 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 		set_bit(i, info->si_imap);
 
 	s->s_op = &bfs_sops;
-	inode = iget(s, BFS_ROOT_INO);
-	if (!inode) {
+	inode = bfs_iget(s, BFS_ROOT_INO);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
 		kfree(info->si_imap);
 		goto out;
 	}
 	s->s_root = d_alloc_root(inode);
 	if (!s->s_root) {
 		iput(inode);
+		ret = -ENOMEM;
 		kfree(info->si_imap);
 		goto out;
 	}
@@ -402,7 +414,7 @@ out:
 	brelse(bh);
 	kfree(info);
 	s->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static int bfs_get_sb(struct file_system_type *fs_type,

