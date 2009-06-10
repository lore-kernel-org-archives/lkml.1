Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbZFJMKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbZFJMKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZFJMIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:08:42 -0400
Received: from mx1.emlix.com ([193.175.82.87]:53964 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbZFJMIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:08:37 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Oskar Schirmer <os@emlix.com>
Subject: [PATCH 7/9 -v2] imx: serial: use rational library function
Date: Wed, 10 Jun 2009 14:08:34 +0200
Message-Id: <1244635716-23315-8-git-send-email-os@emlix.com>
In-Reply-To: <1244635716-23315-1-git-send-email-os@emlix.com>
References: <1244635716-23315-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for calculation of numerator and denominator
used in baud rate setting, use generic library function
for optimum settings.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/serial/Kconfig |    1 +
 drivers/serial/imx.c   |   30 ++++++++++--------------------
 2 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 343e3a3..0ecb4c4 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -833,6 +833,7 @@ config SERIAL_IMX
 	bool "IMX serial port support"
 	depends on ARM && (ARCH_IMX || ARCH_MXC)
 	select SERIAL_CORE
+	select RATIONAL
 	help
 	  If you have a machine based on a Motorola IMX CPU you
 	  can enable its onboard serial port by enabling this option.
diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 60892a2..11f93e2 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -41,6 +41,7 @@
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/clk.h>
+#include <linux/rational.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -670,7 +671,8 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	unsigned long flags;
 	unsigned int ucr2, old_ucr1, old_txrxen, baud, quot;
 	unsigned int old_csize = old ? old->c_cflag & CSIZE : CS8;
-	unsigned int div, num, denom, ufcr;
+	unsigned int div, ufcr;
+	unsigned long num, denom;
 
 	/*
 	 * If we don't support modem control lines, don't allow
@@ -772,32 +774,20 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (!div)
 		div = 1;
 
-	num = baud;
-	denom = port->uartclk / div / 16;
+	rational_best_approximation(16 * div * baud, sport->port.uartclk,
+		1 << 16, 1 << 16, &num, &denom);
 
-	/* shift num and denom right until they fit into 16 bits */
-	while (num > 0x10000 || denom > 0x10000) {
-		num >>= 1;
-		denom >>= 1;
-	}
-	if (num > 0)
-		num -= 1;
-	if (denom > 0)
-		denom -= 1;
-
-	writel(num, sport->port.membase + UBIR);
-	writel(denom, sport->port.membase + UBMR);
-
-	if (div == 7)
-		div = 6; /* 6 in RFDIV means divide by 7 */
-	else
-		div = 6 - div;
+	num -= 1;
+	denom -= 1;
 
 	ufcr = readl(sport->port.membase + UFCR);
 	ufcr = (ufcr & (~UFCR_RFDIV)) |
 	    (div << 7);
 	writel(ufcr, sport->port.membase + UFCR);
 
+	writel(num, sport->port.membase + UBIR);
+	writel(denom, sport->port.membase + UBMR);
+
 #ifdef ONEMS
 	writel(sport->port.uartclk / div / 1000, sport->port.membase + ONEMS);
 #endif
-- 
1.5.3.7

