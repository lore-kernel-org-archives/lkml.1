Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYFFJuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYFFJuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYFFJuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:50:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:41613 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753007AbYFFJup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:50:45 -0400
Date: Fri, 6 Jun 2008 11:50:43 +0200
From: David Sterba <dsterba@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jkosina@suse.cz,
       michal.rokos@gmail.com
Subject: [PATCH] ipwireless: Fix blocked sending
Message-ID: <20080606095043.GB15735@ds.suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sterba <dsterba@suse.cz>
Date: 2008-06-06 10:56:35 +0200

ipwireless: Fix blocked sending

Packet sending is driven by two flags, tx_ready and tx_queued.
It was possible, that there were queued data for sending and
hardware was flagged as blocked but in fact it was not.

The tx_queued was indicator but should be really a counter else
first fragmented packet resets tx_queued flag, but there may be
pending packets which do not get sent.

New semantics:
tx_ready - set, if hw is ready to send packet, no packet is being
           transferred right now
           set the flag right at the place where data are copied
           into hw memory and not earlier without checking if it
           was succesful
tx_queued - count of enqueued packets, including fragments

Tested-by: Michal Rokos <michal.rokos@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index fa9d3c9..ba6340a 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -251,10 +251,11 @@ struct ipw_hardware {
 	int init_loops;
 	struct timer_list setup_timer;
 
+	/* Flag if hw is ready to send next packet */
 	int tx_ready;
-	struct list_head tx_queue[NL_NUM_OF_PRIORITIES];
-	/* True if any packets are queued for transmission */
+	/* Count of pending packets to be sent */
 	int tx_queued;
+	struct list_head tx_queue[NL_NUM_OF_PRIORITIES];
 
 	int rx_bytes_queued;
 	struct list_head rx_queue;
@@ -404,6 +405,8 @@ static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
 
 	spin_lock_irqsave(&hw->spinlock, flags);
 
+	hw->tx_ready = 0;
+
 	if (hw->hw_version == HW_VERSION_1) {
 		outw((unsigned short) length, hw->base_port + IODWR);
 
@@ -492,6 +495,7 @@ static int do_send_packet(struct ipw_hardware *hw, struct ipw_tx_packet *packet)
 
 		spin_lock_irqsave(&hw->spinlock, flags);
 		list_add(&packet->queue, &hw->tx_queue[0]);
+		hw->tx_queued++;
 		spin_unlock_irqrestore(&hw->spinlock, flags);
 	} else {
 		if (packet->packet_callback)
@@ -949,12 +953,10 @@ static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->spinlock, flags);
-	if (hw->tx_queued && hw->tx_ready != 0) {
+	if (hw->tx_queued && hw->tx_ready) {
 		int priority;
 		struct ipw_tx_packet *packet = NULL;
 
-		hw->tx_ready--;
-
 		/* Pick a packet */
 		for (priority = 0; priority < priority_limit; priority++) {
 			if (!list_empty(&hw->tx_queue[priority])) {
@@ -963,6 +965,7 @@ static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
 						struct ipw_tx_packet,
 						queue);
 
+				hw->tx_queued--;
 				list_del(&packet->queue);
 
 				break;
@@ -973,6 +976,7 @@ static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
 			spin_unlock_irqrestore(&hw->spinlock, flags);
 			return 0;
 		}
+
 		spin_unlock_irqrestore(&hw->spinlock, flags);
 
 		/* Send */
@@ -1063,7 +1067,7 @@ static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
 		if (irqn & IR_TXINTR) {
 			ack |= IR_TXINTR;
 			spin_lock_irqsave(&hw->spinlock, flags);
-			hw->tx_ready++;
+			hw->tx_ready = 1;
 			spin_unlock_irqrestore(&hw->spinlock, flags);
 		}
 		/* Received data */
@@ -1170,7 +1174,7 @@ static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
 	if (memrxdone & MEMRX_RX_DONE) {
 		writew(0, &hw->memory_info_regs->memreg_rx_done);
 		spin_lock_irqsave(&hw->spinlock, flags);
-		hw->tx_ready++;
+		hw->tx_ready = 1;
 		spin_unlock_irqrestore(&hw->spinlock, flags);
 		tx = 1;
 	}
@@ -1234,7 +1238,7 @@ static void send_packet(struct ipw_hardware *hw, int priority,
 
 	spin_lock_irqsave(&hw->spinlock, flags);
 	list_add_tail(&packet->queue, &hw->tx_queue[priority]);
-	hw->tx_queued = 1;
+	hw->tx_queued++;
 	spin_unlock_irqrestore(&hw->spinlock, flags);
 
 	flush_packets_to_hw(hw);
