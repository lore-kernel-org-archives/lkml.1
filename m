Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760439AbYLQAJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439AbYLQAJu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbYLQAGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:13 -0500
Received: from kroah.org ([198.145.64.141]:41354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759530AbYLQAGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:10 -0500
Date: Tue, 16 Dec 2008 16:04:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 16/22] firewire: fw-ohci: fix IOMMU resource exhaustion
Message-ID: <20081217000431.GQ4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fw-ohci-fix-iommu-resource-exhaustion.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 1d1dc5e83f3299c108a4e44d58cc4bfef48c876a upstream.

There is a DMA map/ unmap imbalance whenever a block write request
packet is sent and then dequeued with ohci_cancel_packet.  The latter
may happen frequently if the AR resp tasklet is executed before the AT
req tasklet for the same transaction.

Add the missing dma_unmap_single.  This fixes
https://bugzilla.redhat.com/show_bug.cgi?id=475156

Reported-by: Emmanuel Kowalski
Tested-by: Emmanuel Kowalski
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-ohci.c        |   11 +++++++----
 drivers/firewire/fw-transaction.c |    3 +++
 drivers/firewire/fw-transaction.h |    2 ++
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -958,6 +958,7 @@ at_context_queue_packet(struct context *
 			packet->ack = RCODE_SEND_ERROR;
 			return -1;
 		}
+		packet->payload_bus = payload_bus;
 
 		d[2].req_count    = cpu_to_le16(packet->payload_length);
 		d[2].data_address = cpu_to_le32(payload_bus);
@@ -1009,7 +1010,6 @@ static int handle_at_packet(struct conte
 	struct driver_data *driver_data;
 	struct fw_packet *packet;
 	struct fw_ohci *ohci = context->ohci;
-	dma_addr_t payload_bus;
 	int evt;
 
 	if (last->transfer_status == 0)
@@ -1022,9 +1022,8 @@ static int handle_at_packet(struct conte
 		/* This packet was cancelled, just continue. */
 		return 1;
 
-	payload_bus = le32_to_cpu(last->data_address);
-	if (payload_bus != 0)
-		dma_unmap_single(ohci->card.device, payload_bus,
+	if (packet->payload_bus)
+		dma_unmap_single(ohci->card.device, packet->payload_bus,
 				 packet->payload_length, DMA_TO_DEVICE);
 
 	evt = le16_to_cpu(last->transfer_status) & 0x1f;
@@ -1681,6 +1680,10 @@ static int ohci_cancel_packet(struct fw_
 	if (packet->ack != 0)
 		goto out;
 
+	if (packet->payload_bus)
+		dma_unmap_single(ohci->card.device, packet->payload_bus,
+				 packet->payload_length, DMA_TO_DEVICE);
+
 	log_ar_at_event('T', packet->speed, packet->header, 0x20);
 	driver_data->packet = NULL;
 	packet->ack = RCODE_CANCELLED;
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -207,6 +207,7 @@ fw_fill_request(struct fw_packet *packet
 	packet->speed = speed;
 	packet->generation = generation;
 	packet->ack = 0;
+	packet->payload_bus = 0;
 }
 
 /**
@@ -541,6 +542,8 @@ fw_fill_response(struct fw_packet *respo
 		BUG();
 		return;
 	}
+
+	response->payload_bus = 0;
 }
 EXPORT_SYMBOL(fw_fill_response);
 
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

