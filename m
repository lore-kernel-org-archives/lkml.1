Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXJANNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXJANNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXJANKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:10:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbXJANKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:10:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/30] IGET: Stop BEFS from using iget() and read_inode()
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:09:58 +0100
Message-ID: <20071001130958.29339.31669.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the BEFS filesystem from using iget() and read_inode().  Replace
befs_read_inode() with befs_iget(), and call that instead of iget().
befs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

befs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/befs/linuxvfs.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index a451418..a460b28 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -35,7 +35,7 @@ static int befs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 static int befs_readpage(struct file *file, struct page *page);
 static sector_t befs_bmap(struct address_space *mapping, sector_t block);
 static struct dentry *befs_lookup(struct inode *, struct dentry *, struct nameidata *);
-static void befs_read_inode(struct inode *ino);
+static struct inode *befs_iget(struct super_block *, unsigned long);
 static struct inode *befs_alloc_inode(struct super_block *sb);
 static void befs_destroy_inode(struct inode *inode);
 static int befs_init_inodecache(void);
@@ -52,7 +52,6 @@ static int befs_statfs(struct dentry *, struct kstatfs *);
 static int parse_options(char *, befs_mount_options *);
 
 static const struct super_operations befs_sops = {
-	.read_inode	= befs_read_inode,	/* initialize & read inode */
 	.alloc_inode	= befs_alloc_inode,	/* allocate a new inode */
 	.destroy_inode	= befs_destroy_inode, /* deallocate an inode */
 	.put_super	= befs_put_super,	/* uninit super */
@@ -198,9 +197,9 @@ befs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 		return ERR_PTR(-ENODATA);
 	}
 
-	inode = iget(dir->i_sb, (ino_t) offset);
-	if (!inode)
-		return ERR_PTR(-EACCES);
+	inode = befs_iget(dir->i_sb, (ino_t) offset);
+	if (IS_ERR(inode))
+		return ERR_PTR(PTR_ERR(inode));
 
 	d_add(dentry, inode);
 
@@ -296,17 +295,23 @@ static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flag
 	inode_init_once(&bi->vfs_inode);
 }
 
-static void
-befs_read_inode(struct inode *inode)
+static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct buffer_head *bh = NULL;
 	befs_inode *raw_inode = NULL;
 
-	struct super_block *sb = inode->i_sb;
 	befs_sb_info *befs_sb = BEFS_SB(sb);
 	befs_inode_info *befs_ino = NULL;
+	struct inode *inode;
+	long ret = -EIO;
 
-	befs_debug(sb, "---> befs_read_inode() " "inode = %lu", inode->i_ino);
+	befs_debug(sb, "---> befs_read_inode() " "inode = %lu", ino);
+
+	inode = iget_locked(sb, ino);
+	if (IS_ERR(inode))
+		return inode;
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	befs_ino = BEFS_I(inode);
 
@@ -402,15 +407,16 @@ befs_read_inode(struct inode *inode)
 
 	brelse(bh);
 	befs_debug(sb, "<--- befs_read_inode()");
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
       unacquire_bh:
 	brelse(bh);
 
       unacquire_none:
-	make_bad_inode(inode);
+	iget_failed(inode);
 	befs_debug(sb, "<--- befs_read_inode() - Bad inode");
-	return;
+	return ERR_PTR(ret);
 }
 
 /* Initialize the inode cache. Called at fs setup.
@@ -752,6 +758,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 	befs_sb_info *befs_sb;
 	befs_super_block *disk_sb;
 	struct inode *root;
+	long ret = -EINVAL;
 
 	const unsigned long sb_block = 0;
 	const off_t x86_sb_off = 512;
@@ -833,7 +840,11 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 	/* Set real blocksize of fs */
 	sb_set_blocksize(sb, (ulong) befs_sb->block_size);
 	sb->s_op = (struct super_operations *) &befs_sops;
-	root = iget(sb, iaddr2blockno(sb, &(befs_sb->root_dir)));
+	root = befs_iget(sb, iaddr2blockno(sb, &(befs_sb->root_dir)));
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto unacquire_priv_sbp;
+	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		iput(root);
@@ -868,7 +879,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
       unacquire_none:
 	sb->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static int

