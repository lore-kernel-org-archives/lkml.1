Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZFXVKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZFXVKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZFXVJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:09:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52230 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZFXVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:09:51 -0400
Date: Wed, 24 Jun 2009 22:09:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build failure latest git. (acl related)
Message-ID: <20090624210952.GX8633@ZenIV.linux.org.uk>
References: <20090624200941.GA30531@phenom2.trippelsdorf.de> <20090624202852.GA31192@phenom2.trippelsdorf.de> <20090624203330.GS8633@ZenIV.linux.org.uk> <20090624203815.GT8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906241340410.3154@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906241340410.3154@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

In addition to missing ifdef, there'd been a dumb braino in handling
of "we want no acls for this inode", esp. for shmem.  Plus a race
fix for jfs_check_acl() - on JFS the ACL stuff used to have no locks at all
and had been racy as hell; previous patches took most of that mess out, this
one should finish that mess for good.

Overall:

Al Viro (2):
      Get "no acls for this inode" right, fix shmem breakage
      another race fix in jfs_check_acl()

Markus Trippelsdorf (1):
      inline functions left without protection of ifdef (acl)

 fs/btrfs/inode.c          |    6 ++----
 fs/jffs2/acl.c            |    3 +--
 fs/jfs/acl.c              |   13 +++++++------
 include/linux/posix_acl.h |   10 ++++++++++
 mm/shmem.c                |    5 +----
 5 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78ad38d..dbe1aab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2122,10 +2122,8 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	 * any xattrs or acls
 	 */
 	maybe_acls = acls_after_inode_item(leaf, path->slots[0], inode->i_ino);
-	if (!maybe_acls) {
-		inode->i_acl = NULL;
-		inode->i_default_acl = NULL;
-	}
+	if (!maybe_acls)
+		cache_no_acl(inode);
 
 	BTRFS_I(inode)->block_group = btrfs_find_block_group(root, 0,
 						alloc_group_block, 0);
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index edd2ad6..8fcb623 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -284,8 +284,7 @@ int jffs2_init_acl_pre(struct inode *dir_i, struct inode *inode, int *i_mode)
 	struct posix_acl *acl, *clone;
 	int rc;
 
-	inode->i_default_acl = NULL;
-	inode->i_acl = NULL;
+	cache_no_acl(inode);
 
 	if (S_ISLNK(*i_mode))
 		return 0;	/* Symlink always has no-ACL */
diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index f272bf0..91fa3ad 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -118,15 +118,16 @@ out:
 
 static int jfs_check_acl(struct inode *inode, int mask)
 {
-	if (inode->i_acl == ACL_NOT_CACHED) {
-		struct posix_acl *acl = jfs_get_acl(inode, ACL_TYPE_ACCESS);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
+	struct posix_acl *acl = jfs_get_acl(inode, ACL_TYPE_ACCESS);
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl) {
+		int error = posix_acl_permission(inode, acl, mask);
 		posix_acl_release(acl);
+		return error;
 	}
 
-	if (inode->i_acl)
-		return posix_acl_permission(inode, inode->i_acl, mask);
 	return -EAGAIN;
 }
 
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 0cdba01..065a365 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -83,6 +83,7 @@ extern int posix_acl_chmod_masq(struct posix_acl *, mode_t);
 extern struct posix_acl *get_posix_acl(struct inode *, int);
 extern int set_posix_acl(struct inode *, int, struct posix_acl *);
 
+#ifdef CONFIG_FS_POSIX_ACL
 static inline struct posix_acl *get_cached_acl(struct inode *inode, int type)
 {
 	struct posix_acl **p, *acl;
@@ -146,5 +147,14 @@ static inline void forget_cached_acl(struct inode *inode, int type)
 	if (old != ACL_NOT_CACHED)
 		posix_acl_release(old);
 }
+#endif
+
+static inline void cache_no_acl(struct inode *inode)
+{
+#ifdef CONFIG_FS_POSIX_ACL
+	inode->i_acl = NULL;
+	inode->i_default_acl = NULL;
+#endif
+}
 
 #endif  /* __LINUX_POSIX_ACL_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index 5f2019f..d713239 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1558,6 +1558,7 @@ static struct inode *shmem_get_inode(struct super_block *sb, int mode,
 		spin_lock_init(&info->lock);
 		info->flags = flags & VM_NORESERVE;
 		INIT_LIST_HEAD(&info->swaplist);
+		cache_no_acl(inode);
 
 		switch (mode & S_IFMT) {
 		default:
@@ -2379,10 +2380,6 @@ static struct inode *shmem_alloc_inode(struct super_block *sb)
 	p = (struct shmem_inode_info *)kmem_cache_alloc(shmem_inode_cachep, GFP_KERNEL);
 	if (!p)
 		return NULL;
-#ifdef CONFIG_TMPFS_POSIX_ACL
-	p->vfs_inode.i_acl = NULL;
-	p->vfs_inode.i_default_acl = NULL;
-#endif
 	return &p->vfs_inode;
 }
 
