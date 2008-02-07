Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbYBGO3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbYBGO3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYBGO3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:29:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:49579 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYBGO3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:29:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YXD2cF6W+gFIpCYTUzG3L2S2g5/DnOkaGoQkcaE1MONiwcu36jQB+O0FwwKpEhnSeFoWMWZqpuOyzqM1Ze1e4s+nc2ZjN1Fsdl0mmdZMEsH1c7GsvcNQZ+OIKdmIiKOTfdo86c9Mg112FxPKwWTAMfyUi2Cc9BKLZJCSoWESqT8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] palm_bk3710: ide_register_hw() -> ide_device_add()
Date: Thu, 7 Feb 2008 15:41:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Anton Salnikov <asalnikov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071541.22374.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Convert palm_bk3710 host driver to use ide_device_add() instead of
  ide_register_hw() (while at it drop doing "ide_unregister()" loop which
  tries to unregister _all_ IDE interfaces if useable ide_hwifs[] slot
  cannot be find).

  [ identical change as done to bast-ide/ide-cs/delkin_cb host drivers
    by commit 9e016a719209d95338e314b46c3012cc7feaaeec ]

* Rename 'ide_ctlr_info' to 'hw' and 'index' to 'i' while at it.

Cc: Anton Salnikov <asalnikov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
this patch series applies some recent IDE changes (post 2.6.24)
to palm_bk3710 so it matches other IDE host drivers

 drivers/ide/arm/palm_bk3710.c |   45 +++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -313,13 +313,13 @@ static void __devinit palm_bk3710_chipin
 }
 static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 {
-	hw_regs_t ide_ctlr_info;
-	int index = 0;
-	int pribase;
 	struct clk *clkp;
 	struct resource *mem, *irq;
 	ide_hwif_t *hwif;
 	void __iomem *base;
+	int pribase, i;
+	hw_regs_t hw;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	clkp = clk_get(NULL, "IDECLK");
 	if (IS_ERR(clkp))
@@ -330,7 +330,7 @@ static int __devinit palm_bk3710_probe(s
 	ide_palm_clk = clk_get_rate(ideclkp)/100000;
 	ide_palm_clk = (10000/ide_palm_clk) + 1;
 	/* Register the IDE interface with Linux ATA Interface */
-	memset(&ide_ctlr_info, 0, sizeof(ide_ctlr_info));
+	memset(&hw, 0, sizeof(hw));
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL) {
@@ -349,17 +349,33 @@ static int __devinit palm_bk3710_probe(s
 	palm_bk3710_chipinit(base);
 
 	pribase = mem->start + IDE_PALM_ATA_PRI_REG_OFFSET;
-	for (index = 0; index < IDE_NR_PORTS - 2; index++)
-		ide_ctlr_info.io_ports[index] = pribase + index;
-	ide_ctlr_info.io_ports[IDE_CONTROL_OFFSET] = mem->start +
+	for (i = 0; i < IDE_NR_PORTS - 2; i++)
+		hw.io_ports[i] = pribase + i;
+	hw.io_ports[IDE_CONTROL_OFFSET] = mem->start +
 			IDE_PALM_ATA_PRI_CTL_OFFSET;
-	ide_ctlr_info.irq = irq->start;
-	ide_ctlr_info.chipset = ide_palm3710;
+	hw.irq = irq->start;
+	hw.chipset = ide_palm3710;
 
-	if (ide_register_hw(&ide_ctlr_info, NULL, &hwif) < 0) {
-		printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
-		return -ENODEV;
-	}
+	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	if (hwif == NULL)
+		goto out;
+
+	i = hwif->index;
+
+	if (hwif->present)
+		ide_unregister(i, 0, 1);
+	else if (!hwif->hold)
+		ide_init_port_data(hwif, i);
+
+	ide_init_port_hw(hwif, &hw);
+	hwif->quirkproc = NULL;
+
+	idx[0] = i;
+
+	ide_device_add(idx, NULL);
+
+	if (!hwif->present)
+		goto out;
 
 	hwif->set_pio_mode = &palm_bk3710_set_pio_mode;
 	hwif->set_dma_mode = &palm_bk3710_set_dma_mode;
@@ -375,6 +391,9 @@ static int __devinit palm_bk3710_probe(s
 	ide_setup_dma(hwif, mem->start);
 
 	return 0;
+out:
+	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
+	return -ENODEV;
 }
 
 static struct platform_driver platform_bk_driver = {
