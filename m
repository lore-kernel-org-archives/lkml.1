Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbXESLlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbXESLlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 07:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXESLlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 07:41:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33960 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXESLlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 07:41:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 19 May 2007 13:40:24 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PULL] ieee1394 fixes post 2.6.22-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.5299b7dd67007e8c@s5r6.in-berlin.de>
Message-ID: <tkrat.8905a1195adc60cf@s5r6.in-berlin.de>
References: <tkrat.1171a59b9de88f9c@s5r6.in-berlin.de>
 <tkrat.5299b7dd67007e8c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following IEEE 1394 subsystem updates:
> 
>   - fix regression in 2.6.22-rc1:
>     raw1394 asynchronous transmit was broken
> 
>   - fix old bug in raw1394:
>     32bit compat code for 64bit kernels was broken and incomplete
> 
>   - fix old eth1394 bug:
>     packets were frequently dropped in transmit path
>     (This fixes only the most common type of failure, tlabel exhaustion.)
> 
>   - trivial sbp2 fix
> 
> The 32bit compat code has been posted to LKML twice.  The rest was only
> seen on linux1394-devel, hence I'll follow up with the combined diff.
> 
> 
>  drivers/ieee1394/eth1394.c |   84 +++++++++++++-----
>  drivers/ieee1394/eth1394.h |    4 +
>  drivers/ieee1394/raw1394.c |  172 ++++++++++++++++++++++++++++--------
>  drivers/ieee1394/sbp2.c    |    1 +
>  4 files changed, 204 insertions(+), 57 deletions(-)
> 
> Petr Vandrovec (4):
>       ieee1394: raw1394: Fix async send
>       ieee1394: raw1394: Fix read() for 32bit userland on 64bit kernel
>       ieee1394: raw1394: Fix write() for 32bit userland on 64bit kernel
>       ieee1394: raw1394: Add ioctl() for 32bit userland on 64bit kernel
> 
> Stefan Richter (3):
>       ieee1394: sbp2: include workqueue.h
>       ieee1394: eth1394: remove bogus netif_wake_queue
>       ieee1394: eth1394: handle tlabel exhaustion


commit b59f74e660f8064fceb733148aec76334108175c
Author: Petr Vandrovec <petr@vandrovec.name>
Date:   Mon May 7 04:14:47 2007 +0200

    ieee1394: raw1394: Add ioctl() for 32bit userland on 64bit kernel
    
    Add compat_ioctl.  Although all structures are more or less same,
    raw1394_iso_packets got pointer inside, and raw1394_cycle_timer got unwanted
    padding in the middle.  I did not add any translation for ioctls passing array
    of integers around as integers seem to have same size (32 bits) on all
    architectures supported by Linux.
    
    Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
    Acked-by: Dan Dennedy <dan@dennedy.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (split into 3 patches)

commit 44273c6a648a09570bc5a3258049c8079e3eb8b7
Author: Petr Vandrovec <petr@vandrovec.name>
Date:   Mon May 7 04:14:47 2007 +0200

    ieee1394: raw1394: Fix write() for 32bit userland on 64bit kernel
    
    * write(fd, buf, 52) from 32bit app was returning 56.  Most of callers did not
      care, but some (arm registration) did, and anyway it looks bad if request for
      writing 52 bytes returns 56.  And returning sizeof anything in 'int' is not
      good as well.  So all functions now return '0' instead of
      sizeof(struct raw1394_request) on success, and write() itself provides correct
      return value (it just returns value it was asked to write on success as raw1394
      does not do any partial writes at all).
    
    * Related to this was problem that write() could have returned 0 when kernel
      state would become corrupted and moved to different state than
      opened/initialized/connected.  Now it returns -EBADFD which seemed appropriate.
    
    Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
    Acked-by: Dan Dennedy <dan@dennedy.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (split into 3 patches)

commit 36354ea205745107709b012bc2350d9922ca3a58
Author: Petr Vandrovec <petr@vandrovec.name>
Date:   Mon May 7 04:14:47 2007 +0200

    ieee1394: raw1394: Fix read() for 32bit userland on 64bit kernel
    
    read() always failed with -EFAULT.  This was happening due to
    raw1394_compat_read copying data to wrong location - access_ok always
    failed as 'r' is kernel address, not user.  Whole function just tried to
    copy data from 'r' to 'r', which is not good.
    
    Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
    Acked-by: Dan Dennedy <dan@dennedy.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (split into 3 patches)

commit 95608355f5a36781d08757ecea209ce76b4eead0
Author: Petr Vandrovec <petr@vandrovec.name>
Date:   Sun May 13 22:14:44 2007 -0700

    ieee1394: raw1394: Fix async send
    
    While playing with libiec61883 I've noticed that async_send is broken
    because it was doing copy_from_user(...., packet->data_size) before
    packet->data_size was set to any useful value.  It got broken when
    packet->allocated_data_size got introduced, as hpsb_alloc_packet does
    not set packet->data_size anymore.  (Regression in 2.6.22-rc1)
    
    Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 60b27f38f3ff9a325fbc044ddfc869bdb46b59ea
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat May 5 17:25:51 2007 +0200

    ieee1394: eth1394: handle tlabel exhaustion
    
    When eth1394 was unable to acquire a transaction label, it just dropped
    outgoing packets without attempt to resend them later.
    
    The transmit queue is now halted if no tlabel is available to
    ->hard_start_xmit().  A workqueue job is then scheduled to catch the
    moment when ieee1394 recycled the next lot of tlabels.
    
    Fixes http://bugzilla.kernel.org/show_bug.cgi?id=8402
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 6527285b4eaf23e112e88220b3111827916a7dff
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat May 5 17:19:09 2007 +0200

    ieee1394: eth1394: remove bogus netif_wake_queue
    
    When we are within hard_start_xmit, the queue is already awake.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 54b0b6c8bdda632b1556a99562e34d9bda64eec1
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat May 5 17:18:12 2007 +0200

    ieee1394: sbp2: include workqueue.h
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>


diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
index 2296d43..d6b19c2 100644
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
@@ -574,6 +609,8 @@ static void ether1394_add_host(struct hpsb_host *host)
 	spin_lock_init(&priv->lock);
 	priv->host = host;
 	priv->local_fifo = fifo_addr;
+	INIT_WORK(&priv->wake, ether1394_wake_queue);
+	priv->wake_dev = dev;
 
 	hi = hpsb_create_hostinfo(&eth1394_highlevel, host, sizeof(*hi));
 	if (hi == NULL) {
@@ -1390,22 +1427,17 @@ static int ether1394_prep_write_packet(struct hpsb_packet *p,
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
@@ -1451,7 +1483,7 @@ static int ether1394_send_packet(struct packet_task *ptask, unsigned int tx_len)
 
 	packet = ether1394_alloc_common_packet(priv->host);
 	if (!packet)
-		return -1;
+		return -ENOMEM;
 
 	if (ptask->tx_type == ETH1394_GASP) {
 		int length = tx_len + 2 * sizeof(quadlet_t);
@@ -1462,7 +1494,7 @@ static int ether1394_send_packet(struct packet_task *ptask, unsigned int tx_len)
 					       ptask->addr, ptask->skb->data,
 					       tx_len)) {
 		hpsb_free_packet(packet);
-		return -1;
+		return -EAGAIN;
 	}
 
 	ptask->packet = packet;
@@ -1471,7 +1503,7 @@ static int ether1394_send_packet(struct packet_task *ptask, unsigned int tx_len)
 
 	if (hpsb_send_packet(packet) < 0) {
 		ether1394_free_packet(packet);
-		return -1;
+		return -EIO;
 	}
 
 	return 0;
@@ -1514,13 +1546,18 @@ static void ether1394_complete_cb(void *__ptask)
 
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
@@ -1633,10 +1670,18 @@ static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
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
@@ -1650,9 +1695,6 @@ fail:
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
index d382500..151a48f 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -459,7 +459,7 @@ static const char __user *raw1394_compat_write(const char __user *buf)
 static int
 raw1394_compat_read(const char __user *buf, struct raw1394_request *r)
 {
-	struct compat_raw1394_req __user *cr = (typeof(cr)) r;
+	struct compat_raw1394_req __user *cr = (typeof(cr)) buf;
 	if (!access_ok(VERIFY_WRITE, cr, sizeof(struct compat_raw1394_req)) ||
 	    P(type) ||
 	    P(error) ||
@@ -587,7 +587,7 @@ static int state_opened(struct file_info *fi, struct pending_request *req)
 
 	req->req.length = 0;
 	queue_complete_req(req);
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int state_initialized(struct file_info *fi, struct pending_request *req)
@@ -601,7 +601,7 @@ static int state_initialized(struct file_info *fi, struct pending_request *req)
 		req->req.generation = atomic_read(&internal_generation);
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	switch (req->req.type) {
@@ -673,7 +673,7 @@ out_set_card:
 	}
 
 	queue_complete_req(req);
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static void handle_iso_listen(struct file_info *fi, struct pending_request *req)
@@ -865,7 +865,7 @@ static int handle_async_request(struct file_info *fi,
 	if (req->req.error) {
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	hpsb_set_packet_complete_task(packet,
@@ -883,7 +883,7 @@ static int handle_async_request(struct file_info *fi,
 		hpsb_free_tlabel(packet);
 		queue_complete_req(req);
 	}
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int handle_iso_send(struct file_info *fi, struct pending_request *req,
@@ -907,7 +907,7 @@ static int handle_iso_send(struct file_info *fi, struct pending_request *req,
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	req->req.length = 0;
@@ -927,7 +927,7 @@ static int handle_iso_send(struct file_info *fi, struct pending_request *req,
 		queue_complete_req(req);
 	}
 
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int handle_async_send(struct file_info *fi, struct pending_request *req)
@@ -936,16 +936,18 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
 	struct hpsb_packet *packet;
 	int header_length = req->req.misc & 0xffff;
 	int expect_response = req->req.misc >> 16;
+	size_t data_size;
 
 	if (header_length > req->req.length || header_length < 12 ||
 	    header_length > FIELD_SIZEOF(struct hpsb_packet, header)) {
 		req->req.error = RAW1394_ERROR_INVALID_ARG;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
-	packet = hpsb_alloc_packet(req->req.length - header_length);
+	data_size = req->req.length - header_length;
+	packet = hpsb_alloc_packet(data_size);
 	req->packet = packet;
 	if (!packet)
 		return -ENOMEM;
@@ -955,16 +957,16 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	if (copy_from_user
 	    (packet->data, int2ptr(req->req.sendb) + header_length,
-	     packet->data_size)) {
+	     data_size)) {
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	packet->type = hpsb_async;
@@ -974,7 +976,7 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
 	packet->host = fi->host;
 	packet->expect_response = expect_response;
 	packet->header_size = header_length;
-	packet->data_size = req->req.length - header_length;
+	packet->data_size = data_size;
 
 	req->req.length = 0;
 	hpsb_set_packet_complete_task(packet,
@@ -992,7 +994,7 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
 		queue_complete_req(req);
 	}
 
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int arm_read(struct hpsb_host *host, int nodeid, quadlet_t * buffer,
@@ -1867,7 +1869,7 @@ static int arm_register(struct file_info *fi, struct pending_request *req)
 		spin_lock_irqsave(&host_info_lock, flags);
 		list_add_tail(&addr->addr_list, &fi->addr_list);
 		spin_unlock_irqrestore(&host_info_lock, flags);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	retval =
 	    hpsb_register_addrspace(&raw1394_highlevel, fi->host, &arm_ops,
@@ -1885,7 +1887,7 @@ static int arm_register(struct file_info *fi, struct pending_request *req)
 		return (-EALREADY);
 	}
 	free_pending_request(req);	/* immediate success or fail */
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int arm_unregister(struct file_info *fi, struct pending_request *req)
@@ -1953,7 +1955,7 @@ static int arm_unregister(struct file_info *fi, struct pending_request *req)
 		vfree(addr->addr_space_buffer);
 		kfree(addr);
 		free_pending_request(req);	/* immediate success or fail */
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	retval =
 	    hpsb_unregister_addrspace(&raw1394_highlevel, fi->host,
@@ -1969,7 +1971,7 @@ static int arm_unregister(struct file_info *fi, struct pending_request *req)
 	vfree(addr->addr_space_buffer);
 	kfree(addr);
 	free_pending_request(req);	/* immediate success or fail */
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 /* Copy data from ARM buffer(s) to user buffer. */
@@ -2011,7 +2013,7 @@ static int arm_get_buf(struct file_info *fi, struct pending_request *req)
 				 * queue no response, and therefore nobody
 				 * will free it. */
 				free_pending_request(req);
-				return sizeof(struct raw1394_request);
+				return 0;
 			} else {
 				DBGMSG("arm_get_buf request exceeded mapping");
 				spin_unlock_irqrestore(&host_info_lock, flags);
@@ -2063,7 +2065,7 @@ static int arm_set_buf(struct file_info *fi, struct pending_request *req)
 				 * queue no response, and therefore nobody
 				 * will free it. */
 				free_pending_request(req);
-				return sizeof(struct raw1394_request);
+				return 0;
 			} else {
 				DBGMSG("arm_set_buf request exceeded mapping");
 				spin_unlock_irqrestore(&host_info_lock, flags);
@@ -2084,7 +2086,7 @@ static int reset_notification(struct file_info *fi, struct pending_request *req)
 	    (req->req.misc == RAW1394_NOTIFY_ON)) {
 		fi->notification = (u8) req->req.misc;
 		free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	/* error EINVAL (22) invalid argument */
 	return (-EINVAL);
@@ -2117,12 +2119,12 @@ static int write_phypacket(struct file_info *fi, struct pending_request *req)
 		req->req.length = 0;
 		queue_complete_req(req);
 	}
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int get_config_rom(struct file_info *fi, struct pending_request *req)
 {
-	int ret = sizeof(struct raw1394_request);
+	int ret = 0;
 	quadlet_t *data = kmalloc(req->req.length, GFP_KERNEL);
 	int status;
 
@@ -2152,7 +2154,7 @@ static int get_config_rom(struct file_info *fi, struct pending_request *req)
 
 static int update_config_rom(struct file_info *fi, struct pending_request *req)
 {
-	int ret = sizeof(struct raw1394_request);
+	int ret = 0;
 	quadlet_t *data = kmalloc(req->req.length, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -2219,7 +2221,7 @@ static int modify_config_rom(struct file_info *fi, struct pending_request *req)
 
 			hpsb_update_config_rom_image(fi->host);
 			free_pending_request(req);
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 	}
 
@@ -2284,7 +2286,7 @@ static int modify_config_rom(struct file_info *fi, struct pending_request *req)
 		/* we have to free the request, because we queue no response,
 		 * and therefore nobody will free it */
 		free_pending_request(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	} else {
 		for (dentry =
 		     fi->csr1212_dirs[dr]->value.directory.dentries_head;
@@ -2309,7 +2311,7 @@ static int state_connected(struct file_info *fi, struct pending_request *req)
 
 	case RAW1394_REQ_ECHO:
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_ISO_SEND:
 		print_old_iso_deprecation();
@@ -2333,24 +2335,24 @@ static int state_connected(struct file_info *fi, struct pending_request *req)
 	case RAW1394_REQ_ISO_LISTEN:
 		print_old_iso_deprecation();
 		handle_iso_listen(fi, req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_FCP_LISTEN:
 		handle_fcp_listen(fi, req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_RESET_BUS:
 		if (req->req.misc == RAW1394_LONG_RESET) {
 			DBGMSG("busreset called (type: LONG)");
 			hpsb_reset_bus(fi->host, LONG_RESET);
 			free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 		if (req->req.misc == RAW1394_SHORT_RESET) {
 			DBGMSG("busreset called (type: SHORT)");
 			hpsb_reset_bus(fi->host, SHORT_RESET);
 			free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 		/* error EINVAL (22) invalid argument */
 		return (-EINVAL);
@@ -2369,7 +2371,7 @@ static int state_connected(struct file_info *fi, struct pending_request *req)
 		req->req.generation = get_hpsb_generation(fi->host);
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	switch (req->req.type) {
@@ -2382,7 +2384,7 @@ static int state_connected(struct file_info *fi, struct pending_request *req)
 	if (req->req.length == 0) {
 		req->req.error = RAW1394_ERROR_INVALID_ARG;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	return handle_async_request(fi, req, node);
@@ -2393,7 +2395,7 @@ static ssize_t raw1394_write(struct file *file, const char __user * buffer,
 {
 	struct file_info *fi = (struct file_info *)file->private_data;
 	struct pending_request *req;
-	ssize_t retval = 0;
+	ssize_t retval = -EBADFD;
 
 #ifdef CONFIG_COMPAT
 	if (count == sizeof(struct compat_raw1394_req) &&
@@ -2435,6 +2437,9 @@ static ssize_t raw1394_write(struct file *file, const char __user * buffer,
 
 	if (retval < 0) {
 		free_pending_request(req);
+	} else {
+		BUG_ON(retval);
+		retval = count;
 	}
 
 	return retval;
@@ -2800,6 +2805,99 @@ static int raw1394_ioctl(struct inode *inode, struct file *file,
 	return -EINVAL;
 }
 
+#ifdef CONFIG_COMPAT
+struct raw1394_iso_packets32 {
+        __u32 n_packets;
+        compat_uptr_t infos;
+} __attribute__((packed));
+
+struct raw1394_cycle_timer32 {
+        __u32 cycle_timer;
+        __u64 local_time;
+} __attribute__((packed));
+
+#define RAW1394_IOC_ISO_RECV_PACKETS32          \
+        _IOW ('#', 0x25, struct raw1394_iso_packets32)
+#define RAW1394_IOC_ISO_XMIT_PACKETS32          \
+        _IOW ('#', 0x27, struct raw1394_iso_packets32)
+#define RAW1394_IOC_GET_CYCLE_TIMER32           \
+        _IOR ('#', 0x30, struct raw1394_cycle_timer32)
+
+static long raw1394_iso_xmit_recv_packets32(struct file *file, unsigned int cmd,
+                                          struct raw1394_iso_packets32 __user *arg)
+{
+	compat_uptr_t infos32;
+	void *infos;
+	long err = -EFAULT;
+	struct raw1394_iso_packets __user *dst = compat_alloc_user_space(sizeof(struct raw1394_iso_packets));
+
+	if (!copy_in_user(&dst->n_packets, &arg->n_packets, sizeof arg->n_packets) &&
+	    !copy_from_user(&infos32, &arg->infos, sizeof infos32)) {
+		infos = compat_ptr(infos32);
+		if (!copy_to_user(&dst->infos, &infos, sizeof infos))
+			err = raw1394_ioctl(NULL, file, cmd, (unsigned long)dst);
+	}
+	return err;
+}
+
+static long raw1394_read_cycle_timer32(struct file_info *fi, void __user * uaddr)
+{
+	struct raw1394_cycle_timer32 ct;
+	int err;
+
+	err = hpsb_read_cycle_timer(fi->host, &ct.cycle_timer, &ct.local_time);
+	if (!err)
+		if (copy_to_user(uaddr, &ct, sizeof(ct)))
+			err = -EFAULT;
+	return err;
+}
+
+static long raw1394_compat_ioctl(struct file *file,
+				 unsigned int cmd, unsigned long arg)
+{
+	struct file_info *fi = file->private_data;
+	void __user *argp = (void __user *)arg;
+	long err;
+
+	lock_kernel();
+	switch (cmd) {
+	/* These requests have same format as long as 'int' has same size. */
+	case RAW1394_IOC_ISO_RECV_INIT:
+	case RAW1394_IOC_ISO_RECV_START:
+	case RAW1394_IOC_ISO_RECV_LISTEN_CHANNEL:
+	case RAW1394_IOC_ISO_RECV_UNLISTEN_CHANNEL:
+	case RAW1394_IOC_ISO_RECV_SET_CHANNEL_MASK:
+	case RAW1394_IOC_ISO_RECV_RELEASE_PACKETS:
+	case RAW1394_IOC_ISO_RECV_FLUSH:
+	case RAW1394_IOC_ISO_XMIT_RECV_STOP:
+	case RAW1394_IOC_ISO_XMIT_INIT:
+	case RAW1394_IOC_ISO_XMIT_START:
+	case RAW1394_IOC_ISO_XMIT_SYNC:
+	case RAW1394_IOC_ISO_GET_STATUS:
+	case RAW1394_IOC_ISO_SHUTDOWN:
+	case RAW1394_IOC_ISO_QUEUE_ACTIVITY:
+		err = raw1394_ioctl(NULL, file, cmd, arg);
+		break;
+	/* These request have different format. */
+	case RAW1394_IOC_ISO_RECV_PACKETS32:
+		err = raw1394_iso_xmit_recv_packets32(file, RAW1394_IOC_ISO_RECV_PACKETS, argp);
+		break;
+	case RAW1394_IOC_ISO_XMIT_PACKETS32:
+		err = raw1394_iso_xmit_recv_packets32(file, RAW1394_IOC_ISO_XMIT_PACKETS, argp);
+		break;
+	case RAW1394_IOC_GET_CYCLE_TIMER32:
+		err = raw1394_read_cycle_timer32(fi, argp);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	unlock_kernel();
+
+	return err;
+}
+#endif
+
 static unsigned int raw1394_poll(struct file *file, poll_table * pt)
 {
 	struct file_info *fi = file->private_data;
@@ -3039,7 +3137,9 @@ static const struct file_operations raw1394_fops = {
 	.write = raw1394_write,
 	.mmap = raw1394_mmap,
 	.ioctl = raw1394_ioctl,
-	// .compat_ioctl = ... someone needs to do this
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = raw1394_compat_ioctl,
+#endif
 	.poll = raw1394_poll,
 	.open = raw1394_open,
 	.release = raw1394_release,
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
-=====-=-=== -=-= =--==
http://arcgraph.de/sr/

