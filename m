Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbYFNAMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbYFNAMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbYFNAMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:51582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558AbYFNAMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:21 -0400
Date: Fri, 13 Jun 2008 17:10:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Sterba <dsterba@suse.cz>,
       Jiri Kosina <jkosina@suse.cz>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 02/47] ipwireless: Fix blocked sending
Message-ID: <20080614001016.GB24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipwireless-fix-blocked-sending.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Sterba <dsterba@suse.cz>

upstream commit: eb4e545d4ac82d9018487edb4419b33b9930c857

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/char/pcmcia/ipwireless/hardware.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

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
@@ -430,6 +431,8 @@ static int do_send_fragment(struct ipw_h
 
 	spin_lock_irqsave(&hw->spinlock, flags);
 
+	hw->tx_ready = 0;
+
 	if (hw->hw_version == HW_VERSION_1) {
 		outw((unsigned short) length, hw->base_port + IODWR);
 
@@ -518,6 +521,7 @@ static int do_send_packet(struct ipw_har
 
 		spin_lock_irqsave(&hw->spinlock, flags);
 		list_add(&packet->queue, &hw->tx_queue[0]);
+		hw->tx_queued++;
 		spin_unlock_irqrestore(&hw->spinlock, flags);
 	} else {
 		if (packet->packet_callback)
@@ -975,12 +979,10 @@ static int send_pending_packet(struct ip
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
@@ -989,6 +991,7 @@ static int send_pending_packet(struct ip
 						struct ipw_tx_packet,
 						queue);
 
+				hw->tx_queued--;
 				list_del(&packet->queue);
 
 				break;
@@ -999,6 +1002,7 @@ static int send_pending_packet(struct ip
 			spin_unlock_irqrestore(&hw->spinlock, flags);
 			return 0;
 		}
+
 		spin_unlock_irqrestore(&hw->spinlock, flags);
 
 		/* Send */
@@ -1089,7 +1093,7 @@ static irqreturn_t ipwireless_handle_v1_
 		if (irqn & IR_TXINTR) {
 			ack |= IR_TXINTR;
 			spin_lock_irqsave(&hw->spinlock, flags);
-			hw->tx_ready++;
+			hw->tx_ready = 1;
 			spin_unlock_irqrestore(&hw->spinlock, flags);
 		}
 		/* Received data */
@@ -1196,7 +1200,7 @@ static irqreturn_t ipwireless_handle_v2_
 	if (memrxdone & MEMRX_RX_DONE) {
 		writew(0, &hw->memory_info_regs->memreg_rx_done);
 		spin_lock_irqsave(&hw->spinlock, flags);
-		hw->tx_ready++;
+		hw->tx_ready = 1;
 		spin_unlock_irqrestore(&hw->spinlock, flags);
 		tx = 1;
 	}
@@ -1260,7 +1264,7 @@ static void send_packet(struct ipw_hardw
 
 	spin_lock_irqsave(&hw->spinlock, flags);
 	list_add_tail(&packet->queue, &hw->tx_queue[priority]);
-	hw->tx_queued = 1;
+	hw->tx_queued++;
 	spin_unlock_irqrestore(&hw->spinlock, flags);
 
 	flush_packets_to_hw(hw);

-- 
