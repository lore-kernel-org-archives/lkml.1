Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZEEVqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZEEVqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZEEVqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:46:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:51907 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZEEVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:46:14 -0400
Message-Id: <20090505214433.946117208@suse.de>
User-Agent: quilt/0.47-14.10
Date: Tue, 05 May 2009 23:32:04 +0200
From: jblunck@suse.de
To: Arnd Bergmann <arndb@de.ibm.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: [patch 1/2] spufs: make dentry reference count and locking symmetric
References: <20090505213203.797397821@suse.de>
Content-Disposition: inline; filename=spufs-make-dput-and-locking-symmetric.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the dput() and the parent inode locking to the same function.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 arch/powerpc/platforms/cell/spufs/inode.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

Index: b/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -450,16 +450,16 @@ spufs_create_context(struct inode *inode
 	ret = -EPERM;
 	if ((flags & SPU_CREATE_NOSCHED) &&
 	    !capable(CAP_SYS_NICE))
-		goto out_unlock;
+		goto out;
 
 	ret = -EINVAL;
 	if ((flags & (SPU_CREATE_NOSCHED | SPU_CREATE_ISOLATE))
 	    == SPU_CREATE_ISOLATE)
-		goto out_unlock;
+		goto out;
 
 	ret = -ENODEV;
 	if ((flags & SPU_CREATE_ISOLATE) && !isolated_loader)
-		goto out_unlock;
+		goto out;
 
 	gang = NULL;
 	neighbor = NULL;
@@ -468,7 +468,7 @@ spufs_create_context(struct inode *inode
 		gang = SPUFS_I(inode)->i_gang;
 		ret = -EINVAL;
 		if (!gang)
-			goto out_unlock;
+			goto out;
 		mutex_lock(&gang->aff_mutex);
 		neighbor = spufs_assert_affinity(flags, gang, aff_filp);
 		if (IS_ERR(neighbor)) {
@@ -505,10 +505,7 @@ spufs_create_context(struct inode *inode
 out_aff_unlock:
 	if (affinity)
 		mutex_unlock(&gang->aff_mutex);
-out_unlock:
-	mutex_unlock(&inode->i_mutex);
 out:
-	dput(dentry);
 	return ret;
 }
 
@@ -595,8 +592,6 @@ static int spufs_create_gang(struct inod
 	}
 
 out:
-	mutex_unlock(&inode->i_mutex);
-	dput(dentry);
 	return ret;
 }
 
@@ -645,7 +640,6 @@ long spufs_create(struct nameidata *nd,
 					    filp);
 	if (ret >= 0)
 		fsnotify_mkdir(nd->path.dentry->d_inode, dentry);
-	return ret;
 
 out_dput:
 	dput(dentry);


