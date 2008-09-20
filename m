Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYITM56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYITM56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 08:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYITM5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 08:57:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:47845 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYITM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 08:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lcroEgox9hov82jbc2qtgG4u/dghWK1cyLE4V6R3BcCxeIWBBxaJMkW9XldpUgCTss
         8xrJdubc0CH+PktUfTwKYBB1a/5r1+zEF3BSBEKkrawrsM6XBWTFuhmkJzDTUaLqHLbs
         1OBoqCRtogKNKkI2cT+zcE3LMXU8ygagutnLg=
From: Christian Pellegrin <chripell@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Christian Pellegrin <chripell@fsfe.org>
Subject: [PATCH RESEND] max3100 driver
Date: Sat, 20 Sep 2008 14:57:38 +0200
Message-Id: <12219154581088-git-send-email-chripell@gmail.com>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the MAX3100 SPI UART.

Generated on  20080920  against v2.6.27-rc6

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
---
 Documentation/devices.txt      |    3 +
 drivers/serial/Kconfig         |    6 +-
 drivers/serial/Makefile        |    1 +
 drivers/serial/max3100.c       |  953 ++++++++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h    |    3 +
 include/linux/serial_max3100.h |   31 ++
 6 files changed, 996 insertions(+), 1 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 05c8064..c228887 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -2807,6 +2807,9 @@ Your cooperation is appreciated.
 		    ...
 		 190 = /dev/ttyUL3		Xilinx uartlite - port 3
 		 191 = /dev/xvc0		Xen virtual console - port 0
+		 192 = /dev/ttyMAX0             first MAX3100 UART
+		    ...
+ 		 195 = /dev/ttyMAX3             fourth MAX3100 UART
 
 205 char	Low-density serial ports (alternate device)
 		  0 = /dev/culu0		Callout device for ttyLU0
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 77cb342..de3193d 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -509,7 +509,11 @@ config SERIAL_S3C2440
 	help
 	  Serial port support for the Samsung S3C2440 and S3C2442 SoC
 
-
+config SERIAL_MAX3100
+        tristate "MAX3100 support"
+        depends on SPI
+        help
+          MAX3100 chip support
 
 config SERIAL_DZ
 	bool "DECstation DZ serial driver"
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 7e7383e..21c3daf 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_SERIAL_S3C2400) += s3c2400.o
 obj-$(CONFIG_SERIAL_S3C2410) += s3c2410.o
 obj-$(CONFIG_SERIAL_S3C2412) += s3c2412.o
 obj-$(CONFIG_SERIAL_S3C2440) += s3c2440.o
+obj-$(CONFIG_SERIAL_MAX3100) += max3100.o
 obj-$(CONFIG_SERIAL_SUNCORE) += suncore.o
 obj-$(CONFIG_SERIAL_SUNHV) += sunhv.o
 obj-$(CONFIG_SERIAL_SUNZILOG) += sunzilog.o
diff --git a/drivers/serial/max3100.c b/drivers/serial/max3100.c
new file mode 100644
index 0000000..12889b3
--- /dev/null
+++ b/drivers/serial/max3100.c
@@ -0,0 +1,953 @@
+/*
+ *
+ *  Copyright (C) 2008 Christian Pellegrin <chripell@evolware.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ *
+ * Notes: the MAX3100 doesn't provide an interrupt on CTS so we have
+ * to use polling for flow control. TX empty IRQ is unusable, since
+ * writing conf clears FIFO buffer and we cannot have this interrupt
+ * always asking us for attention.
+ *
+ * Example platform data:
+
+static struct plat_max3100 max3100_plat_data = {
+	.loopback = 0,
+	.crystal = 0,
+	.only_edge_irq = 0,
+	.poll_time = 100,
+};
+
+static struct spi_board_info spi_board_info[] = {
+	{
+		.modalias	= "max3100",
+		.platform_data	= &max3100_plat_data,
+		.irq		= IRQ_EINT12,
+		.max_speed_hz	= 5*1000*1000,
+		.chip_select	= 0,
+	},
+};
+
+ * The initial minor number is 192 in the low-density serial port:
+ * mknod /dev/ttyMAX0 c 204 192
+ */
+
+#define MAX3100_MAJOR 204
+#define MAX3100_MINOR 192
+/* 4 MAX3100s should be enough for everyone */
+#define MAX_MAX3100 4
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/serial_core.h>
+#include <linux/serial.h>
+#include <linux/spi/spi.h>
+#include <linux/freezer.h>
+
+#include <linux/serial_max3100.h>
+
+#define MAX3100_C    (1<<14)
+#define MAX3100_D    (0<<14)
+#define MAX3100_W    (1<<15)
+#define MAX3100_RX   (0<<15)
+
+#define MAX3100_WC   (MAX3100_W  | MAX3100_C)
+#define MAX3100_RC   (MAX3100_RX | MAX3100_C)
+#define MAX3100_WD   (MAX3100_W  | MAX3100_D)
+#define MAX3100_RD   (MAX3100_RX | MAX3100_D)
+#define MAX3100_CMD  (3 << 14)
+
+#define MAX3100_T    (1<<14)
+#define MAX3100_R    (1<<15)
+
+#define MAX3100_FEN  (1<<13)
+#define MAX3100_SHDN (1<<12)
+#define MAX3100_TM   (1<<11)
+#define MAX3100_RM   (1<<10)
+#define MAX3100_PM   (1<<9)
+#define MAX3100_RAM  (1<<8)
+#define MAX3100_IR   (1<<7)
+#define MAX3100_ST   (1<<6)
+#define MAX3100_PE   (1<<5)
+#define MAX3100_L    (1<<4)
+#define MAX3100_BAUD (0xf)
+
+#define MAX3100_TE   (1<<10)
+#define MAX3100_RAFE (1<<10)
+#define MAX3100_RTS  (1<<9)
+#define MAX3100_CTS  (1<<9)
+#define MAX3100_PT   (1<<8)
+#define MAX3100_DATA (0xff)
+
+#define MAX3100_RT   (MAX3100_R | MAX3100_T)
+#define MAX3100_RTC  (MAX3100_RT | MAX3100_CTS | MAX3100_RAFE)
+
+/* the following simulate a status reg for ignore_status_mask */
+#define MAX3100_STATUS_PE 1
+#define MAX3100_STATUS_FE 2
+#define MAX3100_STATUS_OE 4
+
+struct max3100_port {
+	struct uart_port port;
+	struct spi_device *spi;
+
+	int cts;	        /* last CTS received for flow ctrl */
+	int tx_empty;		/* last TX empty bit */
+
+	spinlock_t conf_lock;	/* shared data */
+	int conf_commit;	/* need to make changes */
+	int conf;		/* configuration for the MAX31000
+				 * (bits 0-7, bits 8-11 are irqs) */
+	int rts_commit;	        /* need to change rts */
+	int rts;		/* rts status */
+
+	int parity;		/* keeps track if we should send parity */
+#define MAX3100_PARITY_ON 1
+#define MAX3100_PARITY_ODD 2
+#define MAX3100_7BIT 4
+	int rx_enabled;	        /* if we should rx chars */
+
+	int irq;		/* irq assigned to the max3100 */
+
+	int minor;		/* minor number */
+	int crystal;		/* 1 if 3.6864Mhz crystal 0 for 1.8432 */
+	int loopback;		/* 1 if we are in loopback mode */
+	int only_edge_irq;	/* 1 if we have only edge irqs (like PXA) */
+
+	/* for handling irqs: need workqueue since we do spi_sync */
+	struct workqueue_struct *workqueue;
+	struct work_struct work;
+	/* set to 1 to make the workhandler exit as soon as possible */
+	int  force_end_work;
+	/* need to know we are suspending to avoid deadlock on workqueue */
+	int suspending;
+
+	/* these are for IRQ on/off counting */
+	int irq_status;
+	/* avoid race condition on irq_status */
+	spinlock_t irq_lock;
+
+	/* hook for suspending MAX3100 via dedicated pin */
+	void (*max3100_hw_suspend) (int suspend);
+
+	/* poll time (in ms) for ctrl lines */
+	int poll_time;
+	/* and its timer */
+	struct timer_list	timer;
+};
+
+static struct max3100_port *max3100s[MAX_MAX3100]; /* the chips */
+
+static void irq_state(struct max3100_port *s, int on)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->irq_lock, flags);
+	if (s->irq_status != on) {
+		if (on)
+			enable_irq(s->irq);
+		else
+			disable_irq(s->irq);
+		s->irq_status = on;
+	}
+	spin_unlock_irqrestore(&s->irq_lock, flags);
+}
+
+static int max3100_do_parity(struct max3100_port *s, u16 c)
+{
+	int parity;
+
+	if (s->parity & MAX3100_PARITY_ODD)
+		parity = 1;
+	else
+		parity = 0;
+
+	if (s->parity & MAX3100_7BIT)
+		c &= 0x7f;
+	else
+		c &= 0xff;
+
+	parity = parity ^ (hweight8(c) & 1);
+	return parity;
+}
+
+static int max3100_check_parity(struct max3100_port *s, u16 c)
+{
+	return max3100_do_parity(s, c) == ((c >> 8) & 1);
+}
+
+static void max3100_calc_parity(struct max3100_port *s, u16 *c)
+{
+	if (s->parity & MAX3100_7BIT)
+		*c &= 0x7f;
+	else
+		*c &= 0xff;
+
+	if (s->parity & MAX3100_PARITY_ON)
+		*c |= max3100_do_parity(s, *c) << 8;
+}
+
+static void max3100_work(struct work_struct *w);
+
+static void max3100_dowork(struct max3100_port *s)
+{
+	if (!s->force_end_work && !work_pending(&s->work))
+		queue_work(s->workqueue, &s->work);
+}
+
+static void max3100_timeout(unsigned long data)
+{
+	struct max3100_port *s = (struct max3100_port *)data;
+
+	if (s->port.info) {
+		max3100_dowork(s);
+		mod_timer(&s->timer, jiffies + s->poll_time);
+	}
+}
+
+static int max3100_sr(struct max3100_port *s, u16 tx, u16 *rx)
+{
+	struct spi_message message;
+	u16 etx, erx;
+	int status;
+	struct spi_transfer tran = {
+		.tx_buf = &etx,
+		.rx_buf = &erx,
+		.len = 2,
+	};
+
+
+	etx = htons(tx);
+	spi_message_init(&message);
+	spi_message_add_tail(&tran, &message);
+	status = spi_sync(s->spi, &message);
+	if (status) {
+		dev_warn(&s->spi->dev, "error while calling spi_sync\n");
+		return -EIO;
+	}
+	*rx = ntohs(erx);
+	s->tx_empty = (*rx & MAX3100_T) > 0;
+	dev_dbg(&s->spi->dev, "%04x - %04x\n", tx, *rx);
+	return 0;
+}
+
+static int max3100_handlerx(struct max3100_port *s, u16 rx)
+{
+	unsigned int ch, flg, status = 0;
+	int ret = 0, cts;
+
+	if (rx & MAX3100_R && s->rx_enabled) {
+		dev_dbg(&s->spi->dev, "%s\n", __func__);
+		ch = rx & (s->parity & MAX3100_7BIT ? 0x7f : 0xff);
+		if (rx & MAX3100_RAFE) {
+			s->port.icount.frame++;
+			flg = TTY_FRAME;
+			status |= MAX3100_STATUS_FE;
+		} else {
+			if (s->parity & MAX3100_PARITY_ON) {
+				if (max3100_check_parity(s, rx)) {
+					s->port.icount.rx++;
+					flg = TTY_NORMAL;
+				} else {
+					s->port.icount.parity++;
+					flg = TTY_PARITY;
+					status |= MAX3100_STATUS_PE;
+				}
+			} else {
+				s->port.icount.rx++;
+				flg = TTY_NORMAL;
+			}
+		}
+		uart_insert_char(&s->port, status, MAX3100_STATUS_OE, ch, flg);
+		ret = 1;
+	}
+
+	cts = (rx & MAX3100_CTS) > 0;
+	if (s->cts != cts) {
+		s->cts = cts;
+		uart_handle_cts_change(&s->port, cts ? TIOCM_CTS : 0);
+	}
+
+	return ret;
+}
+
+static void max3100_work(struct work_struct *w)
+{
+	struct max3100_port *s = container_of(w, struct max3100_port, work);
+	int rxchars;
+	u16 tx, rx;
+	int conf, cconf, rts, crts;
+	struct circ_buf *xmit = &s->port.info->xmit;
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	do {
+		rxchars = 0;
+
+		spin_lock(&s->conf_lock);
+		conf = s->conf;
+		cconf = s->conf_commit;
+		s->conf_commit = 0;
+		rts = s->rts;
+		crts = s->rts_commit;
+		s->rts_commit = 0;
+		spin_unlock(&s->conf_lock);
+		if (cconf)
+			max3100_sr(s, MAX3100_WC | conf, &rx);
+		if (crts) {
+			max3100_sr(s, MAX3100_WD | MAX3100_TE |
+				   (s->rts ? MAX3100_RTS : 0), &rx);
+			rxchars += max3100_handlerx(s, rx);
+		}
+
+		max3100_sr(s, MAX3100_RD, &rx);
+		rxchars += max3100_handlerx(s, rx);
+
+		if (rx & MAX3100_T) {
+			tx = 0xffff;
+			if (s->port.x_char) {
+				tx = s->port.x_char;
+				s->port.icount.tx++;
+				s->port.x_char = 0;
+			} else if (!uart_circ_empty(xmit) &&
+				 !uart_tx_stopped(&s->port)) {
+				tx = xmit->buf[xmit->tail];
+				xmit->tail = (xmit->tail + 1) &
+				  (UART_XMIT_SIZE - 1);
+				s->port.icount.tx++;
+			}
+			if (tx != 0xffff) {
+				max3100_calc_parity(s, &tx);
+				tx |= MAX3100_WD | (s->rts ? MAX3100_RTS : 0);
+				max3100_sr(s, tx, &rx);
+				rxchars += max3100_handlerx(s, rx);
+			}
+		}
+
+		if (rxchars > 0)
+			tty_flip_buffer_push(s->port.info->port.tty);
+		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+			uart_write_wakeup(&s->port);
+
+	} while (!s->force_end_work &&
+		 !freezing(current) &&
+		 ((rx & MAX3100_R) ||
+		  (!uart_circ_empty(xmit) &&
+		   !uart_tx_stopped(&s->port))));
+
+	if (!s->only_edge_irq && !s->force_end_work &&
+	    !freezing(current))
+		irq_state(s, 1);
+}
+
+static irqreturn_t max3100_irq(int irqno, void *dev_id)
+{
+	struct max3100_port *s = dev_id;
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	if (!s->only_edge_irq)
+		irq_state(s, 0); /* avoid irq storm */
+	max3100_dowork(s);
+	return IRQ_HANDLED;
+}
+
+static void max3100_enable_ms(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	if (s->poll_time > 0)
+		mod_timer(&s->timer, jiffies);
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+}
+
+static void max3100_start_tx(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	max3100_dowork(s);
+}
+
+static void max3100_stop_rx(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	s->rx_enabled = 0;
+	spin_lock(&s->conf_lock);
+	s->conf &= ~MAX3100_RM;
+	s->conf_commit = 1;
+	spin_unlock(&s->conf_lock);
+	max3100_dowork(s);
+}
+
+static unsigned int max3100_tx_empty(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	/* may not be truly up-to-date */
+	max3100_dowork(s);
+	return s->tx_empty;
+}
+
+static unsigned int max3100_get_mctrl(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	/* may not be truly up-to-date */
+	max3100_dowork(s);
+	/* always assert DCD and DSR since these lines are not wired */
+	return (s->cts ? TIOCM_CTS : 0) | TIOCM_DSR | TIOCM_CAR;
+}
+
+static void max3100_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+	int rts;
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	rts = (mctrl & TIOCM_RTS) > 0;
+
+	spin_lock(&s->conf_lock);
+	if (s->rts != rts) {
+		s->rts = rts;
+		s->rts_commit = 1;
+		max3100_dowork(s);
+	}
+	spin_unlock(&s->conf_lock);
+}
+
+static void
+max3100_set_termios(struct uart_port *port, struct ktermios *termios,
+		   struct ktermios *old)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+	int baud = 0;
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	if (!old || (termios->c_cflag != old->c_cflag)) {
+		unsigned cflag;
+		unsigned i;
+		u32 param_new;
+		u32 param_mask;
+		u32 parity = 0;
+
+		cflag = termios->c_cflag;
+		param_new = 0;
+		param_mask = 0;
+
+		i = cflag & CBAUD;
+		switch (i) {
+		case B300:
+			if (s->crystal) {
+				param_new = 16;
+			} else {
+				dev_warn(&s->spi->dev,
+					 "unsupported baud rate!\n");
+				param_new = 15;
+			}
+			baud = 300;
+			break;
+		case B600:
+			param_new = 15;
+			baud = 600;
+			break;
+		case B1200:
+			param_new = 14;
+			baud = 1200;
+			break;
+		case B2400:
+			param_new = 13;
+			baud = 2400;
+			break;
+		case B4800:
+			param_new = 12;
+			baud = 4800;
+			break;
+		case B9600:
+			param_new = 11;
+			baud = 9600;
+			break;
+		case B19200:
+			param_new = 10;
+			baud = 19200;
+			break;
+		case B38400:
+			param_new = 9;
+			baud = 38400;
+			break;
+		case B57600:
+			param_new = 2;
+			baud = 57600;
+			break;
+		case B115200:
+			param_new = 1;
+			baud = 11520;
+			break;
+		case B230400:
+			if (s->crystal) {
+				param_new = 1;
+				dev_warn(&s->spi->dev,
+					 "unsupported baud rate!\n");
+			} else {
+				param_new = 0;
+			}
+			baud = 230400;
+			break;
+		default:
+			param_new = 1;
+			dev_warn(&s->spi->dev, "invalid baudrate\n");
+		}
+		param_new = (param_new - s->crystal) & MAX3100_BAUD;
+		param_mask |= MAX3100_BAUD;
+
+		if ((cflag & CSIZE) == CS8) {
+			param_new &= ~MAX3100_L;
+			parity &= ~MAX3100_7BIT;
+		} else {
+			param_new |= MAX3100_L;
+			parity |= MAX3100_7BIT;
+		}
+		param_mask |= MAX3100_L;
+
+		if (cflag & CSTOPB)
+			param_new |= MAX3100_ST;
+		else
+			param_new &= ~MAX3100_ST;
+		param_mask |= MAX3100_ST;
+
+		if (cflag & PARENB) {
+			param_new |= MAX3100_PE;
+			parity |= MAX3100_PARITY_ON;
+		} else {
+			param_new &= ~MAX3100_PE;
+			parity &= ~MAX3100_PARITY_ON;
+		}
+		param_mask |= MAX3100_PE;
+
+		if (cflag & PARODD)
+			parity |= MAX3100_PARITY_ODD;
+		else
+			parity &= ~MAX3100_PARITY_ODD;
+
+		s->port.ignore_status_mask = 0;
+		if (termios->c_iflag & IGNPAR)
+			s->port.ignore_status_mask |=
+				MAX3100_STATUS_PE | MAX3100_STATUS_FE |
+				MAX3100_STATUS_OE;
+
+		if (s->poll_time > 0)
+			del_timer_sync(&s->timer);
+
+		uart_update_timeout(port, termios->c_cflag, baud);
+
+		spin_lock(&s->conf_lock);
+		s->conf = (s->conf & ~param_mask) | (param_new & param_mask);
+		s->conf_commit = 1;
+		s->parity = parity;
+		spin_unlock(&s->conf_lock);
+		max3100_dowork(s);
+
+		if (UART_ENABLE_MS(&s->port, termios->c_cflag))
+			max3100_enable_ms(&s->port);
+	}
+}
+
+static void max3100_shutdown(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	if (s->suspending)
+		return;
+
+	s->force_end_work = 1;
+
+	if (s->poll_time > 0)
+		del_timer_sync(&s->timer);
+
+	if (s->workqueue) {
+		flush_workqueue(s->workqueue);
+		destroy_workqueue(s->workqueue);
+	}
+	if (s->irq)
+		free_irq(s->irq, s);
+
+	/* set shutdown mode to save power */
+	if (s->max3100_hw_suspend)
+		s->max3100_hw_suspend(1);
+	else  {
+		u16 tx, rx;
+
+		tx = MAX3100_WC | MAX3100_SHDN;
+		max3100_sr(s, tx, &rx);
+	}
+}
+
+static int max3100_startup(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+	char b[12];
+	int irq_type;
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	s->conf = MAX3100_RM;
+	s->rx_enabled = 1;
+
+	if (s->suspending)
+		return 0;
+
+	s->force_end_work = 0;
+	s->parity = 0;
+	s->rts = 0;
+
+	sprintf(b, "max3100-%d", s->minor);
+	s->workqueue = create_freezeable_workqueue(b);
+	if (!s->workqueue) {
+		dev_warn(&s->spi->dev, "cannot create workqueue\n");
+		return -EBUSY;
+	}
+	INIT_WORK(&s->work, max3100_work);
+
+	s->irq_status = 1;	/* IRQS are on after request */
+	if (s->only_edge_irq)
+		irq_type = IRQF_TRIGGER_FALLING;
+	else
+		irq_type = IRQF_TRIGGER_LOW;
+	if (request_irq(s->irq, max3100_irq, irq_type, "max3100", s) < 0) {
+		dev_warn(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
+		s->irq = 0;
+		destroy_workqueue(s->workqueue);
+		return -EBUSY;
+	}
+
+	if (s->loopback) {
+		u16 tx, rx;
+		tx = 0x4001;
+		max3100_sr(s, tx, &rx);
+	}
+
+	if (s->max3100_hw_suspend)
+		s->max3100_hw_suspend(0);
+	s->conf_commit = 1;
+	max3100_dowork(s);
+	/* wait for clock to settle */
+	msleep(50);
+
+	max3100_enable_ms(&s->port);
+
+	return 0;
+}
+
+static const char *max3100_type(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	return s->port.type == PORT_MAX3100 ? "MAX3100" : NULL;
+}
+
+static void max3100_release_port(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+}
+
+static void max3100_config_port(struct uart_port *port, int flags)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	if (flags & UART_CONFIG_TYPE)
+		s->port.type = PORT_MAX3100;
+}
+
+static int max3100_verify_port(struct uart_port *port,
+			       struct serial_struct *ser)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+	int ret = -EINVAL;
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	if (ser->type == PORT_UNKNOWN || ser->type == PORT_MAX3100)
+		ret = 0;
+	return ret;
+}
+
+static void max3100_stop_tx(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+}
+
+static int max3100_request_port(struct uart_port *port)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+	return 0;
+}
+
+static void max3100_break_ctl(struct uart_port *port, int break_state)
+{
+	struct max3100_port *s = container_of(port,
+						struct max3100_port,
+						port);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+}
+
+static struct uart_ops max3100_ops = {
+	.tx_empty	= max3100_tx_empty,
+	.set_mctrl	= max3100_set_mctrl,
+	.get_mctrl	= max3100_get_mctrl,
+	.stop_tx        = max3100_stop_tx,
+	.start_tx	= max3100_start_tx,
+	.stop_rx	= max3100_stop_rx,
+	.enable_ms      = max3100_enable_ms,
+	.break_ctl      = max3100_break_ctl,
+	.startup	= max3100_startup,
+	.shutdown	= max3100_shutdown,
+	.set_termios	= max3100_set_termios,
+	.type		= max3100_type,
+	.release_port   = max3100_release_port,
+	.request_port   = max3100_request_port,
+	.config_port	= max3100_config_port,
+	.verify_port	= max3100_verify_port,
+};
+
+static struct uart_driver max3100_uart_driver = {
+	.owner          = THIS_MODULE,
+	.driver_name    = "ttyMAX",
+	.dev_name       = "ttyMAX",
+	.major          = MAX3100_MAJOR,
+	.minor          = MAX3100_MINOR,
+	.nr             = MAX_MAX3100,
+};
+static int uart_driver_registered;
+
+static int __devinit max3100_probe(struct spi_device *spi)
+{
+	int i, retval;
+	struct plat_max3100 *pdata;
+	u16 tx, rx;
+
+	if (!uart_driver_registered) {
+		uart_driver_registered = 1;
+		retval = uart_register_driver(&max3100_uart_driver);
+		if (retval) {
+			printk(KERN_ERR "Couldn't register max3100 uart driver\n");
+			return retval;
+		}
+	}
+
+	for (i = 0; i < MAX_MAX3100; i++)
+		if (!max3100s[i])
+			break;
+	if (i == MAX_MAX3100) {
+		dev_warn(&spi->dev, "too many MAX3100 chips\n");
+		return -ENOMEM;
+	}
+
+	max3100s[i] = kzalloc(sizeof(struct max3100_port), GFP_KERNEL);
+	if (!max3100s[i]) {
+		dev_warn(&spi->dev,
+			 "kmalloc for max3100 structure %d failed!\n", i);
+		return -ENOMEM;
+	}
+	max3100s[i]->spi = spi;
+	max3100s[i]->irq = spi->irq;
+	spin_lock_init(&max3100s[i]->conf_lock);
+	dev_set_drvdata(&spi->dev, max3100s[i]);
+	pdata = spi->dev.platform_data;
+	max3100s[i]->crystal = pdata->crystal;
+	max3100s[i]->loopback = pdata->loopback;
+	max3100s[i]->only_edge_irq = pdata->only_edge_irq;
+	max3100s[i]->poll_time = pdata->poll_time * HZ / 1000;
+	if (pdata->poll_time > 0 && max3100s[i]->poll_time == 0)
+		max3100s[i]->poll_time = 1;
+	max3100s[i]->max3100_hw_suspend = pdata->max3100_hw_suspend;
+	max3100s[i]->minor = i;
+	init_timer(&max3100s[i]->timer);
+	max3100s[i]->timer.function = max3100_timeout;
+	max3100s[i]->timer.data = (unsigned long) max3100s[i];
+
+	dev_dbg(&spi->dev, "%s: adding port %d\n", __func__, i);
+	max3100s[i]->port.irq = max3100s[i]->irq;
+	max3100s[i]->port.uartclk = max3100s[i]->crystal ? 3686400 : 1843200;
+	max3100s[i]->port.fifosize = 16;
+	max3100s[i]->port.ops = &max3100_ops;
+	max3100s[i]->port.flags = UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
+	max3100s[i]->port.line = i;
+	max3100s[i]->port.type = PORT_MAX3100;
+	max3100s[i]->port.dev = &spi->dev;
+	retval = uart_add_one_port(&max3100_uart_driver, &max3100s[i]->port);
+	if (retval < 0)
+		dev_warn(&spi->dev,
+			 "uart_add_one_port failed for line %d with error %d\n",
+			 i, retval);
+
+	/* set shutdown mode to save power. Will be woken-up on open */
+	if (max3100s[i]->max3100_hw_suspend)
+		max3100s[i]->max3100_hw_suspend(1);
+	else {
+		tx = MAX3100_WC | MAX3100_SHDN;
+		max3100_sr(max3100s[i], tx, &rx);
+	}
+	return 0;
+}
+
+static int __devexit max3100_remove(struct spi_device *spi)
+{
+	struct max3100_port *s = dev_get_drvdata(&spi->dev);
+	int i;
+
+	/* find out the index for the chip we are removing */
+	for (i = 0; i < MAX_MAX3100; i++)
+		if (max3100s[i] == s)
+			break;
+
+	dev_dbg(&spi->dev, "%s: removing port %d\n", __func__, i);
+	uart_remove_one_port(&max3100_uart_driver, &max3100s[i]->port);
+	kfree(max3100s[i]);
+	max3100s[i] = NULL;
+
+	/* check if this is the last chip we have */
+	for (i = 0; i < MAX_MAX3100; i++)
+		if (max3100s[i])
+			return 0;
+	pr_debug("removing max3100 driver\n");
+	uart_unregister_driver(&max3100_uart_driver);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static int max3100_suspend(struct spi_device *spi, pm_message_t state)
+{
+	struct max3100_port *s = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	s->suspending = 1;
+	uart_suspend_port(&max3100_uart_driver, &s->port);
+
+	irq_state(s, 0);
+	synchronize_irq(s->irq);
+
+	if (s->max3100_hw_suspend)
+		s->max3100_hw_suspend(1);
+	else {
+		/* no HW suspend, so do SW one */
+		u16 tx, rx;
+
+		tx = MAX3100_WC | MAX3100_SHDN;
+		max3100_sr(s, tx, &rx);
+	}
+	return 0;
+}
+
+static int max3100_resume(struct spi_device *spi)
+{
+	struct max3100_port *s = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&s->spi->dev, "%s\n", __func__);
+
+	irq_state(s, 1);
+
+	if (s->max3100_hw_suspend)
+		s->max3100_hw_suspend(0);
+	s->conf_commit = 1;
+	max3100_dowork(s);
+
+	uart_resume_port(&max3100_uart_driver, &s->port);
+	s->suspending = 0;
+
+	return 0;
+}
+
+#else
+#define max3100_suspend NULL
+#define max3100_resume  NULL
+#endif
+
+static struct spi_driver max3100_driver = {
+	.driver = {
+		.name		= "max3100",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= max3100_probe,
+	.remove		= __devexit_p(max3100_remove),
+	.suspend	= max3100_suspend,
+	.resume		= max3100_resume,
+};
+
+
+static int __init max3100_init(void)
+{
+	return spi_register_driver(&max3100_driver);
+}
+module_init(max3100_init);
+
+static void __exit max3100_exit(void)
+{
+	spi_unregister_driver(&max3100_driver);
+}
+module_exit(max3100_exit);
+
+MODULE_DESCRIPTION("MAX3100 driver");
+MODULE_AUTHOR("Christian Pellegrin <chripell@evolware.org>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 3b2f6c0..32c9fa9 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -155,6 +155,9 @@
 
 #define PORT_SC26XX	82
 
+/* MAX3100 */
+#define PORT_MAX3100    83
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
diff --git a/include/linux/serial_max3100.h b/include/linux/serial_max3100.h
new file mode 100644
index 0000000..d1b4622
--- /dev/null
+++ b/include/linux/serial_max3100.h
@@ -0,0 +1,31 @@
+
+/*
+ *
+ *  Copyright (C) 2007 Christian Pellegrin
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifndef _LINUX_SERIAL_MAX3100_H
+#define _LINUX_SERIAL_MAX3100_H 1
+
+struct plat_max3100 {
+/* force MAX3100 in loopback */
+	int loopback;
+/* 0 for 3.6864 Mhz, 1 for 1.8432  */
+	int crystal;
+/* for archs like PXA with only edge irqs */
+	int only_edge_irq;
+/* MAX3100 has a shutdown pin. This is a hook
+   called on suspend and resume to activate it.*/
+	void (*max3100_hw_suspend) (int suspend);
+/* poll time for ctr signals in ms, 0 disables (so no hw flow
+ * ctrl is possible)  */
+	int poll_time;
+};
+
+#endif
--
1.4.4.4
