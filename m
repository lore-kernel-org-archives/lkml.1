Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZA3XGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZA3XGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZA3XF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:05:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:53063 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbZA3XF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:05:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,354,1231142400"; 
   d="scan'208";a="105569550"
Subject: [PATCH] atmel-mci: fix initialization of dma slave data
To: hskinnemoen@atmel.com
From: Dan Williams <dan.j.williams@intel.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Date: Fri, 30 Jan 2009 16:05:57 -0700
Message-ID: <20090130230248.2402.65405.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion of atmel-mci to dma_request_channel missed the initialization
of the channel dma_slave information.  dma_request_channel, along with the
filter_fn, find the channel with the proper capabilities, then it is up to the
driver to update the dw_dma_chan with its slave data.

Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Haavard,

I do not have any conflicting dmaengine patches so feel free to carry
this through the avr32 tree.

Regards,
Dan

 drivers/dma/dw_dmac_regs.h   |   24 ------------------------
 drivers/mmc/host/atmel-mci.c |    1 +
 include/linux/dw_dmac.h      |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 00fdd18..10ffa5c 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -126,24 +126,6 @@ struct dw_dma_regs {
 
 #define DW_REGLEN		0x400
 
-struct dw_dma_chan {
-	struct dma_chan		chan;
-	void __iomem		*ch_regs;
-	u8			mask;
-
-	spinlock_t		lock;
-
-	/* these other elements are all protected by lock */
-	dma_cookie_t		completed;
-	struct list_head	active_list;
-	struct list_head	queue;
-	struct list_head	free_list;
-
-	struct dw_dma_slave	*dws;
-
-	unsigned int		descs_allocated;
-};
-
 static inline struct dw_dma_chan_regs __iomem *
 __dwc_regs(struct dw_dma_chan *dwc)
 {
@@ -155,12 +137,6 @@ __dwc_regs(struct dw_dma_chan *dwc)
 #define channel_writel(dwc, name, val) \
 	__raw_writel((val), &(__dwc_regs(dwc)->name))
 
-static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
-{
-	return container_of(chan, struct dw_dma_chan, chan);
-}
-
-
 struct dw_dma {
 	struct dma_device	dma;
 	void __iomem		*regs;
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 76bfe16..2a81d46 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1618,6 +1618,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
 		host->dma.chan = dma_request_channel(mask, filter, dws);
+		set_dw_dma_slave(host->dma.chan, dws);
 	}
 	if (!host->dma.chan)
 		dev_notice(&pdev->dev, "DMA not available, using PIO\n");
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index d797dde..799b6ef 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -54,6 +54,39 @@ struct dw_dma_slave {
 	u32			cfg_lo;
 };
 
+struct dw_dma_chan {
+	struct dma_chan		chan;
+	void __iomem		*ch_regs;
+	u8			mask;
+
+	spinlock_t		lock;
+
+	/* these other elements are all protected by lock */
+	dma_cookie_t		completed;
+	struct list_head	active_list;
+	struct list_head	queue;
+	struct list_head	free_list;
+
+	struct dw_dma_slave	*dws;
+
+	unsigned int		descs_allocated;
+};
+
+static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct dw_dma_chan, chan);
+}
+
+static inline void set_dw_dma_slave(struct dma_chan *chan, struct dw_dma_slave *dws)
+{
+	if (chan) {
+		struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+
+		dwc->dws = dws;
+	}
+}
+
+
 /* Platform-configurable bits in CFG_HI */
 #define DWC_CFGH_FCMODE		(1 << 0)
 #define DWC_CFGH_FIFO_MODE	(1 << 1)

