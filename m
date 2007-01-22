Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXAVTIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXAVTIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932342AbXAVTIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:08:39 -0500
Received: from mother.pmc-sierra.com ([216.241.224.12]:59717 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932368AbXAVTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:08:38 -0500
Message-ID: <45B50A19.6090909@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
Date: Mon, 22 Jan 2007 11:01:45 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 22 Jan 2007 19:01:46.0328 (UTC) FILETIME=[C350D580:01C73E57]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CCing linux-kernel as per AC's suggestion...

Here is a serial driver patch for the PMC-Sierra MSP71xx device.

There are three different fixes:
1. Fix for THRE errata
2. Fix for Busy Detect on LCR write
3. Workaround for interrupt/data concurrency issue

The first fix is handled cleanly using a UART_BUG_* flag.

The second and third fixes use platform tests. I couldn't think of a
good way to implement them without using tests and not increase code
and structure sizes for platforms not requiring them.

Does anyone have any suggestions on implementing these without the
platform flag?

Thanks,
Marc

Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>


Index: linux_2_6/drivers/serial/8250.c
===================================================================
RCS file: linux_2_6/drivers/serial/8250.c,v
retrieving revision 1.1.1.7
retrieving revision 1.9
diff -u -r1.1.1.7 -r1.9
--- linux_2_6/drivers/serial/8250.c	19 Oct 2006 21:00:58 -0000	1.1.1.7
+++ linux_2_6/drivers/serial/8250.c	19 Oct 2006 22:08:15 -0000	1.9
@@ -44,6 +44,10 @@
  #include <asm/io.h>
  #include <asm/irq.h>

+#ifdef CONFIG_PMC_MSP
+#include <msp_regs.h>
+#endif
+
  #include "8250.h"

  /*
@@ -130,6 +134,9 @@
  	unsigned char		mcr_mask;	/* mask of user bits */
  	unsigned char		mcr_force;	/* mask of forced bits */
  	unsigned char		lsr_break_flag;
+#ifdef CONFIG_PMC_MSP
+	int					dwapb_lcr;	/* saved LCR for DW APB WAR */
+#endif

  	/*
  	 * We provide a per-port pm hook.
@@ -333,6 +340,10 @@
  static void
  serial_out(struct uart_8250_port *up, int offset, int value)
  {
+#ifdef CONFIG_PMC_MSP
+	/* Save the offset before it's remapped */
+	int dwapb_offset = offset;
+#endif
  	offset = map_8250_out_reg(up, offset) << up->port.regshift;

  	switch (up->port.iotype) {
@@ -342,7 +353,19 @@
  		break;

  	case UPIO_MEM:
+#ifdef CONFIG_PMC_MSP
+		/* Save the LCR value so it can be re-written when a
+		 * Busy Detect interrupt occurs. */
+		if (dwapb_offset == UART_LCR)
+			up->dwapb_lcr = value;
+#endif
  		writeb(value, up->port.membase + offset);
+#ifdef CONFIG_PMC_MSP
+		/* Re-read the IER to ensure any interrupt disabling has
+		 * completed before proceeding with ISR. */
+		if (dwapb_offset == UART_IER)
+			value = serial_in(up, dwapb_offset);
+#endif
  		break;

  	case UPIO_MEM32:
@@ -1016,6 +1039,17 @@
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
@@ -1141,6 +1175,12 @@
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

@@ -1366,6 +1406,31 @@
  			handled = 1;

  			end = NULL;
+#ifdef CONFIG_PMC_MSP
+		} else if ((iir & UART_IER_BUSY) == UART_IER_BUSY) {
+			/*
+			 * The MSP (DesignWare APB UART) serial subsystem has a
+			 * non-standard interrupt condition (0x7) which means
+			 * that the LCR was written while the UART was busy, so
+			 * the LCR was not actually written.  It is cleared by
+			 * reading the special non-standard extended UART status
+			 * register.
+			 */
+			unsigned int tmp;
+			if( up->port.line == 0 )
+				tmp = *UART0_STATUS_REG;
+			else
+				tmp = *UART1_STATUS_REG;
+			
+			/* Check if saved on LCR write */
+			if( up->dwapb_lcr != -1 )
+				serial_outp(up, UART_LCR, up->dwapb_lcr);
+			else
+				printk(KERN_ERR "serial8250: UART BUSY, no LCR write!\n" );
+
+			handled = 1;
+			end = NULL;
+#endif
  		} else if (end == NULL)
  			end = l;

@@ -2191,6 +2256,11 @@
  	for (i = 0; i < nr_uarts; i++) {
  		struct uart_8250_port *up = &serial8250_ports[i];

+#ifdef CONFIG_PMC_MSP
+		/* Initialize saved LCR value */
+		up->dwapb_lcr = -1;
+#endif
+
  		up->port.dev = dev;
  		uart_add_one_port(drv, &up->port);
  	}
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
Index: linux_2_6/include/linux/serial_core.h
===================================================================
RCS file: linux_2_6/include/linux/serial_core.h,v
retrieving revision 1.1.1.7
retrieving revision 1.5
diff -u -r1.1.1.7 -r1.5
--- linux_2_6/include/linux/serial_core.h	19 Oct 2006 21:01:02 -0000	1.1.1.7
+++ linux_2_6/include/linux/serial_core.h	19 Oct 2006 22:08:16 -0000	1.5
@@ -258,6 +258,8 @@
  #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
  #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
  #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))
+#define UPF_DW_THRE_BUG		((__force upf_t)(1 << 29)) /* DesignWare THRE hardware BUG
+														* (cannot be autodetected) */
  #define UPF_DEAD		((__force upf_t) (1 << 30))
  #define UPF_IOREMAP		((__force upf_t) (1 << 31))

Index: linux_2_6/include/linux/serial_reg.h
===================================================================
RCS file: linux_2_6/include/linux/serial_reg.h,v
retrieving revision 1.1.1.2
retrieving revision 1.3
diff -u -r1.1.1.2 -r1.3
--- linux_2_6/include/linux/serial_reg.h	19 Oct 2006 18:29:50 -0000	1.1.1.2
+++ linux_2_6/include/linux/serial_reg.h	19 Oct 2006 19:45:04 -0000	1.3
@@ -218,6 +218,10 @@
  #define UART_FCR_PXAR16	0x80	/* receive FIFO treshold = 16 */
  #define UART_FCR_PXAR32	0xc0	/* receive FIFO treshold = 32 */

+/*
+ * DesignWare APB UART
+ */
+#define UART_IER_BUSY		0x07	/* Busy Detect */

