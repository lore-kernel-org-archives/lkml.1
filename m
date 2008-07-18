Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbYGRWMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbYGRWMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbYGRWLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:15 -0400
Received: from styx.suse.cz ([82.119.242.94]:55493 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758608AbYGRWLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:11 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 03/12] ipwireless: Rename spinlock variables to lock
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:09 +0200
Message-ID: <20080718221109.19195.27128.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |   96 +++++++++++++++--------------
 drivers/char/pcmcia/ipwireless/network.c  |   46 +++++++-------
 2 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index ce57a7f..f948791 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -242,7 +242,7 @@ struct ipw_hardware {
 	unsigned int base_port;
 	short hw_version;
 	unsigned short ll_mtu;
-	spinlock_t spinlock;
+	spinlock_t lock;
 
 	int initializing;
 	int init_loops;
@@ -400,7 +400,7 @@ static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
 	if (ipwireless_debug)
 		dump_data_bytes("send", data, length);
 
-	spin_lock_irqsave(&hw->spinlock, flags);
+	spin_lock_irqsave(&hw->lock, flags);
 
 	hw->tx_ready = 0;
 
@@ -437,7 +437,7 @@ static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
 		writew(MEMRX_RX, &hw->memory_info_regs->memreg_rx);
 	}
 
-	spin_unlock_irqrestore(&hw->spinlock, flags);
+	spin_unlock_irqrestore(&hw->lock, flags);
 
 	end_write_timing(length);
 
@@ -490,10 +490,10 @@ static int do_send_packet(struct ipw_hardware *hw, struct ipw_tx_packet *packet)
 		 */
 		unsigned long flags;
 
-		spin_lock_irqsave(&hw->spinlock, flags);
+		spin_lock_irqsave(&hw->lock, flags);
 		list_add(&packet->queue, &hw->tx_queue[0]);
 		hw->tx_queued++;
-		spin_unlock_irqrestore(&hw->spinlock, flags);
+		spin_unlock_irqrestore(&hw->lock, flags);
 	} else {
 		if (packet->packet_callback)
 			packet->packet_callback(packet->callback_data,
@@ -508,7 +508,7 @@ static void ipw_setup_hardware(struct ipw_hardware *hw)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&hw->spinlock, flags);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (hw->hw_version == HW_VERSION_1) {
 		/* Reset RX FIFO */
 		outw(DCR_RXRESET, hw->base_port + IODCR);
@@ -527,7 +527,7 @@ static void ipw_setup_hardware(struct ipw_hardware *hw)
 		csr |= 1;
 		writew(csr, &hw->memregs_CCR->reg_config_and_status);
 	}
-	spin_unlock_irqrestore(&hw->spinlock, flags);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
 /*
@@ -546,18 +546,18 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 	if (!packet) {
 		unsigned long flags;
 
-		spin_lock_irqsave(&hw->spinlock, flags);
+		spin_lock_irqsave(&hw->lock, flags);
 		if (!list_empty(&hw->rx_pool)) {
 			packet = list_first_entry(&hw->rx_pool,
 					struct ipw_rx_packet, queue);
 			list_del(&packet->queue);
 			hw->rx_pool_size--;
-			spin_unlock_irqrestore(&hw->spinlock, flags);
+			spin_unlock_irqrestore(&hw->lock, flags);
 		} else {
 			static int min_capacity = 256;
 			int new_capacity;
 
-			spin_unlock_irqrestore(&hw->spinlock, flags);
+			spin_unlock_irqrestore(&hw->lock, flags);
 			new_capacity =
 				(minimum_free_space > min_capacity
 				 ? minimum_free_space
@@ -645,9 +645,9 @@ static void queue_received_packet(struct ipw_hardware *hw,
 			packet = *assem;
 			*assem = NULL;
 			/* Count queued DATA bytes only */
-			spin_lock_irqsave(&hw->spinlock, flags);
+			spin_lock_irqsave(&hw->lock, flags);
 			hw->rx_bytes_queued += packet->length;
-			spin_unlock_irqrestore(&hw->spinlock, flags);
+			spin_unlock_irqrestore(&hw->lock, flags);
 		}
 	} else {
 		/* If it's a CTRL packet, don't assemble, just queue it. */
@@ -669,13 +669,13 @@ static void queue_received_packet(struct ipw_hardware *hw,
 	 * network layer.
 	 */
 	if (packet) {
-		spin_lock_irqsave(&hw->spinlock, flags);
+		spin_lock_irqsave(&hw->lock, flags);
 		list_add_tail(&packet->queue, &hw->rx_queue);
 		/* Block reception of incoming packets if queue is full. */
 		hw->blocking_rx =
 			(hw->rx_bytes_queued >= IPWIRELESS_RX_QUEUE_SIZE);
 
-		spin_unlock_irqrestore(&hw->spinlock, flags);
+		spin_unlock_irqrestore(&hw->lock, flags);
 		schedule_work(&hw->work_rx);
 	}
 }
@@ -689,7 +689,7 @@ static void ipw_receive_data_work(struct work_struct *work_rx)
 	    container_of(work_rx, struct ipw_hardware, work_rx);
 	unsigned long flags;
 
-	spin_lock_irqsave(&hw->spinlock, flags);
+	spin_lock_irqsave(&hw->lock, flags);
 	while (!list_empty(&hw->rx_queue)) {
 		struct ipw_rx_packet *packet =
 			list_first_entry(&hw->rx_queue,
@@ -707,7 +707,7 @@ static void ipw_receive_data_work(struct work_struct *work_rx)
 		if (packet->protocol == TL_PROTOCOLID_COM_DATA) {
 			if (hw->network != NULL) {
 				/* If the network hasn't been disconnected. */
-				spin_unlock_irqrestore(&hw->spinlock, flags);
+				spin_unlock_irqrestore(&hw->lock, flags);
 				/*
 				 * This must run unlocked due to tty processing
 				 * and mutex locking
@@ -718,7 +718,7 @@ static void ipw_receive_data_work(struct work_struct *work_rx)
 						(unsigned char *)packet
 						+ sizeof(struct ipw_rx_packet),
 						packet->length);
-				spin_lock_irqsave(&hw->spinlock, flags);
+				spin_lock_irqsave(&hw->lock, flags);
 			}
 			/* Count queued DATA bytes only */
 			hw->rx_bytes_queued -= packet->length;
@@ -742,7 +742,7 @@ static void ipw_receive_data_work(struct work_struct *work_rx)
 		if (hw->shutting_down)
 			break;
 	}
-	spin_unlock_irqrestore(&hw->spinlock, flags);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
 static void handle_received_CTRL_packet(struct ipw_hardware *hw,
@@ -914,17 +914,17 @@ static int get_packets_from_hw(struct ipw_hardware *hw)
 	int received = 0;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hw->spinlock, flags);
+	spin_lock_irqsave(&hw->lock, flags);
 	while (hw->rx_ready && !hw->blocking_rx) {
 		received = 1;
 		hw->rx_ready--;
-		spin_unlock_irqrestore(&hw->spinlock, flags);
+		spin_unlock_irqrestore(&hw->lock, flags);
 
 		do_receive_packet(hw);
 
-		spin_lock_irqsave(&hw->spinlock, flags);
+		spin_lock_irqsave(&hw->lock, flags);
 	}
-	spin_unlock_irqrestore(&hw->spinlock, flags);
+	spin_unlock_irqrestore(&hw->lock, flags);
 
 	return received;
 }
@@ -940,7 +940,7 @@ static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
 	int more_to_send = 0;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hw->spinlock, flags);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (hw->tx_queued && hw->tx_ready) {
 		int priority;
 		struct ipw_tx_packet *packet = NULL;
@@ -961,17 +961,17 @@ static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
 		}
 		if (!packet) {
 			hw->tx_queued = 0;
-			spin_unlock_irqrestore(&hw->spinlock, flags);
+			spin_unlock_irqrestore(&hw->lock, flags);
 			return 0;
 		}
 
-		spin_unlock_irqrestore(&hw->spinlock, flags);
+		spin_unlock_irqrestore(&hw->lock, flags);
 
 		/* Send */
 		do_send_packet(hw, packet);
 
 		/* Check if more to send */
-		spin_lock_irqsave(&hw->spinlock, flags);
+		spin_lock_irqsave(&hw->lock, flags);
 		for (priority = 0; priority < priority_limit; priority++)
 			if (!list_empty(&hw->tx_queue[priority])) {
 				more_to_send = 1;
@@ -981,7 +981,7 @@ static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
 		if (!more_to_send)
 			hw->tx_queued = 0;
 	}
-	spin_unlock_irqrestore(&hw->spinlock, flags);
+	spin_unlock_irqrestore(&hw->lock, flags);
 
 	return more_to_send;
 }
@@ -994,9 +994,9 @@ static void ipwireless_do_tasklet(unsigned long hw_)
 	struct ipw_hardware *hw = (struct ipw_hardware *) hw_;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hw->spinlock, flags);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (hw->shutting_down) {
-		spin_unlock_irqrestore(&hw->spinlock, flags);
+		spin_unlock_irqrestore(&hw->lock, flags);
 		return;
 	}
 
@@ -1005,7 +1005,7 @@ static void ipwireless_do_tasklet(unsigned long hw_)
 		 * Initial setup data sent to hardware
 		 */
 		hw->to_setup = 2;
-		spin_unlock_irqrestore(&hw->spinlock, flags);
+		spin_unlock_irqrestore(&hw->lock, flags);
 
 		ipw_setup_hardware(hw);
 		ipw_send_setup_packet(hw);
@@ -1016,7 +1016,7 @@ static void ipwireless_do_tasklet(unsigned long hw_)
 		int priority_limit = get_current_packet_priority(hw);
 		int again;
 
-		spin_unlock_irqrestore(&hw->spinlock, flags);
+		spin_unlock_irqrestore(&hw->lock, flags);
 
 		do {
 			again = send_pending_packet(hw, priority_limit);
@@ -1054,16 +1054,16 @@ static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
 		/* Transmit complete. */
 		if (irqn & IR_TXINTR) {
 			ack |= IR_TXINTR;
-			spin_lock_irqsave(&hw->spinlock, flags);
+			spin_lock_irqsave(&hw->lock, flags);
 			hw->tx_ready = 1;
-			spin_unlock_irqrestore(&hw->spinlock, flags);
+			spin_unlock_irqrestore(&hw->lock, flags);
 		}
 		/* Received data */
 		if (irqn & IR_RXINTR) {
 			ack |= IR_RXINTR;
-			spin_lock_irqsave(&hw->spinlock, flags);
+			spin_lock_irqsave(&hw->lock, flags);
 			hw->rx_ready++;
-			spin_unlock_irqrestore(&hw->spinlock, flags);
+			spin_unlock_irqrestore(&hw->lock, flags);
 		}
 		if (ack != 0) {
 			outw(ack, hw->base_port + IOIR);
@@ -1134,9 +1134,9 @@ static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
 		if (hw->serial_number_detected) {
 			if (memtx_serial != hw->last_memtx_serial) {
 				hw->last_memtx_serial = memtx_serial;
-				spin_lock_irqsave(&hw->spinlock, flags);
+				spin_lock_irqsave(&hw->lock, flags);
 				hw->rx_ready++;
-				spin_unlock_irqrestore(&hw->spinlock, flags);
+				spin_unlock_irqrestore(&hw->lock, flags);
 				rx = 1;
 			} else
 				/* Ignore 'Timer Recovery' duplicates. */
@@ -1151,18 +1151,18 @@ static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
 				printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
 					": memreg_tx serial num detected\n");
 
-				spin_lock_irqsave(&hw->spinlock, flags);
+				spin_lock_irqsave(&hw->lock, flags);
 				hw->rx_ready++;
-				spin_unlock_irqrestore(&hw->spinlock, flags);
+				spin_unlock_irqrestore(&hw->lock, flags);
 			}
 			rx = 1;
 		}
 	}
 	if (memrxdone & MEMRX_RX_DONE) {
 		writew(0, &hw->memory_info_regs->memreg_rx_done);
-		spin_lock_irqsave(&hw->spinlock, flags);
+		spin_lock_irqsave(&hw->lock, flags);
 		hw->tx_ready = 1;
-		spin_unlock_irqrestore(&hw->spinlock, flags);
+		spin_unlock_irqrestore(&hw->lock, flags);
 		tx = 1;
 	}
 	if (tx)
@@ -1211,9 +1211,9 @@ static void flush_packets_to_hw(struct ipw_hardware *hw)
 	int priority_limit;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hw->spinlock, flags);
+	spin_lock_irqsave(&hw->lock, flags);
 	priority_limit = get_current_packet_priority(hw);
-	spin_unlock_irqrestore(&hw->spinlock, flags);
+	spin_unlock_irqrestore(&hw->lock, flags);
 
 	while (send_pending_packet(hw, priority_limit));
 }
@@ -1223,10 +1223,10 @@ static void send_packet(struct ipw_hardware *hw, int priority,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&hw->spinlock, flags);
+	spin_lock_irqsave(&hw->lock, flags);
 	list_add_tail(&packet->queue, &hw->tx_queue[priority]);
 	hw->tx_queued++;
-	spin_unlock_irqrestore(&hw->spinlock, flags);
+	spin_unlock_irqrestore(&hw->lock, flags);
 
 	flush_packets_to_hw(hw);
 }
@@ -1612,7 +1612,7 @@ struct ipw_hardware *ipwireless_hardware_create(void)
 
 	INIT_LIST_HEAD(&hw->rx_queue);
 	INIT_LIST_HEAD(&hw->rx_pool);
-	spin_lock_init(&hw->spinlock);
+	spin_lock_init(&hw->lock);
 	tasklet_init(&hw->tasklet, ipwireless_do_tasklet, (unsigned long) hw);
 	INIT_WORK(&hw->work_rx, ipw_receive_data_work);
 	setup_timer(&hw->setup_timer, ipwireless_setup_timer,
@@ -1678,10 +1678,10 @@ static void ipwireless_setup_timer(unsigned long data)
 		if (is_card_present(hw)) {
 			unsigned long flags;
 
-			spin_lock_irqsave(&hw->spinlock, flags);
+			spin_lock_irqsave(&hw->lock, flags);
 			hw->to_setup = 1;
 			hw->tx_ready = 1;
-			spin_unlock_irqrestore(&hw->spinlock, flags);
+			spin_unlock_irqrestore(&hw->lock, flags);
 			tasklet_schedule(&hw->tasklet);
 		}
 
diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/char/pcmcia/ipwireless/network.c
index cf12eb4..28d9fd7 100644
--- a/drivers/char/pcmcia/ipwireless/network.c
+++ b/drivers/char/pcmcia/ipwireless/network.c
@@ -45,7 +45,7 @@ struct ipw_network {
 	/* Number of packets queued up in hardware module. */
 	int outgoing_packets_queued;
 	/* Spinlock to avoid interrupts during shutdown */
-	spinlock_t spinlock;
+	spinlock_t lock;
 	struct mutex close_lock;
 
 	/* PPP ioctl data, not actually used anywere */
@@ -67,20 +67,20 @@ static void notify_packet_sent(void *callback_data, unsigned int packet_length)
 	struct ipw_network *network = callback_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&network->spinlock, flags);
+	spin_lock_irqsave(&network->lock, flags);
 	network->outgoing_packets_queued--;
 	if (network->ppp_channel != NULL) {
 		if (network->ppp_blocked) {
 			network->ppp_blocked = 0;
-			spin_unlock_irqrestore(&network->spinlock, flags);
+			spin_unlock_irqrestore(&network->lock, flags);
 			ppp_output_wakeup(network->ppp_channel);
 			if (ipwireless_debug)
 				printk(KERN_INFO IPWIRELESS_PCCARD_NAME
 				       ": ppp unblocked\n");
 		} else
-			spin_unlock_irqrestore(&network->spinlock, flags);
+			spin_unlock_irqrestore(&network->lock, flags);
 	} else
-		spin_unlock_irqrestore(&network->spinlock, flags);
+		spin_unlock_irqrestore(&network->lock, flags);
 }
 
 /*
@@ -92,7 +92,7 @@ static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
 	struct ipw_network *network = ppp_channel->private;
 	unsigned long flags;
 
-	spin_lock_irqsave(&network->spinlock, flags);
+	spin_lock_irqsave(&network->lock, flags);
 	if (network->outgoing_packets_queued < ipwireless_out_queue) {
 		unsigned char *buf;
 		static unsigned char header[] = {
@@ -102,7 +102,7 @@ static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
 		int ret;
 
 		network->outgoing_packets_queued++;
-		spin_unlock_irqrestore(&network->spinlock, flags);
+		spin_unlock_irqrestore(&network->lock, flags);
 
 		/*
 		 * If we have the requested amount of headroom in the skb we
@@ -143,7 +143,7 @@ static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
 		 * needs to be unblocked once we are ready to send.
 		 */
 		network->ppp_blocked = 1;
-		spin_unlock_irqrestore(&network->spinlock, flags);
+		spin_unlock_irqrestore(&network->lock, flags);
 		return 0;
 	}
 }
@@ -248,11 +248,11 @@ static void do_go_online(struct work_struct *work_go_online)
 				work_go_online);
 	unsigned long flags;
 
-	spin_lock_irqsave(&network->spinlock, flags);
+	spin_lock_irqsave(&network->lock, flags);
 	if (!network->ppp_channel) {
 		struct ppp_channel *channel;
 
-		spin_unlock_irqrestore(&network->spinlock, flags);
+		spin_unlock_irqrestore(&network->lock, flags);
 		channel = kzalloc(sizeof(struct ppp_channel), GFP_KERNEL);
 		if (!channel) {
 			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
@@ -272,10 +272,10 @@ static void do_go_online(struct work_struct *work_go_online)
 		network->xaccm[3] = 0x60000000U;
 		network->raccm = ~0U;
 		ppp_register_channel(channel);
-		spin_lock_irqsave(&network->spinlock, flags);
+		spin_lock_irqsave(&network->lock, flags);
 		network->ppp_channel = channel;
 	}
-	spin_unlock_irqrestore(&network->spinlock, flags);
+	spin_unlock_irqrestore(&network->lock, flags);
 }
 
 static void do_go_offline(struct work_struct *work_go_offline)
@@ -286,16 +286,16 @@ static void do_go_offline(struct work_struct *work_go_offline)
 	unsigned long flags;
 
 	mutex_lock(&network->close_lock);
-	spin_lock_irqsave(&network->spinlock, flags);
+	spin_lock_irqsave(&network->lock, flags);
 	if (network->ppp_channel != NULL) {
 		struct ppp_channel *channel = network->ppp_channel;
 
 		network->ppp_channel = NULL;
-		spin_unlock_irqrestore(&network->spinlock, flags);
+		spin_unlock_irqrestore(&network->lock, flags);
 		mutex_unlock(&network->close_lock);
 		ppp_unregister_channel(channel);
 	} else {
-		spin_unlock_irqrestore(&network->spinlock, flags);
+		spin_unlock_irqrestore(&network->lock, flags);
 		mutex_unlock(&network->close_lock);
 	}
 }
@@ -380,18 +380,18 @@ void ipwireless_network_packet_received(struct ipw_network *network,
 			 * the PPP layer.
 			 */
 			mutex_lock(&network->close_lock);
-			spin_lock_irqsave(&network->spinlock, flags);
+			spin_lock_irqsave(&network->lock, flags);
 			if (network->ppp_channel != NULL) {
 				struct sk_buff *skb;
 
-				spin_unlock_irqrestore(&network->spinlock,
+				spin_unlock_irqrestore(&network->lock,
 						flags);
 
 				/* Send the data to the ppp_generic module. */
 				skb = ipw_packet_received_skb(data, length);
 				ppp_input(network->ppp_channel, skb);
 			} else
-				spin_unlock_irqrestore(&network->spinlock,
+				spin_unlock_irqrestore(&network->lock,
 						flags);
 			mutex_unlock(&network->close_lock);
 		}
@@ -409,7 +409,7 @@ struct ipw_network *ipwireless_network_create(struct ipw_hardware *hw)
 	if (!network)
 		return NULL;
 
-	spin_lock_init(&network->spinlock);
+	spin_lock_init(&network->lock);
 	mutex_init(&network->close_lock);
 
 	network->hardware = hw;
@@ -477,10 +477,10 @@ int ipwireless_ppp_channel_index(struct ipw_network *network)
 	int ret = -1;
 	unsigned long flags;
 
-	spin_lock_irqsave(&network->spinlock, flags);
+	spin_lock_irqsave(&network->lock, flags);
 	if (network->ppp_channel != NULL)
 		ret = ppp_channel_index(network->ppp_channel);
-	spin_unlock_irqrestore(&network->spinlock, flags);
+	spin_unlock_irqrestore(&network->lock, flags);
 
 	return ret;
 }
@@ -490,10 +490,10 @@ int ipwireless_ppp_unit_number(struct ipw_network *network)
 	int ret = -1;
 	unsigned long flags;
 
-	spin_lock_irqsave(&network->spinlock, flags);
+	spin_lock_irqsave(&network->lock, flags);
 	if (network->ppp_channel != NULL)
 		ret = ppp_unit_number(network->ppp_channel);
-	spin_unlock_irqrestore(&network->spinlock, flags);
+	spin_unlock_irqrestore(&network->lock, flags);
 
 	return ret;
 }

