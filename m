Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbYF0S0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbYF0S0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759082AbYF0SZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:25:50 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11697 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753304AbYF0SZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:25:49 -0400
Date: Fri, 27 Jun 2008 12:13:53 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 13/13] EDAC mv64x60 add pci fixup
Message-ID: <48652de1.0FvaYuYNBPqHXodM%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup of missing bit 0 on 64360 PCIx_ERR_MASK and errata FEr-#11 and FEr-#16
for the 64460. Bit 0 must remain 0.

Signed-off-by: Dave Jiang <djiang@mvista.com>

Index: 2.6.26-rc5-mm3/drivers/edac/mv64x60_edac.c
===================================================================
--- 2.6.26-rc5-mm3.orig/drivers/edac/mv64x60_edac.c
+++ 2.6.26-rc5-mm3/drivers/edac/mv64x60_edac.c
@@ -71,6 +71,35 @@ static irqreturn_t mv64x60_pci_isr(int i
 	return IRQ_HANDLED;
 }
 
+/*
+ * Bit 0 of MV64x60_PCIx_ERR_MASK does not exist on the 64360 and because of
+ * errata FEr-#11 and FEr-##16 for the 64460, it should be 0 on that chip as
+ * well.  IOW, don't set bit 0.
+ */
+
+/* Erratum FEr PCI-#16: clear bit 0 of PCI SERRn Mask reg. */
+static int __init mv64x60_pci_fixup(struct platform_device *pdev)
+{
+	struct resource *r;
+	void __iomem *pci_serr;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!r) {
+		printk(KERN_ERR "%s: Unable to get resource for "
+		       "PCI err regs\n", __func__);
+		return -ENOENT;
+	}
+
+	pci_serr = ioremap(r->start, r->end - r->start + 1);
+	if (!pci_serr)
+		return -ENOMEM;
+
+	out_le32(pci_serr, in_le32(pci_serr) & ~0x1);
+	iounmap(pci_serr);
+
+	return 0;
+}
+
 static int __devinit mv64x60_pci_err_probe(struct platform_device *pdev)
 {
 	struct edac_pci_ctl_info *pci;
@@ -128,6 +157,12 @@ static int __devinit mv64x60_pci_err_pro
 		goto err;
 	}
 
+	res = mv64x60_pci_fixup(pdev);
+	if (res < 0) {
+		printk(KERN_ERR "%s: PCI fixup failed\n", __func__);
+		goto err;
+	}
+
 	out_le32(pdata->pci_vbase + MV64X60_PCI_ERROR_CAUSE, 0);
 	out_le32(pdata->pci_vbase + MV64X60_PCI_ERROR_MASK, 0);
 	out_le32(pdata->pci_vbase + MV64X60_PCI_ERROR_MASK,
