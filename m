Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbZIORSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbZIORSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 13:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbZIORSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 13:18:16 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:41783 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757586AbZIORSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 13:18:15 -0400
Date: Tue, 15 Sep 2009 11:18:16 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com
Subject: [PATCH] TPM: Make tpm_tis always create a platform driver
Message-ID: <20090915171816.GJ25981@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets systems that don't use PNP to create a platform device and have the
tpm_tis driver bind to it. For embedded users.

Rework the force option to just create a platform device with the proper
resource information and use the usual binding mechanism to set it up.

Slightly rework the way interrupt auto detection happens to provide a -1 'do
not ever autodetect' input and use it to force off autodetection if PNP or
platform devices have no IRQ line.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_tis.c |   73 +++++++++++++++++++++++++++++---------------
 1 files changed, 48 insertions(+), 25 deletions(-)

Unfortunately I can only test the platform device path here, I don't
have a PC system that uses this driver to test the force option.

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 626dd4c..80db599 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -435,7 +435,7 @@ module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static int tpm_tis_init(struct device *dev, u32 start,
-			u32 len, unsigned int irq)
+			u32 len, int irq)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i;
@@ -507,9 +507,11 @@ static int tpm_tis_init(struct device *dev, u32 start,
 	iowrite32(intmask,
 		  chip->vendor.iobase +
 		  TPM_INT_ENABLE(chip->vendor.locality));
-	if (interrupts)
+	if (!interrupts)
+		irq = -1;
+	if (irq != -1)
 		chip->vendor.irq = irq;
-	if (interrupts && !chip->vendor.irq) {
+	if (irq == 0) {
 		chip->vendor.irq =
 		    ioread8(chip->vendor.iobase +
 			    TPM_INT_VECTOR(chip->vendor.locality));
@@ -594,15 +596,13 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 				      const struct pnp_device_id *pnp_id)
 {
 	u32 start, len;
-	unsigned int irq = 0;
+	int irq = -1;
 
 	start = pnp_mem_start(pnp_dev, 0);
 	len = pnp_mem_len(pnp_dev, 0);
 
 	if (pnp_irq_valid(pnp_dev, 0))
 		irq = pnp_irq(pnp_dev, 0);
-	else
-		interrupts = 0;
 
 	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
@@ -654,6 +654,30 @@ module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
 		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 
+static int force;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
+static struct platform_device *forced_pdev;
+static int __devinit tpm_tis_probe(struct platform_device *pdev)
+{
+	struct resource *mem;
+	struct resource *irqr;
+	int irq = -1;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
+
+	irqr = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (irqr)
+		irq = irqr->start;
+	else if (pdev == forced_pdev)
+		irq = 0;    /* Auto-detect interrupts. */
+
+	return tpm_tis_init(&pdev->dev, mem->start, (mem->end - mem->start+1),
+			    irq);
+}
+
 static int tpm_tis_suspend(struct platform_device *dev, pm_message_t msg)
 {
 	return tpm_pm_suspend(&dev->dev, msg);
@@ -668,30 +692,29 @@ static struct platform_driver tis_drv = {
 		.name = "tpm_tis",
 		.owner		= THIS_MODULE,
 	},
+	.probe = tpm_tis_probe,
 	.suspend = tpm_tis_suspend,
 	.resume = tpm_tis_resume,
 };
 
-static struct platform_device *pdev;
-
-static int force;
-module_param(force, bool, 0444);
-MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
 static int __init init_tis(void)
 {
 	int rc;
 
-	if (force) {
-		rc = platform_driver_register(&tis_drv);
-		if (rc < 0)
-			return rc;
-		if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
-			return PTR_ERR(pdev);
-		if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
-			platform_device_unregister(pdev);
-			platform_driver_unregister(&tis_drv);
-		}
+	rc = platform_driver_register(&tis_drv);
+	if (rc < 0)
 		return rc;
+
+	if (force) {
+		struct resource res[1] = {
+			{.start = TIS_MEM_BASE,
+			 .end = TIS_MEM_BASE + TIS_MEM_LEN - 1,
+			 .flags = IORESOURCE_MEM} };
+		forced_pdev = platform_device_register_simple("tpm_tis", -1,
+							      res, 1);
+		if (IS_ERR(forced_pdev))
+			return PTR_ERR(forced_pdev);
+		return 0;
 	}
 
 	return pnp_register_driver(&tis_pnp_driver);
@@ -719,10 +742,10 @@ static void __exit cleanup_tis(void)
 	}
 	spin_unlock(&tis_lock);
 
-	if (force) {
-		platform_device_unregister(pdev);
-		platform_driver_unregister(&tis_drv);
-	} else
+	if (forced_pdev)
+		platform_device_unregister(forced_pdev);
+	platform_driver_unregister(&tis_drv);
+	if (!force)
 		pnp_unregister_driver(&tis_pnp_driver);
 }
 
-- 
1.6.0.4

