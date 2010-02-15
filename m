Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab0BOWY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:24:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47841 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0BOWYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:24:25 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 15 Feb 2010 23:19:30 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.9722581233c899cf@s5r6.in-berlin.de>
Message-ID: <tkrat.416004f416294e89@s5r6.in-berlin.de>
References: <tkrat.71d11155e1b4d897@s5r6.in-berlin.de>
 <tkrat.c98ccacd8716c278@s5r6.in-berlin.de>
 <tkrat.c0cd1d998becca89@s5r6.in-berlin.de>
 <tkrat.9722581233c899cf@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-5
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates to the FireWire subsystem.
Thanks.

Clemens Ladisch (1):
      firewire: ohci: retransmit isochronous transmit packets on cycle loss

Stefan Richter (1):
      firewire: net: fix panic in fwnet_write_complete

 drivers/firewire/net.c  |   53 ++++++++++++++++++++++++++++----------
 drivers/firewire/ohci.c |   13 ++++++---
 2 files changed, 47 insertions(+), 19 deletions(-)


commit 7f51a100bba517196ac4bdf29408d20ee1c771e8
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Feb 8 08:30:03 2010 +0100

    firewire: ohci: retransmit isochronous transmit packets on cycle loss
    
    In isochronous transmit DMA descriptors, link the skip address pointer
    back to the descriptor itself.  When a cycle is lost, the controller
    will send the packet in the next cycle, instead of terminating the
    entire DMA program.
    
    There are two reasons for this:
    
    * This behaviour is compatible with the old IEEE1394 stack.  Old
      applications would not expect the DMA program to stop in this case.
    
    * Since the OHCI driver does not report any uncompleted packets, the
      context would stop silently; clients would not have any chance to
      detect and handle this error without a watchdog timer.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    
    Pieter Palmers notes:
    
    "The reason I added this retry behavior to the old stack is because some
    cards now and then fail to send a packet (e.g. the o2micro card in my
    dell laptop).  I couldn't figure out why exactly this happens, my best
    guess is that the card cannot fetch the payload data on time.  This
    happens much more frequently when sending large packets, which leads me
    to suspect that there are some contention issues with the DMA that fills
    the transmit FIFO.
    
    In the old stack it was a pretty critical issue as it resulted in a
    freeze of the userspace application.
    
    The omission of a packet doesn't necessarily have to be an issue.  E.g.
    in IEC61883 streams the DBC field can be used to detect discontinuities
    in the stream.  So as long as the other side doesn't bail when no
    [packet] is present in a cycle, there is not really a problem.
    
    I'm not convinced though that retrying is the proper solution, but it is
    simple and effective for what it had to do.  And I think there are no
    reasons not to do it this way.  Userspace can still detect this by
    checking the cycle the descriptor was sent in."
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (changelog, comment)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 2345d41..43ebf33 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2101,11 +2101,6 @@ static int ohci_queue_iso_transmit(struct fw_iso_context *base,
 	u32 payload_index, payload_end_index, next_page_index;
 	int page, end_page, i, length, offset;
 
-	/*
-	 * FIXME: Cycle lost behavior should be configurable: lose
-	 * packet, retransmit or terminate..
-	 */
-
 	p = packet;
 	payload_index = payload;
 
@@ -2135,6 +2130,14 @@ static int ohci_queue_iso_transmit(struct fw_iso_context *base,
 	if (!p->skip) {
 		d[0].control   = cpu_to_le16(DESCRIPTOR_KEY_IMMEDIATE);
 		d[0].req_count = cpu_to_le16(8);
+		/*
+		 * Link the skip address to this descriptor itself.  This causes
+		 * a context to skip a cycle whenever lost cycles or FIFO
+		 * overruns occur, without dropping the data.  The application
+		 * should then decide whether this is an error condition or not.
+		 * FIXME:  Make the context's cycle-lost behaviour configurable?
+		 */
+		d[0].branch_address = cpu_to_le32(d_bus | z);
 
 		header = (__le32 *) &d[1];
 		header[0] = cpu_to_le32(IT_HEADER_SY(p->sy) |

commit 110f82d7a2e0ff5a17617a9672f1ccb7e44bc0c6
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Jan 18 22:36:49 2010 +0100

    firewire: net: fix panic in fwnet_write_complete
    
    In the transmit path of firewire-net (IPv4 over 1394), the following
    race condition may occur:
      - The networking soft IRQ inserts a datagram into the 1394 async
        request transmit DMA.
      - The 1394 async transmit completion tasklet runs to finish cleaning
        up (unlink datagram from list of pending ones, release skb and
        outbound 1394 transaction object) --- before the networking soft IRQ
        had a chance to proceed and add the datagram to the list of pending
        datagrams.
    
    This caused a panic in the 1394 async transmit completion tasklet when
    it dereferenced unitialized list heads:
    http://bugzilla.kernel.org/show_bug.cgi?id=15077
    
    The fix is to add checks in the tx soft IRQ and in the tasklet to
    determine which of these two is the last referrer to the transaction
    object.  Then handle the cleanup of the object by the last referrer
    rather than assuming that the tasklet is always the last one.
    
    There is another similar race:  Between said tasklet and fwnet_close,
    i.e. at ifdown.  However, that race is much less likely to occur in
    practice and shall be fixed in a separate update.
    
    Reported-by: Илья Басин <basinilya@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index cbaf420..2d3dc7d 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -893,20 +893,31 @@ static void fwnet_receive_broadcast(struct fw_iso_context *context,
 
 static struct kmem_cache *fwnet_packet_task_cache;
 
+static void fwnet_free_ptask(struct fwnet_packet_task *ptask)
+{
+	dev_kfree_skb_any(ptask->skb);
+	kmem_cache_free(fwnet_packet_task_cache, ptask);
+}
+
 static int fwnet_send_packet(struct fwnet_packet_task *ptask);
 
 static void fwnet_transmit_packet_done(struct fwnet_packet_task *ptask)
 {
-	struct fwnet_device *dev;
+	struct fwnet_device *dev = ptask->dev;
 	unsigned long flags;
-
-	dev = ptask->dev;
+	bool free;
 
 	spin_lock_irqsave(&dev->lock, flags);
-	list_del(&ptask->pt_link);
-	spin_unlock_irqrestore(&dev->lock, flags);
 
-	ptask->outstanding_pkts--; /* FIXME access inside lock */
+	ptask->outstanding_pkts--;
+
+	/* Check whether we or the networking TX soft-IRQ is last user. */
+	free = (ptask->outstanding_pkts == 0 && !list_empty(&ptask->pt_link));
+
+	if (ptask->outstanding_pkts == 0)
+		list_del(&ptask->pt_link);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (ptask->outstanding_pkts > 0) {
 		u16 dg_size;
@@ -951,10 +962,10 @@ static void fwnet_transmit_packet_done(struct fwnet_packet_task *ptask)
 			ptask->max_payload = skb->len + RFC2374_FRAG_HDR_SIZE;
 		}
 		fwnet_send_packet(ptask);
-	} else {
-		dev_kfree_skb_any(ptask->skb);
-		kmem_cache_free(fwnet_packet_task_cache, ptask);
 	}
+
+	if (free)
+		fwnet_free_ptask(ptask);
 }
 
 static void fwnet_write_complete(struct fw_card *card, int rcode,
@@ -977,6 +988,7 @@ static int fwnet_send_packet(struct fwnet_packet_task *ptask)
 	unsigned tx_len;
 	struct rfc2734_header *bufhdr;
 	unsigned long flags;
+	bool free;
 
 	dev = ptask->dev;
 	tx_len = ptask->max_payload;
@@ -1022,12 +1034,16 @@ static int fwnet_send_packet(struct fwnet_packet_task *ptask)
 				generation, SCODE_100, 0ULL, ptask->skb->data,
 				tx_len + 8, fwnet_write_complete, ptask);
 
-		/* FIXME race? */
 		spin_lock_irqsave(&dev->lock, flags);
-		list_add_tail(&ptask->pt_link, &dev->broadcasted_list);
+
+		/* If the AT tasklet already ran, we may be last user. */
+		free = (ptask->outstanding_pkts == 0 && list_empty(&ptask->pt_link));
+		if (!free)
+			list_add_tail(&ptask->pt_link, &dev->broadcasted_list);
+
 		spin_unlock_irqrestore(&dev->lock, flags);
 
-		return 0;
+		goto out;
 	}
 
 	fw_send_request(dev->card, &ptask->transaction,
@@ -1035,12 +1051,19 @@ static int fwnet_send_packet(struct fwnet_packet_task *ptask)
 			ptask->generation, ptask->speed, ptask->fifo_addr,
 			ptask->skb->data, tx_len, fwnet_write_complete, ptask);
 
-	/* FIXME race? */
 	spin_lock_irqsave(&dev->lock, flags);
-	list_add_tail(&ptask->pt_link, &dev->sent_list);
+
+	/* If the AT tasklet already ran, we may be last user. */
+	free = (ptask->outstanding_pkts == 0 && list_empty(&ptask->pt_link));
+	if (!free)
+		list_add_tail(&ptask->pt_link, &dev->sent_list);
+
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	dev->netdev->trans_start = jiffies;
+ out:
+	if (free)
+		fwnet_free_ptask(ptask);
 
 	return 0;
 }
@@ -1298,6 +1321,8 @@ static netdev_tx_t fwnet_tx(struct sk_buff *skb, struct net_device *net)
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	ptask->max_payload = max_payload;
+	INIT_LIST_HEAD(&ptask->pt_link);
+
 	fwnet_send_packet(ptask);
 
 	return NETDEV_TX_OK;
-- 
Stefan Richter
-=====-==-=- --=- -====
http://arcgraph.de/sr/

