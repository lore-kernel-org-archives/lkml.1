Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYLJLyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYLJLyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 06:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLJLya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 06:54:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44509 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYLJLy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:54:29 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 10 Dec 2008 12:50:47 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] ieee1394 fix - updated
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.9291b0d04a76c14a@s5r6.in-berlin.de>
Message-ID: <tkrat.d342fc31303e4524@s5r6.in-berlin.de>
References: <tkrat.9291b0d04a76c14a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  9 Dec, Stefan Richter wrote:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following update:

I received confirmation for another bug fix and updated for-linus:

Nigel Cunningham (1):
      ieee1394: node manager causes up to ~3.25s delay in freezing tasks

Stefan Richter (1):
      firewire: fw-ohci: fix IOMMU resource exhaustion

 drivers/firewire/fw-ohci.c        |   11 +++++++----
 drivers/firewire/fw-transaction.c |    3 +++
 drivers/firewire/fw-transaction.h |    2 ++
 drivers/ieee1394/nodemgr.c        |    2 ++
 4 files changed, 14 insertions(+), 4 deletions(-)


commit 1d1dc5e83f3299c108a4e44d58cc4bfef48c876a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Dec 10 00:20:38 2008 +0100

    firewire: fw-ohci: fix IOMMU resource exhaustion
    
    There is a DMA map/ unmap imbalance whenever a block write request
    packet is sent and then dequeued with ohci_cancel_packet.  The latter
    may happen frequently if the AR resp tasklet is executed before the AT
    req tasklet for the same transaction.
    
    Add the missing dma_unmap_single.  This fixes
    https://bugzilla.redhat.com/show_bug.cgi?id=475156
    
    Reported-by: Emmanuel Kowalski
    Tested-by: Emmanuel Kowalski
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 46610b0..ab9c01e 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -974,6 +974,7 @@ at_context_queue_packet(struct context *ctx, struct fw_packet *packet)
 			packet->ack = RCODE_SEND_ERROR;
 			return -1;
 		}
+		packet->payload_bus = payload_bus;
 
 		d[2].req_count    = cpu_to_le16(packet->payload_length);
 		d[2].data_address = cpu_to_le32(payload_bus);
@@ -1025,7 +1026,6 @@ static int handle_at_packet(struct context *context,
 	struct driver_data *driver_data;
 	struct fw_packet *packet;
 	struct fw_ohci *ohci = context->ohci;
-	dma_addr_t payload_bus;
 	int evt;
 
 	if (last->transfer_status == 0)
@@ -1038,9 +1038,8 @@ static int handle_at_packet(struct context *context,
 		/* This packet was cancelled, just continue. */
 		return 1;
 
-	payload_bus = le32_to_cpu(last->data_address);
-	if (payload_bus != 0)
-		dma_unmap_single(ohci->card.device, payload_bus,
+	if (packet->payload_bus)
+		dma_unmap_single(ohci->card.device, packet->payload_bus,
 				 packet->payload_length, DMA_TO_DEVICE);
 
 	evt = le16_to_cpu(last->transfer_status) & 0x1f;
@@ -1697,6 +1696,10 @@ static int ohci_cancel_packet(struct fw_card *card, struct fw_packet *packet)
 	if (packet->ack != 0)
 		goto out;
 
+	if (packet->payload_bus)
+		dma_unmap_single(ohci->card.device, packet->payload_bus,
+				 packet->payload_length, DMA_TO_DEVICE);
+
 	log_ar_at_event('T', packet->speed, packet->header, 0x20);
 	driver_data->packet = NULL;
 	packet->ack = RCODE_CANCELLED;
diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 022ac4f..2884f87 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -207,6 +207,7 @@ fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
 	packet->speed = speed;
 	packet->generation = generation;
 	packet->ack = 0;
+	packet->payload_bus = 0;
 }
 
 /**
@@ -581,6 +582,8 @@ fw_fill_response(struct fw_packet *response, u32 *request_header,
 		BUG();
 		return;
 	}
+
+	response->payload_bus = 0;
 }
 EXPORT_SYMBOL(fw_fill_response);
 
diff --git a/drivers/firewire/fw-transaction.h b/drivers/firewire/fw-transaction.h
index aed7dbb..839466f 100644
--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
 #include <linux/timer.h>
+#include <linux/types.h>
 #include <linux/workqueue.h>
 
 #define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
@@ -153,6 +154,7 @@ struct fw_packet {
 	size_t header_length;
 	void *payload;
 	size_t payload_length;
+	dma_addr_t payload_bus;
 	u32 timestamp;
 
 	/*

commit ec9a13cdbfc8cf29502096ca69b65f07184a9b2c
Author: Nigel Cunningham <ncunningham@crca.org.au>
Date:   Tue Dec 9 22:40:20 2008 +1100

    ieee1394: node manager causes up to ~3.25s delay in freezing tasks
    
    The firewire nodemanager function "nodemgr_host_thread" contains a loop
    that calls try_to_freeze near the top of the loop, but then delays for
    up to 3.25 seconds (plus time to do work) before getting back to the top
    of the loop. When starting a cycle post-boot, this doesn't seem to bite,
    but it is causing a noticeable delay at boot time, when freezing
    processes prior to starting to read the image.
    
    The following patch adds invocation of try_to_freeze to the subloops
    that are used in the body of this function. With these additions, the
    time to freeze when starting to resume at boot time is virtually zero.
    I'm no expert on firewire, and so don't know that we shouldn't check
    the return value and jump back to the top of the loop or such like after
    being frozen, but I submit it for your consideration.
    
    Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
    
    The delay until nodemgr freezes was up to 0.25s (plus time for node
    probes) in Linux 2.6.27 and older and up to 3.25s (plus ~) since Linux
    2.6.28-rc1, hence much more noticeable.
    
    try_to_freeze() without any jump is correct.  The surrounding code in
    the respective loops will catch whether another bus reset happens during
    the freeze and handle it.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 9e39f73..d333ae2 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -1685,6 +1685,7 @@ static int nodemgr_host_thread(void *data)
 		g = get_hpsb_generation(host);
 		for (i = 0; i < 4 ; i++) {
 			msleep_interruptible(63);
+			try_to_freeze();
 			if (kthread_should_stop())
 				goto exit;
 
@@ -1725,6 +1726,7 @@ static int nodemgr_host_thread(void *data)
 		/* Sleep 3 seconds */
 		for (i = 3000/200; i; i--) {
 			msleep_interruptible(200);
+			try_to_freeze();
 			if (kthread_should_stop())
 				goto exit;
 


-- 
Stefan Richter
-=====-==--- ==-- -=-=-
http://arcgraph.de/sr/

