Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbZFJMK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbZFJMK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbZFJMIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:08:44 -0400
Received: from mx1.emlix.com ([193.175.82.87]:50434 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZFJMIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:08:37 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Oskar Schirmer <os@emlix.com>,
       Fabian Godehardt <fg@emlix.com>
Subject: [PATCH 8/9 -v2] imx: serial: add IrDA support to serial driver
Date: Wed, 10 Jun 2009 14:08:35 +0200
Message-Id: <1244635716-23315-9-git-send-email-os@emlix.com>
In-Reply-To: <1244635716-23315-1-git-send-email-os@emlix.com>
References: <1244635716-23315-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Godehardt <fg@emlix.com>

Using the iMX serial driver with an IrDA device
needs extra peripheral settings and specific
timing depending on the transmitter circuitry used.

Signed-off-by: Fabian Godehardt <fg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/arm/plat-mxc/include/mach/imx-uart.h |    5 +
 drivers/serial/imx.c                      |  195 ++++++++++++++++++++++++++---
 2 files changed, 181 insertions(+), 19 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/imx-uart.h b/arch/arm/plat-mxc/include/mach/imx-uart.h
index 599217b..f9bd17d 100644
--- a/arch/arm/plat-mxc/include/mach/imx-uart.h
+++ b/arch/arm/plat-mxc/include/mach/imx-uart.h
@@ -20,11 +20,16 @@
 #define ASMARM_ARCH_UART_H
 
 #define IMXUART_HAVE_RTSCTS (1<<0)
+#define IMXUART_IRDA        (1<<1)
 
 struct imxuart_platform_data {
 	int (*init)(struct platform_device *pdev);
 	int (*exit)(struct platform_device *pdev);
 	unsigned int flags;
+	void (*irda_enable)(int enable);
+	unsigned int irda_inv_rx:1;
+	unsigned int irda_inv_tx:1;
+	unsigned short transceiver_delay;
 };
 
 #endif
diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 11f93e2..1c00e2a 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -8,6 +8,9 @@
  *  Author: Sascha Hauer <sascha@saschahauer.de>
  *  Copyright (C) 2004 Pengutronix
  *
+ *  Copyright (C) 2009 emlix GmbH
+ *  Author: Fabian Godehardt (added IrDA support for iMX)
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -41,6 +44,7 @@
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/rational.h>
 
 #include <asm/io.h>
@@ -149,6 +153,7 @@
 #define  UCR4_DREN  	 (1<<0)  /* Recv data ready interrupt enable */
 #define  UFCR_RXTL_SHF   0       /* Receiver trigger level shift */
 #define  UFCR_RFDIV      (7<<7)  /* Reference freq divider mask */
+#define  UFCR_RFDIV_REG(x)	(((x) < 7 ? 6 - (x) : 6) << 7)
 #define  UFCR_TXTL_SHF   10      /* Transmitter trigger level shift */
 #define  USR1_PARITYERR  (1<<15) /* Parity error interrupt flag */
 #define  USR1_RTSS  	 (1<<14) /* RTS pin status */
@@ -213,9 +218,19 @@ struct imx_port {
 	unsigned int		old_status;
 	int			txirq,rxirq,rtsirq;
 	unsigned int		have_rtscts:1;
+	unsigned int		use_irda:1;
+	unsigned int		irda_inv_rx:1;
+	unsigned int		irda_inv_tx:1;
+	unsigned short		trcv_delay; /* transceiver delay */
 	struct clk		*clk;
 };
 
+#ifdef CONFIG_IRDA
+#define USE_IRDA(sport)	((sport)->use_irda)
+#else
+#define USE_IRDA(sport)	(0)
+#endif
+
 /*
  * Handle any change of modem status signal since we were last called.
  */
@@ -269,6 +284,48 @@ static void imx_stop_tx(struct uart_port *port)
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
+	if (USE_IRDA(sport)) {
+		/* half duplex - wait for end of transmission */
+		int n = 256;
+		while ((--n > 0) &&
+		      !(readl(sport->port.membase + USR2) & USR2_TXDC)) {
+			udelay(5);
+			barrier();
+		}
+		/*
+		 * irda transceiver - wait a bit more to avoid
+		 * cutoff, hardware dependent
+		 */
+		udelay(sport->trcv_delay);
+
+		/*
+		 * half duplex - reactivate receive mode,
+		 * flush receive pipe echo crap
+		 */
+		if (readl(sport->port.membase + USR2) & USR2_TXDC) {
+			temp = readl(sport->port.membase + UCR1);
+			temp &= ~(UCR1_TXMPTYEN | UCR1_TRDYEN);
+			writel(temp, sport->port.membase + UCR1);
+
+			temp = readl(sport->port.membase + UCR4);
+			temp &= ~(UCR4_TCEN);
+			writel(temp, sport->port.membase + UCR4);
+
+			while (readl(sport->port.membase + URXD0) &
+			       URXD_CHARRDY)
+				barrier();
+
+			temp = readl(sport->port.membase + UCR1);
+			temp |= UCR1_RRDYEN;
+			writel(temp, sport->port.membase + UCR1);
+
+			temp = readl(sport->port.membase + UCR4);
+			temp |= UCR4_DREN;
+			writel(temp, sport->port.membase + UCR4);
+		}
+		return;
+	}
+
 	temp = readl(sport->port.membase + UCR1);
 	writel(temp & ~UCR1_TXMPTYEN, sport->port.membase + UCR1);
 }
@@ -324,9 +381,30 @@ static void imx_start_tx(struct uart_port *port)
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
+	if (USE_IRDA(sport)) {
+		/* half duplex in IrDA mode; have to disable receive mode */
+		temp = readl(sport->port.membase + UCR4);
+		temp &= ~(UCR4_DREN);
+		writel(temp, sport->port.membase + UCR4);
+
+		temp = readl(sport->port.membase + UCR1);
+		temp &= ~(UCR1_RRDYEN);
+		writel(temp, sport->port.membase + UCR1);
+	}
+
 	temp = readl(sport->port.membase + UCR1);
 	writel(temp | UCR1_TXMPTYEN, sport->port.membase + UCR1);
 
+	if (USE_IRDA(sport)) {
+		temp = readl(sport->port.membase + UCR1);
+		temp |= UCR1_TRDYEN;
+		writel(temp, sport->port.membase + UCR1);
+
+		temp = readl(sport->port.membase + UCR4);
+		temp |= UCR4_TCEN;
+		writel(temp, sport->port.membase + UCR4);
+	}
+
 	if (readl(sport->port.membase + UTS) & UTS_TXEMPTY)
 		imx_transmit_buffer(sport);
 }
@@ -536,12 +614,7 @@ static int imx_setup_ufcr(struct imx_port *sport, unsigned int mode)
 	if(!ufcr_rfdiv)
 		ufcr_rfdiv = 1;
 
-	if(ufcr_rfdiv >= 7)
-		ufcr_rfdiv = 6;
-	else
-		ufcr_rfdiv = 6 - ufcr_rfdiv;
-
-	val |= UFCR_RFDIV & (ufcr_rfdiv << 7);
+	val |= UFCR_RFDIV_REG(ufcr_rfdiv);
 
 	writel(val, sport->port.membase + UFCR);
 
@@ -560,8 +633,24 @@ static int imx_startup(struct uart_port *port)
 	 * requesting IRQs
 	 */
 	temp = readl(sport->port.membase + UCR4);
+
+	if (USE_IRDA(sport))
+		temp |= UCR4_IRSC;
+
 	writel(temp & ~UCR4_DREN, sport->port.membase + UCR4);
 
+	if (USE_IRDA(sport)) {
+		/* reset fifo's and state machines */
+		int i = 100;
+		temp = readl(sport->port.membase + UCR2);
+		temp &= ~UCR2_SRST;
+		writel(temp, sport->port.membase + UCR2);
+		while (!(readl(sport->port.membase + UCR2) & UCR2_SRST) &&
+		    (--i > 0)) {
+			udelay(1);
+		}
+	}
+
 	/*
 	 * Allocate the IRQ(s) i.MX1 has three interrupts whereas later
 	 * chips only have one interrupt.
@@ -577,12 +666,16 @@ static int imx_startup(struct uart_port *port)
 		if (retval)
 			goto error_out2;
 
-		retval = request_irq(sport->rtsirq, imx_rtsint,
-			     (sport->rtsirq < MAX_INTERNAL_IRQ) ? 0 :
-			       IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
-				DRIVER_NAME, sport);
-		if (retval)
-			goto error_out3;
+		/* do not use RTS IRQ on IrDA */
+		if (!USE_IRDA(sport)) {
+			retval = request_irq(sport->rtsirq, imx_rtsint,
+				     (sport->rtsirq < MAX_INTERNAL_IRQ) ? 0 :
+				       IRQF_TRIGGER_FALLING |
+				       IRQF_TRIGGER_RISING,
+					DRIVER_NAME, sport);
+			if (retval)
+				goto error_out3;
+		}
 	} else {
 		retval = request_irq(sport->port.irq, imx_int, 0,
 				DRIVER_NAME, sport);
@@ -599,18 +692,49 @@ static int imx_startup(struct uart_port *port)
 
 	temp = readl(sport->port.membase + UCR1);
 	temp |= UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN;
+
+	if (USE_IRDA(sport)) {
+		temp |= UCR1_IREN;
+		temp &= ~(UCR1_RTSDEN);
+	}
+
 	writel(temp, sport->port.membase + UCR1);
 
 	temp = readl(sport->port.membase + UCR2);
 	temp |= (UCR2_RXEN | UCR2_TXEN);
 	writel(temp, sport->port.membase + UCR2);
 
+	if (USE_IRDA(sport)) {
+		/* clear RX-FIFO */
+		int i = 64;
+		while ((--i > 0) &&
+			(readl(sport->port.membase + URXD0) & URXD_CHARRDY)) {
+			barrier();
+		}
+	}
+
 #if defined CONFIG_ARCH_MX2 || defined CONFIG_ARCH_MX3
 	temp = readl(sport->port.membase + UCR3);
 	temp |= UCR3_RXDMUXSEL;
 	writel(temp, sport->port.membase + UCR3);
 #endif
 
+	if (USE_IRDA(sport)) {
+		temp = readl(sport->port.membase + UCR4);
+		if (sport->irda_inv_rx)
+			temp |= UCR4_INVR;
+		else
+			temp &= ~(UCR4_INVR);
+		writel(temp | UCR4_DREN, sport->port.membase + UCR4);
+
+		temp = readl(sport->port.membase + UCR3);
+		if (sport->irda_inv_tx)
+			temp |= UCR3_INVT;
+		else
+			temp &= ~(UCR3_INVT);
+		writel(temp, sport->port.membase + UCR3);
+	}
+
 	/*
 	 * Enable modem status interrupts
 	 */
@@ -618,6 +742,16 @@ static int imx_startup(struct uart_port *port)
 	imx_enable_ms(&sport->port);
 	spin_unlock_irqrestore(&sport->port.lock,flags);
 
+	if (USE_IRDA(sport)) {
+		struct imxuart_platform_data *pdata;
+		pdata = sport->port.dev->platform_data;
+		sport->irda_inv_rx = pdata->irda_inv_rx;
+		sport->irda_inv_tx = pdata->irda_inv_tx;
+		sport->trcv_delay = pdata->transceiver_delay;
+		if (pdata->irda_enable)
+			pdata->irda_enable(1);
+	}
+
 	return 0;
 
 error_out3:
@@ -639,6 +773,13 @@ static void imx_shutdown(struct uart_port *port)
 	temp &= ~(UCR2_TXEN);
 	writel(temp, sport->port.membase + UCR2);
 
+	if (USE_IRDA(sport)) {
+		struct imxuart_platform_data *pdata;
+		pdata = sport->port.dev->platform_data;
+		if (pdata->irda_enable)
+			pdata->irda_enable(0);
+	}
+
 	/*
 	 * Stop our timer.
 	 */
@@ -648,7 +789,8 @@ static void imx_shutdown(struct uart_port *port)
 	 * Free the interrupts
 	 */
 	if (sport->txirq > 0) {
-		free_irq(sport->rtsirq, sport);
+		if (!USE_IRDA(sport))
+			free_irq(sport->rtsirq, sport);
 		free_irq(sport->txirq, sport);
 		free_irq(sport->rxirq, sport);
 	} else
@@ -660,6 +802,9 @@ static void imx_shutdown(struct uart_port *port)
 
 	temp = readl(sport->port.membase + UCR1);
 	temp &= ~(UCR1_TXMPTYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN);
+	if (USE_IRDA(sport))
+		temp &= ~(UCR1_IREN);
+
 	writel(temp, sport->port.membase + UCR1);
 }
 
@@ -768,11 +913,19 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 			sport->port.membase + UCR2);
 	old_txrxen &= (UCR2_TXEN | UCR2_RXEN);
 
-	div = sport->port.uartclk / (baud * 16);
-	if (div > 7)
-		div = 7;
-	if (!div)
+	if (USE_IRDA(sport)) {
+		/*
+		 * use maximum available submodule frequency to
+		 * avoid missing short pulses due to low sampling rate
+		 */
 		div = 1;
+	} else {
+		div = sport->port.uartclk / (baud * 16);
+		if (div > 7)
+			div = 7;
+		if (!div)
+			div = 1;
+	}
 
 	rational_best_approximation(16 * div * baud, sport->port.uartclk,
 		1 << 16, 1 << 16, &num, &denom);
@@ -781,8 +934,7 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	denom -= 1;
 
 	ufcr = readl(sport->port.membase + UFCR);
-	ufcr = (ufcr & (~UFCR_RFDIV)) |
-	    (div << 7);
+	ufcr = (ufcr & (~UFCR_RFDIV)) | UFCR_RFDIV_REG(div);
 	writel(ufcr, sport->port.membase + UFCR);
 
 	writel(num, sport->port.membase + UBIR);
@@ -1139,6 +1291,11 @@ static int serial_imx_probe(struct platform_device *pdev)
 	if (pdata && (pdata->flags & IMXUART_HAVE_RTSCTS))
 		sport->have_rtscts = 1;
 
+#ifdef CONFIG_IRDA
+	if (pdata && (pdata->flags & IMXUART_IRDA))
+		sport->use_irda = 1;
+#endif
+
 	if (pdata->init) {
 		ret = pdata->init(pdev);
 		if (ret)
-- 
1.5.3.7

