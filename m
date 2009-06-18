Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbZFRHpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbZFRHpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759811AbZFRHmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:44 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47403 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759953AbZFRHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:42 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 12/13] Char: cyclades, introduce cyy_readb/writeb
Date: Thu, 18 Jun 2009 09:41:47 +0200
Message-Id: <1245310908-27691-12-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for io operations, so that we can eliminate huge
amount of supporting code. It is now centralized in those
helpers and used values are precomputed in the init phase.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c  |  448 +++++++++++++++++-----------------------------
 include/linux/cyclades.h |    2 +-
 2 files changed, 165 insertions(+), 285 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index ed9ec2c..76248aa 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -89,7 +89,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
-static void cy_throttle(struct tty_struct *tty);
 static void cy_send_xchar(struct tty_struct *tty, char ch);
 
 #ifndef SERIAL_XMIT_SIZE
@@ -297,6 +296,20 @@ static void cyz_rx_restart(unsigned long);
 static struct timer_list cyz_rx_full_timer[NR_PORTS];
 #endif				/* CONFIG_CYZ_INTR */
 
+static inline void cyy_writeb(struct cyclades_port *port, u32 reg, u8 val)
+{
+	struct cyclades_card *card = port->card;
+
+	cy_writeb(port->u.cyy.base_addr + (reg << card->bus_index), val);
+}
+
+static inline u8 cyy_readb(struct cyclades_port *port, u32 reg)
+{
+	struct cyclades_card *card = port->card;
+
+	return readb(port->u.cyy.base_addr + (reg << card->bus_index));
+}
+
 static inline bool cy_is_Z(struct cyclades_card *card)
 {
 	return card->num_chips == (unsigned int)-1;
@@ -349,13 +362,14 @@ static inline int serial_paranoia_check(struct cyclades_port *info,
 
    This function is only called from inside spinlock-protected code.
  */
-static int cyy_issue_cmd(void __iomem *base_addr, u_char cmd, int index)
+static int __cyy_issue_cmd(void __iomem *base_addr, u8 cmd, int index)
 {
+	void __iomem *ccr = base_addr + (CyCCR << index);
 	unsigned int i;
 
 	/* Check to see that the previous command has completed */
 	for (i = 0; i < 100; i++) {
-		if (readb(base_addr + (CyCCR << index)) == 0)
+		if (readb(ccr) == 0)
 			break;
 		udelay(10L);
 	}
@@ -365,10 +379,16 @@ static int cyy_issue_cmd(void __iomem *base_addr, u_char cmd, int index)
 		return -1;
 
 	/* Issue the new command */
-	cy_writeb(base_addr + (CyCCR << index), cmd);
+	cy_writeb(ccr, cmd);
 
 	return 0;
-}				/* cyy_issue_cmd */
+}
+
+static inline int cyy_issue_cmd(struct cyclades_port *port, u8 cmd)
+{
+	return __cyy_issue_cmd(port->u.cyy.base_addr, cmd,
+			port->card->bus_index);
+}
 
 #ifdef CONFIG_ISA
 /* ISA interrupt detection code */
@@ -393,7 +413,7 @@ static unsigned detect_isa_irq(void __iomem *address)
 	/* Enable the Tx interrupts on the CD1400 */
 	local_irq_save(flags);
 	cy_writeb(address + (CyCAR << index), 0);
-	cyy_issue_cmd(address, CyCHAN_CTL | CyENB_XMTR, index);
+	__cyy_issue_cmd(address, CyCHAN_CTL | CyENB_XMTR, index);
 
 	cy_writeb(address + (CyCAR << index), 0);
 	cy_writeb(address + (CySRER << index),
@@ -427,7 +447,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 	struct cyclades_port *info;
 	struct tty_struct *tty;
 	int len, index = cinfo->bus_index;
-	u8 save_xir, channel, save_car, data, char_count;
+	u8 ivr, save_xir, channel, save_car, data, char_count;
 
 #ifdef CY_DEBUG_INTERRUPTS
 	printk(KERN_DEBUG "cyy_interrupt: rcvd intr, chip %d\n", chip);
@@ -436,26 +456,25 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 	save_xir = readb(base_addr + (CyRIR << index));
 	channel = save_xir & CyIRChannel;
 	info = &cinfo->ports[channel + chip * 4];
-	save_car = readb(base_addr + (CyCAR << index));
-	cy_writeb(base_addr + (CyCAR << index), save_xir);
+	save_car = cyy_readb(info, CyCAR);
+	cyy_writeb(info, CyCAR, save_xir);
+	ivr = cyy_readb(info, CyRIVR) & CyIVRMask;
 
 	tty = tty_port_tty_get(&info->port);
 	/* if there is nowhere to put the data, discard it */
 	if (tty == NULL) {
-		if ((readb(base_addr + (CyRIVR << index)) & CyIVRMask) ==
-				CyIVRRxEx) {	/* exception */
-			data = readb(base_addr + (CyRDSR << index));
+		if (ivr == CyIVRRxEx) {	/* exception */
+			data = cyy_readb(info, CyRDSR);
 		} else {	/* normal character reception */
-			char_count = readb(base_addr + (CyRDCR << index));
+			char_count = cyy_readb(info, CyRDCR);
 			while (char_count--)
-				data = readb(base_addr + (CyRDSR << index));
+				data = cyy_readb(info, CyRDSR);
 		}
 		goto end;
 	}
 	/* there is an open port for this data */
-	if ((readb(base_addr + (CyRIVR << index)) & CyIVRMask) ==
-			CyIVRRxEx) {	/* exception */
-		data = readb(base_addr + (CyRDSR << index));
+	if (ivr == CyIVRRxEx) {	/* exception */
+		data = cyy_readb(info, CyRDSR);
 
 		/* For statistics only */
 		if (data & CyBREAK)
@@ -476,22 +495,22 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 			if (data & info->read_status_mask) {
 				if (data & CyBREAK) {
 					tty_insert_flip_char(tty,
-						readb(base_addr + (CyRDSR <<
-							index)), TTY_BREAK);
+						cyy_readb(info, CyRDSR),
+						TTY_BREAK);
 					info->icount.rx++;
 					if (info->port.flags & ASYNC_SAK)
 						do_SAK(tty);
 				} else if (data & CyFRAME) {
 					tty_insert_flip_char(tty,
-						readb(base_addr + (CyRDSR <<
-							index)), TTY_FRAME);
+						cyy_readb(info, CyRDSR),
+						TTY_FRAME);
 					info->icount.rx++;
 					info->idle_stats.frame_errs++;
 				} else if (data & CyPARITY) {
 					/* Pieces of seven... */
 					tty_insert_flip_char(tty,
-						readb(base_addr + (CyRDSR <<
-							index)), TTY_PARITY);
+						cyy_readb(info, CyRDSR),
+						TTY_PARITY);
 					info->icount.rx++;
 					info->idle_stats.parity_errs++;
 				} else if (data & CyOVERRUN) {
@@ -503,8 +522,8 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 					   the next incoming character.
 					 */
 					tty_insert_flip_char(tty,
-						readb(base_addr + (CyRDSR <<
-							index)), TTY_FRAME);
+						cyy_readb(info, CyRDSR),
+						TTY_FRAME);
 					info->icount.rx++;
 					info->idle_stats.overruns++;
 				/* These two conditions may imply */
@@ -528,7 +547,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 		}
 	} else {	/* normal character reception */
 		/* load # chars available from the chip */
-		char_count = readb(base_addr + (CyRDCR << index));
+		char_count = cyy_readb(info, CyRDCR);
 
 #ifdef CY_ENABLE_MONITORING
 		++info->mon.int_count;
@@ -539,7 +558,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 #endif
 		len = tty_buffer_request_room(tty, char_count);
 		while (len--) {
-			data = readb(base_addr + (CyRDSR << index));
+			data = cyy_readb(info, CyRDSR);
 			tty_insert_flip_char(tty, data, TTY_NORMAL);
 			info->idle_stats.recv_bytes++;
 			info->icount.rx++;
@@ -553,8 +572,8 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 	tty_kref_put(tty);
 end:
 	/* end of service */
-	cy_writeb(base_addr + (CyRIR << index), save_xir & 0x3f);
-	cy_writeb(base_addr + (CyCAR << index), save_car);
+	cyy_writeb(info, CyRIR, save_xir & 0x3f);
+	cyy_writeb(info, CyCAR, save_car);
 }
 
 static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
@@ -587,8 +606,7 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 	info = &cinfo->ports[channel + chip * 4];
 	tty = tty_port_tty_get(&info->port);
 	if (tty == NULL) {
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
+		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) & ~CyTxRdy);
 		goto end;
 	}
 
@@ -597,7 +615,7 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 
 	if (info->x_char) {	/* send special char */
 		outch = info->x_char;
-		cy_writeb(base_addr + (CyTDR << index), outch);
+		cyy_writeb(info, CyTDR, outch);
 		char_count--;
 		info->icount.tx++;
 		info->x_char = 0;
@@ -605,14 +623,14 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 
 	if (info->breakon || info->breakoff) {
 		if (info->breakon) {
-			cy_writeb(base_addr + (CyTDR << index), 0);
-			cy_writeb(base_addr + (CyTDR << index), 0x81);
+			cyy_writeb(info, CyTDR, 0);
+			cyy_writeb(info, CyTDR, 0x81);
 			info->breakon = 0;
 			char_count -= 2;
 		}
 		if (info->breakoff) {
-			cy_writeb(base_addr + (CyTDR << index), 0);
-			cy_writeb(base_addr + (CyTDR << index), 0x83);
+			cyy_writeb(info, CyTDR, 0);
+			cyy_writeb(info, CyTDR, 0x83);
 			info->breakoff = 0;
 			char_count -= 2;
 		}
@@ -620,27 +638,23 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 
 	while (char_count-- > 0) {
 		if (!info->xmit_cnt) {
-			if (readb(base_addr + (CySRER << index)) & CyTxMpty) {
-				cy_writeb(base_addr + (CySRER << index),
-					readb(base_addr + (CySRER << index)) &
-						~CyTxMpty);
+			if (cyy_readb(info, CySRER) & CyTxMpty) {
+				cyy_writeb(info, CySRER,
+					cyy_readb(info, CySRER) & ~CyTxMpty);
 			} else {
-				cy_writeb(base_addr + (CySRER << index),
-					(readb(base_addr + (CySRER << index)) &
-						~CyTxRdy) | CyTxMpty);
+				cyy_writeb(info, CySRER, CyTxMpty |
+					(cyy_readb(info, CySRER) & ~CyTxRdy));
 			}
 			goto done;
 		}
 		if (info->port.xmit_buf == NULL) {
-			cy_writeb(base_addr + (CySRER << index),
-				readb(base_addr + (CySRER << index)) &
-					~CyTxRdy);
+			cyy_writeb(info, CySRER,
+				cyy_readb(info, CySRER) & ~CyTxRdy);
 			goto done;
 		}
 		if (tty->stopped || tty->hw_stopped) {
-			cy_writeb(base_addr + (CySRER << index),
-				readb(base_addr + (CySRER << index)) &
-					~CyTxRdy);
+			cyy_writeb(info, CySRER,
+				cyy_readb(info, CySRER) & ~CyTxRdy);
 			goto done;
 		}
 		/* Because the Embedded Transmit Commands have been enabled,
@@ -657,15 +671,15 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 			info->xmit_cnt--;
 			info->xmit_tail = (info->xmit_tail + 1) &
 					(SERIAL_XMIT_SIZE - 1);
-			cy_writeb(base_addr + (CyTDR << index), outch);
+			cyy_writeb(info, CyTDR, outch);
 			info->icount.tx++;
 		} else {
 			if (char_count > 1) {
 				info->xmit_cnt--;
 				info->xmit_tail = (info->xmit_tail + 1) &
 					(SERIAL_XMIT_SIZE - 1);
-				cy_writeb(base_addr + (CyTDR << index), outch);
-				cy_writeb(base_addr + (CyTDR << index), 0);
+				cyy_writeb(info, CyTDR, outch);
+				cyy_writeb(info, CyTDR, 0);
 				info->icount.tx++;
 				char_count--;
 			}
@@ -677,8 +691,8 @@ done:
 	tty_kref_put(tty);
 end:
 	/* end of service */
-	cy_writeb(base_addr + (CyTIR << index), save_xir & 0x3f);
-	cy_writeb(base_addr + (CyCAR << index), save_car);
+	cyy_writeb(info, CyTIR, save_xir & 0x3f);
+	cyy_writeb(info, CyCAR, save_car);
 }
 
 static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
@@ -693,11 +707,11 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 	save_xir = readb(base_addr + (CyMIR << index));
 	channel = save_xir & CyIRChannel;
 	info = &cinfo->ports[channel + chip * 4];
-	save_car = readb(base_addr + (CyCAR << index));
-	cy_writeb(base_addr + (CyCAR << index), save_xir);
+	save_car = cyy_readb(info, CyCAR);
+	cyy_writeb(info, CyCAR, save_xir);
 
-	mdm_change = readb(base_addr + (CyMISR << index));
-	mdm_status = readb(base_addr + (CyMSVR1 << index));
+	mdm_change = cyy_readb(info, CyMISR);
+	mdm_status = cyy_readb(info, CyMSVR1);
 
 	tty = tty_port_tty_get(&info->port);
 	if (!tty)
@@ -729,9 +743,8 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 				/* cy_start isn't used
 				   because... !!! */
 				tty->hw_stopped = 0;
-				cy_writeb(base_addr + (CySRER << index),
-					readb(base_addr + (CySRER << index)) |
-						CyTxRdy);
+				cyy_writeb(info, CySRER,
+					cyy_readb(info, CySRER) | CyTxRdy);
 				tty_wakeup(tty);
 			}
 		} else {
@@ -739,9 +752,8 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 				/* cy_stop isn't used
 				   because ... !!! */
 				tty->hw_stopped = 1;
-				cy_writeb(base_addr + (CySRER << index),
-					readb(base_addr + (CySRER << index)) &
-						~CyTxRdy);
+				cyy_writeb(info, CySRER,
+					cyy_readb(info, CySRER) & ~CyTxRdy);
 			}
 		}
 	}
@@ -752,8 +764,8 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 	tty_kref_put(tty);
 end:
 	/* end of service */
-	cy_writeb(base_addr + (CyMIR << index), save_xir & 0x3f);
-	cy_writeb(base_addr + (CyCAR << index), save_car);
+	cyy_writeb(info, CyMIR, save_xir & 0x3f);
+	cyy_writeb(info, CyCAR, save_car);
 }
 
 /* The real interrupt service routine is called
@@ -828,15 +840,10 @@ static void cyy_change_rts_dtr(struct cyclades_port *info, unsigned int set,
 		unsigned int clear)
 {
 	struct cyclades_card *card = info->card;
-	void __iomem *base_addr;
-	int chip, channel, index;
+	int channel = info->line - card->first_line;
 	u32 rts, dtr, msvrr, msvrd;
 
-	channel = info->line - card->first_line;
-	chip = channel >> 2;
 	channel &= 0x03;
-	index = card->bus_index;
-	base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 	if (info->rtsdtr_inv) {
 		msvrr = CyMSVR2;
@@ -850,31 +857,31 @@ static void cyy_change_rts_dtr(struct cyclades_port *info, unsigned int set,
 		dtr = CyDTR;
 	}
 	if (set & TIOCM_RTS) {
-		cy_writeb(base_addr + (CyCAR << index), (u8)channel);
-		cy_writeb(base_addr + (msvrr << index), rts);
+		cyy_writeb(info, CyCAR, channel);
+		cyy_writeb(info, msvrr, rts);
 	}
 	if (clear & TIOCM_RTS) {
-		cy_writeb(base_addr + (CyCAR << index), (u8)channel);
-		cy_writeb(base_addr + (msvrr << index), ~rts);
+		cyy_writeb(info, CyCAR, channel);
+		cyy_writeb(info, msvrr, ~rts);
 	}
 	if (set & TIOCM_DTR) {
-		cy_writeb(base_addr + (CyCAR << index), (u8)channel);
-		cy_writeb(base_addr + (msvrd << index), dtr);
+		cyy_writeb(info, CyCAR, channel);
+		cyy_writeb(info, msvrd, dtr);
 #ifdef CY_DEBUG_DTR
 		printk(KERN_DEBUG "cyc:set_modem_info raising DTR\n");
 		printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-			readb(base_addr + (CyMSVR1 << index)),
-			readb(base_addr + (CyMSVR2 << index)));
+			cyy_readb(info, CyMSVR1),
+			cyy_readb(info, CyMSVR2));
 #endif
 	}
 	if (clear & TIOCM_DTR) {
-		cy_writeb(base_addr + (CyCAR << index), (u8)channel);
-		cy_writeb(base_addr + (msvrd << index), ~dtr);
+		cyy_writeb(info, CyCAR, channel);
+		cyy_writeb(info, msvrd, ~dtr);
 #ifdef CY_DEBUG_DTR
 		printk(KERN_DEBUG "cyc:set_modem_info dropping DTR\n");
 		printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-			readb(base_addr + (CyMSVR1 << index)),
-			readb(base_addr + (CyMSVR2 << index)));
+			cyy_readb(info, CyMSVR1),
+			cyy_readb(info, CyMSVR2));
 #endif
 	}
 }
@@ -1289,7 +1296,6 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 	struct cyclades_card *card;
 	unsigned long flags;
 	int retval = 0;
-	void __iomem *base_addr;
 	int channel;
 	unsigned long page;
 
@@ -1320,31 +1326,21 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 	cy_set_line_char(info, tty);
 
 	if (!cy_is_Z(card)) {
-		int chip = channel >> 2;
-		int index = card->bus_index;
 		channel &= 0x03;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
-#ifdef CY_DEBUG_OPEN
-		printk(KERN_DEBUG "cyc startup card %d, chip %d, channel %d, "
-				"base_addr %p\n",
-				card, chip, channel, base_addr);
-#endif
 		spin_lock_irqsave(&card->card_lock, flags);
 
-		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		cyy_writeb(info, CyCAR, channel);
 
-		cy_writeb(base_addr + (CyRTPR << index),
+		cyy_writeb(info, CyRTPR,
 			(info->default_timeout ? info->default_timeout : 0x02));
 		/* 10ms rx timeout */
 
-		cyy_issue_cmd(base_addr, CyCHAN_CTL | CyENB_RCVR | CyENB_XMTR,
-				index);
+		cyy_issue_cmd(info, CyCHAN_CTL | CyENB_RCVR | CyENB_XMTR);
 
 		cyy_change_rts_dtr(info, TIOCM_RTS | TIOCM_DTR, 0);
 
-		cy_writeb(base_addr + (CySRER << index),
-			readb(base_addr + (CySRER << index)) | CyRxData);
+		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) | CyRxData);
 	} else {
 		struct CH_CTRL __iomem *ch_ctrl = info->u.cyz.ch_ctrl;
 
@@ -1422,23 +1418,14 @@ errout:
 
 static void start_xmit(struct cyclades_port *info)
 {
-	struct cyclades_card *card;
+	struct cyclades_card *card = info->card;
 	unsigned long flags;
-	void __iomem *base_addr;
-	int chip, channel, index;
+	int channel = info->line - card->first_line;
 
-	card = info->card;
-	channel = info->line - card->first_line;
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
-
 		spin_lock_irqsave(&card->card_lock, flags);
-		cy_writeb(base_addr + (CyCAR << index), channel);
-		cy_writeb(base_addr + (CySRER << index),
-			readb(base_addr + (CySRER << index)) | CyTxRdy);
+		cyy_writeb(info, CyCAR, channel & 0x03);
+		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) | CyTxRdy);
 		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
 #ifdef CONFIG_CYZ_INTR
@@ -1465,8 +1452,7 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 {
 	struct cyclades_card *card;
 	unsigned long flags;
-	void __iomem *base_addr;
-	int chip, channel, index;
+	int channel;
 
 	if (!(info->port.flags & ASYNC_INITIALIZED))
 		return;
@@ -1474,17 +1460,6 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 	card = info->card;
 	channel = info->line - card->first_line;
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
-
-#ifdef CY_DEBUG_OPEN
-		printk(KERN_DEBUG "cyc shutdown Y card %d, chip %d, "
-				"channel %d, base_addr %p\n",
-				card, chip, channel, base_addr);
-#endif
-
 		spin_lock_irqsave(&card->card_lock, flags);
 
 		/* Clear delta_msr_wait queue to avoid mem leaks. */
@@ -1499,7 +1474,7 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 		if (tty->termios->c_cflag & HUPCL)
 			cyy_change_rts_dtr(info, 0, TIOCM_RTS | TIOCM_DTR);
 
-		cyy_issue_cmd(base_addr, CyCHAN_CTL | CyDIS_RCVR, index);
+		cyy_issue_cmd(info, CyCHAN_CTL | CyDIS_RCVR);
 		/* it may be appropriate to clear _XMIT at
 		   some later date (after testing)!!! */
 
@@ -1676,8 +1651,6 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 {
 	struct cyclades_card *card;
 	struct cyclades_port *info = tty->driver_data;
-	void __iomem *base_addr;
-	int chip, channel, index;
 	unsigned long orig_jiffies;
 	int char_time;
 
@@ -1721,13 +1694,8 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 		timeout, char_time, jiffies);
 #endif
 	card = info->card;
-	channel = (info->line) - (card->first_line);
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
-		while (readb(base_addr + (CySRER << index)) & CyTxRdy) {
+		while (cyy_readb(info, CySRER) & CyTxRdy) {
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
 			printk(KERN_DEBUG "Not clean (jiff=%lu)...", jiffies);
 #endif
@@ -1789,6 +1757,7 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 	struct cyclades_port *info = tty->driver_data;
 	struct cyclades_card *card;
 	unsigned long flags;
+	int channel;
 
 	if (!info || serial_paranoia_check(info, tty->name, "cy_close"))
 		return;
@@ -1798,18 +1767,13 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 	if (!tty_port_close_start(&info->port, tty, filp))
 		return;
 
+	channel = info->line - card->first_line;
 	spin_lock_irqsave(&card->card_lock, flags);
 
 	if (!cy_is_Z(card)) {
-		int channel = info->line - card->first_line;
-		int index = card->bus_index;
-		void __iomem *base_addr = card->base_addr +
-			(cy_chip_offset[channel >> 2] << index);
 		/* Stop accepting input */
-		channel &= 0x03;
-		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) & ~CyRxData);
+		cyy_writeb(info, CyCAR, channel & 0x03);
+		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) & ~CyRxData);
 		if (info->port.flags & ASYNC_INITIALIZED) {
 			/* Waiting for on-board buffers to be empty before
 			   closing the port */
@@ -1822,7 +1786,6 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 		/* Waiting for on-board buffers to be empty before closing
 		   the port */
 		struct CH_CTRL __iomem *ch_ctrl = info->u.cyz.ch_ctrl;
-		int channel = info->line - card->first_line;
 		int retval;
 
 		if (readl(&ch_ctrl->flow_status) != C_FS_TXIDLE) {
@@ -2063,8 +2026,7 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 {
 	struct cyclades_card *card;
 	unsigned long flags;
-	void __iomem *base_addr;
-	int chip, channel, index;
+	int channel;
 	unsigned cflag, iflag;
 	int baud, baud_rate = 0;
 	int i;
@@ -2094,9 +2056,6 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 	channel = info->line - card->first_line;
 
 	if (!cy_is_Z(card)) {
-
-		index = card->bus_index;
-
 		/* baud rate */
 		baud = tty_get_baud_rate(tty);
 		if (baud == 38400 && (info->port.flags & ASYNC_SPD_MASK) ==
@@ -2207,70 +2166,67 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 	    cable.  Contact Marcio Saito for details.
 	 ***********************************************/
 
-		chip = channel >> 2;
 		channel &= 0x03;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		spin_lock_irqsave(&card->card_lock, flags);
-		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		cyy_writeb(info, CyCAR, channel);
 
 		/* tx and rx baud rate */
 
-		cy_writeb(base_addr + (CyTCOR << index), info->tco);
-		cy_writeb(base_addr + (CyTBPR << index), info->tbpr);
-		cy_writeb(base_addr + (CyRCOR << index), info->rco);
-		cy_writeb(base_addr + (CyRBPR << index), info->rbpr);
+		cyy_writeb(info, CyTCOR, info->tco);
+		cyy_writeb(info, CyTBPR, info->tbpr);
+		cyy_writeb(info, CyRCOR, info->rco);
+		cyy_writeb(info, CyRBPR, info->rbpr);
 
 		/* set line characteristics  according configuration */
 
-		cy_writeb(base_addr + (CySCHR1 << index), START_CHAR(tty));
-		cy_writeb(base_addr + (CySCHR2 << index), STOP_CHAR(tty));
-		cy_writeb(base_addr + (CyCOR1 << index), info->cor1);
-		cy_writeb(base_addr + (CyCOR2 << index), info->cor2);
-		cy_writeb(base_addr + (CyCOR3 << index), info->cor3);
-		cy_writeb(base_addr + (CyCOR4 << index), info->cor4);
-		cy_writeb(base_addr + (CyCOR5 << index), info->cor5);
+		cyy_writeb(info, CySCHR1, START_CHAR(tty));
+		cyy_writeb(info, CySCHR2, STOP_CHAR(tty));
+		cyy_writeb(info, CyCOR1, info->cor1);
+		cyy_writeb(info, CyCOR2, info->cor2);
+		cyy_writeb(info, CyCOR3, info->cor3);
+		cyy_writeb(info, CyCOR4, info->cor4);
+		cyy_writeb(info, CyCOR5, info->cor5);
 
-		cyy_issue_cmd(base_addr, CyCOR_CHANGE | CyCOR1ch | CyCOR2ch |
-				CyCOR3ch, index);
+		cyy_issue_cmd(info, CyCOR_CHANGE | CyCOR1ch | CyCOR2ch |
+				CyCOR3ch);
 
 		/* !!! Is this needed? */
-		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
-		cy_writeb(base_addr + (CyRTPR << index),
+		cyy_writeb(info, CyCAR, channel);
+		cyy_writeb(info, CyRTPR,
 			(info->default_timeout ? info->default_timeout : 0x02));
 		/* 10ms rx timeout */
 
 		if (C_CLOCAL(tty)) {
 			/* without modem intr */
-			cy_writeb(base_addr + (CySRER << index),
-				readb(base_addr + (CySRER << index)) | CyMdmCh);
+			cyy_writeb(info, CySRER,
+					cyy_readb(info, CySRER) | CyMdmCh);
 			/* act on 1->0 modem transitions */
 			if ((cflag & CRTSCTS) && info->rflow) {
-				cy_writeb(base_addr + (CyMCOR1 << index),
+				cyy_writeb(info, CyMCOR1,
 					  (CyCTS | rflow_thr[i]));
 			} else {
-				cy_writeb(base_addr + (CyMCOR1 << index),
+				cyy_writeb(info, CyMCOR1,
 					  CyCTS);
 			}
 			/* act on 0->1 modem transitions */
-			cy_writeb(base_addr + (CyMCOR2 << index), CyCTS);
+			cyy_writeb(info, CyMCOR2, CyCTS);
 		} else {
 			/* without modem intr */
-			cy_writeb(base_addr + (CySRER << index),
-				  readb(base_addr +
-					   (CySRER << index)) | CyMdmCh);
+			cyy_writeb(info, CySRER,
+					cyy_readb(info, CySRER) | CyMdmCh);
 			/* act on 1->0 modem transitions */
 			if ((cflag & CRTSCTS) && info->rflow) {
-				cy_writeb(base_addr + (CyMCOR1 << index),
+				cyy_writeb(info, CyMCOR1,
 					  (CyDSR | CyCTS | CyRI | CyDCD |
 					   rflow_thr[i]));
 			} else {
-				cy_writeb(base_addr + (CyMCOR1 << index),
-					  CyDSR | CyCTS | CyRI | CyDCD);
+				cyy_writeb(info, CyMCOR1,
+						CyDSR | CyCTS | CyRI | CyDCD);
 			}
 			/* act on 0->1 modem transitions */
-			cy_writeb(base_addr + (CyMCOR2 << index),
-				  CyDSR | CyCTS | CyRI | CyDCD);
+			cyy_writeb(info, CyMCOR2,
+					CyDSR | CyCTS | CyRI | CyDCD);
 		}
 
 		if (i == 0)	/* baud rate is zero, turn off line */
@@ -2481,24 +2437,14 @@ check_and_exit:
  */
 static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
 {
-	struct cyclades_card *card;
-	int chip, channel, index;
-	unsigned char status;
+	struct cyclades_card *card = info->card;
 	unsigned int result;
 	unsigned long flags;
-	void __iomem *base_addr;
+	u8 status;
 
-	card = info->card;
-	channel = (info->line) - (card->first_line);
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
-
 		spin_lock_irqsave(&card->card_lock, flags);
-		status = readb(base_addr + (CySRER << index)) &
-				(CyTxRdy | CyTxMpty);
+		status = cyy_readb(info, CySRER) & (CyTxRdy | CyTxMpty);
 		spin_unlock_irqrestore(&card->card_lock, flags);
 		result = (status ? 0 : TIOCSER_TEMT);
 	} else {
@@ -2512,29 +2458,23 @@ static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct cyclades_port *info = tty->driver_data;
 	struct cyclades_card *card;
-	void __iomem *base_addr;
-	int result, channel;
+	int result;
 
 	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	card = info->card;
-	channel = info->line - card->first_line;
 
 	lock_kernel();
 	if (!cy_is_Z(card)) {
 		unsigned long flags;
-		unsigned char status;
-		int chip = channel >> 2;
-		int index = card->bus_index;
-
-		channel &= 0x03;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
+		int channel = info->line - card->first_line;
+		u8 status;
 
 		spin_lock_irqsave(&card->card_lock, flags);
-		cy_writeb(base_addr + (CyCAR << index), (u8)channel);
-		status = readb(base_addr + (CyMSVR1 << index));
-		status |= readb(base_addr + (CyMSVR2 << index));
+		cyy_writeb(info, CyCAR, channel & 0x03);
+		status = cyy_readb(info, CyMSVR1);
+		status |= cyy_readb(info, CyMSVR2);
 		spin_unlock_irqrestore(&card->card_lock, flags);
 
 		if (info->rtsdtr_inv) {
@@ -2688,26 +2628,16 @@ static int cy_break(struct tty_struct *tty, int break_state)
 
 static int set_threshold(struct cyclades_port *info, unsigned long value)
 {
-	struct cyclades_card *card;
-	void __iomem *base_addr;
-	int channel, chip, index;
+	struct cyclades_card *card = info->card;
 	unsigned long flags;
 
-	card = info->card;
-	channel = info->line - card->first_line;
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr =
-		    card->base_addr + (cy_chip_offset[chip] << index);
-
 		info->cor3 &= ~CyREC_FIFO;
 		info->cor3 |= value & CyREC_FIFO;
 
 		spin_lock_irqsave(&card->card_lock, flags);
-		cy_writeb(base_addr + (CyCOR3 << index), info->cor3);
-		cyy_issue_cmd(base_addr, CyCOR_CHANGE | CyCOR3ch, index);
+		cyy_writeb(info, CyCOR3, info->cor3);
+		cyy_issue_cmd(info, CyCOR_CHANGE | CyCOR3ch);
 		spin_unlock_irqrestore(&card->card_lock, flags);
 	}
 	return 0;
@@ -2716,20 +2646,10 @@ static int set_threshold(struct cyclades_port *info, unsigned long value)
 static int get_threshold(struct cyclades_port *info,
 						unsigned long __user *value)
 {
-	struct cyclades_card *card;
-	void __iomem *base_addr;
-	int channel, chip, index;
-	unsigned long tmp;
+	struct cyclades_card *card = info->card;
 
-	card = info->card;
-	channel = info->line - card->first_line;
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
-
-		tmp = readb(base_addr + (CyCOR3 << index)) & CyREC_FIFO;
+		u8 tmp = cyy_readb(info, CyCOR3) & CyREC_FIFO;
 		return put_user(tmp, value);
 	}
 	return 0;
@@ -2737,21 +2657,12 @@ static int get_threshold(struct cyclades_port *info,
 
 static int set_timeout(struct cyclades_port *info, unsigned long value)
 {
-	struct cyclades_card *card;
-	void __iomem *base_addr;
-	int channel, chip, index;
+	struct cyclades_card *card = info->card;
 	unsigned long flags;
 
-	card = info->card;
-	channel = info->line - card->first_line;
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
-
 		spin_lock_irqsave(&card->card_lock, flags);
-		cy_writeb(base_addr + (CyRTPR << index), value & 0xff);
+		cyy_writeb(info, CyRTPR, value & 0xff);
 		spin_unlock_irqrestore(&card->card_lock, flags);
 	}
 	return 0;
@@ -2760,20 +2671,10 @@ static int set_timeout(struct cyclades_port *info, unsigned long value)
 static int get_timeout(struct cyclades_port *info,
 						unsigned long __user *value)
 {
-	struct cyclades_card *card;
-	void __iomem *base_addr;
-	int channel, chip, index;
-	unsigned long tmp;
+	struct cyclades_card *card = info->card;
 
-	card = info->card;
-	channel = info->line - card->first_line;
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
-
-		tmp = readb(base_addr + (CyRTPR << index));
+		u8 tmp = cyy_readb(info, CyRTPR);
 		return put_user(tmp, value);
 	}
 	return 0;
@@ -3100,8 +3001,7 @@ static void cy_stop(struct tty_struct *tty)
 {
 	struct cyclades_card *cinfo;
 	struct cyclades_port *info = tty->driver_data;
-	void __iomem *base_addr;
-	int chip, channel, index;
+	int channel;
 	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
@@ -3114,16 +3014,9 @@ static void cy_stop(struct tty_struct *tty)
 	cinfo = info->card;
 	channel = info->line - cinfo->first_line;
 	if (!cy_is_Z(cinfo)) {
-		index = cinfo->bus_index;
-		chip = channel >> 2;
-		channel &= 0x03;
-		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
-
 		spin_lock_irqsave(&cinfo->card_lock, flags);
-		cy_writeb(base_addr + (CyCAR << index),
-			(u_char)(channel & 0x0003)); /* index channel */
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
+		cyy_writeb(info, CyCAR, channel & 0x03);
+		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) & ~CyTxRdy);
 		spin_unlock_irqrestore(&cinfo->card_lock, flags);
 	}
 }				/* cy_stop */
@@ -3132,8 +3025,7 @@ static void cy_start(struct tty_struct *tty)
 {
 	struct cyclades_card *cinfo;
 	struct cyclades_port *info = tty->driver_data;
-	void __iomem *base_addr;
-	int chip, channel, index;
+	int channel;
 	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
@@ -3145,17 +3037,10 @@ static void cy_start(struct tty_struct *tty)
 
 	cinfo = info->card;
 	channel = info->line - cinfo->first_line;
-	index = cinfo->bus_index;
 	if (!cy_is_Z(cinfo)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
-
 		spin_lock_irqsave(&cinfo->card_lock, flags);
-		cy_writeb(base_addr + (CyCAR << index),
-			(u_char) (channel & 0x0003));	/* index channel */
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) | CyTxRdy);
+		cyy_writeb(info, CyCAR, channel & 0x03);
+		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) | CyTxRdy);
 		spin_unlock_irqrestore(&cinfo->card_lock, flags);
 	}
 }				/* cy_start */
@@ -3184,18 +3069,13 @@ static int cyy_carrier_raised(struct tty_port *port)
 	struct cyclades_port *info = container_of(port, struct cyclades_port,
 			port);
 	struct cyclades_card *cinfo = info->card;
-	void __iomem *base = cinfo->base_addr;
 	unsigned long flags;
 	int channel = info->line - cinfo->first_line;
-	int chip = channel >> 2, index = cinfo->bus_index;
 	u32 cd;
 
-	channel &= 0x03;
-	base += cy_chip_offset[chip] << index;
-
 	spin_lock_irqsave(&cinfo->card_lock, flags);
-	cy_writeb(base + (CyCAR << index), (u8)channel);
-	cd = readb(base + (CyMSVR1 << index)) & CyDCD;
+	cyy_writeb(info, CyCAR, channel & 0x03);
+	cd = cyy_readb(info, CyMSVR1) & CyDCD;
 	spin_unlock_irqrestore(&cinfo->card_lock, flags);
 
 	return cd;
@@ -3325,9 +3205,9 @@ static int __devinit cy_init_card(struct cyclades_card *cinfo)
 			info->cor3 = 0x08;	/* _very_ small rcv threshold */
 
 			chip_number = channel / CyPORTS_PER_CHIP;
-			info->chip_rev = readb(cinfo->base_addr +
-				      (cy_chip_offset[chip_number] << index) +
-				      (CyGFRCR << index));
+			info->u.cyy.base_addr = cinfo->base_addr +
+				(cy_chip_offset[chip_number] << index);
+			info->chip_rev = cyy_readb(info, CyGFRCR);
 
 			if (info->chip_rev >= CD1400_REV_J) {
 				/* It is a CD1400 rev. J or later */
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index 1eb87a6..bbebef7 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -544,7 +544,7 @@ struct cyclades_port {
 	struct cyclades_card	*card;
 	union {
 		struct {
-			int filler;
+			void __iomem *base_addr;
 		} cyy;
 		struct {
 			struct CH_CTRL __iomem	*ch_ctrl;
-- 
1.6.3.2

