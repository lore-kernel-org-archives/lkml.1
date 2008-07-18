Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYGRWLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYGRWLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYGRWLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:07 -0400
Received: from styx.suse.cz ([82.119.242.94]:55487 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757023AbYGRWLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:06 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 02/12] ipwireless: Remove unused defines
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:04 +0200
Message-ID: <20080718221104.19195.74210.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused defines, defines hiding variables, defines hiding 0.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |   15 ++++++---------
 drivers/char/pcmcia/ipwireless/network.c  |    3 +--
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 6a3e666..ce57a7f 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -227,15 +227,12 @@ struct MEMINFREG {
 	unsigned short memreg_tx_new;	/* TX2 (new) Register (R/W) */
 };
 
-#define IODMADPR 0x00		/* DMA Data Port Register (R/W) */
-
 #define CARD_PRESENT_VALUE (0xBEEFCAFEUL)
 
 #define MEMTX_TX                       0x0001
 #define MEMRX_RX                       0x0001
 #define MEMRX_RX_DONE                  0x0001
 #define MEMRX_PCINTACKK                0x0001
-#define MEMRX_MEMSPURIOUSINT           0x0001
 
 #define NL_NUM_OF_PRIORITIES       3
 #define NL_NUM_OF_PROTOCOLS        3
@@ -422,7 +419,7 @@ static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
 
 		outw(DCR_TXDONE, hw->base_port + IODCR);
 	} else if (hw->hw_version == HW_VERSION_2) {
-		outw((unsigned short) length, hw->base_port + IODMADPR);
+		outw((unsigned short) length, hw->base_port);
 
 		for (i = 0; i < length; i += 2) {
 			unsigned short d = data[i];
@@ -431,10 +428,10 @@ static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
 			if (i + 1 < length)
 				d |= data[i + 1] << 8;
 			raw_data = cpu_to_le16(d);
-			outw(raw_data, hw->base_port + IODMADPR);
+			outw(raw_data, hw->base_port);
 		}
 		while ((i & 3) != 2) {
-			outw((unsigned short) 0xDEAD, hw->base_port + IODMADPR);
+			outw((unsigned short) 0xDEAD, hw->base_port);
 			i += 2;
 		}
 		writew(MEMRX_RX, &hw->memory_info_regs->memreg_rx);
@@ -863,7 +860,7 @@ static void do_receive_packet(struct ipw_hardware *hw)
 			pkt[i + 1] = (unsigned char) (data >> 8);
 		}
 	} else {
-		len = inw(hw->base_port + IODMADPR);
+		len = inw(hw->base_port);
 		if (len > hw->ll_mtu) {
 			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
 			       ": received a packet of %u bytes - "
@@ -874,7 +871,7 @@ static void do_receive_packet(struct ipw_hardware *hw)
 		}
 
 		for (i = 0; i < len; i += 2) {
-			__le16 raw_data = inw(hw->base_port + IODMADPR);
+			__le16 raw_data = inw(hw->base_port);
 			unsigned short data = le16_to_cpu(raw_data);
 
 			pkt[i] = (unsigned char) data;
@@ -882,7 +879,7 @@ static void do_receive_packet(struct ipw_hardware *hw)
 		}
 
 		while ((i & 3) != 2) {
-			inw(hw->base_port + IODMADPR);
+			inw(hw->base_port);
 			i += 2;
 		}
 	}
diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/char/pcmcia/ipwireless/network.c
index fe914d3..cf12eb4 100644
--- a/drivers/char/pcmcia/ipwireless/network.c
+++ b/drivers/char/pcmcia/ipwireless/network.c
@@ -29,7 +29,6 @@
 #include "main.h"
 #include "tty.h"
 
-#define MAX_OUTGOING_PACKETS_QUEUED   ipwireless_out_queue
 #define MAX_ASSOCIATED_TTYS 2
 
 #define SC_RCV_BITS     (SC_RCV_B7_1|SC_RCV_B7_0|SC_RCV_ODDP|SC_RCV_EVNP)
@@ -94,7 +93,7 @@ static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
 	unsigned long flags;
 
 	spin_lock_irqsave(&network->spinlock, flags);
-	if (network->outgoing_packets_queued < MAX_OUTGOING_PACKETS_QUEUED) {
+	if (network->outgoing_packets_queued < ipwireless_out_queue) {
 		unsigned char *buf;
 		static unsigned char header[] = {
 			PPP_ALLSTATIONS, /* 0xff */

