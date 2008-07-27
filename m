Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYG0GHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYG0GHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYG0GHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:07:04 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:32978 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYG0GHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=h/DhnCdGFB16Yctqda24n44aTnfG4Mn8l0jOTwRlRLNjTmtRafhDrsBhOQgIj+TXyn
         w/liVANRMlOzJ71R0jM57TQN3tL7cMnpUXOpU+uWheFUgvMlBNCi0jnqsVGazPujCltv
         fzzeUL1s11yoqs6NojN93mh/Dc7bomI1KBxr4=
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 7/8] Blackfin Serial Driver: Fix bug - ircp fails on sir over Blackfin UART
Date: Sun, 27 Jul 2008 14:04:06 +0800
Message-Id: <1217138647-18227-8-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
References: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

We now use the sir_dev/irtty_sir/uart/bfin_serial drivers framework
to monitor the TX status.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c                         |    4 ++++
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |    3 +++
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |    2 ++
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |    3 +++
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |    3 +++
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |    2 ++
 6 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index afeff9f..ac74d8b 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -761,6 +761,9 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	val |= UCEN;
 	UART_PUT_GCTL(uart, val);
 
+	/* Port speed changed, update the per-port timeout. */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
 	spin_unlock_irqrestore(&uart->port.lock, flags);
 }
 
@@ -865,6 +868,7 @@ static void __init bfin_serial_init_ports(void)
 
 	for (i = 0; i < nr_active_ports; i++) {
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
+		bfin_serial_ports[i].port.fifosize  = BFIN_UART_TX_FIFO_SIZE;
 		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;
 		bfin_serial_ports[i].port.line      = i;
 		bfin_serial_ports[i].port.iotype    = UPIO_MEM;
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
index a23d047..75722d6 100644
--- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -78,6 +78,9 @@
 #  define CONFIG_UART1_RTS_PIN -1
 # endif
 #endif
+
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 /*
  * The pin configuration is different from schematic
  */
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index 20471cd..815bfe5 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -69,6 +69,8 @@
 # endif
 #endif
 
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 08dfe30..b3f87e1 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -78,6 +78,9 @@
 #  define CONFIG_UART1_RTS_PIN -1
 # endif
 #endif
+
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 /*
  * The pin configuration is different from schematic
  */
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 76976b1..e4cf35e 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -82,6 +82,9 @@
 #  define CONFIG_UART1_RTS_PIN -1
 # endif
 #endif
+
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 /*
  * The pin configuration is different from schematic
  */
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index 6cddca4..e0ce0c1 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -69,6 +69,8 @@
 # endif
 #endif
 
+#define BFIN_UART_TX_FIFO_SIZE	2
+
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
-- 
1.5.6

