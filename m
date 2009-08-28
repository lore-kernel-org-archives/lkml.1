Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbZH1NuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbZH1NuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZH1NuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:50:22 -0400
Received: from mail-yw0-f184.google.com ([209.85.211.184]:61860 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZH1NuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=ArQqTVoz60gr0D4gMZxShftwd6YqLbCNsOgOD+ZnIYCdZiqmrRw8j+4IlPhfI9kuyz
         FJdEQEJeoIXXfY6ewaI2DsIQofnXwoHfGt//FmE1vDG059mZo6CivTpBIOET0E6yCq6D
         KWY/oL9FIkzKS6U3G4tfOoR6Id+OyNbPR3Tsg=
MIME-Version: 1.0
From: vimal singh <vimal.newwork@gmail.com>
Date: Fri, 28 Aug 2009 19:19:48 +0530
Message-ID: <ce9ab5790908280649n77765dedm9161316a181b6a07@mail.gmail.com>
Subject: [RFC][PATCH]: Adding support for omap-serail driver
To: linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Govindraj R <govindraj.raja@ti.com>

This patch adds support for OMAP3430-HIGH SPEED UART Controller.

It currently adds support for the following features.

        1. Supports Interrupt Mode for all three UARTs on SDP/ZOOM2.
        2. Supports DMA Mode for all three UARTs on SDP/ZOOM2.
        3. Supports Hardware flow control (CTS/RTS) on SDP/ZOOM2.
        4. Supports 3.6Mbps baudrate on SDP/ZOOM2.
        5. Debug Console support on all UARTs on SDP/ZOOM2.
        6. Support for quad uart on ZOOM2 board.

The reason for adding this new driver alternative to 8250 is to avoid
polluting 8250 driver with too many omap specific data as 8250 already
supports more than 16 different uart controllers and may need too
many omap-platform checks to implement feature like DMA support.

Signed-off-by: Govindraj R <govindraj.raja@ti.com>
---
 arch/arm/plat-omap/include/mach/omap-serial.h |   84 +
 drivers/serial/Kconfig                        |   92 +
 drivers/serial/Makefile                       |    1
 drivers/serial/omap-serial.c                  | 1431 ++++++++++++++++++++++++++
 4 files changed, 1608 insertions(+)

diff --git a/arch/arm/plat-omap/include/mach/omap-serial.h
b/arch/arm/plat-omap/include/mach/omap-serial.h
new file mode 100644
index 0000000..d1b0bf2
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/omap-serial.h
@@ -0,0 +1,84 @@
+/*
+ * arch/arm/plat-omap/include/mach/omap-serial.h
+ *
+ * Driver for OMAP3430 UART controller.
+ *
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ * Authors:
+ *	Thara Gopinath	<thara@ti.com>
+ *	Govindraj R	<govindraj.raja@ti.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef __OMAP_SERIAL_H__
+#define __OMAP_SERIAL_H__
+
+#include <linux/serial_core.h>
+#include <linux/platform_device.h>
+
+/* TI OMAP CONSOLE */
+#define PORT_OMAP       86
+
+#define DRIVER_NAME	"omap-hsuart"
+
+/*
+ * We default to IRQ0 for the "no irq" hack.   Some
+ * machine types want  others as well - they're free
+ * to redefine this in their header file.
+ */
+#define is_real_interrupt(irq)  ((irq) != 0)
+
+#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
+#ifdef CONFIG_ARCH_OMAP34XX
+#define OMAP_MDR1_DISABLE 	0x07
+#define OMAP_MDR1_MODE13X 	0x03
+#define OMAP_MDR1_MODE16X 	0x00
+#define OMAP_MODE13X_SPEED	230400
+#endif
+
+#define CONSOLE_NAME	"console="
+
+#define UART_CLK	(48000000)
+#define QUART_CLK	(1843200)
+
+/* UART NUMBERS */
+#define UART1		(0x0)
+#define UART2		(0x1)
+#define UART3		(0x2)
+#define QUART		(0x3)
+
+#ifdef CONFIG_MACH_OMAP_ZOOM2
+#define MAX_UARTS	QUART
+#else
+#define MAX_UARTS	UART3
+#endif
+
+#define UART_BASE(uart_no)		(uart_no == UART1) ? OMAP_UART1_BASE :\
+					(uart_no == UART2) ? OMAP_UART2_BASE :\
+					 OMAP_UART3_BASE
+
+#define UART_MODULE_BASE(uart_no)	(UART1 == uart_no ? \
+						IO_ADDRESS(OMAP_UART1_BASE) :\
+					(UART2 == uart_no ? \
+						IO_ADDRESS(OMAP_UART2_BASE) :\
+						IO_ADDRESS(OMAP_UART3_BASE)))
+extern unsigned int fcr[MAX_UARTS];
+extern char *saved_command_line;
+
+struct plat_serialomap_port {
+	void __iomem    *membase;       /* ioremap cookie or NULL */
+	 resource_size_t mapbase;       /* resource base */
+	unsigned int    irq;            /* interrupt number */
+	unsigned char   regshift;       /* register shift */
+	upf_t           flags;          /* UPF_* flags */
+	void            *private_data;
+};
+
+#endif /* __OMAP_SERIAL_H__ */
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 037c1e0..906fb61 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1359,6 +1359,98 @@ config SERIAL_OF_PLATFORM
 	  Currently, only 8250 compatible ports are supported, but
 	  others can easily be added.

+config SERIAL_OMAP
+	bool "OMAP serial port support"
+	depends on ARM && ARCH_OMAP
+	select SERIAL_CORE
+	help
+	If you have a machine based on an Texas Instruments OMAP CPU you
+	can enable its onboard serial ports by enabling this option.
+
+config SERIAL_OMAP_CONSOLE
+	bool "Console on OMAP serial port"
+	depends on SERIAL_OMAP
+	select SERIAL_CORE_CONSOLE
+	help
+	If you have enabled the serial port on the Texas Instruments OMAP
+	CPU you can make it the console by answering Y to this option.
+
+	Even if you say Y here, the currently visible virtual console
+	(/dev/tty0) will still be used as the system console by default, but
+	you can alter that using a kernel command line option such as
+	"console=ttyS0". (Try "man bootparam" or see the documentation of
+	your boot loader (lilo or loadlin) about how to pass options to the
+	kernel at boot time.)
+
+config SERIAL_OMAP_DMA_UART1
+	bool "UART1 DMA support"
+	depends on SERIAL_OMAP
+	help
+	If you have enabled the serial port on the Texas Instruments OMAP
+	CPU you can enable the DMA transfer on UART 1 by answering
+	 to this option.
+
+config SERIAL_OMAP_UART1_RXDMA_TIMEOUT
+	int "Timeout value for RX DMA in microseconds"
+	depends on SERIAL_OMAP_DMA_UART1
+	default "1"
+	help
+	  Set the timeout value in which you want the data pulled by RX dma to
+	  be passed to the tty framework.
+
+config SERIAL_OMAP_UART1_RXDMA_BUFSIZE
+	int "DMA buffer size for RX in bytes"
+	depends on SERIAL_OMAP_DMA_UART1
+	default "4096"
+	help
+	  Set the dma buffer size for UART Rx
+
+config SERIAL_OMAP_DMA_UART2
+	bool "UART2 DMA support"
+	depends on SERIAL_OMAP
+	help
+	  If you have enabled the serial port on the Texas Instruments OMAP
+	  CPU you can enable the DMA transfer on UART 2 by answering
+	  to this option.
+
+config SERIAL_OMAP_UART2_RXDMA_TIMEOUT
+	int "Timeout value for RX DMA in microseconds"
+	depends on SERIAL_OMAP_DMA_UART2
+	default "1"
+	help
+	  Set the timeout value in which you want the data pulled by RX dma to
+	  be passed to the tty framework.
+
+config SERIAL_OMAP_UART2_RXDMA_BUFSIZE
+	int "DMA buffer size for RX in bytes"
+	depends on SERIAL_OMAP_DMA_UART2
+	default "4096"
+	help
+	  Set the dma buffer size for UART Rx
+
+config SERIAL_OMAP_DMA_UART3
+	bool "UART3 DMA support"
+	depends on SERIAL_OMAP
+	help
+	  If you have enabled the serial port on the Texas Instruments OMAP
+	  CPU you can enable the DMA transfer on UART 3 by answering
+	  to this option.
+
+config SERIAL_OMAP_UART3_RXDMA_TIMEOUT
+	int "Timeout value for RX DMA in microseconds"
+	depends on SERIAL_OMAP_DMA_UART3
+	default "1"
+	help
+	  Set the timeout value in which you want the data pulled by RX dma to
+	  be passed to the tty framework.
+
+config SERIAL_OMAP_UART3_RXDMA_BUFSIZE
+	int "DMA buffer size for RX in bytes"
+	depends on SERIAL_OMAP_DMA_UART3
+	default "4096"
+	help
+	  Set the dma buffer size for UART Rx
+
 config SERIAL_OF_PLATFORM_NWPSERIAL
 	tristate "NWP serial port driver"
 	depends on PPC_OF && PPC_DCR
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index d5a2998..db38f2c 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -79,3 +79,4 @@ obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
 obj-$(CONFIG_KGDB_SERIAL_CONSOLE) += kgdboc.o
 obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
 obj-$(CONFIG_SERIAL_TIMBERDALE)	+= timbuart.o
+obj-$(CONFIG_SERIAL_OMAP) += omap-serial.o
diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
new file mode 100644
index 0000000..3b84740
--- /dev/null
+++ b/drivers/serial/omap-serial.c
@@ -0,0 +1,1431 @@
+/*
+ * drivers/serial/omap-serial.c
+ *
+ * Driver for OMAP3430 UART controller.
+ *
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ * Authors:
+ *	Thara Gopinath	<thara@ti.com>
+ *	Govindraj R	<govindraj.raja@ti.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/serial_reg.h>
+#include <linux/delay.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+
+#include <asm/irq.h>
+#include <mach/dma.h>
+#include <mach/dmtimer.h>
+#include <mach/omap-serial.h>
+
+#ifdef DEBUG
+#define DPRINTK  printk
+#else
+#define DPRINTK(x...)
+#endif
+
+static u8 uart_dma_tx[MAX_UARTS + 1] =
+	{OMAP24XX_DMA_UART1_TX, OMAP24XX_DMA_UART2_TX, OMAP24XX_DMA_UART3_TX};
+static u8 uart_dma_rx[MAX_UARTS + 1] =
+	{OMAP24XX_DMA_UART1_RX, OMAP24XX_DMA_UART2_RX, OMAP24XX_DMA_UART3_RX};
+
+struct uart_omap_dma {
+	int rx_dma_channel;
+	int tx_dma_channel;
+	dma_addr_t rx_buf_dma_phys;	/* Physical adress of RX DMA buffer */
+	dma_addr_t tx_buf_dma_phys;	/* Physical adress of TX DMA buffer */
+	/*
+	 * Buffer for rx dma.It is not required for tx because the buffer
+	 * comes from port structure
+	 */
+	unsigned char *rx_buf;
+	unsigned int prev_rx_dma_pos;
+	int tx_buf_size;
+	int tx_dma_state;
+	int rx_dma_state;
+	spinlock_t tx_lock;
+	spinlock_t rx_lock;
+	struct timer_list 	rx_timer;/* timer to poll activity on rx dma */
+	int rx_buf_size;
+	int rx_timeout;
+};
+
+struct uart_omap_port {
+	struct uart_port	port;
+	struct uart_omap_dma	uart_dma;
+	struct platform_device	*pdev;
+
+	unsigned char		ier;
+	unsigned char		lcr;
+	unsigned char		mcr;
+	int			use_dma;
+	int			is_buf_dma_alloced;
+	/*
+	 * Some bits in registers are cleared on a read, so they must
+	 * be saved whenever the register is read but the bits will not
+	 * be immediately processed.
+	 */
+	unsigned int		lsr_break_flag;
+#define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
+	unsigned char		msr_saved_flags;
+	char			name[20];
+	spinlock_t		uart_lock;
+};
+
+static struct uart_omap_port *ui[MAX_UARTS + 1];
+unsigned int fcr[MAX_UARTS];
+unsigned long up_activity;
+
+/* Forward declaration of dma callback functions */
+static void uart_tx_dma_callback(int lch, u16 ch_status, void *data);
+#ifdef DEBUG
+static void serial_omap_display_reg(struct uart_port *port);
+#endif
+static void serial_omap_rx_timeout(unsigned long uart_no);
+static void serial_omap_start_rxdma(struct uart_omap_port *up);
+
+int console_detect(char *str)
+{
+	char *next, *start = NULL;
+	int i;
+
+	i = strlen(CONSOLE_NAME);
+	next = saved_command_line;
+
+	while ((next = strchr(next, 'c')) != NULL) {
+		if (!strncmp(next, CONSOLE_NAME, i)) {
+			start = next;
+			break;
+		} else
+			next++;
+	}
+	if (!start)
+		return -EPERM;
+	i = 0;
+	start = strchr(start, '=') + 1;
+	while (*start != ',') {
+		str[i++] = *start++;
+		if (i > 6) {
+			printk(KERN_INFO "Invalid Console Name\n");
+			return -EPERM;
+		}
+	}
+	str[i] = '\0';
+	return 0;
+}
+
+static inline unsigned int serial_in(struct uart_omap_port *up, int offset)
+{
+	offset <<= up->port.regshift;
+	if (up->pdev->id != 4)
+		return readb(up->port.membase + offset);
+	else
+		return readw(up->port.membase + offset);
+}
+
+static inline void serial_out(struct uart_omap_port *up, int offset, int value)
+{
+	offset <<= up->port.regshift;
+	if (up->pdev->id != 4)
+		writeb(value, up->port.membase + offset);
+	else
+		writew(value, up->port.membase + offset);
+}
+
+static inline void serial_omap_clear_fifos(struct uart_omap_port *p)
+{
+		serial_out(p, UART_FCR, UART_FCR_ENABLE_FIFO);
+		serial_out(p, UART_FCR, UART_FCR_ENABLE_FIFO |
+			       UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
+		serial_out(p, UART_FCR, 0);
+		fcr[p->pdev->id - 1] = 0;
+}
+
+/*
+ * We have written our own function to get the divisor so as to support
+ * 13x mode.
+ */
+static unsigned int
+serial_omap_get_divisor(struct uart_port *port, unsigned int baud)
+{
+	unsigned int divisor;
+	if (baud > OMAP_MODE13X_SPEED && baud != 3000000)
+		divisor = 13;
+	else
+		divisor = 16;
+	return port->uartclk/(baud * divisor);
+}
+
+static void serial_omap_stop_rxdma(struct uart_omap_port *up)
+{
+	if (up->uart_dma.rx_dma_state) {
+		del_timer_sync(&up->uart_dma.rx_timer);
+		omap_stop_dma(up->uart_dma.rx_dma_channel);
+		omap_free_dma(up->uart_dma.rx_dma_channel);
+		up->uart_dma.rx_dma_channel = 0xFF;
+		up->uart_dma.rx_dma_state = 0x0;
+	}
+}
+
+static void serial_omap_enable_ms(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+
+	DPRINTK("serial_omap_enable_ms+%d\n", up->pdev->id);
+	up->ier |= UART_IER_MSI;
+	serial_out(up, UART_IER, up->ier);
+}
+
+static void serial_omap_stop_tx(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	if (up->use_dma) {
+		if (up->uart_dma.tx_dma_channel != 0xFF) {
+			/*
+			 * Check if dma is still active . If yes do nothing,
+			 * return. Else stop dma
+			 */
+			int status = omap_readl(OMAP34XX_DMA4_BASE +
+				    OMAP_DMA4_CCR(up->uart_dma.tx_dma_channel));
+			if (status & (1 << 7))
+				return;
+			omap_stop_dma(up->uart_dma.tx_dma_channel);
+			omap_free_dma(up->uart_dma.tx_dma_channel);
+			up->uart_dma.tx_dma_channel = 0xFF;
+		}
+	}
+
+	if (up->ier & UART_IER_THRI) {
+		up->ier &= ~UART_IER_THRI;
+		serial_out(up, UART_IER, up->ier);
+	}
+#ifdef CONFIG_PM
+	if (!up->uart_dma.rx_dma_state) {
+		unsigned int tmp;
+		tmp = (serial_in(up, UART_OMAP_SYSC) & 0x7) | (2 << 3);
+		serial_out(up, UART_OMAP_SYSC, tmp); /* smart-idle */
+	}
+#endif
+}
+
+static void serial_omap_stop_rx(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	serial_omap_stop_rxdma(up);
+	up->ier &= ~UART_IER_RLSI;
+	up->port.read_status_mask &= ~UART_LSR_DR;
+	serial_out(up, UART_IER, up->ier);
+
+}
+
+static inline void receive_chars(struct uart_omap_port *up, int *status)
+{
+	struct tty_struct *tty = up->port.info->port.tty;
+	unsigned int ch, flag;
+	int max_count = 256;
+
+	do {
+		ch = serial_in(up, UART_RX);
+		flag = TTY_NORMAL;
+		up->port.icount.rx++;
+
+		if (unlikely(*status & (UART_LSR_BI | UART_LSR_PE |
+				       UART_LSR_FE | UART_LSR_OE))) {
+			/*
+			 * For statistics only
+			 */
+			if (*status & UART_LSR_BI) {
+				*status &= ~(UART_LSR_FE | UART_LSR_PE);
+				up->port.icount.brk++;
+				/*
+				 * We do the SysRQ and SAK checking
+				 * here because otherwise the break
+				 * may get masked by ignore_status_mask
+				 * or read_status_mask.
+				 */
+				if (uart_handle_break(&up->port))
+					goto ignore_char;
+			} else if (*status & UART_LSR_PE)
+				up->port.icount.parity++;
+			else if (*status & UART_LSR_FE)
+				up->port.icount.frame++;
+			if (*status & UART_LSR_OE)
+				up->port.icount.overrun++;
+
+			/*
+			 * Mask off conditions which should be ignored.
+			 */
+			*status &= up->port.read_status_mask;
+
+#ifdef CONFIG_SERIAL_OMAP_CONSOLE
+			if (up->port.line == up->port.cons->index) {
+				/* Recover the break flag from console xmit */
+				*status |= up->lsr_break_flag;
+				up->lsr_break_flag = 0;
+			}
+#endif
+			if (*status & UART_LSR_BI)
+				flag = TTY_BREAK;
+			else if (*status & UART_LSR_PE)
+				flag = TTY_PARITY;
+			else if (*status & UART_LSR_FE)
+				flag = TTY_FRAME;
+		}
+
+		if (uart_handle_sysrq_char(&up->port, ch))
+			goto ignore_char;
+
+		uart_insert_char(&up->port, *status, UART_LSR_OE, ch, flag);
+
+ignore_char:
+		*status = serial_in(up, UART_LSR);
+	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
+	tty_flip_buffer_push(tty);
+
+
+}
+
+static void transmit_chars(struct uart_omap_port *up)
+{
+	struct circ_buf *xmit = &up->port.info->xmit;
+	int count;
+
+	if (up->port.x_char) {
+		serial_out(up, UART_TX, up->port.x_char);
+		up->port.icount.tx++;
+		up->port.x_char = 0;
+		return;
+	}
+	if (uart_circ_empty(xmit) || uart_tx_stopped(&up->port)) {
+		serial_omap_stop_tx(&up->port);
+		return;
+	}
+
+	count = up->port.fifosize / 4;
+	do {
+		serial_out(up, UART_TX, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		up->port.icount.tx++;
+		if (uart_circ_empty(xmit))
+			break;
+	} while (--count > 0);
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&up->port);
+
+	if (uart_circ_empty(xmit))
+		serial_omap_stop_tx(&up->port);
+}
+
+static void serial_omap_start_tx(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+#ifdef CONFIG_PM
+		/* Disallow OCP bus idle. UART TX irqs are not seen during
+		 * bus idle. Alternative is to set kernel timer at fifo
+		 * drain rate.
+		 */
+		unsigned int tmp;
+		tmp = (serial_in(up, UART_OMAP_SYSC) & 0x7) | (1 << 3);
+		serial_out(up, UART_OMAP_SYSC, tmp); /* no-idle */
+#endif
+
+	if (up->use_dma && !(up->port.x_char)) {
+
+		struct circ_buf *xmit = &up->port.info->xmit;
+		unsigned int start = up->uart_dma.tx_buf_dma_phys +
+				     (xmit->tail & (UART_XMIT_SIZE - 1));
+		if (uart_circ_empty(xmit) || up->uart_dma.tx_dma_state)
+			return;
+		spin_lock(&(up->uart_dma.tx_lock));
+		up->uart_dma.tx_dma_state = 1;
+		spin_unlock(&(up->uart_dma.tx_lock));
+
+		up->uart_dma.tx_buf_size = uart_circ_chars_pending(xmit);
+		/* It is a circular buffer. See if the buffer has wounded back.
+		 * If yes it will have to be transferred in two separate dma
+		 * transfers */
+		if (start + up->uart_dma.tx_buf_size >=
+				up->uart_dma.tx_buf_dma_phys + UART_XMIT_SIZE)
+			up->uart_dma.tx_buf_size =
+				(up->uart_dma.tx_buf_dma_phys +
+				UART_XMIT_SIZE) - start;
+
+		if (up->uart_dma.tx_dma_channel == 0xFF)
+			omap_request_dma(uart_dma_tx[up->pdev->id-1],
+					"UART Tx DMA",
+					(void *)uart_tx_dma_callback, up,
+					&(up->uart_dma.tx_dma_channel));
+		omap_set_dma_dest_params(up->uart_dma.tx_dma_channel, 0,
+					 OMAP_DMA_AMODE_CONSTANT,
+					 UART_BASE(up->pdev->id - 1), 0, 0);
+		omap_set_dma_src_params(up->uart_dma.tx_dma_channel, 0,
+					OMAP_DMA_AMODE_POST_INC, start, 0, 0);
+
+		omap_set_dma_transfer_params(up->uart_dma.tx_dma_channel,
+					     OMAP_DMA_DATA_TYPE_S8,
+					     up->uart_dma.tx_buf_size, 1,
+					     OMAP_DMA_SYNC_ELEMENT,
+					     uart_dma_tx[(up->pdev->id)-1], 0);
+
+		omap_start_dma(up->uart_dma.tx_dma_channel);
+
+	} else if (!(up->ier & UART_IER_THRI)) {
+		up->ier |= UART_IER_THRI;
+		serial_out(up, UART_IER, up->ier);
+	}
+}
+
+static unsigned int check_modem_status(struct uart_omap_port *up)
+{
+	int status;
+	status = serial_in(up, UART_MSR);
+
+	status |= up->msr_saved_flags;
+	up->msr_saved_flags = 0;
+
+	if ((status & UART_MSR_ANY_DELTA) == 0)
+		return status;
+	if (status & UART_MSR_ANY_DELTA && up->ier & UART_IER_MSI &&
+	    up->port.info != NULL) {
+		if (status & UART_MSR_TERI)
+			up->port.icount.rng++;
+		if (status & UART_MSR_DDSR)
+			up->port.icount.dsr++;
+		if (status & UART_MSR_DDCD)
+			uart_handle_dcd_change
+				(&up->port, status & UART_MSR_DCD);
+		if (status & UART_MSR_DCTS)
+			uart_handle_cts_change
+				(&up->port, status & UART_MSR_CTS);
+		wake_up_interruptible(&up->port.info->delta_msr_wait);
+	}
+
+	return status;
+}
+
+/*
+ * This handles the interrupt from one port.
+ */
+static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
+{
+	struct uart_omap_port *up = dev_id;
+	unsigned int iir, lsr;
+
+	iir = serial_in(up, UART_IIR);
+	if (iir & UART_IIR_NO_INT)
+		return IRQ_NONE;
+	lsr = serial_in(up, UART_LSR);
+	if ((iir & 0x4) && up->use_dma) {
+		up->ier &= ~UART_IER_RDI;
+		serial_out(up, UART_IER, up->ier);
+		serial_omap_start_rxdma(up);
+	} else if (lsr & UART_LSR_DR)
+		receive_chars(up, &lsr);
+	check_modem_status(up);
+	if ((lsr & UART_LSR_THRE) && (iir & 0x2))
+		transmit_chars(up);
+	up_activity = jiffies;
+
+	return IRQ_HANDLED;
+}
+
+static unsigned int serial_omap_tx_empty(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned long flags;
+	unsigned int ret;
+
+	DPRINTK("serial_omap_tx_empty+%d\n", up->pdev->id);
+	spin_lock_irqsave(&up->port.lock, flags);
+	ret = serial_in(up, UART_LSR) & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	return ret;
+}
+
+static unsigned int serial_omap_get_mctrl(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned char status;
+	unsigned int ret;
+
+	status = check_modem_status(up);
+	DPRINTK("serial_omap_get_mctrl+%d\n", up->pdev->id);
+
+	ret = 0;
+	if (status & UART_MSR_DCD)
+		ret |= TIOCM_CAR;
+	if (status & UART_MSR_RI)
+		ret |= TIOCM_RNG;
+	if (status & UART_MSR_DSR)
+		ret |= TIOCM_DSR;
+	if (status & UART_MSR_CTS)
+		ret |= TIOCM_CTS;
+	return ret;
+}
+
+static void serial_omap_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned char mcr = 0;
+
+	DPRINTK("serial_omap_set_mctrl+%d\n", up->pdev->id);
+	if (mctrl & TIOCM_RTS)
+		mcr |= UART_MCR_RTS;
+	if (mctrl & TIOCM_DTR)
+		mcr |= UART_MCR_DTR;
+	if (mctrl & TIOCM_OUT1)
+		mcr |= UART_MCR_OUT1;
+	if (mctrl & TIOCM_OUT2)
+		mcr |= UART_MCR_OUT2;
+	if (mctrl & TIOCM_LOOP)
+		mcr |= UART_MCR_LOOP;
+
+	mcr |= up->mcr;
+	serial_out(up, UART_MCR, mcr);
+}
+
+static void serial_omap_break_ctl(struct uart_port *port, int break_state)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned long flags;
+
+	DPRINTK("serial_omap_break_ctl+%d\n", up->pdev->id);
+	spin_lock_irqsave(&up->port.lock, flags);
+	if (break_state == -1)
+		up->lcr |= UART_LCR_SBC;
+	else
+		up->lcr &= ~UART_LCR_SBC;
+	serial_out(up, UART_LCR, up->lcr);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
+static int serial_omap_startup(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned long flags;
+	int irq_flags = 0;
+	int retval;
+
+	/* Zoom2 has GPIO_102 connected to Serial device:
+	 * Active High
+	 */
+	if (up->port.flags & UPF_IOREMAP)
+		irq_flags |= IRQF_TRIGGER_HIGH;
+
+	if (up->port.flags & UPF_SHARE_IRQ)
+		irq_flags |= IRQF_SHARED;
+
+	/*
+	 * Allocate the IRQ
+	 */
+	retval = request_irq(up->port.irq, serial_omap_irq, irq_flags,
+				up->name, up);
+	if (retval)
+		return retval;
+	DPRINTK("serial_omap_startup+%d\n", up->pdev->id);
+	/*
+	 * Stop the baud clock and disable the UART. UART will be enabled
+	 * back in set_termios. This is essential for DMA mode operations.
+	 */
+	serial_out(up, UART_LCR, UART_LCR_DLAB);
+	serial_out(up, UART_DLL, 0);
+	serial_out(up, UART_DLM, 0);
+	serial_out(up, UART_LCR, 0);
+	serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_DISABLE);
+
+	/*
+	 * Clear the FIFO buffers and disable them.
+	 * (they will be reenabled in set_termios())
+	 */
+	serial_omap_clear_fifos(up);
+	serial_out(up, UART_SCR, 0x00);
+	/* For Hardware flow control */
+	serial_out(up, UART_MCR, 0x2);
+
+	/*
+	 * Clear the interrupt registers.
+	 */
+	(void) serial_in(up, UART_LSR);
+	(void) serial_in(up, UART_RX);
+	(void) serial_in(up, UART_IIR);
+	(void) serial_in(up, UART_MSR);
+	/*
+	 * Now, initialize the UART
+	 */
+	serial_out(up, UART_LCR, UART_LCR_WLEN8);
+	spin_lock_irqsave(&up->port.lock, flags);
+	if (up->port.flags & UPF_FOURPORT) {
+		if (!is_real_interrupt(up->port.irq))
+			up->port.mctrl |= TIOCM_OUT1;
+	} else {
+		/*
+		 * Most PC uarts need OUT2 raised to enable interrupts.
+		 */
+		if (is_real_interrupt(up->port.irq))
+			up->port.mctrl |= TIOCM_OUT2;
+	}
+	serial_omap_set_mctrl(&up->port, up->port.mctrl);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	up->msr_saved_flags = 0;
+
+	if (up->port.flags & UPF_FOURPORT) {
+		unsigned int icp;
+		/*
+		 * Enable interrupts on the AST Fourport board
+		 */
+		icp = (up->port.iobase & 0xfe0) | 0x01f;
+		outb_p(0x80, icp);
+		(void) inb_p(icp);
+	}
+	if (up->use_dma) {
+		if (!up->is_buf_dma_alloced) {
+			free_page((unsigned long)up->port.info->xmit.buf);
+			up->port.info->xmit.buf = NULL;
+			up->port.info->xmit.buf = dma_alloc_coherent(NULL,
+				UART_XMIT_SIZE,
+				(dma_addr_t *)&(up->uart_dma.tx_buf_dma_phys),
+				0);
+			up->is_buf_dma_alloced = 1;
+		}
+		init_timer(&(up->uart_dma.rx_timer));
+		up->uart_dma.rx_timer.function = serial_omap_rx_timeout;
+		up->uart_dma.rx_timer.data = up->pdev->id;
+		/* Currently the buffer size is 4KB. Can increase it later*/
+		up->uart_dma.rx_buf = dma_alloc_coherent(NULL,
+			up->uart_dma.rx_buf_size,
+			(dma_addr_t *)&(up->uart_dma.rx_buf_dma_phys), 0);
+	}
+		/*
+		* Finally, enable interrupts.  Note: Modem status interrupts
+		* are set via set_termios(), which will be occurring imminently
+		* anyway, so we don't enable them here.
+		*/
+		up->ier = UART_IER_RLSI | UART_IER_RDI;
+		serial_out(up, UART_IER, up->ier);
+
+	up_activity = jiffies;
+	return 0;
+}
+
+static void serial_omap_shutdown(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned long flags;
+
+	DPRINTK("serial_omap_shutdown+%d\n", up->pdev->id);
+	/*
+	 * Disable interrupts from this port
+	 */
+	up->ier = 0;
+	serial_out(up, UART_IER, 0);
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	if (up->port.flags & UPF_FOURPORT) {
+		/* reset interrupts on the AST Fourport board */
+		inb((up->port.iobase & 0xfe0) | 0x1f);
+		up->port.mctrl |= TIOCM_OUT1;
+	} else
+		up->port.mctrl &= ~TIOCM_OUT2;
+	serial_omap_set_mctrl(&up->port, up->port.mctrl);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	/*
+	 * Disable break condition and FIFOs
+	 */
+	serial_out(up, UART_LCR, serial_in(up, UART_LCR) & ~UART_LCR_SBC);
+	serial_omap_clear_fifos(up);
+
+	/*
+	 * Read data port to reset things, and then free the irq
+	 */
+	(void) serial_in(up, UART_RX);
+	if (up->use_dma) {
+		int tmp;
+		if (up->is_buf_dma_alloced) {
+			dma_free_coherent(up->port.dev,
+				  UART_XMIT_SIZE,
+				  up->port.info->xmit.buf,
+				  up->uart_dma.tx_buf_dma_phys);
+			up->port.info->xmit.buf = NULL;
+			up->is_buf_dma_alloced = 0;
+		}
+		serial_omap_stop_rx(port);
+		dma_free_coherent(up->port.dev,
+				  up->uart_dma.rx_buf_size,
+				  up->uart_dma.rx_buf,
+				  up->uart_dma.rx_buf_dma_phys);
+		up->uart_dma.rx_buf = NULL;
+		tmp = serial_in(up, UART_OMAP_SYSC) & 0x7;
+		serial_out(up, UART_OMAP_SYSC, tmp); /* force-idle */
+	}
+
+	free_irq(up->port.irq, up);
+}
+
+static void
+serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
+			struct ktermios *old)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned char cval;
+	unsigned char efr = 0;
+	unsigned long flags;
+	unsigned int baud, quot;
+
+	serial_out(up, UART_LCR, UART_LCR_DLAB);
+	serial_out(up, UART_DLL, 0);
+	serial_out(up, UART_DLM, 0);
+	serial_out(up, UART_LCR, 0);
+	serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_DISABLE);
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		cval = UART_LCR_WLEN5;
+		break;
+	case CS6:
+		cval = UART_LCR_WLEN6;
+		break;
+	case CS7:
+		cval = UART_LCR_WLEN7;
+		break;
+	default:
+	case CS8:
+		cval = UART_LCR_WLEN8;
+		break;
+	}
+
+	if (termios->c_cflag & CSTOPB)
+		cval |= UART_LCR_STOP;
+	if (termios->c_cflag & PARENB)
+		cval |= UART_LCR_PARITY;
+	if (!(termios->c_cflag & PARODD))
+		cval |= UART_LCR_EPAR;
+
+	/*
+	 * Ask the core to calculate the divisor for us.
+	 */
+
+	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/13);
+	quot = serial_omap_get_divisor(port, baud);
+
+	if (up->use_dma)
+		fcr[up->pdev->id - 1] = UART_FCR_ENABLE_FIFO
+					| 0x1 << 6 | 0x1 << 4
+					| UART_FCR_DMA_SELECT;
+	else
+		fcr[up->pdev->id - 1] = UART_FCR_ENABLE_FIFO
+					| 0x1 << 6 | 0x1 << 4;
+
+	/*
+	 * Ok, we're now changing the port state.  Do it with
+	 * interrupts disabled.
+	 */
+	spin_lock_irqsave(&up->port.lock, flags);
+
+	/*
+	 * Update the per-port timeout.
+	 */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	up->port.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
+	if (termios->c_iflag & INPCK)
+		up->port.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		up->port.read_status_mask |= UART_LSR_BI;
+
+	/*
+	 * Characters to ignore
+	 */
+	up->port.ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		up->port.ignore_status_mask |= UART_LSR_PE | UART_LSR_FE;
+	if (termios->c_iflag & IGNBRK) {
+		up->port.ignore_status_mask |= UART_LSR_BI;
+		/*
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR)
+			up->port.ignore_status_mask |= UART_LSR_OE;
+	}
+
+	/*
+	 * ignore all characters if CREAD is not set
+	 */
+	if ((termios->c_cflag & CREAD) == 0)
+		up->port.ignore_status_mask |= UART_LSR_DR;
+
+	/*
+	 * CTS flow control flag and modem status interrupts
+	 */
+	up->ier &= ~UART_IER_MSI;
+	if (UART_ENABLE_MS(&up->port, termios->c_cflag))
+		up->ier |= UART_IER_MSI;
+	serial_out(up, UART_IER, up->ier);
+
+	if (termios->c_cflag & CRTSCTS)
+		efr |= (UART_EFR_CTS | UART_EFR_RTS);
+
+	serial_out(up, UART_LCR, cval | UART_LCR_DLAB);	/* set DLAB */
+	serial_out(up, UART_DLL, quot & 0xff);		/* LS of divisor */
+	serial_out(up, UART_DLM, quot >> 8);		/* MS of divisor */
+
+	serial_out(up, UART_LCR, cval);		/* reset DLAB */
+	up->lcr = cval;				/* Save LCR */
+	if (up->use_dma)
+		serial_out(up, UART_OMAP_SCR  , ((1 << 6) | (1 << 7)));
+
+	serial_out(up, UART_LCR, 0xbf);		/* Access EFR */
+	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, UART_LCR, 0x0);		/* Access FCR */
+	serial_out(up, UART_FCR, fcr[up->pdev->id - 1]);
+	serial_out(up, UART_LCR, 0xbf);		/* Access EFR */
+	serial_out(up, UART_EFR, efr);
+	serial_out(up, UART_LCR, cval);		/* Restore LCR */
+
+	serial_omap_set_mctrl(&up->port, up->port.mctrl);
+	/*
+	 * Clear all the status registers and RX register before
+	 * enabling UART
+	 */
+	(void) serial_in(up, UART_LSR);
+	(void) serial_in(up, UART_RX);
+	(void) serial_in(up, UART_IIR);
+	(void) serial_in(up, UART_MSR);
+
+	if (baud > 230400 && baud != 3000000)
+		serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_MODE13X);
+	else if (baud == 3000000)
+		serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_MODE16X);
+	else
+		serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_MODE16X);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	DPRINTK("serial_omap_set_termios+%d\n", up->pdev->id);
+#ifdef DEBUG
+	serial_omap_display_reg(port);
+#endif
+}
+
+static void
+serial_omap_pm(struct uart_port *port, unsigned int state,
+	       unsigned int oldstate)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned char efr;
+	DPRINTK("serial_omap_pm+%d\n", up->pdev->id);
+	efr = serial_in(up, UART_EFR);
+	serial_out(up, UART_LCR, 0xBF);
+	serial_out(up, UART_EFR, efr | UART_EFR_ECB);
+	serial_out(up, UART_LCR, 0);
+
+	serial_out(up, UART_IER, (state != 0) ? UART_IERX_SLEEP : 0);
+	serial_out(up, UART_LCR, 0xBF);
+	serial_out(up, UART_EFR, efr);
+	serial_out(up, UART_LCR, 0);
+}
+
+static void serial_omap_release_port(struct uart_port *port)
+{
+	DPRINTK("serial_omap_release_port+\n");
+}
+
+static int serial_omap_request_port(struct uart_port *port)
+{
+	DPRINTK("serial_omap_request_port+\n");
+	return 0;
+}
+
+static void serial_omap_config_port(struct uart_port *port, int flags)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+
+	DPRINTK("serial_omap_config_port+%d\n", up->pdev->id);
+	up->port.type = PORT_OMAP;
+}
+
+static int
+serial_omap_verify_port(struct uart_port *port, struct serial_struct *ser)
+{
+	/* we don't want the core code to modify any port params */
+	DPRINTK("serial_omap_verify_port+\n");
+	return -EINVAL;
+}
+
+static const char *
+serial_omap_type(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+
+	DPRINTK("serial_omap_type+%d\n", up->pdev->id);
+	return up->name;
+}
+
+#ifdef CONFIG_SERIAL_OMAP_CONSOLE
+
+static struct uart_omap_port *serial_omap_console_ports[4];
+
+static struct uart_driver serial_omap_reg;
+
+#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
+
+/*
+ *	Wait for transmitter & holding register to empty
+ */
+static inline void wait_for_xmitr(struct uart_omap_port *up)
+{
+	unsigned int status, tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	do {
+		status = serial_in(up, UART_LSR);
+
+		if (status & UART_LSR_BI)
+			up->lsr_break_flag = UART_LSR_BI;
+
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	} while ((status & BOTH_EMPTY) != BOTH_EMPTY);
+
+	/* Wait up to 1s for flow control if necessary */
+	if (up->port.flags & UPF_CONS_FLOW) {
+		tmout = 1000000;
+		for (tmout = 1000000; tmout; tmout--) {
+			unsigned int msr = serial_in(up, UART_MSR);
+			up->msr_saved_flags |= msr & MSR_SAVE_FLAGS;
+			if (msr & UART_MSR_CTS)
+				break;
+			udelay(1);
+		}
+	}
+}
+
+static void serial_omap_console_putchar(struct uart_port *port, int ch)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+
+	wait_for_xmitr(up);
+	serial_out(up, UART_TX, ch);
+}
+
+/*
+ * Print a string to the serial port trying not to disturb
+ * any possible real use of the port...
+ *
+ *	The console_lock must be held when we get here.
+ */
+static void
+serial_omap_console_write(struct console *co, const char *s,
+		unsigned int count)
+{
+	struct uart_omap_port *up = serial_omap_console_ports[co->index];
+	unsigned int ier;
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = serial_in(up, UART_IER);
+	serial_out(up, UART_IER, 0);
+
+	uart_console_write(&up->port, s, count, serial_omap_console_putchar);
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(up);
+	serial_out(up, UART_IER, ier);
+	/*
+	 *	The receive handling will happen properly because the
+	 *	receive ready bit will still be set; it is not cleared
+	 *	on read.  However, modem control will not, we must
+	 *	call it if we have saved something in the saved flags
+	 *	while processing with interrupts off.
+	 */
+	if (up->msr_saved_flags)
+		check_modem_status(up);
+}
+
+static int __init
+serial_omap_console_setup(struct console *co, char *options)
+{
+	struct uart_omap_port *up;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+	int r;
+
+	if (serial_omap_console_ports[co->index] == NULL)
+		return -ENODEV;
+	up = serial_omap_console_ports[co->index];
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	r = uart_set_options(&up->port, co, baud, parity, bits, flow);
+
+	return r;
+}
+
+static struct console serial_omap_console = {
+	.name		= "ttyS",
+	.write		= serial_omap_console_write,
+	.device		= uart_console_device,
+	.setup		= serial_omap_console_setup,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+	.data		= &serial_omap_reg,
+};
+
+static void serial_omap_add_console_port(struct uart_omap_port *up)
+{
+	serial_omap_console_ports[up->pdev->id - 1] = up;
+}
+
+#define OMAP_CONSOLE	(&serial_omap_console)
+
+#else
+
+#define OMAP_CONSOLE	NULL
+
+static inline void serial_omap_add_console_port(struct uart_omap_port *up) {}
+
+#endif
+
+struct uart_ops serial_omap_pops = {
+	.tx_empty	= serial_omap_tx_empty,
+	.set_mctrl	= serial_omap_set_mctrl,
+	.get_mctrl	= serial_omap_get_mctrl,
+	.stop_tx	= serial_omap_stop_tx,
+	.start_tx	= serial_omap_start_tx,
+	.stop_rx	= serial_omap_stop_rx,
+	.enable_ms	= serial_omap_enable_ms,
+	.break_ctl	= serial_omap_break_ctl,
+	.startup	= serial_omap_startup,
+	.shutdown	= serial_omap_shutdown,
+	.set_termios	= serial_omap_set_termios,
+	.pm		= serial_omap_pm,
+	.type		= serial_omap_type,
+	.release_port	= serial_omap_release_port,
+	.request_port	= serial_omap_request_port,
+	.config_port	= serial_omap_config_port,
+	.verify_port	= serial_omap_verify_port,
+};
+
+static struct uart_driver serial_omap_reg = {
+	.owner		= THIS_MODULE,
+	.driver_name	= "OMAP-SERIAL",
+	.dev_name	= "ttyS",
+	.major		= TTY_MAJOR,
+	.minor		= 64,
+	.nr		= 4,
+	.cons		= OMAP_CONSOLE,
+};
+
+static int serial_omap_remove(struct platform_device *dev);
+
+static
+int serial_omap_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct uart_omap_port *up = platform_get_drvdata(pdev);
+	unsigned int tmp;
+
+	if (up)
+		uart_suspend_port(&serial_omap_reg, &up->port);
+	if (up->use_dma) {
+		/*
+		 * Silicon Errata 2.15 workaround.
+		 * UART Module has to be put in force idle if it is
+		 * configured in DMA mode and when there is no activity
+		 * expected.
+		 */
+		tmp = (serial_in(up, UART_OMAP_SYSC) & 0x7);
+		serial_out(up, UART_OMAP_SYSC, tmp); /* force-idle */
+	}
+	return 0;
+}
+
+static int serial_omap_resume(struct platform_device *dev)
+{
+	struct uart_omap_port *up = platform_get_drvdata(dev);
+	if (up)
+		uart_resume_port(&serial_omap_reg, &up->port);
+
+	return 0;
+}
+
+static void serial_omap_rx_timeout(unsigned long uart_no)
+{
+	struct uart_omap_port *up = ui[uart_no - 1];
+	unsigned int curr_dma_pos;
+	curr_dma_pos = omap_readl(OMAP34XX_DMA4_BASE +
+				  OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
+	if ((curr_dma_pos == up->uart_dma.prev_rx_dma_pos) ||
+			     (curr_dma_pos == 0)) {
+		if (jiffies_to_msecs(jiffies - up_activity) < 10000) {
+			mod_timer(&up->uart_dma.rx_timer, jiffies +
+				usecs_to_jiffies(up->uart_dma.rx_timeout));
+		} else {
+			serial_omap_stop_rxdma(up);
+			up->ier |= UART_IER_RDI;
+			serial_out(up, UART_IER, up->ier);
+		}
+
+		return;
+	} else {
+		unsigned int curr_transmitted_size = curr_dma_pos -
+						up->uart_dma.prev_rx_dma_pos;
+		up->port.icount.rx += curr_transmitted_size;
+		tty_insert_flip_string(up->port.info->port.tty,
+				up->uart_dma.rx_buf +
+				(up->uart_dma.prev_rx_dma_pos -
+				up->uart_dma.rx_buf_dma_phys),
+				curr_transmitted_size);
+		tty_flip_buffer_push(up->port.info->port.tty);
+		up->uart_dma.prev_rx_dma_pos = curr_dma_pos;
+		if (up->uart_dma.rx_buf_size +
+				up->uart_dma.rx_buf_dma_phys == curr_dma_pos)
+			serial_omap_start_rxdma(up);
+		else
+			mod_timer(&up->uart_dma.rx_timer, jiffies +
+				usecs_to_jiffies(up->uart_dma.rx_timeout));
+		up_activity = jiffies;
+
+	}
+}
+
+static void uart_rx_dma_callback(int lch, u16 ch_status, void *data)
+{
+	return;
+}
+
+static void serial_omap_start_rxdma(struct uart_omap_port *up)
+{
+#ifdef CONFIG_PM
+	/* Disallow OCP bus idle. UART TX irqs are not seen during
+	 * bus idle. Alternative is to set kernel timer at fifo
+	 * drain rate.
+	 */
+	unsigned int tmp;
+	tmp = (serial_in(up, UART_OMAP_SYSC) & 0x7) | (1 << 3);
+	serial_out(up, UART_OMAP_SYSC, tmp); /* no-idle */
+#endif
+	if (up->uart_dma.rx_dma_channel == 0xFF) {
+		omap_request_dma(uart_dma_rx[up->pdev->id-1], "UART Rx DMA",
+			(void *)uart_rx_dma_callback, up,
+				&(up->uart_dma.rx_dma_channel));
+
+		omap_set_dma_src_params(up->uart_dma.rx_dma_channel, 0,
+					OMAP_DMA_AMODE_CONSTANT,
+					UART_BASE(up->pdev->id - 1), 0, 0);
+		omap_set_dma_dest_params(up->uart_dma.rx_dma_channel, 0,
+					OMAP_DMA_AMODE_POST_INC,
+					up->uart_dma.rx_buf_dma_phys, 0, 0);
+		omap_set_dma_transfer_params(up->uart_dma.rx_dma_channel,
+					OMAP_DMA_DATA_TYPE_S8,
+					up->uart_dma.rx_buf_size, 1,
+					OMAP_DMA_SYNC_ELEMENT,
+					uart_dma_rx[up->pdev->id-1], 0);
+	}
+	up->uart_dma.prev_rx_dma_pos = up->uart_dma.rx_buf_dma_phys;
+	omap_writel(0, OMAP34XX_DMA4_BASE
+			+ OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
+	omap_start_dma(up->uart_dma.rx_dma_channel);
+	mod_timer(&up->uart_dma.rx_timer, jiffies +
+				usecs_to_jiffies(up->uart_dma.rx_timeout));
+	up->uart_dma.rx_dma_state = 1;
+}
+
+static void serial_omap_continue_tx(struct uart_omap_port *up)
+{
+	struct circ_buf *xmit = &up->port.info->xmit;
+	int start = up->uart_dma.tx_buf_dma_phys
+			+ (xmit->tail & (UART_XMIT_SIZE - 1));
+	if (uart_circ_empty(xmit))
+		return;
+
+	up->uart_dma.tx_buf_size = uart_circ_chars_pending(xmit);
+	/* It is a circular buffer. See if the buffer has wounded back.
+	* If yes it will have to be transferred in two separate dma
+	* transfers
+	*/
+	if (start + up->uart_dma.tx_buf_size >=
+			up->uart_dma.tx_buf_dma_phys + UART_XMIT_SIZE)
+		up->uart_dma.tx_buf_size =
+			(up->uart_dma.tx_buf_dma_phys + UART_XMIT_SIZE) - start;
+	omap_set_dma_dest_params(up->uart_dma.tx_dma_channel, 0,
+				 OMAP_DMA_AMODE_CONSTANT,
+				 UART_BASE(up->pdev->id - 1), 0, 0);
+	omap_set_dma_src_params(up->uart_dma.tx_dma_channel, 0,
+		OMAP_DMA_AMODE_POST_INC, start, 0, 0);
+
+	omap_set_dma_transfer_params(up->uart_dma.tx_dma_channel,
+				     OMAP_DMA_DATA_TYPE_S8,
+				     up->uart_dma.tx_buf_size, 1,
+				     OMAP_DMA_SYNC_ELEMENT,
+				     uart_dma_tx[(up->pdev->id)-1], 0);
+
+	omap_start_dma(up->uart_dma.tx_dma_channel);
+}
+
+static void uart_tx_dma_callback(int lch, u16 ch_status, void *data)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)data;
+	struct circ_buf *xmit = &up->port.info->xmit;
+	xmit->tail = (xmit->tail + up->uart_dma.tx_buf_size) & \
+			(UART_XMIT_SIZE - 1);
+	up->port.icount.tx += up->uart_dma.tx_buf_size;
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&up->port);
+
+	if (uart_circ_empty(xmit)) {
+
+		spin_lock(&(up->uart_dma.tx_lock));
+		serial_omap_stop_tx(&up->port);
+		up->uart_dma.tx_dma_state = 0;
+		spin_unlock(&(up->uart_dma.tx_lock));
+	} else {
+		omap_stop_dma(up->uart_dma.tx_dma_channel);
+		serial_omap_continue_tx(up);
+	}
+	up_activity = jiffies;
+	return;
+}
+
+static int serial_omap_probe(struct platform_device *pdev)
+{
+	struct uart_omap_port	*up;
+	struct resource		*mem, *irq;
+	int ret = -ENOSPC;
+	char str[7];
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "no mem resource?\n");
+		return -ENODEV;
+	}
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq) {
+		dev_err(&pdev->dev, "no irq resource?\n");
+		return -ENODEV;
+	}
+
+	ret = (int) request_mem_region(mem->start, (mem->end - mem->start) + 1,
+				     pdev->dev.driver->name);
+	if (!ret) {
+		dev_err(&pdev->dev, "memory region already claimed\n");
+		return -EBUSY;
+	}
+	up = kzalloc(sizeof(*up), GFP_KERNEL);
+	if (up == NULL) {
+		ret = -ENOMEM;
+		goto do_release_region;
+	}
+	sprintf(up->name, "OMAP UART%d", pdev->id);
+
+	up->pdev = pdev;
+	up->port.dev = &pdev->dev;
+	up->port.type = PORT_OMAP;
+	up->port.iotype = UPIO_MEM;
+	up->port.mapbase = mem->start;
+	up->port.irq = irq->start;
+	up->port.fifosize = 64;
+	up->port.ops = &serial_omap_pops;
+	up->port.line = pdev->id - 1;
+	if ((pdev->id-1) == QUART) {
+		up->port.membase = ioremap_nocache(mem->start, 0x16 << 1);
+		up->port.flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP;
+		up->port.uartclk = QUART_CLK;
+		up->port.regshift = 1;
+	} else {
+		up->port.membase = (void *) IO_ADDRESS(mem->start);
+		up->port.flags = UPF_BOOT_AUTOCONF;
+		up->port.uartclk = UART_CLK;
+		up->port.regshift = 2;
+	}
+#ifdef CONFIG_PM
+		up->port.flags |= UPF_SHARE_IRQ;
+#endif
+	if ((pdev->id-1) == UART1) {
+#ifdef CONFIG_SERIAL_OMAP_DMA_UART1
+		up->use_dma = 1;
+		up->uart_dma.rx_buf_size =
+			CONFIG_SERIAL_OMAP_UART1_RXDMA_BUFSIZE;
+		up->uart_dma.rx_timeout =
+			CONFIG_SERIAL_OMAP_UART1_RXDMA_TIMEOUT;
+#endif
+	} else if ((pdev->id-1) == UART2) {
+#ifdef CONFIG_SERIAL_OMAP_DMA_UART2
+		up->use_dma = 1;
+		up->uart_dma.rx_buf_size =
+			CONFIG_SERIAL_OMAP_UART2_RXDMA_BUFSIZE;
+		up->uart_dma.rx_timeout =
+			CONFIG_SERIAL_OMAP_UART2_RXDMA_TIMEOUT;
+#endif
+	} else if ((pdev->id-1) == UART3) {
+#ifdef CONFIG_SERIAL_OMAP_DMA_UART3
+		up->use_dma = 1;
+		up->uart_dma.rx_buf_size =
+			CONFIG_SERIAL_OMAP_UART3_RXDMA_BUFSIZE;
+		up->uart_dma.rx_timeout =
+			CONFIG_SERIAL_OMAP_UART3_RXDMA_TIMEOUT;
+#endif
+	}
+	if (up->use_dma) {
+		spin_lock_init(&(up->uart_dma.tx_lock));
+		spin_lock_init(&(up->uart_dma.rx_lock));
+		up->uart_dma.tx_dma_channel = 0xFF;
+		up->uart_dma.rx_dma_channel = 0xFF;
+	}
+	if (console_detect(str)) {
+		pr_err("\n %s: Invalid console paramter...\n", __func__);
+		pr_err("\n %s: UART Driver Init Failed!\n", __func__);
+		return -EPERM;
+	}
+	fcr[pdev->id - 1] = 0;
+	ui[pdev->id - 1] = up;
+	serial_omap_add_console_port(up);
+
+	ret = uart_add_one_port(&serial_omap_reg, &up->port);
+	if (ret != 0)
+		goto do_release_region;
+
+	platform_set_drvdata(pdev, up);
+	return 0;
+do_release_region:
+	release_mem_region(mem->start, (mem->end - mem->start) + 1);
+	return ret;
+}
+
+static int serial_omap_remove(struct platform_device *dev)
+{
+	struct uart_omap_port *up = platform_get_drvdata(dev);
+	platform_set_drvdata(dev, NULL);
+	if (up) {
+		uart_remove_one_port(&serial_omap_reg, &up->port);
+		kfree(up);
+	}
+	return 0;
+}
+
+static struct platform_driver serial_omap_driver = {
+	.probe          = serial_omap_probe,
+	.remove         = serial_omap_remove,
+
+	.suspend	= serial_omap_suspend,
+	.resume		= serial_omap_resume,
+	.driver		= {
+		.name	= "omap-uart",
+	},
+};
+
+int __init serial_omap_init(void)
+{
+	int ret;
+
+	ret = uart_register_driver(&serial_omap_reg);
+	if (ret != 0)
+		return ret;
+	ret = platform_driver_register(&serial_omap_driver);
+	if (ret != 0)
+		uart_unregister_driver(&serial_omap_reg);
+	return ret;
+}
+
+void __exit serial_omap_exit(void)
+{
+	platform_driver_unregister(&serial_omap_driver);
+	uart_unregister_driver(&serial_omap_reg);
+}
+
+#ifdef DEBUG
+static void serial_omap_display_reg(struct uart_port *port)
+{
+	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	unsigned int lcr, efr, mcr, dll, dlh, xon1, xon2, xoff1, xoff2;
+	unsigned int tcr, tlr, uasr;
+	DPRINTK("Register dump for UART%d\n", up->pdev->id);
+	DPRINTK("IER_REG = 0x%x\n", serial_in(up, UART_IER));
+	DPRINTK("IIR_REG = 0x%x\n", serial_in(up, UART_IIR));
+	lcr = serial_in(up, UART_LCR);
+	DPRINTK("LCR_REG = 0x%x\n", lcr);
+	mcr = serial_in(up, UART_MCR);
+	DPRINTK("MCR_REG = 0x%x\n", mcr);
+	DPRINTK("LSR_REG = 0x%x\n", serial_in(up, UART_LSR));
+	DPRINTK("MSR_REG = 0x%x\n", serial_in(up, UART_MSR));
+	DPRINTK("SPR_REG = 0x%x\n", serial_in(up, UART_OMAP_SPR));
+	DPRINTK("MDR1_REG = 0x%x\n", serial_in(up, UART_OMAP_MDR1));
+	DPRINTK("MDR2_REG = 0x%x\n", serial_in(up, UART_OMAP_MDR2));
+	DPRINTK("SCR_REG = 0x%x\n", serial_in(up, UART_OMAP_SCR));
+	DPRINTK("SSR_REG = 0x%x\n", serial_in(up, UART_OMAP_SSR));
+	DPRINTK("MVR_REG = 0x%x\n", serial_in(up, UART_OMAP_MVER));
+	DPRINTK("SYSC_REG = 0x%x\n", serial_in(up, UART_OMAP_SYSC));
+	DPRINTK("SYSS_REG = 0x%x\n", serial_in(up, UART_OMAP_SYSS));
+	DPRINTK("WER_REG = 0x%x\n", serial_in(up, UART_OMAP_WER));
+
+	serial_out(up, UART_LCR, 0xBF);
+	dll = serial_in(up, UART_DLL);
+	dlh = serial_in(up, UART_DLM);
+	efr = serial_in(up, UART_EFR);
+	xon1 = serial_in(up, UART_XON1);
+	xon2 = serial_in(up, UART_XON2);
+
+	serial_out(up, UART_EFR, efr | UART_EFR_ECB);
+	serial_out(up, UART_LCR, lcr);
+	serial_out(up, UART_MCR, mcr | UART_MCR_TCRTLR);
+	serial_out(up, UART_LCR, 0xBF);
+
+	tcr = serial_in(up, UART_TI752_TCR);
+	tlr = serial_in(up, UART_TI752_TLR);
+
+	serial_out(up, UART_LCR, lcr);
+	serial_out(up, UART_MCR, mcr);
+	serial_out(up, UART_LCR, 0xBF);
+
+	xoff1 = serial_in(up, UART_XOFF1);
+	xoff2 = serial_in(up, UART_XOFF2);
+	uasr = serial_in(up, UART_OMAP_UASR);
+
+	serial_out(up, UART_EFR, efr);
+	serial_out(up, UART_LCR, lcr);
+
+
+	DPRINTK("DLL_REG = 0x%x\n", dll);
+	DPRINTK("DLH_REG = 0x%x\n", dlh);
+	DPRINTK("EFR_REG = 0x%x\n", efr);
+
+	DPRINTK("XON1_ADDR_REG = 0x%x\n", xon1);
+	DPRINTK("XON2_ADDR_REG = 0x%x\n", xon2);
+	DPRINTK("TCR_REG = 0x%x\n", tcr);
+	DPRINTK("TLR_REG = 0x%x\n", tlr);
+
+
+	DPRINTK("XOFF1_REG = 0x%x\n", xoff1);
+	DPRINTK("XOFF2_REG = 0x%x\n", xoff2);
+	DPRINTK("UASR_REG = 0x%x\n", uasr);
+}
+#endif
+
+subsys_initcall(serial_omap_init);
+module_exit(serial_omap_exit);
+
+MODULE_DESCRIPTION("OMAP High Speed UART driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
+MODULE_AUTHOR("Texas Instruments Inc");
