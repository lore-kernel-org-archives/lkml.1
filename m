Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbXGHXJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbXGHXJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXGHXJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:09:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51036 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGHXJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:09:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 9 Jul 2007 01:09:08 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC PATCH resend] ieee1394: remove old isochronous ABI
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, Adrian Bunk <bunk@stusta.de>
Message-ID: <tkrat.6383600ec76139e7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Sun, 24 Jun 2007 15:31:54 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC PATCH] ieee1394: remove old isochronous ABI

Based on patch "the scheduled removal of RAW1394_REQ_ISO_{SEND,LISTEN}"
from Adrian Bunk, November 20 2006.

This patch also removes the underlying facilities in ohci1394 and
disables them in pcilynx.  That is, hpsb_host_driver.devctl() and
hpsb_host_driver.transmit_packet() are no longer used for iso reception
and transmission.

Since video1394 and dv1394 only work with ohci1394 and raw1394's rawiso
interface has never been implemented in pcilynx, pcilynx is now no
longer useful for isochronous applications.

raw1394 will still handle the request types but will complete the
requests with errors that indicate API version conflicts.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---


This patch has been sent to linux1394-devel and libdc1394-devel and
didn't receive a comment.


 Documentation/ABI/removed/raw1394_legacy_isochronous |   16 
 Documentation/feature-removal-schedule.txt           |   10 
 drivers/ieee1394/highlevel.c                         |   45 --
 drivers/ieee1394/highlevel.h                         |   16 
 drivers/ieee1394/hosts.h                             |    8 
 drivers/ieee1394/ieee1394_core.c                     |    8 
 drivers/ieee1394/ieee1394_core.h                     |    5 
 drivers/ieee1394/ieee1394_transactions.c             |   30 -
 drivers/ieee1394/ieee1394_transactions.h             |    2 
 drivers/ieee1394/ohci1394.c                          |  221 -----------
 drivers/ieee1394/ohci1394.h                          |   14 
 drivers/ieee1394/pcilynx.c                           |   16 
 drivers/ieee1394/raw1394-private.h                   |    5 
 drivers/ieee1394/raw1394.c                           |  176 --------
 drivers/ieee1394/raw1394.h                           |    4 
 15 files changed, 48 insertions(+), 528 deletions(-)

Index: linux/Documentation/ABI/removed/raw1394_legacy_isochronous
===================================================================
--- /dev/null
+++ linux/Documentation/ABI/removed/raw1394_legacy_isochronous
@@ -0,0 +1,16 @@
+What:		legacy isochronous ABI of raw1394 (1st generation iso ABI)
+Date:		June 2007 (scheduled), removed in kernel v2.6.23
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+	The two request types RAW1394_REQ_ISO_SEND, RAW1394_REQ_ISO_LISTEN have
+	been deprecated for quite some time.  They are very inefficient as they
+	come with high interrupt load and several layers of callbacks for each
+	packet.  Because of these deficiencies, the video1394 and dv1394 drivers
+	and the 3rd-generation isochronous ABI in raw1394 (rawiso) were created.
+
+Users:
+	libraw1394 users via the long deprecated API raw1394_iso_write,
+	raw1394_start_iso_write, raw1394_start_iso_rcv, raw1394_stop_iso_rcv
+
+	libdc1394, which optionally uses these old libraw1394 calls
+	alternatively to the more efficient video1394 ABI
Index: linux/Documentation/feature-removal-schedule.txt
===================================================================
--- linux.orig/Documentation/feature-removal-schedule.txt
+++ linux/Documentation/feature-removal-schedule.txt
@@ -49,16 +49,6 @@ Who:	Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
 
-What:	raw1394: requests of type RAW1394_REQ_ISO_SEND, RAW1394_REQ_ISO_LISTEN
-When:	June 2007
-Why:	Deprecated in favour of the more efficient and robust rawiso interface.
-	Affected are applications which use the deprecated part of libraw1394
-	(raw1394_iso_write, raw1394_start_iso_write, raw1394_start_iso_rcv,
-	raw1394_stop_iso_rcv) or bypass	libraw1394.
-Who:	Dan Dennedy <dan@dennedy.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
-
----------------------------
-
 What:	old NCR53C9x driver
 When:	October 2007
 Why:	Replaced by the much better esp_scsi driver.  Actual low-level
Index: linux/drivers/ieee1394/raw1394.h
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.h
+++ linux/drivers/ieee1394/raw1394.h
@@ -17,11 +17,11 @@
 #define RAW1394_REQ_ASYNC_WRITE     101
 #define RAW1394_REQ_LOCK            102
 #define RAW1394_REQ_LOCK64          103
-#define RAW1394_REQ_ISO_SEND        104
+#define RAW1394_REQ_ISO_SEND        104 /* removed ABI, now a no-op */
 #define RAW1394_REQ_ASYNC_SEND      105
 #define RAW1394_REQ_ASYNC_STREAM    106
 
-#define RAW1394_REQ_ISO_LISTEN      200
+#define RAW1394_REQ_ISO_LISTEN      200 /* removed ABI, now a no-op */
 #define RAW1394_REQ_FCP_LISTEN      201
 #define RAW1394_REQ_RESET_BUS       202
 #define RAW1394_REQ_GET_ROM         203
Index: linux/drivers/ieee1394/raw1394-private.h
===================================================================
--- linux.orig/drivers/ieee1394/raw1394-private.h
+++ linux/drivers/ieee1394/raw1394-private.h
@@ -36,11 +36,6 @@ struct file_info {
 
         u8 __user *fcp_buffer;
 
-	/* old ISO API */
-        u64 listen_channels;
-        quadlet_t __user *iso_buffer;
-        size_t iso_buffer_length;
-
         u8 notification; /* (busreset-notification) RAW1394_NOTIFY_OFF/ON */
 
 	/* new rawiso API */
Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -98,21 +98,6 @@ static struct hpsb_address_ops arm_ops =
 
 static void queue_complete_cb(struct pending_request *req);
 
-#include <asm/current.h>
-static void print_old_iso_deprecation(void)
-{
-	static pid_t p;
-
-	if (p == current->pid)
-		return;
-	p = current->pid;
-	printk(KERN_WARNING "raw1394: WARNING - Program \"%s\" uses unsupported"
-	       " isochronous request types which will be removed in a next"
-	       " kernel release\n", current->comm);
-	printk(KERN_WARNING "raw1394: Update your software to use libraw1394's"
-	       " newer interface\n");
-}
-
 static struct pending_request *__alloc_pending_request(gfp_t flags)
 {
 	struct pending_request *req;
@@ -297,67 +282,6 @@ static void host_reset(struct hpsb_host 
 	spin_unlock_irqrestore(&host_info_lock, flags);
 }
 
-static void iso_receive(struct hpsb_host *host, int channel, quadlet_t * data,
-			size_t length)
-{
-	unsigned long flags;
-	struct host_info *hi;
-	struct file_info *fi;
-	struct pending_request *req, *req_next;
-	struct iso_block_store *ibs = NULL;
-	LIST_HEAD(reqs);
-
-	if ((atomic_read(&iso_buffer_size) + length) > iso_buffer_max) {
-		HPSB_INFO("dropped iso packet");
-		return;
-	}
-
-	spin_lock_irqsave(&host_info_lock, flags);
-	hi = find_host_info(host);
-
-	if (hi != NULL) {
-		list_for_each_entry(fi, &hi->file_info_list, list) {
-			if (!(fi->listen_channels & (1ULL << channel)))
-				continue;
-
-			req = __alloc_pending_request(GFP_ATOMIC);
-			if (!req)
-				break;
-
-			if (!ibs) {
-				ibs = kmalloc(sizeof(*ibs) + length,
-					      GFP_ATOMIC);
-				if (!ibs) {
-					kfree(req);
-					break;
-				}
-
-				atomic_add(length, &iso_buffer_size);
-				atomic_set(&ibs->refcount, 0);
-				ibs->data_size = length;
-				memcpy(ibs->data, data, length);
-			}
-
-			atomic_inc(&ibs->refcount);
-
-			req->file_info = fi;
-			req->ibs = ibs;
-			req->data = ibs->data;
-			req->req.type = RAW1394_REQ_ISO_RECEIVE;
-			req->req.generation = get_hpsb_generation(host);
-			req->req.misc = 0;
-			req->req.recvb = ptr2int(fi->iso_buffer);
-			req->req.length = min(length, fi->iso_buffer_length);
-
-			list_add_tail(&req->list, &reqs);
-		}
-	}
-	spin_unlock_irqrestore(&host_info_lock, flags);
-
-	list_for_each_entry_safe(req, req_next, &reqs, list)
-	    queue_complete_req(req);
-}
-
 static void fcp_request(struct hpsb_host *host, int nodeid, int direction,
 			int cts, u8 * data, size_t length)
 {
@@ -676,43 +600,6 @@ out_set_card:
 	return 0;
 }
 
-static void handle_iso_listen(struct file_info *fi, struct pending_request *req)
-{
-	int channel = req->req.misc;
-
-	if ((channel > 63) || (channel < -64)) {
-		req->req.error = RAW1394_ERROR_INVALID_ARG;
-	} else if (channel >= 0) {
-		/* allocate channel req.misc */
-		if (fi->listen_channels & (1ULL << channel)) {
-			req->req.error = RAW1394_ERROR_ALREADY;
-		} else {
-			if (hpsb_listen_channel
-			    (&raw1394_highlevel, fi->host, channel)) {
-				req->req.error = RAW1394_ERROR_ALREADY;
-			} else {
-				fi->listen_channels |= 1ULL << channel;
-				fi->iso_buffer = int2ptr(req->req.recvb);
-				fi->iso_buffer_length = req->req.length;
-			}
-		}
-	} else {
-		/* deallocate channel (one's complement neg) req.misc */
-		channel = ~channel;
-
-		if (fi->listen_channels & (1ULL << channel)) {
-			hpsb_unlisten_channel(&raw1394_highlevel, fi->host,
-					      channel);
-			fi->listen_channels &= ~(1ULL << channel);
-		} else {
-			req->req.error = RAW1394_ERROR_INVALID_ARG;
-		}
-	}
-
-	req->req.length = 0;
-	queue_complete_req(req);
-}
-
 static void handle_fcp_listen(struct file_info *fi, struct pending_request *req)
 {
 	if (req->req.misc) {
@@ -886,50 +773,6 @@ static int handle_async_request(struct f
 	return 0;
 }
 
-static int handle_iso_send(struct file_info *fi, struct pending_request *req,
-			   int channel)
-{
-	unsigned long flags;
-	struct hpsb_packet *packet;
-
-	packet = hpsb_make_isopacket(fi->host, req->req.length, channel & 0x3f,
-				     (req->req.misc >> 16) & 0x3,
-				     req->req.misc & 0xf);
-	if (!packet)
-		return -ENOMEM;
-
-	packet->speed_code = req->req.address & 0x3;
-
-	req->packet = packet;
-
-	if (copy_from_user(packet->data, int2ptr(req->req.sendb),
-			   req->req.length)) {
-		req->req.error = RAW1394_ERROR_MEMFAULT;
-		req->req.length = 0;
-		queue_complete_req(req);
-		return 0;
-	}
-
-	req->req.length = 0;
-	hpsb_set_packet_complete_task(packet,
-				      (void (*)(void *))queue_complete_req,
-				      req);
-
-	spin_lock_irqsave(&fi->reqlists_lock, flags);
-	list_add_tail(&req->list, &fi->req_pending);
-	spin_unlock_irqrestore(&fi->reqlists_lock, flags);
-
-	/* Update the generation of the packet just before sending. */
-	packet->generation = req->req.generation;
-
-	if (hpsb_send_packet(packet) < 0) {
-		req->req.error = RAW1394_ERROR_SEND_ERROR;
-		queue_complete_req(req);
-	}
-
-	return 0;
-}
-
 static int handle_async_send(struct file_info *fi, struct pending_request *req)
 {
 	unsigned long flags;
@@ -2313,10 +2156,6 @@ static int state_connected(struct file_i
 		queue_complete_req(req);
 		return 0;
 
-	case RAW1394_REQ_ISO_SEND:
-		print_old_iso_deprecation();
-		return handle_iso_send(fi, req, node);
-
 	case RAW1394_REQ_ARM_REGISTER:
 		return arm_register(fi, req);
 
@@ -2332,9 +2171,12 @@ static int state_connected(struct file_i
 	case RAW1394_REQ_RESET_NOTIFY:
 		return reset_notification(fi, req);
 
+	case RAW1394_REQ_ISO_SEND:
 	case RAW1394_REQ_ISO_LISTEN:
-		print_old_iso_deprecation();
-		handle_iso_listen(fi, req);
+		printk(KERN_DEBUG "raw1394: old iso ABI has been removed\n");
+		req->req.error = RAW1394_ERROR_COMPAT;
+		req->req.misc = RAW1394_KERNELAPI_VERSION;
+		queue_complete_req(req);
 		return 0;
 
 	case RAW1394_REQ_FCP_LISTEN:
@@ -2961,14 +2803,7 @@ static int raw1394_release(struct inode 
 	if (fi->iso_state != RAW1394_ISO_INACTIVE)
 		raw1394_iso_shutdown(fi);
 
-	for (i = 0; i < 64; i++) {
-		if (fi->listen_channels & (1ULL << i)) {
-			hpsb_unlisten_channel(&raw1394_highlevel, fi->host, i);
-		}
-	}
-
 	spin_lock_irqsave(&host_info_lock, flags);
-	fi->listen_channels = 0;
 
 	fail = 0;
 	/* set address-entries invalid */
@@ -3130,7 +2965,6 @@ static struct hpsb_highlevel raw1394_hig
 	.add_host = add_host,
 	.remove_host = remove_host,
 	.host_reset = host_reset,
-	.iso_receive = iso_receive,
 	.fcp_request = fcp_request,
 };
 
Index: linux/drivers/ieee1394/highlevel.c
===================================================================
--- linux.orig/drivers/ieee1394/highlevel.c
+++ linux/drivers/ieee1394/highlevel.c
@@ -483,37 +483,6 @@ int hpsb_unregister_addrspace(struct hps
 	return retval;
 }
 
-/**
- * hpsb_listen_channel - enable receving a certain isochronous channel
- *
- * Reception is handled through the @hl's iso_receive op.
- */
-int hpsb_listen_channel(struct hpsb_highlevel *hl, struct hpsb_host *host,
-			unsigned int channel)
-{
-	if (channel > 63) {
-		HPSB_ERR("%s called with invalid channel", __FUNCTION__);
-		return -EINVAL;
-	}
-	if (host->iso_listen_count[channel]++ == 0)
-		return host->driver->devctl(host, ISO_LISTEN_CHANNEL, channel);
-	return 0;
-}
-
-/**
- * hpsb_unlisten_channel - disable receving a certain isochronous channel
- */
-void hpsb_unlisten_channel(struct hpsb_highlevel *hl, struct hpsb_host *host,
-			   unsigned int channel)
-{
-	if (channel > 63) {
-		HPSB_ERR("%s called with invalid channel", __FUNCTION__);
-		return;
-	}
-	if (--host->iso_listen_count[channel] == 0)
-		host->driver->devctl(host, ISO_UNLISTEN_CHANNEL, channel);
-}
-
 static void init_hpsb_highlevel(struct hpsb_host *host)
 {
 	INIT_LIST_HEAD(&dummy_zero_addr.host_list);
@@ -570,20 +539,6 @@ void highlevel_host_reset(struct hpsb_ho
 	read_unlock_irqrestore(&hl_irqs_lock, flags);
 }
 
-void highlevel_iso_receive(struct hpsb_host *host, void *data, size_t length)
-{
-	unsigned long flags;
-	struct hpsb_highlevel *hl;
-	int channel = (((quadlet_t *)data)[0] >> 8) & 0x3f;
-
-	read_lock_irqsave(&hl_irqs_lock, flags);
-	list_for_each_entry(hl, &hl_irqs, irq_list) {
-		if (hl->iso_receive)
-			hl->iso_receive(host, channel, data, length);
-	}
-	read_unlock_irqrestore(&hl_irqs_lock, flags);
-}
-
 void highlevel_fcp_request(struct hpsb_host *host, int nodeid, int direction,
 			   void *data, size_t length)
 {
Index: linux/drivers/ieee1394/highlevel.h
===================================================================
--- linux.orig/drivers/ieee1394/highlevel.h
+++ linux/drivers/ieee1394/highlevel.h
@@ -26,9 +26,7 @@ struct hpsb_address_serve {
 struct hpsb_highlevel {
 	const char *name;
 
-	/* Any of the following pointers can legally be NULL, except for
-	 * iso_receive which can only be NULL when you don't request
-	 * channels. */
+	/* Any of the following pointers can legally be NULL. */
 
 	/* New host initialized.  Will also be called during
 	 * hpsb_register_highlevel for all hosts already installed. */
@@ -43,13 +41,6 @@ struct hpsb_highlevel {
 	 * You can not expect to be able to do stock hpsb_reads. */
 	void (*host_reset)(struct hpsb_host *host);
 
-	/* An isochronous packet was received.  Channel contains the channel
-	 * number for your convenience, it is also contained in the included
-	 * packet header (first quadlet, CRCs are missing).  You may get called
-	 * for channel/host combinations you did not request. */
-	void (*iso_receive)(struct hpsb_host *host, int channel,
-			    quadlet_t *data, size_t length);
-
 	/* A write request was received on either the FCP_COMMAND (direction =
 	 * 0) or the FCP_RESPONSE (direction = 1) register.  The cts arg
 	 * contains the cts field (first byte of data). */
@@ -109,7 +100,6 @@ int highlevel_lock(struct hpsb_host *hos
 int highlevel_lock64(struct hpsb_host *host, int nodeid, octlet_t *store,
 		     u64 addr, octlet_t data, octlet_t arg, int ext_tcode,
 		     u16 flags);
-void highlevel_iso_receive(struct hpsb_host *host, void *data, size_t length);
 void highlevel_fcp_request(struct hpsb_host *host, int nodeid, int direction,
 			   void *data, size_t length);
 
@@ -125,10 +115,6 @@ int hpsb_register_addrspace(struct hpsb_
 			    struct hpsb_address_ops *ops, u64 start, u64 end);
 int hpsb_unregister_addrspace(struct hpsb_highlevel *hl, struct hpsb_host *host,
 			      u64 start);
-int hpsb_listen_channel(struct hpsb_highlevel *hl, struct hpsb_host *host,
-			unsigned int channel);
-void hpsb_unlisten_channel(struct hpsb_highlevel *hl, struct hpsb_host *host,
-			   unsigned int channel);
 
 void *hpsb_get_hostinfo(struct hpsb_highlevel *hl, struct hpsb_host *host);
 void *hpsb_create_hostinfo(struct hpsb_highlevel *hl, struct hpsb_host *host,
Index: linux/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.c
+++ linux/drivers/ieee1394/ieee1394_core.c
@@ -1028,11 +1028,6 @@ void hpsb_packet_received(struct hpsb_ho
 		handle_incoming_packet(host, tcode, data, size, write_acked);
 		break;
 
-
-	case TCODE_ISO_DATA:
-		highlevel_iso_receive(host, data, size);
-		break;
-
 	case TCODE_CYCLE_START:
 		/* simply ignore this packet if it is passed on */
 		break;
@@ -1316,7 +1311,6 @@ EXPORT_SYMBOL(hpsb_make_streampacket);
 EXPORT_SYMBOL(hpsb_make_lockpacket);
 EXPORT_SYMBOL(hpsb_make_lock64packet);
 EXPORT_SYMBOL(hpsb_make_phypacket);
-EXPORT_SYMBOL(hpsb_make_isopacket);
 EXPORT_SYMBOL(hpsb_read);
 EXPORT_SYMBOL(hpsb_write);
 EXPORT_SYMBOL(hpsb_packet_success);
@@ -1327,8 +1321,6 @@ EXPORT_SYMBOL(hpsb_unregister_highlevel)
 EXPORT_SYMBOL(hpsb_register_addrspace);
 EXPORT_SYMBOL(hpsb_unregister_addrspace);
 EXPORT_SYMBOL(hpsb_allocate_and_register_addrspace);
-EXPORT_SYMBOL(hpsb_listen_channel);
-EXPORT_SYMBOL(hpsb_unlisten_channel);
 EXPORT_SYMBOL(hpsb_get_hostinfo);
 EXPORT_SYMBOL(hpsb_create_hostinfo);
 EXPORT_SYMBOL(hpsb_destroy_hostinfo);
Index: linux/drivers/ieee1394/ieee1394_transactions.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_transactions.c
+++ linux/drivers/ieee1394/ieee1394_transactions.c
@@ -89,18 +89,6 @@ static void fill_async_lock(struct hpsb_
 	packet->expect_response = 1;
 }
 
-static void fill_iso_packet(struct hpsb_packet *packet, int length, int channel,
-			    int tag, int sync)
-{
-	packet->header[0] = (length << 16) | (tag << 14) | (channel << 8)
-	    | (TCODE_ISO_DATA << 4) | sync;
-
-	packet->header_size = 4;
-	packet->data_size = length;
-	packet->type = hpsb_iso;
-	packet->tcode = TCODE_ISO_DATA;
-}
-
 static void fill_phy_packet(struct hpsb_packet *packet, quadlet_t data)
 {
 	packet->header[0] = data;
@@ -491,24 +479,6 @@ struct hpsb_packet *hpsb_make_phypacket(
 	return p;
 }
 
-struct hpsb_packet *hpsb_make_isopacket(struct hpsb_host *host,
-					int length, int channel,
-					int tag, int sync)
-{
-	struct hpsb_packet *p;
-
-	p = hpsb_alloc_packet(length);
-	if (!p)
-		return NULL;
-
-	p->host = host;
-	fill_iso_packet(p, length, channel, tag, sync);
-
-	p->generation = get_hpsb_generation(host);
-
-	return p;
-}
-
 /*
  * FIXME - these functions should probably read from / write to user space to
  * avoid in kernel buffers for user space callers
Index: linux/drivers/ieee1394/ieee1394_transactions.h
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_transactions.h
+++ linux/drivers/ieee1394/ieee1394_transactions.h
@@ -19,8 +19,6 @@ struct hpsb_packet *hpsb_make_lock64pack
 					   nodeid_t node, u64 addr, int extcode,
 					   octlet_t *data, octlet_t arg);
 struct hpsb_packet *hpsb_make_phypacket(struct hpsb_host *host, quadlet_t data);
-struct hpsb_packet *hpsb_make_isopacket(struct hpsb_host *host, int length,
-					int channel, int tag, int sync);
 struct hpsb_packet *hpsb_make_writepacket(struct hpsb_host *host,
 					  nodeid_t node, u64 addr,
 					  quadlet_t *buffer, size_t length);
Index: linux/drivers/ieee1394/ieee1394_core.h
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.h
+++ linux/drivers/ieee1394/ieee1394_core.h
@@ -24,9 +24,8 @@ struct hpsb_packet {
 
 	nodeid_t node_id;
 
-	/* Async and Iso types should be clear, raw means send-as-is, do not
-	 * CRC!  Byte swapping shall still be done in this case. */
-	enum { hpsb_async, hpsb_iso, hpsb_raw } __attribute__((packed)) type;
+	/* hpsb_raw = send as-is, do not CRC (but still byte-swap it) */
+	enum { hpsb_async, hpsb_raw } __attribute__((packed)) type;
 
 	/* Okay, this is core internal and a no care for hosts.
 	 * queued   = queued for sending
Index: linux/drivers/ieee1394/hosts.h
===================================================================
--- linux.orig/drivers/ieee1394/hosts.h
+++ linux/drivers/ieee1394/hosts.h
@@ -28,8 +28,6 @@ struct hpsb_host {
 	struct timer_list timeout;
 	unsigned long timeout_interval;
 
-	unsigned char iso_listen_count[64];
-
 	int node_count;      /* number of identified nodes on this bus */
 	int selfid_count;    /* total number of SelfIDs received */
 	int nodes_active;    /* number of nodes with active link layer */
@@ -99,12 +97,6 @@ enum devctl_cmd {
 	/* Cancel all outstanding async requests without resetting the bus.
 	 * Return void. */
 	CANCEL_REQUESTS,
-
-	/* Start or stop receiving isochronous channel in arg.  Return void.
-	 * This acts as an optimization hint, hosts are not required not to
-	 * listen on unrequested channels. */
-	ISO_LISTEN_CHANNEL,
-	ISO_UNLISTEN_CHANNEL
 };
 
 enum isoctl_cmd {
Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -157,7 +157,6 @@ static void dma_trm_reset(struct dma_trm
 static int alloc_dma_rcv_ctx(struct ti_ohci *ohci, struct dma_rcv_ctx *d,
 			     enum context_type type, int ctx, int num_desc,
 			     int buf_size, int split_buf_size, int context_base);
-static void stop_dma_rcv_ctx(struct dma_rcv_ctx *d);
 static void free_dma_rcv_ctx(struct dma_rcv_ctx *d);
 
 static int alloc_dma_trm_ctx(struct ti_ohci *ohci, struct dma_trm_ctx *d,
@@ -520,9 +519,6 @@ static void ohci_initialize(struct ti_oh
 	initialize_dma_trm_ctx(&ohci->at_req_context);
 	initialize_dma_trm_ctx(&ohci->at_resp_context);
 	
-	/* Initialize IR Legacy DMA channel mask */
-	ohci->ir_legacy_channels = 0;
-
 	/* Accept AR requests from all nodes */
 	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
 
@@ -869,36 +865,9 @@ static int ohci_transmit(struct hpsb_hos
 		return -EOVERFLOW;
 	}
 
-	/* Decide whether we have an iso, a request, or a response packet */
 	if (packet->type == hpsb_raw)
 		d = &ohci->at_req_context;
-	else if ((packet->tcode == TCODE_ISO_DATA) && (packet->type == hpsb_iso)) {
-		/* The legacy IT DMA context is initialized on first
-		 * use.  However, the alloc cannot be run from
-		 * interrupt context, so we bail out if that is the
-		 * case. I don't see anyone sending ISO packets from
-		 * interrupt context anyway... */
-
-		if (ohci->it_legacy_context.ohci == NULL) {
-			if (in_interrupt()) {
-				PRINT(KERN_ERR,
-				      "legacy IT context cannot be initialized during interrupt");
-				return -EINVAL;
-			}
-
-			if (alloc_dma_trm_ctx(ohci, &ohci->it_legacy_context,
-					      DMA_CTX_ISO, 0, IT_NUM_DESC,
-					      OHCI1394_IsoXmitContextBase) < 0) {
-				PRINT(KERN_ERR,
-				      "error initializing legacy IT context");
-				return -ENOMEM;
-			}
-
-			initialize_dma_trm_ctx(&ohci->it_legacy_context);
-		}
-
-		d = &ohci->it_legacy_context;
-	} else if ((packet->tcode & 0x02) && (packet->tcode != TCODE_ISO_DATA))
+	else if ((packet->tcode & 0x02) && (packet->tcode != TCODE_ISO_DATA))
 		d = &ohci->at_resp_context;
 	else
 		d = &ohci->at_req_context;
@@ -917,9 +886,7 @@ static int ohci_transmit(struct hpsb_hos
 static int ohci_devctl(struct hpsb_host *host, enum devctl_cmd cmd, int arg)
 {
 	struct ti_ohci *ohci = host->hostdata;
-	int retval = 0;
-	unsigned long flags;
-	int phy_reg;
+	int retval = 0, phy_reg;
 
 	switch (cmd) {
 	case RESET_BUS:
@@ -1012,117 +979,6 @@ static int ohci_devctl(struct hpsb_host 
 		dma_trm_reset(&ohci->at_resp_context);
 		break;
 
-	case ISO_LISTEN_CHANNEL:
-        {
-		u64 mask;
-		struct dma_rcv_ctx *d = &ohci->ir_legacy_context;
-		int ir_legacy_active;
-
-		if (arg<0 || arg>63) {
-			PRINT(KERN_ERR,
-			      "%s: IS0 listen channel %d is out of range",
-			      __FUNCTION__, arg);
-			return -EFAULT;
-		}
-
-		mask = (u64)0x1<<arg;
-
-                spin_lock_irqsave(&ohci->IR_channel_lock, flags);
-
-		if (ohci->ISO_channel_usage & mask) {
-			PRINT(KERN_ERR,
-			      "%s: IS0 listen channel %d is already used",
-			      __FUNCTION__, arg);
-			spin_unlock_irqrestore(&ohci->IR_channel_lock, flags);
-			return -EFAULT;
-		}
-
-		ir_legacy_active = ohci->ir_legacy_channels;
-
-		ohci->ISO_channel_usage |= mask;
-		ohci->ir_legacy_channels |= mask;
-
-                spin_unlock_irqrestore(&ohci->IR_channel_lock, flags);
-
-		if (!ir_legacy_active) {
-			if (ohci1394_register_iso_tasklet(ohci,
-					  &ohci->ir_legacy_tasklet) < 0) {
-				PRINT(KERN_ERR, "No IR DMA context available");
-				return -EBUSY;
-			}
-
-			/* the IR context can be assigned to any DMA context
-			 * by ohci1394_register_iso_tasklet */
-			d->ctx = ohci->ir_legacy_tasklet.context;
-			d->ctrlSet = OHCI1394_IsoRcvContextControlSet +
-				32*d->ctx;
-			d->ctrlClear = OHCI1394_IsoRcvContextControlClear +
-				32*d->ctx;
-			d->cmdPtr = OHCI1394_IsoRcvCommandPtr + 32*d->ctx;
-			d->ctxtMatch = OHCI1394_IsoRcvContextMatch + 32*d->ctx;
-
-			initialize_dma_rcv_ctx(&ohci->ir_legacy_context, 1);
-
-			if (printk_ratelimit())
-				DBGMSG("IR legacy activated");
-		}
-
-                spin_lock_irqsave(&ohci->IR_channel_lock, flags);
-
-		if (arg>31)
-			reg_write(ohci, OHCI1394_IRMultiChanMaskHiSet,
-				  1<<(arg-32));
-		else
-			reg_write(ohci, OHCI1394_IRMultiChanMaskLoSet,
-				  1<<arg);
-
-                spin_unlock_irqrestore(&ohci->IR_channel_lock, flags);
-                DBGMSG("Listening enabled on channel %d", arg);
-                break;
-        }
-	case ISO_UNLISTEN_CHANNEL:
-        {
-		u64 mask;
-
-		if (arg<0 || arg>63) {
-			PRINT(KERN_ERR,
-			      "%s: IS0 unlisten channel %d is out of range",
-			      __FUNCTION__, arg);
-			return -EFAULT;
-		}
-
-		mask = (u64)0x1<<arg;
-
-                spin_lock_irqsave(&ohci->IR_channel_lock, flags);
-
-		if (!(ohci->ISO_channel_usage & mask)) {
-			PRINT(KERN_ERR,
-			      "%s: IS0 unlisten channel %d is not used",
-			      __FUNCTION__, arg);
-			spin_unlock_irqrestore(&ohci->IR_channel_lock, flags);
-			return -EFAULT;
-		}
-
-		ohci->ISO_channel_usage &= ~mask;
-		ohci->ir_legacy_channels &= ~mask;
-
-		if (arg>31)
-			reg_write(ohci, OHCI1394_IRMultiChanMaskHiClear,
-				  1<<(arg-32));
-		else
-			reg_write(ohci, OHCI1394_IRMultiChanMaskLoClear,
-				  1<<arg);
-
-                spin_unlock_irqrestore(&ohci->IR_channel_lock, flags);
-                DBGMSG("Listening disabled on channel %d", arg);
-
-		if (ohci->ir_legacy_channels == 0) {
-			stop_dma_rcv_ctx(&ohci->ir_legacy_context);
-			DBGMSG("ISO legacy receive context stopped");
-		}
-
-                break;
-        }
 	default:
 		PRINT_G(KERN_ERR, "ohci_devctl cmd %d not implemented yet",
 			cmd);
@@ -2868,22 +2724,6 @@ static void dma_trm_tasklet (unsigned lo
 	spin_unlock_irqrestore(&d->lock, flags);
 }
 
-static void stop_dma_rcv_ctx(struct dma_rcv_ctx *d)
-{
-	if (d->ctrlClear) {
-		ohci1394_stop_context(d->ohci, d->ctrlClear, NULL);
-
-		if (d->type == DMA_CTX_ISO) {
-			/* disable interrupts */
-			reg_write(d->ohci, OHCI1394_IsoRecvIntMaskClear, 1 << d->ctx);
-			ohci1394_unregister_iso_tasklet(d->ohci, &d->ohci->ir_legacy_tasklet);
-		} else {
-			tasklet_kill(&d->task);
-		}
-	}
-}
-
-
 static void free_dma_rcv_ctx(struct dma_rcv_ctx *d)
 {
 	int i;
@@ -3005,18 +2845,11 @@ alloc_dma_rcv_ctx(struct ti_ohci *ohci, 
 
         spin_lock_init(&d->lock);
 
-	if (type == DMA_CTX_ISO) {
-		ohci1394_init_iso_tasklet(&ohci->ir_legacy_tasklet,
-					  OHCI_ISO_MULTICHANNEL_RECEIVE,
-					  dma_rcv_tasklet, (unsigned long) d);
-	} else {
-		d->ctrlSet = context_base + OHCI1394_ContextControlSet;
-		d->ctrlClear = context_base + OHCI1394_ContextControlClear;
-		d->cmdPtr = context_base + OHCI1394_ContextCommandPtr;
-
-		tasklet_init (&d->task, dma_rcv_tasklet, (unsigned long) d);
-	}
+	d->ctrlSet = context_base + OHCI1394_ContextControlSet;
+	d->ctrlClear = context_base + OHCI1394_ContextControlClear;
+	d->cmdPtr = context_base + OHCI1394_ContextCommandPtr;
 
+	tasklet_init(&d->task, dma_rcv_tasklet, (unsigned long) d);
 	return 0;
 }
 
@@ -3097,28 +2930,10 @@ alloc_dma_trm_ctx(struct ti_ohci *ohci, 
         spin_lock_init(&d->lock);
 
 	/* initialize tasklet */
-	if (type == DMA_CTX_ISO) {
-		ohci1394_init_iso_tasklet(&ohci->it_legacy_tasklet, OHCI_ISO_TRANSMIT,
-					  dma_trm_tasklet, (unsigned long) d);
-		if (ohci1394_register_iso_tasklet(ohci,
-						  &ohci->it_legacy_tasklet) < 0) {
-			PRINT(KERN_ERR, "No IT DMA context available");
-			free_dma_trm_ctx(d);
-			return -EBUSY;
-		}
-
-		/* IT can be assigned to any context by register_iso_tasklet */
-		d->ctx = ohci->it_legacy_tasklet.context;
-		d->ctrlSet = OHCI1394_IsoXmitContextControlSet + 16 * d->ctx;
-		d->ctrlClear = OHCI1394_IsoXmitContextControlClear + 16 * d->ctx;
-		d->cmdPtr = OHCI1394_IsoXmitCommandPtr + 16 * d->ctx;
-	} else {
-		d->ctrlSet = context_base + OHCI1394_ContextControlSet;
-		d->ctrlClear = context_base + OHCI1394_ContextControlClear;
-		d->cmdPtr = context_base + OHCI1394_ContextCommandPtr;
-		tasklet_init (&d->task, dma_trm_tasklet, (unsigned long)d);
-	}
-
+	d->ctrlSet = context_base + OHCI1394_ContextControlSet;
+	d->ctrlClear = context_base + OHCI1394_ContextControlClear;
+	d->cmdPtr = context_base + OHCI1394_ContextCommandPtr;
+	tasklet_init(&d->task, dma_trm_tasklet, (unsigned long)d);
 	return 0;
 }
 
@@ -3344,20 +3159,6 @@ static int __devinit ohci1394_pci_probe(
 	ohci->ISO_channel_usage = 0;
         spin_lock_init(&ohci->IR_channel_lock);
 
-	/* Allocate the IR DMA context right here so we don't have
-	 * to do it in interrupt path - note that this doesn't
-	 * waste much memory and avoids the jugglery required to
-	 * allocate it in IRQ path. */
-	if (alloc_dma_rcv_ctx(ohci, &ohci->ir_legacy_context,
-			      DMA_CTX_ISO, 0, IR_NUM_DESC,
-			      IR_BUF_SIZE, IR_SPLIT_BUF_SIZE,
-			      OHCI1394_IsoRcvContextBase) < 0) {
-		FAIL(-ENOMEM, "Cannot allocate IR Legacy DMA context");
-	}
-
-	/* We hopefully don't have to pre-allocate IT DMA like we did
-	 * for IR DMA above. Allocate it on-demand and mark inactive. */
-	ohci->it_legacy_context.ohci = NULL;
 	spin_lock_init(&ohci->event_lock);
 
 	/*
@@ -3450,8 +3251,6 @@ static void ohci1394_pci_remove(struct p
 		free_dma_rcv_ctx(&ohci->ar_resp_context);
 		free_dma_trm_ctx(&ohci->at_req_context);
 		free_dma_trm_ctx(&ohci->at_resp_context);
-		free_dma_rcv_ctx(&ohci->ir_legacy_context);
-		free_dma_trm_ctx(&ohci->it_legacy_context);
 
 	case OHCI_INIT_HAVE_SELFID_BUFFER:
 		pci_free_consistent(ohci->dev, OHCI1394_SI_DMA_BUF_SIZE,
Index: linux/drivers/ieee1394/ohci1394.h
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.h
+++ linux/drivers/ieee1394/ohci1394.h
@@ -190,23 +190,10 @@ struct ti_ohci {
 	unsigned long ir_multichannel_used; /* ditto */
         spinlock_t IR_channel_lock;
 
-	/* iso receive (legacy API) */
-	u64 ir_legacy_channels; /* note: this differs from ISO_channel_usage;
-				   it only accounts for channels listened to
-				   by the legacy API, so that we can know when
-				   it is safe to free the legacy API context */
-
-	struct dma_rcv_ctx ir_legacy_context;
-	struct ohci1394_iso_tasklet ir_legacy_tasklet;
-
         /* iso transmit */
 	int nb_iso_xmit_ctx;
 	unsigned long it_ctx_usage; /* use test_and_set_bit() for atomicity */
 
-	/* iso transmit (legacy API) */
-	struct dma_trm_ctx it_legacy_context;
-	struct ohci1394_iso_tasklet it_legacy_tasklet;
-
         u64 ISO_channel_usage;
 
         /* IEEE-1394 part follows */
@@ -221,7 +208,6 @@ struct ti_ohci {
 
 	/* Tasklets for iso receive and transmit, used by video1394
 	 * and dv1394 */
-
 	struct list_head iso_tasklet_list;
 	spinlock_t iso_tasklet_list_lock;
 
Index: linux/drivers/ieee1394/pcilynx.c
===================================================================
--- linux.orig/drivers/ieee1394/pcilynx.c
+++ linux/drivers/ieee1394/pcilynx.c
@@ -477,7 +477,11 @@ static void send_next(struct ti_lynx *ly
         struct lynx_send_data *d;
         struct hpsb_packet *packet;
 
+#if 0 /* has been removed from ieee1394 core */
         d = (what == hpsb_iso ? &lynx->iso_send : &lynx->async);
+#else
+	d = &lynx->async;
+#endif
         if (!list_empty(&d->pcl_queue)) {
                 PRINT(KERN_ERR, lynx->id, "trying to queue a new packet in nonempty fifo");
                 BUG();
@@ -511,9 +515,11 @@ static void send_next(struct ti_lynx *ly
         case hpsb_async:
                 pcl.buffer[0].control |= PCL_CMD_XMT;
                 break;
+#if 0 /* has been removed from ieee1394 core */
         case hpsb_iso:
                 pcl.buffer[0].control |= PCL_CMD_XMT | PCL_ISOMODE;
                 break;
+#endif
         case hpsb_raw:
                 pcl.buffer[0].control |= PCL_CMD_UNFXMT;
                 break;
@@ -542,9 +548,11 @@ static int lynx_transmit(struct hpsb_hos
         case hpsb_raw:
                 d = &lynx->async;
                 break;
+#if 0 /* has been removed from ieee1394 core */
         case hpsb_iso:
                 d = &lynx->iso_send;
                 break;
+#endif
         default:
                 PRINT(KERN_ERR, lynx->id, "invalid packet type %d",
                       packet->type);
@@ -797,7 +805,7 @@ static int lynx_devctl(struct hpsb_host 
 		}
 
                 break;
-
+#if 0 /* has been removed from ieee1394 core */
         case ISO_LISTEN_CHANNEL:
                 spin_lock_irqsave(&lynx->iso_rcv.lock, flags);
 
@@ -819,7 +827,7 @@ static int lynx_devctl(struct hpsb_host 
 
                 spin_unlock_irqrestore(&lynx->iso_rcv.lock, flags);
                 break;
-
+#endif
         default:
                 PRINT(KERN_ERR, lynx->id, "unknown devctl command %d", cmd);
                 retval = -1;
@@ -1009,11 +1017,11 @@ static irqreturn_t lynx_irq_handler(int 
                                 pci_unmap_single(lynx->dev, lynx->iso_send.data_dma,
                                                  packet->data_size, PCI_DMA_TODEVICE);
                         }
-
+#if 0 /* has been removed from ieee1394 core */
                         if (!list_empty(&lynx->iso_send.queue)) {
                                 send_next(lynx, hpsb_iso);
                         }
-
+#endif
                         spin_unlock(&lynx->iso_send.queue_lock);
 
                         if (pcl.pcl_status & DMA_CHAN_STAT_PKTCMPL) {

-- 
Stefan Richter
-=====-=-=== -=== -=--=
http://arcgraph.de/sr/

