Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbXDEU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbXDEU3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXDEU3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:29:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:54273 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbXDEU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:29:16 -0400
Date: Thu, 5 Apr 2007 16:24:52 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/4] UML - drivers get release methods
Message-ID: <20070405202452.GA8923@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Define release methods for the ubd and net drivers.  They contain as
much of the remove methods as make sense.  All error checking must
have already been done as well as anything else that might be holding
a reference on the device kobject.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/net_kern.c |   19 +++++++++++++++----
 arch/um/drivers/ubd_kern.c |   17 ++++++++++++-----
 2 files changed, 27 insertions(+), 9 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-04-05 12:39:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-04-05 12:39:11.000000000 -0400
@@ -622,6 +622,14 @@ static int ubd_open_dev(struct ubd *ubd_
 	return(err);
 }
 
+static void ubd_device_release(struct device *dev)
+{
+	struct ubd *ubd_dev = dev->driver_data;
+
+	blk_cleanup_queue(ubd_dev->queue);
+	*ubd_dev = ((struct ubd) DEFAULT_UBD);
+}
+
 static int ubd_disk_register(int major, u64 size, int unit,
 			     struct gendisk **disk_out)
 {
@@ -644,6 +652,8 @@ static int ubd_disk_register(int major, 
 	if (major == MAJOR_NR) {
 		ubd_devs[unit].pdev.id   = unit;
 		ubd_devs[unit].pdev.name = DRIVER_NAME;
+		ubd_devs[unit].pdev.dev.release = ubd_device_release;
+		ubd_devs[unit].pdev.dev.driver_data = &ubd_devs[unit];
 		platform_device_register(&ubd_devs[unit].pdev);
 		disk->driverfs_dev = &ubd_devs[unit].pdev.dev;
 	}
@@ -787,7 +797,7 @@ static int ubd_id(char **str, int *start
 
 static int ubd_remove(int n, char **error_out)
 {
-	struct gendisk *disk;
+	struct gendisk *disk = ubd_gendisk[n];
 	struct ubd *ubd_dev;
 	int err = -ENODEV;
 
@@ -803,7 +813,6 @@ static int ubd_remove(int n, char **erro
 	if(ubd_dev->count > 0)
 		goto out;
 
- 	disk = ubd_gendisk[n];
  	ubd_gendisk[n] = NULL;
 	if(disk != NULL){
 		del_gendisk(disk);
@@ -816,10 +825,8 @@ static int ubd_remove(int n, char **erro
 		fake_gendisk[n] = NULL;
 	}
 
-	blk_cleanup_queue(ubd_dev->queue);
-	platform_device_unregister(&ubd_dev->pdev);
-	*ubd_dev = ((struct ubd) DEFAULT_UBD);
 	err = 0;
+	platform_device_unregister(&ubd_dev->pdev);
 out:
 	mutex_unlock(&ubd_lock);
 	return err;
Index: linux-2.6.21-mm/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/net_kern.c	2007-04-05 12:38:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/net_kern.c	2007-04-05 12:39:11.000000000 -0400
@@ -341,6 +341,19 @@ static struct platform_driver uml_net_dr
 };
 static int driver_registered;
 
+static void net_device_release(struct device *dev)
+{
+	struct uml_net *device = dev->driver_data;
+	struct net_device *netdev = device->dev;
+	struct uml_net_private *lp = netdev->priv;
+
+	if(lp->remove != NULL)
+		(*lp->remove)(&lp->user);
+	list_del(&device->list);
+	kfree(device);
+	free_netdev(netdev);
+}
+
 static void eth_configure(int n, void *init, char *mac,
 			  struct transport *transport)
 {
@@ -396,6 +409,8 @@ static void eth_configure(int n, void *i
 	}
 	device->pdev.id = n;
 	device->pdev.name = DRIVER_NAME;
+	device->pdev.dev.release = net_device_release;
+	device->pdev.dev.driver_data = device;
 	if(platform_device_register(&device->pdev))
 		goto out_free_netdev;
 	SET_NETDEV_DEV(dev,&device->pdev.dev);
@@ -689,13 +704,9 @@ static int net_remove(int n, char **erro
 	lp = dev->priv;
 	if(lp->fd > 0)
 		return -EBUSY;
-	if(lp->remove != NULL) (*lp->remove)(&lp->user);
 	unregister_netdev(dev);
 	platform_device_unregister(&device->pdev);
 
-	list_del(&device->list);
-	kfree(device);
-	free_netdev(dev);
 	return 0;
 }
 
