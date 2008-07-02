Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbYGBFF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbYGBFF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 01:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYGBFFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 01:05:18 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:20475 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753491AbYGBFFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 01:05:16 -0400
Date: Tue, 01 Jul 2008 23:05:15 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] EDAC: mpc85xx fix pci ofdev 2nd pass
Message-ID: <486b0c8b.KRCPDeIgRMakiRp7%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Dave Jiang <djiang@mvista.com>

Applied to linux-2.6.26-rc8-next-20080702

Converting PCI err device from platform to open firmware of_dev to comply with
powerpc schemes.

Repatched for linux-next

Signed-off-by:	Dave Jiang <djiang@mvista.com>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 mpc85xx_edac.c |   67 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff -Naurp 2.6.26-rc8.orig/drivers/edac/mpc85xx_edac.c 2.6.26-rc8/drivers/edac/mpc85xx_edac.c
--- 2.6.26-rc8.orig/drivers/edac/mpc85xx_edac.c	2008-06-30 15:41:02.000000000 -0700
+++ 2.6.26-rc8/drivers/edac/mpc85xx_edac.c	2008-06-30 15:33:34.000000000 -0700
@@ -195,14 +195,15 @@ static irqreturn_t mpc85xx_pci_isr(int i
 	return IRQ_HANDLED;
 }
 
-static int __devinit mpc85xx_pci_err_probe(struct platform_device *pdev)
+static int __devinit mpc85xx_pci_err_probe(struct of_device *op,
+					   const struct of_device_id *match)
 {
 	struct edac_pci_ctl_info *pci;
 	struct mpc85xx_pci_pdata *pdata;
-	struct resource *r;
+	struct resource r;
 	int res = 0;
 
-	if (!devres_open_group(&pdev->dev, mpc85xx_pci_err_probe, GFP_KERNEL))
+	if (!devres_open_group(&op->dev, mpc85xx_pci_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
 	pci = edac_pci_alloc_ctl_info(sizeof(*pdata), "mpc85xx_pci_err");
@@ -212,34 +213,37 @@ static int __devinit mpc85xx_pci_err_pro
 	pdata = pci->pvt_info;
 	pdata->name = "mpc85xx_pci_err";
 	pdata->irq = NO_IRQ;
-	platform_set_drvdata(pdev, pci);
-	pci->dev = &pdev->dev;
+ 	dev_set_drvdata(&op->dev, pci);
+ 	pci->dev = &op->dev;
 	pci->mod_name = EDAC_MOD_STR;
 	pci->ctl_name = pdata->name;
-	pci->dev_name = pdev->dev.bus_id;
+	pci->dev_name = op->dev.bus_id;
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		pci->edac_check = mpc85xx_pci_check;
 
 	pdata->edac_idx = edac_pci_idx++;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
+	res = of_address_to_resource(op->node, 0, &r);
+	if (res) {
 		printk(KERN_ERR "%s: Unable to get resource for "
 		       "PCI err regs\n", __func__);
 		goto err;
 	}
 
-	if (!devm_request_mem_region(&pdev->dev, r->start,
-				     r->end - r->start + 1, pdata->name)) {
+	/* we only need the error registers */
+	r.start += 0xe00;
+ 
+	if (!devm_request_mem_region(&op->dev, r.start,
+ 				     r.end - r.start + 1, pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
 		res = -EBUSY;
 		goto err;
 	}
 
-	pdata->pci_vbase = devm_ioremap(&pdev->dev, r->start,
-					r->end - r->start + 1);
+	pdata->pci_vbase = devm_ioremap(&op->dev, r.start,
+					r.end - r.start + 1);
 	if (!pdata->pci_vbase) {
 		printk(KERN_ERR "%s: Unable to setup PCI err regs\n", __func__);
 		res = -ENOMEM;
@@ -266,14 +270,15 @@ static int __devinit mpc85xx_pci_err_pro
 	}
 
 	if (edac_op_state == EDAC_OPSTATE_INT) {
-		pdata->irq = platform_get_irq(pdev, 0);
-		res = devm_request_irq(&pdev->dev, pdata->irq,
+		pdata->irq = irq_of_parse_and_map(op->node, 0);
+		res = devm_request_irq(&op->dev, pdata->irq,
 				       mpc85xx_pci_isr, IRQF_DISABLED,
 				       "[EDAC] PCI err", pci);
 		if (res < 0) {
 			printk(KERN_ERR
 			       "%s: Unable to requiest irq %d for "
 			       "MPC85xx PCI err\n", __func__, pdata->irq);
+			irq_dispose_mapping(pdata->irq);
 			res = -ENODEV;
 			goto err2;
 		}
@@ -282,23 +287,23 @@ static int __devinit mpc85xx_pci_err_pro
 		       pdata->irq);
 	}
 
-	devres_remove_group(&pdev->dev, mpc85xx_pci_err_probe);
+	devres_remove_group(&op->dev, mpc85xx_pci_err_probe);
 	debugf3("%s(): success\n", __func__);
 	printk(KERN_INFO EDAC_MOD_STR " PCI err registered\n");
 
 	return 0;
 
 err2:
-	edac_pci_del_device(&pdev->dev);
+	edac_pci_del_device(&op->dev);
 err:
 	edac_pci_free_ctl_info(pci);
-	devres_release_group(&pdev->dev, mpc85xx_pci_err_probe);
+	devres_release_group(&op->dev, mpc85xx_pci_err_probe);
 	return res;
 }
 
-static int mpc85xx_pci_err_remove(struct platform_device *pdev)
+static int mpc85xx_pci_err_remove(struct of_device *op)
 {
-	struct edac_pci_ctl_info *pci = platform_get_drvdata(pdev);
+	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
 
 	debugf0("%s()\n", __func__);
@@ -318,12 +323,26 @@ static int mpc85xx_pci_err_remove(struct
 	return 0;
 }
 
-static struct platform_driver mpc85xx_pci_err_driver = {
+static struct of_device_id mpc85xx_pci_err_of_match[] = {
+	{
+	 .compatible = "fsl,mpc8540-pcix",
+	 },
+	{
+	 .compatible = "fsl,mpc8540-pci",
+	},
+	{},
+};
+
+static struct of_platform_driver mpc85xx_pci_err_driver = {
+	.owner = THIS_MODULE,
+	.name = "mpc85xx_pci_err",
+	.match_table = mpc85xx_pci_err_of_match,
 	.probe = mpc85xx_pci_err_probe,
 	.remove = __devexit_p(mpc85xx_pci_err_remove),
 	.driver = {
-		.name = "mpc85xx_pci_err",
-	}
+		   .name = "mpc85xx_pci_err",
+		   .owner = THIS_MODULE,
+		   },
 };
 
 #endif				/* CONFIG_PCI */
@@ -1002,7 +1021,7 @@ static int __init mpc85xx_mc_init(void)
 		printk(KERN_WARNING EDAC_MOD_STR "L2 fails to register\n");
 
 #ifdef CONFIG_PCI
-	res = platform_driver_register(&mpc85xx_pci_err_driver);
+	res = of_register_platform_driver(&mpc85xx_pci_err_driver);
 	if (res)
 		printk(KERN_WARNING EDAC_MOD_STR "PCI fails to register\n");
 #endif
@@ -1025,7 +1044,7 @@ static void __exit mpc85xx_mc_exit(void)
 {
 	mtspr(SPRN_HID1, orig_hid1);
 #ifdef CONFIG_PCI
-	platform_driver_unregister(&mpc85xx_pci_err_driver);
+	of_unregister_platform_driver(&mpc85xx_pci_err_driver);
 #endif
 	of_unregister_platform_driver(&mpc85xx_l2_err_driver);
 	of_unregister_platform_driver(&mpc85xx_mc_err_driver);
