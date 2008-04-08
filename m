Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYDHQDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYDHQDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYDHQDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:03:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59103 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752793AbYDHQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:03:34 -0400
Date: Tue, 8 Apr 2008 16:58:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty/serial: Lay the foundations for the next set of reworks
Message-ID: <20080408165839.47df4517@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Stop drivers calling their own flush method indirectly, it obfuscates
code and it will change soon anyway
- A few more lock_kernel paths temporarily needed in some driver internal
waiting code
- Remove private put_char method that does a write call for one char - we
have that anyway
- Most but not yet all of the termios copy under lock fixing (some has
other dependancies to follow)
- Note a few locking bugs in drivers found in the process
- Kill remaining [ab]users of TIOCG/SSOFTCAR in the driver, these must go
to fix the termios locking


Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/amiserial.c linux-2.6.25-rc8-mm1/drivers/char/amiserial.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/amiserial.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/amiserial.c	2008-04-08 11:42:51.000000000 +0100
@@ -1505,8 +1506,7 @@
 		rs_wait_until_sent(tty, info->timeout);
 	}
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rs_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
@@ -1539,6 +1539,8 @@
 		return; /* Just in case.... */
 
 	orig_jiffies = jiffies;
+	
+	lock_kernel();
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1579,6 +1581,7 @@
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
+	unlock_kernel();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/cyclades.c linux-2.6.25-rc8-mm1/drivers/char/cyclades.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/cyclades.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/cyclades.c	2008-04-08 11:43:19.000000000 +0100
@@ -2522,6 +2522,7 @@
 		return;		/* Just in case.... */
 
 	orig_jiffies = jiffies;
+	lock_kernel();
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -2573,11 +2574,47 @@
 	}
 	/* Run one more char cycle */
 	msleep_interruptible(jiffies_to_msecs(char_time * 5));
+	unlock_kernel();
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_DEBUG "Clean (jiff=%lu)...done\n", jiffies);
 #endif
 }
 
+static void cy_flush_buffer(struct tty_struct *tty)
+{
+	struct cyclades_port *info = tty->driver_data;
+	struct cyclades_card *card;
+	int channel, retval;
+	unsigned long flags;
+
+#ifdef CY_DEBUG_IO
+	printk(KERN_DEBUG "cyc:cy_flush_buffer ttyC%d\n", info->line);
+#endif
+
+	if (serial_paranoia_check(info, tty->name, "cy_flush_buffer"))
+		return;
+
+	card = info->card;
+	channel = info->line - card->first_line;
+
+	spin_lock_irqsave(&card->card_lock, flags);
+	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
+	spin_unlock_irqrestore(&card->card_lock, flags);
+
+	if (IS_CYC_Z(*card)) {	/* If it is a Z card, flush the on-board
+					   buffers as well */
+		spin_lock_irqsave(&card->card_lock, flags);
+		retval = cyz_issue_cmd(card, channel, C_CM_FLUSH_TX, 0L);
+		if (retval != 0) {
+			printk(KERN_ERR "cyc: flush_buffer retval on ttyC%d "
+				"was %x\n", info->line, retval);
+		}
+		spin_unlock_irqrestore(&card->card_lock, flags);
+	}
+	tty_wakeup(tty);
+}				/* cy_flush_buffer */
+
+
 /*
  * This routine is called when a particular tty device is closed.
  */
@@ -2689,8 +2726,7 @@
 
 	spin_unlock_irqrestore(&card->card_lock, flags);
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	cy_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	spin_lock_irqsave(&card->card_lock, flags);
 
@@ -2882,6 +2919,7 @@
 		int char_count;
 		__u32 tx_put, tx_get, tx_bufsize;
 
+		lock_kernel();
 		firm_id = card->base_addr + ID_ADDRESS;
 		zfw_ctrl = card->base_addr +
 			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
@@ -2899,6 +2937,7 @@
 		printk(KERN_DEBUG "cyc:cy_chars_in_buffer ttyC%d %d\n",
 			info->line, info->xmit_cnt + char_count);
 #endif
+		unlock_kernel();
 		return info->xmit_cnt + char_count;
 	}
 #endif				/* Z_EXT_CHARS_IN_BUFFER */
@@ -4281,40 +4320,6 @@
 	}
 }				/* cy_start */
 
-static void cy_flush_buffer(struct tty_struct *tty)
-{
-	struct cyclades_port *info = tty->driver_data;
-	struct cyclades_card *card;
-	int channel, retval;
-	unsigned long flags;
-
-#ifdef CY_DEBUG_IO
-	printk(KERN_DEBUG "cyc:cy_flush_buffer ttyC%d\n", info->line);
-#endif
-
-	if (serial_paranoia_check(info, tty->name, "cy_flush_buffer"))
-		return;
-
-	card = info->card;
-	channel = info->line - card->first_line;
-
-	spin_lock_irqsave(&card->card_lock, flags);
-	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-	spin_unlock_irqrestore(&card->card_lock, flags);
-
-	if (IS_CYC_Z(*card)) {	/* If it is a Z card, flush the on-board
-					   buffers as well */
-		spin_lock_irqsave(&card->card_lock, flags);
-		retval = cyz_issue_cmd(card, channel, C_CM_FLUSH_TX, 0L);
-		if (retval != 0) {
-			printk(KERN_ERR "cyc: flush_buffer retval on ttyC%d "
-				"was %x\n", info->line, retval);
-		}
-		spin_unlock_irqrestore(&card->card_lock, flags);
-	}
-	tty_wakeup(tty);
-}				/* cy_flush_buffer */
-
 /*
  * cy_hangup() --- called by tty_hangup() when a hangup is signaled.
  */
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/epca.c linux-2.6.25-rc8-mm1/drivers/char/epca.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/epca.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/epca.c	2008-04-08 11:43:26.000000000 +0100
@@ -157,7 +157,6 @@
 static void pc_close(struct tty_struct *, struct file *);
 static void shutdown(struct channel *);
 static void pc_hangup(struct tty_struct *);
-static void pc_put_char(struct tty_struct *, unsigned char);
 static int pc_write_room(struct tty_struct *);
 static int pc_chars_in_buffer(struct tty_struct *);
 static void pc_flush_buffer(struct tty_struct *);
@@ -459,8 +458,7 @@
 			setup_empty_event(tty, ch);
 			tty_wait_until_sent(tty, 3000); /* 30 seconds timeout */
 		}
-		if (tty->driver->flush_buffer)
-			tty->driver->flush_buffer(tty);
+		pc_flush_buffer(tty);
 
 		tty_ldisc_flush(tty);
 		shutdown(ch);
@@ -532,8 +530,7 @@
 	if ((ch = verifyChannel(tty)) != NULL) {
 		unsigned long flags;
 
-		if (tty->driver->flush_buffer)
-			tty->driver->flush_buffer(tty);
+		pc_flush_buffer(tty);
 		tty_ldisc_flush(tty);
 		shutdown(ch);
 
@@ -645,11 +642,6 @@
 	return amountCopied;
 }
 
-static void pc_put_char(struct tty_struct *tty, unsigned char c)
-{
-	pc_write(tty, &c, 1);
-}
-
 static int pc_write_room(struct tty_struct *tty)
 {
 	int remain;
@@ -1035,7 +1027,6 @@
 	.flush_buffer = pc_flush_buffer,
 	.chars_in_buffer = pc_chars_in_buffer,
 	.flush_chars = pc_flush_chars,
-	.put_char = pc_put_char,
 	.ioctl = pc_ioctl,
 	.set_termios = pc_set_termios,
 	.stop = pc_stop,
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/esp.c linux-2.6.25-rc8-mm1/drivers/char/esp.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/esp.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/esp.c	2008-04-08 11:43:34.000000000 +0100
@@ -1994,8 +1997,7 @@
 		rs_wait_until_sent(tty, info->timeout);
 	}
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rs_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
 	info->tty = NULL;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/generic_serial.c linux-2.6.25-rc8-mm1/drivers/char/generic_serial.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/generic_serial.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/generic_serial.c	2008-04-08 11:43:42.000000000 +0100
@@ -587,8 +588,7 @@
 
 	port->flags &= ~GS_ACTIVE;
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	gs_flush_buffer(tty);
 
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/isicom.c linux-2.6.25-rc8-mm1/drivers/char/isicom.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/isicom.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/isicom.c	2008-04-08 11:43:50.000000000 +0100
@@ -1012,6 +1012,22 @@
 	}
 }
 
+static void isicom_flush_buffer(struct tty_struct *tty)
+{
+	struct isi_port *port = tty->driver_data;
+	struct isi_board *card = port->card;
+	unsigned long flags;
+
+	if (isicom_paranoia_check(port, tty->name, "isicom_flush_buffer"))
+		return;
+
+	spin_lock_irqsave(&card->card_lock, flags);
+	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
+	spin_unlock_irqrestore(&card->card_lock, flags);
+
+	tty_wakeup(tty);
+}
+
 static void isicom_close(struct tty_struct *tty, struct file *filp)
 {
 	struct isi_port *port = tty->driver_data;
@@ -1065,8 +1081,7 @@
 	isicom_shutdown_port(port);
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	isicom_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	spin_lock_irqsave(&card->card_lock, flags);
@@ -1447,22 +1463,6 @@
 	wake_up_interruptible(&port->open_wait);
 }
 
-/* flush_buffer et all */
-static void isicom_flush_buffer(struct tty_struct *tty)
-{
-	struct isi_port *port = tty->driver_data;
-	struct isi_board *card = port->card;
-	unsigned long flags;
-
-	if (isicom_paranoia_check(port, tty->name, "isicom_flush_buffer"))
-		return;
-
-	spin_lock_irqsave(&card->card_lock, flags);
-	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	spin_unlock_irqrestore(&card->card_lock, flags);
-
-	tty_wakeup(tty);
-}
 
 /*
  * Driver init and deinit functions
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/moxa.c linux-2.6.25-rc8-mm1/drivers/char/moxa.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/moxa.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/moxa.c	2008-04-08 11:44:00.000000000 +0100
@@ -1280,6 +1280,7 @@
 	 */
 	if (ch == NULL)
 		return 0;
+	lock_kernel();
 	chars = MoxaPortTxQueue(ch);
 	if (chars) {
 		/*
@@ -1289,6 +1290,7 @@
 		if (!(ch->statusflags & EMPTYWAIT))
 			moxa_setup_empty_event(tty);
 	}
+	unlock_kernel();
 	return chars;
 }
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/mxser.c linux-2.6.25-rc8-mm1/drivers/char/mxser.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/mxser.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/mxser.c	2008-04-08 11:44:00.000000000 +0100
@@ -1125,6 +1125,27 @@
 	return 0;
 }
 
+static void mxser_flush_buffer(struct tty_struct *tty)
+{
+	struct mxser_port *info = tty->driver_data;
+	char fcr;
+	unsigned long flags;
+
+
+	spin_lock_irqsave(&info->slock, flags);
+	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
+
+	fcr = inb(info->ioaddr + UART_FCR);
+	outb((fcr | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT),
+		info->ioaddr + UART_FCR);
+	outb(fcr, info->ioaddr + UART_FCR);
+
+	spin_unlock_irqrestore(&info->slock, flags);
+
+	tty_wakeup(tty);
+}
+
+
 /*
  * This routine is called when the serial port gets closed.  First, we
  * wait for the last remaining data to be sent.  Then, we unlink its
@@ -1211,9 +1232,7 @@
 	}
 	mxser_shutdown(info);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
-
+	mxser_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
@@ -1340,26 +1360,6 @@
 	return info->xmit_cnt;
 }
 
-static void mxser_flush_buffer(struct tty_struct *tty)
-{
-	struct mxser_port *info = tty->driver_data;
-	char fcr;
-	unsigned long flags;
-
-
-	spin_lock_irqsave(&info->slock, flags);
-	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-
-	fcr = inb(info->ioaddr + UART_FCR);
-	outb((fcr | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT),
-		info->ioaddr + UART_FCR);
-	outb(fcr, info->ioaddr + UART_FCR);
-
-	spin_unlock_irqrestore(&info->slock, flags);
-
-	tty_wakeup(tty);
-}
-
 /*
  * ------------------------------------------------------------
  * friends of mxser_ioctl()
@@ -2191,6 +2191,7 @@
 		timeout, char_time);
 	printk("jiff=%lu...", jiffies);
 #endif
+	lock_kernel();
 	while (!((lsr = inb(info->ioaddr + UART_LSR)) & UART_LSR_TEMT)) {
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 		printk("lsr = %d (jiff=%lu)...", lsr, jiffies);
@@ -2202,6 +2203,7 @@
 			break;
 	}
 	set_current_state(TASK_RUNNING);
+	unlock_kernel();
 
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/nozomi.c linux-2.6.25-rc8-mm1/drivers/char/nozomi.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/nozomi.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/nozomi.c	2008-04-08 11:44:09.000000000 +0100
@@ -1724,6 +1724,8 @@
 	const struct ctrl_dl *ctrl_dl = &port->ctrl_dl;
 	const struct ctrl_ul *ctrl_ul = &port->ctrl_ul;
 
+	/* Note: these could change under us but it is not clear this
+	   matters if so */
 	return	(ctrl_ul->RTS ? TIOCM_RTS : 0) |
 		(ctrl_ul->DTR ? TIOCM_DTR : 0) |
 		(ctrl_dl->DCD ? TIOCM_CAR : 0) |
@@ -1849,16 +1851,6 @@
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 }
 
-/* just to discard single character writes */
-static void ntty_put_char(struct tty_struct *tty, unsigned char c)
-{
-	/*
-	 * card does not react correct when we write single chars
-	 * to the card, so we discard them
-	 */
-	DBG2("PUT CHAR Function: %c", c);
-}
-
 /* Returns number of chars in buffer, called by tty layer */
 static s32 ntty_chars_in_buffer(struct tty_struct *tty)
 {
@@ -1892,7 +1884,6 @@
 	.unthrottle = ntty_unthrottle,
 	.throttle = ntty_throttle,
 	.chars_in_buffer = ntty_chars_in_buffer,
-	.put_char = ntty_put_char,
 	.tiocmget = ntty_tiocmget,
 	.tiocmset = ntty_tiocmset,
 };
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/pcmcia/synclink_cs.c linux-2.6.25-rc8-mm1/drivers/char/pcmcia/synclink_cs.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/pcmcia/synclink_cs.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/pcmcia/synclink_cs.c	2008-04-08 11:44:22.000000000 +0100
@@ -503,20 +503,9 @@
  * The wrappers maintain line discipline references
  * while calling into the line discipline.
  *
- * ldisc_flush_buffer - flush line discipline receive buffers
  * ldisc_receive_buf  - pass receive data to line discipline
  */
 
-static void ldisc_flush_buffer(struct tty_struct *tty)
-{
-	struct tty_ldisc *ld = tty_ldisc_ref(tty);
-	if (ld) {
-		if (ld->flush_buffer)
-			ld->flush_buffer(tty);
-		tty_ldisc_deref(ld);
-	}
-}
-
 static void ldisc_receive_buf(struct tty_struct *tty,
 			      const __u8 *data, char *flags, int count)
 {
@@ -2469,10 +2459,9 @@
  	if (info->flags & ASYNC_INITIALIZED)
  		mgslpc_wait_until_sent(tty, info->timeout);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	mgslpc_flush_buffer(tty);
 
-	ldisc_flush_buffer(tty);
+	tty_ldisc_flush(tty);
 
 	shutdown(info);
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/riscom8.c linux-2.6.25-rc8-mm1/drivers/char/riscom8.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/riscom8.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/riscom8.c	2008-04-08 11:44:38.000000000 +0100
@@ -1015,6 +1015,24 @@
 	return 0;
 }
 
+static void rc_flush_buffer(struct tty_struct *tty)
+{
+	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
+	unsigned long flags;
+				
+	if (rc_paranoia_check(port, tty->name, "rc_flush_buffer"))
+		return;
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
+	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
+	
+	tty_wakeup(tty);
+}
+
+
 static void rc_close(struct tty_struct * tty, struct file * filp)
 {
 	struct riscom_port *port = (struct riscom_port *) tty->driver_data;
@@ -1078,8 +1096,7 @@
 		}
 	}
 	rc_shutdown_port(bp, port);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rc_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
@@ -1213,23 +1233,6 @@
 	return port->xmit_cnt;
 }
 
-static void rc_flush_buffer(struct tty_struct *tty)
-{
-	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
-	unsigned long flags;
-				
-	if (rc_paranoia_check(port, tty->name, "rc_flush_buffer"))
-		return;
-
-	spin_lock_irqsave(&riscom_lock, flags);
-
-	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-
-	spin_unlock_irqrestore(&riscom_lock, flags);
-	
-	tty_wakeup(tty);
-}
-
 static int rc_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/rocket.c linux-2.6.25-rc8-mm1/drivers/char/rocket.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/rocket.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/rocket.c	2008-04-08 11:44:38.000000000 +0100
@@ -1585,6 +1585,7 @@
 	       jiffies);
 	printk(KERN_INFO "cps=%d...\n", info->cps);
 #endif
+	lock_kernel();
 	while (1) {
 		txcnt = sGetTxCnt(cp);
 		if (!txcnt) {
@@ -1612,6 +1613,7 @@
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
+	unlock_kernel();
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_INFO "txcnt = %d (jiff=%lu)...done\n", txcnt, jiffies);
 #endif
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/serial167.c linux-2.6.25-rc8-mm1/drivers/char/serial167.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/serial167.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/serial167.c	2008-04-08 11:44:38.000000000 +0100
@@ -1674,8 +1675,7 @@
 	if (info->flags & ASYNC_INITIALIZED)
 		tty_wait_until_sent(tty, 3000);	/* 30 seconds timeout */
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	cy_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	info->tty = NULL;
 	if (info->blocked_open) {
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/specialix.c linux-2.6.25-rc8-mm1/drivers/char/specialix.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/specialix.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/specialix.c	2008-04-08 11:44:46.000000000 +0100
@@ -1506,6 +1506,27 @@
 	return 0;
 }
 
+static void sx_flush_buffer(struct tty_struct *tty)
+{
+	struct specialix_port *port = (struct specialix_port *)tty->driver_data;
+	unsigned long flags;
+	struct specialix_board  * bp;
+
+	func_enter();
+
+	if (sx_paranoia_check(port, tty->name, "sx_flush_buffer")) {
+		func_exit();
+		return;
+	}
+
+	bp = port_Board(port);
+	spin_lock_irqsave(&port->lock, flags);
+	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
+	spin_unlock_irqrestore(&port->lock, flags);
+	tty_wakeup(tty);
+
+	func_exit();
+}
 
 static void sx_close(struct tty_struct * tty, struct file * filp)
 {
@@ -1599,8 +1620,7 @@
 	}
 
 	sx_shutdown_port(bp, port);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	sx_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	spin_lock_irqsave(&port->lock, flags);
 	tty->closing = 0;
@@ -1772,28 +1793,6 @@
 }
 
 
-static void sx_flush_buffer(struct tty_struct *tty)
-{
-	struct specialix_port *port = (struct specialix_port *)tty->driver_data;
-	unsigned long flags;
-	struct specialix_board  * bp;
-
-	func_enter();
-
-	if (sx_paranoia_check(port, tty->name, "sx_flush_buffer")) {
-		func_exit();
-		return;
-	}
-
-	bp = port_Board(port);
-	spin_lock_irqsave(&port->lock, flags);
-	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	spin_unlock_irqrestore(&port->lock, flags);
-	tty_wakeup(tty);
-
-	func_exit();
-}
-
 
 static int sx_tiocmget(struct tty_struct *tty, struct file *file)
 {
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/stallion.c linux-2.6.25-rc8-mm1/drivers/char/stallion.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/stallion.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/stallion.c	2008-04-08 11:44:46.000000000 +0100
@@ -875,6 +875,7 @@
 		timeout = HZ;
 	tend = jiffies + timeout;
 
+	lock_kernel();
 	while (stl_datastate(portp)) {
 		if (signal_pending(current))
 			break;
@@ -882,6 +883,7 @@
 		if (time_after_eq(jiffies, tend))
 			break;
 	}
+	unlock_kernel();
 }
 
 /*****************************************************************************/
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/synclink.c linux-2.6.25-rc8-mm1/drivers/char/synclink.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/synclink.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/synclink.c	2008-04-08 11:45:10.000000000 +0100
@@ -3160,8 +3161,7 @@
  	if (info->flags & ASYNC_INITIALIZED)
  		mgsl_wait_until_sent(tty, info->timeout);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	mgsl_flush_buffer(tty);
 
 	tty_ldisc_flush(tty);
 		
@@ -3224,7 +3224,8 @@
 	 * interval should also be less than the timeout.
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
 	 */ 
-       
+
+	lock_kernel();
 	if ( info->params.data_rate ) {
 	       	char_time = info->timeout/(32 * 5);
 		if (!char_time)
@@ -3254,6 +3255,7 @@
 				break;
 		}
 	}
+	unlock_kernel();
       
 exit:
 	if (debug_level >= DEBUG_LEVEL_INFO)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/synclink_gt.c linux-2.6.25-rc8-mm1/drivers/char/synclink_gt.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/synclink_gt.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/synclink_gt.c	2008-04-08 11:45:10.000000000 +0100
@@ -772,8 +772,7 @@
 
  	if (info->flags & ASYNC_INITIALIZED)
  		wait_until_sent(tty, info->timeout);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	shutdown(info);
@@ -968,6 +971,8 @@
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
 	 */
 
+	lock_kernel();
+
 	if (info->params.data_rate) {
 	       	char_time = info->timeout/(32 * 5);
 		if (!char_time)
@@ -985,6 +990,7 @@
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
 			break;
 	}
+	unlock_kernel();
 
 exit:
 	DBGINFO(("%s wait_until_sent exit\n", info->device_name));
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/synclinkmp.c linux-2.6.25-rc8-mm1/drivers/char/synclinkmp.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/synclinkmp.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/synclinkmp.c	2008-04-08 11:45:10.000000000 +0100
@@ -862,8 +862,7 @@
  	if (info->flags & ASYNC_INITIALIZED)
  		wait_until_sent(tty, info->timeout);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	flush_buffer(tty);
 
 	tty_ldisc_flush(tty);
 
@@ -1119,6 +1121,8 @@
 	if (sanity_check(info, tty->name, "wait_until_sent"))
 		return;
 
+	lock_kernel();
+
 	if (!(info->flags & ASYNC_INITIALIZED))
 		goto exit;
 
@@ -1161,6 +1165,7 @@
 	}
 
 exit:
+	unlock_kernel();
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s wait_until_sent() exit\n",
 			 __FILE__,__LINE__, info->device_name );
@@ -1176,6 +1181,7 @@
 	if (sanity_check(info, tty->name, "write_room"))
 		return 0;
 
+	lock_kernel();
 	if (info->params.mode == MGSL_MODE_HDLC) {
 		ret = (info->tx_active) ? 0 : HDLC_MAX_FRAME_SIZE;
 	} else {
@@ -1183,6 +1189,7 @@
 		if (ret < 0)
 			ret = 0;
 	}
+	unlock_kernel();
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s write_room()=%d\n",
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/tty_io.c linux-2.6.25-rc8-mm1/drivers/char/tty_io.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/tty_io.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/tty_io.c	2008-04-08 11:49:52.000000000 +0100
@@ -1204,7 +1204,7 @@
  *	not in the foreground, send a SIGTTOU.  If the signal is blocked or
  *	ignored, go ahead and perform the operation.  (POSIX 7.2)
  *
- *	Locking: ctrl_lock - FIXME: review this
+ *	Locking: ctrl_lock
  */
 
 int tty_check_change(struct tty_struct *tty)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/char/tty_ioctl.c linux-2.6.25-rc8-mm1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/char/tty_ioctl.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/char/tty_ioctl.c	2008-04-08 11:50:56.000000000 +0100
@@ -396,7 +420,7 @@
 static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 {
 	int canon_change;
-	struct ktermios old_termios = *tty->termios;
+	struct ktermios old_termios; 
 	struct tty_ldisc *ld;
 	unsigned long flags;
 
@@ -408,7 +432,7 @@
 	/* FIXME: we need to decide on some locking/ordering semantics
 	   for the set_termios notification eventually */
 	mutex_lock(&tty->termios_mutex);
-
+	old_termios = *tty->termios;
 	*tty->termios = *new_termios;
 	unset_locked_termios(tty->termios, &old_termios, tty->termios_locked);
 	canon_change = (old_termios.c_lflag ^ tty->termios->c_lflag) & ICANON;
@@ -480,7 +504,9 @@
 	if (retval)
 		return retval;
 
+	mutex_lock(&tty->termios_mutex);
 	memcpy(&tmp_termios, tty->termios, sizeof(struct ktermios));
+	mutex_unlock(&tty->termios_mutex);
 
 	if (opt & TERMIOS_TERMIO) {
 		if (user_termio_to_kernel_termios(&tmp_termios,
@@ -666,12 +692,14 @@
 {
 	struct tchars tmp;
 
+	mutex_lock(&tty->termios_mutex);
 	tmp.t_intrc = tty->termios->c_cc[VINTR];
 	tmp.t_quitc = tty->termios->c_cc[VQUIT];
 	tmp.t_startc = tty->termios->c_cc[VSTART];
 	tmp.t_stopc = tty->termios->c_cc[VSTOP];
 	tmp.t_eofc = tty->termios->c_cc[VEOF];
 	tmp.t_brkc = tty->termios->c_cc[VEOL2];	/* what is brkc anyway? */
+	mutex_unlock(&tty->termios_mutex);
 	return copy_to_user(tchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
@@ -681,12 +709,14 @@
 
 	if (copy_from_user(&tmp, tchars, sizeof(tmp)))
 		return -EFAULT;
+	mutex_lock(&tty->termios_mutex);
 	tty->termios->c_cc[VINTR] = tmp.t_intrc;
 	tty->termios->c_cc[VQUIT] = tmp.t_quitc;
 	tty->termios->c_cc[VSTART] = tmp.t_startc;
 	tty->termios->c_cc[VSTOP] = tmp.t_stopc;
 	tty->termios->c_cc[VEOF] = tmp.t_eofc;
 	tty->termios->c_cc[VEOL2] = tmp.t_brkc;	/* what is brkc anyway? */
+	mutex_unlock(&tty->termios_mutex);
 	return 0;
 }
 #endif
@@ -696,6 +726,7 @@
 {
 	struct ltchars tmp;
 
+	mutex_lock(&tty->termios_mutex);
 	tmp.t_suspc = tty->termios->c_cc[VSUSP];
 	/* what is dsuspc anyway? */
 	tmp.t_dsuspc = tty->termios->c_cc[VSUSP];
@@ -704,6 +735,7 @@
 	tmp.t_flushc = tty->termios->c_cc[VEOL2];
 	tmp.t_werasc = tty->termios->c_cc[VWERASE];
 	tmp.t_lnextc = tty->termios->c_cc[VLNEXT];
+	mutex_unlock(&tty->termios_mutex);
 	return copy_to_user(ltchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
@@ -714,6 +746,7 @@
 	if (copy_from_user(&tmp, ltchars, sizeof(tmp)))
 		return -EFAULT;
 
+	mutex_lock(&tty->termios_mutex);
 	tty->termios->c_cc[VSUSP] = tmp.t_suspc;
 	/* what is dsuspc anyway? */
 	tty->termios->c_cc[VEOL2] = tmp.t_dsuspc;
@@ -722,6 +755,7 @@
 	tty->termios->c_cc[VEOL2] = tmp.t_flushc;
 	tty->termios->c_cc[VWERASE] = tmp.t_werasc;
 	tty->termios->c_cc[VLNEXT] = tmp.t_lnextc;
+	mutex_unlock(&tty->termios_mutex);
 	return 0;
 }
 #endif
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/isdn/i4l/isdn_tty.c linux-2.6.25-rc8-mm1/drivers/isdn/i4l/isdn_tty.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/isdn/i4l/isdn_tty.c	2008-04-08 11:34:51.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/isdn/i4l/isdn_tty.c	2008-04-08 11:53:15.000000000 +0100
@@ -1708,9 +1708,7 @@
 	}
 	dev->modempoll--;
 	isdn_tty_shutdown(info);
-	
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	isdn_tty_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	info->tty = NULL;
 	info->ncarrier = 0;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/serial/68328serial.c linux-2.6.25-rc8-mm1/drivers/serial/68328serial.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/serial/68328serial.c	2008-04-08 11:34:40.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/serial/68328serial.c	2008-04-08 11:56:00.000000000 +0100
@@ -1017,18 +1018,6 @@
 			tty_wait_until_sent(tty, 0);
 			send_break(info, arg ? arg*(100) : 250);
 			return 0;
-		case TIOCGSOFTCAR:
-			error = put_user(C_CLOCAL(tty) ? 1 : 0,
-				    (unsigned long *) arg);
-			if (error)
-				return error;
-			return 0;
-		case TIOCSSOFTCAR:
-			get_user(arg, (unsigned long *) arg);
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			return 0;
 		case TIOCGSERIAL:
 			if (access_ok(VERIFY_WRITE, (void *) arg,
 						sizeof(struct serial_struct)))
@@ -1061,9 +1050,6 @@
 {
 	struct m68k_serial *info = (struct m68k_serial *)tty->driver_data;
 
-	if (tty->termios->c_cflag == old_termios->c_cflag)
-		return;
-
 	change_speed(info);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
@@ -1140,8 +1126,7 @@
 	uart->ustcnt &= ~(USTCNT_RXEN | USTCNT_RX_INTR_MASK);
 
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rs_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/serial/68360serial.c linux-2.6.25-rc8-mm1/drivers/serial/68360serial.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/serial/68360serial.c	2008-04-08 11:34:52.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/serial/68360serial.c	2008-04-08 11:56:00.000000000 +0100
@@ -1435,18 +1436,6 @@
 				return retval;
 			end_break(info);
 			return 0;
-		case TIOCGSOFTCAR:
-			/* return put_user(C_CLOCAL(tty) ? 1 : 0, (int *) arg); */
-			put_user(C_CLOCAL(tty) ? 1 : 0, (int *) arg);
-			return 0;
-		case TIOCSSOFTCAR:
-			error = get_user(arg, (unsigned int *) arg); 
-			if (error)
-				return error;
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			return 0;
 #ifdef maybe
 		case TIOCSERGETLSR: /* Get line status register */
 			return get_lsr_info(info, (unsigned int *) arg);
@@ -1664,8 +1653,7 @@
 		rs_360_wait_until_sent(tty, info->timeout);
 	}
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rs_360_flush_buffer(tty);
 	tty_ldisc_flush(tty);		
 	tty->closing = 0;
 	info->event = 0;
@@ -1716,6 +1704,7 @@
 	printk("jiff=%lu...", jiffies);
 #endif
 
+	lock_kernel();
 	/* We go through the loop at least once because we can't tell
 	 * exactly when the last character exits the shifter.  There can
 	 * be at least two characters waiting to be sent after the buffers
@@ -1744,6 +1733,7 @@
 			bdp--;
 	} while (bdp->status & BD_SC_READY);
 	current->state = TASK_RUNNING;
+	unlock_kernel();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/serial/crisv10.c linux-2.6.25-rc8-mm1/drivers/serial/crisv10.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/serial/crisv10.c	2008-04-08 11:34:52.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/serial/crisv10.c	2008-04-08 11:56:13.000000000 +0100
@@ -3581,9 +3581,10 @@
 		unsigned int set, unsigned int clear)
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
+	unsigned long flags;
 
-	lock_kernel();
-
+	local_irq_save(flags);
+	
 	if (clear & TIOCM_RTS)
 		e100_rts(info, 0);
 	if (clear & TIOCM_DTR)
@@ -3604,7 +3605,7 @@
 	if (set & TIOCM_CD)
 		e100_cd_out(info, 1);
 
-	unlock_kernel();
+	local_irq_restore(flags);
 	return 0;
 }
 
@@ -3613,8 +3614,10 @@
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned int result;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
-	lock_kernel();
 	result =
 		(!E100_RTS_GET(info) ? TIOCM_RTS : 0)
 		| (!E100_DTR_GET(info) ? TIOCM_DTR : 0)
@@ -3623,7 +3626,7 @@
 		| (!E100_CD_GET(info) ? TIOCM_CAR : 0)
 		| (!E100_CTS_GET(info) ? TIOCM_CTS : 0);
 
-	unlock_kernel();
+	local_irq_restore(flags);
 
 #ifdef SERIAL_DEBUG_IO
 	printk(KERN_DEBUG "ser%i: modem state: %i 0x%08X\n",
@@ -3702,10 +3705,6 @@
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 
-	if (tty->termios->c_cflag == old_termios->c_cflag &&
-	    tty->termios->c_iflag == old_termios->c_iflag)
-		return;
-
 	change_speed(info);
 
 	/* Handle turning off CRTSCTS */
@@ -3808,10 +3807,8 @@
 #endif
 
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
-	if (tty->ldisc.flush_buffer)
-		tty->ldisc.flush_buffer(tty);
+	rs_flush_buffer(tty);
+	tty_ldisc_flush_buffer(tty);
 	tty->closing = 0;
 	info->event = 0;
 	info->tty = 0;
@@ -3885,6 +3882,7 @@
 	 * Check R_DMA_CHx_STATUS bit 0-6=number of available bytes in FIFO
 	 * R_DMA_CHx_HWSW bit 31-16=nbr of bytes left in DMA buffer (0=64k)
 	 */
+	lock_kernel();
 	orig_jiffies = jiffies;
 	while (info->xmit.head != info->xmit.tail || /* More in send queue */
 	       (*info->ostatusadr & 0x007f) ||  /* more in FIFO */
@@ -3901,6 +3899,7 @@
 			curr_time_usec - info->last_tx_active_usec;
 	}
 	set_current_state(TASK_RUNNING);
+	unlock_kernel();
 }
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/serial/mcfserial.c linux-2.6.25-rc8-mm1/drivers/serial/mcfserial.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/serial/mcfserial.c	2008-04-08 11:33:59.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/serial/mcfserial.c	2008-04-08 11:56:13.000000000 +0100
@@ -1073,18 +1073,6 @@
 			tty_wait_until_sent(tty, 0);
 			send_break(info, arg ? arg*(HZ/10) : HZ/4);
 			return 0;
-		case TIOCGSOFTCAR:
-			error = put_user(C_CLOCAL(tty) ? 1 : 0,
-				    (unsigned long *) arg);
-			if (error)
-				return error;
-			return 0;
-		case TIOCSSOFTCAR:
-			get_user(arg, (unsigned long *) arg);
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			return 0;
 		case TIOCGSERIAL:
 			if (access_ok(VERIFY_WRITE, (void *) arg,
 						sizeof(struct serial_struct)))
@@ -1223,8 +1211,7 @@
 	} else
 #endif
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	mcfrs_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	
 	tty->closing = 0;
@@ -1277,6 +1264,8 @@
 	 * Note: we have to use pretty tight timings here to satisfy
 	 * the NIST-PCTS.
 	 */
+	lock_kernel();
+
 	fifo_time = (MCF5272_FIFO_SIZE * HZ * 10) / info->baud;
 	char_time = fifo_time / 5;
 	if (char_time == 0)
@@ -1313,6 +1302,7 @@
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
 			break;
 	}
+	unlock_kernel();
 #else
 	/*
 	 * For the other coldfire models, assume all data has been sent
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm1/drivers/serial/netx-serial.c linux-2.6.25-rc8-mm1/drivers/serial/netx-serial.c
--- linux.vanilla-2.6.25-rc8-mm1/drivers/serial/netx-serial.c	2008-04-08 11:33:30.000000000 +0100
+++ linux-2.6.25-rc8-mm1/drivers/serial/netx-serial.c	2008-04-08 11:56:13.000000000 +0100
@@ -287,6 +287,7 @@
 {
 	unsigned int val;
 
+	/* FIXME: Locking needed ? */
 	if (mctrl & TIOCM_RTS) {
 		val = readl(port->membase + UART_RTS_CR);
 		writel(val | RTS_CR_RTS, port->membase + UART_RTS_CR);
