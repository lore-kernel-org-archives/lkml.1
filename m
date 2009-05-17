Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbZEQFFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbZEQFFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 01:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZEQFEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 01:04:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:54462 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZEQFEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 01:04:33 -0400
Message-Id: <20090517050332.303142159@suse.com>
User-Agent: quilt/0.47-14.9
Date: Sun, 17 May 2009 01:02:03 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 3/4] reiserfs: fixup perms when xattrs are disabled
References: <20090517050200.786752018@suse.com>
Content-Disposition: inline; filename=patches.fixes/reiserfs-xattrs-disabled-perms
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch CONFIG_REISERFS_FS_XATTR protection from reiserfs_permission.

 This is needed to avoid warnings during file deletions and chowns with
 xattrs disabled.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c            |   37 ++++++++++++++++++++-----------------
 include/linux/reiserfs_xattr.h |    4 +---
 2 files changed, 21 insertions(+), 20 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -869,23 +869,6 @@ static int reiserfs_check_acl(struct ino
 	return error;
 }
 
-int reiserfs_permission(struct inode *inode, int mask)
-{
-	/*
-	 * We don't do permission checks on the internal objects.
-	 * Permissions are determined by the "owning" object.
-	 */
-	if (IS_PRIVATE(inode))
-		return 0;
-	/*
-	 * Stat data v1 doesn't support ACLs.
-	 */
-	if (get_inode_sd_version(inode) == STAT_DATA_V1)
-		return generic_permission(inode, mask, NULL);
-	else
-		return generic_permission(inode, mask, reiserfs_check_acl);
-}
-
 static int create_privroot(struct dentry *dentry)
 {
 	int err;
@@ -949,6 +932,26 @@ static int xattr_mount_check(struct supe
 	return 0;
 }
 
+int reiserfs_permission(struct inode *inode, int mask)
+{
+	/*
+	 * We don't do permission checks on the internal objects.
+	 * Permissions are determined by the "owning" object.
+	 */
+	if (IS_PRIVATE(inode))
+		return 0;
+
+#ifdef CONFIG_REISERFS_FS_XATTR
+	/*
+	 * Stat data v1 doesn't support ACLs.
+	 */
+	if (get_inode_sd_version(inode) != STAT_DATA_V1)
+		return generic_permission(inode, mask, reiserfs_check_acl);
+	else
+#endif
+		return generic_permission(inode, mask, NULL);
+}
+
 /* This will catch lookups from the fs root to .reiserfs_priv */
 static int
 xattr_lookup_poison(struct dentry *dentry, struct qstr *q1, struct qstr *name)
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -41,6 +41,7 @@ int reiserfs_xattr_init(struct super_blo
 int reiserfs_lookup_privroot(struct super_block *sb);
 int reiserfs_delete_xattrs(struct inode *inode);
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs);
+int reiserfs_permission(struct inode *inode, int mask);
 
 #ifdef CONFIG_REISERFS_FS_XATTR
 #define has_xattr_dir(inode) (REISERFS_I(inode)->i_flags & i_has_xattr_dir)
@@ -50,7 +51,6 @@ int reiserfs_setxattr(struct dentry *den
 		      const void *value, size_t size, int flags);
 ssize_t reiserfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 int reiserfs_removexattr(struct dentry *dentry, const char *name);
-int reiserfs_permission(struct inode *inode, int mask);
 
 int reiserfs_xattr_get(struct inode *, const char *, void *, size_t);
 int reiserfs_xattr_set(struct inode *, const char *, const void *, size_t, int);
@@ -117,8 +117,6 @@ static inline void reiserfs_init_xattr_r
 #define reiserfs_listxattr NULL
 #define reiserfs_removexattr NULL
 
-#define reiserfs_permission NULL
-
 static inline void reiserfs_init_xattr_rwsem(struct inode *inode)
 {
 }

