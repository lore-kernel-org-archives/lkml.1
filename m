Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXI0OLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXI0OLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbXI0OJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:09:48 -0400
Received: from mail.suse.de ([195.135.220.2]:36786 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbXI0OJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:09:44 -0400
Message-Id: <20070927141228.805874619@X40.localnet>
References: <20070927141200.820970144@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Thu, 27 Sep 2007 16:12:08 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@lst.de, agruen@suse.de, tiwai@suse.de
Subject: [patch 08/10] Introduce path_get()
Content-Disposition: inline; filename=nameidata-path-5.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces the symmetric function to path_put() for getting a reference
to the dentry and vfsmount of a struct path in the right order.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 fs/namei.c           |   17 +++++++++++++++--
 include/linux/path.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

Index: b/fs/namei.c
===================================================================
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -348,6 +348,20 @@ int deny_write_access(struct file * file
 }
 
 /**
+ * path_get - get a reference to a path
+ * @path: path to get the reference to
+ *
+ * Given a path increment the reference count to the dentry and the vfsmount.
+ */
+struct path *path_get(struct path *path)
+{
+	mntget(path->mnt);
+	dget(path->dentry);
+	return path;
+}
+EXPORT_SYMBOL(path_get);
+
+/**
  * path_put - put a reference to a path
  * @path: path to put the reference to
  *
@@ -1145,8 +1159,7 @@ static int fastcall do_path_lookup(int d
 		if (retval)
 			goto fput_fail;
 
-		nd->path.mnt = mntget(file->f_path.mnt);
-		nd->path.dentry = dget(dentry);
+		nd->path = *path_get(&file->f_path);
 
 		fput_light(file, fput_needed);
 	}
Index: b/include/linux/path.h
===================================================================
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -9,6 +9,7 @@ struct path {
 	struct dentry *dentry;
 };
 
+extern struct path *path_get(struct path *);
 extern void path_put(struct path *);
 
 #endif  /* _LINUX_PATH_H */

-- 

