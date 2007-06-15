Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbXFOOCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbXFOOCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXFOOCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:02:34 -0400
Received: from saeurebad.de ([85.214.36.134]:48229 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbXFOOCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:02:33 -0400
X-Greylist: delayed 953 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 10:02:33 EDT
Date: Fri, 15 Jun 2007 15:46:32 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Replace obscure constructs in fs/block_dev.c
Message-ID: <20070615134632.GA11666@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Andrew, I promised it [1], here goes. Patched against Linus' git-tree.

[1] http://lkml.org/lkml/2007/3/22/226

This patch replaces some obscure code-paths in fs/block_dev.c with more
readable versions.

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="block_dev-anti-obscurity.patch"

diff --git a/fs/block_dev.c b/fs/block_dev.c
index ea1480a..1ffbb6d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -660,26 +660,16 @@ void bd_forget(struct inode *inode)
 
 int bd_claim(struct block_device *bdev, void *holder)
 {
-	int res;
+	int res = 0;
 	spin_lock(&bdev_lock);
 
-	/* first decide result */
-	if (bdev->bd_holder == holder)
-		res = 0;	 /* already a holder */
-	else if (bdev->bd_holder != NULL)
-		res = -EBUSY; 	 /* held by someone else */
-	else if (bdev->bd_contains == bdev)
-		res = 0;  	 /* is a whole device which isn't held */
-
-	else if (bdev->bd_contains->bd_holder == bd_claim)
-		res = 0; 	 /* is a partition of a device that is being partitioned */
-	else if (bdev->bd_contains->bd_holder != NULL)
-		res = -EBUSY;	 /* is a partition of a held device */
-	else
-		res = 0;	 /* is a partition of an un-held device */
+	/* If already held by someone else or we have a
+	 * partition of a held device, we do nothing. */
 
-	/* now impose change */
-	if (res==0) {
+	if (bdev->bd_holder || bdev->bd_contains->bd_holder)
+		res = -EBUSY;
+
+	if (!res) {
 		/* note that for a whole device bd_holders
 		 * will be incremented twice, and bd_holder will
 		 * be set to bd_claim before being set to holder
@@ -874,7 +864,7 @@ static struct bd_holder *find_bd_holder(struct block_device *bdev,
  */
 static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
 {
-	int ret;
+	int err;
 
 	if (!bo)
 		return -EINVAL;
@@ -882,15 +872,18 @@ static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
 	if (!bd_holder_grab_dirs(bdev, bo))
 		return -EBUSY;
 
-	ret = add_symlink(bo->sdir, bo->sdev);
-	if (ret == 0) {
-		ret = add_symlink(bo->hdir, bo->hdev);
-		if (ret)
-			del_symlink(bo->sdir, bo->sdev);
+	err = add_symlink(bo->sdir, bo->sdev);
+	if (err)
+		return err;
+
+	err = add_symlink(bo->hdir, bo->hdev);
+	if (err) {
+		del_symlink(bo->sdir, bo->sdev);
+		return err;
 	}
-	if (ret == 0)
-		list_add_tail(&bo->list, &bdev->bd_holder_list);
-	return ret;
+		
+	list_add_tail(&bo->list, &bdev->bd_holder_list);
+	return 0;
 }
 
 /**
@@ -948,7 +941,7 @@ static struct bd_holder *del_bd_holder(struct block_device *bdev,
 static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
 				struct kobject *kobj)
 {
-	int res;
+	int err;
 	struct bd_holder *bo, *found;
 
 	if (!kobj)
@@ -959,21 +952,25 @@ static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
 		return -ENOMEM;
 
 	mutex_lock(&bdev->bd_mutex);
-	res = bd_claim(bdev, holder);
-	if (res == 0) {
-		found = find_bd_holder(bdev, bo);
-		if (found == NULL) {
-			res = add_bd_holder(bdev, bo);
-			if (res)
-				bd_release(bdev);
-		}
-	}
 
-	if (res || found)
+	err = bd_claim(bdev, holder);
+	if (err)
+		goto out;
+
+	found = find_bd_holder(bdev, bo);
+	if (found)
+		goto out;
+
+	err = add_bd_holder(bdev, bo);
+	if (err)
+		bd_release(bdev);
+
+out:
+	if (err || found)
 		free_bd_holder(bo);
-	mutex_unlock(&bdev->bd_mutex);
 
-	return res;
+	mutex_unlock(&bdev->bd_mutex);
+	return err;
 }
 
 /**

--vkogqOf2sHV7VnPd--
