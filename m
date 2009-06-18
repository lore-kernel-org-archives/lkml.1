Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbZFRHoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbZFRHoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbZFRHmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:18 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47392 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZFRHmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:09 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 01/13] Char: cyclades, add tty refcounting
Date: Thu, 18 Jun 2009 09:41:36 +0200
Message-Id: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While this is not problem for Y card handlers (they are protected
by card_lock), Z handlers and other functions may dereference NULL
at any point after hangup/close. Even if (tty == NULL) was already
performed in the handler.

Note that it's not an issue for Y cards just for now. After
switching to tty_port_close_* et al. this will be a problem. So
add refcounting to them all.

Also proc .show doesn't take a tty reference and it should (along
with a ldisc one).

While at it and changing prototypes (adding tty param), prepend
cy_ to functions which don't have it yet.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |  172 +++++++++++++++++++++++++---------------------
 1 files changed, 93 insertions(+), 79 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index f3366d3..de9c1d9 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -849,7 +849,7 @@ MODULE_DEVICE_TABLE(pci, cy_pci_dev_id);
 #endif
 
 static void cy_start(struct tty_struct *);
-static void set_line_char(struct cyclades_port *);
+static void cy_set_line_char(struct cyclades_port *, struct tty_struct *);
 static int cyz_issue_cmd(struct cyclades_card *, __u32, __u8, __u32);
 #ifdef CONFIG_ISA
 static unsigned detect_isa_irq(void __iomem *);
@@ -1010,8 +1010,9 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
 
+	tty = tty_port_tty_get(&info->port);
 	/* if there is nowhere to put the data, discard it */
-	if (info->port.tty == NULL) {
+	if (tty == NULL) {
 		if ((readb(base_addr + (CyRIVR << index)) & CyIVRMask) ==
 				CyIVRRxEx) {	/* exception */
 			data = readb(base_addr + (CyRDSR << index));
@@ -1023,7 +1024,6 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 		goto end;
 	}
 	/* there is an open port for this data */
-	tty = info->port.tty;
 	if ((readb(base_addr + (CyRIVR << index)) & CyIVRMask) ==
 			CyIVRRxEx) {	/* exception */
 		data = readb(base_addr + (CyRDSR << index));
@@ -1040,6 +1040,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 
 		if (data & info->ignore_status_mask) {
 			info->icount.rx++;
+			tty_kref_put(tty);
 			return;
 		}
 		if (tty_buffer_request_room(tty, 1)) {
@@ -1120,6 +1121,7 @@ static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
 		info->idle_stats.recv_idle = jiffies;
 	}
 	tty_schedule_flip(tty);
+	tty_kref_put(tty);
 end:
 	/* end of service */
 	cy_writeb(base_addr + (CyRIR << index), save_xir & 0x3f);
@@ -1130,6 +1132,7 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 		void __iomem *base_addr)
 {
 	struct cyclades_port *info;
+	struct tty_struct *tty;
 	int char_count, index = cinfo->bus_index;
 	u8 save_xir, channel, save_car, outch;
 
@@ -1153,7 +1156,8 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 		goto end;
 	}
 	info = &cinfo->ports[channel + chip * 4];
-	if (info->port.tty == NULL) {
+	tty = tty_port_tty_get(&info->port);
+	if (tty == NULL) {
 		cy_writeb(base_addr + (CySRER << index),
 			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
 		goto end;
@@ -1204,7 +1208,7 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 					~CyTxRdy);
 			goto done;
 		}
-		if (info->port.tty->stopped || info->port.tty->hw_stopped) {
+		if (tty->stopped || tty->hw_stopped) {
 			cy_writeb(base_addr + (CySRER << index),
 				readb(base_addr + (CySRER << index)) &
 					~CyTxRdy);
@@ -1240,7 +1244,8 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 	}
 
 done:
-	tty_wakeup(info->port.tty);
+	tty_wakeup(tty);
+	tty_kref_put(tty);
 end:
 	/* end of service */
 	cy_writeb(base_addr + (CyTIR << index), save_xir & 0x3f);
@@ -1251,6 +1256,7 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 		void __iomem *base_addr)
 {
 	struct cyclades_port *info;
+	struct tty_struct *tty;
 	int index = cinfo->bus_index;
 	u8 save_xir, channel, save_car, mdm_change, mdm_status;
 
@@ -1264,7 +1270,8 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 	mdm_change = readb(base_addr + (CyMISR << index));
 	mdm_status = readb(base_addr + (CyMSVR1 << index));
 
-	if (!info->port.tty)
+	tty = tty_port_tty_get(&info->port);
+	if (!tty)
 		goto end;
 
 	if (mdm_change & CyANY_DELTA) {
@@ -1283,27 +1290,27 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 
 	if ((mdm_change & CyDCD) && (info->port.flags & ASYNC_CHECK_CD)) {
 		if (!(mdm_status & CyDCD)) {
-			tty_hangup(info->port.tty);
+			tty_hangup(tty);
 			info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 		}
 		wake_up_interruptible(&info->port.open_wait);
 	}
 	if ((mdm_change & CyCTS) && (info->port.flags & ASYNC_CTS_FLOW)) {
-		if (info->port.tty->hw_stopped) {
+		if (tty->hw_stopped) {
 			if (mdm_status & CyCTS) {
 				/* cy_start isn't used
 				   because... !!! */
-				info->port.tty->hw_stopped = 0;
+				tty->hw_stopped = 0;
 				cy_writeb(base_addr + (CySRER << index),
 					readb(base_addr + (CySRER << index)) |
 						CyTxRdy);
-				tty_wakeup(info->port.tty);
+				tty_wakeup(tty);
 			}
 		} else {
 			if (!(mdm_status & CyCTS)) {
 				/* cy_stop isn't used
 				   because ... !!! */
-				info->port.tty->hw_stopped = 1;
+				tty->hw_stopped = 1;
 				cy_writeb(base_addr + (CySRER << index),
 					readb(base_addr + (CySRER << index)) &
 						~CyTxRdy);
@@ -1314,6 +1321,7 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 	}
 	if (mdm_change & CyRI) {
 	}*/
+	tty_kref_put(tty);
 end:
 	/* end of service */
 	cy_writeb(base_addr + (CyMIR << index), save_xir & 0x3f);
@@ -1448,11 +1456,10 @@ cyz_issue_cmd(struct cyclades_card *cinfo,
 	return 0;
 }				/* cyz_issue_cmd */
 
-static void cyz_handle_rx(struct cyclades_port *info,
+static void cyz_handle_rx(struct cyclades_port *info, struct tty_struct *tty,
 		struct BUF_CTRL __iomem *buf_ctrl)
 {
 	struct cyclades_card *cinfo = info->card;
-	struct tty_struct *tty = info->port.tty;
 	unsigned int char_count;
 	int len;
 #ifdef BLOCKMOVE
@@ -1541,11 +1548,10 @@ static void cyz_handle_rx(struct cyclades_port *info,
 	}
 }
 
-static void cyz_handle_tx(struct cyclades_port *info,
+static void cyz_handle_tx(struct cyclades_port *info, struct tty_struct *tty,
 		struct BUF_CTRL __iomem *buf_ctrl)
 {
 	struct cyclades_card *cinfo = info->card;
-	struct tty_struct *tty = info->port.tty;
 	u8 data;
 	unsigned int char_count;
 #ifdef BLOCKMOVE
@@ -1641,7 +1647,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 		special_count = 0;
 		delta_count = 0;
 		info = &cinfo->ports[channel];
-		tty = info->port.tty;
+		tty = tty_port_tty_get(&info->port);
 		if (tty == NULL)
 			continue;
 
@@ -1673,7 +1679,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 						C_RS_DCD) {
 					wake_up_interruptible(&info->port.open_wait);
 				} else {
-					tty_hangup(info->port.tty);
+					tty_hangup(tty);
 					wake_up_interruptible(&info->port.open_wait);
 					info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 				}
@@ -1705,7 +1711,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 			printk(KERN_DEBUG "cyz_interrupt: rcvd intr, card %d, "
 					"port %ld\n", info->card, channel);
 #endif
-			cyz_handle_rx(info, buf_ctrl);
+			cyz_handle_rx(info, tty, buf_ctrl);
 			break;
 		case C_CM_TXBEMPTY:
 		case C_CM_TXLOWWM:
@@ -1715,7 +1721,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 			printk(KERN_DEBUG "cyz_interrupt: xmit intr, card %d, "
 					"port %ld\n", info->card, channel);
 #endif
-			cyz_handle_tx(info, buf_ctrl);
+			cyz_handle_tx(info, tty, buf_ctrl);
 			break;
 #endif				/* CONFIG_CYZ_INTR */
 		case C_CM_FATAL:
@@ -1728,6 +1734,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 			wake_up_interruptible(&info->delta_msr_wait);
 		if (special_count)
 			tty_schedule_flip(tty);
+		tty_kref_put(tty);
 	}
 }
 
@@ -1773,7 +1780,6 @@ static void cyz_poll(unsigned long arg)
 {
 	struct cyclades_card *cinfo;
 	struct cyclades_port *info;
-	struct tty_struct *tty;
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
 	struct BUF_CTRL __iomem *buf_ctrl;
@@ -1801,13 +1807,19 @@ static void cyz_poll(unsigned long arg)
 		cyz_handle_cmd(cinfo);
 
 		for (port = 0; port < cinfo->nports; port++) {
+			struct tty_struct *tty;
+
 			info = &cinfo->ports[port];
-			tty = info->port.tty;
 			buf_ctrl = &(zfw_ctrl->buf_ctrl[port]);
 
+			tty = tty_port_tty_get(&info->port);
+			/* OK to pass NULL to the handle functions below.
+			   They need to drop the data in that case. */
+
 			if (!info->throttle)
-				cyz_handle_rx(info, buf_ctrl);
-			cyz_handle_tx(info, buf_ctrl);
+				cyz_handle_rx(info, tty, buf_ctrl);
+			cyz_handle_tx(info, tty, buf_ctrl);
+			tty_kref_put(tty);
 		}
 		/* poll every 'cyz_polling_cycle' period */
 		expires = jiffies + cyz_polling_cycle;
@@ -1823,7 +1835,7 @@ static void cyz_poll(unsigned long arg)
 /* This is called whenever a port becomes active;
    interrupts are enabled and DTR & RTS are turned on.
  */
-static int startup(struct cyclades_port *info)
+static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 {
 	struct cyclades_card *card;
 	unsigned long flags;
@@ -1847,8 +1859,7 @@ static int startup(struct cyclades_port *info)
 	}
 
 	if (!info->type) {
-		if (info->port.tty)
-			set_bit(TTY_IO_ERROR, &info->port.tty->flags);
+		set_bit(TTY_IO_ERROR, &tty->flags);
 		free_page(page);
 		goto errout;
 	}
@@ -1860,7 +1871,7 @@ static int startup(struct cyclades_port *info)
 
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
-	set_line_char(info);
+	cy_set_line_char(info, tty);
 
 	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
@@ -1899,8 +1910,7 @@ static int startup(struct cyclades_port *info)
 			readb(base_addr + (CySRER << index)) | CyRxData);
 		info->port.flags |= ASYNC_INITIALIZED;
 
-		if (info->port.tty)
-			clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 		info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 		info->breakon = info->breakoff = 0;
 		memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
@@ -1983,8 +1993,7 @@ static int startup(struct cyclades_port *info)
 		/* enable send, recv, modem !!! */
 
 		info->port.flags |= ASYNC_INITIALIZED;
-		if (info->port.tty)
-			clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 		info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 		info->breakon = info->breakoff = 0;
 		memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
@@ -2046,7 +2055,7 @@ static void start_xmit(struct cyclades_port *info)
  * This routine shuts down a serial port; interrupts are disabled,
  * and DTR is dropped if the hangup on close termio flag is on.
  */
-static void shutdown(struct cyclades_port *info)
+static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 {
 	struct cyclades_card *card;
 	unsigned long flags;
@@ -2082,7 +2091,7 @@ static void shutdown(struct cyclades_port *info)
 			free_page((unsigned long)temp);
 		}
 		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
-		if (!info->port.tty || (info->port.tty->termios->c_cflag & HUPCL)) {
+		if (tty->termios->c_cflag & HUPCL) {
 			cy_writeb(base_addr + (CyMSVR1 << index), ~CyRTS);
 			cy_writeb(base_addr + (CyMSVR2 << index), ~CyDTR);
 #ifdef CY_DEBUG_DTR
@@ -2096,8 +2105,7 @@ static void shutdown(struct cyclades_port *info)
 		/* it may be appropriate to clear _XMIT at
 		   some later date (after testing)!!! */
 
-		if (info->port.tty)
-			set_bit(TTY_IO_ERROR, &info->port.tty->flags);
+		set_bit(TTY_IO_ERROR, &tty->flags);
 		info->port.flags &= ~ASYNC_INITIALIZED;
 		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
@@ -2131,7 +2139,7 @@ static void shutdown(struct cyclades_port *info)
 			free_page((unsigned long)temp);
 		}
 
-		if (!info->port.tty || (info->port.tty->termios->c_cflag & HUPCL)) {
+		if (tty->termios->c_cflag & HUPCL) {
 			cy_writel(&ch_ctrl[channel].rs_control,
 				(__u32)(readl(&ch_ctrl[channel].rs_control) &
 					~(C_RS_RTS | C_RS_DTR)));
@@ -2146,8 +2154,7 @@ static void shutdown(struct cyclades_port *info)
 #endif
 		}
 
-		if (info->port.tty)
-			set_bit(TTY_IO_ERROR, &info->port.tty->flags);
+		set_bit(TTY_IO_ERROR, &tty->flags);
 		info->port.flags &= ~ASYNC_INITIALIZED;
 
 		spin_unlock_irqrestore(&card->card_lock, flags);
@@ -2435,7 +2442,6 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	printk(KERN_DEBUG "cyc:cy_open ttyC%d\n", info->line);
 #endif
 	tty->driver_data = info;
-	info->port.tty = tty;
 	if (serial_paranoia_check(info, tty->name, "cy_open"))
 		return -ENODEV;
 
@@ -2461,7 +2467,7 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	/*
 	 * Start up serial port
 	 */
-	retval = startup(info);
+	retval = cy_startup(info, tty);
 	if (retval)
 		return retval;
 
@@ -2475,6 +2481,7 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	}
 
 	info->throttle = 0;
+	tty_port_tty_set(&info->port, tty);
 
 #ifdef CY_DEBUG_OPEN
 	printk(KERN_DEBUG "cyc:cy_open done\n");
@@ -2704,13 +2711,13 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 	}
 
 	spin_unlock_irqrestore(&card->card_lock, flags);
-	shutdown(info);
+	cy_shutdown(info, tty);
 	cy_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	spin_lock_irqsave(&card->card_lock, flags);
 
 	tty->closing = 0;
-	info->port.tty = NULL;
+	tty_port_tty_set(&info->port, NULL);
 	if (info->port.blocked_open) {
 		spin_unlock_irqrestore(&card->card_lock, flags);
 		if (info->port.close_delay) {
@@ -2956,7 +2963,7 @@ static void cyy_baud_calc(struct cyclades_port *info, __u32 baud)
  * This routine finds or computes the various line characteristics.
  * It used to be called config_setup
  */
-static void set_line_char(struct cyclades_port *info)
+static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 {
 	struct cyclades_card *card;
 	unsigned long flags;
@@ -2966,28 +2973,26 @@ static void set_line_char(struct cyclades_port *info)
 	int baud, baud_rate = 0;
 	int i;
 
-	if (!info->port.tty || !info->port.tty->termios)
+	if (!tty->termios) /* XXX can this happen at all? */
 		return;
 
 	if (info->line == -1)
 		return;
 
-	cflag = info->port.tty->termios->c_cflag;
-	iflag = info->port.tty->termios->c_iflag;
+	cflag = tty->termios->c_cflag;
+	iflag = tty->termios->c_iflag;
 
 	/*
 	 * Set up the tty->alt_speed kludge
 	 */
-	if (info->port.tty) {
-		if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-			info->port.tty->alt_speed = 57600;
-		if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			info->port.tty->alt_speed = 115200;
-		if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
-			info->port.tty->alt_speed = 230400;
-		if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
-			info->port.tty->alt_speed = 460800;
-	}
+	if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		tty->alt_speed = 57600;
+	if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		tty->alt_speed = 115200;
+	if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		tty->alt_speed = 230400;
+	if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		tty->alt_speed = 460800;
 
 	card = info->card;
 	channel = info->line - card->first_line;
@@ -2997,7 +3002,7 @@ static void set_line_char(struct cyclades_port *info)
 		index = card->bus_index;
 
 		/* baud rate */
-		baud = tty_get_baud_rate(info->port.tty);
+		baud = tty_get_baud_rate(tty);
 		if (baud == 38400 && (info->port.flags & ASYNC_SPD_MASK) ==
 				ASYNC_SPD_CUST) {
 			if (info->custom_divisor)
@@ -3122,9 +3127,8 @@ static void set_line_char(struct cyclades_port *info)
 
 		/* set line characteristics  according configuration */
 
-		cy_writeb(base_addr + (CySCHR1 << index),
-			  START_CHAR(info->port.tty));
-		cy_writeb(base_addr + (CySCHR2 << index), STOP_CHAR(info->port.tty));
+		cy_writeb(base_addr + (CySCHR1 << index), START_CHAR(tty));
+		cy_writeb(base_addr + (CySCHR2 << index), STOP_CHAR(tty));
 		cy_writeb(base_addr + (CyCOR1 << index), info->cor1);
 		cy_writeb(base_addr + (CyCOR2 << index), info->cor2);
 		cy_writeb(base_addr + (CyCOR3 << index), info->cor3);
@@ -3140,7 +3144,7 @@ static void set_line_char(struct cyclades_port *info)
 			(info->default_timeout ? info->default_timeout : 0x02));
 		/* 10ms rx timeout */
 
-		if (C_CLOCAL(info->port.tty)) {
+		if (C_CLOCAL(tty)) {
 			/* without modem intr */
 			cy_writeb(base_addr + (CySRER << index),
 				readb(base_addr + (CySRER << index)) | CyMdmCh);
@@ -3203,8 +3207,7 @@ static void set_line_char(struct cyclades_port *info)
 #endif
 		}
 
-		if (info->port.tty)
-			clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 		spin_unlock_irqrestore(&card->card_lock, flags);
 
 	} else {
@@ -3223,7 +3226,7 @@ static void set_line_char(struct cyclades_port *info)
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
 
 		/* baud rate */
-		baud = tty_get_baud_rate(info->port.tty);
+		baud = tty_get_baud_rate(tty);
 		if (baud == 38400 && (info->port.flags & ASYNC_SPD_MASK) ==
 				ASYNC_SPD_CUST) {
 			if (info->custom_divisor)
@@ -3334,8 +3337,7 @@ static void set_line_char(struct cyclades_port *info)
 				"was %x\n", info->line, retval);
 		}
 
-		if (info->port.tty)
-			clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 	}
 }				/* set_line_char */
 
@@ -3364,7 +3366,7 @@ get_serial_info(struct cyclades_port *info,
 }				/* get_serial_info */
 
 static int
-set_serial_info(struct cyclades_port *info,
+cy_set_serial_info(struct cyclades_port *info, struct tty_struct *tty,
 		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
@@ -3402,10 +3404,10 @@ set_serial_info(struct cyclades_port *info,
 
 check_and_exit:
 	if (info->port.flags & ASYNC_INITIALIZED) {
-		set_line_char(info);
+		cy_set_line_char(info, tty);
 		return 0;
 	} else {
-		return startup(info);
+		return cy_startup(info, tty);
 	}
 }				/* set_serial_info */
 
@@ -3954,7 +3956,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 		ret_val = get_serial_info(info, argp);
 		break;
 	case TIOCSSERIAL:
-		ret_val = set_serial_info(info, argp);
+		ret_val = cy_set_serial_info(info, tty, argp);
 		break;
 	case TIOCSERGETLSR:	/* Get line status register */
 		ret_val = get_lsr_info(info, argp);
@@ -4054,7 +4056,7 @@ static void cy_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	printk(KERN_DEBUG "cyc:cy_set_termios ttyC%d\n", info->line);
 #endif
 
-	set_line_char(info);
+	cy_set_line_char(info, tty);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
 			!(tty->termios->c_cflag & CRTSCTS)) {
@@ -4298,13 +4300,13 @@ static void cy_hangup(struct tty_struct *tty)
 		return;
 
 	cy_flush_buffer(tty);
-	shutdown(info);
+	cy_shutdown(info, tty);
 	info->port.count = 0;
 #ifdef CY_DEBUG_COUNT
 	printk(KERN_DEBUG "cyc:cy_hangup (%d): setting count to 0\n",
 		current->pid);
 #endif
-	info->port.tty = NULL;
+	tty_port_tty_set(&info->port, NULL);
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	wake_up_interruptible(&info->port.open_wait);
 }				/* cy_hangup */
@@ -5190,18 +5192,30 @@ static int cyclades_proc_show(struct seq_file *m, void *v)
 		for (j = 0; j < cy_card[i].nports; j++) {
 			info = &cy_card[i].ports[j];
 
-			if (info->port.count)
+			if (info->port.count) {
+				/* XXX is the ldisc num worth this? */
+				struct tty_struct *tty;
+				struct tty_ldisc *ld;
+				int num = 0;
+				tty = tty_port_tty_get(&info->port);
+				if (tty) {
+					ld = tty_ldisc_ref(tty);
+					if (ld) {
+						num = ld->ops->num;
+						tty_ldisc_deref(ld);
+					}
+					tty_kref_put(tty);
+				}
 				seq_printf(m, "%3d %8lu %10lu %8lu "
-					"%10lu %8lu %9lu %6ld\n", info->line,
+					"%10lu %8lu %9lu %6d\n", info->line,
 					(cur_jifs - info->idle_stats.in_use) /
 					HZ, info->idle_stats.xmit_bytes,
 					(cur_jifs - info->idle_stats.xmit_idle)/
 					HZ, info->idle_stats.recv_bytes,
 					(cur_jifs - info->idle_stats.recv_idle)/
 					HZ, info->idle_stats.overruns,
-					/* FIXME: double check locking */
-					(long)info->port.tty->ldisc->ops->num);
-			else
+					num);
+			} else
 				seq_printf(m, "%3d %8lu %10lu %8lu "
 					"%10lu %8lu %9lu %6ld\n",
 					info->line, 0L, 0L, 0L, 0L, 0L, 0L, 0L);
-- 
1.6.3.2

