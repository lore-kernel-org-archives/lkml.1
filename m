Return-Path: <linux-kernel-owner+w=401wt.eu-S936461AbZFPGGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936461AbZFPGGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935998AbZFPFv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:56 -0400
Received: from kroah.org ([198.145.64.141]:48491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935983AbZFPFvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, xen-devel@lists.xensource.com,
       virtualization@lists.osdl.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [PATCH 62/64] xen: remove driver_data direct access of struct device from more drivers
Date: Mon, 15 Jun 2009 22:46:51 -0700
Message-Id: <1245131213-24168-62-git-send-email-gregkh@suse.de>
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
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/xen-kbdfront.c |    8 ++++----
 drivers/net/xen-netfront.c   |   10 +++++-----
 drivers/video/xen-fbfront.c  |    8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 928d2ed..b115726 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -114,7 +114,7 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
 		return -ENOMEM;
 	}
-	dev->dev.driver_data = info;
+	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->irq = -1;
 	snprintf(info->phys, sizeof(info->phys), "xenbus/%s", dev->nodename);
@@ -186,7 +186,7 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 
 static int xenkbd_resume(struct xenbus_device *dev)
 {
-	struct xenkbd_info *info = dev->dev.driver_data;
+	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
 
 	xenkbd_disconnect_backend(info);
 	memset(info->page, 0, PAGE_SIZE);
@@ -195,7 +195,7 @@ static int xenkbd_resume(struct xenbus_device *dev)
 
 static int xenkbd_remove(struct xenbus_device *dev)
 {
-	struct xenkbd_info *info = dev->dev.driver_data;
+	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
 
 	xenkbd_disconnect_backend(info);
 	if (info->kbd)
@@ -266,7 +266,7 @@ static void xenkbd_disconnect_backend(struct xenkbd_info *info)
 static void xenkbd_backend_changed(struct xenbus_device *dev,
 				   enum xenbus_state backend_state)
 {
-	struct xenkbd_info *info = dev->dev.driver_data;
+	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
 	int ret, val;
 
 	switch (backend_state) {
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index f673253..8d88dae 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1212,7 +1212,7 @@ static int __devinit netfront_probe(struct xenbus_device *dev,
 	}
 
 	info = netdev_priv(netdev);
-	dev->dev.driver_data = info;
+	dev_set_drvdata(&dev->dev, info);
 
 	err = register_netdev(info->netdev);
 	if (err) {
@@ -1233,7 +1233,7 @@ static int __devinit netfront_probe(struct xenbus_device *dev,
 
  fail:
 	free_netdev(netdev);
-	dev->dev.driver_data = NULL;
+	dev_set_drvdata(&dev->dev, NULL);
 	return err;
 }
 
@@ -1275,7 +1275,7 @@ static void xennet_disconnect_backend(struct netfront_info *info)
  */
 static int netfront_resume(struct xenbus_device *dev)
 {
-	struct netfront_info *info = dev->dev.driver_data;
+	struct netfront_info *info = dev_get_drvdata(&dev->dev);
 
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
@@ -1600,7 +1600,7 @@ static int xennet_connect(struct net_device *dev)
 static void backend_changed(struct xenbus_device *dev,
 			    enum xenbus_state backend_state)
 {
-	struct netfront_info *np = dev->dev.driver_data;
+	struct netfront_info *np = dev_get_drvdata(&dev->dev);
 	struct net_device *netdev = np->netdev;
 
 	dev_dbg(&dev->dev, "%s\n", xenbus_strstate(backend_state));
@@ -1774,7 +1774,7 @@ static struct xenbus_device_id netfront_ids[] = {
 
 static int __devexit xennet_remove(struct xenbus_device *dev)
 {
-	struct netfront_info *info = dev->dev.driver_data;
+	struct netfront_info *info = dev_get_drvdata(&dev->dev);
 
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 2493f05..15502d5 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -384,7 +384,7 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 		fb_size = XENFB_DEFAULT_FB_LEN;
 	}
 
-	dev->dev.driver_data = info;
+	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->irq = -1;
 	info->x1 = info->y1 = INT_MAX;
@@ -503,7 +503,7 @@ xenfb_make_preferred_console(void)
 
 static int xenfb_resume(struct xenbus_device *dev)
 {
-	struct xenfb_info *info = dev->dev.driver_data;
+	struct xenfb_info *info = dev_get_drvdata(&dev->dev);
 
 	xenfb_disconnect_backend(info);
 	xenfb_init_shared_page(info, info->fb_info);
@@ -512,7 +512,7 @@ static int xenfb_resume(struct xenbus_device *dev)
 
 static int xenfb_remove(struct xenbus_device *dev)
 {
-	struct xenfb_info *info = dev->dev.driver_data;
+	struct xenfb_info *info = dev_get_drvdata(&dev->dev);
 
 	xenfb_disconnect_backend(info);
 	if (info->fb_info) {
@@ -621,7 +621,7 @@ static void xenfb_disconnect_backend(struct xenfb_info *info)
 static void xenfb_backend_changed(struct xenbus_device *dev,
 				  enum xenbus_state backend_state)
 {
-	struct xenfb_info *info = dev->dev.driver_data;
+	struct xenfb_info *info = dev_get_drvdata(&dev->dev);
 	int val;
 
 	switch (backend_state) {
-- 
1.6.3.2

