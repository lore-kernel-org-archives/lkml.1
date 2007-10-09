Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbXJISIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbXJISIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXJISHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:07:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:35891 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbXJISHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:07:42 -0400
Message-Id: <20071009180513.757397456@X40.localnet>
References: <20071009180503.075306583@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Tue, 09 Oct 2007 20:05:11 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [patch 08/10] Introduce path_get()
Content-Disposition: inline; filename=vfs/nameidata-path-5.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces the symmetric function to path_put() for getting a reference
to the dentry and vfsmount of a struct path in the right order.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c            |   17 +++++++++++++++--
 include/linux/namei.h |    6 ------
 include/linux/path.h  |    1 +
 3 files changed, 16 insertions(+), 8 deletions(-)

Index: b/fs/namei.c
===================================================================
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -363,6 +363,19 @@ int deny_write_access(struct file * file
 }
 
 /**
+ * path_get - get a reference to a path
+ * @path: path to get the reference to
+ *
+ * Given a path increment the reference count to the dentry and the vfsmount.
+ */
+void path_get(struct path *path)
+{
+	mntget(path->mnt);
+	dget(path->dentry);
+}
+EXPORT_SYMBOL(path_get);
+
+/**
  * path_put - put a reference to a path
  * @path: path to put the reference to
  *
@@ -1161,8 +1174,8 @@ static int fastcall do_path_lookup(int d
 		if (retval)
 			goto fput_fail;
 
-		nd->path.mnt = mntget(file->f_path.mnt);
-		nd->path.dentry = dget(dentry);
+		nd->path = file->f_path;
+		path_get(&file->f_path);
 
 		fput_light(file, fput_needed);
 	}
Index: b/include/linux/namei.h
===================================================================
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -94,10 +94,4 @@ static inline char *nd_get_link(struct n
 	return nd->saved_names[nd->depth];
 }
 
-static inline void pathget(struct path *path)
-{
-	mntget(path->mnt);
-	dget(path->dentry);
-}
-
 #endif /* _LINUX_NAMEI_H */
Index: b/include/linux/path.h
===================================================================
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -9,6 +9,7 @@ struct path {
 	struct dentry *dentry;
 };
 
+extern void path_get(struct path *);
 extern void path_put(struct path *);
 
 #endif  /* _LINUX_PATH_H */

-- 

