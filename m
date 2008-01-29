Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbYA2SL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbYA2SL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbYA2SK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:10:28 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53785 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753725AbYA2SKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:10:20 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC v2 1/5] dmaengine: Add dma_client parameter to device_alloc_chan_resources
Date: Tue, 29 Jan 2008 19:10:09 +0100
Message-Id: <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A DMA controller capable of doing slave transfers may need to know a
few things about the slave when preparing the channel. We don't want
to add this information to struct dma_channel since the channel hasn't
yet been bound to a client at this point.

Instead, pass a reference to the client requesting the channel to the
driver's device_alloc_chan_resources hook so that it can pick the
necessary information from the dma_client struct by itself.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/dma/dmaengine.c   |    3 ++-
 drivers/dma/ioat_dma.c    |    5 +++--
 drivers/dma/iop-adma.c    |    7 ++++---
 include/linux/dmaengine.h |    3 ++-
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2996523..9b5bed9 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -174,7 +174,8 @@ static void dma_client_chan_alloc(struct dma_client *client)
 			if (!dma_chan_satisfies_mask(chan, client->cap_mask))
 				continue;
 
-			desc = chan->device->device_alloc_chan_resources(chan);
+			desc = chan->device->device_alloc_chan_resources(
+					chan, client);
 			if (desc >= 0) {
 				ack = client->event_callback(client,
 						chan,
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index dff38ac..3e82bfb 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -452,7 +452,8 @@ static void ioat2_dma_massage_chan_desc(struct ioat_dma_chan *ioat_chan)
  * ioat_dma_alloc_chan_resources - returns the number of allocated descriptors
  * @chan: the channel to be filled out
  */
-static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
+static int ioat_dma_alloc_chan_resources(struct dma_chan *chan,
+					 struct dma_client *client)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_desc_sw *desc;
@@ -1058,7 +1059,7 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 	dma_chan = container_of(device->common.channels.next,
 				struct dma_chan,
 				device_node);
-	if (device->common.device_alloc_chan_resources(dma_chan) < 1) {
+	if (device->common.device_alloc_chan_resources(dma_chan, NULL) < 1) {
 		dev_err(&device->pdev->dev,
 			"selftest cannot allocate chan resource\n");
 		err = -ENODEV;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 853af18..a784918 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -447,7 +447,8 @@ static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan);
 static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan);
 
 /* returns the number of allocated descriptors */
-static int iop_adma_alloc_chan_resources(struct dma_chan *chan)
+static int iop_adma_alloc_chan_resources(struct dma_chan *chan,
+					 struct dma_client *client)
 {
 	char *hw_desc;
 	int idx;
@@ -844,7 +845,7 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 	dma_chan = container_of(device->common.channels.next,
 				struct dma_chan,
 				device_node);
-	if (iop_adma_alloc_chan_resources(dma_chan) < 1) {
+	if (iop_adma_alloc_chan_resources(dma_chan, NULL) < 1) {
 		err = -ENODEV;
 		goto out;
 	}
@@ -942,7 +943,7 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 	dma_chan = container_of(device->common.channels.next,
 				struct dma_chan,
 				device_node);
-	if (iop_adma_alloc_chan_resources(dma_chan) < 1) {
+	if (iop_adma_alloc_chan_resources(dma_chan, NULL) < 1) {
 		err = -ENODEV;
 		goto out;
 	}
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 586ea37..160835c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -278,7 +278,8 @@ struct dma_device {
 	int dev_id;
 	struct device *dev;
 
-	int (*device_alloc_chan_resources)(struct dma_chan *chan);
+	int (*device_alloc_chan_resources)(struct dma_chan *chan,
+			struct dma_client *client);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
 
 	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy)(
-- 
1.5.3.8

