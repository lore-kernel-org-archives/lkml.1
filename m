Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZJWP3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZJWP3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZJWP3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:29:50 -0400
Received: from mail.atmel.fr ([81.80.104.162]:38685 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752203AbZJWP3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:29:18 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-mmc@vger.kernel.org, haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3 v2] atmel-mci: change use of dma slave interface
Date: Fri, 23 Oct 2009 18:34:12 +0200
Message-Id: <acfa557032a93e2d3186981b16f7048a5a31028a.1256314995.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090930155557.7dae503b@hskinnemoen-d830>
References: <20090930155557.7dae503b@hskinnemoen-d830>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the use of another DMA controller driver in atmel-mci sd/mmc driver.
This adds a generic dma_slave pointer to the mci platform structure where
we can store DMA controller information.  In atmel-mci we use information
provided by this structure to initialize the driver (with new helper
functions that are architecture dependant).

This also adds at32/avr32 chip modifications to cope with this new access
method.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/include/mach/atmel-mci.h     |   24 ++++++++++
 arch/avr32/mach-at32ap/at32ap700x.c             |   18 +++++--
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h |   24 ++++++++++
 drivers/mmc/host/atmel-mci.c                    |   56 +++++++++++++++--------
 include/linux/atmel-mci.h                       |    4 +-
 5 files changed, 98 insertions(+), 28 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/atmel-mci.h
 create mode 100644 arch/avr32/mach-at32ap/include/mach/atmel-mci.h

diff --git a/arch/arm/mach-at91/include/mach/atmel-mci.h b/arch/arm/mach-at91/include/mach/atmel-mci.h
new file mode 100644
index 0000000..998cb0c
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/atmel-mci.h
@@ -0,0 +1,24 @@
+#ifndef __MACH_ATMEL_MCI_H
+#define __MACH_ATMEL_MCI_H
+
+#include <mach/at_hdmac.h>
+
+/**
+ * struct mci_dma_data - DMA data for MCI interface
+ */
+struct mci_dma_data {
+	struct at_dma_slave	sdata;
+};
+
+/* accessor macros */
+#define	slave_data_ptr(s)	(&(s)->sdata)
+#define find_slave_dev(s)	((s)->sdata.dma_dev)
+
+#define	setup_dma_addr(s, t, r)	do {		\
+	if (s) {				\
+		(s)->sdata.tx_reg = (t);	\
+		(s)->sdata.rx_reg = (r);	\
+	}					\
+} while (0)
+
+#endif /* __MACH_ATMEL_MCI_H */
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index eb9d4dc..b40ff39 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -15,6 +15,8 @@
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
+
+#include <mach/atmel-mci.h>
 #include <linux/atmel-mci.h>
 
 #include <asm/io.h>
@@ -1320,7 +1322,7 @@ struct platform_device *__init
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct platform_device		*pdev;
-	struct dw_dma_slave		*dws = &data->dma_slave;
+	struct mci_dma_slave		*slave;
 	u32				pioa_mask;
 	u32				piob_mask;
 
@@ -1339,13 +1341,17 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 				ARRAY_SIZE(atmel_mci0_resource)))
 		goto fail;
 
-	dws->dma_dev = &dw_dmac0_device.dev;
-	dws->reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
-	dws->cfg_hi = (DWC_CFGH_SRC_PER(0)
+	slave = kzalloc(sizeof(struct mci_dma_slave), GFP_KERNEL);
+
+	slave->sdata.dma_dev = &dw_dmac0_device.dev;
+	slave->sdata.reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
+	slave->sdata.cfg_hi = (DWC_CFGH_SRC_PER(0)
 				| DWC_CFGH_DST_PER(1));
-	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL
+	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
 				| DWC_CFGL_HS_SRC_POL);
 
+	data->dma_slave = slave;
+
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct mci_platform_data)))
 		goto fail;
@@ -1411,6 +1417,8 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 	return pdev;
 
 fail:
+	data->dma_slave = NULL;
+	kfree(slave);
 	platform_device_put(pdev);
 	return NULL;
 }
diff --git a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
new file mode 100644
index 0000000..a9b3896
--- /dev/null
+++ b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
@@ -0,0 +1,24 @@
+#ifndef __MACH_ATMEL_MCI_H
+#define __MACH_ATMEL_MCI_H
+
+#include <linux/dw_dmac.h>
+
+/**
+ * struct mci_dma_data - DMA data for MCI interface
+ */
+struct mci_dma_data {
+	struct dw_dma_slave	sdata;
+};
+
+/* accessor macros */
+#define	slave_data_ptr(s)	(&(s)->sdata)
+#define find_slave_dev(s)	((s)->sdata.dma_dev)
+
+#define	setup_dma_addr(s, t, r)	do {		\
+	if (s) {				\
+		(s)->sdata.tx_reg = (t);	\
+		(s)->sdata.rx_reg = (r);	\
+	}					\
+} while (0)
+
+#endif /* __MACH_ATMEL_MCI_H */
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fc25586..ba8b219 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -25,6 +25,8 @@
 #include <linux/stat.h>
 
 #include <linux/mmc/host.h>
+
+#include <mach/atmel-mci.h>
 #include <linux/atmel-mci.h>
 
 #include <asm/io.h>
@@ -1584,14 +1586,43 @@ static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot,
 #ifdef CONFIG_MMC_ATMELMCI_DMA
 static bool filter(struct dma_chan *chan, void *slave)
 {
-	struct dw_dma_slave *dws = slave;
+	struct mci_dma_data	*sl = slave;
 
-	if (dws->dma_dev == chan->device->dev) {
-		chan->private = dws;
+	if (sl && find_slave_dev(sl) == chan->device->dev) {
+		chan->private = slave_data_ptr(sl);
 		return true;
-	} else
+	} else {
 		return false;
+	}
 }
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
+		setup_dma_addr(pdata->dma_slave,
+			       host->mapbase + MCI_TDR,
+			       host->mapbase + MCI_RDR);
+
+		/* Try to grab a DMA channel */
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_SLAVE, mask);
+		host->dma.chan =
+			dma_request_channel(mask, filter, pdata->dma_slave);
+	}
+	if (!host->dma.chan)
+		dev_notice(&host->pdev->dev, "DMA not available, using PIO\n");
+}
+#else
+static void atmci_configure_dma(struct atmel_mci *host) {}
 #endif
 
 static int __init atmci_probe(struct platform_device *pdev)
@@ -1645,22 +1676,7 @@ static int __init atmci_probe(struct platform_device *pdev)
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
index 57b1846..3e09b34 100644
--- a/include/linux/atmel-mci.h
+++ b/include/linux/atmel-mci.h
@@ -3,8 +3,6 @@
 
 #define ATMEL_MCI_MAX_NR_SLOTS	2
 
-#include <linux/dw_dmac.h>
-
 /**
  * struct mci_slot_pdata - board-specific per-slot configuration
  * @bus_width: Number of data lines wired up the slot
@@ -34,7 +32,7 @@ struct mci_slot_pdata {
  * @slot: Per-slot configuration data.
  */
 struct mci_platform_data {
-	struct dw_dma_slave	dma_slave;
+	struct mci_dma_data	*dma_slave;
 	struct mci_slot_pdata	slot[ATMEL_MCI_MAX_NR_SLOTS];
 };
 
-- 
1.5.6.5

