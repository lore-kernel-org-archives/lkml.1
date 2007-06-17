Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbXFQPmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbXFQPmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXFQPmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:42:36 -0400
Received: from saeurebad.de ([85.214.36.134]:36799 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbXFQPmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:42:35 -0400
Date: Sun, 17 Jun 2007 17:42:26 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Replace obscure constructs in fs/block_dev.c
Message-ID: <20070617154226.GB9489@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	=?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070615134632.GA11666@saeurebad.de> <20070617093855.GA30197@atjola.homenet>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20070617093855.GA30197@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

please ignore the last revision of this patch. There were some places where
semantics where changed instead of just presentation.  Also the bd_claim()
'fixup' was reverted, due to a misunderstanding of the code.


This patch replaces some funky codepaths in fs/block_dev.c with cleaner
versions of the affected places.

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

--0OAP2g/MAC+5xKAE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="block_dev-anti-obscurity-r2.patch"

diff --git a/fs/block_dev.c b/fs/block_dev.c
index ea1480a..710de2f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -874,7 +874,7 @@ static struct bd_holder *find_bd_holder(struct block_device *bdev,
  */
 static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
 {
-	int ret;
+	int err;
 
 	if (!bo)
 		return -EINVAL;
@@ -882,15 +882,18 @@ static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
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
+	return err;
 }
 
 /**
@@ -948,7 +951,7 @@ static struct bd_holder *del_bd_holder(struct block_device *bdev,
 static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
 				struct kobject *kobj)
 {
-	int res;
+	int err;
 	struct bd_holder *bo, *found;
 
 	if (!kobj)
@@ -959,21 +962,24 @@ static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
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
 	mutex_unlock(&bdev->bd_mutex);
-
-	return res;
+	return err;
 }
 
 /**

--0OAP2g/MAC+5xKAE--
