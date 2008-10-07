Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYJGAjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYJGAjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYJGAjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:39:00 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6270 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYJGAi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:38:59 -0400
Message-ID: <48EAAF97.8050307@caviumnetworks.com>
Date: Mon, 06 Oct 2008 17:38:47 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
CC: "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: [PATCH] serial: Add Cavium OCTEON UART definitions.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2008 00:38:48.0005 (UTC) FILETIME=[0FBA1F50:01C92815]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cavium: 8250 serial driver changes

As mentioned in '[PATCH 1/2] serial: Allow for replaceable I/O
functions in 8250 driver.', we are in the process of preparing kernel
support for the Cavium Networks OCTEON processor for inclusion in the
main-line kernel sources.

The OCTEON's UART differs from the existing uart_configs, so we add a
new uart_config and check for it in several places.

This patch depends on the aforementioned 'Allow for replaceable I/O
functions in 8250 driver' patch.

Since this patch is part of the Cavium OCTEON processor port, we don't
expect that it would be committed until the rest of the port is
accepted.  However we would like feedback so that it might be
adjusted if necessary.

Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/serial/8250.c       |   30 +++++++++++++++++++++++++++---
 include/linux/serial_core.h |    3 ++-
 include/linux/serial_reg.h  |    6 ++++++
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 02771d6..2ef79e9 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -264,6 +264,13 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO,
 	},
+	[PORT_OCTEON] = {
+		.name		= "OCTEON",
+		.fifo_size	= 64,
+		.tx_loadsz	= 64,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 #if defined (CONFIG_SERIAL_8250_AU1X00)
@@ -902,7 +909,14 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	unsigned char status1, status2;
 	unsigned int iersave;
 
-	up->port.type = PORT_16550A;
+#ifdef CONFIG_CPU_CAVIUM_OCTEON
+	/* UPF_FIXED_PORT indicates an internal UART.  */
+	if (up->port.flags & UPF_FIXED_PORT)
+		up->port.type = PORT_OCTEON;
+	else
+#endif
+		up->port.type = PORT_16550A;
+
 	up->capabilities |= UART_CAP_FIFO;
 
 	/*
@@ -948,7 +962,8 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 
 	if (!((status2 ^ status1) & UART_MCR_LOOP)) {
 		serial_outp(up, UART_LCR, 0);
-		serial_outp(up, UART_MCR, status1 ^ UART_MCR_LOOP);
+		if (up->port.type != PORT_OCTEON)
+			serial_outp(up, UART_MCR, status1 ^ UART_MCR_LOOP);
 		serial_outp(up, UART_LCR, 0xE0);
 		status2 = serial_in(up, 0x02); /* EXCR1 */
 		serial_outp(up, UART_LCR, 0);
@@ -1002,6 +1017,9 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 		return;
 	}
 
+	if (up->port.type == PORT_OCTEON)
+		return;
+
 	/*
 	 * Try writing and reading the UART_IER_UUE bit (b6).
 	 * If it works, this is probably one of the Xscale platform's
@@ -1539,6 +1557,12 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 		up = list_entry(l, struct uart_8250_port, list);
 
 		iir = serial_in(up, UART_IIR);
+		if (up->port.type == PORT_OCTEON && (iir & 0xf) == 7) {
+			/* Busy interrupt */
+			serial_in(up, UART_OCTEON_USR);
+			iir = serial_in(up, UART_IIR);
+		}
+
 		if (!(iir & UART_IIR_NO_INT)) {
 			serial8250_handle_port(up);
 
@@ -1657,7 +1681,7 @@ static void serial8250_timeout(unsigned long data)
 	unsigned int iir;
 
 	iir = serial_in(up, UART_IIR);
-	if (!(iir & UART_IIR_NO_INT))
+	if (!(iir & UART_IIR_NO_INT) || up->port.type == PORT_OCTEON)
 		serial8250_handle_port(up);
 	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
 }
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 3a4afcf..6f49385 100644
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
 
