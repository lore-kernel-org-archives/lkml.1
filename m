Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbXL2K1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbXL2K1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 05:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXL2K1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 05:27:38 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:38372 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbXL2K1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 05:27:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H8Cqf0AdnHX92wc37TFQ+zTocBCvcAI9mXSKjXN01O5VbuRIUGBLVjlPbsAvDq8ovZPuIy/FLvD2cJQYZrWLT2BU2FiWCn7s0hRAOS/FDMFlO6cg0hL8Rx00IcKwZ+3JnJuZZm/r5Gpi41nFMDyicjE9Zqksx43OjL0yuGUBHuA=
From: chripell@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Christian Pellegrin <chripell@fsfe.org>
Subject: [PATCH RESEND] max3100 driver
Date: Sat, 29 Dec 2007 11:27:41 +0100
Message-Id: <11989240614132-git-send-email-chripell@gmail.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <cabda6420712282234m41e29e34t8af2463ff4ddb5e5@mail.gmail.com>
References: <cabda6420712282234m41e29e34t8af2463ff4ddb5e5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the MAX3100 SPI UART.

Generated on  20071229  against v2.6.23

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
---
 drivers/serial/Kconfig         |    7 +
 drivers/serial/Makefile        |    1 +
 drivers/serial/max3100.c       | 1003 ++++++++++++++++++++++++++++++++++++++++
 include/linux/serial_max3100.h |   28 ++
 4 files changed, 1039 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 81b52b7..4e7111b 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -461,6 +461,13 @@ config SERIAL_S3C2410_CONSOLE
 	  your boot loader about how to pass options to the kernel at
 	  boot time.)
 
+config SERIAL_MAX3100
+        tristate "MAX3100 support"
+        depends on SPI
+        help
+          MAX3100 chip support
+
+
 config SERIAL_DZ
 	bool "DECstation DZ serial driver"
 	depends on MACH_DECSTATION && 32BIT
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index af6377d..9f67e52 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_SERIAL_PNX8XXX) += pnx8xxx_uart.o
 obj-$(CONFIG_SERIAL_SA1100) += sa1100.o
 obj-$(CONFIG_SERIAL_BFIN) += bfin_5xx.o
 obj-$(CONFIG_SERIAL_S3C2410) += s3c2410.o
+obj-$(CONFIG_SERIAL_MAX3100) += max3100.o
 obj-$(CONFIG_SERIAL_SUNCORE) += suncore.o
 obj-$(CONFIG_SERIAL_SUNHV) += sunhv.o
 obj-$(CONFIG_SERIAL_SUNZILOG) += sunzilog.o
diff --git a/drivers/serial/max3100.c b/drivers/serial/max3100.c
new file mode 100644
index 0000000..9b6a08c
--- /dev/null
+++ b/drivers/serial/max3100.c
@@ -0,0 +1,1003 @@
+
+/*
+ *
+ *  Copyright (C) 2007 Christian Pellegrin <chripell@evolware.org>
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
+ * The initial minor number is 128 to prevent clashes with ttyS:
+ * mknod /dev/ttyMAX0 c 4 128
+ */
+
+#include <linux/bitops.h>
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/fcntl.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/keyboard.h>
+#include <linux/major.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pm.h>
+#include <linux/reboot.h>
+#include <linux/sched.h>
+#include <linux/serial_core.h>
+#include <linux/signal.h>
+#include <linux/spi/spi.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/uaccess.h>
+#include <linux/workqueue.h>
+
+#include <asm/system.h>
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
+struct max3100_port_s {
+	struct uart_port port;
+	struct spi_device *spi;
+	struct tty_struct 	*tty;
+
+	struct mutex   spi_txrx;/* protects access to the hw */
+
+	int rts:1;		/* rts status */
+	int conf;		/* configuration for the MAX31000
+				 * (bits 0-7, bits 8-11 are irqs) */
+	int last_cts_rx;	/* last CTS received for flow ctrl */
+
+	unsigned int tx_buf_cur;	        /* current char to tx */
+	/* current number of chars in tx buf */
+	unsigned int tx_buf_tot;
+	unsigned char *tx_buf;
+	/* shared tx buffer spinlock (no sem since write may sleep) */
+	spinlock_t tx_buf_lock;
+
+	int tx_stopped:1;	/* when we should not send chars */
+	int parity:3;		/* keeps track if we should send parity */
+#define MAX3100_PARITY_ON 1
+#define MAX3100_PARITY_ODD 2
+#define MAX3100_7BIT 4
+
+	int irq;		/* irq assigned to the max3100 */
+
+	int minor;		/* minor number */
+	int crystal:1;		/* 1 if 3.6864Mhz crystal 0 for 1.8432 */
+	int loopback:1;		/* 1 if we are in loopback mode */
+	int only_edge_irq:1;	/* 1 if we have only edge irqs (like PXA) */
+
+	int ref_count;		/* how many users */
+	struct mutex sem;	/* protects us during open/close */
+
+	/* for handling irqs: need workqueue since we do spi_sync */
+	struct workqueue_struct *workqueue;
+	struct work_struct work;
+	/* set to 1 to make the workhandler exit as soon as possible */
+	int  force_end_work;
+
+	/* these are for IRQ on/off counting */
+	int irq_status;
+	/* avoid race condition on irq_status */
+	spinlock_t irq_lock;
+
+	/* signals when we done sending current buffer */
+	wait_queue_head_t all_sent;
+
+	/* this is set when we are waking up */
+	int after_suspend:1;
+	/* hook for suspending MAX3100 via dedicated pin */
+	void (*max3100_hw_suspend) (int suspend);
+};
+
+/* global since we do register the driver only once */
+static struct tty_driver *serial_driver;
+
+/* 4 MAX3100s should be enough for everyone */
+#define MAX_MAX3100 4
+static struct max3100_port_s *max3100s[MAX_MAX3100]; /* the chips */
+
+/* our buffer for sending chars */
+#define MAX3100_TX_BUF_N 16
+
+/* how many chars we wait befor flipping tty buffer */
+#define MAX3100_FLIP_EVERY 8
+
+static void irq_state(struct max3100_port_s *s, int on)
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
+
+static int max3100_do_parity(struct max3100_port_s *s, u16 c)
+{
+	int parity;
+	int i, n;
+
+	if (s->parity & MAX3100_PARITY_ODD)
+		parity = 0;
+	else
+		parity = 1;
+
+	if (s->parity & MAX3100_7BIT)
+		n = 7;
+	else
+		n = 8;
+
+	for (i = 0; i < n; i++)
+		parity = parity ^ ((c>>i) & 1);
+	return parity;
+}
+
+static int max3100_check_parity(struct max3100_port_s *s, u16 c)
+{
+	return max3100_do_parity(s, c) == ((c>>9) & 1);
+}
+
+static void max3100_calc_parity(struct max3100_port_s *s, u16 *c)
+{
+	*c &=  ~MAX3100_PT;
+	*c |= max3100_do_parity(s, *c)<<8;
+}
+
+
+static void max3100_work(struct work_struct *w);
+
+static void max3100_dowork(struct max3100_port_s *s)
+{
+	if (!s->force_end_work) {
+		PREPARE_WORK(&s->work, max3100_work);
+		queue_work(s->workqueue, &s->work);
+	}
+}
+
+static int max3100_sr(struct max3100_port_s *s, u16 tx, u16 *rx, int push)
+{
+	/* note: we suppose that the T bit from conf_status is in sync
+	 * with the hw one, so all the communication must go through
+	 * this function */
+	struct spi_message message;
+	struct spi_transfer tran;
+	int status, flag;
+	u16 etx, erx;
+	int got_char = 0;
+
+	mutex_lock(&s->spi_txrx);
+
+	if (s->loopback && (tx & MAX3100_CMD) == MAX3100_RC)
+		tx |= 1;
+	etx = htons(tx);
+	spi_message_init(&message);
+	memset(&tran, 0, sizeof(tran));
+	tran.tx_buf = &etx;
+	tran.rx_buf = &erx;
+	tran.len = 2;
+	spi_message_add_tail(&tran, &message);
+	status = spi_sync(s->spi, &message);
+	if (status) {
+		dev_warn(&s->spi->dev, "error while calling spi_sync\n");
+		mutex_unlock(&s->spi_txrx);
+		return 0;
+	}
+	*rx = ntohs(erx);
+	dev_dbg(&s->spi->dev, "%04x - %04x\n", tx, *rx);
+
+	if ((tx & MAX3100_CMD) == MAX3100_RD ||
+	    (tx & MAX3100_CMD) == MAX3100_WD)
+		s->last_cts_rx = *rx;
+
+	if (*rx & MAX3100_R &&
+	    ((tx & MAX3100_CMD) == MAX3100_RD ||
+	     (tx & MAX3100_CMD) == MAX3100_WD)) {
+		got_char = 1;
+		if (tty_buffer_request_room(s->tty, 1) == 0) {
+			dev_warn(&s->spi->dev, "no room in tty buffer\n");
+			tty_schedule_flip(s->tty);
+		}
+
+		flag = TTY_NORMAL;
+		if (*rx & MAX3100_RAFE) {
+			s->port.icount.frame++;
+			flag = TTY_FRAME;
+		}
+		if (s->parity & MAX3100_PARITY_ON &&
+		    max3100_check_parity(s, *rx)) {
+			s->port.icount.parity++;
+			flag = TTY_PARITY;
+		}
+		tty_insert_flip_char(s->tty, *rx & MAX3100_DATA, flag);
+	}
+
+	mutex_unlock(&s->spi_txrx);
+
+	if (push && got_char)
+		tty_schedule_flip(s->tty);
+	return got_char;
+}
+
+
+static void max3100_send_conf(struct max3100_port_s *s)
+{
+	u16 tx = 0, rx;
+
+	tx = MAX3100_WC | (s->conf & 0x0fff);
+	max3100_sr(s, tx, &rx, 1);
+}
+
+static int max3100_ok_to_send(struct max3100_port_s *s)
+{
+	if (C_CRTSCTS(s->tty) && (s->last_cts_rx & MAX3100_CTS) == 0)
+		return 0;
+	return !s->tx_stopped;
+}
+
+static void max3100_work(struct work_struct *w)
+{
+	struct max3100_port_s *s = container_of(w, struct max3100_port_s, work);
+	u16 tx, rx;
+	int nchars;		/* number of char waiting in the send buf */
+	int rxchars = 0;	/* chars received */
+
+	do {
+		unsigned long flags;
+
+		if (s->after_suspend) {
+			mdelay(25);
+			max3100_send_conf(s);
+			mdelay(25);
+			s->after_suspend = 0;
+		}
+
+		tx = MAX3100_RD;
+		/* rx a char so we get MAX3100_T and CTS current */
+		rxchars += max3100_sr(s, tx, &rx, 0);
+
+		spin_lock_irqsave(&s->tx_buf_lock, flags);
+		nchars = s->tx_buf_tot - s->tx_buf_cur;
+		tx = MAX3100_WD | (s->rts ? MAX3100_RTS : 0);
+		tx |= s->tx_buf[s->tx_buf_cur];
+		spin_unlock_irqrestore(&s->tx_buf_lock, flags);
+
+		if ((rx & MAX3100_T) &&	/* tx buffer empty*/
+		    max3100_ok_to_send(s) &&  /* fw ctrl decision */
+		    nchars > 0 && /* more to send */
+		    !s->force_end_work) {
+			if (s->parity & MAX3100_PARITY_ON)
+				max3100_calc_parity(s, &tx);
+			rxchars += max3100_sr(s, tx, &rx, 0);
+			nchars -= 1;
+			spin_lock_irqsave(&s->tx_buf_lock, flags);
+			s->tx_buf_cur += 1;
+			spin_unlock_irqrestore(&s->tx_buf_lock, flags);
+			if (nchars == 0) {
+				tty_wakeup(s->tty);
+				wake_up(&s->all_sent);
+			}
+		}
+		if (rxchars > MAX3100_FLIP_EVERY) {
+			tty_schedule_flip(s->tty);
+			rxchars = 0;
+		}
+	}
+	while ((nchars > 0 || 	/* more to send */
+		rx & MAX3100_R) && 	/* try to empy all the RX buffer */
+	       !s->force_end_work);
+	if (rxchars)
+		tty_schedule_flip(s->tty);
+	/* reschedule ourself if we have more chars to send (can be
+	 * that TX buffer was full). Must do this since we cannot
+	 * use TX empty interrupt. */
+	if (s->tx_buf_tot > 0 && s->tx_buf_cur < s->tx_buf_tot)
+		max3100_dowork(s);
+	if (!s->only_edge_irq && !s->force_end_work)
+		irq_state(s, 1);
+}
+
+static irqreturn_t max3100_irq(int irqno, void *dev_id)
+{
+	struct max3100_port_s	*s = dev_id;
+
+	if (!s->only_edge_irq)
+		irq_state(s, 0); /* avoid irq storm */
+	max3100_dowork(s);
+	return IRQ_HANDLED;
+}
+
+static void rs_stop(struct tty_struct *tty)
+{
+	struct max3100_port_s *s = tty->driver_data;
+
+	s->tx_stopped = 1;
+}
+
+static void rs_start(struct tty_struct *tty)
+{
+	struct max3100_port_s *s = tty->driver_data;
+
+	s->tx_stopped = 0;
+}
+
+static void rs_flush_chars(struct tty_struct *tty)
+{
+}
+
+static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
+{
+	struct max3100_port_s *s = tty->driver_data;
+
+	wait_event_timeout(s->all_sent,
+			   s->tx_buf_tot == 0 || s->tx_buf_tot == s->tx_buf_cur,
+			   timeout);
+}
+
+static void rs_flush_buffer(struct tty_struct *tty)
+{
+	struct max3100_port_s *s = tty->driver_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->tx_buf_lock, flags);
+	s->tx_buf_cur = 0;
+	s->tx_buf_tot = 0;
+	spin_unlock_irqrestore(&s->tx_buf_lock, flags);
+}
+
+static int rs_write(struct tty_struct *tty,
+		    const unsigned char *buf, int count)
+{
+	struct max3100_port_s *s = tty->driver_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->tx_buf_lock, flags);
+	if (s->tx_buf_tot > 0 && s->tx_buf_cur < s->tx_buf_tot) {
+		count = 0;
+	} else {
+		if (count > MAX3100_TX_BUF_N)
+			count = MAX3100_TX_BUF_N;
+		memcpy(s->tx_buf, buf, count);
+		s->tx_buf_cur = 0;
+		s->tx_buf_tot = count;
+	}
+	spin_unlock_irqrestore(&s->tx_buf_lock, flags);
+	max3100_dowork(s);
+	return count;
+}
+
+static int rs_write_room(struct tty_struct *tty)
+{
+	struct max3100_port_s *s = tty->driver_data;
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->tx_buf_lock, flags);
+	if (s->tx_buf_tot > 0 && s->tx_buf_cur < s->tx_buf_tot)
+		ret = 0;
+	else
+		ret = MAX3100_TX_BUF_N;
+	spin_unlock_irqrestore(&s->tx_buf_lock, flags);
+	return ret;
+}
+
+static int rs_chars_in_buffer(struct tty_struct *tty)
+{
+	struct max3100_port_s *s = tty->driver_data;
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->tx_buf_lock, flags);
+	if (s->tx_buf_tot > 0 && s->tx_buf_cur < s->tx_buf_tot)
+		ret = MAX3100_TX_BUF_N;
+	else
+		ret = 0;
+	spin_unlock_irqrestore(&s->tx_buf_lock, flags);
+	return ret;
+}
+
+static void internal_throttle(struct tty_struct *tty, char ch, int rts)
+{
+	struct max3100_port_s *s = tty->driver_data;
+	u16 tx = 0, rx;
+	int old_tx_stopped;
+
+	old_tx_stopped = s->tx_stopped;
+	s->tx_stopped = 1;
+	tx = MAX3100_RD;
+	/* wait for tx buf empty. Unfortunately we cannot avoid a busy
+	   loop (it should not take much since we block tx ... so at
+	   most a byte time) since TX empty interrupt is unusable (see
+	   Notes on top) */
+	do {
+		max3100_sr(s, tx, &rx, 1);
+		if ((rx & MAX3100_T) == 0)
+			schedule();
+	} while ((rx & MAX3100_T) == 0);
+
+	if (I_IXOFF(tty))
+		tx = MAX3100_WD | (s->rts ? MAX3100_RTS : 0) | (ch&0xff);
+	if (C_CRTSCTS(tty)) {
+		s->rts = rts ? 1 : 0;
+		tx =  MAX3100_WD | (s->rts ? MAX3100_RTS : 0) | MAX3100_TE;
+	}
+	if (tx)
+		max3100_sr(s, tx, &rx, 1);
+	s->tx_stopped = old_tx_stopped;
+	max3100_dowork(s);
+}
+
+static void rs_throttle(struct tty_struct *tty)
+{
+	internal_throttle(tty, STOP_CHAR(tty), 0);
+}
+
+static void rs_unthrottle(struct tty_struct *tty)
+{
+	internal_throttle(tty, START_CHAR(tty), 1);
+}
+
+static int get_lsr_info(struct max3100_port_s *s, unsigned int *value)
+{
+	unsigned char status;
+	u16 tx = 0, rx;
+
+	tx = MAX3100_RD;
+	max3100_sr(s, tx, &rx, 1);
+	status = (rx & MAX3100_CTS) > 0;
+	return put_user(status, value);
+}
+
+static int rs_ioctl(struct tty_struct *tty, struct file *file,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct max3100_port_s *s = tty->driver_data;
+	int retval = 0;
+
+	switch (cmd) {
+
+	case TIOCSERGETLSR: /* Get line status register */
+		return get_lsr_info(s, (unsigned int *) arg);
+
+	default:
+		retval = -ENOIOCTLCMD ;
+	}
+	return retval;
+}
+
+static void change_speed(struct max3100_port_s *s)
+{
+	unsigned cflag;
+	unsigned i;
+	u32 param_new;
+	u32 param_mask;
+
+	cflag = s->tty->termios->c_cflag;
+	param_new = 0;
+	param_mask = 0;
+
+	i = cflag & CBAUD;
+	switch (i) {
+	case B300:
+		if (s->crystal) {
+			param_new = 16;
+		} else {
+			dev_warn(&s->spi->dev, "unsupported baud rate!\n");
+			param_new = 15;
+		}
+		break;
+	case B600:
+		param_new = 15;
+		break;
+	case B1200:
+		param_new = 14;
+		break;
+	case B2400:
+		param_new = 13;
+		break;
+	case B4800:
+		param_new = 12;
+		break;
+	case B9600:
+		param_new = 11;
+		break;
+	case B19200:
+		param_new = 10;
+		break;
+	case B38400:
+		param_new = 9;
+		break;
+	case B57600:
+		param_new = 2;
+		break;
+	case B115200:
+		param_new = 1;
+		break;
+	case B230400:
+		if (s->crystal) {
+			param_new = 1;
+			dev_warn(&s->spi->dev, "unsupported baud rate!\n");
+		} else {
+			param_new = 0;
+		}
+		break;
+	default:
+		param_new = 1;
+		dev_warn(&s->spi->dev, "invalid baudrate\n");
+	}
+	param_new = (param_new - s->crystal) & MAX3100_BAUD;
+	param_mask |= MAX3100_BAUD;
+
+	if ((cflag & CSIZE) == CS8) {
+		param_new &= ~MAX3100_L;
+		s->parity &= ~MAX3100_7BIT;
+	} else {
+		param_new |= MAX3100_L;
+		s->parity |= MAX3100_7BIT;
+	}
+	param_mask |= MAX3100_L;
+
+	if (cflag & CSTOPB)
+		param_new |= MAX3100_ST;
+	else
+		param_new &= ~MAX3100_ST;
+	param_mask |= MAX3100_ST;
+
+	if (cflag & PARENB) {
+		param_new |= MAX3100_PE;
+		s->parity |= MAX3100_PARITY_ON;
+	} else {
+		param_new &= ~MAX3100_PE;
+		s->parity &= ~MAX3100_PARITY_ON;
+	}
+	param_mask |= MAX3100_PE;
+
+	if (cflag & PARODD) {
+		s->parity |= MAX3100_PARITY_ODD;
+	} else {
+		s->parity &= ~MAX3100_PARITY_ODD;
+	}
+
+	s->conf = (s->conf & ~param_mask) | (param_new & param_mask);
+	max3100_send_conf(s);
+
+	return;
+}
+
+
+static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+{
+	struct max3100_port_s *s = tty->driver_data;
+
+	if (tty->termios->c_cflag == old_termios->c_cflag)
+		return;
+
+	change_speed(s);
+
+	if ((old_termios->c_cflag & CRTSCTS) &&
+	    !(tty->termios->c_cflag & CRTSCTS))
+		max3100_dowork(s);
+}
+
+static void shutdown(struct max3100_port_s *s)
+{
+	u16 tx, rx;
+
+	s->force_end_work = 1;
+	if (s->workqueue) {
+		flush_workqueue(s->workqueue);
+		destroy_workqueue(s->workqueue);
+	}
+	if (s->irq)
+		free_irq(s->irq, s);
+	kfree(s->tx_buf);
+	s->tx_buf = NULL;
+	if (s->tty)
+		set_bit(TTY_IO_ERROR, &s->tty->flags);
+	/* set shutdown mode to save power */
+	tx = MAX3100_WC | MAX3100_SHDN;
+	max3100_sr(s, tx, &rx, 0);
+}
+
+static void rs_hangup(struct tty_struct *tty)
+{
+	struct max3100_port_s *s = tty->driver_data;
+
+	shutdown(s);
+}
+
+static int startup(struct max3100_port_s *s)
+{
+	char b[10];
+	int irq_type;
+
+	s->tx_buf = kmalloc(MAX3100_TX_BUF_N, GFP_KERNEL);
+	if (s->tx_buf == NULL)
+		return -ENOMEM;
+	s->tx_buf_cur = 0;
+	s->tx_buf_tot = 0;
+
+	s->force_end_work = 0;
+	s->parity = 0;
+	s->rts = 0;
+	s->tx_stopped = 0;
+	s->conf = MAX3100_RM;
+
+	sprintf(b, "max3100-%d", s->minor);
+	s->workqueue = create_singlethread_workqueue(b);
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
+		kfree(s->tx_buf);
+		return -EBUSY;
+	}
+
+	if (s->tty)
+		clear_bit(TTY_IO_ERROR, &s->tty->flags);
+
+	change_speed(s);
+	mdelay(50);		/* waits for wakeup from shutdown */
+
+	if (s->loopback) {
+		u16 tx, rx;
+		tx = 0x4001;
+		max3100_sr(s, tx, &rx, 1);
+	}
+
+	return 0;
+}
+
+int rs_open(struct tty_struct *tty, struct file *filp)
+{
+	struct max3100_port_s *s;
+	int retval = 0, line;
+
+	line = tty->index;
+
+	if (line >= MAX_MAX3100 || line < 0)
+		return -ENODEV;
+
+	s = max3100s[line];
+
+	if (!s) {
+		printk(KERN_ERR "Nonexistent max3100 for index %d\n", line);
+		return -ENODEV;
+	}
+
+	retval = mutex_lock_interruptible(&s->sem);
+	if (retval < 0)
+		return retval;
+
+	s->ref_count++;
+
+	if (s->ref_count == 1) {
+		tty->driver_data = s;
+		s->tty = tty;
+
+		retval = startup(s);
+	}
+
+	mutex_unlock(&s->sem);
+
+	return retval;
+}
+
+static void rs_close(struct tty_struct *tty, struct file *filp)
+{
+	struct max3100_port_s *s = tty->driver_data;
+
+	mutex_lock(&s->sem);
+
+	s->ref_count--;
+	if (s->ref_count == 0)
+		shutdown(s);
+
+	mutex_unlock(&s->sem);
+}
+
+static int rs_tiocmget(struct tty_struct *tty, struct file *file)
+{
+	struct max3100_port_s *s = tty->driver_data;
+	u16 tx, rx;
+	unsigned int result;
+
+	tx =  MAX3100_RD;
+	max3100_sr(s, tx, &rx, 1);
+
+	result =  ((s->rts) ? TIOCM_RTS : 0)
+		| ((rx  & MAX3100_CTS) ? TIOCM_CTS : 0);
+	return result;
+}
+
+static int rs_tiocmset(struct tty_struct *tty, struct file *file,
+			   unsigned int set, unsigned int clear)
+{
+	struct max3100_port_s *s = tty->driver_data;
+	int old_rts = s->rts;
+	u16 tx, rx;
+
+	if (set & TIOCM_RTS)
+		s->rts = 1;
+	if (clear & TIOCM_RTS)
+		s->rts = 0;
+
+	if (s->rts != old_rts) {
+		tx =  MAX3100_WD | (s->rts ? MAX3100_RTS : 0) | MAX3100_TE;
+		max3100_sr(s, tx, &rx, 1);
+	}
+	return 0;
+}
+
+static struct tty_operations rs_ops = {
+	.open = rs_open,
+	.close = rs_close,
+	.write = rs_write,
+	.flush_chars = rs_flush_chars,
+	.wait_until_sent = rs_wait_until_sent,
+	.write_room = rs_write_room,
+	.chars_in_buffer = rs_chars_in_buffer,
+	.flush_buffer = rs_flush_buffer,
+	.ioctl = rs_ioctl,
+	.throttle = rs_throttle,
+	.unthrottle = rs_unthrottle,
+	.set_termios = rs_set_termios,
+	.stop = rs_stop,
+	.start = rs_start,
+	.hangup = rs_hangup,
+	.tiocmget = rs_tiocmget,
+	.tiocmset = rs_tiocmset,
+};
+
+static int __devinit max3100_probe(struct spi_device *spi)
+{
+	int i;
+	struct plat_max3100 *pdata;
+	u16 tx, rx;
+
+	if (!serial_driver) {
+		serial_driver = alloc_tty_driver(MAX_MAX3100);
+		if (!serial_driver) {
+			printk(KERN_ERR "Cannot allocate serial driver\n");
+			return -ENOMEM;
+		}
+
+		serial_driver->name = "ttyMAX";
+		serial_driver->driver_name = "ttyMAX";
+		serial_driver->major = TTY_MAJOR;
+		/* this should prevent clashes */
+		serial_driver->minor_start = 128;
+		serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
+		serial_driver->subtype = SERIAL_TYPE_NORMAL;
+		serial_driver->init_termios = tty_std_termios;
+		serial_driver->init_termios.c_cflag =
+			B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+		serial_driver->flags = TTY_DRIVER_REAL_RAW |
+			TTY_DRIVER_DYNAMIC_DEV;
+		tty_set_operations(serial_driver, &rs_ops);
+
+		if (tty_register_driver(serial_driver)) {
+			put_tty_driver(serial_driver);
+			printk(KERN_ERR "Couldn't register serial driver\n");
+			return -EINVAL;
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
+	max3100s[i] = kzalloc(sizeof(struct max3100_port_s), GFP_KERNEL);
+	if (!max3100s[i]) {
+		dev_warn(&spi->dev,
+			 "kmalloc for max3100 structure %d failed!\n", i);
+		return -ENOMEM;
+	}
+	max3100s[i]->spi = spi;
+	max3100s[i]->irq = spi->irq;
+	mutex_init(&max3100s[i]->sem);
+	mutex_init(&max3100s[i]->spi_txrx);
+	spin_lock_init(&max3100s[i]->tx_buf_lock);
+	spin_lock_init(&max3100s[i]->irq_lock);
+	init_waitqueue_head(&max3100s[i]->all_sent);
+	dev_set_drvdata(&spi->dev, max3100s[i]);
+	pdata = spi->dev.platform_data;
+	max3100s[i]->crystal = pdata->crystal;
+	max3100s[i]->loopback = pdata->loopback;
+	max3100s[i]->only_edge_irq = pdata->only_edge_irq;
+	max3100s[i]->after_suspend = 0;
+	max3100s[i]->max3100_hw_suspend = pdata->max3100_hw_suspend;
+	max3100s[i]->minor = i;
+	tty_register_device(serial_driver, i, &spi->dev);
+	/* set shutdown mode to save power. Will be woken-up on open */
+	tx = MAX3100_WC | MAX3100_SHDN;
+	max3100_sr(max3100s[i], tx, &rx, 0);
+
+	return 0;
+}
+
+static int __devexit max3100_remove(struct spi_device *spi)
+{
+	struct max3100_port_s *s = dev_get_drvdata(&spi->dev);
+	int i;
+
+	if (s->ref_count > 0)
+		return -EBUSY;
+
+	/* find out the index for the chip we are removing */
+	for (i = 0; i < MAX_MAX3100; i++)
+		if (max3100s[i] == s)
+			break;
+
+	tty_unregister_device(serial_driver, i);
+	kfree(max3100s[i]);
+	max3100s[i] = NULL;
+
+	/* check if this is the last chip we have */
+	for (i = 0; i < MAX_MAX3100; i++)
+		if (max3100s[i])
+			return 0;
+	tty_unregister_driver(serial_driver);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static int max3100_suspend(struct spi_device *spi, pm_message_t state)
+{
+	struct max3100_port_s *s = dev_get_drvdata(&spi->dev);
+
+	s->force_end_work = 1;
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
+		max3100_sr(s, tx, &rx, 0);
+	}
+	return 0;
+}
+
+static int max3100_resume(struct spi_device *spi)
+{
+	struct max3100_port_s *s = dev_get_drvdata(&spi->dev);
+
+	s->force_end_work = 0;
+	irq_state(s, 1);
+
+	if (s->max3100_hw_suspend)
+		s->max3100_hw_suspend(0);
+	s->after_suspend = 1;
+	max3100_dowork(s);
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
+MODULE_LICENSE("GPL");
diff --git a/include/linux/serial_max3100.h b/include/linux/serial_max3100.h
new file mode 100644
index 0000000..5c0489e
--- /dev/null
+++ b/include/linux/serial_max3100.h
@@ -0,0 +1,28 @@
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
+};
+
+#endif
--
1.4.4.4
