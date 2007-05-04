Return-Path: <linux-kernel-owner+w=401wt.eu-S1031424AbXEDREb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031424AbXEDREb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031431AbXEDREb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:04:31 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:34957 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031429AbXEDRE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:04:28 -0400
Date: Fri, 04 May 2007 13:04:02 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from the
 LSR and MSR
In-reply-to: <20070504131532.GA12265@localdomain>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Message-id: <200705041304.02618.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070504131532.GA12265@localdomain>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007, Corey Minyard wrote:
>I did think of one other thing: if you clear the MSR delta flags while
>polling the serial console, you need to call the routine to check the
>modem status since the interrupt will not happen.  So here's the
>patch...
>
>Subject: Serial 8250: Handle saving the clear-on-read bits from the LSR and
> MSR
>
I applied this patch because I was curious to see what effect if any it had on 
some serial based acessories I use here, like a cm11 x10 controller with 
heyu, and a belkin ups with its supplied software.

But at first boot, its not 100% operationally safe, but please read on.

1) heyu (the x10 control program) is now stuck in a loop, repeating the last 
command issued, at about 40 second repeat intervals.  AND it is using 90%+ of 
the cpu while it executes each loop, which takes about 7 to 10 seconds each 
time.  heyu is interfacing to the world via /dev/ttyUSB0, through an FTDI 
adapter so I'm not able to make a mental connection here between this patch 
and that effect.

2) HOWEVER!  The belkin upsd daemon, which started being a cpu hog, using 40% 
of the cpu continuously since something in the 2.6.20 to 2.6.21 time frame, 
and this was regardless of whether it was talking through a /dev/ttyUSB# port 
and either a pl2303, or an FTDI adaptor, or direct through /dev/ttyS0, is at 
least for /dev/ttyS0, now operating normally and apparently 100% stable.  So 
I pulled out another FTDI adaptor, and reconfigured the daemon to 
use /dev/ttyUSB1, and that is also operating 100% normally now.

Can someone explain 1) above?  Even odder still, I'd killed and restarted heyu 
several times to no avail before I tried putting upsd on /dev/ttyUSB1, but 
after moving the upsd access from /dev/ttyS0 to /dev/ttyUSB1, then heyu, 
running through /dev/ttyUSB0, is now operating 100% normally.  ???

Does anyone have any idea what kind of bait I should put out to kill this 
nilmerg?  I'm happy, its all working again for a change, but I'll be damned 
if I ain't totally bumfuzzled.  And I wonder if it will survive a reboot...

>Reading the LSR clears the break, parity, frame error, and overrun
>bits in the 8250 chip, but these are not being saved in all places
>that read the LSR.  Same goes for the MSR delta bits.  Save the LSR
>bits off whenever the lsr is read so they can be handled later in the
>receive routine.  Save the MSR bits to be handled in the modem status
>routine.
>
>Also, clear the stored bits and clear the interrupt registers before
>enabling interrupts, to avoid handling old values of the stored bits
>in the interrupt routines.
>
>Signed-off-by: Corey Minyard <minyard@acm.org>
>Cc: Russell King <rmk+lkml@arm.linux.org.uk>
>
> drivers/serial/8250.c      |   85
> +++++++++++++++++++++++++++++---------------- include/linux/serial_reg.h | 
>   1
> 2 files changed, 57 insertions(+), 29 deletions(-)
>
>Index: linux-2.6.21/drivers/serial/8250.c
>===================================================================
>--- linux-2.6.21.orig/drivers/serial/8250.c
>+++ linux-2.6.21/drivers/serial/8250.c
>@@ -129,7 +129,16 @@ struct uart_8250_port {
> 	unsigned char		mcr;
> 	unsigned char		mcr_mask;	/* mask of user bits */
> 	unsigned char		mcr_force;	/* mask of forced bits */
>-	unsigned char		lsr_break_flag;
>+
>+	/*
>+	 * Some bits in registers are cleared on a read, so they must
>+	 * be saved whenever the register is read but the bits will not
>+	 * be immediately processed.
>+	 */
>+#define LSR_SAVE_FLAGS UART_LSR_BRK_ERROR_BITS
>+	unsigned char		lsr_saved_flags;
>+#define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
>+	unsigned char		msr_saved_flags;
>
> 	/*
> 	 * We provide a per-port pm hook.
>@@ -1159,6 +1168,7 @@ static void serial8250_start_tx(struct u
> 		if (up->bugs & UART_BUG_TXEN) {
> 			unsigned char lsr, iir;
> 			lsr = serial_in(up, UART_LSR);
>+			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
> 			iir = serial_in(up, UART_IIR);
> 			if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT)
> 				transmit_chars(up);
>@@ -1208,18 +1218,10 @@ receive_chars(struct uart_8250_port *up,
> 		flag = TTY_NORMAL;
> 		up->port.icount.rx++;
>
>-#ifdef CONFIG_SERIAL_8250_CONSOLE
>-		/*
>-		 * Recover the break flag from console xmit
>-		 */
>-		if (up->port.line == up->port.cons->index) {
>-			lsr |= up->lsr_break_flag;
>-			up->lsr_break_flag = 0;
>-		}
>-#endif
>+		lsr |= up->lsr_saved_flags;
>+		up->lsr_saved_flags = 0;
>
>-		if (unlikely(lsr & (UART_LSR_BI | UART_LSR_PE |
>-				    UART_LSR_FE | UART_LSR_OE))) {
>+		if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
> 			/*
> 			 * For statistics only
> 			 */
>@@ -1310,6 +1312,8 @@ static unsigned int check_modem_status(s
> {
> 	unsigned int status = serial_in(up, UART_MSR);
>
>+	status |= up->msr_saved_flags;
>+	up->msr_saved_flags = 0;
> 	if (status & UART_MSR_ANY_DELTA && up->ier & UART_IER_MSI &&
> 	    up->port.info != NULL) {
> 		if (status & UART_MSR_TERI)
>@@ -1496,7 +1500,8 @@ static void serial8250_timeout(unsigned
> static void serial8250_backup_timeout(unsigned long data)
> {
> 	struct uart_8250_port *up = (struct uart_8250_port *)data;
>-	unsigned int iir, ier = 0;
>+	unsigned int iir, ier = 0, lsr;
>+	unsigned long flags;
>
> 	/*
> 	 * Must disable interrupts or else we risk racing with the interrupt
>@@ -1515,9 +1520,13 @@ static void serial8250_backup_timeout(un
> 	 * the "Diva" UART used on the management processor on many HP
> 	 * ia64 and parisc boxes.
> 	 */
>+	spin_lock_irqsave(&up->port.lock, flags);
>+	lsr = serial_in(up, UART_LSR);
>+	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
>+	spin_unlock_irqrestore(&up->port.lock, flags);
> 	if ((iir & UART_IIR_NO_INT) && (up->ier & UART_IER_THRI) &&
> 	    (!uart_circ_empty(&up->port.info->xmit) || up->port.x_char) &&
>-	    (serial_in(up, UART_LSR) & UART_LSR_THRE)) {
>+	    (lsr & UART_LSR_THRE)) {
> 		iir &= ~(UART_IIR_ID | UART_IIR_NO_INT);
> 		iir |= UART_IIR_THRI;
> 	}
>@@ -1536,13 +1545,14 @@ static unsigned int serial8250_tx_empty(
> {
> 	struct uart_8250_port *up = (struct uart_8250_port *)port;
> 	unsigned long flags;
>-	unsigned int ret;
>+	unsigned int lsr;
>
> 	spin_lock_irqsave(&up->port.lock, flags);
>-	ret = serial_in(up, UART_LSR) & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
>+	lsr = serial_in(up, UART_LSR);
>+	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
> 	spin_unlock_irqrestore(&up->port.lock, flags);
>
>-	return ret;
>+	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
> }
>
> static unsigned int serial8250_get_mctrl(struct uart_port *port)
>@@ -1613,8 +1623,7 @@ static inline void wait_for_xmitr(struct
> 	do {
> 		status = serial_in(up, UART_LSR);
>
>-		if (status & UART_LSR_BI)
>-			up->lsr_break_flag = UART_LSR_BI;
>+		up->lsr_saved_flags |= status & LSR_SAVE_FLAGS;
>
> 		if (--tmout == 0)
> 			break;
>@@ -1623,8 +1632,12 @@ static inline void wait_for_xmitr(struct
>
> 	/* Wait up to 1s for flow control if necessary */
> 	if (up->port.flags & UPF_CONS_FLOW) {
>-		tmout = 1000000;
>-		while (!(serial_in(up, UART_MSR) & UART_MSR_CTS) && --tmout) {
>+		unsigned int tmout;
>+		for (tmout = 1000000; tmout; tmout--) {
>+			unsigned int msr = serial_in(up, UART_MSR);
>+			up->msr_saved_flags |= msr & MSR_SAVE_FLAGS;
>+			if (msr & UART_MSR_CTS)
>+				break;
> 			udelay(1);
> 			touch_nmi_watchdog();
> 		}
>@@ -1794,6 +1807,18 @@ static int serial8250_startup(struct uar
> 	spin_unlock_irqrestore(&up->port.lock, flags);
>
> 	/*
>+	 * Clear the interrupt registers again for luck, and clear the
>+	 * saved flags to avoid getting false values from polling
>+	 * routines or the previous session.
>+	 */
>+	(void) serial_inp(up, UART_LSR);
>+	(void) serial_inp(up, UART_RX);
>+	(void) serial_inp(up, UART_IIR);
>+	(void) serial_inp(up, UART_MSR);
>+	up->lsr_saved_flags = 0;
>+	up->msr_saved_flags = 0;
>+
>+	/*
> 	 * Finally, enable interrupts.  Note: Modem status interrupts
> 	 * are set via set_termios(), which will be occurring imminently
> 	 * anyway, so we don't enable them here.
>@@ -1811,14 +1836,6 @@ static int serial8250_startup(struct uar
> 		(void) inb_p(icp);
> 	}
>
>-	/*
>-	 * And clear the interrupt registers again for luck.
>-	 */
>-	(void) serial_inp(up, UART_LSR);
>-	(void) serial_inp(up, UART_RX);
>-	(void) serial_inp(up, UART_IIR);
>-	(void) serial_inp(up, UART_MSR);
>-
> 	return 0;
> }
>
>@@ -2387,6 +2404,16 @@ serial8250_console_write(struct console
> 	wait_for_xmitr(up, BOTH_EMPTY);
> 	serial_out(up, UART_IER, ier);
>
>+	/*
>+	 *	The receive handling will happen properly because the
>+	 *	receive ready bit will still be set; it is not cleared
>+	 *	on read.  However, modem control will not, we must
>+	 *	call it if we have saved something in the saved flags
>+	 *	while processing with interrupts off.
>+	 */
>+	if (up->msr_saved_flags)
>+		check_modem_status(up);
>+
> 	if (locked)
> 		spin_unlock(&up->port.lock);
> 	local_irq_restore(flags);
>Index: linux-2.6.21/include/linux/serial_reg.h
>===================================================================
>--- linux-2.6.21.orig/include/linux/serial_reg.h
>+++ linux-2.6.21/include/linux/serial_reg.h
>@@ -116,6 +116,7 @@
> #define UART_LSR_PE		0x04 /* Parity error indicator */
> #define UART_LSR_OE		0x02 /* Overrun error indicator */
> #define UART_LSR_DR		0x01 /* Receiver data ready */
>+#define UART_LSR_BRK_ERROR_BITS	0x1E /* BI, FE, PE, OE bits */
>
> #define UART_MSR	6	/* In:  Modem Status Register */
> #define UART_MSR_DCD		0x80 /* Data Carrier Detect */
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
#define NULL 0           /* silly thing is, we don't even use this */
             -- Larry Wall in perl.c from the perl source code
