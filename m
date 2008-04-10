Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYDJMiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYDJMiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYDJMhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:37:24 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:49515 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755471AbYDJMhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:37:20 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-12.tower-29.messagelabs.com!1207831038!10511181!7
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] UIO: hold a reference to the device's owner while the device is open
Date: Thu, 10 Apr 2008 14:37:00 +0200
Message-Id: <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Apr 2008 12:37:03.0482 (UTC) FILETIME=[94470DA0:01C89B07]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15840.007
X-TM-AS-Result: No--4.976000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the device might just disappear while /dev/uioX is being used
which results in an Oops.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 drivers/uio/uio.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 1175908..005fc55 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -301,25 +301,35 @@ static int uio_open(struct inode *inode, struct file *filep)
 	if (!idev)
 		return -ENODEV;
 
+	if (!try_module_get(idev->owner)) {
+		ret = -ENODEV;
+		goto err_module_get;
+	}
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
-	}
+		if (ret) {
+			kfree(listener);
+err_alloc_listener:
 
-	if (ret)
-		kfree(listener);
+			module_put(idev->owner);
+err_module_get:
 
-	return ret;
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 static int uio_fasync(int fd, struct file *filep, int on)
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

