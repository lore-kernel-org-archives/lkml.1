Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZAaQ0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZAaQ0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 11:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZAaQ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 11:26:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:29133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbZAaQ0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 11:26:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,356,1231142400"; 
   d="scan'208";a="427047268"
Subject: Re: [PATCH] atmel-mci: fix initialization of dma slave data
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>,
       "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090131.235230.90118475.anemo@mba.ocn.ne.jp>
References: <20090130230248.2402.65405.stgit@dwillia2-linux.ch.intel.com>
	 <20090131.210651.126573837.anemo@mba.ocn.ne.jp>
	 <20090131.235230.90118475.anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 09:26:43 -0700
Message-Id: <1233419203.5959.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: atmel-mci: fix initialization of dma slave data

From: Dan Williams <dan.j.williams@intel.com>

The conversion of atmel-mci to dma_request_channel missed the
initialization of the channel dma_slave information.  The filter_fn
passed to dma_request_channel is responsible for initializing the
channel's private data.  This implementation has the additional benefit
of enabling a generic client-channel data passing mechanism.

Reviewed-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
On Sat, 2009-01-31 at 07:52 -0700, Atsushi Nemoto wrote: 
> > Thanks.  This patch disclose struct dw_dma_chan to its client.  But
> > the struct seems too private for me.  Maybe we need some generic
> > method to pass slave information?  Any idea or plan?
> 
> Also, it seems too late to initialize dwc->dws after returning from
> dma_request_channel().  The alloc_chan_resources routine of dw_dmac
> driver needs dmc->dws and it is called from dma_request_channel() via
> dma_chan_get().

Thanks for the review Atsushi, much appreciated.  I thought the
Reviewed-by tag was appropriate.

 drivers/dma/dmaengine.c      |    2 ++
 drivers/dma/dw_dmac.c        |    5 ++---
 drivers/dma/dw_dmac_regs.h   |    2 --
 drivers/mmc/host/atmel-mci.c |    5 +++--
 include/linux/dmaengine.h    |    2 ++
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index a589930..280a9d2 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -518,6 +518,7 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 				       dma_chan_name(chan), err);
 			else
 				break;
+			chan->private = NULL;
 			chan = NULL;
 		}
 	}
@@ -536,6 +537,7 @@ void dma_release_channel(struct dma_chan *chan)
 	WARN_ONCE(chan->client_count != 1,
 		  "chan reference count %d != 1\n", chan->client_count);
 	dma_chan_put(chan);
+	chan->private = NULL;
 	mutex_unlock(&dma_list_mutex);
 }
 EXPORT_SYMBOL_GPL(dma_release_channel);
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 6b702cc..a97c07e 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -560,7 +560,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned long flags)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
-	struct dw_dma_slave	*dws = dwc->dws;
+	struct dw_dma_slave	*dws = chan->private;
 	struct dw_desc		*prev;
 	struct dw_desc		*first;
 	u32			ctllo;
@@ -790,7 +790,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	cfghi = DWC_CFGH_FIFO_MODE;
 	cfglo = 0;
 
-	dws = dwc->dws;
+	dws = chan->private;
 	if (dws) {
 		/*
 		 * We need controller-specific data to set up slave
@@ -866,7 +866,6 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	spin_lock_bh(&dwc->lock);
 	list_splice_init(&dwc->free_list, &list);
 	dwc->descs_allocated = 0;
-	dwc->dws = NULL;
 
 	/* Disable interrupts */
 	channel_clear_bit(dw, MASK.XFER, dwc->mask);
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 00fdd18..b252b20 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -139,8 +139,6 @@ struct dw_dma_chan {
 	struct list_head	queue;
 	struct list_head	free_list;
 
-	struct dw_dma_slave	*dws;
-
 	unsigned int		descs_allocated;
 };
 
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 76bfe16..2b1196e 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1548,9 +1548,10 @@ static bool filter(struct dma_chan *chan, void *slave)
 {
 	struct dw_dma_slave *dws = slave;
 
-	if (dws->dma_dev == chan->device->dev)
+	if (dws->dma_dev == chan->device->dev) {
+		chan->private = dws;
 		return true;
-	else
+	} else
 		return false;
 }
 #endif
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3e0f64c..494aa0d 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -121,6 +121,7 @@ struct dma_chan_percpu {
  * @local: per-cpu pointer to a struct dma_chan_percpu
  * @client-count: how many clients are using this channel
  * @table_count: number of appearances in the mem-to-mem allocation table
+ * @private: private data for certain client-channel associations
  */
 struct dma_chan {
 	struct dma_device *device;
@@ -134,6 +135,7 @@ struct dma_chan {
 	struct dma_chan_percpu *local;
 	int client_count;
 	int table_count;
+	void *private;
 };
 
 /**


