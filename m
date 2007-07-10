Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbXGJJhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbXGJJhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbXGJJhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:37:47 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:54148 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbXGJJhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:37:46 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: akpm@linux-foundation.org, paulus@samba.org, galak@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 3/4] Extend the DMA-engine API.
Date: Tue, 10 Jul 2007 17:45:11 +0800
Message-Id: <11840607111926-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add channel wait queue and transfer callback dma_xfer_callback().
If the DMA controller and driver support interrupt, when the
transfer is finished, it will wakeup the wait queue
and call the callback function of the channel.

Add dma_async_raw_xfer() to API and device_raw_xfer() to struct dma_device
for RAW physical address DMA transfer, which will be used at transfer
between I/O address and memory address.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 include/linux/dmaengine.h |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c94d8f1..d9dfc57 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -28,6 +28,7 @@
 #include <linux/kref.h>
 #include <linux/completion.h>
 #include <linux/rcupdate.h>
+#include <linux/wait.h>
 
 /**
  * enum dma_event - resource PNP/power managment events
@@ -108,6 +109,8 @@ struct dma_chan {
 	struct list_head client_node;
 	struct list_head device_node;
 	struct dma_chan_percpu *local;
+
+	wait_queue_head_t wait_q;
 };
 
 void dma_chan_cleanup(struct kref *kref);
@@ -138,6 +141,12 @@ static inline void dma_chan_put(struct dma_chan *chan)
 typedef void (*dma_event_callback) (struct dma_client *client,
 		struct dma_chan *chan, enum dma_event event);
 
+/*
+ * typedef dma_xfer_callback
+ *   - function pointer to a DMA transfer callback when finished
+ */
+typedef void (*dma_xfer_callback) (struct dma_chan *chan, void *data);
+
 /**
  * struct dma_client - info on the entity making use of DMA services
  * @event_callback: func ptr to call when something happens
@@ -187,6 +196,9 @@ struct dma_device {
 
 	int (*device_alloc_chan_resources)(struct dma_chan *chan);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
+	dma_cookie_t (*device_raw_xfer)(struct dma_chan *chan,
+			dma_addr_t dest, dma_addr_t src, size_t len,
+			dma_xfer_callback cb, void *data);
 	dma_cookie_t (*device_memcpy_buf_to_buf)(struct dma_chan *chan,
 			void *dest, void *src, size_t len);
 	dma_cookie_t (*device_memcpy_buf_to_pg)(struct dma_chan *chan,
@@ -209,6 +221,29 @@ void dma_async_client_chan_request(struct dma_client *client,
 		unsigned int number);
 
 /**
+ * dma_async_raw_xfer - transfor data between physical addresses with callback
+ * @chan: DMA channel to be used
+ * @dest: destination address (physical)
+ * @src: source address (physical)
+ * @len: length
+ */
+static inline dma_cookie_t dma_async_raw_xfer(struct dma_chan *chan,
+				dma_addr_t dest, dma_addr_t src, size_t len,
+				dma_xfer_callback cb, void *data)
+{
+	int cpu = get_cpu();
+	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
+	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	put_cpu();
+
+	if (chan->device->device_raw_xfer)
+		return chan->device->device_raw_xfer(chan, dest, src, len,
+							cb, data);
+	else
+		return -EPERM;
+}
+
+/**
  * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
  * @chan: DMA channel to offload copy to
  * @dest: destination address (virtual)
-- 
1.5.1

