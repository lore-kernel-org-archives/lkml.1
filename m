Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbXJANTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbXJANTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbXJANLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:11:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbXJANLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:11:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/30] IGET: Stop the SYSV filesystem from using iget() and
	read_inode()
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:11:29 +0100
Message-ID: <20071001131129.29339.61868.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the SYSV filesystem from using iget() and read_inode().  Replace
sysv_read_inode() with sysv_iget(), and call that instead of iget().
sysv_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/sysv/inode.c |   25 ++++++++++++++++---------
 fs/sysv/namei.c |    6 +++---
 fs/sysv/super.c |    4 ++--
 fs/sysv/sysv.h  |    1 +
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 7c4e5d3..9d512a8 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -169,20 +169,27 @@ void sysv_set_inode(struct inode *inode, dev_t rdev)
 		init_special_inode(inode, inode->i_mode, rdev);
 }
 
-static void sysv_read_inode(struct inode *inode)
+struct inode *sysv_iget(struct super_block *sb, unsigned int ino)
 {
-	struct super_block * sb = inode->i_sb;
 	struct sysv_sb_info * sbi = SYSV_SB(sb);
 	struct buffer_head * bh;
 	struct sysv_inode * raw_inode;
 	struct sysv_inode_info * si;
-	unsigned int block, ino = inode->i_ino;
+	struct inode *inode;
+	unsigned int block;
 
 	if (!ino || ino > sbi->s_ninodes) {
 		printk("Bad inode number on dev %s: %d is out of range\n",
-		       inode->i_sb->s_id, ino);
-		goto bad_inode;
+		       sb->s_id, ino);
+		return ERR_PTR(-EIO);
 	}
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
 		printk("Major problem: unable to read inode from dev %s\n",
@@ -214,11 +221,12 @@ static void sysv_read_inode(struct inode *inode)
 			       old_decode_dev(fs32_to_cpu(sbi, si->i_data[0])));
 	else
 		sysv_set_inode(inode, 0);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static struct buffer_head * sysv_update_inode(struct inode * inode)
@@ -328,7 +336,6 @@ static void init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
 const struct super_operations sysv_sops = {
 	.alloc_inode	= sysv_alloc_inode,
 	.destroy_inode	= sysv_destroy_inode,
-	.read_inode	= sysv_read_inode,
 	.write_inode	= sysv_write_inode,
 	.delete_inode	= sysv_delete_inode,
 	.put_super	= sysv_put_super,
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 6bd850b..599d980 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -53,9 +53,9 @@ static struct dentry *sysv_lookup(struct inode * dir, struct dentry * dentry, st
 	ino = sysv_inode_by_name(dentry);
 
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
-		if (!inode)
-			return ERR_PTR(-EACCES);
+		inode = sysv_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_PTR(PTR_ERR(inode));
 	}
 	d_add(dentry, inode);
 	return NULL;
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 6f9707a..a92d104 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -332,8 +332,8 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 	sb->s_magic = SYSV_MAGIC_BASE + sbi->s_type;
 	/* set up enough so that it can read an inode */
 	sb->s_op = &sysv_sops;
-	root_inode = iget(sb,SYSV_ROOT_INO);
-	if (!root_inode || is_bad_inode(root_inode)) {
+	root_inode = sysv_iget(sb,SYSV_ROOT_INO);
+	if (IS_ERR(root_inode)) {
 		printk("SysV FS: get root inode failed\n");
 		return 0;
 	}
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 5b4fedf..71ebdbc 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -138,6 +138,7 @@ extern unsigned long sysv_count_free_blocks(struct super_block *);
 extern void sysv_truncate(struct inode *);
 
 /* inode.c */
+extern struct inode *sysv_iget(struct super_block *, unsigned int);
 extern int sysv_write_inode(struct inode *, int);
 extern int sysv_sync_inode(struct inode *);
 extern int sysv_sync_file(struct file *, struct dentry *, int);

