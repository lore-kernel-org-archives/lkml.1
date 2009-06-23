Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbZFWNTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbZFWNTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbZFWNTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:19:02 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:43570 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758349AbZFWNTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:19:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: gregkh@suse.de, bigeasy@linuxtronix.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] USB: isp1760: allow platform devices to customize devflags
Date: Tue, 23 Jun 2009 09:18:34 -0400
Message-Id: <1245763114-7753-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Platform device support was merged earlier, but support for boards to
customize the devflags aspect of the controller was not.  We want this on
Blackfin systems to control the bus width, but might as well expose all of
the fields while we're at it.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/host/isp1760-hcd.c |    4 ++++
 drivers/usb/host/isp1760-hcd.h |    2 ++
 drivers/usb/host/isp1760-if.c  |   21 ++++++++++++++++++++-
 include/linux/usb/isp1760.h    |   18 ++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/usb/isp1760.h

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 1543846..9600a58 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -386,6 +386,10 @@ static int isp1760_hc_setup(struct usb_hcd *hcd)
 		hwmode |= HW_DACK_POL_HIGH;
 	if (priv->devflags & ISP1760_FLAG_DREQ_POL_HIGH)
 		hwmode |= HW_DREQ_POL_HIGH;
+	if (priv->devflags & ISP1760_FLAG_INTR_POL_HIGH)
+		hwmode |= HW_INTR_HIGH_ACT;
+	if (priv->devflags & ISP1760_FLAG_INTR_EDGE_TRIG)
+		hwmode |= HW_INTR_EDGE_TRIG;
 
 	/*
 	 * We have to set this first in case we're in 16-bit mode.
diff --git a/drivers/usb/host/isp1760-hcd.h b/drivers/usb/host/isp1760-hcd.h
index 462f494..6931ef5 100644
--- a/drivers/usb/host/isp1760-hcd.h
+++ b/drivers/usb/host/isp1760-hcd.h
@@ -142,6 +142,8 @@ typedef void (packet_enqueue)(struct usb_hcd *hcd, struct isp1760_qh *qh,
 #define ISP1760_FLAG_DACK_POL_HIGH	0x00000010 /* DACK active high */
 #define ISP1760_FLAG_DREQ_POL_HIGH	0x00000020 /* DREQ active high */
 #define ISP1760_FLAG_ISP1761		0x00000040 /* Chip is ISP1761 */
+#define ISP1760_FLAG_INTR_POL_HIGH	0x00000080 /* Interrupt polarity active high */
+#define ISP1760_FLAG_INTR_EDGE_TRIG	0x00000100 /* Interrupt edge triggered */
 
 /* chip memory management */
 struct memory_chunk {
diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index d4feebf..1c9f977 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -3,6 +3,7 @@
  * Currently there is support for
  * - OpenFirmware
  * - PCI
+ * - PDEV (generic platform device centralized driver model)
  *
  * (c) 2007 Sebastian Siewior <bigeasy@linutronix.de>
  *
@@ -11,6 +12,7 @@
 #include <linux/usb.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/usb/isp1760.h>
 
 #include "../core/hcd.h"
 #include "isp1760-hcd.h"
@@ -308,6 +310,8 @@ static int __devinit isp1760_plat_probe(struct platform_device *pdev)
 	struct resource *mem_res;
 	struct resource *irq_res;
 	resource_size_t mem_size;
+	struct isp1760_platform_data *priv = pdev->dev.platform_data;
+	unsigned int devflags = 0;
 	unsigned long irqflags = IRQF_SHARED | IRQF_DISABLED;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -330,8 +334,23 @@ static int __devinit isp1760_plat_probe(struct platform_device *pdev)
 	}
 	irqflags |= irq_res->flags & IRQF_TRIGGER_MASK;
 
+	if (priv) {
+		if (priv->is_isp1761)
+			devflags |= ISP1760_FLAG_ISP1761;
+		if (priv->bus_width_16)
+			devflags |= ISP1760_FLAG_BUS_WIDTH_16;
+		if (priv->port1_otg)
+			devflags |= ISP1760_FLAG_OTG_EN;
+		if (priv->analog_oc)
+			devflags |= ISP1760_FLAG_ANALOG_OC;
+		if (priv->dack_polarity_high)
+			devflags |= ISP1760_FLAG_DACK_POL_HIGH;
+		if (priv->dreq_polarity_high)
+			devflags |= ISP1760_FLAG_DREQ_POL_HIGH;
+	}
+
 	hcd = isp1760_register(mem_res->start, mem_size, irq_res->start,
-			       irqflags, &pdev->dev, dev_name(&pdev->dev), 0);
+			       irqflags, &pdev->dev, dev_name(&pdev->dev), devflags);
 	if (IS_ERR(hcd)) {
 		pr_warning("isp1760: Failed to register the HCD device\n");
 		ret = -ENODEV;
diff --git a/include/linux/usb/isp1760.h b/include/linux/usb/isp1760.h
new file mode 100644
index 0000000..de7de53
--- /dev/null
+++ b/include/linux/usb/isp1760.h
@@ -0,0 +1,18 @@
+/*
+ * board initialization should put one of these into dev->platform_data
+ * and place the isp1760 onto platform_bus named "isp1760-hcd".
+ */
+
+#ifndef __LINUX_USB_ISP1760_H
+#define __LINUX_USB_ISP1760_H
+
+struct isp1760_platform_data {
+	unsigned is_isp1761:1;			/* Chip is ISP1761 */
+	unsigned bus_width_16:1;		/* 16/32-bit data bus width */
+	unsigned port1_otg:1;			/* Port 1 supports OTG */
+	unsigned analog_oc:1;			/* Analog overcurrent */
+	unsigned dack_polarity_high:1;		/* DACK active high */
+	unsigned dreq_polarity_high:1;		/* DREQ active high */
+};
+
+#endif /* __LINUX_USB_ISP1760_H */
-- 
1.6.3.1

