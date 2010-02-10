Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0BJW0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:26:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:7476 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab0BJW0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:26:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,447,1262592000"; 
   d="scan'208";a="539669584"
Subject: [GIT PULL] dmaengine fixes for 2.6.33-rc8
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 15:26:25 -0700
Message-ID: <1265840785.7157.15.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from 

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

Anatolij Gustschin (1):
      dmaengine: fix memleak in dma_async_device_unregister

Dan Williams (1):
      ioat: fix infinite timeout checking in ioat2_quiesce

Guennadi Liakhovetski (1):
      async-tx: fix buffer submission error handling in ipu_idma.c

Julia Lawall (1):
      drivers/dma: Correct NULL test

Yong Zhang (1):
      dmaengine: correct onstack wait_queue_head declaration

 drivers/dma/coh901318.c     |    2 --
 drivers/dma/dmaengine.c     |    1 +
 drivers/dma/dmatest.c       |    2 +-
 drivers/dma/ioat/dma_v2.c   |    2 +-
 drivers/dma/ipu/ipu_idmac.c |   25 +++++++------------------
 5 files changed, 10 insertions(+), 22 deletions(-)

Nothing urgent in this collection.  Just nice to have fixes in
2.6.33-rc.  The 'ioat' one is also applicable to 2.6.32.3+, but
otherwise none of these are targeted at 2.6.32 or prior.  All but the
recently appended patches (Julia's and Guennadi's) have seen at least
one release in -next.

Thanks,
Dan

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index b5f2ee0..64a9372 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -613,8 +613,6 @@ static void dma_tasklet(unsigned long data)
 	cohd_fin->pending_irqs--;
 	cohc->completed = cohd_fin->desc.cookie;
 
-	BUG_ON(cohc->nbr_active_done && cohd_fin == NULL);
-
 	if (cohc->nbr_active_done == 0)
 		return;
 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 6f51a0a..e7a3230 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -826,6 +826,7 @@ void dma_async_device_unregister(struct dma_device *device)
 		chan->dev->chan = NULL;
 		mutex_unlock(&dma_list_mutex);
 		device_unregister(&chan->dev->device);
+		free_percpu(chan->local);
 	}
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 8b90516..948d563 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -467,7 +467,7 @@ err_srcs:
 
 	if (iterations > 0)
 		while (!kthread_should_stop()) {
-			DECLARE_WAIT_QUEUE_HEAD(wait_dmatest_exit);
+			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
 			interruptible_sleep_on(&wait_dmatest_exit);
 		}
 
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 5f7a500..5cc37af 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -249,7 +249,7 @@ int ioat2_quiesce(struct ioat_chan_common *chan, unsigned long tmo)
 	if (is_ioat_active(status) || is_ioat_idle(status))
 		ioat_suspend(chan);
 	while (is_ioat_active(status) || is_ioat_idle(status)) {
-		if (end && time_after(jiffies, end)) {
+		if (tmo && time_after(jiffies, end)) {
 			err = -ETIMEDOUT;
 			break;
 		}
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 9a5bc1a..e80bae1 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -761,12 +761,10 @@ static void ipu_select_buffer(enum ipu_channel channel, int buffer_n)
  * @buffer_n:	buffer number to update.
  *		0 or 1 are the only valid values.
  * @phyaddr:	buffer physical address.
- * @return:	Returns 0 on success or negative error code on failure. This
- *              function will fail if the buffer is set to ready.
  */
 /* Called under spin_lock(_irqsave)(&ichan->lock) */
-static int ipu_update_channel_buffer(struct idmac_channel *ichan,
-				     int buffer_n, dma_addr_t phyaddr)
+static void ipu_update_channel_buffer(struct idmac_channel *ichan,
+				      int buffer_n, dma_addr_t phyaddr)
 {
 	enum ipu_channel channel = ichan->dma_chan.chan_id;
 	uint32_t reg;
@@ -806,8 +804,6 @@ static int ipu_update_channel_buffer(struct idmac_channel *ichan,
 	}
 
 	spin_unlock_irqrestore(&ipu_data.lock, flags);
-
-	return 0;
 }
 
 /* Called under spin_lock_irqsave(&ichan->lock) */
@@ -816,7 +812,6 @@ static int ipu_submit_buffer(struct idmac_channel *ichan,
 {
 	unsigned int chan_id = ichan->dma_chan.chan_id;
 	struct device *dev = &ichan->dma_chan.dev->device;
-	int ret;
 
 	if (async_tx_test_ack(&desc->txd))
 		return -EINTR;
@@ -827,14 +822,7 @@ static int ipu_submit_buffer(struct idmac_channel *ichan,
 	 * could make it conditional on status >= IPU_CHANNEL_ENABLED, but
 	 * doing it again shouldn't hurt either.
 	 */
-	ret = ipu_update_channel_buffer(ichan, buf_idx,
-					sg_dma_address(sg));
-
-	if (ret < 0) {
-		dev_err(dev, "Updating sg %p on channel 0x%x buffer %d failed!\n",
-			sg, chan_id, buf_idx);
-		return ret;
-	}
+	ipu_update_channel_buffer(ichan, buf_idx, sg_dma_address(sg));
 
 	ipu_select_buffer(chan_id, buf_idx);
 	dev_dbg(dev, "Updated sg %p on channel 0x%x buffer %d\n",
@@ -1379,10 +1367,11 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 
 	if (likely(sgnew) &&
 	    ipu_submit_buffer(ichan, descnew, sgnew, ichan->active_buffer) < 0) {
-		callback = desc->txd.callback;
-		callback_param = desc->txd.callback_param;
+		callback = descnew->txd.callback;
+		callback_param = descnew->txd.callback_param;
 		spin_unlock(&ichan->lock);
-		callback(callback_param);
+		if (callback)
+			callback(callback_param);
 		spin_lock(&ichan->lock);
 	}
 


