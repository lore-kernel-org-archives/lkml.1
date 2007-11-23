Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbXKWMVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbXKWMVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbXKWMVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:21:16 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53340 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756062AbXKWMVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:21:15 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC 1/4] dmaengine: Add slave DMA interface
Date: Fri, 23 Nov 2007 13:20:10 +0100
Message-Id: <1195820413-2179-2-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
References: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new struct dma_slave_descriptor which extends the standard
dma_async_tx_descriptor with a few members that are needed for doing
DMA from/to peripherals with hardware handshaking (aka slave DMA.)

Add new operations to struct dma_device for creating such descriptors,
for setting up the controller to do slave DMA for a given device, and
for terminating all pending transfers. The latter is needed because
there may be errors outside the scope of the DMA Engine framework that
requires DMA operations to be terminated prematurely.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/dma/dmaengine.c   |    6 +++++
 include/linux/dmaengine.h |   55 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index ec7e871..3d17918 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -362,6 +362,12 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_ZERO_SUM, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
+	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+		!device->device_set_slave);
+	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+		!device->device_prep_slave);
+	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+		!device->device_terminate_all);
 
 	BUG_ON(!device->device_alloc_chan_resources);
 	BUG_ON(!device->device_free_chan_resources);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 55c9a69..e81189f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -89,10 +89,33 @@ enum dma_transaction_type {
 	DMA_MEMSET,
 	DMA_MEMCPY_CRC32C,
 	DMA_INTERRUPT,
+	DMA_SLAVE,
 };
 
 /* last transaction type for creation of the capabilities mask */
-#define DMA_TX_TYPE_END (DMA_INTERRUPT + 1)
+#define DMA_TX_TYPE_END (DMA_SLAVE + 1)
+
+/**
+ * enum dma_slave_direction - direction of a DMA slave transfer
+ * @DMA_SLAVE_TO_MEMORY: Transfer data from peripheral to memory
+ * @DMA_SLAVE_FROM_MEMORY: Transfer data from memory to peripheral
+ */
+enum dma_slave_direction {
+	DMA_SLAVE_TO_MEMORY,
+	DMA_SLAVE_FROM_MEMORY,
+};
+
+/**
+ * enum dma_slave_width - DMA slave register access width.
+ * @DMA_SLAVE_WIDTH_8BIT: Do 8-bit slave register accesses
+ * @DMA_SLAVE_WIDTH_16BIT: Do 16-bit slave register accesses
+ * @DMA_SLAVE_WIDTH_32BIT: Do 32-bit slave register accesses
+ */
+enum dma_slave_width {
+	DMA_SLAVE_WIDTH_8BIT,
+	DMA_SLAVE_WIDTH_16BIT,
+	DMA_SLAVE_WIDTH_32BIT,
+};
 
 /**
  * dma_cap_mask_t - capabilities bitmap modeled after cpumask_t.
@@ -240,6 +263,25 @@ struct dma_async_tx_descriptor {
 };
 
 /**
+ * struct dma_slave_descriptor - extended DMA descriptor for slave DMA
+ * @async_tx: async transaction descriptor
+ * @slave_set_direction: set the direction of the slave DMA
+ *	transaction in the hardware descriptor
+ * @slave_set_width: set the slave register access width in the
+ *	hardware descriptor
+ * @client_node: for use by the client, for example when operating on
+ *	scatterlists.
+ */
+struct dma_slave_descriptor {
+	struct dma_async_tx_descriptor txd;
+	void (*slave_set_direction)(struct dma_slave_descriptor *desc,
+			enum dma_slave_direction direction);
+	void (*slave_set_width)(struct dma_slave_descriptor *desc,
+			enum dma_slave_width width);
+	struct list_head client_node;
+};
+
+/**
  * struct dma_device - info on the entity supplying DMA services
  * @chancnt: how many DMA channels are supported
  * @channels: the list of struct dma_chan
@@ -258,6 +300,10 @@ struct dma_async_tx_descriptor {
  * @device_prep_dma_zero_sum: prepares a zero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
+ * @device_set_slave: set up a channel to do slave DMA for a given
+ *	peripheral
+ * @device_prep_slave: prepares a slave dma operation
+ * @device_terminate_all: terminate all pending operations
  * @device_dependency_added: async_tx notifies the channel about new deps
  * @device_issue_pending: push pending transactions to hardware
  */
@@ -291,6 +337,13 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
 		struct dma_chan *chan);
 
+	void (*device_set_slave)(struct dma_chan *chan,
+			dma_addr_t rx_reg, unsigned int rx_hs_id,
+			dma_addr_t tx_reg, unsigned int tx_hs_id);
+	struct dma_slave_descriptor *(*device_prep_slave)(
+		struct dma_chan *chan, size_t len, int int_en);
+	void (*device_terminate_all)(struct dma_chan *chan);
+
 	void (*device_dependency_added)(struct dma_chan *chan);
 	enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
 			dma_cookie_t cookie, dma_cookie_t *last,
-- 
1.5.3.4

