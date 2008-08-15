Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYHOIXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYHOIXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYHOIWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:22:54 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:1932 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYHOIWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:22:53 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="58085953"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] Blackfin Serial Driver: fix bug - Avoid null point exception in kgdb over UART
Date: Fri, 15 Aug 2008 16:14:09 +0800
Message-Id: <1218788049-7632-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1218788049-7632-1-git-send-email-cooloney@kernel.org>
References: <1218788049-7632-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 487a562..a5ff54e 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -124,8 +124,6 @@ static void bfin_serial_enable_ms(struct uart_port *port)
 }
 
 #ifdef CONFIG_KGDB_UART
-static int kgdb_entry_state;
-
 void kgdb_put_debug_char(int chr)
 {
 	struct bfin_serial_port *uart;
@@ -178,7 +176,7 @@ int kgdb_get_debug_char(void)
 #ifdef CONFIG_SERIAL_BFIN_PIO
 static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 {
-	struct tty_struct *tty = uart->port.info->port.tty;
+	struct tty_struct *tty = NULL;
 	unsigned int status, ch, flg;
 	static struct timeval anomaly_start = { .tv_sec = 0 };
 
@@ -191,24 +189,33 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 #ifdef CONFIG_KGDB_UART
 	if (uart->port.line == CONFIG_KGDB_UART_PORT) {
 		struct pt_regs *regs = get_irq_regs();
-		if (uart->port.cons->index == CONFIG_KGDB_UART_PORT && ch == 0x1) { /* Ctrl + A */
-			kgdb_breakkey_pressed(regs);
-			return;
-		} else if (kgdb_entry_state == 0 && ch == '$') {/* connection from KGDB */
-			kgdb_entry_state = 1;
-		} else if (kgdb_entry_state == 1 && ch == 'q') {
-			kgdb_entry_state = 0;
+		int kgdb_timeout;
+		if (uart->port.cons->index == CONFIG_KGDB_UART_PORT
+			&& ch == 0x1) { /* Ctrl + A */
 			kgdb_breakkey_pressed(regs);
 			return;
+		}
+		if (ch == '$') {
+			/* connection from KGDB */
+			kgdb_timeout = get_cclk()/10000;
+			while (!(UART_GET_LSR(uart) & DR)
+				&& kgdb_timeout > 0) {
+				kgdb_timeout--;
+				cpu_relax();
+			}
+			if (kgdb_timeout && UART_GET_CHAR(uart) == 'q') {
+				kgdb_breakkey_pressed(regs);
+				return;
+			}
 		} else if (ch == 0x3) {/* Ctrl + C */
-			kgdb_entry_state = 0;
 			kgdb_breakkey_pressed(regs);
 			return;
-		} else {
-			kgdb_entry_state = 0;
 		}
+		if (!uart->port.info)
+			return;
 	}
 #endif
+	tty = uart->port.info->tty;
 
 	if (ANOMALY_05000363) {
 		/* The BF533 (and BF561) family of processors have a nice anomaly
@@ -1076,10 +1083,7 @@ static int __init bfin_serial_rs_console_init(void)
 {
 	bfin_serial_init_ports();
 	register_console(&bfin_serial_console);
-#ifdef CONFIG_KGDB_UART
-	kgdb_entry_state = 0;
-	init_kgdb_uart();
-#endif
+
 	return 0;
 }
 console_initcall(bfin_serial_rs_console_init);
@@ -1266,6 +1270,7 @@ static int __init bfin_serial_init(void)
 		t.c_line = CONFIG_KGDB_UART_PORT;
 		bfin_serial_set_termios(&uart->port, &t, &t);
 	}
+	init_kgdb_uart();
 #endif
 	return ret;
 }
@@ -1276,7 +1281,11 @@ static void __exit bfin_serial_exit(void)
 	uart_unregister_driver(&bfin_serial_reg);
 }
 
+#ifdef CONFIG_KGDB_UART
+subsys_initcall(bfin_serial_init);
+#else
 module_init(bfin_serial_init);
+#endif
 module_exit(bfin_serial_exit);
 
 MODULE_AUTHOR("Aubrey.Li <aubrey.li@analog.com>");
-- 
1.5.6
