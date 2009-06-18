Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbZFRHn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbZFRHn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758510AbZFRHmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:13 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47389 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbZFRHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 08/13] Char: cyclades, use dtr_rts helpers
Date: Thu, 18 Jun 2009 09:41:43 +0200
Message-Id: <1245310908-27691-8-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Z cards, use tty helpers for dtr_rts.

If we did the same for Y cards, it will cause a deadlock, because
cyy_dtr_rts takes a lock which we already hold.

Instead, we introduce an Y helper expecting card lock to be held.
It may then be called with set/clear masks from other places.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |  280 +++++++++++++---------------------------------
 1 files changed, 79 insertions(+), 201 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 1fca273..bad3010 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -824,6 +824,66 @@ static irqreturn_t cyy_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }				/* cyy_interrupt */
 
+static void cyy_change_rts_dtr(struct cyclades_port *info, unsigned int set,
+		unsigned int clear)
+{
+	struct cyclades_card *card = info->card;
+	void __iomem *base_addr;
+	int chip, channel, index;
+
+	channel = info->line - card->first_line;
+	chip = channel >> 2;
+	channel &= 0x03;
+	index = card->bus_index;
+	base_addr = card->base_addr + (cy_chip_offset[chip] << index);
+
+	if (set & TIOCM_RTS) {
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		if (info->rtsdtr_inv) {
+			cy_writeb(base_addr + (CyMSVR2 << index), CyDTR);
+		} else {
+			cy_writeb(base_addr + (CyMSVR1 << index), CyRTS);
+		}
+	}
+	if (clear & TIOCM_RTS) {
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		if (info->rtsdtr_inv) {
+			cy_writeb(base_addr + (CyMSVR2 << index), ~CyDTR);
+		} else {
+			cy_writeb(base_addr + (CyMSVR1 << index), ~CyRTS);
+		}
+	}
+	if (set & TIOCM_DTR) {
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		if (info->rtsdtr_inv) {
+			cy_writeb(base_addr + (CyMSVR1 << index), CyRTS);
+		} else {
+			cy_writeb(base_addr + (CyMSVR2 << index), CyDTR);
+		}
+#ifdef CY_DEBUG_DTR
+		printk(KERN_DEBUG "cyc:set_modem_info raising DTR\n");
+		printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
+			readb(base_addr + (CyMSVR1 << index)),
+			readb(base_addr + (CyMSVR2 << index)));
+#endif
+	}
+	if (clear & TIOCM_DTR) {
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		if (info->rtsdtr_inv) {
+			cy_writeb(base_addr + (CyMSVR1 << index), ~CyRTS);
+		} else {
+			cy_writeb(base_addr + (CyMSVR2 << index), ~CyDTR);
+		}
+
+#ifdef CY_DEBUG_DTR
+		printk(KERN_DEBUG "cyc:set_modem_info dropping DTR\n");
+		printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
+			readb(base_addr + (CyMSVR1 << index)),
+			readb(base_addr + (CyMSVR2 << index)));
+#endif
+	}
+}
+
 /***********************************************************/
 /********* End of block of Cyclom-Y specific code **********/
 /******** Start of block of Cyclades-Z specific code *******/
@@ -1289,16 +1349,7 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 		cyy_issue_cmd(base_addr, CyCHAN_CTL | CyENB_RCVR | CyENB_XMTR,
 				index);
 
-		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
-		cy_writeb(base_addr + (CyMSVR1 << index), CyRTS);
-		cy_writeb(base_addr + (CyMSVR2 << index), CyDTR);
-
-#ifdef CY_DEBUG_DTR
-		printk(KERN_DEBUG "cyc:startup raising DTR\n");
-		printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-			readb(base_addr + (CyMSVR1 << index)),
-			readb(base_addr + (CyMSVR2 << index)));
-#endif
+		cyy_change_rts_dtr(info, TIOCM_RTS | TIOCM_DTR, 0);
 
 		cy_writeb(base_addr + (CySRER << index),
 			readb(base_addr + (CySRER << index)) | CyRxData);
@@ -1361,16 +1412,7 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 
 		/* set timeout !!! */
 		/* set RTS and DTR !!! */
-		cy_writel(&ch_ctrl->rs_control, readl(&ch_ctrl->rs_control) |
-				C_RS_RTS | C_RS_DTR);
-		retval = cyz_issue_cmd(card, channel, C_CM_IOCTLM, 0L);
-		if (retval != 0) {
-			printk(KERN_ERR "cyc:startup(3) retval on ttyC%d was "
-				"%x\n", info->line, retval);
-		}
-#ifdef CY_DEBUG_DTR
-		printk(KERN_DEBUG "cyc:startup raising Z DTR\n");
-#endif
+		tty_port_raise_dtr_rts(&info->port);
 
 		/* enable send, recv, modem !!! */
 
@@ -1472,17 +1514,9 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 			info->port.xmit_buf = NULL;
 			free_page((unsigned long)temp);
 		}
-		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
-		if (tty->termios->c_cflag & HUPCL) {
-			cy_writeb(base_addr + (CyMSVR1 << index), ~CyRTS);
-			cy_writeb(base_addr + (CyMSVR2 << index), ~CyDTR);
-#ifdef CY_DEBUG_DTR
-			printk(KERN_DEBUG "cyc shutdown dropping DTR\n");
-			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-				readb(base_addr + (CyMSVR1 << index)),
-				readb(base_addr + (CyMSVR2 << index)));
-#endif
-		}
+		if (tty->termios->c_cflag & HUPCL)
+			cyy_change_rts_dtr(info, 0, TIOCM_RTS | TIOCM_DTR);
+
 		cyy_issue_cmd(base_addr, CyCHAN_CTL | CyDIS_RCVR, index);
 		/* it may be appropriate to clear _XMIT at
 		   some later date (after testing)!!! */
@@ -1491,9 +1525,6 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 		info->port.flags &= ~ASYNC_INITIALIZED;
 		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
-		struct CH_CTRL __iomem *ch_ctrl = info->u.cyz.ch_ctrl;
-		int retval;
-
 #ifdef CY_DEBUG_OPEN
 		printk(KERN_DEBUG "cyc shutdown Z card %d, channel %d, "
 			"base_addr %p\n", card, channel, card->base_addr);
@@ -1511,20 +1542,8 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 			free_page((unsigned long)temp);
 		}
 
-		if (tty->termios->c_cflag & HUPCL) {
-			cy_writel(&ch_ctrl->rs_control,
-				readl(&ch_ctrl->rs_control) &
-					~(C_RS_RTS | C_RS_DTR));
-			retval = cyz_issue_cmd(info->card, channel,
-					C_CM_IOCTLM, 0L);
-			if (retval != 0) {
-				printk(KERN_ERR"cyc:shutdown retval on ttyC%d "
-					"was %x\n", info->line, retval);
-			}
-#ifdef CY_DEBUG_DTR
-			printk(KERN_DEBUG "cyc:shutdown dropping Z DTR\n");
-#endif
-		}
+		if (tty->termios->c_cflag & HUPCL)
+			tty_port_lower_dtr_rts(&info->port);
 
 		set_bit(TTY_IO_ERROR, &tty->flags);
 		info->port.flags &= ~ASYNC_INITIALIZED;
@@ -2272,35 +2291,10 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 				  CyDSR | CyCTS | CyRI | CyDCD);
 		}
 
-		if (i == 0) {	/* baud rate is zero, turn off line */
-			if (info->rtsdtr_inv) {
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  ~CyRTS);
-			} else {
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  ~CyDTR);
-			}
-#ifdef CY_DEBUG_DTR
-			printk(KERN_DEBUG "cyc:set_line_char dropping DTR\n");
-			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-				readb(base_addr + (CyMSVR1 << index)),
-				readb(base_addr + (CyMSVR2 << index)));
-#endif
-		} else {
-			if (info->rtsdtr_inv) {
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  CyRTS);
-			} else {
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  CyDTR);
-			}
-#ifdef CY_DEBUG_DTR
-			printk(KERN_DEBUG "cyc:set_line_char raising DTR\n");
-			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-				readb(base_addr + (CyMSVR1 << index)),
-				readb(base_addr + (CyMSVR2 << index)));
-#endif
-		}
+		if (i == 0)	/* baud rate is zero, turn off line */
+			cyy_change_rts_dtr(info, 0, TIOCM_DTR);
+		else
+			cyy_change_rts_dtr(info, TIOCM_DTR, 0);
 
 		clear_bit(TTY_IO_ERROR, &tty->flags);
 		spin_unlock_irqrestore(&card->card_lock, flags);
@@ -2603,9 +2597,8 @@ cy_tiocmset(struct tty_struct *tty, struct file *file,
 {
 	struct cyclades_port *info = tty->driver_data;
 	struct cyclades_card *card;
-	int chip, channel, index;
 	unsigned long flags;
-	int retval;
+	int channel, retval;
 
 	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
@@ -2613,77 +2606,9 @@ cy_tiocmset(struct tty_struct *tty, struct file *file,
 	card = info->card;
 	channel = (info->line) - (card->first_line);
 	if (!cy_is_Z(card)) {
-		void __iomem *base_addr;
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = card->bus_index;
-		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
-
-		if (set & TIOCM_RTS) {
-			spin_lock_irqsave(&card->card_lock, flags);
-			cy_writeb(base_addr + (CyCAR << index),
-				  (u_char) channel);
-			if (info->rtsdtr_inv) {
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  CyDTR);
-			} else {
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  CyRTS);
-			}
-			spin_unlock_irqrestore(&card->card_lock, flags);
-		}
-		if (clear & TIOCM_RTS) {
-			spin_lock_irqsave(&card->card_lock, flags);
-			cy_writeb(base_addr + (CyCAR << index),
-				  (u_char) channel);
-			if (info->rtsdtr_inv) {
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  ~CyDTR);
-			} else {
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  ~CyRTS);
-			}
-			spin_unlock_irqrestore(&card->card_lock, flags);
-		}
-		if (set & TIOCM_DTR) {
-			spin_lock_irqsave(&card->card_lock, flags);
-			cy_writeb(base_addr + (CyCAR << index),
-				  (u_char) channel);
-			if (info->rtsdtr_inv) {
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  CyRTS);
-			} else {
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  CyDTR);
-			}
-#ifdef CY_DEBUG_DTR
-			printk(KERN_DEBUG "cyc:set_modem_info raising DTR\n");
-			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-				readb(base_addr + (CyMSVR1 << index)),
-				readb(base_addr + (CyMSVR2 << index)));
-#endif
-			spin_unlock_irqrestore(&card->card_lock, flags);
-		}
-		if (clear & TIOCM_DTR) {
-			spin_lock_irqsave(&card->card_lock, flags);
-			cy_writeb(base_addr + (CyCAR << index),
-				  (u_char) channel);
-			if (info->rtsdtr_inv) {
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  ~CyRTS);
-			} else {
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  ~CyDTR);
-			}
-
-#ifdef CY_DEBUG_DTR
-			printk(KERN_DEBUG "cyc:set_modem_info dropping DTR\n");
-			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-				readb(base_addr + (CyMSVR1 << index)),
-				readb(base_addr + (CyMSVR2 << index)));
-#endif
-			spin_unlock_irqrestore(&card->card_lock, flags);
-		}
+		spin_lock_irqsave(&card->card_lock, flags);
+		cyy_change_rts_dtr(info, set, clear);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
 		if (cyz_is_loaded(card)) {
 			struct CH_CTRL __iomem *ch_ctrl = info->u.cyz.ch_ctrl;
@@ -3176,8 +3101,6 @@ static void cy_throttle(struct tty_struct *tty)
 	struct cyclades_port *info = tty->driver_data;
 	struct cyclades_card *card;
 	unsigned long flags;
-	void __iomem *base_addr;
-	int chip, channel, index;
 
 #ifdef CY_DEBUG_THROTTLE
 	char buf[64];
@@ -3199,24 +3122,9 @@ static void cy_throttle(struct tty_struct *tty)
 	}
 
 	if (tty->termios->c_cflag & CRTSCTS) {
-		channel = info->line - card->first_line;
 		if (!cy_is_Z(card)) {
-			chip = channel >> 2;
-			channel &= 0x03;
-			index = card->bus_index;
-			base_addr = card->base_addr +
-				(cy_chip_offset[chip] << index);
-
 			spin_lock_irqsave(&card->card_lock, flags);
-			cy_writeb(base_addr + (CyCAR << index),
-				  (u_char) channel);
-			if (info->rtsdtr_inv) {
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  ~CyDTR);
-			} else {
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  ~CyRTS);
-			}
+			cyy_change_rts_dtr(info, 0, TIOCM_RTS);
 			spin_unlock_irqrestore(&card->card_lock, flags);
 		} else {
 			info->throttle = 1;
@@ -3234,8 +3142,6 @@ static void cy_unthrottle(struct tty_struct *tty)
 	struct cyclades_port *info = tty->driver_data;
 	struct cyclades_card *card;
 	unsigned long flags;
-	void __iomem *base_addr;
-	int chip, channel, index;
 
 #ifdef CY_DEBUG_THROTTLE
 	char buf[64];
@@ -3256,24 +3162,9 @@ static void cy_unthrottle(struct tty_struct *tty)
 
 	if (tty->termios->c_cflag & CRTSCTS) {
 		card = info->card;
-		channel = info->line - card->first_line;
 		if (!cy_is_Z(card)) {
-			chip = channel >> 2;
-			channel &= 0x03;
-			index = card->bus_index;
-			base_addr = card->base_addr +
-				(cy_chip_offset[chip] << index);
-
 			spin_lock_irqsave(&card->card_lock, flags);
-			cy_writeb(base_addr + (CyCAR << index),
-				  (u_char) channel);
-			if (info->rtsdtr_inv) {
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  CyDTR);
-			} else {
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  CyRTS);
-			}
+			cyy_change_rts_dtr(info, TIOCM_RTS, 0);
 			spin_unlock_irqrestore(&card->card_lock, flags);
 		} else {
 			info->throttle = 0;
@@ -3394,24 +3285,11 @@ static void cyy_dtr_rts(struct tty_port *port, int raise)
 	struct cyclades_port *info = container_of(port, struct cyclades_port,
 			port);
 	struct cyclades_card *cinfo = info->card;
-	void __iomem *base = cinfo->base_addr;
 	unsigned long flags;
-	int channel = info->line - cinfo->first_line;
-	int chip = channel >> 2, index = cinfo->bus_index;
-
-	channel &= 0x03;
-	base += cy_chip_offset[chip] << index;
 
 	spin_lock_irqsave(&cinfo->card_lock, flags);
-	cy_writeb(base + (CyCAR << index), (u8)channel);
-	cy_writeb(base + (CyMSVR1 << index), raise ? CyRTS : ~CyRTS);
-	cy_writeb(base + (CyMSVR2 << index), raise ? CyDTR : ~CyDTR);
-#ifdef CY_DEBUG_DTR
-	printk(KERN_DEBUG "%s: raising DTR\n", __func__);
-	printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-			readb(base + (CyMSVR1 << index)),
-			readb(base + (CyMSVR2 << index)));
-#endif
+	cyy_change_rts_dtr(info, raise ? TIOCM_RTS | TIOCM_DTR : 0,
+			raise ? 0 : TIOCM_RTS | TIOCM_DTR);
 	spin_unlock_irqrestore(&cinfo->card_lock, flags);
 }
 
-- 
1.6.3.2

