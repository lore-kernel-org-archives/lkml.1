Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZIQPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZIQPZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZIQPZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:25:40 -0400
Received: from mail.atmel.fr ([81.80.104.162]:35164 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbZIQPZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:25:39 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       kernel@avr32linux.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] atmel-mci: change use of dma slave interface
Date: Thu, 17 Sep 2009 18:29:26 +0200
Message-Id: <1253204967-30010-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1253204967-30010-1-git-send-email-nicolas.ferre@atmel.com>
References: <1253204967-30010-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the use of another DMA controller driver in atmel-mci sd/mmc driver. This
adds a generic dma_slave pointer to the mci platform structure where we can
store DMA controller information. In atmel-mci we use information provided by
this structure to initialize the driver (with new helper functions that are
architecture dependant).
This also adds at32/avr32 chip modifications to cope with this new access
method.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    6 ++-
 drivers/mmc/host/atmel-mci.c        |   82 ++++++++++++++++++++++++++---------
 include/linux/atmel-mci.h           |    3 +-
 3 files changed, 68 insertions(+), 23 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index eb9d4dc..d1fe145 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1320,7 +1320,7 @@ struct platform_device *__init
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct platform_device		*pdev;
-	struct dw_dma_slave		*dws = &data->dma_slave;
+	struct dw_dma_slave		*dws;
 	u32				pioa_mask;
 	u32				piob_mask;
 
@@ -1339,6 +1339,8 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 				ARRAY_SIZE(atmel_mci0_resource)))
 		goto fail;
 
+	dws = kzalloc(sizeof(struct dw_dma_slave), GFP_KERNEL);
+
 	dws->dma_dev = &dw_dmac0_device.dev;
 	dws->reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
 	dws->cfg_hi = (DWC_CFGH_SRC_PER(0)
@@ -1346,6 +1348,8 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL
 				| DWC_CFGL_HS_SRC_POL);
 
+	data->dma_slave = dws;
+
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct mci_platform_data)))
 		goto fail;
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 065fa81..1689396 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1575,16 +1575,71 @@ static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot,
 }
 
 #ifdef CONFIG_MMC_ATMELMCI_DMA
-static bool filter(struct dma_chan *chan, void *slave)
+static struct device *find_slave_dev(void *slave)
+{
+	if (!slave)
+		return NULL;
+
+	if (cpu_is_at32ap7000())
+		return ((struct dw_dma_slave *)slave)->dma_dev;
+	else
+		return ((struct at_dma_slave *)slave)->dma_dev;
+}
+
+static void setup_dma_addr(struct mci_platform_data *pdata,
+			dma_addr_t tx_addr, dma_addr_t rx_addr)
 {
-	struct dw_dma_slave *dws = slave;
+	if (!pdata)
+		return;
+
+	if (cpu_is_at32ap7000()) {
+		struct dw_dma_slave *dws = pdata->dma_slave;
+
+		dws->tx_reg = tx_addr;
+		dws->rx_reg = rx_addr;
+	} else {
+		struct at_dma_slave *ats = pdata->dma_slave;
 
-	if (dws->dma_dev == chan->device->dev) {
-		chan->private = dws;
+		ats->tx_reg = tx_addr;
+		ats->rx_reg = rx_addr;
+	}
+}
+
+static bool filter(struct dma_chan *chan, void *slave)
+{
+	if (find_slave_dev(slave) == chan->device->dev) {
+		chan->private = slave;
 		return true;
-	} else
+	} else {
 		return false;
+	}
+}
+
+static void atmci_configure_dma(struct atmel_mci *host)
+{
+	struct mci_platform_data	*pdata;
+
+	if (host == NULL)
+		return;
+
+	pdata = host->pdev->dev.platform_data;
+
+	if (pdata && find_slave_dev(pdata->dma_slave)) {
+		dma_cap_mask_t mask;
+
+		setup_dma_addr(pdata, host->mapbase + MCI_TDR,
+				      host->mapbase + MCI_RDR);
+
+		/* Try to grab a DMA channel */
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_SLAVE, mask);
+		host->dma.chan = dma_request_channel(mask, filter, pdata->dma_slave);
+	}
+	if (!host->dma.chan)
+		dev_notice(&host->pdev->dev, "DMA not available, using PIO\n");
 }
+#else
+static void atmci_configure_dma(struct atmel_mci *host) {}
 #endif
 
 static int __init atmci_probe(struct platform_device *pdev)
@@ -1638,22 +1693,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_request_irq;
 
-#ifdef CONFIG_MMC_ATMELMCI_DMA
-	if (pdata->dma_slave.dma_dev) {
-		struct dw_dma_slave *dws = &pdata->dma_slave;
-		dma_cap_mask_t mask;
-
-		dws->tx_reg = regs->start + MCI_TDR;
-		dws->rx_reg = regs->start + MCI_RDR;
-
-		/* Try to grab a DMA channel */
-		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
-		host->dma.chan = dma_request_channel(mask, filter, dws);
-	}
-	if (!host->dma.chan)
-		dev_notice(&pdev->dev, "DMA not available, using PIO\n");
-#endif /* CONFIG_MMC_ATMELMCI_DMA */
+	atmci_configure_dma(host);
 
 	platform_set_drvdata(pdev, host);
 
diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
index 57b1846..e26b7de 100644
--- a/include/linux/atmel-mci.h
+++ b/include/linux/atmel-mci.h
@@ -4,6 +4,7 @@
 #define ATMEL_MCI_MAX_NR_SLOTS	2
 
 #include <linux/dw_dmac.h>
+#include <mach/at_hdmac.h>
 
 /**
  * struct mci_slot_pdata - board-specific per-slot configuration
@@ -34,7 +35,7 @@ struct mci_slot_pdata {
  * @slot: Per-slot configuration data.
  */
 struct mci_platform_data {
-	struct dw_dma_slave	dma_slave;
+	void			*dma_slave;
 	struct mci_slot_pdata	slot[ATMEL_MCI_MAX_NR_SLOTS];
 };
 
-- 
1.5.6.5

