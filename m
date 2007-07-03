Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbXGCPVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbXGCPVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXGCPVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:21:06 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:43586 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbXGCPVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:21:04 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 11:21:04 EDT
From: "Peter Pearse" <peter.pearse@arm.com>
To: <linux-kernel@vger.kernel.org>
Cc: <christopher.leech@intel.com>
Subject: [RFC][PATCH] DMA: Expand dmaengine implementation for more DMACs
Date: Tue, 3 Jul 2007 15:58:31 +0100
Message-ID: <000501c7bd82$9f2fb310$821ba8c0@Emea.Arm.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ace9gp7Xn5S76TvjSiiYft+C95Y48g==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-OriginalArrivalTime: 03 Jul 2007 14:58:34.0684 (UTC) FILETIME=[A0F027C0:01C7BD82]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The existing DMAC used by the dmaengine API (Intel IOAT) assumes all 
possible clients can use any available DMA channel.

Some other DMACs restrict particular peripherals to particular DMA channels.

The patch below (against v2.6.22-rc7) extends the dmaengine implementation 
to allow such DMACs to differentiate between clients.

Regards

Peter Pearse

---
From: Peter Pearse <peter.pearse@arm.com>

Pass client data down to the dmaengine DMAC implementation code.

Signed-off-by: Peter Pearse <peter.pearse@arm.com> 
---
diff -purN RFCbase/drivers/dma/dmaengine.c
RFCpatched/drivers/dma/dmaengine.c
--- RFCbase/drivers/dma/dmaengine.c	2007-07-02 09:38:15.124179000 +0100
+++ RFCpatched/drivers/dma/dmaengine.c	2007-07-03 15:16:45.550630000 +0100
@@ -146,7 +146,7 @@ static struct dma_chan *dma_client_chan_
 			if (chan->client)
 				continue;
 
-			desc =
chan->device->device_alloc_chan_resources(chan);
+			desc =
chan->device->device_alloc_chan_resources(chan, client);
 			if (desc >= 0) {
 				kref_get(&device->refcount);
 				kref_init(&chan->refcount);
diff -purN RFCbase/drivers/dma/ioatdma.c RFCpatched/drivers/dma/ioatdma.c
--- RFCbase/drivers/dma/ioatdma.c	2007-07-02 09:38:15.129184000 +0100
+++ RFCpatched/drivers/dma/ioatdma.c	2007-07-03 12:58:01.525560000 +0100
@@ -110,7 +110,7 @@ static struct ioat_desc_sw *ioat_dma_all
 static void ioat_start_null_desc(struct ioat_dma_chan *ioat_chan);
 
 /* returns the actual number of allocated descriptors */
-static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
+static int ioat_dma_alloc_chan_resources(struct dma_chan, struct dma_client
*client)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_desc_sw *desc = NULL;
diff -purN RFCbase/include/linux/dmaengine.h
RFCpatched/include/linux/dmaengine.h
--- RFCbase/include/linux/dmaengine.h	2007-07-02 09:39:08.954261000 +0100
+++ RFCpatched/include/linux/dmaengine.h	2007-07-03
15:46:33.552608000 +0100
@@ -143,6 +143,8 @@ typedef void (*dma_event_callback) (stru
  * @event_callback: func ptr to call when something happens
  * @chan_count: number of chans allocated
  * @chans_desired: number of chans requested. Can be +/- chan_count
+ * @client_data: ptr to data which allows implementations to distinguish
+ *               between clients
  * @lock: protects access to the channels list
  * @channels: the list of DMA channels allocated
  * @global_node: list_head for global dma_client_list
@@ -151,6 +153,7 @@ struct dma_client {
 	dma_event_callback	event_callback;
 	unsigned int		chan_count;
 	unsigned int		chans_desired;
+	void *client_data;
 
 	spinlock_t		lock;
 	struct list_head	channels;


