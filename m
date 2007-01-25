Return-Path: <linux-kernel-owner+w=401wt.eu-S1750983AbXAYAAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983AbXAYAAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbXAYAAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:00:54 -0500
Received: from mother.pmc-sierra.com ([216.241.224.12]:58362 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750983AbXAYAAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:00:53 -0500
Message-ID: <45B7F32E.1030208@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: linux-mips@linux-mips.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
Date: Wed, 24 Jan 2007 16:00:46 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 25 Jan 2007 00:00:46.0784 (UTC) FILETIME=[DD7CAC00:01C74013]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my second attempt at the serial driver patch for the
PMC-Sierra MSP71xx device.

There are three different fixes:
1. Fix for THRE errata
- I verified the UART_BUG_TXEN fix does not help with this erratum.
- I left our current fix in until I get our platform booting on
2.6.20-rc4 to try the mm tree "8250-uart-backup-timer.patch".
Feel free to ignore for now.

2. Fix for Busy Detect on LCR write
- Moved to new UPIO_DWAPB iotype. Because the new type is a memory
mapped device and there are several tests for UPIO_MEM, this involved
updating serial_core.c and 8250_early.c in addition to 8250.c.
- I tried implementing this totally in serial_in as suggested, but
it can't be done because of bit overlap between UART_IIR_NO_INT and
UART_IIR_BUSY. Also there is no way to set the interrupt "handled = 1"
from serial_in.

3. Workaround for interrupt/data concurrency issue
- Moved to new UPIO_DWAPB iotype.

Thanks,
Marc

Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>

Index: linux_2_6/drivers/serial/8250.c
===================================================================
RCS file: linux_2_6/drivers/serial/8250.c,v
retrieving revision 1.1.1.7
diff -u -r1.1.1.7 8250.c
--- linux_2_6/drivers/serial/8250.c	19 Oct 2006 21:00:58 -0000	1.1.1.7
+++ linux_2_6/drivers/serial/8250.c	24 Jan 2007 23:55:27 -0000
@@ -308,6 +308,7 @@
  		return inb(up->port.iobase + 1);

  	case UPIO_MEM:
+	case UPIO_DWAPB:
  		return readb(up->port.membase + offset);

  	case UPIO_MEM32:
@@ -333,6 +334,8 @@
  static void
  serial_out(struct uart_8250_port *up, int offset, int value)
  {
+	/* Save the offset before it's remapped */
+	int save_offset = offset;
  	offset = map_8250_out_reg(up, offset) << up->port.regshift;

  	switch (up->port.iotype) {
@@ -359,6 +362,19 @@
  			writeb(value, up->port.membase + offset);
  		break;

+	case UPIO_DWAPB:
+		/* Save the LCR value so it can be re-written when a
+		 * Busy Detect interrupt occurs. */
+		if (save_offset == UART_LCR)
+			up->lcr = value;
+		writeb(value, up->port.membase + offset);
+		/* Read the IER to ensure any interrupt is cleared before
+		 * returning from ISR. */
+		if ((save_offset == UART_TX || save_offset == UART_IER) &&
+				in_irq())
+			value = serial_in(up, UART_IER);
+		break;
+		
  	default:
  		outb(value, up->port.iobase + offset);
  	}
@@ -1016,6 +1032,17 @@
  		up->bugs |= UART_BUG_NOMSR;
  #endif

+	/* Workaround:
+	 * The DesignWare SoC UART part has a bug for all
+	 * versions before 3.03a (2005-07-18)
+	 * In brief, this is a non-standard 16550 in that the THRE interrupt
+	 * will not re-assert itself simply by disabling and re-enabling the
+	 * THRI bit in the IER, it is only re-enabled if a character is actually
+	 * sent out.
+	 */
+	if( up->port.flags & UPF_DW_THRE_BUG )
+		up->bugs |= UART_BUG_DWTHRE;
+
  	serial_outp(up, UART_LCR, save_lcr);

  	if (up->capabilities != uart_config[up->port.type].flags) {
@@ -1141,6 +1168,12 @@
  			iir = serial_in(up, UART_IIR);
  			if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT)
  				transmit_chars(up);
+		} else if (up->bugs & UART_BUG_DWTHRE) {
+			unsigned char lsr, iir;
+			lsr = serial_in(up, UART_LSR);
+			iir = serial_in(up, UART_IIR);
+			if (lsr & UART_LSR_THRE)
+				transmit_chars(up);
  		}
  	}

@@ -1366,6 +1399,19 @@
  			handled = 1;

  			end = NULL;
+		} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY &&
+				up->port.iotype == UPIO_DWAPB) {
+			/* The DesignWare APB UART has an Busy Detect (0x07)
+			 * interrupt meaning the LCR was written while the UART
+			 * was busy, so the LCR was not actually written. It's
+			 * cleared by reading the extended UART status register. */
+			unsigned int status;
+			status = *(volatile u32 *)up->port.user;
+			serial_out(up, UART_LCR, up->lcr);			
+
+			handled = 1;
+
+			end = NULL;
  		} else if (end == NULL)
  			end = l;

@@ -1950,6 +1996,7 @@
  		size = 0x100000;
  		/* fall thru */
  	case UPIO_MEM:
+	case UPIO_DWAPB:
  		if (!up->port.mapbase)
  			break;

@@ -1985,6 +2032,7 @@
  		size = 0x100000;
  		/* fall thru */
  	case UPIO_MEM:
+	case UPIO_DWAPB:
  		if (!up->port.mapbase)
  			break;

@@ -2011,6 +2059,7 @@

  	switch (up->port.iotype) {
  	case UPIO_MEM:
+	case UPIO_DWAPB:
  		ret = -EINVAL;
  		break;

@@ -2032,6 +2081,7 @@

  	switch (up->port.iotype) {
  	case UPIO_MEM:
+	case UPIO_DWAPB:
  		break;

  	case UPIO_HUB6:
@@ -2352,9 +2402,12 @@

  	add_preferred_console("ttyS", line, options);
  	printk("Adding console on ttyS%d at %s 0x%lx (options '%s')\n",
-		line, port->iotype == UPIO_MEM ? "MMIO" : "I/O port",
-		port->iotype == UPIO_MEM ? (unsigned long) port->mapbase :
-		    (unsigned long) port->iobase, options);
+		line,
+		(port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
+			? "MMIO" : "I/O port",
+		(port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
+			? (unsigned long) port->mapbase : (unsigned long) port->iobase,
+		options);
  	if (!(serial8250_console.flags & CON_ENABLED)) {
  		serial8250_console.flags &= ~CON_PRINTBUFFER;
  		register_console(&serial8250_console);
Index: linux_2_6/drivers/serial/8250.h
===================================================================
RCS file: linux_2_6/drivers/serial/8250.h,v
retrieving revision 1.1.1.6
retrieving revision 1.4
diff -u -r1.1.1.6 -r1.4
--- linux_2_6/drivers/serial/8250.h	19 Oct 2006 21:00:58 -0000	1.1.1.6
+++ linux_2_6/drivers/serial/8250.h	19 Oct 2006 22:08:15 -0000	1.4
@@ -49,6 +49,7 @@
  #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
  #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
  #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
+#define UART_BUG_DWTHRE (1 << 3)	/* UART has buggy DesignWare THRE interrupt re-assertion */

  #define PROBE_RSA	(1 << 0)
  #define PROBE_ANY	(~0)
Index: linux_2_6/drivers/serial/8250_early.c
===================================================================
RCS file: linux_2_6/drivers/serial/8250_early.c,v
retrieving revision 1.1.1.3
diff -u -r1.1.1.3 8250_early.c
--- linux_2_6/drivers/serial/8250_early.c	19 Oct 2006 20:08:20 -0000	1.1.1.3
+++ linux_2_6/drivers/serial/8250_early.c	24 Jan 2007 23:55:27 -0000
@@ -46,7 +46,7 @@

  static unsigned int __init serial_in(struct uart_port *port, int offset)
  {
-	if (port->iotype == UPIO_MEM)
+	if (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
  		return readb(port->membase + offset);
  	else
  		return inb(port->iobase + offset);
@@ -54,7 +54,7 @@

  static void __init serial_out(struct uart_port *port, int offset, int value)
  {
-	if (port->iotype == UPIO_MEM)
+	if (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
  		writeb(value, port->membase + offset);
  	else
  		outb(value, port->iobase + offset);
@@ -233,7 +233,7 @@
  		return 0;

  	/* Try to start the normal driver on a matching line.  */
-	mmio = (port->iotype == UPIO_MEM);
+	mmio = (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB);
  	line = serial8250_start_console(port, device->options);
  	if (line < 0)
  		printk("No ttyS device at %s 0x%lx for console\n",
Index: linux_2_6/drivers/serial/serial_core.c
===================================================================
RCS file: linux_2_6/drivers/serial/serial_core.c,v
retrieving revision 1.1.1.7
diff -u -r1.1.1.7 serial_core.c
--- linux_2_6/drivers/serial/serial_core.c	19 Oct 2006 21:00:58 -0000	1.1.1.7
+++ linux_2_6/drivers/serial/serial_core.c	24 Jan 2007 23:55:28 -0000
@@ -1669,9 +1669,10 @@

  	ret = sprintf(buf, "%d: uart:%s %s%08lX irq:%d",
  			port->line, uart_type(port),
-			port->iotype == UPIO_MEM ? "mmio:0x" : "port:",
-			port->iotype == UPIO_MEM ? port->mapbase :
-						(unsigned long) port->iobase,
+			(port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
+				? "mmio:0x" : "port:",
+			(port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
+				? port->mapbase : (unsigned long) port->iobase,
  			port->irq);

  	if (port->type == PORT_UNKNOWN) {
@@ -2037,6 +2038,7 @@
  	case UPIO_MEM32:
  	case UPIO_AU:
  	case UPIO_TSI:
+	case UPIO_DWAPB:
  		snprintf(address, sizeof(address),
  			 "MMIO 0x%lx", port->mapbase);
  		break;
@@ -2380,6 +2382,7 @@
  	case UPIO_MEM32:
  	case UPIO_AU:
  	case UPIO_TSI:
+	case UPIO_DWAPB:
  		return (port1->mapbase == port2->mapbase);
  	}
  	return 0;
Index: linux_2_6/include/linux/serial_core.h
===================================================================
RCS file: linux_2_6/include/linux/serial_core.h,v
retrieving revision 1.1.1.7
diff -u -r1.1.1.7 serial_core.h
--- linux_2_6/include/linux/serial_core.h	19 Oct 2006 21:01:02 -0000	1.1.1.7
+++ linux_2_6/include/linux/serial_core.h	24 Jan 2007 23:55:28 -0000
@@ -228,6 +228,7 @@
  #define UPIO_MEM32		(3)
  #define UPIO_AU			(4)			/* Au1x00 type IO */
  #define UPIO_TSI		(5)			/* Tsi108/109 type IO */
+#define UPIO_DWAPB		(6)			/* DesignWare APB UART */

  	unsigned int		read_status_mask;	/* driver specific */
  	unsigned int		ignore_status_mask;	/* driver specific */
@@ -258,6 +259,8 @@
  #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
  #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
  #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))
+#define UPF_DW_THRE_BUG		((__force upf_t)(1 << 29)) /* DesignWare THRE hardware BUG
+														* (cannot be autodetected) */
  #define UPF_DEAD		((__force upf_t) (1 << 30))
  #define UPF_IOREMAP		((__force upf_t) (1 << 31))

@@ -274,6 +277,7 @@
  	struct device		*dev;			/* parent device */
  	unsigned char		hub6;			/* this should be in the 8250 driver */
  	unsigned char		unused[3];
+	void				*user;			/* generic platform 'user' pointer */
  };

  /*
Index: linux_2_6/include/linux/serial_reg.h
===================================================================
RCS file: linux_2_6/include/linux/serial_reg.h,v
retrieving revision 1.1.1.2
diff -u -r1.1.1.2 serial_reg.h
--- linux_2_6/include/linux/serial_reg.h	19 Oct 2006 18:29:50 -0000	1.1.1.2
+++ linux_2_6/include/linux/serial_reg.h	24 Jan 2007 23:55:29 -0000
@@ -218,6 +218,10 @@
  #define UART_FCR_PXAR16	0x80	/* receive FIFO treshold = 16 */
  #define UART_FCR_PXAR32	0xc0	/* receive FIFO treshold = 32 */

+/*
+ * DesignWare APB UART
+ */
+#define UART_IIR_BUSY		0x07	/* Busy Detect */



