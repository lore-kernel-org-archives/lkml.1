Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbXJLJMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbXJLJMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbXJLJH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:07:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbXJLJHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:07:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/31] IGET: Stop BEFS from using iget() and read_inode() [try
	#4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:07:49 +0100
Message-ID: <20071012090749.3442.28666.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
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
Acked-by: Will Dyson <will_dyson@pobox.com>
---

 fs/befs/linuxvfs.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index a451418..fd9866e 100644
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
+		return ERR_CAST(inode);
 
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

