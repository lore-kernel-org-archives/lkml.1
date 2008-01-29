Return-Path: <linux-kernel-owner+w=401wt.eu-S933682AbYA2SLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbYA2SLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbYA2SK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:10:29 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53782 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753119AbYA2SKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [RFC v2 2/5] dmaengine: Add slave DMA interface
Date: Tue, 29 Jan 2008 19:10:10 +0100
Message-Id: <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
 <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new struct dma_slave with information that the DMA engine driver
needs to set up slave transfers to and from a slave device.

Add a "slave" pointer to the dma_client struct. This must point to a
valid dma_slave structure iff the DMA_SLAVE capability is requested.
The DMA engine driver may use this information in its
device_alloc_chan_resources hook to configure the DMA controller for
slave transfers from and to the given slave device.

Add a new struct dma_slave_descriptor which extends the standard
dma_async_tx_descriptor with a few members that are needed for doing
DMA from/to peripherals with hardware handshaking (aka slave DMA.)

Add new operations to struct dma_device for creating such descriptors,
and for terminating all pending transfers. The latter is needed
because there may be errors outside the scope of the DMA Engine
framework that may require DMA operations to be terminated
prematurely.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

dmaslave interface changes since v1:
  * Drop the set_direction and set_width descriptor hooks. Pass the
    direction and width to the prep function instead.
  * Declare a dma_slave struct with fixed information about a slave,
    i.e. register addresses, handshake interfaces and such.
  * Add pointer to a dma_slave struct to dma_client. Can be NULL if
    the DMA_SLAVE capability isn't requested.
  * Drop the set_slave device hook since the alloc_chan_resources hook
    now has enough information to set up the channel for slave
    transfers.
---
 drivers/dma/dmaengine.c   |    8 +++++
 include/linux/dmaengine.h |   68 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9b5bed9..40162cb 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -286,6 +286,10 @@ static void dma_clients_notify_removed(struct dma_chan *chan)
  */
 void dma_async_client_register(struct dma_client *client)
 {
+	/* validate client data */
+	BUG_ON(dma_has_cap(DMA_SLAVE, client->cap_mask) &&
+		!client->slave);
+
 	mutex_lock(&dma_list_mutex);
 	list_add_tail(&client->global_node, &dma_client_list);
 	mutex_unlock(&dma_list_mutex);
@@ -360,6 +364,10 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_ZERO_SUM, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
+	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+		!device->device_prep_slave);
+	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+		!device->device_terminate_all);
 
 	BUG_ON(!device->device_alloc_chan_resources);
 	BUG_ON(!device->device_free_chan_resources);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 160835c..bcacfb5 100644
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
  * enum dma_prep_flags - DMA flags to augment operation preparation
@@ -110,6 +133,26 @@ enum dma_prep_flags {
 typedef struct { DECLARE_BITMAP(bits, DMA_TX_TYPE_END); } dma_cap_mask_t;
 
 /**
+ * struct dma_slave - Information about a DMA slave
+ * @dev: device acting as DMA slave
+ * @tx_reg: physical address of data register used for
+ *	memory-to-peripheral transfers
+ * @rx_reg: physical address of data register used for
+ *	peripheral-to-memory transfers
+ * @tx_handshake_id: handshake signal used by the device to request
+ *	the DMA controller to do a write to tx_reg
+ * @rx_handshake_id: handshake signal used by the device to request
+ *	the DMA controller to do a read from rx_reg
+ */
+struct dma_slave {
+	struct device	*dev;
+	dma_addr_t	tx_reg;
+	dma_addr_t	rx_reg;
+	unsigned int	tx_handshake_id;
+	unsigned int	rx_handshake_id;
+};
+
+/**
  * struct dma_chan_percpu - the per-CPU part of struct dma_chan
  * @refcount: local_t used for open-coded "bigref" counting
  * @memcpy_count: transaction counter
@@ -197,11 +240,14 @@ typedef enum dma_state_client (*dma_event_callback) (struct dma_client *client,
  * @event_callback: func ptr to call when something happens
  * @cap_mask: only return channels that satisfy the requested capabilities
  *  a value of zero corresponds to any capability
+ * @slave: data for preparing slave transfer. Must be non-NULL iff the
+ *  DMA_SLAVE capability is requested.
  * @global_node: list_head for global dma_client_list
  */
 struct dma_client {
 	dma_event_callback	event_callback;
 	dma_cap_mask_t		cap_mask;
+	struct dma_slave	*slave;
 	struct list_head	global_node;
 };
 
@@ -243,6 +289,17 @@ struct dma_async_tx_descriptor {
 };
 
 /**
+ * struct dma_slave_descriptor - extended DMA descriptor for slave DMA
+ * @async_tx: async transaction descriptor
+ * @client_node: for use by the client, for example when operating on
+ *	scatterlists.
+ */
+struct dma_slave_descriptor {
+	struct dma_async_tx_descriptor txd;
+	struct list_head client_node;
+};
+
+/**
  * struct dma_device - info on the entity supplying DMA services
  * @chancnt: how many DMA channels are supported
  * @channels: the list of struct dma_chan
@@ -261,6 +318,8 @@ struct dma_async_tx_descriptor {
  * @device_prep_dma_zero_sum: prepares a zero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
+ * @device_prep_slave: prepares a slave dma operation
+ * @device_terminate_all: terminate all pending operations
  * @device_dependency_added: async_tx notifies the channel about new deps
  * @device_issue_pending: push pending transactions to hardware
  */
@@ -297,6 +356,13 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
 		struct dma_chan *chan);
 
+	struct dma_slave_descriptor *(*device_prep_slave)(
+		struct dma_chan *chan, dma_addr_t mem_addr,
+		enum dma_slave_direction direction,
+		enum dma_slave_width reg_width,
+		size_t len, unsigned long flags);
+	void (*device_terminate_all)(struct dma_chan *chan);
+
 	void (*device_dependency_added)(struct dma_chan *chan);
 	enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
 			dma_cookie_t cookie, dma_cookie_t *last,
-- 
1.5.3.8

