Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbXJLJLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbXJLJLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbXJLJHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:07:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760042AbXJLJHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:07:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/31] IGET: Stop AFFS from using iget() and read_inode() [try
	#4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:07:39 +0100
Message-ID: <20071012090739.3442.63415.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the AFFS filesystem from using iget() and read_inode().  Replace
affs_read_inode() with affs_iget(), and call that instead of iget().
affs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

affs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/affs/affs.h     |    2 +-
 fs/affs/amigaffs.c |    6 ++++--
 fs/affs/inode.c    |   20 +++++++++++++-------
 fs/affs/namei.c    |   10 ++++------
 fs/affs/super.c    |   12 +++++++++---
 5 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 232c694..0bce4ff 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -174,7 +174,7 @@ extern void			 affs_put_inode(struct inode *inode);
 extern void			 affs_drop_inode(struct inode *inode);
 extern void			 affs_delete_inode(struct inode *inode);
 extern void			 affs_clear_inode(struct inode *inode);
-extern void			 affs_read_inode(struct inode *inode);
+extern struct inode		*affs_iget(struct super_block *sb, unsigned long ino);
 extern int			 affs_write_inode(struct inode *inode, int);
 extern int			 affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s32 type);
 
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index f4de4b9..8055730 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -170,9 +170,11 @@ affs_remove_link(struct dentry *dentry)
 		if (!link_bh)
 			goto done;
 
-		dir = iget(sb, be32_to_cpu(AFFS_TAIL(sb, link_bh)->parent));
-		if (!dir)
+		dir = affs_iget(sb, be32_to_cpu(AFFS_TAIL(sb, link_bh)->parent));
+		if (IS_ERR(dir)) {
+			retval = PTR_ERR(dir);
 			goto done;
+		}
 
 		affs_lock_dir(dir);
 		affs_fix_dcache(dentry, link_ino);
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 4609a6c..edea76c 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -15,20 +15,25 @@
 extern const struct inode_operations affs_symlink_inode_operations;
 extern struct timezone sys_tz;
 
-void
-affs_read_inode(struct inode *inode)
+struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 {
-	struct super_block	*sb = inode->i_sb;
 	struct affs_sb_info	*sbi = AFFS_SB(sb);
 	struct buffer_head	*bh;
 	struct affs_head	*head;
 	struct affs_tail	*tail;
+	struct inode		*inode;
 	u32			 block;
 	u32			 size;
 	u32			 prot;
 	u16			 id;
 
-	pr_debug("AFFS: read_inode(%lu)\n",inode->i_ino);
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	pr_debug("AFFS: affs_iget(%lu)\n",inode->i_ino);
 
 	block = inode->i_ino;
 	bh = affs_bread(sb, block);
@@ -154,12 +159,13 @@ affs_read_inode(struct inode *inode)
 			 sys_tz.tz_minuteswest * 60;
 	inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_atime.tv_nsec = 0;
 	affs_brelse(bh);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
 	affs_brelse(bh);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 int
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index b407e9e..2218f1e 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -208,9 +208,8 @@ affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	affs_lock_dir(dir);
 	bh = affs_find_entry(dir, dentry);
 	affs_unlock_dir(dir);
-	if (IS_ERR(bh)) {
+	if (IS_ERR(bh))
 		return ERR_CAST(bh);
-	}
 	if (bh) {
 		u32 ino = bh->b_blocknr;
 
@@ -223,10 +222,9 @@ affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 			ino = be32_to_cpu(AFFS_TAIL(sb, bh)->original);
 		}
 		affs_brelse(bh);
-		inode = iget(sb, ino);
-		if (!inode) {
-			return ERR_PTR(-EACCES);
-		}
+		inode = affs_iget(sb, ino);
+		if (IS_ERR(inode))
+			return ERR_PTR(PTR_ERR(inode));
 	}
 	dentry->d_op = AFFS_SB(sb)->s_flags & SF_INTL ? &affs_intl_dentry_operations : &affs_dentry_operations;
 	d_add(dentry, inode);
diff --git a/fs/affs/super.c b/fs/affs/super.c
index c80191a..f005050 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -113,7 +113,6 @@ static void destroy_inodecache(void)
 static const struct super_operations affs_sops = {
 	.alloc_inode	= affs_alloc_inode,
 	.destroy_inode	= affs_destroy_inode,
-	.read_inode	= affs_read_inode,
 	.write_inode	= affs_write_inode,
 	.put_inode	= affs_put_inode,
 	.drop_inode	= affs_drop_inode,
@@ -271,6 +270,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long		 mount_flags;
 	int			 tmp_flags;	/* fix remount prototype... */
 	u8			 sig[4];
+	int			 ret = -EINVAL;
 
 	pr_debug("AFFS: read_super(%s)\n",data ? (const char *)data : "no options");
 
@@ -444,7 +444,12 @@ got_root:
 
 	/* set up enough so that it can read an inode */
 
-	root_inode = iget(sb, root_block);
+	root_inode = affs_iget(sb, root_block);
+	if (IS_ERR(root_inode)) {
+		ret = PTR_ERR(root_inode);
+		goto out_error_noinode;
+	}
+
 	sb->s_root = d_alloc_root(root_inode);
 	if (!sb->s_root) {
 		printk(KERN_ERR "AFFS: Get root inode failed\n");
@@ -461,12 +466,13 @@ got_root:
 out_error:
 	if (root_inode)
 		iput(root_inode);
+out_error_noinode:
 	kfree(sbi->s_bitmap);
 	affs_brelse(root_bh);
 	kfree(sbi->s_prefix);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static int

