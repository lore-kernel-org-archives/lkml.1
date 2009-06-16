Return-Path: <linux-kernel-owner+w=401wt.eu-S937121AbZFPGEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937121AbZFPGEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935995AbZFPFvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:49 -0400
Received: from kroah.org ([198.145.64.141]:48484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935978AbZFPFvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 60/64] uml: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:49 -0700
Message-Id: <1245131213-24168-60-git-send-email-gregkh@suse.de>
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

Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/um/drivers/net_kern.c |    4 ++--
 arch/um/drivers/ubd_kern.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 434ba12..3b44b47 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -360,7 +360,7 @@ static struct platform_driver uml_net_driver = {
 
 static void net_device_release(struct device *dev)
 {
-	struct uml_net *device = dev->driver_data;
+	struct uml_net *device = dev_get_drvdata(dev);
 	struct net_device *netdev = device->dev;
 	struct uml_net_private *lp = netdev_priv(netdev);
 
@@ -440,7 +440,7 @@ static void eth_configure(int n, void *init, char *mac,
 	device->pdev.id = n;
 	device->pdev.name = DRIVER_NAME;
 	device->pdev.dev.release = net_device_release;
-	device->pdev.dev.driver_data = device;
+	dev_set_drvdata(&device->pdev.dev, device);
 	if (platform_device_register(&device->pdev))
 		goto out_free_netdev;
 	SET_NETDEV_DEV(dev,&device->pdev.dev);
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index aa9e926..8f05d4d 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -778,7 +778,7 @@ static int ubd_open_dev(struct ubd *ubd_dev)
 
 static void ubd_device_release(struct device *dev)
 {
-	struct ubd *ubd_dev = dev->driver_data;
+	struct ubd *ubd_dev = dev_get_drvdata(dev);
 
 	blk_cleanup_queue(ubd_dev->queue);
 	*ubd_dev = ((struct ubd) DEFAULT_UBD);
@@ -807,7 +807,7 @@ static int ubd_disk_register(int major, u64 size, int unit,
 		ubd_devs[unit].pdev.id   = unit;
 		ubd_devs[unit].pdev.name = DRIVER_NAME;
 		ubd_devs[unit].pdev.dev.release = ubd_device_release;
-		ubd_devs[unit].pdev.dev.driver_data = &ubd_devs[unit];
+		dev_set_drvdata(&ubd_devs[unit].pdev.dev, &ubd_devs[unit]);
 		platform_device_register(&ubd_devs[unit].pdev);
 		disk->driverfs_dev = &ubd_devs[unit].pdev.dev;
 	}
-- 
1.6.3.2

