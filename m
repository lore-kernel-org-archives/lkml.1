Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbXEXCBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbXEXCBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762500AbXEXB7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:59:44 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42616 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762434AbXEXB7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:59:39 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/5] fs: Introduce vfs_path_lookup
Date: Wed, 23 May 2007 21:54:34 -0400
Message-Id: <11799716782310-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799716781687-git-send-email-jsipek@cs.sunysb.edu>
References: <11799716781687-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c            |   32 ++++++++++++++++++++++++++++++++
 include/linux/namei.h |    2 ++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 580162b..a30efbc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1172,6 +1172,37 @@ int fastcall path_lookup(const char *name, unsigned int flags,
 	return do_path_lookup(AT_FDCWD, name, flags, nd);
 }
 
+/**
+ * vfs_path_lookup - lookup a file path relative to a dentry-vfsmount pair
+ * @dentry:  pointer to dentry of the base directory
+ * @mnt: pointer to vfs mount of the base directory
+ * @name: pointer to file name
+ * @flags: lookup flags
+ * @nd: pointer to nameidata
+ */
+int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
+		    const char *name, unsigned int flags, 
+		    struct nameidata *nd)
+{
+	int retval;
+
+	/* same as do_path_lookup */
+	nd->last_type = LAST_ROOT;
+	nd->flags = flags;
+	nd->depth = 0;
+
+	nd->mnt = mntget(mnt);
+	nd->dentry = dget(dentry);
+
+	retval = path_walk(name, nd);
+	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
+				nd->dentry->d_inode))
+		audit_inode(name, nd->dentry->d_inode);
+
+	return retval;
+
+}
+
 static int __path_lookup_intent_open(int dfd, const char *name,
 		unsigned int lookup_flags, struct nameidata *nd,
 		int open_flags, int create_mode)
@@ -2775,6 +2806,7 @@ EXPORT_SYMBOL(__page_symlink);
 EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
+EXPORT_SYMBOL(vfs_path_lookup);
 EXPORT_SYMBOL(path_release);
 EXPORT_SYMBOL(path_walk);
 EXPORT_SYMBOL(permission);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 0ab27ba..4718788 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -70,6 +70,8 @@ extern int FASTCALL(__user_walk_fd(int dfd, const char __user *, unsigned, struc
 #define user_path_walk_link(name,nd) \
 	__user_walk_fd(AT_FDCWD, name, 0, nd)
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
+extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
+			   const char *, unsigned int, struct nameidata *);
 extern int FASTCALL(path_walk(const char *, struct nameidata *));
 extern int FASTCALL(link_path_walk(const char *, struct nameidata *));
 extern void path_release(struct nameidata *);
-- 
1.5.2.rc1.165.gaf9b

