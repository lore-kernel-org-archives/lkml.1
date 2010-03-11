Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0CKIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:16:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38545 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0CKIQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:16:26 -0500
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
To: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, akpm@linux-foundation.org,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: [PATCH] davinci: MMC: Pass number of SG segments as platform data
Date: Thu, 11 Mar 2010 13:02:36 +0530
Message-Id: <1268292756-5369-1-git-send-email-sudhakar.raj@ti.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms like DM355, the number of EDMA parameter
slots available for EDMA_SLOT_ANY usage are few. In such cases,
if MMC/SD uses 16 slots for each instance of MMC controller,
then the number of slots available for other modules will be
very few.

By passing the number of EDMA slots to be used in MMC driver
from platform data, EDMA slots available for other purposes
can be controlled.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
---
 arch/arm/mach-davinci/include/mach/mmc.h |    3 +++
 drivers/mmc/host/davinci_mmc.c           |   22 +++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/mmc.h b/arch/arm/mach-davinci/include/mach/mmc.h
index 5a85e24..384fc0e 100644
--- a/arch/arm/mach-davinci/include/mach/mmc.h
+++ b/arch/arm/mach-davinci/include/mach/mmc.h
@@ -22,6 +22,9 @@ struct davinci_mmc_config {
 
 	/* Version of the MMC/SD controller */
 	u8	version;
+
+	/* Number of sg segments */
+	u32	nr_sg;
 };
 void davinci_setup_mmc(int module, struct davinci_mmc_config *config);
 
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 3bd0ba2..19c050c 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -137,15 +137,15 @@
 
 /*
  * One scatterlist dma "segment" is at most MAX_CCNT rw_threshold units,
- * and we handle up to NR_SG segments.  MMC_BLOCK_BOUNCE kicks in only
+ * and we handle up to MAX_NR_SG segments.  MMC_BLOCK_BOUNCE kicks in only
  * for drivers with max_hw_segs == 1, making the segments bigger (64KB)
- * than the page or two that's otherwise typical.  NR_SG == 16 gives at
- * least the same throughput boost, using EDMA transfer linkage instead
- * of spending CPU time copying pages.
+ * than the page or two that's otherwise typical. nr_sg (passed from
+ * platform data) == 16 gives at least the same throughput boost, using
+ * EDMA transfer linkage instead of spending CPU time copying pages.
  */
 #define MAX_CCNT	((1 << 16) - 1)
 
-#define NR_SG		16
+#define MAX_NR_SG	16
 
 static unsigned rw_threshold = 32;
 module_param(rw_threshold, uint, S_IRUGO);
@@ -192,7 +192,7 @@ struct mmc_davinci_host {
 	struct edmacc_param	tx_template;
 	struct edmacc_param	rx_template;
 	unsigned		n_link;
-	u32			links[NR_SG - 1];
+	u32			links[MAX_NR_SG - 1];
 
 	/* For PIO we walk scatterlists one segment at a time. */
 	unsigned int		sg_len;
@@ -202,6 +202,8 @@ struct mmc_davinci_host {
 	u8 version;
 	/* for ns in one cycle calculation */
 	unsigned ns_in_one_cycle;
+	/* Number of sg segments */
+	u32 nr_sg;
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 #endif
@@ -568,6 +570,7 @@ davinci_release_dma_channels(struct mmc_davinci_host *host)
 
 static int __init davinci_acquire_dma_channels(struct mmc_davinci_host *host)
 {
+	u32 link_size;
 	int r, i;
 
 	/* Acquire master DMA write channel */
@@ -593,7 +596,8 @@ static int __init davinci_acquire_dma_channels(struct mmc_davinci_host *host)
 	/* Allocate parameter RAM slots, which will later be bound to a
 	 * channel as needed to handle a scatterlist.
 	 */
-	for (i = 0; i < ARRAY_SIZE(host->links); i++) {
+	link_size = min_t(unsigned, host->nr_sg, ARRAY_SIZE(host->links));
+	for (i = 0; i < link_size; i++) {
 		r = edma_alloc_slot(EDMA_CTLR(host->txdma), EDMA_SLOT_ANY);
 		if (r < 0) {
 			dev_dbg(mmc_dev(host->mmc), "dma PaRAM alloc --> %d\n",
@@ -1202,6 +1206,10 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 
 	init_mmcsd_host(host);
 
+	host->nr_sg = pdata->nr_sg - 1;
+	if (host->nr_sg > MAX_NR_SG || host->nr_sg == 0)
+		host->nr_sg = MAX_NR_SG;
+
 	host->use_dma = use_dma;
 	host->irq = irq;
 
-- 
1.5.6

