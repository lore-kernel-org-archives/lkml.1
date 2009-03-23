Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbZCWKLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbZCWKLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbZCWKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:10:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:57786 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757690AbZCWKK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:10:56 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18XVZlz+3YXMcX/X9lGTFSnq7ELtKYvgRpj+cTXGV
	4akdAppxE7Qw9d
Date: Mon, 23 Mar 2009 11:11:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/3 v2] dma: i.MX31 IPU DMA robustness improvements
In-Reply-To: <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
Message-ID: <Pine.LNX.4.64.0903231109590.4871@axis700.grange>
References: <Pine.LNX.4.64.0903130837040.4653@axis700.grange>
 <e9c3a7c20903161459n8ad3c6qd705d146703b28a1@mail.gmail.com>
 <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DMA error handling to the ISR, move common code fragments to functions, fix
scatter-gather element queuing in the ISR, survive channel freeing and
re-allocation in a quick succession.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 drivers/dma/ipu/ipu_idmac.c |  265 +++++++++++++++++++++++++++++--------------
 1 files changed, 181 insertions(+), 84 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 1040730..5974e1b 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -28,6 +28,9 @@
 #define FS_VF_IN_VALID	0x00000002
 #define FS_ENC_IN_VALID	0x00000001
 
+static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
+			       bool wait_for_stop);
+
 /*
  * There can be only one, we could allocate it dynamically, but then we'd have
  * to add an extra parameter to some functions, and use something as ugly as
@@ -762,9 +765,10 @@ static void ipu_select_buffer(enum ipu_channel channel, int buffer_n)
  *              function will fail if the buffer is set to ready.
  */
 /* Called under spin_lock(_irqsave)(&ichan->lock) */
-static int ipu_update_channel_buffer(enum ipu_channel channel,
+static int ipu_update_channel_buffer(struct idmac_channel *ichan,
 				     int buffer_n, dma_addr_t phyaddr)
 {
+	enum ipu_channel channel = ichan->dma_chan.chan_id;
 	uint32_t reg;
 	unsigned long flags;
 
@@ -773,8 +777,8 @@ static int ipu_update_channel_buffer(enum ipu_channel channel,
 	if (buffer_n == 0) {
 		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY);
 		if (reg & (1UL << channel)) {
-			spin_unlock_irqrestore(&ipu_data.lock, flags);
-			return -EACCES;
+			ipu_ic_disable_task(&ipu_data, channel);
+			ichan->status = IPU_CHANNEL_READY;
 		}
 
 		/* 44.3.3.1.9 - Row Number 1 (WORD1, offset 0) */
@@ -784,8 +788,8 @@ static int ipu_update_channel_buffer(enum ipu_channel channel,
 	} else {
 		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY);
 		if (reg & (1UL << channel)) {
-			spin_unlock_irqrestore(&ipu_data.lock, flags);
-			return -EACCES;
+			ipu_ic_disable_task(&ipu_data, channel);
+			ichan->status = IPU_CHANNEL_READY;
 		}
 
 		/* Check if double-buffering is already enabled */
@@ -807,6 +811,39 @@ static int ipu_update_channel_buffer(enum ipu_channel channel,
 }
 
 /* Called under spin_lock_irqsave(&ichan->lock) */
+static int ipu_submit_buffer(struct idmac_channel *ichan,
+	struct idmac_tx_desc *desc, struct scatterlist *sg, int buf_idx)
+{
+	unsigned int chan_id = ichan->dma_chan.chan_id;
+	struct device *dev = &ichan->dma_chan.dev->device;
+	int ret;
+
+	if (async_tx_test_ack(&desc->txd))
+		return -EINTR;
+
+	/*
+	 * On first invocation this shouldn't be necessary, the call to
+	 * ipu_init_channel_buffer() above will set addresses for us, so we
+	 * could make it conditional on status >= IPU_CHANNEL_ENABLED, but
+	 * doing it again shouldn't hurt either.
+	 */
+	ret = ipu_update_channel_buffer(ichan, buf_idx,
+					sg_dma_address(sg));
+
+	if (ret < 0) {
+		dev_err(dev, "Updating sg %p on channel 0x%x buffer %d failed!\n",
+			sg, chan_id, buf_idx);
+		return ret;
+	}
+
+	ipu_select_buffer(chan_id, buf_idx);
+	dev_dbg(dev, "Updated sg %p on channel 0x%x buffer %d\n",
+		sg, chan_id, buf_idx);
+
+	return 0;
+}
+
+/* Called under spin_lock_irqsave(&ichan->lock) */
 static int ipu_submit_channel_buffers(struct idmac_channel *ichan,
 				      struct idmac_tx_desc *desc)
 {
@@ -817,20 +854,10 @@ static int ipu_submit_channel_buffers(struct idmac_channel *ichan,
 		if (!ichan->sg[i]) {
 			ichan->sg[i] = sg;
 
-			/*
-			 * On first invocation this shouldn't be necessary, the
-			 * call to ipu_init_channel_buffer() above will set
-			 * addresses for us, so we could make it conditional
-			 * on status >= IPU_CHANNEL_ENABLED, but doing it again
-			 * shouldn't hurt either.
-			 */
-			ret = ipu_update_channel_buffer(ichan->dma_chan.chan_id, i,
-							sg_dma_address(sg));
+			ret = ipu_submit_buffer(ichan, desc, sg, i);
 			if (ret < 0)
 				return ret;
 
-			ipu_select_buffer(ichan->dma_chan.chan_id, i);
-
 			sg = sg_next(sg);
 		}
 	}
@@ -844,19 +871,22 @@ static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct idmac_channel *ichan = to_idmac_chan(tx->chan);
 	struct idmac *idmac = to_idmac(tx->chan->device);
 	struct ipu *ipu = to_ipu(idmac);
+	struct device *dev = &ichan->dma_chan.dev->device;
 	dma_cookie_t cookie;
 	unsigned long flags;
+	int ret;
 
 	/* Sanity check */
 	if (!list_empty(&desc->list)) {
 		/* The descriptor doesn't belong to client */
-		dev_err(&ichan->dma_chan.dev->device,
-			"Descriptor %p not prepared!\n", tx);
+		dev_err(dev, "Descriptor %p not prepared!\n", tx);
 		return -EBUSY;
 	}
 
 	mutex_lock(&ichan->chan_mutex);
 
+	async_tx_clear_ack(tx);
+
 	if (ichan->status < IPU_CHANNEL_READY) {
 		struct idmac_video_param *video = &ichan->params.video;
 		/*
@@ -880,16 +910,7 @@ static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
 			goto out;
 	}
 
-	/* ipu->lock can be taken under ichan->lock, but not v.v. */
-	spin_lock_irqsave(&ichan->lock, flags);
-
-	/* submit_buffers() atomically verifies and fills empty sg slots */
-	cookie = ipu_submit_channel_buffers(ichan, desc);
-
-	spin_unlock_irqrestore(&ichan->lock, flags);
-
-	if (cookie < 0)
-		goto out;
+	dev_dbg(dev, "Submitting sg %p\n", &desc->sg[0]);
 
 	cookie = ichan->dma_chan.cookie;
 
@@ -899,24 +920,40 @@ static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* from dmaengine.h: "last cookie value returned to client" */
 	ichan->dma_chan.cookie = cookie;
 	tx->cookie = cookie;
+
+	/* ipu->lock can be taken under ichan->lock, but not v.v. */
 	spin_lock_irqsave(&ichan->lock, flags);
+
 	list_add_tail(&desc->list, &ichan->queue);
+	/* submit_buffers() atomically verifies and fills empty sg slots */
+	ret = ipu_submit_channel_buffers(ichan, desc);
+
 	spin_unlock_irqrestore(&ichan->lock, flags);
 
+	if (ret < 0) {
+		cookie = ret;
+		goto dequeue;
+	}
+
 	if (ichan->status < IPU_CHANNEL_ENABLED) {
-		int ret = ipu_enable_channel(idmac, ichan);
+		ret = ipu_enable_channel(idmac, ichan);
 		if (ret < 0) {
 			cookie = ret;
-			spin_lock_irqsave(&ichan->lock, flags);
-			list_del_init(&desc->list);
-			spin_unlock_irqrestore(&ichan->lock, flags);
-			tx->cookie = cookie;
-			ichan->dma_chan.cookie = cookie;
+			goto dequeue;
 		}
 	}
 
 	dump_idmac_reg(ipu);
 
+dequeue:
+	if (cookie < 0) {
+		spin_lock_irqsave(&ichan->lock, flags);
+		list_del_init(&desc->list);
+		spin_unlock_irqrestore(&ichan->lock, flags);
+		tx->cookie = cookie;
+		ichan->dma_chan.cookie = cookie;
+	}
+
 out:
 	mutex_unlock(&ichan->chan_mutex);
 
@@ -1163,6 +1200,24 @@ static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
 	return 0;
 }
 
+static struct scatterlist *idmac_sg_next(struct idmac_channel *ichan,
+	struct idmac_tx_desc **desc, struct scatterlist *sg)
+{
+	struct scatterlist *sgnew = sg ? sg_next(sg) : NULL;
+
+	if (sgnew)
+		/* next sg-element in this list */
+		return sgnew;
+
+	if ((*desc)->list.next == &ichan->queue)
+		/* No more descriptors on the queue */
+		return NULL;
+
+	/* Fetch next descriptor */
+	*desc = list_entry((*desc)->list.next, struct idmac_tx_desc, list);
+	return (*desc)->sg;
+}
+
 /*
  * We have several possibilities here:
  * current BUF		next BUF
@@ -1178,23 +1233,46 @@ static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
 static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 {
 	struct idmac_channel *ichan = dev_id;
+	struct device *dev = &ichan->dma_chan.dev->device;
 	unsigned int chan_id = ichan->dma_chan.chan_id;
 	struct scatterlist **sg, *sgnext, *sgnew = NULL;
 	/* Next transfer descriptor */
-	struct idmac_tx_desc *desc = NULL, *descnew;
+	struct idmac_tx_desc *desc, *descnew;
 	dma_async_tx_callback callback;
 	void *callback_param;
 	bool done = false;
-	u32	ready0 = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY),
-		ready1 = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY),
-		curbuf = idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
+	u32 ready0, ready1, curbuf, err;
+	unsigned long flags;
 
 	/* IDMAC has cleared the respective BUFx_RDY bit, we manage the buffer */
 
-	pr_debug("IDMAC irq %d\n", irq);
+	dev_dbg(dev, "IDMAC irq %d, buf %d\n", irq, ichan->active_buffer);
+
+	spin_lock_irqsave(&ipu_data.lock, flags);
+
+	ready0	= idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY);
+	ready1	= idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY);
+	curbuf	= idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
+	err	= idmac_read_ipureg(&ipu_data, IPU_INT_STAT_4);
+
+	if (err & (1 << chan_id)) {
+		idmac_write_ipureg(&ipu_data, 1 << chan_id, IPU_INT_STAT_4);
+		spin_unlock_irqrestore(&ipu_data.lock, flags);
+		/*
+		 * Doing this
+		 * ichan->sg[0] = ichan->sg[1] = NULL;
+		 * you can force channel re-enable on the next tx_submit(), but
+		 * this is dirty - think about descriptors with multiple
+		 * sg elements.
+		 */
+		dev_warn(dev, "NFB4EOF on channel %d, ready %x, %x, cur %x\n",
+			 chan_id, ready0, ready1, curbuf);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&ipu_data.lock, flags);
+
 	/* Other interrupts do not interfere with this channel */
 	spin_lock(&ichan->lock);
-
 	if (unlikely(chan_id != IDMAC_SDC_0 && chan_id != IDMAC_SDC_1 &&
 		     ((curbuf >> chan_id) & 1) == ichan->active_buffer)) {
 		int i = 100;
@@ -1209,19 +1287,23 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 
 		if (!i) {
 			spin_unlock(&ichan->lock);
-			dev_dbg(ichan->dma_chan.device->dev,
+			dev_dbg(dev,
 				"IRQ on active buffer on channel %x, active "
 				"%d, ready %x, %x, current %x!\n", chan_id,
 				ichan->active_buffer, ready0, ready1, curbuf);
 			return IRQ_NONE;
-		}
+		} else
+			dev_dbg(dev,
+				"Buffer deactivated on channel %x, active "
+				"%d, ready %x, %x, current %x, rest %d!\n", chan_id,
+				ichan->active_buffer, ready0, ready1, curbuf, i);
 	}
 
 	if (unlikely((ichan->active_buffer && (ready1 >> chan_id) & 1) ||
 		     (!ichan->active_buffer && (ready0 >> chan_id) & 1)
 		     )) {
 		spin_unlock(&ichan->lock);
-		dev_dbg(ichan->dma_chan.device->dev,
+		dev_dbg(dev,
 			"IRQ with active buffer still ready on channel %x, "
 			"active %d, ready %x, %x!\n", chan_id,
 			ichan->active_buffer, ready0, ready1);
@@ -1229,8 +1311,9 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	}
 
 	if (unlikely(list_empty(&ichan->queue))) {
+		ichan->sg[ichan->active_buffer] = NULL;
 		spin_unlock(&ichan->lock);
-		dev_err(ichan->dma_chan.device->dev,
+		dev_err(dev,
 			"IRQ without queued buffers on channel %x, active %d, "
 			"ready %x, %x!\n", chan_id,
 			ichan->active_buffer, ready0, ready1);
@@ -1245,40 +1328,44 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	sg = &ichan->sg[ichan->active_buffer];
 	sgnext = ichan->sg[!ichan->active_buffer];
 
+	if (!*sg) {
+		spin_unlock(&ichan->lock);
+		return IRQ_HANDLED;
+	}
+
+	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
+	descnew = desc;
+
+	dev_dbg(dev, "IDMAC irq %d, dma 0x%08x, next dma 0x%08x, current %d, curbuf 0x%08x\n",
+		irq, sg_dma_address(*sg), sgnext ? sg_dma_address(sgnext) : 0, ichan->active_buffer, curbuf);
+
+	/* Find the descriptor of sgnext */
+	sgnew = idmac_sg_next(ichan, &descnew, *sg);
+	if (sgnext != sgnew)
+		dev_err(dev, "Submitted buffer %p, next buffer %p\n", sgnext, sgnew);
+
 	/*
 	 * if sgnext == NULL sg must be the last element in a scatterlist and
 	 * queue must be empty
 	 */
 	if (unlikely(!sgnext)) {
-		if (unlikely(sg_next(*sg))) {
-			dev_err(ichan->dma_chan.device->dev,
-				"Broken buffer-update locking on channel %x!\n",
-				chan_id);
-			/* We'll let the user catch up */
+		if (!WARN_ON(sg_next(*sg)))
+			dev_dbg(dev, "Underrun on channel %x\n", chan_id);
+		ichan->sg[!ichan->active_buffer] = sgnew;
+
+		if (unlikely(sgnew)) {
+			ipu_submit_buffer(ichan, descnew, sgnew, !ichan->active_buffer);
 		} else {
-			/* Underrun */
+			spin_lock_irqsave(&ipu_data.lock, flags);
 			ipu_ic_disable_task(&ipu_data, chan_id);
-			dev_dbg(ichan->dma_chan.device->dev,
-				"Underrun on channel %x\n", chan_id);
+			spin_unlock_irqrestore(&ipu_data.lock, flags);
 			ichan->status = IPU_CHANNEL_READY;
 			/* Continue to check for complete descriptor */
 		}
 	}
 
-	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
-
-	/* First calculate and submit the next sg element */
-	if (likely(sgnext))
-		sgnew = sg_next(sgnext);
-
-	if (unlikely(!sgnew)) {
-		/* Start a new scatterlist, if any queued */
-		if (likely(desc->list.next != &ichan->queue)) {
-			descnew = list_entry(desc->list.next,
-					     struct idmac_tx_desc, list);
-			sgnew = &descnew->sg[0];
-		}
-	}
+	/* Calculate and submit the next sg element */
+	sgnew = idmac_sg_next(ichan, &descnew, sgnew);
 
 	if (unlikely(!sg_next(*sg)) || !sgnext) {
 		/*
@@ -1291,17 +1378,13 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 
 	*sg = sgnew;
 
-	if (likely(sgnew)) {
-		int ret;
-
-		ret = ipu_update_channel_buffer(chan_id, ichan->active_buffer,
-						sg_dma_address(*sg));
-		if (ret < 0)
-			dev_err(ichan->dma_chan.device->dev,
-				"Failed to update buffer on channel %x buffer %d!\n",
-				chan_id, ichan->active_buffer);
-		else
-			ipu_select_buffer(chan_id, ichan->active_buffer);
+	if (likely(sgnew) &&
+	    ipu_submit_buffer(ichan, descnew, sgnew, ichan->active_buffer) < 0) {
+		callback = desc->txd.callback;
+		callback_param = desc->txd.callback_param;
+		spin_unlock(&ichan->lock);
+		callback(callback_param);
+		spin_lock(&ichan->lock);
 	}
 
 	/* Flip the active buffer - even if update above failed */
@@ -1329,13 +1412,20 @@ static void ipu_gc_tasklet(unsigned long arg)
 		struct idmac_channel *ichan = ipu->channel + i;
 		struct idmac_tx_desc *desc;
 		unsigned long flags;
-		int j;
+		struct scatterlist *sg;
+		int j, k;
 
 		for (j = 0; j < ichan->n_tx_desc; j++) {
 			desc = ichan->desc + j;
 			spin_lock_irqsave(&ichan->lock, flags);
 			if (async_tx_test_ack(&desc->txd)) {
 				list_move(&desc->list, &ichan->free_list);
+				for_each_sg(desc->sg, sg, desc->sg_len, k) {
+					if (ichan->sg[0] == sg)
+						ichan->sg[0] = NULL;
+					else if (ichan->sg[1] == sg)
+						ichan->sg[1] = NULL;
+				}
 				async_tx_clear_ack(&desc->txd);
 			}
 			spin_unlock_irqrestore(&ichan->lock, flags);
@@ -1471,15 +1561,22 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan)
 		goto eimap;
 
 	ichan->eof_irq = ret;
-	ret = request_irq(ichan->eof_irq, idmac_interrupt, 0,
-			  ichan->eof_name, ichan);
-	if (ret < 0)
-		goto erirq;
+
+	/*
+	 * Important to first disable the channel, because maybe someone
+	 * used it before us, e.g., the bootloader
+	 */
+	ipu_disable_channel(idmac, ichan, true);
 
 	ret = ipu_init_channel(idmac, ichan);
 	if (ret < 0)
 		goto eichan;
 
+	ret = request_irq(ichan->eof_irq, idmac_interrupt, 0,
+			  ichan->eof_name, ichan);
+	if (ret < 0)
+		goto erirq;
+
 	ichan->status = IPU_CHANNEL_INITIALIZED;
 
 	dev_dbg(&ichan->dma_chan.dev->device, "Found channel 0x%x, irq %d\n",
@@ -1487,9 +1584,9 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan)
 
 	return ret;
 
-eichan:
-	free_irq(ichan->eof_irq, ichan);
 erirq:
+	ipu_uninit_channel(idmac, ichan);
+eichan:
 	ipu_irq_unmap(ichan->dma_chan.chan_id);
 eimap:
 	return ret;
-- 
1.5.4

