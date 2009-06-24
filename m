Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbZFXPbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbZFXPbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZFXPbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:31:08 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55607 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZFXPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:31:06 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, hjk@linutronix.de, Daniel Mack <daniel@caiaq.de>
Subject: [PATCH 1/2] UIO: add device clock support
Date: Wed, 24 Jun 2009 17:30:24 +0200
Message-Id: <1245857425-25389-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245857425-25389-1-git-send-email-daniel@caiaq.de>
References: <1245857425-25389-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pointer to a 'struct clk' to uio_info. Drivers can set
this pointer if a clock is needed, and the UIO core will care
to enable and disable it upon device open and release.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Hans J. Koch <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c          |   15 ++++++++++++++-
 include/linux/uio_driver.h |    2 ++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 03efb06..6ba95cf 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -479,6 +479,12 @@ static int uio_open(struct inode *inode, struct file *filep)
 	listener->event_count = atomic_read(&idev->event);
 	filep->private_data = listener;
 
+	if (idev->info->clk) {
+		ret = clk_enable(idev->info->clk);
+		if (ret)
+			goto err_clkenable;
+	}
+
 	if (idev->info->open) {
 		ret = idev->info->open(idev->info, inode);
 		if (ret)
@@ -486,6 +492,7 @@ static int uio_open(struct inode *inode, struct file *filep)
 	}
 	return 0;
 
+err_clkenable:
 err_infoopen:
 	kfree(listener);
 
@@ -510,8 +517,14 @@ static int uio_release(struct inode *inode, struct file *filep)
 	struct uio_listener *listener = filep->private_data;
 	struct uio_device *idev = listener->dev;
 
-	if (idev->info->release)
+	if (idev->info->release) {
 		ret = idev->info->release(idev->info, inode);
+		if (ret)
+			dev_err(idev->dev, "release() failed (%d)\n", ret);
+	}
+
+	if (idev->info->clk)
+		clk_disable(idev->info->clk);
 
 	module_put(idev->owner);
 	kfree(listener);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 5dcc9ff..6bc0e7e 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
+#include <linux/clk.h>
 
 struct uio_map;
 
@@ -87,6 +88,7 @@ struct uio_info {
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
+	struct clk		*clk;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
 	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
 	int (*open)(struct uio_info *info, struct inode *inode);
-- 
1.6.3.1

