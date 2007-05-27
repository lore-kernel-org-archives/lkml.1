Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbXE0VqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbXE0VqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbXE0Vpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:45:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56952 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbXE0Vpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:45:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 27 May 2007 23:45:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 fixes post 2.6.22-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <46542248.3090507@s5r6.in-berlin.de>
Message-ID: <tkrat.51a1fad7f3b96378@s5r6.in-berlin.de>
References: <tkrat.1171a59b9de88f9c@s5r6.in-berlin.de>
 <tkrat.5299b7dd67007e8c@s5r6.in-berlin.de>
 <46542248.3090507@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394 subsystem updates:

(old stack)
  - fix regression in 2.6.22-rc1: raw1394 asynchronous transmit was broken,
  - fix regression in 2.6.21: some distro's scripts for persistent
    naming of network interfaces were broken for eth1394,
  - fix old eth1394 bug: packets were frequently dropped in transmit path,
  - trivial sbp2 fix.

(new stack)
  - fix for big endian CPUs,
  - call new driver modules firewire-core.ko, firewire-ohci.ko,
    firewire-sbp2.ko.


The stat, log, and diff:

 drivers/firewire/Kconfig   |   14 +++---
 drivers/firewire/Makefile  |   12 +++--
 drivers/firewire/fw-cdev.c |    2 +-
 drivers/firewire/fw-ohci.c |    5 +-
 drivers/ieee1394/eth1394.c |   91 ++++++++++++++++++++++++++----------
 drivers/ieee1394/eth1394.h |    4 ++
 drivers/ieee1394/raw1394.c |    8 ++-
 drivers/ieee1394/sbp2.c    |    1 +
 8 files changed, 94 insertions(+), 43 deletions(-)


Jeff Garzik (1):
      firewire: fix return code

Kristian Høgsberg (1):
      firewire: Add missing byteswapping for receive DMA programs.

Petr Vandrovec (1):
      ieee1394: raw1394: Fix async send

Stefan Richter (5):
      ieee1394: sbp2: include workqueue.h
      ieee1394: eth1394: remove bogus netif_wake_queue
      ieee1394: eth1394: handle tlabel exhaustion
      ieee1394: eth1394: bring back a parent device
      firewire: prefix modules with firewire- instead of fw-


diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 5932c72..396dade 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -18,7 +18,7 @@ config FIREWIRE
 	  your IEEE 1394 adapter.
 
 	  To compile this driver as a module, say M here: the module will be
-	  called fw-core.
+	  called firewire-core.
 
 	  This is the "JUJU" FireWire stack, an alternative implementation
 	  designed for robustness and simplicity.  You can build either this
@@ -34,11 +34,11 @@ config FIREWIRE_OHCI
 	  is the only chipset in use, so say Y here.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called fw-ohci.
+	  called firewire-ohci.
 
 	  If you also build ohci1394 of the classic IEEE 1394 driver stack,
-	  blacklist either ohci1394 or fw-ohci to let hotplug load the desired
-	  driver.
+	  blacklist either ohci1394 or firewire-ohci to let hotplug load the
+	  desired driver.
 
 config FIREWIRE_SBP2
 	tristate "Support for storage devices (SBP-2 protocol driver)"
@@ -50,12 +50,12 @@ config FIREWIRE_SBP2
 	  like scanners.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called fw-sbp2.
+	  called firewire-sbp2.
 
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
 
 	  If you also build sbp2 of the classic IEEE 1394 driver stack,
-	  blacklist either sbp2 or fw-sbp2 to let hotplug load the desired
-	  driver.
+	  blacklist either sbp2 or firewire-sbp2 to let hotplug load the
+	  desired driver.
 
diff --git a/drivers/firewire/Makefile b/drivers/firewire/Makefile
index fc7d59d..a7c31e9 100644
--- a/drivers/firewire/Makefile
+++ b/drivers/firewire/Makefile
@@ -2,9 +2,11 @@
 # Makefile for the Linux IEEE 1394 implementation
 #
 
-fw-core-y += fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
-	fw-device.o fw-cdev.o
+firewire-core-y += fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
+                   fw-device.o fw-cdev.o
+firewire-ohci-y += fw-ohci.o
+firewire-sbp2-y += fw-sbp2.o
 
-obj-$(CONFIG_FIREWIRE) += fw-core.o
-obj-$(CONFIG_FIREWIRE_OHCI) += fw-ohci.o
-obj-$(CONFIG_FIREWIRE_SBP2) += fw-sbp2.o
+obj-$(CONFIG_FIREWIRE) += firewire-core.o
+obj-$(CONFIG_FIREWIRE_OHCI) += firewire-ohci.o
+obj-$(CONFIG_FIREWIRE_SBP2) += firewire-sbp2.o
diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 0fa5bd5..3ab3585 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -365,7 +365,7 @@ complete_transaction(struct fw_card *card, int rcode,
 		    response->response.data, response->response.length);
 }
 
-static ssize_t ioctl_send_request(struct client *client, void *buffer)
+static int ioctl_send_request(struct client *client, void *buffer)
 {
 	struct fw_device *device = client->device;
 	struct fw_cdev_send_request *request = buffer;
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index c17342d..2e4cfa5 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -268,7 +268,7 @@ static int ar_context_add_page(struct ar_context *ctx)
 
 	dma_sync_single_for_device(dev, ab_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
 
-	ctx->last_buffer->descriptor.branch_address = ab_bus | 1;
+	ctx->last_buffer->descriptor.branch_address = cpu_to_le32(ab_bus | 1);
 	ctx->last_buffer->next = ab;
 	ctx->last_buffer = ab;
 
@@ -417,7 +417,8 @@ ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci, u32 regs)
 	ctx->current_buffer = ab.next;
 	ctx->pointer = ctx->current_buffer->data;
 
-	reg_write(ctx->ohci, COMMAND_PTR(ctx->regs), ab.descriptor.branch_address);
+	reg_write(ctx->ohci, COMMAND_PTR(ctx->regs),
+		  le32_to_cpu(ab.descriptor.branch_address));
 	reg_write(ctx->ohci, CONTROL_SET(ctx->regs), CONTEXT_RUN);
 	flush_writes(ctx->ohci);
 
diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
index 2296d43..5f026b5 100644
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -47,6 +47,7 @@
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/workqueue.h>
 
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
@@ -235,6 +236,9 @@ static int ether1394_open(struct net_device *dev)
 /* This is called after an "ifdown" */
 static int ether1394_stop(struct net_device *dev)
 {
+	/* flush priv->wake */
+	flush_scheduled_work();
+
 	netif_stop_queue(dev);
 	return 0;
 }
@@ -531,6 +535,37 @@ static void ether1394_init_dev(struct net_device *dev)
 }
 
 /*
+ * Wake the queue up after commonly encountered transmit failure conditions are
+ * hopefully over.  Currently only tlabel exhaustion is accounted for.
+ */
+static void ether1394_wake_queue(struct work_struct *work)
+{
+	struct eth1394_priv *priv;
+	struct hpsb_packet *packet;
+
+	priv = container_of(work, struct eth1394_priv, wake);
+	packet = hpsb_alloc_packet(0);
+
+	/* This is really bad, but unjam the queue anyway. */
+	if (!packet)
+		goto out;
+
+	packet->host = priv->host;
+	packet->node_id = priv->wake_node;
+	/*
+	 * A transaction label is all we really want.  If we get one, it almost
+	 * always means we can get a lot more because the ieee1394 core recycled
+	 * a whole batch of tlabels, at last.
+	 */
+	if (hpsb_get_tlabel(packet) == 0)
+		hpsb_free_tlabel(packet);
+
+	hpsb_free_packet(packet);
+out:
+	netif_wake_queue(priv->wake_dev);
+}
+
+/*
  * This function is called every time a card is found. It is generally called
  * when the module is installed. This is where we add all of our ethernet
  * devices. One for each host.
@@ -564,16 +599,17 @@ static void ether1394_add_host(struct hpsb_host *host)
 	}
 
 	SET_MODULE_OWNER(dev);
-#if 0
-	/* FIXME - Is this the correct parent device anyway? */
-	SET_NETDEV_DEV(dev, &host->device);
-#endif
+
+	/* This used to be &host->device in Linux 2.6.20 and before. */
+	SET_NETDEV_DEV(dev, host->device.parent);
 
 	priv = netdev_priv(dev);
 	INIT_LIST_HEAD(&priv->ip_node_list);
 	spin_lock_init(&priv->lock);
 	priv->host = host;
 	priv->local_fifo = fifo_addr;
+	INIT_WORK(&priv->wake, ether1394_wake_queue);
+	priv->wake_dev = dev;
 
 	hi = hpsb_create_hostinfo(&eth1394_highlevel, host, sizeof(*hi));
 	if (hi == NULL) {
@@ -1390,22 +1426,17 @@ static int ether1394_prep_write_packet(struct hpsb_packet *p,
 				       u64 addr, void *data, int tx_len)
 {
 	p->node_id = node;
-	p->data = NULL;
 
-	p->tcode = TCODE_WRITEB;
-	p->header[1] = host->node_id << 16 | addr >> 32;
-	p->header[2] = addr & 0xffffffff;
+	if (hpsb_get_tlabel(p))
+		return -EAGAIN;
 
+	p->tcode = TCODE_WRITEB;
 	p->header_size = 16;
 	p->expect_response = 1;
-
-	if (hpsb_get_tlabel(p)) {
-		ETH1394_PRINT_G(KERN_ERR, "Out of tlabels\n");
-		return -1;
-	}
 	p->header[0] =
 		p->node_id << 16 | p->tlabel << 10 | 1 << 8 | TCODE_WRITEB << 4;
-
+	p->header[1] = host->node_id << 16 | addr >> 32;
+	p->header[2] = addr & 0xffffffff;
 	p->header[3] = tx_len << 16;
 	p->data_size = (tx_len + 3) & ~3;
 	p->data = data;
@@ -1451,7 +1482,7 @@ static int ether1394_send_packet(struct packet_task *ptask, unsigned int tx_len)
 
 	packet = ether1394_alloc_common_packet(priv->host);
 	if (!packet)
-		return -1;
+		return -ENOMEM;
 
 	if (ptask->tx_type == ETH1394_GASP) {
 		int length = tx_len + 2 * sizeof(quadlet_t);
@@ -1462,7 +1493,7 @@ static int ether1394_send_packet(struct packet_task *ptask, unsigned int tx_len)
 					       ptask->addr, ptask->skb->data,
 					       tx_len)) {
 		hpsb_free_packet(packet);
-		return -1;
+		return -EAGAIN;
 	}
 
 	ptask->packet = packet;
@@ -1471,7 +1502,7 @@ static int ether1394_send_packet(struct packet_task *ptask, unsigned int tx_len)
 
 	if (hpsb_send_packet(packet) < 0) {
 		ether1394_free_packet(packet);
-		return -1;
+		return -EIO;
 	}
 
 	return 0;
@@ -1514,13 +1545,18 @@ static void ether1394_complete_cb(void *__ptask)
 
 	ptask->outstanding_pkts--;
 	if (ptask->outstanding_pkts > 0 && !fail) {
-		int tx_len;
+		int tx_len, err;
 
 		/* Add the encapsulation header to the fragment */
 		tx_len = ether1394_encapsulate(ptask->skb, ptask->max_payload,
 					       &ptask->hdr);
-		if (ether1394_send_packet(ptask, tx_len))
+		err = ether1394_send_packet(ptask, tx_len);
+		if (err) {
+			if (err == -EAGAIN)
+				ETH1394_PRINT_G(KERN_ERR, "Out of tlabels\n");
+
 			ether1394_dg_complete(ptask, 1);
+		}
 	} else {
 		ether1394_dg_complete(ptask, fail);
 	}
@@ -1633,10 +1669,18 @@ static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
 	/* Add the encapsulation header to the fragment */
 	tx_len = ether1394_encapsulate(skb, max_payload, &ptask->hdr);
 	dev->trans_start = jiffies;
-	if (ether1394_send_packet(ptask, tx_len))
-		goto fail;
+	if (ether1394_send_packet(ptask, tx_len)) {
+		if (dest_node == (LOCAL_BUS | ALL_NODES))
+			goto fail;
+
+		/* Most failures of ether1394_send_packet are recoverable. */
+		netif_stop_queue(dev);
+		priv->wake_node = dest_node;
+		schedule_work(&priv->wake);
+		kmem_cache_free(packet_task_cache, ptask);
+		return NETDEV_TX_BUSY;
+	}
 
-	netif_wake_queue(dev);
 	return NETDEV_TX_OK;
 fail:
 	if (ptask)
@@ -1650,9 +1694,6 @@ fail:
 	priv->stats.tx_errors++;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (netif_queue_stopped(dev))
-		netif_wake_queue(dev);
-
 	/*
 	 * FIXME: According to a patch from 2003-02-26, "returning non-zero
 	 * causes serious problems" here, allegedly.  Before that patch,
diff --git a/drivers/ieee1394/eth1394.h b/drivers/ieee1394/eth1394.h
index a3439ee..4f3e2dd 100644
--- a/drivers/ieee1394/eth1394.h
+++ b/drivers/ieee1394/eth1394.h
@@ -66,6 +66,10 @@ struct eth1394_priv {
 	int bc_dgl;			/* Outgoing broadcast datagram label */
 	struct list_head ip_node_list;	/* List of IP capable nodes	 */
 	struct unit_directory *ud_list[ALL_NODES]; /* Cached unit dir list */
+
+	struct work_struct wake;	/* Wake up after xmit failure	 */
+	struct net_device *wake_dev;	/* Stupid backlink for .wake	 */
+	nodeid_t wake_node;		/* Destination of failed xmit	 */
 };
 
 
diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index d382500..f1d05ee 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -936,6 +936,7 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
 	struct hpsb_packet *packet;
 	int header_length = req->req.misc & 0xffff;
 	int expect_response = req->req.misc >> 16;
+	size_t data_size;
 
 	if (header_length > req->req.length || header_length < 12 ||
 	    header_length > FIELD_SIZEOF(struct hpsb_packet, header)) {
@@ -945,7 +946,8 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
 		return sizeof(struct raw1394_request);
 	}
 
-	packet = hpsb_alloc_packet(req->req.length - header_length);
+	data_size = req->req.length - header_length;
+	packet = hpsb_alloc_packet(data_size);
 	req->packet = packet;
 	if (!packet)
 		return -ENOMEM;
@@ -960,7 +962,7 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
 
 	if (copy_from_user
 	    (packet->data, int2ptr(req->req.sendb) + header_length,
-	     packet->data_size)) {
+	     data_size)) {
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
@@ -974,7 +976,7 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
 	packet->host = fi->host;
 	packet->expect_response = expect_response;
 	packet->header_size = header_length;
-	packet->data_size = req->req.length - header_length;
+	packet->data_size = data_size;
 
 	req->req.length = 0;
 	hpsb_set_packet_complete_task(packet,
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 4cb6fa2..875eadd 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -70,6 +70,7 @@
 #include <linux/stringify.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #include <asm/byteorder.h>
 #include <asm/errno.h>


-- 
Stefan Richter
-=====-=-=== -=-= ==-==
http://arcgraph.de/sr/

