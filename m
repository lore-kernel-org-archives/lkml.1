Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbYFPRWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbYFPRWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757013AbYFPRVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:21:35 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:50842 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbYFPRVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:21:34 -0400
Message-Id: <20080616171058.829792697@kerlabs.com>
References: <20080616170057.399713501@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 19:01:00 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 3/5][BUGFIX] configfs: Make configfs_new_dirent() return error code instead of NULL
Content-Disposition: inline; filename=configfs-make-configfs_new_dirent-return-errno.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes configfs_new_dirent return negative error code instead of NULL,
which will be useful in the next patch to differentiate ENOMEM from ENOENT.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-06-16 17:42:43.000000000 +0200
+++ b/fs/configfs/dir.c	2008-06-16 18:54:11.000000000 +0200
@@ -30,6 +30,7 @@
 #include <linux/mount.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 
 #include <linux/configfs.h>
 #include "configfs_internal.h"
@@ -83,7 +84,7 @@ static struct configfs_dirent *configfs_
 
 	sd = kmem_cache_zalloc(configfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	atomic_set(&sd->s_count, 1);
 	INIT_LIST_HEAD(&sd->s_links);
@@ -129,8 +130,8 @@ int configfs_make_dirent(struct configfs
 	struct configfs_dirent * sd;
 
 	sd = configfs_new_dirent(parent_sd, element);
-	if (!sd)
-		return -ENOMEM;
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
 
 	sd->s_mode = mode;
 	sd->s_type = type;
@@ -1277,7 +1278,7 @@ static int configfs_dir_open(struct inod
 	file->private_data = configfs_new_dirent(parent_sd, NULL);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
-	return file->private_data ? 0 : -ENOMEM;
+	return IS_ERR(file->private_data) ? PTR_ERR(file->private_data) : 0;
 
 }
 

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

