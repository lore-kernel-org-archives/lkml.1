Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbYKFU6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbYKFU6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKFU5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:57:52 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:40234 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYKFU5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:57:50 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 25/29] Serial: Allow port type to be specified when calling serial8250_register_port.
Date: Thu,  6 Nov 2008 12:57:03 -0800
Message-Id: <1226005025-27804-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <491358F5.7040002@caviumnetworks.com>
References: <491358F5.7040002@caviumnetworks.com>
X-OriginalArrivalTime: 06 Nov 2008 20:57:12.0397 (UTC) FILETIME=[3DBB97D0:01C94052]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add flag value UPF_FIXED_TYPE which specifies that the UART type is
known and should not be probed.  For this case the UARTs properties
are just copied out of the uart_config entry.

This allows us to keep SOC specific 8250 probe code out of 8250.c.  In
this case we know the serial hardware will not be changing as it is on
the same silicon as the CPU, and we can specify it with certainty in
the board/cpu setup code.

The alternative is to load up 8250.c with a bunch of OCTEON specific
special cases in the probing code.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/serial/8250.c        |    8 ++++++++
 drivers/serial/serial_core.c |    7 +++++--
 include/linux/serial_core.h  |    2 ++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 410478f..9d16abb 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -3056,6 +3056,14 @@ int serial8250_register_port(struct uart_port *port)
 		uart->port.private_data = port->private_data;
 		if (port->dev)
 			uart->port.dev = port->dev;
+
+		if (port->flags & UPF_FIXED_TYPE) {
+			uart->port.type = port->type;
+			uart->port.fifosize = uart_config[port->type].fifo_size;
+			uart->capabilities = uart_config[port->type].flags;
+			uart->tx_loadsz = uart_config[port->type].tx_loadsz;
+		}
+
 		set_io_fns_from_upio(&uart->port);
 		/* Possibly override default I/O functions.  */
 		if (port->serial_in_fn)
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 874786a..7fef45e 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2198,11 +2198,14 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 	 * Now do the auto configuration stuff.  Note that config_port
 	 * is expected to claim the resources and map the port for us.
 	 */
-	flags = UART_CONFIG_TYPE;
+	flags = 0;
 	if (port->flags & UPF_AUTO_IRQ)
 		flags |= UART_CONFIG_IRQ;
 	if (port->flags & UPF_BOOT_AUTOCONF) {
-		port->type = PORT_UNKNOWN;
+		if (!(port->flags & UPF_FIXED_TYPE)) {
+			port->type = PORT_UNKNOWN;
+			flags |= UART_CONFIG_TYPE;
+		}
 		port->ops->config_port(port, flags);
 	}
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 40509b0..54e0dce 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -290,6 +290,8 @@ struct uart_port {
 #define UPF_MAGIC_MULTIPLIER	((__force upf_t) (1 << 16))
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
+/* The exact UART type is known and should not be probed.  */
+#define UPF_FIXED_TYPE		((__force upf_t) (1 << 27))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))
 #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
 #define UPF_DEAD		((__force upf_t) (1 << 30))
-- 
1.5.6.5

