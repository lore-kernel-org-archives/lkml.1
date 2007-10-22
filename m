Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXJVHAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXJVHAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXJVHAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:00:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60287 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbXJVHAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:00:36 -0400
Date: Mon, 22 Oct 2007 12:30:32 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/13] Introduce path_get()
Message-ID: <20071022070032.GI6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This introduces the symmetric function to path_put() for getting a reference
to the dentry and vfsmount of a struct path in the right order.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c            |   17 +++++++++++++++--
 fs/unionfs/super.c    |    2 +-
 include/linux/namei.h |    6 ------
 include/linux/path.h  |    1 +
 4 files changed, 17 insertions(+), 9 deletions(-)

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
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -544,7 +544,7 @@ static int unionfs_remount_fs(struct sup
 	memcpy(tmp_lower_paths, UNIONFS_D(sb->s_root)->lower_paths,
 	       cur_branches * sizeof(struct path));
 	for (i = 0; i < cur_branches; i++)
-		pathget(&tmp_lower_paths[i]); /* drop refs at end of fxn */
+		path_get(&tmp_lower_paths[i]); /* drop refs at end of fxn */
 
 	/*******************************************************************
 	 * For each branch command, do path_lookup on the requested branch,
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
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -9,6 +9,7 @@ struct path {
 	struct dentry *dentry;
 };
 
+extern void path_get(struct path *);
 extern void path_put(struct path *);
 
 #endif  /* _LINUX_PATH_H */
