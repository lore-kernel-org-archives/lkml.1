Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbXEDNPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbXEDNPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXEDNPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:15:35 -0400
Received: from mta16.mail.adelphia.net ([68.168.78.211]:59439 "EHLO
	mta16.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbXEDNPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:15:34 -0400
Date: Fri, 4 May 2007 08:15:32 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: [PATCH] Serial 8250: Handle saving the clear-on-read bits from the LSR and MSR
Message-ID: <20070504131532.GA12265@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I did think of one other thing: if you clear the MSR delta flags while
polling the serial console, you need to call the routine to check the
modem status since the interrupt will not happen.  So here's the
patch...

Subject: Serial 8250: Handle saving the clear-on-read bits from the LSR and MSR

Reading the LSR clears the break, parity, frame error, and overrun
bits in the 8250 chip, but these are not being saved in all places
that read the LSR.  Same goes for the MSR delta bits.  Save the LSR
bits off whenever the lsr is read so they can be handled later in the
receive routine.  Save the MSR bits to be handled in the modem status
routine.

Also, clear the stored bits and clear the interrupt registers before
enabling interrupts, to avoid handling old values of the stored bits
in the interrupt routines.

Signed-off-by: Corey Minyard <minyard@acm.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>

 drivers/serial/8250.c      |   85 +++++++++++++++++++++++++++++----------------
 include/linux/serial_reg.h |    1 
 2 files changed, 57 insertions(+), 29 deletions(-)

Index: linux-2.6.21/drivers/serial/8250.c
===================================================================
--- linux-2.6.21.orig/drivers/serial/8250.c
+++ linux-2.6.21/drivers/serial/8250.c
@@ -129,7 +129,16 @@ struct uart_8250_port {
 	unsigned char		mcr;
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
-	unsigned char		lsr_break_flag;
+
+	/*
+	 * Some bits in registers are cleared on a read, so they must
+	 * be saved whenever the register is read but the bits will not
+	 * be immediately processed.
+	 */
+#define LSR_SAVE_FLAGS UART_LSR_BRK_ERROR_BITS
+	unsigned char		lsr_saved_flags;
+#define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
+	unsigned char		msr_saved_flags;
 
 	/*
 	 * We provide a per-port pm hook.
@@ -1159,6 +1168,7 @@ static void serial8250_start_tx(struct u
 		if (up->bugs & UART_BUG_TXEN) {
 			unsigned char lsr, iir;
 			lsr = serial_in(up, UART_LSR);
+			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 			iir = serial_in(up, UART_IIR);
 			if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT)
 				transmit_chars(up);
@@ -1208,18 +1218,10 @@ receive_chars(struct uart_8250_port *up,
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
 
-#ifdef CONFIG_SERIAL_8250_CONSOLE
-		/*
-		 * Recover the break flag from console xmit
-		 */
-		if (up->port.line == up->port.cons->index) {
-			lsr |= up->lsr_break_flag;
-			up->lsr_break_flag = 0;
-		}
-#endif
+		lsr |= up->lsr_saved_flags;
+		up->lsr_saved_flags = 0;
 
-		if (unlikely(lsr & (UART_LSR_BI | UART_LSR_PE |
-				    UART_LSR_FE | UART_LSR_OE))) {
+		if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
 			/*
 			 * For statistics only
 			 */
@@ -1310,6 +1312,8 @@ static unsigned int check_modem_status(s
 {
 	unsigned int status = serial_in(up, UART_MSR);
 
+	status |= up->msr_saved_flags;
+	up->msr_saved_flags = 0;
 	if (status & UART_MSR_ANY_DELTA && up->ier & UART_IER_MSI &&
 	    up->port.info != NULL) {
 		if (status & UART_MSR_TERI)
@@ -1496,7 +1500,8 @@ static void serial8250_timeout(unsigned 
 static void serial8250_backup_timeout(unsigned long data)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)data;
-	unsigned int iir, ier = 0;
+	unsigned int iir, ier = 0, lsr;
+	unsigned long flags;
 
 	/*
 	 * Must disable interrupts or else we risk racing with the interrupt
@@ -1515,9 +1520,13 @@ static void serial8250_backup_timeout(un
 	 * the "Diva" UART used on the management processor on many HP
 	 * ia64 and parisc boxes.
 	 */
+	spin_lock_irqsave(&up->port.lock, flags);
+	lsr = serial_in(up, UART_LSR);
+	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+	spin_unlock_irqrestore(&up->port.lock, flags);
 	if ((iir & UART_IIR_NO_INT) && (up->ier & UART_IER_THRI) &&
 	    (!uart_circ_empty(&up->port.info->xmit) || up->port.x_char) &&
-	    (serial_in(up, UART_LSR) & UART_LSR_THRE)) {
+	    (lsr & UART_LSR_THRE)) {
 		iir &= ~(UART_IIR_ID | UART_IIR_NO_INT);
 		iir |= UART_IIR_THRI;
 	}
@@ -1536,13 +1545,14 @@ static unsigned int serial8250_tx_empty(
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 	unsigned long flags;
-	unsigned int ret;
+	unsigned int lsr;
 
 	spin_lock_irqsave(&up->port.lock, flags);
-	ret = serial_in(up, UART_LSR) & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	lsr = serial_in(up, UART_LSR);
+	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	return ret;
+	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
@@ -1613,8 +1623,7 @@ static inline void wait_for_xmitr(struct
 	do {
 		status = serial_in(up, UART_LSR);
 
-		if (status & UART_LSR_BI)
-			up->lsr_break_flag = UART_LSR_BI;
+		up->lsr_saved_flags |= status & LSR_SAVE_FLAGS;
 
 		if (--tmout == 0)
 			break;
@@ -1623,8 +1632,12 @@ static inline void wait_for_xmitr(struct
 
 	/* Wait up to 1s for flow control if necessary */
 	if (up->port.flags & UPF_CONS_FLOW) {
-		tmout = 1000000;
-		while (!(serial_in(up, UART_MSR) & UART_MSR_CTS) && --tmout) {
+		unsigned int tmout;
+		for (tmout = 1000000; tmout; tmout--) {
+			unsigned int msr = serial_in(up, UART_MSR);
+			up->msr_saved_flags |= msr & MSR_SAVE_FLAGS;
+			if (msr & UART_MSR_CTS)
+				break;
 			udelay(1);
 			touch_nmi_watchdog();
 		}
@@ -1794,6 +1807,18 @@ static int serial8250_startup(struct uar
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
 	/*
+	 * Clear the interrupt registers again for luck, and clear the
+	 * saved flags to avoid getting false values from polling
+	 * routines or the previous session.
+	 */
+	(void) serial_inp(up, UART_LSR);
+	(void) serial_inp(up, UART_RX);
+	(void) serial_inp(up, UART_IIR);
+	(void) serial_inp(up, UART_MSR);
+	up->lsr_saved_flags = 0;
+	up->msr_saved_flags = 0;
+
+	/*
 	 * Finally, enable interrupts.  Note: Modem status interrupts
 	 * are set via set_termios(), which will be occurring imminently
 	 * anyway, so we don't enable them here.
@@ -1811,14 +1836,6 @@ static int serial8250_startup(struct uar
 		(void) inb_p(icp);
 	}
 
-	/*
-	 * And clear the interrupt registers again for luck.
-	 */
-	(void) serial_inp(up, UART_LSR);
-	(void) serial_inp(up, UART_RX);
-	(void) serial_inp(up, UART_IIR);
-	(void) serial_inp(up, UART_MSR);
-
 	return 0;
 }
 
@@ -2387,6 +2404,16 @@ serial8250_console_write(struct console 
 	wait_for_xmitr(up, BOTH_EMPTY);
 	serial_out(up, UART_IER, ier);
 
+	/*
+	 *	The receive handling will happen properly because the
+	 *	receive ready bit will still be set; it is not cleared
+	 *	on read.  However, modem control will not, we must
+	 *	call it if we have saved something in the saved flags
+	 *	while processing with interrupts off.
+	 */
+	if (up->msr_saved_flags)
+		check_modem_status(up);
+
 	if (locked)
 		spin_unlock(&up->port.lock);
 	local_irq_restore(flags);
Index: linux-2.6.21/include/linux/serial_reg.h
===================================================================
--- linux-2.6.21.orig/include/linux/serial_reg.h
+++ linux-2.6.21/include/linux/serial_reg.h
@@ -116,6 +116,7 @@
 #define UART_LSR_PE		0x04 /* Parity error indicator */
 #define UART_LSR_OE		0x02 /* Overrun error indicator */
 #define UART_LSR_DR		0x01 /* Receiver data ready */
+#define UART_LSR_BRK_ERROR_BITS	0x1E /* BI, FE, PE, OE bits */
 
 #define UART_MSR	6	/* In:  Modem Status Register */
 #define UART_MSR_DCD		0x80 /* Data Carrier Detect */
