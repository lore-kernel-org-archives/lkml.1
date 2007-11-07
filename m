Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXKGILv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXKGILv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXKGILk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:11:40 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:49698 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756780AbXKGILj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:11:39 -0500
Date: Wed, 7 Nov 2007 17:11:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: [PATCH 2/2] libata: pata_platform: Support polling-mode configuration.
Message-ID: <20071107081119.GB25913@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxsh-dev@lists.sourceforge.net
References: <20071107081052.GA25913@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107081052.GA25913@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some SH boards (old R2D-1 boards) have generally not had working CF
under libata, due to both buswidth issues (handled by Aoi Shinkai
in 43f4b8c7578b928892b6f01d374346ae14e5eb70), and buggy interrupt
controllers. For these sorts of boards simply disabling the IRQ and
polling ends up working fine.

This conditionalizes the IRQ resource for pata_platform and lets
platforms that want to use polling mode simply omit the resource
entirely.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/ata/pata_platform.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index fc72a96..6b2d731 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -1,7 +1,7 @@
 /*
  * Generic platform device PATA driver
  *
- * Copyright (C) 2006  Paul Mundt
+ * Copyright (C) 2006 - 2007  Paul Mundt
  *
  * Based on pata_pcmcia:
  *
@@ -22,7 +22,7 @@
 #include <linux/pata_platform.h>
 
 #define DRV_NAME "pata_platform"
-#define DRV_VERSION "1.1"
+#define DRV_VERSION "1.2"
 
 static int pio_mask = 1;
 
@@ -120,15 +120,20 @@ static void pata_platform_setup_port(struct ata_ioports *ioaddr,
  *	Register a platform bus IDE interface. Such interfaces are PIO and we
  *	assume do not support IRQ sharing.
  *
- *	Platform devices are expected to contain 3 resources per port:
+ *	Platform devices are expected to contain at least 2 resources per port:
  *
  *		- I/O Base (IORESOURCE_IO or IORESOURCE_MEM)
  *		- CTL Base (IORESOURCE_IO or IORESOURCE_MEM)
+ *
+ *	and optionally:
+ *
  *		- IRQ	   (IORESOURCE_IRQ)
  *
  *	If the base resources are both mem types, the ioremap() is handled
  *	here. For IORESOURCE_IO, it's assumed that there's no remapping
  *	necessary.
+ *
+ *	If no IRQ resource is present, PIO polling mode is used instead.
  */
 static int __devinit pata_platform_probe(struct platform_device *pdev)
 {
@@ -137,11 +142,12 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 	struct ata_port *ap;
 	struct pata_platform_info *pp_info;
 	unsigned int mmio;
+	int irq;
 
 	/*
 	 * Simple resource validation ..
 	 */
-	if (unlikely(pdev->num_resources != 3)) {
+	if ((pdev->num_resources != 3) && (pdev->num_resources != 2)) {
 		dev_err(&pdev->dev, "invalid number of resources\n");
 		return -EINVAL;
 	}
@@ -173,6 +179,11 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 		(ctl_res->flags == IORESOURCE_MEM));
 
 	/*
+	 * And the IRQ
+	 */
+	irq = platform_get_irq(pdev, 0);
+
+	/*
 	 * Now that that's out of the way, wire up the port..
 	 */
 	host = ata_host_alloc(&pdev->dev, 1);
@@ -185,6 +196,14 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	/*
+	 * Use polling mode if there's no IRQ
+	 */
+	if (irq < 0) {
+		ap->flags |= ATA_FLAG_PIO_POLLING;
+		ata_port_desc(ap, "no IRQ, using PIO polling");
+	}
+
+	/*
 	 * Handle the MMIO case
 	 */
 	if (mmio) {
@@ -213,9 +232,9 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 		      (unsigned long long)ctl_res->start);
 
 	/* activate */
-	return ata_host_activate(host, platform_get_irq(pdev, 0),
-				 ata_interrupt, pp_info ? pp_info->irq_flags
-				 : 0, &pata_platform_sht);
+	return ata_host_activate(host, irq, ata_interrupt,
+				 pp_info ? pp_info->irq_flags : 0,
+				 &pata_platform_sht);
 }
 
 /**
