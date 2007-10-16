Return-Path: <linux-kernel-owner+w=401wt.eu-S1765661AbXJPIuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765661AbXJPIuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759660AbXJPIuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:50:06 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:12417 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbXJPIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:50:04 -0400
X-IronPort-AV: i="4.21,282,1188792000"; 
   d="scan'208"; a="54099973:sNHT32782673"
Subject: [PATCH] Update libata driver for bf548 atapi controller against
	the 2.6.24 tree.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Cc: bzolnier@gmail.com
Content-Type: text/plain
Date: Tue, 16 Oct 2007 16:43:27 +0800
Message-Id: <1192524207.11166.1.camel@sevens.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:
1. Remove irq_ack() and port_disable() methods
2. Acocomodate for the libata-link patches
3. Change Kconfig ATAPI mode option into a module param.
4. Add supported WMDMA mode.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/ata/Kconfig      |    7 ----
 drivers/ata/pata_bf54x.c |   77 ++++++++++++++++++++++------------------------
 2 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 33f5eb0..c0ea83d 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -641,11 +641,4 @@ config PATA_BF54X
 
 	  If unsure, say N.
 
-config PATA_BF54X_DMA
-	bool "DMA mode"
-	depends on PATA_BF54X
-	default y
-	help
-	  Enable DMA mode for Blackfin ATAPI controller.
-
 endif # ATA
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 747549e..b5e3842 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1092,14 +1092,15 @@ static unsigned int bfin_bus_softreset(struct ata_port *ap,
  *	Note: Original code is ata_std_softreset().
  */
 
-static int bfin_std_softreset(struct ata_port *ap, unsigned int *classes,
+static int bfin_std_softreset(struct ata_link *link, unsigned int *classes,
 		unsigned long deadline)
 {
+	struct ata_port *ap = link->ap;
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
 	unsigned int devmask = 0, err_mask;
 	u8 err;
 
-	if (ata_port_offline(ap)) {
+	if (ata_link_offline(link)) {
 		classes[0] = ATA_DEV_NONE;
 		goto out;
 	}
@@ -1122,9 +1123,11 @@ static int bfin_std_softreset(struct ata_port *ap, unsigned int *classes,
 	}
 
 	/* determine by signature whether we have ATA or ATAPI devices */
-	classes[0] = ata_dev_try_classify(ap, 0, &err);
+	classes[0] = ata_dev_try_classify(&ap->link.device[0],
+				devmask & (1 << 0), &err);
 	if (slave_possible && err != 0x81)
-		classes[1] = ata_dev_try_classify(ap, 1, &err);
+		classes[1] = ata_dev_try_classify(&ap->link.device[1],
+					devmask & (1 << 1), &err);
 
  out:
 	return 0;
@@ -1167,7 +1170,7 @@ static unsigned char bfin_bmdma_status(struct ata_port *ap)
 static void bfin_data_xfer(struct ata_device *adev, unsigned char *buf,
 			   unsigned int buflen, int write_data)
 {
-	struct ata_port *ap = adev->ap;
+	struct ata_port *ap = adev->link->ap;
 	unsigned int words = buflen >> 1;
 	unsigned short *buf16 = (u16 *) buf;
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
@@ -1206,7 +1209,10 @@ static void bfin_irq_clear(struct ata_port *ap)
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 
 	pr_debug("in atapi irq clear\n");
-	ATAPI_SET_INT_STATUS(base, 0x1FF);
+
+	ATAPI_SET_INT_STATUS(base, ATAPI_GET_INT_STATUS(base)|ATAPI_DEV_INT
+		| MULTI_DONE_INT | UDMAIN_DONE_INT | UDMAOUT_DONE_INT
+		| MULTI_TERM_INT | UDMAIN_TERM_INT | UDMAOUT_TERM_INT);
 }
 
 /**
@@ -1234,33 +1240,6 @@ static unsigned char bfin_irq_on(struct ata_port *ap)
 }
 
 /**
- *	bfin_irq_ack - Acknowledge a device interrupt.
- *	@ap: Port on which interrupts are enabled.
- *
- *	Note: Original code is ata_irq_ack().
- */
-
-static unsigned char bfin_irq_ack(struct ata_port *ap, unsigned int chk_drq)
-{
-	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
-	unsigned int bits = chk_drq ? ATA_BUSY | ATA_DRQ : ATA_BUSY;
-	unsigned char status;
-
-	pr_debug("in atapi irq ack\n");
-	status = ata_busy_wait(ap, bits, 1000);
-	if (status & bits)
-		if (ata_msg_err(ap))
-			dev_err(ap->dev, "abnormal status 0x%X\n", status);
-
-	/* get controller status; clear intr, err bits */
-	ATAPI_SET_INT_STATUS(base, ATAPI_GET_INT_STATUS(base)|ATAPI_DEV_INT
-		| MULTI_DONE_INT | UDMAIN_DONE_INT | UDMAOUT_DONE_INT
-		| MULTI_TERM_INT | UDMAIN_TERM_INT | UDMAOUT_TERM_INT);
-
-	return bfin_bmdma_status(ap);
-}
-
-/**
  *	bfin_bmdma_freeze - Freeze DMA controller port
  *	@ap: port to freeze
  *
@@ -1308,8 +1287,9 @@ void bfin_bmdma_thaw(struct ata_port *ap)
  *	Note: Original code is ata_std_postreset().
  */
 
-static void bfin_std_postreset(struct ata_port *ap, unsigned int *classes)
+static void bfin_std_postreset(struct ata_link *link, unsigned int *classes)
 {
+	struct ata_port *ap = link->ap;
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 
 	/* re-enable interrupts */
@@ -1395,7 +1375,6 @@ static struct scsi_host_template bfin_sht = {
 };
 
 static const struct ata_port_operations bfin_pata_ops = {
-	.port_disable		= ata_port_disable,
 	.set_piomode		= bfin_set_piomode,
 	.set_dmamode		= bfin_set_dmamode,
 
@@ -1423,7 +1402,6 @@ static const struct ata_port_operations bfin_pata_ops = {
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= bfin_irq_clear,
 	.irq_on			= bfin_irq_on,
-	.irq_ack		= bfin_irq_ack,
 
 	.port_start		= bfin_port_start,
 	.port_stop		= bfin_port_stop,
@@ -1437,11 +1415,7 @@ static struct ata_port_info bfin_port_info[] = {
 				| ATA_FLAG_NO_LEGACY,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0,
-#ifdef CONFIG_PATA_BF54X_DMA
-		.udma_mask	= ATA_UDMA5,
-#else
 		.udma_mask	= 0,
-#endif
 		.port_ops	= &bfin_pata_ops,
 	},
 };
@@ -1607,9 +1581,25 @@ static struct platform_driver bfin_atapi_driver = {
 	},
 };
 
+#define ATAPI_MODE_SIZE		10
+static char bfin_atapi_mode[ATAPI_MODE_SIZE];
+
 static int __init bfin_atapi_init(void)
 {
 	pr_info("register bfin atapi driver\n");
+
+	switch(bfin_atapi_mode[0]) {
+	case 'p':
+	case 'P':
+		break;
+	case 'm':
+	case 'M':
+		bfin_port_info[0].mwdma_mask = ATA_MWDMA2;
+		break;
+	default:
+		bfin_port_info[0].udma_mask = ATA_UDMA5;
+	};
+
 	return platform_driver_register(&bfin_atapi_driver);
 }
 
@@ -1620,6 +1610,13 @@ static void __exit bfin_atapi_exit(void)
 
 module_init(bfin_atapi_init);
 module_exit(bfin_atapi_exit);
+/*
+ * ATAPI mode:
+ * pio/PIO
+ * udma/UDMA (default)
+ * mwdma/MWDMA
+ */
+module_param_string(bfin_atapi_mode, bfin_atapi_mode, ATAPI_MODE_SIZE, 0);
 
 MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
 MODULE_DESCRIPTION("PATA driver for blackfin 54x ATAPI controller");
-- 
1.5.1.3


