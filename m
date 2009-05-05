Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZEETlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZEETlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbZEETkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:40:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434AbZEETkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:40:08 -0400
Message-Id: <20090505193206.711742058@suse.com>
User-Agent: quilt/0.47-14.9
Date: Tue, 05 May 2009 15:30:15 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: ReiserFS Devel <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Al Viron <viro@ZenIV.linux.org.uk>
Subject: [patch 1/3] reiserfs: fixup xattr_root caching
References: <20090505193014.926371851@suse.com>
Content-Disposition: inline; filename=reiserfs-fixup-caching
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The xattr_root caching was broken from my previous patch set. It wouldn't
 cause corruption, but could cause decreased performance due to allocating
 a larger chunk of the journal (~ 27 blocks) than it would actually use.

 This patch loads the xattr root dentry at xattr initialization and creates
 it on-demand. Since we're using the cached dentry, there's no point
 in keeping lookup_or_create_dir around, so that's removed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c            |   73 +++++++++++++++++++++++++----------------
 include/linux/reiserfs_fs_sb.h |    2 -
 include/linux/reiserfs_xattr.h |    2 -
 3 files changed, 48 insertions(+), 29 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -113,36 +113,28 @@ static int xattr_rmdir(struct inode *dir
 
 #define xattr_may_create(flags)	(!flags || flags & XATTR_CREATE)
 
-/* Returns and possibly creates the xattr dir. */
-static struct dentry *lookup_or_create_dir(struct dentry *parent,
-					    const char *name, int flags)
+static struct dentry *open_xa_root(struct super_block *sb, int flags)
 {
-	struct dentry *dentry;
-	BUG_ON(!parent);
+	struct dentry *privroot = REISERFS_SB(sb)->priv_root;
+	struct dentry *xaroot;
+	if (!privroot->d_inode)
+		return ERR_PTR(-ENODATA);
 
-	mutex_lock_nested(&parent->d_inode->i_mutex, I_MUTEX_XATTR);
-	dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry) && !dentry->d_inode) {
-		int err = -ENODATA;
+	mutex_lock_nested(&privroot->d_inode->i_mutex, I_MUTEX_XATTR);
 
+	xaroot = dget(REISERFS_SB(sb)->xattr_root);
+	if (!xaroot->d_inode) {
+		int err = -ENODATA;
 		if (xattr_may_create(flags))
-			err = xattr_mkdir(parent->d_inode, dentry, 0700);
-
+			err = xattr_mkdir(privroot->d_inode, xaroot, 0700);
 		if (err) {
-			dput(dentry);
-			dentry = ERR_PTR(err);
+			dput(xaroot);
+			xaroot = ERR_PTR(err);
 		}
 	}
-	mutex_unlock(&parent->d_inode->i_mutex);
-	return dentry;
-}
 
-static struct dentry *open_xa_root(struct super_block *sb, int flags)
-{
-	struct dentry *privroot = REISERFS_SB(sb)->priv_root;
-	if (!privroot)
-		return ERR_PTR(-ENODATA);
-	return lookup_or_create_dir(privroot, XAROOT_NAME, flags);
+	mutex_unlock(&privroot->d_inode->i_mutex);
+	return xaroot;
 }
 
 static struct dentry *open_xa_dir(const struct inode *inode, int flags)
@@ -158,10 +150,22 @@ static struct dentry *open_xa_dir(const
 		 le32_to_cpu(INODE_PKEY(inode)->k_objectid),
 		 inode->i_generation);
 
-	xadir = lookup_or_create_dir(xaroot, namebuf, flags);
+	mutex_lock_nested(&xaroot->d_inode->i_mutex, I_MUTEX_XATTR);
+
+	xadir = lookup_one_len(namebuf, xaroot, strlen(namebuf));
+	if (!IS_ERR(xadir) && !xadir->d_inode) {
+		int err = -ENODATA;
+		if (xattr_may_create(flags))
+			err = xattr_mkdir(xaroot->d_inode, xadir, 0700);
+		if (err) {
+			dput(xadir);
+			xadir = ERR_PTR(err);
+		}
+	}
+
+	mutex_unlock(&xaroot->d_inode->i_mutex);
 	dput(xaroot);
 	return xadir;
-
 }
 
 /* The following are side effects of other operations that aren't explicitly
@@ -986,19 +990,33 @@ int reiserfs_lookup_privroot(struct supe
 int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 {
 	int err = 0;
+	struct dentry *privroot = REISERFS_SB(s)->priv_root;
 
 #ifdef CONFIG_REISERFS_FS_XATTR
 	err = xattr_mount_check(s);
 	if (err)
 		goto error;

-	if (!REISERFS_SB(s)->priv_root->d_inode && !(mount_flags & MS_RDONLY)) {
+	if (!privroot->d_inode && !(mount_flags & MS_RDONLY)) {
 		mutex_lock(&s->s_root->d_inode->i_mutex);
 		err = create_privroot(REISERFS_SB(s)->priv_root);
 		mutex_unlock(&s->s_root->d_inode->i_mutex);
 	}
-	if (!err)
+
+	if (privroot->d_inode) {
 		s->s_xattr = reiserfs_xattr_handlers;
+		mutex_lock(&privroot->d_inode->i_mutex);
+		if (!REISERFS_SB(s)->xattr_root) {
+			struct dentry *dentry;
+			dentry = lookup_one_len(XAROOT_NAME, privroot,
+						strlen(XAROOT_NAME));
+			if (!IS_ERR(dentry))
+				REISERFS_SB(s)->xattr_root = dentry;
+			else
+				err = PTR_ERR(dentry);
+		}
+		mutex_unlock(&privroot->d_inode->i_mutex);
+	}
 
 error:
 	if (err) {
@@ -1008,11 +1026,12 @@ error:
 #endif
 
 	/* The super_block MS_POSIXACL must mirror the (no)acl mount option. */
-	s->s_flags = s->s_flags & ~MS_POSIXACL;
 #ifdef CONFIG_REISERFS_FS_POSIX_ACL
 	if (reiserfs_posixacl(s))
 		s->s_flags |= MS_POSIXACL;
+	else
 #endif
+		s->s_flags &= ~MS_POSIXACL;
 
 	return err;
 }
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -402,7 +402,7 @@ struct reiserfs_sb_info {
 	int reserved_blocks;	/* amount of blocks reserved for further allocations */
 	spinlock_t bitmap_lock;	/* this lock on now only used to protect reserved_blocks variable */
 	struct dentry *priv_root;	/* root of /.reiserfs_priv */
-	struct dentry *xattr_root;	/* root of /.reiserfs_priv/.xa */
+	struct dentry *xattr_root;	/* root of /.reiserfs_priv/xattrs */
 	int j_errno;
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -98,7 +98,7 @@ static inline size_t reiserfs_xattr_jcre
 
 	if ((REISERFS_I(inode)->i_flags & i_has_xattr_dir) == 0) {
 		nblocks += JOURNAL_BLOCKS_PER_OBJECT(inode->i_sb);
-		if (REISERFS_SB(inode->i_sb)->xattr_root == NULL)
+		if (!REISERFS_SB(inode->i_sb)->xattr_root->d_inode)
 			nblocks += JOURNAL_BLOCKS_PER_OBJECT(inode->i_sb);
 	}
 


