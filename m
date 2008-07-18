Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbYGRWL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbYGRWL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbYGRWLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:55483 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756594AbYGRWLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:00 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 01/12] ipwireless: Misc cleanups
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:10:59 +0200
Message-ID: <20080718221059.19195.16733.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove likely() and some extra () in ifs
- use unsigned in for loops
- remove useless typecasts
- remove obvious comments
- add () around ?:

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |   50 ++++++++++-------------------
 1 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 929101e..6a3e666 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -389,7 +389,7 @@ static void dump_data_bytes(const char *type, const unsigned char *data,
 static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
 			    unsigned length)
 {
-	int i;
+	unsigned i;
 	unsigned long flags;
 
 	start_timing();
@@ -414,7 +414,7 @@ static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
 			unsigned short d = data[i];
 			__le16 raw_data;
 
-			if (likely(i + 1 < length))
+			if (i + 1 < length)
 				d |= data[i + 1] << 8;
 			raw_data = cpu_to_le16(d);
 			outw(raw_data, hw->base_port + IODWR);
@@ -428,7 +428,7 @@ static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
 			unsigned short d = data[i];
 			__le16 raw_data;
 
-			if ((i + 1 < length))
+			if (i + 1 < length)
 				d |= data[i + 1] << 8;
 			raw_data = cpu_to_le16(d);
 			outw(raw_data, hw->base_port + IODMADPR);
@@ -549,12 +549,7 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 	if (!packet) {
 		unsigned long flags;
 
-		/*
-		 * If this is the first fragment, then we will need to fetch a
-		 * packet to put it in.
-		 */
 		spin_lock_irqsave(&hw->spinlock, flags);
-		/* If we have one in our pool, then pull it out. */
 		if (!list_empty(&hw->rx_pool)) {
 			packet = list_first_entry(&hw->rx_pool,
 					struct ipw_rx_packet, queue);
@@ -562,15 +557,14 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 			hw->rx_pool_size--;
 			spin_unlock_irqrestore(&hw->spinlock, flags);
 		} else {
-			/* Otherwise allocate a new one. */
 			static int min_capacity = 256;
 			int new_capacity;
 
 			spin_unlock_irqrestore(&hw->spinlock, flags);
 			new_capacity =
-			    minimum_free_space > min_capacity
-			    ? minimum_free_space
-			    : min_capacity;
+				(minimum_free_space > min_capacity
+				 ? minimum_free_space
+				 : min_capacity);
 			packet = kmalloc(sizeof(struct ipw_rx_packet)
 					+ new_capacity, GFP_ATOMIC);
 			if (!packet)
@@ -580,10 +574,6 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 		packet->length = 0;
 	}
 
-	/*
-	 * If this packet does not have sufficient capacity for the data we
-	 * want to add, then make it bigger.
-	 */
 	if (packet->length + minimum_free_space > packet->capacity) {
 		struct ipw_rx_packet *old_packet = packet;
 
@@ -686,7 +676,7 @@ static void queue_received_packet(struct ipw_hardware *hw,
 		list_add_tail(&packet->queue, &hw->rx_queue);
 		/* Block reception of incoming packets if queue is full. */
 		hw->blocking_rx =
-			hw->rx_bytes_queued >= IPWIRELESS_RX_QUEUE_SIZE;
+			(hw->rx_bytes_queued >= IPWIRELESS_RX_QUEUE_SIZE);
 
 		spin_unlock_irqrestore(&hw->spinlock, flags);
 		schedule_work(&hw->work_rx);
@@ -850,7 +840,7 @@ static void acknowledge_data_read(struct ipw_hardware *hw)
 static void do_receive_packet(struct ipw_hardware *hw)
 {
 	unsigned len;
-	unsigned int i;
+	unsigned i;
 	unsigned char pkt[LL_MTU_MAX];
 
 	start_timing();
@@ -916,8 +906,7 @@ static int get_current_packet_priority(struct ipw_hardware *hw)
 	 * until setup is complete.
 	 */
 	return (hw->to_setup || hw->initializing
-			? PRIO_SETUP + 1 :
-			NL_NUM_OF_PRIORITIES);
+			? PRIO_SETUP + 1 : NL_NUM_OF_PRIORITIES);
 }
 
 /*
@@ -1128,9 +1117,8 @@ static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
 			} else {
 				return IRQ_NONE;
 			}
-		} else {
+		} else
 			return IRQ_NONE;
-		}
 	}
 
 	/*
@@ -1297,15 +1285,14 @@ int ipwireless_send_packet(struct ipw_hardware *hw, unsigned int channel_idx,
 {
 	struct ipw_tx_packet *packet;
 
-	packet = alloc_data_packet(length,
-			       (unsigned char) (channel_idx + 1),
-			       TL_PROTOCOLID_COM_DATA);
+	packet = alloc_data_packet(length, (channel_idx + 1),
+			TL_PROTOCOLID_COM_DATA);
 	if (!packet)
 		return -ENOMEM;
 	packet->packet_callback = callback;
 	packet->callback_data = callback_data;
-	memcpy((unsigned char *) packet +
-			sizeof(struct ipw_tx_packet), data, length);
+	memcpy((unsigned char *) packet + sizeof(struct ipw_tx_packet), data,
+			length);
 
 	send_packet(hw, PRIO_DATA, packet);
 	return 0;
@@ -1321,12 +1308,11 @@ static int set_control_line(struct ipw_hardware *hw, int prio,
 		protocolid = TL_PROTOCOLID_SETUP;
 
 	packet = alloc_ctrl_packet(sizeof(struct ipw_control_packet),
-			(unsigned char) (channel_idx + 1),
-			protocolid, line);
+			(channel_idx + 1), protocolid, line);
 	if (!packet)
 		return -ENOMEM;
 	packet->header.length = sizeof(struct ipw_control_packet_body);
-	packet->body.value = (unsigned char) (state == 0 ? 0 : 1);
+	packet->body.value = (state == 0 ? 0 : 1);
 	send_packet(hw, prio, &packet->header);
 	return 0;
 }
@@ -1651,8 +1637,8 @@ void ipwireless_init_hardware_v1(struct ipw_hardware *hw,
 		enable_irq(hw->irq);
 	}
 	hw->base_port = base_port;
-	hw->hw_version = is_v2_card ? HW_VERSION_2 : HW_VERSION_1;
-	hw->ll_mtu = hw->hw_version == HW_VERSION_1 ? LL_MTU_V1 : LL_MTU_V2;
+	hw->hw_version = (is_v2_card ? HW_VERSION_2 : HW_VERSION_1);
+	hw->ll_mtu = (hw->hw_version == HW_VERSION_1 ? LL_MTU_V1 : LL_MTU_V2);
 	hw->memregs_CCR = (struct MEMCCR __iomem *)
 			((unsigned short __iomem *) attr_memory + 0x200);
 	hw->memory_info_regs = (struct MEMINFREG __iomem *) common_memory;

