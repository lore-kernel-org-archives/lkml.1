Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYKFU6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYKFU6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYKFU5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:57:54 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:40241 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYKFU5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:57:51 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org, David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Subject: [PATCH 27/29] Serial: UART driver changes for Cavium OCTEON.
Date: Thu,  6 Nov 2008 12:57:05 -0800
Message-Id: <1226005025-27804-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <491358F5.7040002@caviumnetworks.com>
References: <491358F5.7040002@caviumnetworks.com>
X-OriginalArrivalTime: 06 Nov 2008 20:57:14.0881 (UTC) FILETIME=[3F369F10:01C94052]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cavium UART implementation won't work with the standard 8250 driver
as-is.  Define a new uart_config (PORT_OCTEON) and use it to enable
special handling required by the OCTEON's serial port.  Two new bug
types are defined.

Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/serial/8250.c       |   16 +++++++++++++++-
 drivers/serial/8250.h       |    2 ++
 include/linux/serial_core.h |    3 ++-
 include/linux/serial_reg.h  |    6 ++++++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 474ab89..f274e94 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -279,6 +279,14 @@ static const struct serial8250_config uart_config[] = {
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
@@ -1554,6 +1562,12 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
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
 
@@ -1714,7 +1728,7 @@ static void serial8250_timeout(unsigned long data)
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
index 54e0dce..c6c7faa 100644
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
 
-- 
1.5.6.5

