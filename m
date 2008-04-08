Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYDHKpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYDHKpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYDHKpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:45:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:15621 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYDHKpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=jApQfDlELEtdz+ZbxADDQdL0ciIkEN6pZOorr/5lQF9C8Eo008S7nUydfCeN23X1ILvg0P4Sl6w4ZuSadyaZVF6lwN1Hb1aSg9ddmE1kEGpV+9H6stb0DnU2C0BQUgOJSUrgQT50Vh/hf+OCiJhGhqFf+dYzMeR5YDDM6MI1E4E=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] drivers/char/specialix.c: stop inlining largish static functions
Date: Tue, 8 Apr 2008 12:44:53 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       R.E.Wolff@bitwizard.nl
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ly0+Hj1u0RL5Wex"
Message-Id: <200804081244.53894.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ly0+Hj1u0RL5Wex
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Alan,

drivers/char/specialix.c has unusually large number
of static inline functions - 22.

I looked through them. The file is positively inline-happy.
Inlines with udelay() calls. Inlines with complex loops.
Nested inlines. Rarely called inlines (e.g. with request_region
inside).

This patch removes "inline" from 15 static functions
(regardless of number of callsites - gcc nowadays auto-inlines
statics with one callsite).

Size difference for 32bit x86:
   text    data     bss     dec     hex filename
  21669     204    8780   30653    77bd linux-2.6-ALLYES/drivers/char/specialix.o
  18470     204    8780   27454    6b3e linux-2.6.inline-ALLYES/drivers/char/specialix.o


Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_ly0+Hj1u0RL5Wex
Content-Type: text/x-diff;
  charset="us-ascii";
  name="deinline_specialix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="deinline_specialix.diff"

diff -urp -U 10 linux-2.6/drivers/char/specialix.c linux-2.6.inline/drivers/char/specialix.c
--- linux-2.6/drivers/char/specialix.c	2008-03-30 03:27:43.000000000 +0200
+++ linux-2.6.inline/drivers/char/specialix.c	2008-04-08 12:32:23.000000000 +0200
@@ -190,40 +190,46 @@ static struct specialix_board sx_board[S
 static struct specialix_port sx_port[SX_NBOARD * SX_NPORT];
 
 
 #ifdef SPECIALIX_TIMER
 static struct timer_list missed_irq_timer;
 static irqreturn_t sx_interrupt(int irq, void * dev_id);
 #endif
 
 
 
-static inline int sx_paranoia_check(struct specialix_port const * port,
+#ifdef SPECIALIX_PARANOIA_CHECK
+static int sx_paranoia_check(const struct specialix_port *port,
 				    char *name, const char *routine)
 {
-#ifdef SPECIALIX_PARANOIA_CHECK
-	static const char *badmagic =
+	static const char badmagic[] =
 		KERN_ERR "sx: Warning: bad specialix port magic number for device %s in %s\n";
-	static const char *badinfo =
+	static const char badinfo[] =
 		KERN_ERR "sx: Warning: null specialix port for device %s in %s\n";
 
 	if (!port) {
 		printk(badinfo, name, routine);
 		return 1;
 	}
 	if (port->magic != SPECIALIX_MAGIC) {
 		printk(badmagic, name, routine);
 		return 1;
 	}
-#endif
 	return 0;
 }
+#else
+static inline int sx_paranoia_check(const struct specialix_port *port,
+				    char *name, const char *routine)
+{
+	return 0;
+}
+#endif
 
 
 /*
  *
  *  Service functions for specialix IO8+ driver.
  *
  */
 
 /* Get board number from pointer */
 static inline int board_No (struct specialix_board * bp)
@@ -278,40 +284,40 @@ static inline unsigned char sx_in_off(st
 static inline void sx_out_off(struct specialix_board  * bp, unsigned short reg,
 			  unsigned char val)
 {
 	bp->reg = reg;
 	outb (reg, bp->base + SX_ADDR_REG);
 	outb (val, bp->base + SX_DATA_REG);
 }
 
 
 /* Wait for Channel Command Register ready */
-static inline void sx_wait_CCR(struct specialix_board  * bp)
+static void sx_wait_CCR(struct specialix_board  * bp)
 {
 	unsigned long delay, flags;
 	unsigned char ccr;
 
 	for (delay = SX_CCR_TIMEOUT; delay; delay--) {
 		spin_lock_irqsave(&bp->lock, flags);
 		ccr = sx_in(bp, CD186x_CCR);
 		spin_unlock_irqrestore(&bp->lock, flags);
 		if (!ccr)
 			return;
 		udelay (1);
 	}
 
 	printk(KERN_ERR "sx%d: Timeout waiting for CCR.\n", board_No(bp));
 }
 
 
 /* Wait for Channel Command Register ready */
-static inline void sx_wait_CCR_off(struct specialix_board  * bp)
+static void sx_wait_CCR_off(struct specialix_board  * bp)
 {
 	unsigned long delay;
 	unsigned char crr;
 	unsigned long flags;
 
 	for (delay = SX_CCR_TIMEOUT; delay; delay--) {
 		spin_lock_irqsave(&bp->lock, flags);
 		crr = sx_in_off(bp, CD186x_CCR);
 		spin_unlock_irqrestore(&bp->lock, flags);
 		if (!crr)
@@ -320,29 +326,29 @@ static inline void sx_wait_CCR_off(struc
 	}
 
 	printk(KERN_ERR "sx%d: Timeout waiting for CCR.\n", board_No(bp));
 }
 
 
 /*
  *  specialix IO8+ IO range functions.
  */
 
-static inline int sx_request_io_range(struct specialix_board * bp)
+static int sx_request_io_range(struct specialix_board * bp)
 {
 	return request_region(bp->base,
 		bp->flags & SX_BOARD_IS_PCI ? SX_PCI_IO_SPACE : SX_IO_SPACE,
 		"specialix IO8+") == NULL;
 }
 
 
-static inline void sx_release_io_range(struct specialix_board * bp)
+static void sx_release_io_range(struct specialix_board * bp)
 {
 	release_region(bp->base,
 	               bp->flags&SX_BOARD_IS_PCI?SX_PCI_IO_SPACE:SX_IO_SPACE);
 }
 
 
 /* Set the IRQ using the RTS lines that run to the PAL on the board.... */
 static int sx_set_irq ( struct specialix_board *bp)
 {
 	int virq;
@@ -592,21 +598,21 @@ static int sx_probe(struct specialix_boa
 
 	func_exit();
 	return 0;
 }
 
 /*
  *
  *  Interrupt processing routines.
  * */
 
-static inline struct specialix_port * sx_get_port(struct specialix_board * bp,
+static struct specialix_port * sx_get_port(struct specialix_board * bp,
 					       unsigned char const * what)
 {
 	unsigned char channel;
 	struct specialix_port * port = NULL;
 
 	channel = sx_in(bp, CD186x_GICR) >> GICR_CHAN_OFF;
 	dprintk (SX_DEBUG_CHAN, "channel: %d\n", channel);
 	if (channel < CD186x_NCH) {
 		port = &sx_port[board_No(bp) * SX_NPORT + channel];
 		dprintk (SX_DEBUG_CHAN, "port: %d %p flags: 0x%x\n",board_No(bp) * SX_NPORT + channel,  port, port->flags & ASYNC_INITIALIZED);
@@ -616,21 +622,21 @@ static inline struct specialix_port * sx
 			func_exit();
 			return port;
 		}
 	}
 	printk(KERN_INFO "sx%d: %s interrupt from invalid port %d\n",
 	       board_No(bp), what, channel);
 	return NULL;
 }
 
 
-static inline void sx_receive_exc(struct specialix_board * bp)
+static void sx_receive_exc(struct specialix_board * bp)
 {
 	struct specialix_port *port;
 	struct tty_struct *tty;
 	unsigned char status;
 	unsigned char ch, flag;
 
 	func_enter();
 
 	port = sx_get_port(bp, "Receive");
 	if (!port) {
@@ -688,21 +694,21 @@ static inline void sx_receive_exc(struct
 
 	else
 		flag = TTY_NORMAL;
 
 	if(tty_insert_flip_char(tty, ch, flag))
 		tty_flip_buffer_push(tty);
 	func_exit();
 }
 
 
-static inline void sx_receive(struct specialix_board * bp)
+static void sx_receive(struct specialix_board * bp)
 {
 	struct specialix_port *port;
 	struct tty_struct *tty;
 	unsigned char count;
 
 	func_enter();
 
 	if (!(port = sx_get_port(bp, "Receive"))) {
 		dprintk (SX_DEBUG_RX, "Hmm, couldn't find port.\n");
 		func_exit();
@@ -716,21 +722,21 @@ static inline void sx_receive(struct spe
 
 	tty_buffer_request_room(tty, count);
 
 	while (count--)
 		tty_insert_flip_char(tty, sx_in(bp, CD186x_RDR), TTY_NORMAL);
 	tty_flip_buffer_push(tty);
 	func_exit();
 }
 
 
-static inline void sx_transmit(struct specialix_board * bp)
+static void sx_transmit(struct specialix_board * bp)
 {
 	struct specialix_port *port;
 	struct tty_struct *tty;
 	unsigned char count;
 
 	func_enter();
 	if (!(port = sx_get_port(bp, "Transmit"))) {
 		func_exit();
 		return;
 	}
@@ -794,21 +800,21 @@ static inline void sx_transmit(struct sp
 		port->IER &= ~IER_TXRDY;
 		sx_out(bp, CD186x_IER, port->IER);
 	}
 	if (port->xmit_cnt <= port->wakeup_chars)
  		tty_wakeup(tty);
 
 	func_exit();
 }
 
 
-static inline void sx_check_modem(struct specialix_board * bp)
+static void sx_check_modem(struct specialix_board * bp)
 {
 	struct specialix_port *port;
 	struct tty_struct *tty;
 	unsigned char mcr;
 	int msvr_cd;
 
 	dprintk (SX_DEBUG_SIGNALS, "Modem intr. ");
 	if (!(port = sx_get_port(bp, "Modem")))
 		return;
 
@@ -964,21 +970,21 @@ static void turn_ints_on (struct special
 	}
 	spin_lock_irqsave(&bp->lock, flags);
 	(void) sx_in (bp, 0); /* Turn ON interrupts. */
 	spin_unlock_irqrestore(&bp->lock, flags);
 
 	func_exit();
 }
 
 
 /* Called with disabled interrupts */
-static inline int sx_setup_board(struct specialix_board * bp)
+static int sx_setup_board(struct specialix_board * bp)
 {
 	int error;
 
 	if (bp->flags & SX_BOARD_ACTIVE)
 		return 0;
 
 	if (bp->flags & SX_BOARD_IS_PCI)
 		error = request_irq(bp->irq, sx_interrupt, IRQF_DISABLED | IRQF_SHARED, "specialix IO8+", bp);
 	else
 		error = request_irq(bp->irq, sx_interrupt, IRQF_DISABLED, "specialix IO8+", bp);
@@ -987,21 +993,21 @@ static inline int sx_setup_board(struct 
 		return error;
 
 	turn_ints_on (bp);
 	bp->flags |= SX_BOARD_ACTIVE;
 
 	return 0;
 }
 
 
 /* Called with disabled interrupts */
-static inline void sx_shutdown_board(struct specialix_board *bp)
+static void sx_shutdown_board(struct specialix_board *bp)
 {
 	func_enter();
 
 	if (!(bp->flags & SX_BOARD_ACTIVE)) {
 		func_exit();
 		return;
 	}
 
 	bp->flags &= ~SX_BOARD_ACTIVE;
 
@@ -1882,21 +1888,21 @@ static int sx_tiocmset(struct tty_struct
 	spin_lock_irqsave(&bp->lock, flags);
 	sx_out(bp, CD186x_CAR, port_No(port));
 	sx_out(bp, CD186x_MSVR, port->MSVR);
 	spin_unlock_irqrestore(&bp->lock, flags);
 	spin_unlock_irqrestore(&port->lock, flags);
 	func_exit();
 	return 0;
 }
 
 
-static inline void sx_send_break(struct specialix_port * port, unsigned long length)
+static void sx_send_break(struct specialix_port * port, unsigned long length)
 {
 	struct specialix_board *bp = port_Board(port);
 	unsigned long flags;
 
 	func_enter();
 
 	spin_lock_irqsave (&port->lock, flags);
 	port->break_length = SPECIALIX_TPS / HZ * length;
 	port->COR2 |= COR2_ETC;
 	port->IER  |= IER_TXRDY;
@@ -1909,21 +1915,21 @@ static inline void sx_send_break(struct 
 	sx_wait_CCR(bp);
 	spin_lock_irqsave(&bp->lock, flags);
 	sx_out(bp, CD186x_CCR, CCR_CORCHG2);
 	spin_unlock_irqrestore(&bp->lock, flags);
 	sx_wait_CCR(bp);
 
 	func_exit();
 }
 
 
-static inline int sx_set_serial_info(struct specialix_port * port,
+static int sx_set_serial_info(struct specialix_port * port,
                                      struct serial_struct __user * newinfo)
 {
 	struct serial_struct tmp;
 	struct specialix_board *bp = port_Board(port);
 	int change_speed;
 
 	func_enter();
 	/*
 	if (!access_ok(VERIFY_READ, (void *) newinfo, sizeof(tmp))) {
 		func_exit();
@@ -1971,21 +1977,21 @@ static inline int sx_set_serial_info(str
 		port->custom_divisor = tmp.custom_divisor;
 	}
 	if (change_speed) {
 		sx_change_speed(bp, port);
 	}
 	func_exit();
 	return 0;
 }
 
 
-static inline int sx_get_serial_info(struct specialix_port * port,
+static int sx_get_serial_info(struct specialix_port * port,
 				     struct serial_struct __user *retinfo)
 {
 	struct serial_struct tmp;
 	struct specialix_board *bp = port_Board(port);
 
 	func_enter();
 
 	/*
 	if (!access_ok(VERIFY_WRITE, (void *) retinfo, sizeof(tmp)))
 		return -EFAULT;

--Boundary-00=_ly0+Hj1u0RL5Wex--
