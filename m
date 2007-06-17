Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbXFQMxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbXFQMxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 08:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760263AbXFQMwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 08:52:42 -0400
Received: from saeurebad.de ([85.214.36.134]:35220 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760254AbXFQMwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 08:52:41 -0400
Date: Sun, 17 Jun 2007 14:52:32 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Replace obscure constructs in fs/block_dev.c
Message-ID: <20070617125232.GA32374@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070615134632.GA11666@saeurebad.de> <20070617093855.GA30197@atjola.homenet>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20070617093855.GA30197@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Sun, Jun 17, 2007 at 11:38:55AM +0200, Bjoern Steinbrink wrote:
[SNIP]
> > -	/* first decide result */
> > -	if (bdev->bd_holder == holder)
> > -		res = 0;	 /* already a holder */
> > -	else if (bdev->bd_holder != NULL)
> > -		res = -EBUSY; 	 /* held by someone else */
> > -	else if (bdev->bd_contains == bdev)
> > -		res = 0;  	 /* is a whole device which isn't held */
> > -
> > -	else if (bdev->bd_contains->bd_holder == bd_claim)
> > -		res = 0; 	 /* is a partition of a device that is being partitioned */
> > -	else if (bdev->bd_contains->bd_holder != NULL)
> > -		res = -EBUSY;	 /* is a partition of a held device */
> > -	else
> > -		res = 0;	 /* is a partition of an un-held device */
> > +	/* If already held by someone else or we have a
> > +	 * partition of a held device, we do nothing. */
> >  
> > -	/* now impose change */
> > -	if (res==0) {
> > +	if (bdev->bd_holder || bdev->bd_contains->bd_holder)
> > +		res = -EBUSY;
[SNAP]

> Hm, that actually ignores the "someone else" part of the comment and
> introduces a semantic change. No idea, if it breaks anything though.

Whoops, yes. ->bd_holder can be actually !NULL when it is == holder.
Same for ->bd_contains->bd_holder. Also the `is a whole unheld device'
was ignored - sorry. Second try:


This patch replaces some obscure code-paths in fs/block_dev.c with more
readable versions.

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="block_dev-anti-obscurity-r1.patch"

diff --git a/fs/block_dev.c b/fs/block_dev.c
index ea1480a..3a49adb 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -660,37 +660,32 @@ void bd_forget(struct inode *inode)
 
 int bd_claim(struct block_device *bdev, void *holder)
 {
-	int res;
+	void *bd_holder;
+	struct block_device *bd_contains;
+
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
+	bd_holder = bdev->bd_holder;
+	bd_contains = bdev->bd_contains;
 
-	/* now impose change */
-	if (res==0) {
-		/* note that for a whole device bd_holders
-		 * will be incremented twice, and bd_holder will
-		 * be set to bd_claim before being set to holder
-		 */
-		bdev->bd_contains->bd_holders ++;
-		bdev->bd_contains->bd_holder = bd_claim;
-		bdev->bd_holders++;
-		bdev->bd_holder = holder;
+	if ((bd_holder && bd_holder != holder) ||
+	    (bd_contains != bdev &&
+	     bd_contains->bd_holder && bd_contains->bd_holder != bd_claim)) {
+		spin_unlock(&bdev_lock);
+		return -EBUSY;
 	}
+
+	/* note that for a whole device bd_holders
+	 * will be incremented twice, and bd_holder will
+	 * be set to bd_claim before being set to holder
+	 */
+	bdev->bd_contains->bd_holders ++;
+	bdev->bd_contains->bd_holder = bd_claim;
+	bdev->bd_holders++;
+	bdev->bd_holder = holder;
+
 	spin_unlock(&bdev_lock);
-	return res;
+	return 0;
 }
 
 EXPORT_SYMBOL(bd_claim);
@@ -874,7 +869,7 @@ static struct bd_holder *find_bd_holder(struct block_device *bdev,
  */
 static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
 {
-	int ret;
+	int err;
 
 	if (!bo)
 		return -EINVAL;
@@ -882,14 +877,17 @@ static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
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
+
+	list_add_tail(&bo->list, &bdev->bd_holder_list);
 	return ret;
 }
 

--liOOAslEiF7prFVr--
