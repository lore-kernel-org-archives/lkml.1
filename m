Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbYBMHH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbYBMHH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYBMHHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:07:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:13198 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbYBMHHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:07:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,344,1199692800"; 
   d="scan'208";a="517684962"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/4] iop-adma: remove the workaround for missed interrupts on
	iop3xx
To: linux-kernel@vger.kernel.org
Cc: hskinnemoen@atmel.com, shannon.nelson@intel.com, olof@lixom.net,
       yur@emcraft.com
Date: Wed, 13 Feb 2008 00:03:14 -0700
Message-ID: <20080213070313.793.21980.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com>
References: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This workaround was covering the dependency submission bug in async_tx.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/iop-adma.c                 |    5 -----
 include/asm-arm/arch-iop13xx/adma.h    |    5 -----
 include/asm-arm/hardware/iop3xx-adma.h |    8 --------
 include/asm-arm/hardware/iop_adma.h    |    2 --
 4 files changed, 0 insertions(+), 20 deletions(-)


diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 1cb4284..821bd17 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -255,8 +255,6 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 
 	BUG_ON(!seen_current);
 
-	iop_chan_idle(busy, iop_chan);
-
 	if (cookie > 0) {
 		iop_chan->completed_cookie = cookie;
 		pr_debug("\tcompleted cookie %d\n", cookie);
@@ -1226,9 +1224,6 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&iop_chan->lock);
-	init_timer(&iop_chan->cleanup_watchdog);
-	iop_chan->cleanup_watchdog.data = (unsigned long) iop_chan;
-	iop_chan->cleanup_watchdog.function = iop_adma_tasklet;
 	INIT_LIST_HEAD(&iop_chan->chain);
 	INIT_LIST_HEAD(&iop_chan->all_slots);
 	INIT_RCU_HEAD(&iop_chan->common.rcu);
diff --git a/include/asm-arm/arch-iop13xx/adma.h b/include/asm-arm/arch-iop13xx/adma.h
index efd9a5e..90d14ee 100644
--- a/include/asm-arm/arch-iop13xx/adma.h
+++ b/include/asm-arm/arch-iop13xx/adma.h
@@ -454,11 +454,6 @@ static inline void iop_chan_append(struct iop_adma_chan *chan)
 	__raw_writel(adma_accr, ADMA_ACCR(chan));
 }
 
-static inline void iop_chan_idle(int busy, struct iop_adma_chan *chan)
-{
-	do { } while (0);
-}
-
 static inline u32 iop_chan_get_status(struct iop_adma_chan *chan)
 {
 	return __raw_readl(ADMA_ACSR(chan));
diff --git a/include/asm-arm/hardware/iop3xx-adma.h b/include/asm-arm/hardware/iop3xx-adma.h
index 5c529e6..84d635b 100644
--- a/include/asm-arm/hardware/iop3xx-adma.h
+++ b/include/asm-arm/hardware/iop3xx-adma.h
@@ -767,20 +767,12 @@ static inline int iop_desc_get_zero_result(struct iop_adma_desc_slot *desc)
 static inline void iop_chan_append(struct iop_adma_chan *chan)
 {
 	u32 dma_chan_ctrl;
-	/* workaround dropped interrupts on 3xx */
-	mod_timer(&chan->cleanup_watchdog, jiffies + msecs_to_jiffies(3));
 
 	dma_chan_ctrl = __raw_readl(DMA_CCR(chan));
 	dma_chan_ctrl |= 0x2;
 	__raw_writel(dma_chan_ctrl, DMA_CCR(chan));
 }
 
-static inline void iop_chan_idle(int busy, struct iop_adma_chan *chan)
-{
-	if (!busy)
-		del_timer(&chan->cleanup_watchdog);
-}
-
 static inline u32 iop_chan_get_status(struct iop_adma_chan *chan)
 {
 	return __raw_readl(DMA_CSR(chan));
diff --git a/include/asm-arm/hardware/iop_adma.h b/include/asm-arm/hardware/iop_adma.h
index ca8e71f..cb7e361 100644
--- a/include/asm-arm/hardware/iop_adma.h
+++ b/include/asm-arm/hardware/iop_adma.h
@@ -51,7 +51,6 @@ struct iop_adma_device {
  * @common: common dmaengine channel object members
  * @last_used: place holder for allocation to continue from where it left off
  * @all_slots: complete domain of slots usable by the channel
- * @cleanup_watchdog: workaround missed interrupts on iop3xx
  * @slots_allocated: records the actual size of the descriptor slot pool
  * @irq_tasklet: bottom half where iop_adma_slot_cleanup runs
  */
@@ -65,7 +64,6 @@ struct iop_adma_chan {
 	struct dma_chan common;
 	struct iop_adma_desc_slot *last_used;
 	struct list_head all_slots;
-	struct timer_list cleanup_watchdog;
 	int slots_allocated;
 	struct tasklet_struct irq_tasklet;
 };

