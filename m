Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZIPKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZIPKBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIPKBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:01:15 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:2625 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZIPKBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:01:12 -0400
X-IronPort-AV: E=Sophos;i="4.44,396,1249272000"; 
   d="scan'208";a="6422901"
Subject: [PATCH][uart] fit blackfin uart over sport driver into common uart
	inftrastructure (v2)
From: sonic zhang <sonic.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 18:02:28 +0800
Message-ID: <1253095348.25791.6.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fit blackfin uart over sport driver into common uart inftrastructure.

1. Disable local interrupts in 32-bit reading from SPORT RX MMR to walk
around the RX underflow hardware issue when this reading is interrupted
by the other IRQ.

2. Enable sport uart driver to change uart baud, data bit, stop bit at
runtime.

3. Move most platform data into arch specific board files.

4. Console is registered in sport uart driver as well.

5. Remove 500 us block waiting in sport tx stop code by putting a dummy
data into tx fifo to make sure the sport tx stops when all bytes are
shifted out except for the dummy data.

6. clean up a bit and fix up coding style.


Signed-off-by: Michael Frysinger <michael.frysinger@analog.com>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/serial/Kconfig           |   24 ++
 drivers/serial/bfin_sport_uart.c |  747 ++++++++++++++++++++++++++------------
 drivers/serial/bfin_sport_uart.h |   49 ++-
 3 files changed, 571 insertions(+), 249 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 03422ce..45f63a8 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1451,6 +1451,30 @@ config SPORT_BAUD_RATE
 	default 19200 if (SERIAL_SPORT_BAUD_RATE_19200)
 	default 9600 if (SERIAL_SPORT_BAUD_RATE_9600)
 
+config SERIAL_BFIN_SPORT0_UART
+	bool "Enable UART over SPORT0"
+	depends on SERIAL_BFIN_SPORT
+	help
+	  Enable UART over SPORT0
+
+config SERIAL_BFIN_SPORT1_UART
+	bool "Enable UART over SPORT1"
+	depends on SERIAL_BFIN_SPORT
+	help
+	  Enable UART over SPORT1
+
+config SERIAL_BFIN_SPORT2_UART
+	bool "Enable UART over SPORT2"
+	depends on SERIAL_BFIN_SPORT && (BF54x || BF538 || BF539)
+	help
+	  Enable UART over SPORT2
+
+config SERIAL_BFIN_SPORT3_UART
+	bool "Enable UART over SPORT3"
+	depends on SERIAL_BFIN_SPORT && (BF54x || BF538 || BF539)
+	help
+	  Enable UART over SPORT3
+
 config SERIAL_TIMBERDALE
 	tristate "Support for timberdale UART"
 	depends on MFD_TIMBERDALE
diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index c108b1a..26a536a 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -1,27 +1,11 @@
 /*
- * File:	linux/drivers/serial/bfin_sport_uart.c
+ * Blackfin On-Chip Sport Emulated UART Driver
  *
- * Based on:	drivers/serial/bfin_5xx.c by Aubrey Li.
- * Author:	Roy Huang <roy.huang@analog.com>
+ * Copyright 2006-2009 Analog Devices Inc.
  *
- * Created:	Nov 22, 2006
- * Copyright:	(c) 2006-2007 Analog Devices Inc.
- * Description: this driver enable SPORTs on Blackfin emulate UART.
+ * Enter bugs at http://blackfin.uclinux.org/
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ * Licensed under the GPL-2 or later.
  */
 
 /*
@@ -29,39 +13,17 @@
  * http://www.analog.com/UploadedFiles/Application_Notes/399447663EE191.pdf
  * This application note describe how to implement a UART on a Sharc DSP,
  * but this driver is implemented on Blackfin Processor.
+ * Transmit Frame Sync is not used by this driver to transfer data out.
  */
 
-/* After reset, there is a prelude of low level pulse when transmit data first
- * time. No addtional pulse in following transmit.
- * According to document:
- * The SPORTs are ready to start transmitting or receiving data no later than
- * three serial clock cycles after they are enabled in the SPORTx_TCR1 or
- * SPORTx_RCR1 register. No serial clock cycles are lost from this point on.
- * The first internal frame sync will occur one frame sync delay after the
- * SPORTs are ready. External frame syncs can occur as soon as the SPORT is
- * ready.
- */
+/* #define DEBUG */
 
-/* Thanks to Axel Alatalo <axel@rubico.se> for fixing sport rx bug. Sometimes
- * sport receives data incorrectly. The following is Axel's words.
- * As EE-191, sport rx samples 3 times of the UART baudrate and takes the
- * middle smaple of every 3 samples as the data bit. For a 8-N-1 UART setting,
- * 30 samples will be required for a byte. If transmitter sends a 1/3 bit short
- * byte due to buadrate drift, then the 30th sample of a byte, this sample is
- * also the third sample of the stop bit, will happens on the immediately
- * following start bit which will be thrown away and missed. Thus since parts
- * of the startbit will be missed and the receiver will begin to drift, the
- * effect accumulates over time until synchronization is lost.
- * If only require 2 samples of the stopbit (by sampling in total 29 samples),
- * then a to short byte as in the case above will be tolerated. Then the 1/3
- * early startbit will trigger a framesync since the last read is complete
- * after only 2/3 stopbit and framesync is active during the last 1/3 looking
- * for a possible early startbit. */
-
-//#define DEBUG
+#define DRV_NAME "bfin-sport-uart"
+#define DEVICE_NAME	"ttySS"
 
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/console.h>
 #include <linux/sysrq.h>
@@ -75,23 +37,36 @@
 
 #include "bfin_sport_uart.h"
 
+#ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
 unsigned short bfin_uart_pin_req_sport0[] =
 	{P_SPORT0_TFS, P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS, \
 	 P_SPORT0_DRPRI, P_SPORT0_RSCLK, P_SPORT0_DRSEC, P_SPORT0_DTSEC, 0};
-
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT1_UART
 unsigned short bfin_uart_pin_req_sport1[] =
 	{P_SPORT1_TFS, P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS, \
 	P_SPORT1_DRPRI, P_SPORT1_RSCLK, P_SPORT1_DRSEC, P_SPORT1_DTSEC, 0};
-
-#define DRV_NAME "bfin-sport-uart"
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT2_UART
+unsigned short bfin_uart_pin_req_sport2[] =
+	{P_SPORT2_TFS, P_SPORT2_DTPRI, P_SPORT2_TSCLK, P_SPORT2_RFS, \
+	P_SPORT2_DRPRI, P_SPORT2_RSCLK, P_SPORT2_DRSEC, P_SPORT2_DTSEC, 0};
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT3_UART
+unsigned short bfin_uart_pin_req_sport3[] =
+	{P_SPORT3_TFS, P_SPORT3_DTPRI, P_SPORT3_TSCLK, P_SPORT3_RFS, \
+	P_SPORT3_DRPRI, P_SPORT3_RSCLK, P_SPORT3_DRSEC, P_SPORT3_DTSEC, 0};
+#endif
 
 struct sport_uart_port {
 	struct uart_port	port;
-	char			*name;
-
-	int			tx_irq;
-	int			rx_irq;
 	int			err_irq;
+	unsigned short		csize;
+	unsigned short		rxmask;
+	unsigned short		txmask1;
+	unsigned short		txmask2;
+	unsigned char		stopb;
+/*	unsigned char		parib; */
 };
 
 static void sport_uart_tx_chars(struct sport_uart_port *up);
@@ -99,36 +74,42 @@ static void sport_stop_tx(struct uart_port *port);
 
 static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
 {
-	pr_debug("%s value:%x\n", __func__, value);
-	/* Place a Start and Stop bit */
+	pr_debug("%s value:%x, mask1=0x%x, mask2=0x%x\n", __func__, value,
+		up->txmask1, up->txmask2);
+
+	/* Place Start and Stop bits */
 	__asm__ __volatile__ (
-		"R2 = b#01111111100;"
-		"R3 = b#10000000001;"
-		"%0 <<= 2;"
-		"%0 = %0 & R2;"
-		"%0 = %0 | R3;"
-		: "=d"(value)
-		: "d"(value)
-		: "ASTAT", "R2", "R3"
+		"%[val] <<= 1;"
+		"%[val] = %[val] & %[mask1];"
+		"%[val] = %[val] | %[mask2];"
+		: [val]"+d"(value)
+		: [mask1]"d"(up->txmask1), [mask2]"d"(up->txmask2)
+		: "ASTAT"
 	);
 	pr_debug("%s value:%x\n", __func__, value);
 
 	SPORT_PUT_TX(up, value);
 }
 
-static inline unsigned int rx_one_byte(struct sport_uart_port *up)
+static inline unsigned char rx_one_byte(struct sport_uart_port *up)
 {
-	unsigned int value, extract;
+	unsigned int value;
+	unsigned char extract;
 	u32 tmp_mask1, tmp_mask2, tmp_shift, tmp;
 
-	value = SPORT_GET_RX32(up);
-	pr_debug("%s value:%x\n", __func__, value);
+	if ((up->csize + up->stopb) > 7)
+		value = SPORT_GET_RX32(up);
+	else
+		value = SPORT_GET_RX(up);
+
+	pr_debug("%s value:%x, cs=%d, mask=0x%x\n", __func__, value,
+		up->csize, up->rxmask);
 
-	/* Extract 8 bits data */
+	/* Extract data */
 	__asm__ __volatile__ (
 		"%[extr] = 0;"
-		"%[mask1] = 0x1801(Z);"
-		"%[mask2] = 0x0300(Z);"
+		"%[mask1] = %[rxmask];"
+		"%[mask2] = 0x0200(Z);"
 		"%[shift] = 0;"
 		"LSETUP(.Lloop_s, .Lloop_e) LC0 = %[lc];"
 		".Lloop_s:"
@@ -138,9 +119,9 @@ static inline unsigned int rx_one_byte(struct sport_uart_port *up)
 		"%[mask1] = %[mask1] - %[mask2];"
 		".Lloop_e:"
 		"%[shift] += 1;"
-		: [val]"=d"(value), [extr]"=d"(extract), [shift]"=d"(tmp_shift), [tmp]"=d"(tmp),
-		  [mask1]"=d"(tmp_mask1), [mask2]"=d"(tmp_mask2)
-		: "d"(value), [lc]"a"(8)
+		: [extr]"=&d"(extract), [shift]"=&d"(tmp_shift), [tmp]"=&d"(tmp),
+		  [mask1]"=&d"(tmp_mask1), [mask2]"=&d"(tmp_mask2)
+		: [val]"d"(value), [rxmask]"d"(up->rxmask), [lc]"a"(up->csize)
 		: "ASTAT", "LB0", "LC0", "LT0"
 	);
 
@@ -148,29 +129,28 @@ static inline unsigned int rx_one_byte(struct sport_uart_port *up)
 	return extract;
 }
 
-static int sport_uart_setup(struct sport_uart_port *up, int sclk, int baud_rate)
+static int sport_uart_setup(struct sport_uart_port *up, int size, int baud_rate)
 {
-	int tclkdiv, tfsdiv, rclkdiv;
+	int tclkdiv, rclkdiv;
+	unsigned int sclk = get_sclk();
 
-	/* Set TCR1 and TCR2 */
-	SPORT_PUT_TCR1(up, (LATFS | ITFS | TFSR | TLSBIT | ITCLK));
-	SPORT_PUT_TCR2(up, 10);
+	/* Set TCR1 and TCR2, TFSR is not enabled for uart */
+	SPORT_PUT_TCR1(up, (ITFS | TLSBIT | ITCLK));
+	SPORT_PUT_TCR2(up, size + 1);
 	pr_debug("%s TCR1:%x, TCR2:%x\n", __func__, SPORT_GET_TCR1(up), SPORT_GET_TCR2(up));
 
 	/* Set RCR1 and RCR2 */
 	SPORT_PUT_RCR1(up, (RCKFE | LARFS | LRFS | RFSR | IRCLK));
-	SPORT_PUT_RCR2(up, 28);
+	SPORT_PUT_RCR2(up, (size + 1) * 2 - 1);
 	pr_debug("%s RCR1:%x, RCR2:%x\n", __func__, SPORT_GET_RCR1(up), SPORT_GET_RCR2(up));
 
 	tclkdiv = sclk/(2 * baud_rate) - 1;
-	tfsdiv = 12;
-	rclkdiv = sclk/(2 * baud_rate * 3) - 1;
+	rclkdiv = sclk/(2 * baud_rate * 2) - 1;
 	SPORT_PUT_TCLKDIV(up, tclkdiv);
-	SPORT_PUT_TFSDIV(up, tfsdiv);
 	SPORT_PUT_RCLKDIV(up, rclkdiv);
 	SSYNC();
-	pr_debug("%s sclk:%d, baud_rate:%d, tclkdiv:%d, tfsdiv:%d, rclkdiv:%d\n",
-			__func__, sclk, baud_rate, tclkdiv, tfsdiv, rclkdiv);
+	pr_debug("%s sclk:%d, baud_rate:%d, tclkdiv:%d, rclkdiv:%d\n",
+			__func__, sclk, baud_rate, tclkdiv, rclkdiv);
 
 	return 0;
 }
@@ -181,23 +161,29 @@ static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
 	struct tty_struct *tty = up->port.info->port.tty;
 	unsigned int ch;
 
-	do {
+	spin_lock(&up->port.lock);
+
+	while (SPORT_GET_STAT(up) & RXNE) {
 		ch = rx_one_byte(up);
 		up->port.icount.rx++;
 
-		if (uart_handle_sysrq_char(&up->port, ch))
-			;
-		else
+		if (!uart_handle_sysrq_char(&up->port, ch))
 			tty_insert_flip_char(tty, ch, TTY_NORMAL);
-	} while (SPORT_GET_STAT(up) & RXNE);
+	}
 	tty_flip_buffer_push(tty);
 
+	spin_unlock(&up->port.lock);
+
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t sport_uart_tx_irq(int irq, void *dev_id)
 {
-	sport_uart_tx_chars(dev_id);
+	struct sport_uart_port *up = dev_id;
+
+	spin_lock(&up->port.lock);
+	sport_uart_tx_chars(up);
+	spin_unlock(&up->port.lock);
 
 	return IRQ_HANDLED;
 }
@@ -208,6 +194,8 @@ static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 	struct tty_struct *tty = up->port.info->port.tty;
 	unsigned int stat = SPORT_GET_STAT(up);
 
+	spin_lock(&up->port.lock);
+
 	/* Overflow in RX FIFO */
 	if (stat & ROVF) {
 		up->port.icount.overrun++;
@@ -216,15 +204,16 @@ static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 	}
 	/* These should not happen */
 	if (stat & (TOVF | TUVF | RUVF)) {
-		printk(KERN_ERR "SPORT Error:%s %s %s\n",
-				(stat & TOVF)?"TX overflow":"",
-				(stat & TUVF)?"TX underflow":"",
-				(stat & RUVF)?"RX underflow":"");
+		pr_err("SPORT Error:%s %s %s\n",
+		       (stat & TOVF) ? "TX overflow" : "",
+		       (stat & TUVF) ? "TX underflow" : "",
+		       (stat & RUVF) ? "RX underflow" : "");
 		SPORT_PUT_TCR1(up, SPORT_GET_TCR1(up) & ~TSPEN);
 		SPORT_PUT_RCR1(up, SPORT_GET_RCR1(up) & ~RSPEN);
 	}
 	SSYNC();
 
+	spin_unlock(&up->port.lock);
 	return IRQ_HANDLED;
 }
 
@@ -232,60 +221,37 @@ static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 static int sport_startup(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
-	char buffer[20];
-	int retval;
+	int ret;
 
 	pr_debug("%s enter\n", __func__);
-	snprintf(buffer, 20, "%s rx", up->name);
-	retval = request_irq(up->rx_irq, sport_uart_rx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
-	if (retval) {
-		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
-		return retval;
+	ret = request_irq(up->port.irq, sport_uart_rx_irq, 0,
+		"SPORT_UART_RX", up);
+	if (ret) {
+		dev_err(port->dev, "unable to request SPORT RX interrupt\n");
+		return ret;
 	}
 
-	snprintf(buffer, 20, "%s tx", up->name);
-	retval = request_irq(up->tx_irq, sport_uart_tx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
-	if (retval) {
-		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
+	ret = request_irq(up->port.irq+1, sport_uart_tx_irq, 0,
+		"SPORT_UART_TX", up);
+	if (ret) {
+		dev_err(port->dev, "unable to request SPORT TX interrupt\n");
 		goto fail1;
 	}
 
-	snprintf(buffer, 20, "%s err", up->name);
-	retval = request_irq(up->err_irq, sport_uart_err_irq, IRQF_SAMPLE_RANDOM, buffer, up);
-	if (retval) {
-		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
+	ret = request_irq(up->err_irq, sport_uart_err_irq, 0,
+		"SPORT_UART_STATUS", up);
+	if (ret) {
+		dev_err(port->dev, "unable to request SPORT status interrupt\n");
 		goto fail2;
 	}
 
-	if (port->line) {
-		if (peripheral_request_list(bfin_uart_pin_req_sport1, DRV_NAME))
-			goto fail3;
-	} else {
-		if (peripheral_request_list(bfin_uart_pin_req_sport0, DRV_NAME))
-			goto fail3;
-	}
-
-	sport_uart_setup(up, get_sclk(), port->uartclk);
-
-	/* Enable receive interrupt */
-	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) | RSPEN));
-	SSYNC();
-
 	return 0;
+ fail2:
+	free_irq(up->port.irq+1, up);
+ fail1:
+	free_irq(up->port.irq, up);
 
-
-fail3:
-	printk(KERN_ERR DRV_NAME
-		": Requesting Peripherals failed\n");
-
-	free_irq(up->err_irq, up);
-fail2:
-	free_irq(up->tx_irq, up);
-fail1:
-	free_irq(up->rx_irq, up);
-
-	return retval;
-
+	return ret;
 }
 
 static void sport_uart_tx_chars(struct sport_uart_port *up)
@@ -344,20 +310,17 @@ static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
 static void sport_stop_tx(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
-	unsigned int stat;
 
 	pr_debug("%s enter\n", __func__);
 
-	stat = SPORT_GET_STAT(up);
-	while(!(stat & TXHRE)) {
-		udelay(1);
-		stat = SPORT_GET_STAT(up);
-	}
 	/* Although the hold register is empty, last byte is still in shift
-	 * register and not sent out yet. If baud rate is lower than default,
-	 * delay should be longer. For example, if the baud rate is 9600,
-	 * the delay must be at least 2ms by experience */
-	udelay(500);
+	 * register and not sent out yet. So, put a dummy data into TX FIFO.
+	 * Then, sport tx stops when last byte is shift out and the dummy
+	 * data is moved into the shift register.
+	 */
+	SPORT_PUT_TX(up, 0xffff);
+	while (!(SPORT_GET_STAT(up) & TXHRE))
+		cpu_relax();
 
 	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) & ~TSPEN));
 	SSYNC();
@@ -370,6 +333,7 @@ static void sport_start_tx(struct uart_port *port)
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
 	pr_debug("%s enter\n", __func__);
+
 	/* Write data into SPORT FIFO before enable SPROT to transmit */
 	sport_uart_tx_chars(up);
 
@@ -403,37 +367,24 @@ static void sport_shutdown(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
-	pr_debug("%s enter\n", __func__);
+	dev_dbg(port->dev, "%s enter\n", __func__);
 
 	/* Disable sport */
 	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) & ~TSPEN));
 	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) & ~RSPEN));
 	SSYNC();
 
-	if (port->line) {
-		peripheral_free_list(bfin_uart_pin_req_sport1);
-	} else {
-		peripheral_free_list(bfin_uart_pin_req_sport0);
-	}
-
-	free_irq(up->rx_irq, up);
-	free_irq(up->tx_irq, up);
+	free_irq(up->port.irq, up);
+	free_irq(up->port.irq+1, up);
 	free_irq(up->err_irq, up);
 }
 
-static void sport_set_termios(struct uart_port *port,
-		struct ktermios *termios, struct ktermios *old)
-{
-	pr_debug("%s enter, c_cflag:%08x\n", __func__, termios->c_cflag);
-	uart_update_timeout(port, CS8 ,port->uartclk);
-}
-
 static const char *sport_type(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
 	pr_debug("%s enter\n", __func__);
-	return up->name;
+	return up->port.type == PORT_BFIN_SPORT ? "BFIN-SPORT-UART" : NULL;
 }
 
 static void sport_release_port(struct uart_port *port)
@@ -461,6 +412,110 @@ static int sport_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return 0;
 }
 
+static void sport_set_termios(struct uart_port *port,
+		struct ktermios *termios, struct ktermios *old)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+	unsigned long flags;
+	int i;
+
+	pr_debug("%s enter, c_cflag:%08x\n", __func__, termios->c_cflag);
+
+	switch (termios->c_cflag & CSIZE) {
+	case CS8:
+		up->csize = 8;
+		break;
+	case CS7:
+		up->csize = 7;
+		break;
+	case CS6:
+		up->csize = 6;
+		break;
+	case CS5:
+		up->csize = 5;
+		break;
+	default:
+		pr_warning("requested word length not supported\n");
+	}
+
+	if (termios->c_cflag & CSTOPB) {
+		up->stopb = 1;
+	}
+	if (termios->c_cflag & PARENB) {
+		pr_warning("PAREN bits is not supported yet\n");
+		/* up->parib = 1; */
+	}
+
+	port->read_status_mask = OE;
+	if (termios->c_iflag & INPCK)
+		port->read_status_mask |= (FE | PE);
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		port->read_status_mask |= BI;
+
+	/*
+	 * Characters to ignore
+	 */
+	port->ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		port->ignore_status_mask |= FE | PE;
+	if (termios->c_iflag & IGNBRK) {
+		port->ignore_status_mask |= BI;
+		/*
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR)
+			port->ignore_status_mask |= OE;
+	}
+
+	/* RX extract mask */
+	up->rxmask = 0x01 | (((up->csize + up->stopb) * 2 - 1) << 0x8);
+	/* TX masks, 8 bit data and 1 bit stop for example:
+	 * mask1 = b#0111111110
+	 * mask2 = b#1000000000
+	 */
+	for (i = 0, up->txmask1 = 0; i < up->csize; i++)
+		up->txmask1 |= (1<<i);
+	up->txmask2 = (1<<i);
+	if (up->stopb) {
+		++i;
+		up->txmask2 |= (1<<i);
+	}
+	up->txmask1 <<= 1;
+	up->txmask2 <<= 1;
+	/* uart baud rate */
+	port->uartclk = uart_get_baud_rate(port, termios, old, 0, get_sclk()/16);
+
+	spin_lock_irqsave(&up->port.lock, flags);
+
+	/* Disable UART */
+	SPORT_PUT_TCR1(up, SPORT_GET_TCR1(up) & ~TSPEN);
+	SPORT_PUT_RCR1(up, SPORT_GET_RCR1(up) & ~RSPEN);
+
+	sport_uart_setup(up, up->csize + up->stopb, port->uartclk);
+
+	/* driver TX line high after config, one dummy data is
+	 * necessary to stop sport after shift one byte
+	 */
+	SPORT_PUT_TX(up, 0xffff);
+	SPORT_PUT_TX(up, 0xffff);
+	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) | TSPEN));
+	SSYNC();
+	while (!(SPORT_GET_STAT(up) & TXHRE))
+		cpu_relax();
+	SPORT_PUT_TCR1(up, SPORT_GET_TCR1(up) & ~TSPEN);
+	SSYNC();
+
+	/* Port speed changed, update the per-port timeout. */
+	uart_update_timeout(port, termios->c_cflag, port->uartclk);
+
+	/* Enable sport rx */
+	SPORT_PUT_RCR1(up, SPORT_GET_RCR1(up) | RSPEN);
+	SSYNC();
+
+	spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
 struct uart_ops sport_uart_ops = {
 	.tx_empty	= sport_tx_empty,
 	.set_mctrl	= sport_set_mctrl,
@@ -480,94 +535,314 @@ struct uart_ops sport_uart_ops = {
 	.verify_port	= sport_verify_port,
 };
 
-static struct sport_uart_port sport_uart_ports[] = {
-	{ /* SPORT 0 */
-		.name	= "SPORT0",
-		.tx_irq = IRQ_SPORT0_TX,
-		.rx_irq = IRQ_SPORT0_RX,
-		.err_irq= IRQ_SPORT0_ERROR,
-		.port	= {
-			.type		= PORT_BFIN_SPORT,
-			.iotype		= UPIO_MEM,
-			.membase	= (void __iomem *)SPORT0_TCR1,
-			.mapbase	= SPORT0_TCR1,
-			.irq		= IRQ_SPORT0_RX,
-			.uartclk	= CONFIG_SPORT_BAUD_RATE,
-			.fifosize	= 8,
-			.ops		= &sport_uart_ops,
-			.line		= 0,
-		},
-	}, { /* SPORT 1 */
-		.name	= "SPORT1",
-		.tx_irq = IRQ_SPORT1_TX,
-		.rx_irq = IRQ_SPORT1_RX,
-		.err_irq= IRQ_SPORT1_ERROR,
-		.port	= {
-			.type		= PORT_BFIN_SPORT,
-			.iotype		= UPIO_MEM,
-			.membase	= (void __iomem *)SPORT1_TCR1,
-			.mapbase	= SPORT1_TCR1,
-			.irq		= IRQ_SPORT1_RX,
-			.uartclk	= CONFIG_SPORT_BAUD_RATE,
-			.fifosize	= 8,
-			.ops		= &sport_uart_ops,
-			.line		= 1,
-		},
+#if defined(CONFIG_SERIAL_BFIN_SPORT3_UART)
+#define BFIN_SPORT_UART_MAX_PORTS 4
+#elif defined(CONFIG_SERIAL_BFIN_SPORT2_UART)
+#define BFIN_SPORT_UART_MAX_PORTS 3
+#else
+#define BFIN_SPORT_UART_MAX_PORTS 2
+#endif
+
+static struct sport_uart_port bfin_sport_uart_ports[BFIN_SPORT_UART_MAX_PORTS];
+
+static unsigned long bfin_sport_uart_console_base_addr[] = {
+#ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
+		SPORT0_TCR1,
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT1_UART
+		SPORT1_TCR1,
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT2_UART
+		SPORT2_TCR1,
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT3_UART
+		SPORT3_TCR1,
+#endif
+};
+
+static int nr_active_ports = ARRAY_SIZE(bfin_sport_uart_console_base_addr);
+
+static int __init sport_uart_init_ports(void)
+{
+	static int first = 1;
+	int i, ret;
+
+	if (!first)
+		return 0;
+
+#ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
+	ret = peripheral_request_list(bfin_uart_pin_req_sport0, DRV_NAME);
+	if (ret) {
+		pr_err("requesting SPORT0 peripherals failed\n");
+		goto err_out0;
+	}
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT1_UART
+	ret = peripheral_request_list(bfin_uart_pin_req_sport1, DRV_NAME);
+	if (ret) {
+		pr_err("requesting SPORT1 peripherals failed\n");
+		goto err_out1;
+	}
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT2_UART
+	ret = peripheral_request_list(bfin_uart_pin_req_sport2, DRV_NAME);
+	if (ret) {
+		pr_err("requesting SPORT2 peripherals failed\n");
+		goto err_out2;
+	}
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT3_UART
+	ret = peripheral_request_list(bfin_uart_pin_req_sport3, DRV_NAME);
+	if (ret) {
+		pr_err("requesting SPORT3 peripherals failed\n");
+		goto err_out3;
+	}
+#endif
+	for (i = 0; i < nr_active_ports; i++) {
+		spin_lock_init(&bfin_sport_uart_ports[i].port.lock);
+		bfin_sport_uart_ports[i].port.fifosize  = SPORT_TX_FIFO_SIZE,
+		bfin_sport_uart_ports[i].port.ops       = &sport_uart_ops;
+		bfin_sport_uart_ports[i].port.line      = i;
+		bfin_sport_uart_ports[i].port.iotype    = UPIO_MEM;
+		bfin_sport_uart_ports[i].port.flags     = UPF_BOOT_AUTOCONF;
+		bfin_sport_uart_ports[i].port.membase   =
+			(void __iomem *)bfin_sport_uart_console_base_addr[i];
+	}
+
+	first = 0;
+
+	return 0;
+#ifdef CONFIG_SERIAL_BFIN_SPORT3_UART
+err_out3:
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT2_UART
+	peripheral_free_list(bfin_uart_pin_req_sport2);
+err_out2:
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT1_UART
+	peripheral_free_list(bfin_uart_pin_req_sport1);
+err_out1:
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
+	peripheral_free_list(bfin_uart_pin_req_sport0);
+err_out0:
+#endif
+
+	return ret;
+}
+
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
+static int __init
+sport_uart_console_setup(struct console *co, char *options)
+{
+	struct sport_uart_port *up;
+	int baud = 57600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	/*
+	 * Check whether an invalid uart number has been specified, and
+	 * if so, search for the first available port that does have
+	 * console support.
+	 */
+	if (co->index == -1 || co->index >= nr_active_ports)
+		co->index = 0;
+	up = &bfin_sport_uart_ports[co->index];
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	return uart_set_options(&up->port, co, baud, parity, bits, flow);
+}
+
+static void sport_uart_console_putchar(struct uart_port *port, int ch)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+
+	while (SPORT_GET_STAT(up) & TXF)
+		barrier();
+
+	tx_one_byte(up, ch);
+}
+
+/*
+ * Interrupts are disabled on entering
+ */
+static void
+sport_uart_console_write(struct console *co, const char *s, unsigned int count)
+{
+	struct sport_uart_port *up = &bfin_sport_uart_ports[co->index];
+	unsigned long flags;
+
+	spin_lock_irqsave(&up->port.lock, flags);
+
+	if (SPORT_GET_TCR1(up) & TSPEN)
+		uart_console_write(&up->port, s, count, sport_uart_console_putchar);
+	else {
+		/* dummy data to start sport */
+		while (SPORT_GET_STAT(up) & TXF)
+			barrier();
+		SPORT_PUT_TX(up, 0xffff);
+		/* Enable transmit, then an interrupt will generated */
+		SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) | TSPEN));
+		SSYNC();
+
+		uart_console_write(&up->port, s, count, sport_uart_console_putchar);
+
+		/* Although the hold register is empty, last byte is still in shift
+		 * register and not sent out yet. So, put a dummy data into TX FIFO.
+		 * Then, sport tx stops when last byte is shift out and the dummy
+		 * data is moved into the shift register.
+		 */
+		while (SPORT_GET_STAT(up) & TXF)
+			barrier();
+		SPORT_PUT_TX(up, 0xffff);
+		while (!(SPORT_GET_STAT(up) & TXHRE))
+			barrier();
+
+		/* Stop sport tx transfer */
+		SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) & ~TSPEN));
+		SSYNC();
 	}
+
+	spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
+static struct uart_driver sport_uart_reg;
+
+static struct console sport_uart_console = {
+	.name		= DEVICE_NAME,
+	.write		= sport_uart_console_write,
+	.device		= uart_console_device,
+	.setup		= sport_uart_console_setup,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+	.data		= &sport_uart_reg,
 };
 
+static int __init sport_uart_rs_console_init(void)
+{
+	int ret = sport_uart_init_ports();
+	if (ret)
+		return ret;
+
+	register_console(&sport_uart_console);
+
+	return 0;
+}
+console_initcall(sport_uart_rs_console_init);
+
+#define SPORT_UART_CONSOLE	(&sport_uart_console)
+#else
+#define SPORT_UART_CONSOLE	NULL
+#endif /* CONFIG_SERIAL_BFIN_CONSOLE */
+
+
 static struct uart_driver sport_uart_reg = {
 	.owner		= THIS_MODULE,
-	.driver_name	= "SPORT-UART",
-	.dev_name	= "ttySS",
+	.driver_name	= DRV_NAME,
+	.dev_name	= DEVICE_NAME,
 	.major		= 204,
 	.minor		= 84,
-	.nr		= ARRAY_SIZE(sport_uart_ports),
-	.cons		= NULL,
+	.nr		= BFIN_SPORT_UART_MAX_PORTS,
+	.cons		= SPORT_UART_CONSOLE,
 };
 
-static int sport_uart_suspend(struct platform_device *dev, pm_message_t state)
+#ifdef CONFIG_PM
+static int sport_uart_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct sport_uart_port *sport = platform_get_drvdata(dev);
+	struct sport_uart_port *sport = platform_get_drvdata(pdev);
 
-	pr_debug("%s enter\n", __func__);
+	dev_dbg(&pdev->dev, "%s enter\n", __func__);
 	if (sport)
 		uart_suspend_port(&sport_uart_reg, &sport->port);
 
 	return 0;
 }
 
-static int sport_uart_resume(struct platform_device *dev)
+static int sport_uart_resume(struct platform_device *pdev)
 {
-	struct sport_uart_port *sport = platform_get_drvdata(dev);
+	struct sport_uart_port *sport = platform_get_drvdata(pdev);
 
-	pr_debug("%s enter\n", __func__);
+	dev_dbg(&pdev->dev, "%s enter\n", __func__);
 	if (sport)
 		uart_resume_port(&sport_uart_reg, &sport->port);
 
 	return 0;
 }
+#else
+# define sport_uart_suspend NULL
+# define sport_uart_resume  NULL
+#endif
 
-static int sport_uart_probe(struct platform_device *dev)
+static int __devinit sport_uart_probe(struct platform_device *pdev)
 {
-	pr_debug("%s enter\n", __func__);
-	sport_uart_ports[dev->id].port.dev = &dev->dev;
-	uart_add_one_port(&sport_uart_reg, &sport_uart_ports[dev->id].port);
-	platform_set_drvdata(dev, &sport_uart_ports[dev->id]);
+	struct resource *res;
+	struct sport_uart_port *sport;
+	int ret = 0;
+	static int index;
 
-	return 0;
+	dev_dbg(&pdev->dev, "%s enter\n", __func__);
+
+	sport = &bfin_sport_uart_ports[index];
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
+		return -ENOENT;
+	}
+
+	if (res->start != bfin_sport_uart_console_base_addr[index]) {
+		dev_err(&pdev->dev, "Wrong sport uart platform device\n");
+		return -ENOENT;
+	}
+	index++;
+
+	sport->port.membase = ioremap(res->start, res->end - res->start);
+	if (!sport->port.membase) {
+		dev_err(&pdev->dev, "Cannot map sport IO\n");
+		return -ENXIO;
+	}
+
+	sport->port.irq = platform_get_irq(pdev, 0);
+	if (sport->port.irq < 0) {
+		dev_err(&pdev->dev, "No sport RX/TX IRQ specified\n");
+		ret = -ENOENT;
+		goto out_error;
+	}
+
+	sport->err_irq = platform_get_irq(pdev, 1);
+	if (sport->err_irq < 0) {
+		dev_err(&pdev->dev, "No sport status IRQ specified\n");
+		ret = -ENOENT;
+		goto out_error;
+	}
+
+	sport->port.dev = &pdev->dev;
+	platform_set_drvdata(pdev, sport);
+	ret = uart_add_one_port(&sport_uart_reg, &sport->port);
+	if (!ret)
+		return 0;
+
+out_error:
+	iounmap(sport->port.membase);
+
+	return ret;
 }
 
-static int sport_uart_remove(struct platform_device *dev)
+static int __devexit sport_uart_remove(struct platform_device *pdev)
 {
-	struct sport_uart_port *sport = platform_get_drvdata(dev);
+	struct sport_uart_port *sport = platform_get_drvdata(pdev);
 
-	pr_debug("%s enter\n", __func__);
-	platform_set_drvdata(dev, NULL);
+	dev_dbg(&pdev->dev, "%s enter\n", __func__);
+	platform_set_drvdata(pdev, NULL);
 
 	if (sport)
 		uart_remove_one_port(&sport_uart_reg, &sport->port);
 
+	iounmap(sport->port.membase);
+
 	return 0;
 }
 
@@ -575,7 +850,7 @@ static struct platform_driver sport_uart_driver = {
 	.probe		= sport_uart_probe,
 	.remove		= sport_uart_remove,
 	.suspend	= sport_uart_suspend,
-	.resume		= sport_uart_resume,
+	.resume		= __devexit_p(sport_uart_resume),
 	.driver		= {
 		.name	= DRV_NAME,
 	},
@@ -585,33 +860,49 @@ static int __init sport_uart_init(void)
 {
 	int ret;
 
-	pr_debug("%s enter\n", __func__);
+	pr_info("Serial: Blackfin uart over sport driver\n");
+
+	ret = sport_uart_init_ports();
+	if (ret)
+		return ret;
+
 	ret = uart_register_driver(&sport_uart_reg);
-	if (ret != 0) {
-		printk(KERN_ERR "Failed to register %s:%d\n",
+	if (ret) {
+		pr_err("failed to register %s:%d\n",
 				sport_uart_reg.driver_name, ret);
 		return ret;
 	}
 
 	ret = platform_driver_register(&sport_uart_driver);
-	if (ret != 0) {
-		printk(KERN_ERR "Failed to register sport uart driver:%d\n", ret);
+	if (ret) {
+		pr_err("failed to register sport uart driver:%d\n", ret);
 		uart_unregister_driver(&sport_uart_reg);
 	}
 
-
-	pr_debug("%s exit\n", __func__);
 	return ret;
 }
+module_init(sport_uart_init);
 
 static void __exit sport_uart_exit(void)
 {
-	pr_debug("%s enter\n", __func__);
 	platform_driver_unregister(&sport_uart_driver);
 	uart_unregister_driver(&sport_uart_reg);
-}
 
-module_init(sport_uart_init);
+#ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
+	peripheral_free_list(bfin_uart_pin_req_sport0);
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT1_UART
+	peripheral_free_list(bfin_uart_pin_req_sport1);
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT2_UART
+	peripheral_free_list(bfin_uart_pin_req_sport2);
+#endif
+#ifdef CONFIG_SERIAL_BFIN_SPORT3_UART
+	peripheral_free_list(bfin_uart_pin_req_sport3);
+#endif
+}
 module_exit(sport_uart_exit);
 
+MODULE_AUTHOR("Sonic Zhang, Roy Huang");
+MODULE_DESCRIPTION("Blackfin serial over SPORT driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index 671d41c..21a0617 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
@@ -1,29 +1,20 @@
 /*
- * File:	linux/drivers/serial/bfin_sport_uart.h
+ * Blackfin On-Chip Sport Emulated UART Driver
  *
- * Based on:	include/asm-blackfin/mach-533/bfin_serial_5xx.h
- * Author:	Roy Huang <roy.huang>analog.com>
+ * Copyright 2006-2008 Analog Devices Inc.
  *
- * Created:	Nov 22, 2006
- * Copyright:	(C) Analog Device Inc.
- * Description: this driver enable SPORTs on Blackfin emulate UART.
+ * Enter bugs at http://blackfin.uclinux.org/
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ * Licensed under the GPL-2 or later.
  */
 
+/*
+ * This driver and the hardware supported are in term of EE-191 of ADI.
+ * http://www.analog.com/UploadedFiles/Application_Notes/399447663EE191.pdf
+ * This application note describe how to implement a UART on a Sharc DSP,
+ * but this driver is implemented on Blackfin Processor.
+ * Transmit Frame Sync is not used by this driver to transfer data out.
+ */
 
 #define OFFSET_TCR1		0x00	/* Transmit Configuration 1 Register */
 #define OFFSET_TCR2		0x04	/* Transmit Configuration 2 Register */
@@ -43,7 +34,20 @@
 #define SPORT_GET_TFSDIV(sport)		bfin_read16(((sport)->port.membase + OFFSET_TFSDIV))
 #define SPORT_GET_TX(sport)		bfin_read16(((sport)->port.membase + OFFSET_TX))
 #define SPORT_GET_RX(sport)		bfin_read16(((sport)->port.membase + OFFSET_RX))
-#define SPORT_GET_RX32(sport)		bfin_read32(((sport)->port.membase + OFFSET_RX))
+/*
+ * Disable local interrupt to walk around the fake RX underflow error
+ * when do 32-bit reading from RX fifois interrupted by other interrupt.
+ * This is a possible hardware anomaly. After it is logged officially,
+ * the official anomaly id should be listed bellow.
+ */
+#define SPORT_GET_RX32(sport)	\
+({				\
+	unsigned int __ret;		\
+	local_irq_disable();	\
+	__ret = bfin_read32(((sport)->port.membase + OFFSET_RX));	\
+	local_irq_enable();	\
+	__ret;			\
+})
 #define SPORT_GET_RCR1(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR1))
 #define SPORT_GET_RCR2(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR2))
 #define SPORT_GET_RCLKDIV(sport)	bfin_read16(((sport)->port.membase + OFFSET_RCLKDIV))
@@ -61,3 +65,6 @@
 #define SPORT_PUT_RCLKDIV(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_RCLKDIV), v)
 #define SPORT_PUT_RFSDIV(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_RFSDIV), v)
 #define SPORT_PUT_STAT(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_STAT), v)
+
+#define SPORT_TX_FIFO_SIZE	8
+
-- 
1.6.0



