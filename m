Return-Path: <linux-kernel-owner+w=401wt.eu-S1762523AbYFLNoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762523AbYFLNoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbYFLNnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:43:50 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:49487 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761905AbYFLNnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:43:46 -0400
Message-Id: <20080612134203.960567897@kerlabs.com>
References: <20080612133126.335618468@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 15:31:28 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 2/3][BUGFIX] configfs: Make configfs_new_dirent() return error code instead of NULL
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
--- a/fs/configfs/dir.c	2008-06-12 13:45:14.000000000 +0200
+++ b/fs/configfs/dir.c	2008-06-12 15:18:28.000000000 +0200
@@ -30,6 +30,7 @@
 #include <linux/mount.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 
 #include <linux/configfs.h>
 #include "configfs_internal.h"
@@ -79,7 +80,7 @@ static struct configfs_dirent *configfs_
 
 	sd = kmem_cache_zalloc(configfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	atomic_set(&sd->s_count, 1);
 	INIT_LIST_HEAD(&sd->s_links);
@@ -125,8 +126,8 @@ int configfs_make_dirent(struct configfs
 	struct configfs_dirent * sd;
 
 	sd = configfs_new_dirent(parent_sd, element);
-	if (!sd)
-		return -ENOMEM;
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
 
 	sd->s_mode = mode;
 	sd->s_type = type;
@@ -1273,7 +1274,7 @@ static int configfs_dir_open(struct inod
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

