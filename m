Return-Path: <linux-kernel-owner+w=401wt.eu-S1761568AbZFRHnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568AbZFRHnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbZFRHmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:16 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47393 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbZFRHmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:09 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 02/13] Char: cyclades, remove block_til_ready
Date: Thu, 18 Jun 2009 09:41:37 +0200
Message-Id: <1245310908-27691-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a tty_port common instead. This saves lots of .text and makes the
code a lot more readable.

This involves separation of a dtr_rts handling, next patches will use
that to not duplicate the code all over the place.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |  302 +++++++++++++++++------------------------------
 1 files changed, 108 insertions(+), 194 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index de9c1d9..c6709e4 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2171,199 +2171,6 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
  * ------------------------------------------------------------
  */
 
-static int
-block_til_ready(struct tty_struct *tty, struct file *filp,
-		struct cyclades_port *info)
-{
-	DECLARE_WAITQUEUE(wait, current);
-	struct cyclades_card *cinfo;
-	unsigned long flags;
-	int chip, channel, index;
-	int retval;
-	void __iomem *base_addr;
-
-	cinfo = info->card;
-	channel = info->line - cinfo->first_line;
-
-	/*
-	 * If the device is in the middle of being closed, then block
-	 * until it's done, and then try again.
-	 */
-	if (tty_hung_up_p(filp) || (info->port.flags & ASYNC_CLOSING)) {
-		wait_event_interruptible(info->port.close_wait,
-				!(info->port.flags & ASYNC_CLOSING));
-		return (info->port.flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
-	}
-
-	/*
-	 * If non-blocking mode is set, then make the check up front
-	 * and then exit.
-	 */
-	if ((filp->f_flags & O_NONBLOCK) ||
-					(tty->flags & (1 << TTY_IO_ERROR))) {
-		info->port.flags |= ASYNC_NORMAL_ACTIVE;
-		return 0;
-	}
-
-	/*
-	 * Block waiting for the carrier detect and the line to become
-	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, info->port.count is dropped by one, so that
-	 * cy_close() knows when to free things.  We restore it upon
-	 * exit, either normal or abnormal.
-	 */
-	retval = 0;
-	add_wait_queue(&info->port.open_wait, &wait);
-#ifdef CY_DEBUG_OPEN
-	printk(KERN_DEBUG "cyc block_til_ready before block: ttyC%d, "
-		"count = %d\n", info->line, info->port.count);
-#endif
-	spin_lock_irqsave(&cinfo->card_lock, flags);
-	if (!tty_hung_up_p(filp))
-		info->port.count--;
-	spin_unlock_irqrestore(&cinfo->card_lock, flags);
-#ifdef CY_DEBUG_COUNT
-	printk(KERN_DEBUG "cyc block_til_ready: (%d): decrementing count to "
-		"%d\n", current->pid, info->port.count);
-#endif
-	info->port.blocked_open++;
-
-	if (!cy_is_Z(cinfo)) {
-		chip = channel >> 2;
-		channel &= 0x03;
-		index = cinfo->bus_index;
-		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
-
-		while (1) {
-			spin_lock_irqsave(&cinfo->card_lock, flags);
-			if ((tty->termios->c_cflag & CBAUD)) {
-				cy_writeb(base_addr + (CyCAR << index),
-					  (u_char) channel);
-				cy_writeb(base_addr + (CyMSVR1 << index),
-					  CyRTS);
-				cy_writeb(base_addr + (CyMSVR2 << index),
-					  CyDTR);
-#ifdef CY_DEBUG_DTR
-				printk(KERN_DEBUG "cyc:block_til_ready raising "
-					"DTR\n");
-				printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
-					readb(base_addr + (CyMSVR1 << index)),
-					readb(base_addr + (CyMSVR2 << index)));
-#endif
-			}
-			spin_unlock_irqrestore(&cinfo->card_lock, flags);
-
-			set_current_state(TASK_INTERRUPTIBLE);
-			if (tty_hung_up_p(filp) ||
-					!(info->port.flags & ASYNC_INITIALIZED)) {
-				retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-					  -EAGAIN : -ERESTARTSYS);
-				break;
-			}
-
-			spin_lock_irqsave(&cinfo->card_lock, flags);
-			cy_writeb(base_addr + (CyCAR << index),
-				  (u_char) channel);
-			if (!(info->port.flags & ASYNC_CLOSING) && (C_CLOCAL(tty) ||
-					(readb(base_addr +
-						(CyMSVR1 << index)) & CyDCD))) {
-				spin_unlock_irqrestore(&cinfo->card_lock, flags);
-				break;
-			}
-			spin_unlock_irqrestore(&cinfo->card_lock, flags);
-
-			if (signal_pending(current)) {
-				retval = -ERESTARTSYS;
-				break;
-			}
-#ifdef CY_DEBUG_OPEN
-			printk(KERN_DEBUG "cyc block_til_ready blocking: "
-				"ttyC%d, count = %d\n",
-				info->line, info->port.count);
-#endif
-			schedule();
-		}
-	} else {
-		struct FIRM_ID __iomem *firm_id;
-		struct ZFW_CTRL __iomem *zfw_ctrl;
-		struct BOARD_CTRL __iomem *board_ctrl;
-		struct CH_CTRL __iomem *ch_ctrl;
-
-		base_addr = cinfo->base_addr;
-		firm_id = base_addr + ID_ADDRESS;
-		if (!cyz_is_loaded(cinfo)) {
-			__set_current_state(TASK_RUNNING);
-			remove_wait_queue(&info->port.open_wait, &wait);
-			return -EINVAL;
-		}
-
-		zfw_ctrl = base_addr + (readl(&firm_id->zfwctrl_addr)
-								& 0xfffff);
-		board_ctrl = &zfw_ctrl->board_ctrl;
-		ch_ctrl = zfw_ctrl->ch_ctrl;
-
-		while (1) {
-			if ((tty->termios->c_cflag & CBAUD)) {
-				cy_writel(&ch_ctrl[channel].rs_control,
-					readl(&ch_ctrl[channel].rs_control) |
-					C_RS_RTS | C_RS_DTR);
-				retval = cyz_issue_cmd(cinfo,
-					channel, C_CM_IOCTLM, 0L);
-				if (retval != 0) {
-					printk(KERN_ERR "cyc:block_til_ready "
-						"retval on ttyC%d was %x\n",
-						info->line, retval);
-				}
-#ifdef CY_DEBUG_DTR
-				printk(KERN_DEBUG "cyc:block_til_ready raising "
-					"Z DTR\n");
-#endif
-			}
-
-			set_current_state(TASK_INTERRUPTIBLE);
-			if (tty_hung_up_p(filp) ||
-					!(info->port.flags & ASYNC_INITIALIZED)) {
-				retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-					  -EAGAIN : -ERESTARTSYS);
-				break;
-			}
-			if (!(info->port.flags & ASYNC_CLOSING) && (C_CLOCAL(tty) ||
-					(readl(&ch_ctrl[channel].rs_status) &
-						C_RS_DCD))) {
-				break;
-			}
-			if (signal_pending(current)) {
-				retval = -ERESTARTSYS;
-				break;
-			}
-#ifdef CY_DEBUG_OPEN
-			printk(KERN_DEBUG "cyc block_til_ready blocking: "
-				"ttyC%d, count = %d\n",
-				info->line, info->port.count);
-#endif
-			schedule();
-		}
-	}
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&info->port.open_wait, &wait);
-	if (!tty_hung_up_p(filp)) {
-		info->port.count++;
-#ifdef CY_DEBUG_COUNT
-		printk(KERN_DEBUG "cyc:block_til_ready (%d): incrementing "
-			"count to %d\n", current->pid, info->port.count);
-#endif
-	}
-	info->port.blocked_open--;
-#ifdef CY_DEBUG_OPEN
-	printk(KERN_DEBUG "cyc:block_til_ready after blocking: ttyC%d, "
-		"count = %d\n", info->line, info->port.count);
-#endif
-	if (retval)
-		return retval;
-	info->port.flags |= ASYNC_NORMAL_ACTIVE;
-	return 0;
-}				/* block_til_ready */
-
 /*
  * This routine is called whenever a serial port is opened.  It
  * performs the serial-specific initialization for the tty structure.
@@ -2471,7 +2278,7 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	if (retval)
 		return retval;
 
-	retval = block_til_ready(tty, filp, info);
+	retval = tty_port_block_til_ready(&info->port, tty, filp);
 	if (retval) {
 #ifdef CY_DEBUG_OPEN
 		printk(KERN_DEBUG "cyc:cy_open returning after block_til_ready "
@@ -4311,6 +4118,111 @@ static void cy_hangup(struct tty_struct *tty)
 	wake_up_interruptible(&info->port.open_wait);
 }				/* cy_hangup */
 
+static int cyy_carrier_raised(struct tty_port *port)
+{
+	struct cyclades_port *info = container_of(port, struct cyclades_port,
+			port);
+	struct cyclades_card *cinfo = info->card;
+	void __iomem *base = cinfo->base_addr;
+	unsigned long flags;
+	int channel = info->line - cinfo->first_line;
+	int chip = channel >> 2, index = cinfo->bus_index;
+	u32 cd;
+
+	channel &= 0x03;
+	base += cy_chip_offset[chip] << index;
+
+	spin_lock_irqsave(&cinfo->card_lock, flags);
+	cy_writeb(base + (CyCAR << index), (u8)channel);
+	cd = readb(base + (CyMSVR1 << index)) & CyDCD;
+	spin_unlock_irqrestore(&cinfo->card_lock, flags);
+
+	return cd;
+}
+
+static void cyy_dtr_rts(struct tty_port *port, int raise)
+{
+	struct cyclades_port *info = container_of(port, struct cyclades_port,
+			port);
+	struct cyclades_card *cinfo = info->card;
+	void __iomem *base = cinfo->base_addr;
+	unsigned long flags;
+	int channel = info->line - cinfo->first_line;
+	int chip = channel >> 2, index = cinfo->bus_index;
+
+	channel &= 0x03;
+	base += cy_chip_offset[chip] << index;
+
+	spin_lock_irqsave(&cinfo->card_lock, flags);
+	cy_writeb(base + (CyCAR << index), (u8)channel);
+	cy_writeb(base + (CyMSVR1 << index), raise ? CyRTS : ~CyRTS);
+	cy_writeb(base + (CyMSVR2 << index), raise ? CyDTR : ~CyDTR);
+#ifdef CY_DEBUG_DTR
+	printk(KERN_DEBUG "%s: raising DTR\n", __func__);
+	printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
+			readb(base + (CyMSVR1 << index)),
+			readb(base + (CyMSVR2 << index)));
+#endif
+	spin_unlock_irqrestore(&cinfo->card_lock, flags);
+}
+
+static int cyz_carrier_raised(struct tty_port *port)
+{
+	struct cyclades_port *info = container_of(port, struct cyclades_port,
+			port);
+	struct cyclades_card *cinfo = info->card;
+	void __iomem *base = cinfo->base_addr;
+	struct FIRM_ID __iomem *firm_id = base + ID_ADDRESS;
+	struct ZFW_CTRL __iomem *zfw_ctrl;
+	struct CH_CTRL __iomem *ch_ctrl;
+	int channel = info->line - cinfo->first_line;
+
+	zfw_ctrl = base + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
+	ch_ctrl = zfw_ctrl->ch_ctrl;
+
+	return readl(&ch_ctrl[channel].rs_status) & C_RS_DCD;
+}
+
+static void cyz_dtr_rts(struct tty_port *port, int raise)
+{
+	struct cyclades_port *info = container_of(port, struct cyclades_port,
+			port);
+	struct cyclades_card *cinfo = info->card;
+	void __iomem *base = cinfo->base_addr;
+	struct FIRM_ID __iomem *firm_id = base + ID_ADDRESS;
+	struct ZFW_CTRL __iomem *zfw_ctrl;
+	struct CH_CTRL __iomem *ch_ctrl;
+	int ret, channel = info->line - cinfo->first_line;
+	u32 rs;
+
+	zfw_ctrl = base + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
+	ch_ctrl = zfw_ctrl->ch_ctrl;
+
+	rs = readl(&ch_ctrl[channel].rs_control);
+	if (raise)
+		rs |= C_RS_RTS | C_RS_DTR;
+	else
+		rs &= ~(C_RS_RTS | C_RS_DTR);
+	cy_writel(&ch_ctrl[channel].rs_control, rs);
+	ret = cyz_issue_cmd(cinfo, channel, C_CM_IOCTLM, 0L);
+	if (ret != 0)
+		printk(KERN_ERR "%s: retval on ttyC%d was %x\n",
+				__func__, info->line, ret);
+#ifdef CY_DEBUG_DTR
+	printk(KERN_DEBUG "%s: raising Z DTR\n", __func__);
+#endif
+}
+
+static const struct tty_port_operations cyy_port_ops = {
+	.carrier_raised = cyy_carrier_raised,
+	.dtr_rts = cyy_dtr_rts,
+};
+
+static const struct tty_port_operations cyz_port_ops = {
+	.carrier_raised = cyz_carrier_raised,
+	.dtr_rts = cyz_dtr_rts,
+};
+
 /*
  * ---------------------------------------------------------------------
  * cy_init() and friends
@@ -4350,6 +4262,7 @@ static int __devinit cy_init_card(struct cyclades_card *cinfo)
 		init_waitqueue_head(&info->delta_msr_wait);
 
 		if (cy_is_Z(cinfo)) {
+			info->port.ops = &cyz_port_ops;
 			info->type = PORT_STARTECH;
 			if (cinfo->hw_ver == ZO_V1)
 				info->xmit_fifo_size = CYZ_FIFO_SIZE;
@@ -4361,6 +4274,7 @@ static int __devinit cy_init_card(struct cyclades_card *cinfo)
 #endif
 		} else {
 			int index = cinfo->bus_index;
+			info->port.ops = &cyy_port_ops;
 			info->type = PORT_CIRRUS;
 			info->xmit_fifo_size = CyMAX_CHAR_FIFO;
 			info->cor1 = CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
-- 
1.6.3.2

