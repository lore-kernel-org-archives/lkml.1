Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYJGX7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYJGX7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbYJGX7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:59:43 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:36310 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYJGX7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:59:42 -0400
Message-ID: <48EBF7E7.1000300@caviumnetworks.com>
Date: Tue, 07 Oct 2008 16:59:35 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
CC: "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: [PATCH 4/4] serial: Add new uart_config for PORT_OCTEON
References: <48EBF426.9080500@caviumnetworks.com>
In-Reply-To: <48EBF426.9080500@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2008 23:59:35.0377 (UTC) FILETIME=[BFDD5410:01C928D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cavium UART implementation won't work with the standard 8250 driver
as-is.  Define a new uart_config (PORT_OCTEON) and use it to enable
special handling required by the OCTEON's serial port.

Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Signed-off-by: Paul Gortmaker <Paul.Gortmaker@windriver.com>
Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/serial/8250.c       |   16 +++++++++++++++-
 drivers/serial/8250.h       |    2 ++
 include/linux/serial_core.h |    3 ++-
 include/linux/serial_reg.h  |    6 ++++++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 19a8373..7afd07f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -264,6 +264,14 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO,
 	},
+	[PORT_OCTEON] = {
+		.name		= "OCTEON",
+		.fifo_size	= 64,
+		.tx_loadsz	= 64,
+		.bugs		= UART_BUG_TIMEOUT | UART_BUG_OCTEON_IIR,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 #if defined (CONFIG_SERIAL_8250_AU1X00)
@@ -1540,6 +1548,12 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 		up = list_entry(l, struct uart_8250_port, list);
 
 		iir = serial_in(up, UART_IIR);
+		if ((up->bugs & UART_BUG_OCTEON_IIR) && (iir & 0xf) == 7) {
+			/* Busy interrupt */
+			serial_in(up, UART_OCTEON_USR);
+			iir = serial_in(up, UART_IIR);
+		}
+
 		if (!(iir & UART_IIR_NO_INT)) {
 			serial8250_handle_port(up);
 
@@ -1658,7 +1672,7 @@ static void serial8250_timeout(unsigned long data)
 	unsigned int iir;
 
 	iir = serial_in(up, UART_IIR);
-	if (!(iir & UART_IIR_NO_INT))
+	if (!(iir & UART_IIR_NO_INT) || (up->bugs & UART_BUG_TIMEOUT))
 		serial8250_handle_port(up);
 	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
 }
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index c9b3002..56b3cb7 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -49,6 +49,8 @@ struct serial8250_config {
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
 #define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */
+#define UART_BUG_TIMEOUT (1 << 4)	/* UART should always handle timeout */
+#define UART_BUG_OCTEON_IIR (1 << 5)	/* UART OCTEON IIR workaround */
 
 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index c68dc94..c920c43 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -40,7 +40,8 @@
 #define PORT_NS16550A	14
 #define PORT_XSCALE	15
 #define PORT_RM9000	16	/* PMC-Sierra RM9xxx internal UART */
-#define PORT_MAX_8250	16	/* max port ID */
+#define PORT_OCTEON	17	/* Cavium OCTEON internal UART */
+#define PORT_MAX_8250	17	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index 96c0d93..a96bd50 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -324,5 +324,11 @@
 #define UART_OMAP_SYSC		0x15	/* System configuration register */
 #define UART_OMAP_SYSS		0x16	/* System status register */
 
+/*
+ * Extra serial register definitions for the internal UARTs in Cavium
+ * Networks OCTEON processors.
+ */
+#define UART_OCTEON_USR		0x27	/* UART Status Register */
+
 #endif /* _LINUX_SERIAL_REG_H */
 
