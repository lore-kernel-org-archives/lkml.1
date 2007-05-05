Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbXEEXM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbXEEXM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXEEXMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:12:50 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55133 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbXEEXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:12:31 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/4] fs: Introduce path_component_lookup
Date: Sat,  5 May 2007 19:09:31 -0400
Message-Id: <11784065742752-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
In-Reply-To: <11784065741163-git-send-email-jsipek@cs.sunysb.edu>
References: <11784065741163-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c            |   26 ++++++++++++++++++++++++++
 include/linux/namei.h |    2 ++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3449e0a..b547af0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1175,6 +1175,31 @@ int fastcall path_lookup(const char *name, unsigned int flags,
 	return do_path_lookup(AT_FDCWD, name, flags, nd);
 }
 
+int path_component_lookup(struct dentry *dentry, struct vfsmount *mnt,
+			  const char *name, unsigned int flags, 
+			  struct nameidata *nd)
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
+	if (likely(retval == 0)) {
+		if (unlikely(!audit_dummy_context() && nd && nd->dentry && 
+				nd->dentry->d_inode))
+			audit_inode(name, nd->dentry->d_inode);
+	}
+
+	return retval;
+
+}
+
 static int __path_lookup_intent_open(int dfd, const char *name,
 		unsigned int lookup_flags, struct nameidata *nd,
 		int open_flags, int create_mode)
@@ -2799,6 +2824,7 @@ EXPORT_SYMBOL(__page_symlink);
 EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
+EXPORT_SYMBOL(path_component_lookup);
 EXPORT_SYMBOL(path_release);
 EXPORT_SYMBOL(path_walk);
 EXPORT_SYMBOL(permission);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 0ab27ba..2247397 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -70,6 +70,8 @@ extern int FASTCALL(__user_walk_fd(int dfd, const char __user *, unsigned, struc
 #define user_path_walk_link(name,nd) \
 	__user_walk_fd(AT_FDCWD, name, 0, nd)
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
+extern int path_component_lookup(struct dentry *, struct vfsmount *,
+				 const char *, unsigned int, struct nameidata *);
 extern int FASTCALL(path_walk(const char *, struct nameidata *));
 extern int FASTCALL(link_path_walk(const char *, struct nameidata *));
 extern void path_release(struct nameidata *);
-- 
1.5.0.3.1043.g4342

