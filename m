Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYFZNY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYFZNY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbYFZNXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:23:53 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59174 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbYFZNXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:23:51 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       kernel@avr32linux.org, shannon.nelson@intel.com,
       David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v4 1/6] dmaengine: Add dma_client parameter to device_alloc_chan_resources
Date: Thu, 26 Jun 2008 15:23:18 +0200
Message-Id: <1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 26 Jun 2008 13:23:06.0619 (UTC) FILETIME=[C50B0CB0:01C8D78F]
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

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/dma/dmaengine.c   |    3 ++-
 drivers/dma/ioat_dma.c    |    5 +++--
 drivers/dma/iop-adma.c    |    7 ++++---
 include/linux/dmaengine.h |    3 ++-
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 99c22b4..a57c337 100644
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
index 318e8a2..90e5b0a 100644
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
@@ -1049,7 +1050,7 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 	dma_chan = container_of(device->common.channels.next,
 				struct dma_chan,
 				device_node);
-	if (device->common.device_alloc_chan_resources(dma_chan) < 1) {
+	if (device->common.device_alloc_chan_resources(dma_chan, NULL) < 1) {
 		dev_err(&device->pdev->dev,
 			"selftest cannot allocate chan resource\n");
 		err = -ENODEV;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 0ec0f43..2664ea5 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -444,7 +444,8 @@ static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan);
 static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan);
 
 /* returns the number of allocated descriptors */
-static int iop_adma_alloc_chan_resources(struct dma_chan *chan)
+static int iop_adma_alloc_chan_resources(struct dma_chan *chan,
+					 struct dma_client *client)
 {
 	char *hw_desc;
 	int idx;
@@ -838,7 +839,7 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 	dma_chan = container_of(device->common.channels.next,
 				struct dma_chan,
 				device_node);
-	if (iop_adma_alloc_chan_resources(dma_chan) < 1) {
+	if (iop_adma_alloc_chan_resources(dma_chan, NULL) < 1) {
 		err = -ENODEV;
 		goto out;
 	}
@@ -936,7 +937,7 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 	dma_chan = container_of(device->common.channels.next,
 				struct dma_chan,
 				device_node);
-	if (iop_adma_alloc_chan_resources(dma_chan) < 1) {
+	if (iop_adma_alloc_chan_resources(dma_chan, NULL) < 1) {
 		err = -ENODEV;
 		goto out;
 	}
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d08a5c5..cffb95f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -279,7 +279,8 @@ struct dma_device {
 	int dev_id;
 	struct device *dev;
 
-	int (*device_alloc_chan_resources)(struct dma_chan *chan);
+	int (*device_alloc_chan_resources)(struct dma_chan *chan,
+			struct dma_client *client);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
 
 	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy)(
-- 
1.5.5.4

