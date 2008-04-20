Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbYDTKmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbYDTKmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbYDTKkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56262 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbYDTKkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Hans J Koch <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/36] UIO: hold a reference to the device's owner while the device is open
Date: Sun, 20 Apr 2008 03:45:37 -0700
Message-Id: <1208688366-9252-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Otherwise the device might just disappear while /dev/uioX is being used
which results in an Oops.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Signed-off-by: Hans J Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 1175908..55cc7b8 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -301,23 +301,33 @@ static int uio_open(struct inode *inode, struct file *filep)
 	if (!idev)
 		return -ENODEV;
 
+	if (!try_module_get(idev->owner))
+		return -ENODEV;
+
 	listener = kmalloc(sizeof(*listener), GFP_KERNEL);
-	if (!listener)
-		return -ENOMEM;
+	if (!listener) {
+		ret = -ENOMEM;
+		goto err_alloc_listener;
+	}
 
 	listener->dev = idev;
 	listener->event_count = atomic_read(&idev->event);
 	filep->private_data = listener;
 
 	if (idev->info->open) {
-		if (!try_module_get(idev->owner))
-			return -ENODEV;
 		ret = idev->info->open(idev->info, inode);
-		module_put(idev->owner);
+		if (ret)
+			goto err_infoopen;
 	}
 
-	if (ret)
-		kfree(listener);
+	return 0;
+
+err_infoopen:
+
+	kfree(listener);
+err_alloc_listener:
+
+	module_put(idev->owner);
 
 	return ret;
 }
@@ -336,12 +346,11 @@ static int uio_release(struct inode *inode, struct file *filep)
 	struct uio_listener *listener = filep->private_data;
 	struct uio_device *idev = listener->dev;
 
-	if (idev->info->release) {
-		if (!try_module_get(idev->owner))
-			return -ENODEV;
+	if (idev->info->release)
 		ret = idev->info->release(idev->info, inode);
-		module_put(idev->owner);
-	}
+
+	module_put(idev->owner);
+
 	if (filep->f_flags & FASYNC)
 		ret = uio_fasync(-1, filep, 0);
 	kfree(listener);
@@ -510,10 +519,7 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	if (idev->info->mmap) {
-		if (!try_module_get(idev->owner))
-			return -ENODEV;
 		ret = idev->info->mmap(idev->info, vma);
-		module_put(idev->owner);
 		return ret;
 	}
 
-- 
1.5.4.5

