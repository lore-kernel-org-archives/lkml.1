Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbXCQXyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbXCQXyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXCQXyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:54:02 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59042 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbXCQXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:53:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 18 Mar 2007 00:53:48 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: remove usage of skb_queue as packet queue
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.be8814c580bba408@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This considerably reduces the memory requirements for a packet and
eliminates ieee1394's dependency on CONFIG_NET.

TODO:
  - Double-check if there are any drivers whose packet complete routine
    really needs process context. If there are none, get rid of khpsbpkt
    and execute the complete routine in the low-level driver's bottom
    half's context.
  - Check whether the complete packet really has to be zeroed when
    allocated.
  - Allocate small frequently used packets (e.g. quadlet read requests
    and 4...8 bytes write requests) from a kmem_cache. Append separately
    allocated data sections only if necessary.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

 drivers/ieee1394/Kconfig         |    1
 drivers/ieee1394/hosts.c         |   12 -
 drivers/ieee1394/hosts.h         |    4
 drivers/ieee1394/ieee1394_core.c |  296 ++++++++++++++++---------------
 drivers/ieee1394/ieee1394_core.h |   27 --
 5 files changed, 165 insertions(+), 175 deletions(-)


Index: linux/drivers/ieee1394/Kconfig
===================================================================
--- linux.orig/drivers/ieee1394/Kconfig
+++ linux/drivers/ieee1394/Kconfig
@@ -7,7 +7,6 @@ source "drivers/firewire/Kconfig"
 config IEEE1394
 	tristate "IEEE 1394 (FireWire) support"
 	depends on PCI || BROKEN
-	select NET
 	help
 	  IEEE 1394 describes a high performance serial bus, which is also
 	  known as FireWire(tm) or i.Link(tm) and is used for connecting all
Index: linux/drivers/ieee1394/hosts.c
===================================================================
--- linux.orig/drivers/ieee1394/hosts.c
+++ linux/drivers/ieee1394/hosts.c
@@ -94,14 +94,6 @@ static int alloc_hostnum_cb(struct hpsb_
 	return 0;
 }
 
-/*
- * The pending_packet_queue is special in that it's processed
- * from hardirq context too (such as hpsb_bus_reset()). Hence
- * split the lock class from the usual networking skb-head
- * lock class by using a separate key for it:
- */
-static struct lock_class_key pending_packet_queue_key;
-
 static DEFINE_MUTEX(host_num_alloc);
 
 /**
@@ -137,9 +129,7 @@ struct hpsb_host *hpsb_alloc_host(struct
 	h->hostdata = h + 1;
 	h->driver = drv;
 
-	skb_queue_head_init(&h->pending_packet_queue);
-	lockdep_set_class(&h->pending_packet_queue.lock,
-			   &pending_packet_queue_key);
+	INIT_LIST_HEAD(&h->pending_packets);
 	INIT_LIST_HEAD(&h->addr_space);
 
 	for (i = 2; i < 16; i++)
Index: linux/drivers/ieee1394/hosts.h
===================================================================
--- linux.orig/drivers/ieee1394/hosts.h
+++ linux/drivers/ieee1394/hosts.h
@@ -3,7 +3,6 @@
 
 #include <linux/device.h>
 #include <linux/list.h>
-#include <linux/skbuff.h>
 #include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
@@ -25,8 +24,7 @@ struct hpsb_host {
 
 	atomic_t generation;
 
-	struct sk_buff_head pending_packet_queue;
-
+	struct list_head pending_packets;
 	struct timer_list timeout;
 	unsigned long timeout_interval;
 
Index: linux/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.c
+++ linux/drivers/ieee1394/ieee1394_core.c
@@ -30,7 +30,6 @@
 #include <linux/moduleparam.h>
 #include <linux/bitops.h>
 #include <linux/kdev_t.h>
-#include <linux/skbuff.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/preempt.h>
@@ -103,6 +102,8 @@ static void queue_packet_complete(struct
  *
  * Set the task that runs when a packet completes. You cannot call this more
  * than once on a single packet before it is sent.
+ *
+ * Typically, the complete @routine is responsible to call hpsb_free_packet().
  */
 void hpsb_set_packet_complete_task(struct hpsb_packet *packet,
 				   void (*routine)(void *), void *data)
@@ -115,12 +116,12 @@ void hpsb_set_packet_complete_task(struc
 
 /**
  * hpsb_alloc_packet - allocate new packet structure
- * @data_size: size of the data block to be allocated
+ * @data_size: size of the data block to be allocated, in bytes
  *
  * This function allocates, initializes and returns a new &struct hpsb_packet.
- * It can be used in interrupt context.  A header block is always included, its
- * size is big enough to contain all possible 1394 headers.  The data block is
- * only allocated when @data_size is not zero.
+ * It can be used in interrupt context.  A header block is always included and
+ * initialized with zeros.  Its size is big enough to contain all possible 1394
+ * headers.  The data block is only allocated if @data_size is not zero.
  *
  * For packets for which responses will be received the @data_size has to be big
  * enough to contain the response's data block since no further allocation
@@ -135,50 +136,42 @@ void hpsb_set_packet_complete_task(struc
  */
 struct hpsb_packet *hpsb_alloc_packet(size_t data_size)
 {
-	struct hpsb_packet *packet = NULL;
-	struct sk_buff *skb;
+	struct hpsb_packet *packet;
 
 	data_size = ((data_size + 3) & ~3);
 
-	skb = alloc_skb(data_size + sizeof(*packet), GFP_ATOMIC);
-	if (skb == NULL)
+	packet = kzalloc(sizeof(*packet) + data_size, GFP_ATOMIC);
+	if (!packet)
 		return NULL;
 
-	memset(skb->data, 0, data_size + sizeof(*packet));
-
-	packet = (struct hpsb_packet *)skb->data;
-	packet->skb = skb;
-
-	packet->header = packet->embedded_header;
 	packet->state = hpsb_unused;
 	packet->generation = -1;
 	INIT_LIST_HEAD(&packet->driver_list);
+	INIT_LIST_HEAD(&packet->queue);
 	atomic_set(&packet->refcnt, 1);
 
 	if (data_size) {
-		packet->data = (quadlet_t *)(skb->data + sizeof(*packet));
-		packet->data_size = data_size;
+		packet->data = packet->embedded_data;
+		packet->allocated_data_size = data_size;
 	}
-
 	return packet;
 }
 
-
 /**
  * hpsb_free_packet - free packet and data associated with it
  * @packet: packet to free (is NULL safe)
  *
- * This function will free packet->data and finally the packet itself.
+ * Frees @packet->data only if it was allocated through hpsb_alloc_packet().
  */
 void hpsb_free_packet(struct hpsb_packet *packet)
 {
 	if (packet && atomic_dec_and_test(&packet->refcnt)) {
-		BUG_ON(!list_empty(&packet->driver_list));
-		kfree_skb(packet->skb);
+		BUG_ON(!list_empty(&packet->driver_list) ||
+		       !list_empty(&packet->queue));
+		kfree(packet);
 	}
 }
 
-
 /**
  * hpsb_reset_bus - initiate bus reset on the given host
  * @host: host controller whose bus to reset
@@ -494,6 +487,8 @@ void hpsb_selfid_complete(struct hpsb_ho
 	highlevel_host_reset(host);
 }
 
+static spinlock_t pending_packets_lock = SPIN_LOCK_UNLOCKED;
+
 /**
  * hpsb_packet_sent - notify core of sending a packet
  *
@@ -509,24 +504,24 @@ void hpsb_packet_sent(struct hpsb_host *
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&host->pending_packet_queue.lock, flags);
+	spin_lock_irqsave(&pending_packets_lock, flags);
 
 	packet->ack_code = ackcode;
 
 	if (packet->no_waiter || packet->state == hpsb_complete) {
 		/* if packet->no_waiter, must not have a tlabel allocated */
-		spin_unlock_irqrestore(&host->pending_packet_queue.lock, flags);
+		spin_unlock_irqrestore(&pending_packets_lock, flags);
 		hpsb_free_packet(packet);
 		return;
 	}
 
 	atomic_dec(&packet->refcnt);	/* drop HC's reference */
-	/* here the packet must be on the host->pending_packet_queue */
+	/* here the packet must be on the host->pending_packets queue */
 
 	if (ackcode != ACK_PENDING || !packet->expect_response) {
 		packet->state = hpsb_complete;
-		__skb_unlink(packet->skb, &host->pending_packet_queue);
-		spin_unlock_irqrestore(&host->pending_packet_queue.lock, flags);
+		list_del_init(&packet->queue);
+		spin_unlock_irqrestore(&pending_packets_lock, flags);
 		queue_packet_complete(packet);
 		return;
 	}
@@ -534,7 +529,7 @@ void hpsb_packet_sent(struct hpsb_host *
 	packet->state = hpsb_pending;
 	packet->sendtime = jiffies;
 
-	spin_unlock_irqrestore(&host->pending_packet_queue.lock, flags);
+	spin_unlock_irqrestore(&pending_packets_lock, flags);
 
 	mod_timer(&host->timeout, jiffies + host->timeout_interval);
 }
@@ -609,12 +604,16 @@ int hpsb_send_packet(struct hpsb_packet 
 	WARN_ON(packet->no_waiter && packet->expect_response);
 
 	if (!packet->no_waiter || packet->expect_response) {
+		unsigned long flags;
+
 		atomic_inc(&packet->refcnt);
 		/* Set the initial "sendtime" to 10 seconds from now, to
 		   prevent premature expiry.  If a packet takes more than
 		   10 seconds to hit the wire, we have bigger problems :) */
 		packet->sendtime = jiffies + 10 * HZ;
-		skb_queue_tail(&host->pending_packet_queue, packet->skb);
+		spin_lock_irqsave(&pending_packets_lock, flags);
+		list_add_tail(&packet->queue, &host->pending_packets);
+		spin_unlock_irqrestore(&pending_packets_lock, flags);
 	}
 
 	if (packet->node_id == host->node_id) {
@@ -690,86 +689,97 @@ static void send_packet_nocare(struct hp
 	}
 }
 
+static size_t packet_size_to_data_size(size_t packet_size, size_t header_size,
+				       size_t buffer_size, int tcode)
+{
+	size_t ret = packet_size <= header_size ? 0 : packet_size - header_size;
+
+	if (unlikely(ret > buffer_size))
+		ret = buffer_size;
+
+	if (unlikely(ret + header_size != packet_size))
+		HPSB_ERR("unexpected packet size %d (tcode %d), bug?",
+			 packet_size, tcode);
+	return ret;
+}
 
 static void handle_packet_response(struct hpsb_host *host, int tcode,
 				   quadlet_t *data, size_t size)
 {
-	struct hpsb_packet *packet = NULL;
-	struct sk_buff *skb;
-	int tcode_match = 0;
-	int tlabel;
+	struct hpsb_packet *packet;
+	int tlabel = (data[0] >> 10) & 0x3f;
+	size_t header_size;
 	unsigned long flags;
 
-	tlabel = (data[0] >> 10) & 0x3f;
-
-	spin_lock_irqsave(&host->pending_packet_queue.lock, flags);
-
-	skb_queue_walk(&host->pending_packet_queue, skb) {
-		packet = (struct hpsb_packet *)skb->data;
-		if ((packet->tlabel == tlabel)
-		    && (packet->node_id == (data[1] >> 16))){
-			break;
-		}
-
-		packet = NULL;
-	}
+	spin_lock_irqsave(&pending_packets_lock, flags);
 
-	if (packet == NULL) {
-		HPSB_DEBUG("unsolicited response packet received - no tlabel match");
-		dump_packet("contents", data, 16, -1);
-		spin_unlock_irqrestore(&host->pending_packet_queue.lock, flags);
-		return;
-	}
+	list_for_each_entry(packet, &host->pending_packets, queue)
+		if (packet->tlabel == tlabel &&
+		    packet->node_id == (data[1] >> 16))
+			goto found;
+
+	spin_unlock_irqrestore(&pending_packets_lock, flags);
+	HPSB_DEBUG("unsolicited response packet received - %s",
+		   "no tlabel match");
+	dump_packet("contents", data, 16, -1);
+	return;
 
+found:
 	switch (packet->tcode) {
 	case TCODE_WRITEQ:
 	case TCODE_WRITEB:
-		if (tcode != TCODE_WRITE_RESPONSE)
+		if (unlikely(tcode != TCODE_WRITE_RESPONSE))
 			break;
-		tcode_match = 1;
-		memcpy(packet->header, data, 12);
-		break;
+		header_size = 12;
+		size = 0;
+		goto dequeue;
+
 	case TCODE_READQ:
-		if (tcode != TCODE_READQ_RESPONSE)
+		if (unlikely(tcode != TCODE_READQ_RESPONSE))
 			break;
-		tcode_match = 1;
-		memcpy(packet->header, data, 16);
-		break;
+		header_size = 16;
+		size = 0;
+		goto dequeue;
+
 	case TCODE_READB:
-		if (tcode != TCODE_READB_RESPONSE)
+		if (unlikely(tcode != TCODE_READB_RESPONSE))
 			break;
-		tcode_match = 1;
-		BUG_ON(packet->skb->len - sizeof(*packet) < size - 16);
-		memcpy(packet->header, data, 16);
-		memcpy(packet->data, data + 4, size - 16);
-		break;
+		header_size = 16;
+		size = packet_size_to_data_size(size, header_size,
+						packet->allocated_data_size,
+						tcode);
+		goto dequeue;
+
 	case TCODE_LOCK_REQUEST:
-		if (tcode != TCODE_LOCK_RESPONSE)
+		if (unlikely(tcode != TCODE_LOCK_RESPONSE))
 			break;
-		tcode_match = 1;
-		size = min((size - 16), (size_t)8);
-		BUG_ON(packet->skb->len - sizeof(*packet) < size);
-		memcpy(packet->header, data, 16);
-		memcpy(packet->data, data + 4, size);
-		break;
+		header_size = 16;
+		size = packet_size_to_data_size(min(size, (size_t)(16 + 8)),
+						header_size,
+						packet->allocated_data_size,
+						tcode);
+		goto dequeue;
 	}
 
-	if (!tcode_match) {
-		spin_unlock_irqrestore(&host->pending_packet_queue.lock, flags);
-		HPSB_INFO("unsolicited response packet received - tcode mismatch");
-		dump_packet("contents", data, 16, -1);
-		return;
-	}
+	spin_unlock_irqrestore(&pending_packets_lock, flags);
+	HPSB_DEBUG("unsolicited response packet received - %s",
+		   "tcode mismatch");
+	dump_packet("contents", data, 16, -1);
+	return;
 
-	__skb_unlink(skb, &host->pending_packet_queue);
+dequeue:
+	list_del_init(&packet->queue);
+	spin_unlock_irqrestore(&pending_packets_lock, flags);
 
 	if (packet->state == hpsb_queued) {
 		packet->sendtime = jiffies;
 		packet->ack_code = ACK_PENDING;
 	}
-
 	packet->state = hpsb_complete;
-	spin_unlock_irqrestore(&host->pending_packet_queue.lock, flags);
+
+	memcpy(packet->header, data, header_size);
+	if (size)
+		memcpy(packet->data, data + 4, size);
 
 	queue_packet_complete(packet);
 }
@@ -783,6 +793,7 @@ static struct hpsb_packet *create_reply_
 	p = hpsb_alloc_packet(dsize);
 	if (unlikely(p == NULL)) {
 		/* FIXME - send data_error response */
+		HPSB_ERR("out of memory, cannot send response packet");
 		return NULL;
 	}
 
@@ -805,8 +816,7 @@ static struct hpsb_packet *create_reply_
 	packet->tcode = tc; \
 	packet->header[0] = (packet->node_id << 16) | (packet->tlabel << 10) \
 		| (1 << 8) | (tc << 4); \
-	packet->header[1] = (packet->host->node_id << 16) | (rcode << 12); \
-	packet->header[2] = 0
+	packet->header[1] = (packet->host->node_id << 16) | (rcode << 12);
 
 static void fill_async_readquad_resp(struct hpsb_packet *packet, int rcode,
 			      quadlet_t data)
@@ -814,7 +824,6 @@ static void fill_async_readquad_resp(str
 	PREP_ASYNC_HEAD_RCODE(TCODE_READQ_RESPONSE);
 	packet->header[3] = data;
 	packet->header_size = 16;
-	packet->data_size = 0;
 }
 
 static void fill_async_readblock_resp(struct hpsb_packet *packet, int rcode,
@@ -832,9 +841,7 @@ static void fill_async_readblock_resp(st
 static void fill_async_write_resp(struct hpsb_packet *packet, int rcode)
 {
 	PREP_ASYNC_HEAD_RCODE(TCODE_WRITE_RESPONSE);
-	packet->header[2] = 0;
 	packet->header_size = 12;
-	packet->data_size = 0;
 }
 
 static void fill_async_lock_resp(struct hpsb_packet *packet, int rcode, int extcode,
@@ -1002,8 +1009,8 @@ void hpsb_packet_received(struct hpsb_ho
 {
 	int tcode;
 
-	if (host->in_bus_reset) {
-		HPSB_INFO("received packet during reset; ignoring");
+	if (unlikely(host->in_bus_reset)) {
+		HPSB_DEBUG("received packet during reset; ignoring");
 		return;
 	}
 
@@ -1037,23 +1044,27 @@ void hpsb_packet_received(struct hpsb_ho
 		break;
 
 	default:
-		HPSB_NOTICE("received packet with bogus transaction code %d",
-			    tcode);
+		HPSB_DEBUG("received packet with bogus transaction code %d",
+			   tcode);
 		break;
 	}
 }
 
-
 static void abort_requests(struct hpsb_host *host)
 {
-	struct hpsb_packet *packet;
-	struct sk_buff *skb;
+	struct hpsb_packet *packet, *p;
+	struct list_head tmp;
+	unsigned long flags;
 
 	host->driver->devctl(host, CANCEL_REQUESTS, 0);
 
-	while ((skb = skb_dequeue(&host->pending_packet_queue)) != NULL) {
-		packet = (struct hpsb_packet *)skb->data;
+	INIT_LIST_HEAD(&tmp);
+	spin_lock_irqsave(&pending_packets_lock, flags);
+	list_splice_init(&host->pending_packets, &tmp);
+	spin_unlock_irqrestore(&pending_packets_lock, flags);
 
+	list_for_each_entry_safe(packet, p, &tmp, queue) {
+		list_del_init(&packet->queue);
 		packet->state = hpsb_complete;
 		packet->ack_code = ACKX_ABORTED;
 		queue_packet_complete(packet);
@@ -1063,87 +1074,90 @@ static void abort_requests(struct hpsb_h
 void abort_timedouts(unsigned long __opaque)
 {
 	struct hpsb_host *host = (struct hpsb_host *)__opaque;
-	unsigned long flags;
-	struct hpsb_packet *packet;
-	struct sk_buff *skb;
-	unsigned long expire;
+	struct hpsb_packet *packet, *p;
+	struct list_head tmp;
+	unsigned long flags, expire, j;
 
 	spin_lock_irqsave(&host->csr.lock, flags);
 	expire = host->csr.expire;
 	spin_unlock_irqrestore(&host->csr.lock, flags);
 
-	/* Hold the lock around this, since we aren't dequeuing all
-	 * packets, just ones we need. */
-	spin_lock_irqsave(&host->pending_packet_queue.lock, flags);
-
-	while (!skb_queue_empty(&host->pending_packet_queue)) {
-		skb = skb_peek(&host->pending_packet_queue);
-
-		packet = (struct hpsb_packet *)skb->data;
-
-		if (time_before(packet->sendtime + expire, jiffies)) {
-			__skb_unlink(skb, &host->pending_packet_queue);
-			packet->state = hpsb_complete;
-			packet->ack_code = ACKX_TIMEOUT;
-			queue_packet_complete(packet);
-		} else {
+	j = jiffies;
+	INIT_LIST_HEAD(&tmp);
+	spin_lock_irqsave(&pending_packets_lock, flags);
+
+	list_for_each_entry_safe(packet, p, &host->pending_packets, queue) {
+		if (time_before(packet->sendtime + expire, j))
+			list_move_tail(&packet->queue, &tmp);
+		else
 			/* Since packets are added to the tail, the oldest
 			 * ones are first, always. When we get to one that
 			 * isn't timed out, the rest aren't either. */
 			break;
-		}
 	}
+	if (!list_empty(&host->pending_packets))
+		mod_timer(&host->timeout, j + host->timeout_interval);
 
-	if (!skb_queue_empty(&host->pending_packet_queue))
-		mod_timer(&host->timeout, jiffies + host->timeout_interval);
+	spin_unlock_irqrestore(&pending_packets_lock, flags);
 
-	spin_unlock_irqrestore(&host->pending_packet_queue.lock, flags);
+	list_for_each_entry_safe(packet, p, &tmp, queue) {
+		list_del_init(&packet->queue);
+		packet->state = hpsb_complete;
+		packet->ack_code = ACKX_TIMEOUT;
+		queue_packet_complete(packet);
+	}
 }
 
-
-/* Kernel thread and vars, which handles packets that are completed. Only
- * packets that have a "complete" function are sent here. This way, the
- * completion is run out of kernel context, and doesn't block the rest of
- * the stack. */
 static struct task_struct *khpsbpkt_thread;
-static struct sk_buff_head hpsbpkt_queue;
+static LIST_HEAD(hpsbpkt_queue);
 
 static void queue_packet_complete(struct hpsb_packet *packet)
 {
+	unsigned long flags;
+
 	if (packet->no_waiter) {
 		hpsb_free_packet(packet);
 		return;
 	}
 	if (packet->complete_routine != NULL) {
-		skb_queue_tail(&hpsbpkt_queue, packet->skb);
+		spin_lock_irqsave(&pending_packets_lock, flags);
+		list_add_tail(&packet->queue, &hpsbpkt_queue);
+		spin_unlock_irqrestore(&pending_packets_lock, flags);
 		wake_up_process(khpsbpkt_thread);
 	}
 	return;
 }
 
+/*
+ * Kernel thread which handles packets that are completed.  This way the
+ * packet's "complete" function is asynchronously run in process context.
+ * Only packets which have a "complete" function may be sent here.
+ */
 static int hpsbpkt_thread(void *__hi)
 {
-	struct sk_buff *skb;
-	struct hpsb_packet *packet;
-	void (*complete_routine)(void*);
-	void *complete_data;
+	struct hpsb_packet *packet, *p;
+	struct list_head tmp;
+	int may_schedule;
 
 	current->flags |= PF_NOFREEZE;
 
 	while (!kthread_should_stop()) {
-		while ((skb = skb_dequeue(&hpsbpkt_queue)) != NULL) {
-			packet = (struct hpsb_packet *)skb->data;
 
-			complete_routine = packet->complete_routine;
-			complete_data = packet->complete_data;
-
-			packet->complete_routine = packet->complete_data = NULL;
-
-			complete_routine(complete_data);
+		INIT_LIST_HEAD(&tmp);
+		spin_lock_irq(&pending_packets_lock);
+		list_splice_init(&hpsbpkt_queue, &tmp);
+		spin_unlock_irq(&pending_packets_lock);
+
+		list_for_each_entry_safe(packet, p, &tmp, queue) {
+			list_del_init(&packet->queue);
+			packet->complete_routine(packet->complete_data);
 		}
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (!skb_peek(&hpsbpkt_queue))
+		spin_lock_irq(&pending_packets_lock);
+		may_schedule = list_empty(&hpsbpkt_queue);
+		spin_unlock_irq(&pending_packets_lock);
+		if (may_schedule)
 			schedule();
 		__set_current_state(TASK_RUNNING);
 	}
@@ -1154,8 +1168,6 @@ static int __init ieee1394_init(void)
 {
 	int i, ret;
 
-	skb_queue_head_init(&hpsbpkt_queue);
-
 	/* non-fatal error */
 	if (hpsb_init_config_roms()) {
 		HPSB_ERR("Failed to initialize some config rom entries.\n");
Index: linux/drivers/ieee1394/ieee1394_core.h
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.h
+++ linux/drivers/ieee1394/ieee1394_core.h
@@ -4,7 +4,6 @@
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/list.h>
-#include <linux/skbuff.h>
 #include <linux/types.h>
 #include <asm/atomic.h>
 
@@ -13,7 +12,7 @@
 
 struct hpsb_packet {
 	/* This struct is basically read-only for hosts with the exception of
-	 * the data buffer contents and xnext - see below. */
+	 * the data buffer contents and driver_list. */
 
 	/* This can be used for host driver internal linking.
 	 *
@@ -49,35 +48,27 @@ struct hpsb_packet {
 	/* Speed to transmit with: 0 = 100Mbps, 1 = 200Mbps, 2 = 400Mbps */
 	unsigned speed_code:2;
 
-	/*
-	 * *header and *data are guaranteed to be 32-bit DMAable and may be
-	 * overwritten to allow in-place byte swapping.  Neither of these is
-	 * CRCed (the sizes also don't include CRC), but contain space for at
-	 * least one additional quadlet to allow in-place CRCing.  The memory is
-	 * also guaranteed to be DMA mappable.
-	 */
-	quadlet_t *header;
-	quadlet_t *data;
-	size_t header_size;
-	size_t data_size;
-
 	struct hpsb_host *host;
 	unsigned int generation;
 
 	atomic_t refcnt;
+	struct list_head queue;
 
 	/* Function (and possible data to pass to it) to call when this
 	 * packet is completed.  */
 	void (*complete_routine)(void *);
 	void *complete_data;
 
-	/* XXX This is just a hack at the moment */
-	struct sk_buff *skb;
-
 	/* Store jiffies for implementing bus timeouts. */
 	unsigned long sendtime;
 
-	quadlet_t embedded_header[5];
+	/* Sizes are in bytes. *data can be DMA-mapped. */
+	size_t allocated_data_size;	/* as allocated */
+	size_t data_size;		/* as filled in */
+	size_t header_size;		/* as filled in, not counting the CRC */
+	quadlet_t *data;
+	quadlet_t header[5];
+	quadlet_t embedded_data[0];	/* keep as last member */
 };
 
 void hpsb_set_packet_complete_task(struct hpsb_packet *packet,

-- 
Stefan Richter
-=====-=-=== --== =--=-
http://arcgraph.de/sr/

