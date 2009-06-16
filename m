Return-Path: <linux-kernel-owner+w=401wt.eu-S937020AbZFPGC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937020AbZFPGC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935907AbZFPFvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:38 -0400
Received: from kroah.org ([198.145.64.141]:48439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935845AbZFPFvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, xen-devel@lists.xensource.com,
       virtualization@lists.osdl.org
Subject: [PATCH 49/64] xen block: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:38 -0700
Message-Id: <1245131213-24168-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.


Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.osdl.org
Acked-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/xen-blkfront.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index c199682..e532847 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -753,12 +753,12 @@ static int blkfront_probe(struct xenbus_device *dev,
 
 	/* Front end dir is a number, which is used as the id. */
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
-	dev->dev.driver_data = info;
+	dev_set_drvdata(&dev->dev, info);
 
 	err = talk_to_backend(dev, info);
 	if (err) {
 		kfree(info);
-		dev->dev.driver_data = NULL;
+		dev_set_drvdata(&dev->dev, NULL);
 		return err;
 	}
 
@@ -843,7 +843,7 @@ static int blkif_recover(struct blkfront_info *info)
  */
 static int blkfront_resume(struct xenbus_device *dev)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	int err;
 
 	dev_dbg(&dev->dev, "blkfront_resume: %s\n", dev->nodename);
@@ -922,7 +922,7 @@ static void blkfront_connect(struct blkfront_info *info)
  */
 static void blkfront_closing(struct xenbus_device *dev)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	unsigned long flags;
 
 	dev_dbg(&dev->dev, "blkfront_closing: %s removed\n", dev->nodename);
@@ -957,7 +957,7 @@ static void blkfront_closing(struct xenbus_device *dev)
 static void backend_changed(struct xenbus_device *dev,
 			    enum xenbus_state backend_state)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	struct block_device *bd;
 
 	dev_dbg(&dev->dev, "blkfront:backend_changed.\n");
@@ -997,7 +997,7 @@ static void backend_changed(struct xenbus_device *dev,
 
 static int blkfront_remove(struct xenbus_device *dev)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 
 	dev_dbg(&dev->dev, "blkfront_remove: %s removed\n", dev->nodename);
 
@@ -1010,7 +1010,7 @@ static int blkfront_remove(struct xenbus_device *dev)
 
 static int blkfront_is_ready(struct xenbus_device *dev)
 {
-	struct blkfront_info *info = dev->dev.driver_data;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 
 	return info->is_ready;
 }
-- 
1.6.3.2

