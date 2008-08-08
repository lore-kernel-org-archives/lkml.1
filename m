Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYHHPl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYHHPl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYHHPlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:41:51 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:49490 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbYHHPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:41:50 -0400
Date: Fri, 8 Aug 2008 17:41:44 +0200
From: Marc Zyngier <maz@misterjones.org>
To: Olav Kongas <ok@artecdesign.ee>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Let isp116x-hcd get IRQ flags from resource
Message-ID: <20080808174144.535e1612@not-of-this-earth.wild-wind.fr.eu.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, ok@artecdesign.ee
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Olav,

This patch let the isp116x-hcd driver obtain IRQ flags from its
IORESOURCE_IRQ resource if configured as such, much like it's been
done for the smc91x driver.

It spares people writing support for specific boards the burden to
configure the interrupt controller independantly, and keeps all IRQ
related information in a single resource.

Regards,

	M.

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index ce1ca0b..6eda6f9 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1562,10 +1562,10 @@ static int __devinit isp116x_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
 	struct isp116x *isp116x;
-	struct resource *addr, *data;
+	struct resource *addr, *data, *ires;
 	void __iomem *addr_reg;
 	void __iomem *data_reg;
-	int irq;
+	int irq, irq_flags;
 	int ret = 0;
 
 	if (pdev->num_resources < 3) {
@@ -1575,12 +1575,16 @@ static int __devinit isp116x_probe(struct platform_device *pdev)
 
 	data = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	addr = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	irq = platform_get_irq(pdev, 0);
-	if (!addr || !data || irq < 0) {
+	ires = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	if (!addr || !data || !ires) {
 		ret = -ENODEV;
 		goto err1;
 	}
 
+	irq = ires->start;
+	irq_flags = ires->flags & IRQF_TRIGGER_MASK;
+
 	if (pdev->dev.dma_mask) {
 		DBG("DMA not supported\n");
 		ret = -EINVAL;
@@ -1634,7 +1638,7 @@ static int __devinit isp116x_probe(struct platform_device *pdev)
 		goto err6;
 	}
 
-	ret = usb_add_hcd(hcd, irq, IRQF_DISABLED);
+	ret = usb_add_hcd(hcd, irq, irq_flags | IRQF_DISABLED);
 	if (ret)
 		goto err6;
 

-- 
A rat a day keeps the plague away.
