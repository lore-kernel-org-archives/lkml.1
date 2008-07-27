Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYG0GGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYG0GGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYG0GF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:05:58 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:32725 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYG0GF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=sldSEfpR5BOU3eBcPxhQ1ZeiO89v6kL0YLy5BbR0NJrBtSD3sYUQn5LkIb7dynMtfy
         4z+xufUY96E83wbg4NSzsE3o9alYeYy0ihl73heiUri/P/NU8JjUkqIit6kq1pobSktB
         pcdSZPwbcuavuRBLQNNDk1KZk6d7EDYHnH254=
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/8] Blackfin Serial Driver: move common variables out of serial headers and into the serial driver
Date: Sun, 27 Jul 2008 14:04:03 +0800
Message-Id: <1217138647-18227-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
References: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

move common variables out of serial headers and into the serial driver and
rename "nr_ports" to "nr_active_ports" so as to easily differentiat
between BFIN_UART_NR_PORTS (the # of available) and nr_ports (the # of enabled)

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c                         |   17 ++++++++++-------
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |    3 ---
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |    2 --
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |    3 ---
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |    3 ---
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |    2 --
 6 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 444ebe5..f069309 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -42,6 +42,9 @@
 #define BFIN_SERIAL_MAJOR	204
 #define BFIN_SERIAL_MINOR	64
 
+static struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
+static int nr_active_ports = ARRAY_SIZE(bfin_serial_resource);
+
 /*
  * Setup for console. Argument comes from the menuconfig
  */
@@ -859,7 +862,7 @@ static void __init bfin_serial_init_ports(void)
 		return;
 	first = 0;
 
-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
 		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;
 		bfin_serial_ports[i].port.line      = i;
@@ -961,7 +964,7 @@ bfin_serial_console_setup(struct console *co, char *options)
 	 * if so, search for the first available port that does have
 	 * console support.
 	 */
-	if (co->index == -1 || co->index >= nr_ports)
+	if (co->index == -1 || co->index >= nr_active_ports)
 		co->index = 0;
 	uart = &bfin_serial_ports[co->index];
 
@@ -1072,7 +1075,7 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
 	struct bfin_serial_port *uart;
 	struct ktermios t;
 
-	if (port == -1 || port >= nr_ports)
+	if (port == -1 || port >= nr_active_ports)
 		port = 0;
 	bfin_serial_init_ports();
 	bfin_early_serial_console.index = port;
@@ -1102,7 +1105,7 @@ static int bfin_serial_suspend(struct platform_device *dev, pm_message_t state)
 {
 	int i;
 
-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		if (bfin_serial_ports[i].port.dev != &dev->dev)
 			continue;
 		uart_suspend_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
@@ -1115,7 +1118,7 @@ static int bfin_serial_resume(struct platform_device *dev)
 {
 	int i;
 
-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		if (bfin_serial_ports[i].port.dev != &dev->dev)
 			continue;
 		uart_resume_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
@@ -1134,7 +1137,7 @@ static int bfin_serial_probe(struct platform_device *dev)
 			break;
 
 	if (i < dev->num_resources) {
-		for (i = 0; i < nr_ports; i++, res++) {
+		for (i = 0; i < nr_active_ports; i++, res++) {
 			if (bfin_serial_ports[i].port.mapbase != res->start)
 				continue;
 			bfin_serial_ports[i].port.dev = &dev->dev;
@@ -1149,7 +1152,7 @@ static int bfin_serial_remove(struct platform_device *dev)
 {
 	int i;
 
-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		if (bfin_serial_ports[i].port.dev != &dev->dev)
 			continue;
 		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
index 2526b6e..a23d047 100644
--- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -119,7 +119,6 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long uart_base_addr;
 	int uart_irq;
@@ -164,8 +163,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };
 
-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"
 
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index ebf592b..20471cd 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -111,7 +111,6 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -142,7 +141,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 #define DRIVER_NAME "bfin-uart"
 
-int nr_ports = BFIN_UART_NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 1bf56ff..08dfe30 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -119,7 +119,6 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -164,8 +163,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };
 
-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"
 
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 5e29446..76976b1 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -105,7 +105,6 @@ struct bfin_serial_port {
 #endif
 };
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -170,8 +169,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };
 
-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"
 
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index 8aa0278..6cddca4 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -111,7 +111,6 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }
 
-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -142,7 +141,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 #define DRIVER_NAME "bfin-uart"
 
-int nr_ports = BFIN_UART_NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
-- 
1.5.6

