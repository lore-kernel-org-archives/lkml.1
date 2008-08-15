Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYHOIYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYHOIYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYHOIXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:23:44 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:49048 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYHOIXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:23:42 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="73535908"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] Blackfin Serial Driver: Add a debug function to serial driver.
Date: Fri, 15 Aug 2008 16:23:37 +0800
Message-Id: <1218788617-8302-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1218788617-8302-1-git-send-email-cooloney@kernel.org>
References: <1218788617-8302-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   53 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index a5ff54e..1917904 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -21,6 +21,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
+#include <stdarg.h>
 
 #ifdef CONFIG_KGDB_UART
 #include <linux/kgdb.h>
@@ -1101,7 +1102,8 @@ static __init void early_serial_putc(struct uart_port *port, int ch)
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 
 	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
-		cpu_relax();
+		barrier();
+
 	UART_PUT_CHAR(uart, ch);
 }
 
@@ -1150,6 +1152,55 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
 
 #endif /* CONFIG_SERIAL_BFIN_CONSOLE */
 
+#ifdef CONFIG_DEBUG_KERNEL
+void bfin_serial_debug(const char *fmt, ...)
+{
+	struct bfin_serial_port *uart = &bfin_serial_ports[0];
+	unsigned short status, tmp;
+	int flags, i, count;
+	char buf[128];
+	va_list ap;
+
+	if (bfin_serial_console.index < 0)
+		return;		/* Too early. */
+
+	va_start(ap, fmt);
+	vsprintf(buf, fmt, ap);
+	va_end(ap);
+	count = strlen(buf);
+
+	spin_lock_irqsave(&uart->port.lock, flags);
+
+	for (i = 0; i < count; i++) {
+		do {
+			status = UART_GET_LSR(uart);
+		} while (!(status & THRE));
+
+#ifndef CONFIG_BF54x
+		tmp = UART_GET_LCR(uart);
+		tmp &= ~DLAB;
+		UART_PUT_LCR(uart, tmp);
+#endif
+		UART_PUT_CHAR(uart, buf[i]);
+		if (buf[i] == '\n') {
+			do {
+				status = UART_GET_LSR(uart);
+			} while (!(status & THRE));
+			UART_PUT_CHAR(uart, '\r');
+		}
+	}
+
+	spin_unlock_irqrestore(&uart->port.lock, flags);
+}
+EXPORT_SYMBOL(bfin_serial_debug);
+#else
+void bfin_serial_debug(const char *fmt, ...)
+{
+	return;
+}
+EXPORT_SYMBOL(bfin_serial_debug);
+#endif
+
 static struct uart_driver bfin_serial_reg = {
 	.owner			= THIS_MODULE,
 	.driver_name		= "bfin-uart",
-- 
1.5.6
