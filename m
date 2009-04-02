Return-Path: <linux-kernel-owner+w=401wt.eu-S935492AbZDBJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935492AbZDBJh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935376AbZDBJgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:36:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:54272 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934938AbZDBJgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:36:53 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/6/Ks1OXb68IOBPXOPfDdNLxqelrFh+EBiJCIxU1
	cc357X7i2DZx5F
Date: Thu, 2 Apr 2009 11:36:58 +0200 (CEST)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dma: Add SoF and EoF debugging to ipu_idmac.c, minor cleanup
Message-ID: <Pine.LNX.4.64.0904021131070.5263@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Start-of-Frame and End-of-Frame debugging to ipu_idmac.c, in the 
future it might also be needed for the actual video processing in 
mx3-camera, at which point, the ISRs will have to be transferred to 
mx3_camera.c, for which ipu_irq_map() and ipu_irq_unmap() functions will 
have to be exported.

Also simplify a couple of pointer-dereferences.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

Dan, nothing critical, still, would be nice to get it in now to avoid 
bitrotting and the need to rebase...

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 4e6a9c3..e202a6c 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1442,8 +1442,8 @@ static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan
 	unsigned long flags;
 
 	/* We only can handle these three channels so far */
-	if (ichan->dma_chan.chan_id != IDMAC_SDC_0 && ichan->dma_chan.chan_id != IDMAC_SDC_1 &&
-	    ichan->dma_chan.chan_id != IDMAC_IC_7)
+	if (chan->chan_id != IDMAC_SDC_0 && chan->chan_id != IDMAC_SDC_1 &&
+	    chan->chan_id != IDMAC_IC_7)
 		return NULL;
 
 	if (direction != DMA_FROM_DEVICE && direction != DMA_TO_DEVICE) {
@@ -1484,7 +1484,7 @@ static void idmac_issue_pending(struct dma_chan *chan)
 
 	/* This is not always needed, but doesn't hurt either */
 	spin_lock_irqsave(&ipu->lock, flags);
-	ipu_select_buffer(ichan->dma_chan.chan_id, ichan->active_buffer);
+	ipu_select_buffer(chan->chan_id, ichan->active_buffer);
 	spin_unlock_irqrestore(&ipu->lock, flags);
 
 	/*
@@ -1541,6 +1541,28 @@ static void idmac_terminate_all(struct dma_chan *chan)
 	mutex_unlock(&ichan->chan_mutex);
 }
 
+#ifdef DEBUG
+static irqreturn_t ic_sof_irq(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	printk(KERN_DEBUG "Got SOF IRQ %d on Channel %d\n",
+	       irq, ichan->dma_chan.chan_id);
+	disable_irq(irq);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ic_eof_irq(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	printk(KERN_DEBUG "Got EOF IRQ %d on Channel %d\n",
+	       irq, ichan->dma_chan.chan_id);
+	disable_irq(irq);
+	return IRQ_HANDLED;
+}
+
+static int ic_sof = -EINVAL, ic_eof = -EINVAL;
+#endif
+
 static int idmac_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
@@ -1554,7 +1576,7 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan)
 	chan->cookie		= 1;
 	ichan->completed	= -ENXIO;
 
-	ret = ipu_irq_map(ichan->dma_chan.chan_id);
+	ret = ipu_irq_map(chan->chan_id);
 	if (ret < 0)
 		goto eimap;
 
@@ -1575,17 +1597,28 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan)
 	if (ret < 0)
 		goto erirq;
 
+#ifdef DEBUG
+	if (chan->chan_id == IDMAC_IC_7) {
+		ic_sof = ipu_irq_map(69);
+		if (ic_sof > 0)
+			request_irq(ic_sof, ic_sof_irq, 0, "IC SOF", ichan);
+		ic_eof = ipu_irq_map(70);
+		if (ic_eof > 0)
+			request_irq(ic_eof, ic_eof_irq, 0, "IC EOF", ichan);
+	}
+#endif
+
 	ichan->status = IPU_CHANNEL_INITIALIZED;
 
-	dev_dbg(&ichan->dma_chan.dev->device, "Found channel 0x%x, irq %d\n",
-		ichan->dma_chan.chan_id, ichan->eof_irq);
+	dev_dbg(&chan->dev->device, "Found channel 0x%x, irq %d\n",
+		chan->chan_id, ichan->eof_irq);
 
 	return ret;
 
 erirq:
 	ipu_uninit_channel(idmac, ichan);
 eichan:
-	ipu_irq_unmap(ichan->dma_chan.chan_id);
+	ipu_irq_unmap(chan->chan_id);
 eimap:
 	return ret;
 }
@@ -1600,8 +1633,22 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
 	__idmac_terminate_all(chan);
 
 	if (ichan->status > IPU_CHANNEL_FREE) {
+#ifdef DEBUG
+		if (chan->chan_id == IDMAC_IC_7) {
+			if (ic_sof > 0) {
+				free_irq(ic_sof, ichan);
+				ipu_irq_unmap(69);
+				ic_sof = -EINVAL;
+			}
+			if (ic_eof > 0) {
+				free_irq(ic_eof, ichan);
+				ipu_irq_unmap(70);
+				ic_eof = -EINVAL;
+			}
+		}
+#endif
 		free_irq(ichan->eof_irq, ichan);
-		ipu_irq_unmap(ichan->dma_chan.chan_id);
+		ipu_irq_unmap(chan->chan_id);
 	}
 
 	ichan->status = IPU_CHANNEL_FREE;
@@ -1663,7 +1710,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 		dma_chan->device	= &idmac->dma;
 		dma_chan->cookie	= 1;
 		dma_chan->chan_id	= i;
-		list_add_tail(&ichan->dma_chan.device_node, &dma->channels);
+		list_add_tail(&dma_chan->device_node, &dma->channels);
 	}
 
 	idmac_write_icreg(ipu, 0x00000070, IDMAC_CONF);
