Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZKPDZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZKPDZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 22:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZKPDZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 22:25:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:41065 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZKPDZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 22:25:48 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 2/2] Uart driver for ST Microelectronics ConneXt(STA2X11/STA2X10).
Date: Mon, 16 Nov 2009 04:25:43 +0100
Message-ID: <52CF90264091A14888078A031D780F4302F89338@ism-mail03.corp.ad.wrs.com>
In-Reply-To: <52CF90264091A14888078A031D780F436EF0F9@ism-mail03.corp.ad.wrs.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] Uart driver for ST Microelectronics ConneXt(STA2X11/STA2X10).
thread-index: AcpkXLAL7xF8u0X1RPy9hmnV/QIeyACDpxEg
References: <52CF90264091A14888078A031D780F436EF0F9@ism-mail03.corp.ad.wrs.com>
From: "Feng, Xiaobing" <Xiaobing.Feng@windriver.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-serial@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <giancarlo.asnaghi@st.com>,
       "Wallin, Anders" <Anders.Wallin@windriver.com>,
       "D'Agostino, Raffaele" <raffaele.dagostino@windriver.com>,
       "Li, Li" <Li.Li@windriver.com>,
       "Tang, ChunQiang" <ChunQiang.Tang@windriver.com>
X-OriginalArrivalTime: 16 Nov 2009 03:25:49.0127 (UTC) FILETIME=[7E14BD70:01CA666C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
 	 The patch is a serial driver for PL011 UART base on PCI
express. It was develop for ST Microelectronics's ConneXt board.
ST Microelectronics ConneXt(STA2X11/STA2X10), a PCI express
multifunction chip that provides Input/Output capabilities.
	This driver derive from drivers/serial/amba-pl011.c, I added PCI
express feature and some platform-dependent features in it, which make
it support PL011 on ConneXt as a PCI express device. 
  	The patch has been checked by scripts/checkpatch.pl .
 


>From a567d7644d15b4eb0ae511f4e02307e62be127c9 Mon Sep 17 00:00:00 2001
From: Billy <billy@billy-laptop.(none)>
Date: Fri, 13 Nov 2009 18:17:04 +0800
Subject: [PATCH] Add pl011 uart support for STMICRO's ConneXt, which
base on PCI and derive from Amba-pl011.c

Signed-off-by: XiaoBing Feng (Billy Feng) <xiaobing.feng@windriver.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/serial/Kconfig     |   10 +
 drivers/serial/Makefile    |    1 +
 drivers/serial/pl011-pci.c |  949
++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 960 insertions(+), 0 deletions(-)
 create mode 100644 drivers/serial/pl011-pci.c

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 6553833..c42c402 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -331,6 +331,16 @@ config SERIAL_AMBA_PL011_CONSOLE
 	  your boot loader (lilo or loadlin) about how to pass options
to the
 	  kernel at boot time.)
 
+config SERIAL_PCI_PL011
+	tristate "PL011 serial port based on PCI support"
+	depends on PCI
+	select SERIAL_CORE
+
+config SERIAL_PCI_PL011_CONSOLE
+	bool "Support for console on PL011 serial port based on PCI"
+	depends on SERIAL_PCI_PL011=y
+	select SERIAL_CORE_CONSOLE
+
 config SERIAL_SB1250_DUART
 	tristate "BCM1xxx on-chip DUART serial support"
 	depends on SIBYTE_SB1xxx_SOC=y
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index d5a2998..e8e5cfd 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_SERIAL_8250_HUB6) += 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_MCA) += 8250_mca.o
 obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
+obj-$(CONFIG_SERIAL_PCI_PL011) += pl011-pci.o
 obj-$(CONFIG_SERIAL_CLPS711X) += clps711x.o
 obj-$(CONFIG_SERIAL_PXA) += pxa.o
 obj-$(CONFIG_SERIAL_PNX8XXX) += pnx8xxx_uart.o
diff --git a/drivers/serial/pl011-pci.c b/drivers/serial/pl011-pci.c
new file mode 100644
index 0000000..6783b0d
--- /dev/null
+++ b/drivers/serial/pl011-pci.c
@@ -0,0 +1,949 @@
+/*
+* linux/drivers/serial/pl011-pci.c
+*
+* ST Microelectronics ConneXt(STA2X11/STA2X10) UART file
+* derive from AMBA-pl011.c
+*
+* Copyright (c) 2009 Wind River Systems, Inc.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+* See the GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA
+*
+*/
+#include <linux/moduleparam.h>
+#include <linux/pci.h>
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/sysrq.h>
+#include <linux/device.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial_core.h>
+#include <linux/serial.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/serial.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+
+
+#if defined(CONFIG_SERIAL_PCI_PL011_CONSOLE) &&
defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
+#define DRV_VERSION	"1.0.0"
+#define PCI_PL011_DRIVER_NAME "ttyAM"
+#define PCI_PL011_MAJOR		204
+#define PCI_PL011_MINOR_START	16
+#define MAXPORTS		1
+#define UART_NR			4
+#define PL011_HWFC		1
+#define PL011_NO_HWFC		2
+#define AMBA_ISR_PASS_LIMIT	256
+#define UARTCLK			32000000
+
+#define UART_DR_ERROR	\
+	(UART011_DR_OE|UART011_DR_BE|UART011_DR_PE|UART011_DR_FE)
+
+#define UART_DUMMY_DR_RX	(1 << 16)
+#define SZ_4K                           0x00001000
+
+static LIST_HEAD(pci_pl011_adapter_head);
+/**
+ * We wrap our port structure around the generic uart_port.
+ */
+struct uart_amba_port {
+	struct uart_port	port;
+	struct clk		*clk;
+	unsigned int		im;	/** interrupt mask */
+	unsigned int		old_status;
+	unsigned int		ifls;	/** vendor-specific */
+};
+
+struct pci_pl011_adapter{
+
+	u8		rev;		/** PCI revision ID */
+	struct pci_dev	*pci_dev;
+	int		type;
+	int		index;
+
+	spinlock_t	intr_lock;
+
+	u32		irq;		/** Interrupt request number */
+	u64		intr_count;	/** Count of interrupts */
+
+	u64		membase;	/** Start of base memory */
+	u64		membase_end;	/** End of base memory */
+
+	u8	__iomem *re_map_membase;/** Remapped memory */
+
+	u64		iobase;		/** Start of io base */
+	u64		iobase_end;	/** End of io base */
+
+	int		numb_ports;
+	struct uart_amba_port port_info[MAXPORTS];
+	struct list_head pci_pl011_adapter_entry;
+};
+
+
+
+/** There is by now at least one vendor with differing details, so
handle it */
+struct vendor_data {
+	unsigned int		ifls;
+	unsigned int		fifosize;
+};
+
+static struct vendor_data vendor_st = {
+	.ifls			=
UART011_IFLS_RX_HALF|UART011_IFLS_TX_HALF,
+	.fifosize		= 64,
+};
+
+static void pl011_stop_tx(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+
+	uap->im &= ~UART011_TXIM;
+	writel(uap->im, uap->port.membase + UART011_IMSC);
+}
+
+static void pl011_start_tx(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+
+	uap->im |= UART011_TXIM;
+	writel(uap->im, uap->port.membase + UART011_IMSC);
+}
+
+static void pl011_stop_rx(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+
+	uap->im &= ~(UART011_RXIM|UART011_RTIM|UART011_FEIM|
+		     UART011_PEIM|UART011_BEIM|UART011_OEIM);
+	writel(uap->im, uap->port.membase + UART011_IMSC);
+}
+
+static void pl011_enable_ms(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+
+	uap->im |=
UART011_RIMIM|UART011_CTSMIM|UART011_DCDMIM|UART011_DSRMIM;
+	writel(uap->im, uap->port.membase + UART011_IMSC);
+}
+
+static void pl011_rx_chars(struct uart_amba_port *uap)
+{
+	struct tty_struct *tty = uap->port.state->port.tty;
+	unsigned int status, ch, flag, max_count = 256;
+
+	status = readl(uap->port.membase + UART01x_FR);
+	while ((status & UART01x_FR_RXFE) == 0 && max_count--) {
+		ch = readl(uap->port.membase + UART01x_DR) |
UART_DUMMY_DR_RX;
+		flag = TTY_NORMAL;
+		uap->port.icount.rx++;
+
+		/**
+		 * Note that the error handling code is
+		 * out of the main execution path
+		 */
+		if (unlikely(ch & UART_DR_ERROR)) {
+			if (ch & UART011_DR_BE) {
+				ch &= ~(UART011_DR_FE | UART011_DR_PE);
+				uap->port.icount.brk++;
+				if (uart_handle_break(&uap->port))
+					goto ignore_char;
+			} else if (ch & UART011_DR_PE)
+				uap->port.icount.parity++;
+			else if (ch & UART011_DR_FE)
+				uap->port.icount.frame++;
+			if (ch & UART011_DR_OE)
+				uap->port.icount.overrun++;
+
+			ch &= uap->port.read_status_mask;
+
+			if (ch & UART011_DR_BE)
+				flag = TTY_BREAK;
+			else if (ch & UART011_DR_PE)
+				flag = TTY_PARITY;
+			else if (ch & UART011_DR_FE)
+				flag = TTY_FRAME;
+		}
+
+		if (uart_handle_sysrq_char(&uap->port, ch & 255))
+			goto ignore_char;
+
+		uart_insert_char(&uap->port, ch, UART011_DR_OE, ch,
flag);
+
+ignore_char:
+		status = readl(uap->port.membase + UART01x_FR);
+	}
+	spin_unlock(&uap->port.lock);
+	tty_flip_buffer_push(tty);
+	spin_lock(&uap->port.lock);
+}
+
+static void pl011_tx_chars(struct uart_amba_port *uap)
+{
+	struct circ_buf *xmit = &uap->port.state->xmit;
+	int count;
+
+	if (uap->port.x_char) {
+		writel(uap->port.x_char, uap->port.membase +
UART01x_DR);
+		uap->port.icount.tx++;
+		uap->port.x_char = 0;
+		return;
+	}
+	if (uart_circ_empty(xmit) || uart_tx_stopped(&uap->port)) {
+		pl011_stop_tx(&uap->port);
+		return;
+	}
+
+	count = uap->port.fifosize >> 1;
+	do {
+		writel(xmit->buf[xmit->tail], uap->port.membase +
UART01x_DR);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		uap->port.icount.tx++;
+		if (uart_circ_empty(xmit))
+			break;
+	} while (--count > 0);
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&uap->port);
+
+	if (uart_circ_empty(xmit))
+		pl011_stop_tx(&uap->port);
+}
+
+static void pl011_modem_status(struct uart_amba_port *uap)
+{
+	unsigned int status, delta;
+
+	status = readl(uap->port.membase + UART01x_FR) &
UART01x_FR_MODEM_ANY;
+
+	delta = status ^ uap->old_status;
+	uap->old_status = status;
+
+	if (!delta)
+		return;
+
+	if (delta & UART01x_FR_DCD)
+		uart_handle_dcd_change(&uap->port, status &
UART01x_FR_DCD);
+
+	if (delta & UART01x_FR_DSR)
+		uap->port.icount.dsr++;
+
+	if (delta & UART01x_FR_CTS)
+		uart_handle_cts_change(&uap->port, status &
UART01x_FR_CTS);
+
+	wake_up_interruptible(&uap->port.state->port.delta_msr_wait);
+}
+
+static irqreturn_t pl011_int(int irq, void *dev_id)
+{
+	struct uart_amba_port *uap = dev_id;
+	unsigned int status, pass_counter = AMBA_ISR_PASS_LIMIT;
+	int handled = 0;
+
+	spin_lock(&uap->port.lock);
+
+	status = readl(uap->port.membase + UART011_MIS);
+	if (status) {
+		do {
+			writel(status & ~(UART011_TXIS|UART011_RTIS|
+					  UART011_RXIS),
+			       uap->port.membase + UART011_ICR);
+
+			if (status & (UART011_RTIS|UART011_RXIS))
+				pl011_rx_chars(uap);
+			if (status & (UART011_DSRMIS|UART011_DCDMIS|
+				      UART011_CTSMIS|UART011_RIMIS))
+				pl011_modem_status(uap);
+			if (status & UART011_TXIS)
+				pl011_tx_chars(uap);
+
+			if (pass_counter-- == 0)
+				break;
+
+			status = readl(uap->port.membase + UART011_MIS);
+		} while (status != 0);
+		handled = 1;
+	}
+
+	spin_unlock(&uap->port.lock);
+
+	return IRQ_RETVAL(handled);
+}
+
+static unsigned int pl011_tx_empty(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int status = readl(uap->port.membase + UART01x_FR);
+	return status & (UART01x_FR_BUSY|UART01x_FR_TXFF) ? 0 :
TIOCSER_TEMT;
+}
+
+static unsigned int pl011_get_mctrl(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int result = 0;
+	unsigned int status = readl(uap->port.membase + UART01x_FR);
+
+#define TIOCMBIT(uartbit, tiocmbit)		\
+	{					\
+		if (status & uartbit)		\
+			result |= tiocmbit;	\
+	}
+
+	TIOCMBIT(UART01x_FR_DCD, TIOCM_CAR)
+	TIOCMBIT(UART01x_FR_DSR, TIOCM_DSR)
+	TIOCMBIT(UART01x_FR_CTS, TIOCM_CTS)
+	TIOCMBIT(UART011_FR_RI, TIOCM_RNG)
+#undef TIOCMBIT
+	return result;
+}
+
+static void pl011_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int cr;
+
+	cr = readl(uap->port.membase + UART011_CR);
+
+#define	TIOCMBIT(tiocmbit, uartbit)		\
+	do {					\
+		if (mctrl & tiocmbit)		\
+			cr |= uartbit;		\
+		else				\
+			cr &= ~uartbit;		\
+	} while (0)
+
+	TIOCMBIT(TIOCM_RTS, UART011_CR_RTS);
+	TIOCMBIT(TIOCM_DTR, UART011_CR_DTR);
+	TIOCMBIT(TIOCM_OUT1, UART011_CR_OUT1);
+	TIOCMBIT(TIOCM_OUT2, UART011_CR_OUT2);
+	TIOCMBIT(TIOCM_LOOP, UART011_CR_LBE);
+#undef TIOCMBIT
+
+	writel(cr, uap->port.membase + UART011_CR);
+}
+
+static void pl011_break_ctl(struct uart_port *port, int break_state)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned long flags;
+	unsigned int lcr_h;
+
+	spin_lock_irqsave(&uap->port.lock, flags);
+	lcr_h = readl(uap->port.membase + UART011_LCRH);
+	if (break_state == -1)
+		lcr_h |= UART01x_LCRH_BRK;
+	else
+		lcr_h &= ~UART01x_LCRH_BRK;
+	writel(lcr_h, uap->port.membase + UART011_LCRH);
+	spin_unlock_irqrestore(&uap->port.lock, flags);
+}
+
+#ifdef CONFIG_CONSOLE_POLL
+static int pl011_get_poll_char(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int status;
+
+	do {
+		status = readl(uap->port.membase + UART01x_FR);
+	} while (status & UART01x_FR_RXFE);
+
+	return readl(uap->port.membase + UART01x_DR);
+}
+
+static void pl011_put_poll_char(struct uart_port *port,
+			 unsigned char ch)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+
+	while (readl(uap->port.membase + UART01x_FR) & UART01x_FR_TXFF)
+		barrier();
+
+	writel(ch, uap->port.membase + UART01x_DR);
+}
+
+#endif /** CONFIG_CONSOLE_POLL */
+
+static int pl011_startup(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int cr;
+	int retval;
+
+	uap->port.uartclk = UARTCLK;
+	/**
+	 * Allocate the IRQ
+	 */
+	retval = request_irq(uap->port.irq, pl011_int,
+		IRQF_DISABLED | IRQF_SHARED, "uart-pl011", uap);
+	if (retval)
+		goto out;
+
+	writel(uap->ifls, uap->port.membase + UART011_IFLS);
+
+	/**
+	 * Provoke TX FIFO interrupt into asserting.
+	 */
+	cr = UART01x_CR_UARTEN | UART011_CR_TXE | UART011_CR_LBE;
+	writel(cr, uap->port.membase + UART011_CR);
+	writel(0, uap->port.membase + UART011_FBRD);
+	writel(1, uap->port.membase + UART011_IBRD);
+	writel(0, uap->port.membase + UART011_LCRH);
+	writel(0, uap->port.membase + UART01x_DR);
+	while (readl(uap->port.membase + UART01x_FR) & UART01x_FR_BUSY)
+		barrier();
+
+	cr = UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
+	writel(cr, uap->port.membase + UART011_CR);
+
+	/**
+	 * initialise the old status of the modem signals
+	 */
+	uap->old_status =
+		readl(uap->port.membase + UART01x_FR) &
UART01x_FR_MODEM_ANY;
+
+	/**
+	 * Finally, enable interrupts
+	 */
+	spin_lock_irq(&uap->port.lock);
+	uap->im = UART011_RXIM | UART011_RTIM;
+	writel(uap->im, uap->port.membase + UART011_IMSC);
+	spin_unlock_irq(&uap->port.lock);
+
+	return 0;
+
+ out:
+	return retval;
+}
+
+static void pl011_shutdown(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned long val;
+
+	/**
+	 * disable all interrupts
+	 */
+	spin_lock_irq(&uap->port.lock);
+	uap->im = 0;
+	writel(uap->im, uap->port.membase + UART011_IMSC);
+	writel(0xffff, uap->port.membase + UART011_ICR);
+	spin_unlock_irq(&uap->port.lock);
+
+	/**
+	 * Free the interrupt
+	 */
+	free_irq(uap->port.irq, uap);
+
+	/**
+	 * disable the port
+	 */
+	writel(UART01x_CR_UARTEN |
+		UART011_CR_TXE, uap->port.membase + UART011_CR);
+
+	/**
+	 * disable break condition and fifos
+	 */
+	val = readl(uap->port.membase + UART011_LCRH);
+	val &= ~(UART01x_LCRH_BRK | UART01x_LCRH_FEN);
+	writel(val, uap->port.membase + UART011_LCRH);
+}
+
+static void
+pl011_set_termios(struct uart_port *port, struct ktermios *termios,
+		     struct ktermios *old)
+{
+	unsigned int lcr_h, old_cr;
+	unsigned long flags;
+	unsigned int baud, quot;
+
+	/**
+	 * Ask the core to calculate the divisor for us.
+	 */
+	baud = uart_get_baud_rate(port, termios, old, 0,
port->uartclk/16);
+	quot = port->uartclk * 4 / baud;
+
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		lcr_h = UART01x_LCRH_WLEN_5;
+		break;
+	case CS6:
+		lcr_h = UART01x_LCRH_WLEN_6;
+		break;
+	case CS7:
+		lcr_h = UART01x_LCRH_WLEN_7;
+		break;
+	default:
+		lcr_h = UART01x_LCRH_WLEN_8;
+		break;
+	}
+	if (termios->c_cflag & CSTOPB)
+		lcr_h |= UART01x_LCRH_STP2;
+	if (termios->c_cflag & PARENB) {
+		lcr_h |= UART01x_LCRH_PEN;
+		if (!(termios->c_cflag & PARODD))
+			lcr_h |= UART01x_LCRH_EPS;
+	}
+	/** Enable hardware flow control*/
+	if (termios->c_cflag & CRTSCTS) {
+		if (*(int *)(port->private_data) == PL011_HWFC) {
+			lcr_h |= UART011_CR_CTSEN;
+			lcr_h |= UART011_CR_RTSEN;
+		}
+	}
+	if (port->fifosize > 1)
+		lcr_h |= UART01x_LCRH_FEN;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	/**
+	 * Update the per-port timeout.
+	 */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	port->read_status_mask = UART011_DR_OE | 255;
+	if (termios->c_iflag & INPCK)
+		port->read_status_mask |= UART011_DR_FE | UART011_DR_PE;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		port->read_status_mask |= UART011_DR_BE;
+
+	/**
+	 * Characters to ignore
+	 */
+	port->ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		port->ignore_status_mask |= UART011_DR_FE |
UART011_DR_PE;
+	if (termios->c_iflag & IGNBRK) {
+		port->ignore_status_mask |= UART011_DR_BE;
+		/**
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR)
+			port->ignore_status_mask |= UART011_DR_OE;
+	}
+
+	/**
+	 * Ignore all characters if CREAD is not set.
+	 */
+	if ((termios->c_cflag & CREAD) == 0)
+		port->ignore_status_mask |= UART_DUMMY_DR_RX;
+
+	if (UART_ENABLE_MS(port, termios->c_cflag))
+		pl011_enable_ms(port);
+
+	/** first, disable everything */
+	old_cr = readl(port->membase + UART011_CR);
+	writel(0, port->membase + UART011_CR);
+
+	/** Set baud rate */
+	writel(quot & 0x3f, port->membase + UART011_FBRD);
+	writel(quot >> 6, port->membase + UART011_IBRD);
+
+	/**
+	 * ----------v----------v----------v----------v-----
+	 * NOTE: MUST BE WRITTEN AFTER UARTLCR_M & UARTLCR_L
+	 * ----------^----------^----------^----------^-----
+	 */
+	writel(lcr_h, port->membase + UART011_LCRH);
+	writel(lcr_h, port->membase + 0x1c);
+	writel(old_cr, port->membase + UART011_CR);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static const char *pl011_type(struct uart_port *port)
+{
+	return port->type == PORT_AMBA ? "AMBA/PL011" : NULL;
+}
+
+/**
+ * Release the memory region(s) being used by 'port'
+ */
+static void pl011_release_port(struct uart_port *port)
+{
+	release_mem_region(port->mapbase, SZ_4K);
+}
+
+/**
+ * Request the memory region(s) being used by 'port'
+ */
+static int pl011_request_port(struct uart_port *port)
+{
+	return request_mem_region(port->mapbase, SZ_4K, "uart-pl011")
+			!= NULL ? 0 : -EBUSY;
+}
+
+/**
+ * Configure/autoconfigure the port.
+ */
+static void pl011_config_port(struct uart_port *port, int flags)
+{
+	if (flags & UART_CONFIG_TYPE) {
+		port->type = PORT_AMBA;
+		pl011_request_port(port);
+	}
+}
+
+/**
+ * verify the new serial_struct (for TIOCSSERIAL).
+ */
+static int pl011_verify_port(struct uart_port *port, struct
serial_struct *ser)
+{
+	int ret = 0;
+	if (ser->type != PORT_UNKNOWN && ser->type != PORT_AMBA)
+		ret = -EINVAL;
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
+		ret = -EINVAL;
+	if (ser->baud_base < 9600)
+		ret = -EINVAL;
+	return ret;
+}
+
+static struct uart_ops pci_pl011_pops = {
+	.tx_empty	= pl011_tx_empty,
+	.set_mctrl	= pl011_set_mctrl,
+	.get_mctrl	= pl011_get_mctrl,
+	.stop_tx	= pl011_stop_tx,
+	.start_tx	= pl011_start_tx,
+	.stop_rx	= pl011_stop_rx,
+	.enable_ms	= pl011_enable_ms,
+	.break_ctl	= pl011_break_ctl,
+	.startup	= pl011_startup,
+	.shutdown	= pl011_shutdown,
+	.set_termios	= pl011_set_termios,
+	.type		= pl011_type,
+	.release_port	= pl011_release_port,
+	.request_port	= pl011_request_port,
+	.config_port	= pl011_config_port,
+	.verify_port	= pl011_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = pl011_get_poll_char,
+	.poll_put_char = pl011_put_poll_char,
+#endif
+};
+
+static struct uart_amba_port *amba_ports[UART_NR];
+
+#ifdef CONFIG_SERIAL_PCI_PL011_CONSOLE
+
+static void pl011_console_putchar(struct uart_port *port, int ch)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+
+	while (readl(uap->port.membase + UART01x_FR) & UART01x_FR_TXFF)
+		barrier();
+	writel(ch, uap->port.membase + UART01x_DR);
+}
+
+static void
+pl011_console_write(struct console *co, const char *s, unsigned int
count)
+{
+	struct uart_amba_port *uap = amba_ports[co->index];
+	unsigned int status, old_cr, new_cr;
+	/**
+	 *	First save the CR then disable the interrupts
+	 */
+	old_cr = readl(uap->port.membase + UART011_CR);
+	new_cr = old_cr & ~UART011_CR_CTSEN;
+	new_cr |= UART01x_CR_UARTEN | UART011_CR_TXE;
+	writel(new_cr, uap->port.membase + UART011_CR);
+
+	uart_console_write(&uap->port, s, count, pl011_console_putchar);
+
+	/**
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the TCR
+	 */
+	do {
+		status = readl(uap->port.membase + UART01x_FR);
+	} while (status & UART01x_FR_BUSY);
+	writel(old_cr, uap->port.membase + UART011_CR);
+}
+
+static void __init
+pl011_console_get_options(struct uart_amba_port *uap, int *baud,
+			     int *parity, int *bits)
+{
+	if (readl(uap->port.membase + UART011_CR) & UART01x_CR_UARTEN) {
+		unsigned int lcr_h, iadapter, fadapter;
+
+		lcr_h = readl(uap->port.membase + UART011_LCRH);
+
+		*parity = 'n';
+		if (lcr_h & UART01x_LCRH_PEN) {
+			if (lcr_h & UART01x_LCRH_EPS)
+				*parity = 'e';
+			else
+				*parity = 'o';
+		}
+
+		if ((lcr_h & 0x60) == UART01x_LCRH_WLEN_7)
+			*bits = 7;
+		else
+			*bits = 8;
+
+		iadapter = readl(uap->port.membase + UART011_IBRD);
+		fadapter = readl(uap->port.membase + UART011_FBRD);
+
+		*baud = uap->port.uartclk * 4 / (64 * iadapter +
fadapter);
+	}
+}
+
+static int __init pl011_console_setup(struct console *co, char
*options)
+{
+	struct uart_amba_port *uap;
+	int baud = 38400;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	/**
+	 * Check whether an invalid uart number has been specified, and
+	 * if so, search for the first available port that does have
+	 * console support.
+	 */
+	if (co->index >= UART_NR)
+		co->index = 0;
+	uap = amba_ports[co->index];
+	if (!uap)
+		return -ENODEV;
+	uap->port.uartclk = UARTCLK;
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits,
&flow);
+	else
+		pl011_console_get_options(uap, &baud, &parity, &bits);
+
+	return uart_set_options(&uap->port, co, baud, parity, bits,
flow);
+}
+
+static struct uart_driver pci_pl011_uart_driver;
+static struct console amba_console = {
+	.name		= "ttyAM",
+	.write		= pl011_console_write,
+	.device		= uart_console_device,
+	.setup		= pl011_console_setup,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+	.data		= &pci_pl011_uart_driver,
+};
+
+#define AMBA_CONSOLE	(&amba_console)
+#else
+#define AMBA_CONSOLE	NULL
+#endif
+
+
+static struct uart_driver pci_pl011_uart_driver = {
+	.owner		= THIS_MODULE,
+	.driver_name	= PCI_PL011_DRIVER_NAME,
+	.dev_name	= "ttyAM",
+	.major		= PCI_PL011_MAJOR,
+	.minor		= PCI_PL011_MINOR_START,
+	.nr		= UART_NR,
+	.cons		= AMBA_CONSOLE,
+};
+
+static int __devinit
+pci_pl011_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int index, rc = 0;
+	struct pci_pl011_adapter *adapter, *tmp_adapter;
+	struct uart_amba_port *uap;
+	struct list_head *tmp;
+	int	pci_pl011_adapter_count = 0;
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_err(&pdev->dev, "Device enable FAILED\n");
+		goto out;
+	}
+
+	rc = pci_request_regions(pdev, "pci_pl011");
+	if (rc) {
+		dev_err(&pdev->dev, "pci_request_region FAILED\n");
+		goto out_disable_device;
+	}
+
+	pci_set_master(pdev);
+
+	adapter = kzalloc(sizeof(struct pci_pl011_adapter), GFP_KERNEL);
+	if (!adapter) {
+		dev_err(&pdev->dev,
+			"memory allocation for adapter structure
failed\n");
+		rc = -ENOMEM;
+		goto out_release_regions;
+	}
+	list_for_each(tmp, &pci_pl011_adapter_head) {
+		tmp_adapter = list_entry(tmp, struct pci_pl011_adapter,
+					 pci_pl011_adapter_entry);
+		if (tmp_adapter->index != pci_pl011_adapter_count)
+			break;
+		pci_pl011_adapter_count++;
+	}
+	adapter->index = pci_pl011_adapter_count;
+	list_add_tail(&adapter->pci_pl011_adapter_entry, tmp);
+
+	adapter->pci_dev = pdev;
+	if (pdev->device == PCI_DEVICE_ID_STMICRO_UART_HWFC)
+		adapter->type = PL011_HWFC;
+	else
+		adapter->type = PL011_NO_HWFC;
+	adapter->numb_ports = 1;
+
+	spin_lock_init(&adapter->intr_lock);
+
+	/** store which revision we have */
+	adapter->rev = pdev->revision;
+
+	adapter->irq = pdev->irq;
+
+	/** get the PCI Base Address Registers */
+	adapter->membase	= pci_resource_start(pdev, 0);
+	adapter->membase_end = pci_resource_end(pdev, 0);
+
+	if (adapter->membase & 1)
+		adapter->membase &= ~3;
+	else
+		adapter->membase &= ~15;
+
+
+	adapter->re_map_membase =
+		ioremap(adapter->membase, pci_resource_len(pdev, 0));
+	if (!adapter->re_map_membase) {
+		dev_err(&pdev->dev,
+			"Device has no PCI Memory resources, "
+			"failing adapter.\n");
+		rc = -ENOMEM;
+		goto out_kfree_adapter;
+	}
+
+	for (index = 0; index < adapter->numb_ports; index++) {
+		uap = &adapter->port_info[index];
+		uap->port.uartclk = UARTCLK;
+		if (IS_ERR(uap->clk)) {
+			rc = PTR_ERR(uap->clk);
+			goto out_iounmap;
+		}
+
+		uap->port.private_data = &adapter->type;
+		uap->port.mapbase = adapter->membase;
+		uap->port.membase = adapter->re_map_membase;
+		uap->port.iotype = UPIO_MEM;
+		uap->port.irq = adapter->irq;
+		uap->port.fifosize = vendor_st.fifosize;
+		uap->port.ops = &pci_pl011_pops;
+		uap->port.flags = UPF_BOOT_AUTOCONF;
+		uap->port.line = index + adapter->index *
adapter->numb_ports;
+		if (uart_add_one_port(&pci_pl011_uart_driver,
&uap->port))
+			printk(KERN_INFO "Added uart port Failed\n");
+		else
+			printk(KERN_INFO "Added uart port \n");
+		amba_ports[uap->port.line] = uap;
+	}
+
+	/** Log the information about the adapter */
+	dev_info(&pdev->dev, "adapter %d: (rev %d), irq %d\n",
+			pci_pl011_adapter_count, adapter->rev,
adapter->irq);
+
+	pci_set_drvdata(pdev, adapter);
+
+	return 0;
+
+ out_iounmap:
+	iounmap(adapter->re_map_membase);
+ out_kfree_adapter:
+	kfree(adapter);
+ out_release_regions:
+	pci_release_regions(pdev);
+ out_disable_device:
+	pci_disable_device(pdev);
+ out:
+	return rc;
+}
+
+static void __devexit pci_pl011_remove(struct pci_dev *pdev)
+{
+	struct pci_pl011_adapter *adapter = pci_get_drvdata(pdev);
+	int i = 0;
+
+
+	for (i = 0; i < adapter->numb_ports; i++)
+		uart_remove_one_port(&pci_pl011_uart_driver,
+			&adapter->port_info[i].port);
+
+	iounmap(adapter->re_map_membase);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	list_del(&adapter->pci_pl011_adapter_entry);
+	kfree(adapter);
+}
+
+static struct pci_device_id pci_pl011_pci_tbl[] = {
+	{
+		.vendor = PCI_VENDOR_ID_STMICRO,
+		.device = PCI_DEVICE_ID_STMICRO_UART_HWFC,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.driver_data = 0,
+	},
+	{
+		.vendor = PCI_VENDOR_ID_STMICRO,
+		.device = PCI_DEVICE_ID_STMICRO_UART_NO_HWFC,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.driver_data = 0,
+	},
+	{ },
+};
+
+static struct pci_driver pci_pl011_driver = {
+	.name		= "pci_pl011",
+	.id_table	= pci_pl011_pci_tbl,
+	.probe		= pci_pl011_probe,
+	.remove		= __devexit_p(pci_pl011_remove),
+};
+
+static int __init pci_pl011_init(void)
+{
+	int rc;
+
+	printk(KERN_INFO "Serial: PCI PL011 UART driver\n");
+
+	rc = uart_register_driver(&pci_pl011_uart_driver);
+	if (!rc) {
+		rc = pci_register_driver(&pci_pl011_driver);
+		if (rc)
+			uart_unregister_driver(&pci_pl011_uart_driver);
+	}
+	return rc;
+}
+
+static void __exit pci_pl011_exit(void)
+{
+	pci_unregister_driver(&pci_pl011_driver);
+	uart_unregister_driver(&pci_pl011_uart_driver);
+}
+
+module_init(pci_pl011_init);
+module_exit(pci_pl011_exit);
+
+MODULE_DESCRIPTION("Driver for the pl011 based on PCI");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("pl011-pci");
+MODULE_VERSION(DRV_VERSION);
-- 
1.6.0.4
