Return-Path: <linux-kernel-owner+w=401wt.eu-S1763006AbXJYQpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006AbXJYQpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbXJYQgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:36:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbXJYQgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:36:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/31] IGET: Stop UFS from using iget() and read_inode() [try
	#5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:36:16 +0100
Message-ID: <20071025163616.5057.14585.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the UFS filesystem from using iget() and read_inode().  Replace
ufs_read_inode() with ufs_iget(), and call that instead of iget().
ufs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

ufs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ufs/inode.c |   34 ++++++++++++++++++++--------------
 fs/ufs/namei.c |    6 +++---
 fs/ufs/super.c |   14 +++++++++-----
 fs/ufs/ufs.h   |    2 +-
 4 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 4320782..73539ef 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -714,26 +714,30 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 	return 0;
 }
 
-void ufs_read_inode(struct inode * inode)
+struct inode *ufs_iget (struct super_block *sb, unsigned long ino)
 {
-	struct ufs_inode_info *ufsi = UFS_I(inode);
-	struct super_block * sb;
-	struct ufs_sb_private_info * uspi;
+	struct ufs_inode_info *ufsi;
+	struct ufs_sb_private_info * uspi = UFS_SB(sb)->s_uspi;
 	struct buffer_head * bh;
+	struct inode *inode;
 	int err;
 
-	UFSD("ENTER, ino %lu\n", inode->i_ino);
-
-	sb = inode->i_sb;
-	uspi = UFS_SB(sb)->s_uspi;
+	UFSD("ENTER, ino %lu\n", ino);
 
-	if (inode->i_ino < UFS_ROOTINO ||
-	    inode->i_ino > (uspi->s_ncg * uspi->s_ipg)) {
+	if (ino < UFS_ROOTINO || ino > (uspi->s_ncg * uspi->s_ipg)) {
 		ufs_warning(sb, "ufs_read_inode", "bad inode number (%lu)\n",
-			    inode->i_ino);
-		goto bad_inode;
+			    ino);
+		return ERR_PTR(-EIO);
 	}
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ufsi = UFS_I(inode);
+
 	bh = sb_bread(sb, uspi->s_sbbase + ufs_inotofsba(inode->i_ino));
 	if (!bh) {
 		ufs_warning(sb, "ufs_read_inode", "unable to read inode %lu\n",
@@ -765,10 +769,12 @@ void ufs_read_inode(struct inode * inode)
 	brelse(bh);
 
 	UFSD("EXIT\n");
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static void ufs1_update_inode(struct inode *inode, struct ufs_inode *ufs_inode)
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index d8bfbee..747a4de 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -57,10 +57,10 @@ static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, stru
 	lock_kernel();
 	ino = ufs_inode_by_name(dir, dentry);
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
-		if (!inode) {
+		inode = ufs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 584cf12..e58045f 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -633,6 +633,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned block_size, super_block_size;
 	unsigned flags;
 	unsigned super_block_offset;
+	int ret = -EINVAL;
 
 	uspi = NULL;
 	ubh = NULL;
@@ -1066,12 +1067,16 @@ magic_found:
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
 
-	inode = iget(sb, UFS_ROOTINO);
-	if (!inode || is_bad_inode(inode))
+	inode = ufs_iget(sb, UFS_ROOTINO);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
 		goto failed;
+	}
 	sb->s_root = d_alloc_root(inode);
-	if (!sb->s_root)
+	if (!sb->s_root) {
+		ret = -ENOMEM;
 		goto dalloc_failed;
+	}
 
 	ufs_setup_cstotal(sb);
 	/*
@@ -1093,7 +1098,7 @@ failed:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
-	return -EINVAL;
+	return ret;
 
 failed_nomem:
 	UFSD("EXIT (NOMEM)\n");
@@ -1327,7 +1332,6 @@ static ssize_t ufs_quota_write(struct super_block *, int, const char *, size_t,
 static const struct super_operations ufs_super_ops = {
 	.alloc_inode	= ufs_alloc_inode,
 	.destroy_inode	= ufs_destroy_inode,
-	.read_inode	= ufs_read_inode,
 	.write_inode	= ufs_write_inode,
 	.delete_inode	= ufs_delete_inode,
 	.put_super	= ufs_put_super,
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index 7faa4cd..fcb9231 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -106,7 +106,7 @@ extern void ufs_free_inode (struct inode *inode);
 extern struct inode * ufs_new_inode (struct inode *, int);
 
 /* inode.c */
-extern void ufs_read_inode (struct inode *);
+extern struct inode *ufs_iget(struct super_block *, unsigned long);
 extern void ufs_put_inode (struct inode *);
 extern int ufs_write_inode (struct inode *, int);
 extern int ufs_sync_inode (struct inode *);

