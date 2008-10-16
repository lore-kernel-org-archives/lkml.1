Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYJPRW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYJPRW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbYJPROa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:30 -0400
Received: from kroah.org ([198.145.64.141]:46973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756171AbYJPRO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/46] usb gadget: link fixes for cdc composite gadget
Date: Thu, 16 Oct 2008 10:10:22 -0700
Message-Id: <1224177047-11859-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Change how the CDC Composite gadget driver builds:  don't
use separate compilation, since it works poorly when key
parts are library code (with init sections etc).  Instead
be as close as we can to "gcc --combine ...".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/Makefile  |    3 +--
 drivers/usb/gadget/cdc2.c    |   25 +++++++++++++++++++++++--
 drivers/usb/gadget/u_ether.c |    4 ++--
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 736d58f..bfa0229 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -31,8 +31,7 @@ g_midi-objs			:= gmidi.o
 gadgetfs-objs			:= inode.o
 g_file_storage-objs		:= file_storage.o
 g_printer-objs			:= printer.o
-g_cdc-objs			:= cdc2.o u_ether.o f_ecm.o \
-					u_serial.o f_acm.o $(C_UTILS)
+g_cdc-objs			:= cdc2.o
 
 ifeq ($(CONFIG_USB_ETH_RNDIS),y)
 	g_ether-objs		+= f_rndis.o rndis.o
diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
index a39a4b9..a724fc1 100644
--- a/drivers/usb/gadget/cdc2.c
+++ b/drivers/usb/gadget/cdc2.c
@@ -43,6 +43,25 @@
 
 /*-------------------------------------------------------------------------*/
 
+/*
+ * Kbuild is not very cooperative with respect to linking separately
+ * compiled library objects into one module.  So for now we won't use
+ * separate compilation ... ensuring init/exit sections work to shrink
+ * the runtime footprint, and giving us at least some parts of what
+ * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
+ */
+
+#include "composite.c"
+#include "usbstring.c"
+#include "config.c"
+#include "epautoconf.c"
+#include "u_serial.c"
+#include "f_acm.c"
+#include "f_ecm.c"
+#include "u_ether.c"
+
+/*-------------------------------------------------------------------------*/
+
 static struct usb_device_descriptor device_desc = {
 	.bLength =		sizeof device_desc,
 	.bDescriptorType =	USB_DT_DEVICE,
@@ -148,7 +167,8 @@ static int __init cdc_bind(struct usb_composite_dev *cdev)
 	int			status;
 
 	if (!can_support_ecm(cdev->gadget)) {
-		ERROR(cdev, "controller '%s' not usable\n", gadget->name);
+		dev_err(&gadget->dev, "controller '%s' not usable\n",
+				gadget->name);
 		return -EINVAL;
 	}
 
@@ -203,7 +223,8 @@ static int __init cdc_bind(struct usb_composite_dev *cdev)
 	if (status < 0)
 		goto fail1;
 
-	INFO(cdev, "%s, version: " DRIVER_VERSION "\n", DRIVER_DESC);
+	dev_info(&gadget->dev, "%s, version: " DRIVER_VERSION "\n",
+			DRIVER_DESC);
 
 	return 0;
 
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 3791e62..dbd575a 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -52,7 +52,7 @@
  * this single "physical" link to be used by multiple virtual links.)
  */
 
-#define DRIVER_VERSION	"29-May-2008"
+#define UETH__VERSION	"29-May-2008"
 
 struct eth_dev {
 	/* lock is held while accessing port_usb
@@ -170,7 +170,7 @@ static void eth_get_drvinfo(struct net_device *net, struct ethtool_drvinfo *p)
 	struct eth_dev	*dev = netdev_priv(net);
 
 	strlcpy(p->driver, "g_ether", sizeof p->driver);
-	strlcpy(p->version, DRIVER_VERSION, sizeof p->version);
+	strlcpy(p->version, UETH__VERSION, sizeof p->version);
 	strlcpy(p->fw_version, dev->gadget->name, sizeof p->fw_version);
 	strlcpy(p->bus_info, dev_name(&dev->gadget->dev), sizeof p->bus_info);
 }
-- 
1.6.0.2

