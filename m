Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZEJUJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZEJUJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 16:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZEJUIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 16:08:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:53165 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbZEJUIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 16:08:49 -0400
Message-Id: <20090510200649.637922982@suse.com>
User-Agent: quilt/0.47-14.9
Date: Sun, 10 May 2009 16:05:36 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de
Subject: [patch 1/4] reiserfs: clean up ifdefs
References: <20090510200535.893737918@suse.com>
Content-Disposition: inline; filename=reiserfs-xattr-fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 With xattr cleanup even with xattrs disabled, much of the initial setup
 is still performed. Some #ifdefs are just not needed since the options
 they protect wouldn't be available anyway.

 This patch cleans those up.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c |   49 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -685,20 +685,6 @@ out:
 	return err;
 }
 
-/* Actual operations that are exported to VFS-land */
-struct xattr_handler *reiserfs_xattr_handlers[] = {
-	&reiserfs_xattr_user_handler,
-	&reiserfs_xattr_trusted_handler,
-#ifdef CONFIG_REISERFS_FS_SECURITY
-	&reiserfs_xattr_security_handler,
-#endif
-#ifdef CONFIG_REISERFS_FS_POSIX_ACL
-	&reiserfs_posix_acl_access_handler,
-	&reiserfs_posix_acl_default_handler,
-#endif
-	NULL
-};
-
 /*
  * In order to implement different sets of xattr operations for each xattr
  * prefix with the generic xattr API, a filesystem should create a
@@ -922,6 +908,28 @@ static int create_privroot(struct dentry
 	return 0;
 }
 
+#else
+int __init reiserfs_xattr_register_handlers(void) { return 0; }
+void reiserfs_xattr_unregister_handlers(void) {}
+static int create_privroot(struct dentry *dentry) { return 0; }
+#endif
+
+/* Actual operations that are exported to VFS-land */
+struct xattr_handler *reiserfs_xattr_handlers[] = {
+#ifdef CONFIG_REISERFS_FS_XATTR
+	&reiserfs_xattr_user_handler,
+	&reiserfs_xattr_trusted_handler,
+#endif
+#ifdef CONFIG_REISERFS_FS_SECURITY
+	&reiserfs_xattr_security_handler,
+#endif
+#ifdef CONFIG_REISERFS_FS_POSIX_ACL
+	&reiserfs_posix_acl_access_handler,
+	&reiserfs_posix_acl_default_handler,
+#endif
+	NULL
+};
+
 static int xattr_mount_check(struct super_block *s)
 {
 	/* We need generation numbers to ensure that the oid mapping is correct
@@ -941,11 +949,6 @@ static int xattr_mount_check(struct supe
 	return 0;
 }
 
-#else
-int __init reiserfs_xattr_register_handlers(void) { return 0; }
-void reiserfs_xattr_unregister_handlers(void) {}
-#endif
-
 /* This will catch lookups from the fs root to .reiserfs_priv */
 static int
 xattr_lookup_poison(struct dentry *dentry, struct qstr *q1, struct qstr *name)
@@ -992,7 +995,6 @@ int reiserfs_xattr_init(struct super_blo
 	int err = 0;
 	struct dentry *privroot = REISERFS_SB(s)->priv_root;
 
-#ifdef CONFIG_REISERFS_FS_XATTR
 	err = xattr_mount_check(s);
 	if (err)
 		goto error;
@@ -1023,14 +1025,11 @@ error:
 		clear_bit(REISERFS_XATTRS_USER, &(REISERFS_SB(s)->s_mount_opt));
 		clear_bit(REISERFS_POSIXACL, &(REISERFS_SB(s)->s_mount_opt));
 	}
-#endif
 
 	/* The super_block MS_POSIXACL must mirror the (no)acl mount option. */
-#ifdef CONFIG_REISERFS_FS_POSIX_ACL
 	if (reiserfs_posixacl(s))
 		s->s_flags |= MS_POSIXACL;
 	else
-#endif
 		s->s_flags &= ~MS_POSIXACL;
 
 	return err;


