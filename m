Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbYA3Jf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbYA3Jf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbYA3Jal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:41 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:53984 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbYA3JaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:21 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47624091"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 09/12] [Blackfin] serial driver: rework break flood anomaly handling to be more robust/realistic about what we can actually work around
Date: Wed, 30 Jan 2008 17:30:09 +0800
Message-Id: <1201685412-29095-10-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c                         |   66 ++++++++++++++++-----
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |    3 +
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |    3 +
 3 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index af84984..50aa3b2 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -206,12 +206,20 @@ int kgdb_get_debug_char(void)
 }
 #endif
 
+#if ANOMALY_05000230 && defined(CONFIG_SERIAL_BFIN_PIO)
+# define UART_GET_ANOMALY_THRESHOLD(uart)    ((uart)->anomaly_threshold)
+# define UART_SET_ANOMALY_THRESHOLD(uart, v) ((uart)->anomaly_threshold = (v))
+#else
+# define UART_GET_ANOMALY_THRESHOLD(uart)    0
+# define UART_SET_ANOMALY_THRESHOLD(uart, v)
+#endif
+
 #ifdef CONFIG_SERIAL_BFIN_PIO
 static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 {
 	struct tty_struct *tty = uart->port.info->tty;
 	unsigned int status, ch, flg;
-	static int in_break = 0;
+	static struct timeval anomaly_start = { .tv_sec = 0 };
 #ifdef CONFIG_KGDB_UART
 	struct pt_regs *regs = get_irq_regs();
 #endif
@@ -244,28 +252,56 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 #endif
 
 	if (ANOMALY_05000230) {
-		/* The BF533 family of processors have a nice misbehavior where
-		 * they continuously generate characters for a "single" break.
+		/* The BF533 (and BF561) family of processors have a nice anomaly
+		 * where they continuously generate characters for a "single" break.
 		 * We have to basically ignore this flood until the "next" valid
-		 * character comes across.  All other Blackfin families operate
-		 * properly though.
+		 * character comes across.  Due to the nature of the flood, it is
+		 * not possible to reliably catch bytes that are sent too quickly
+		 * after this break.  So application code talking to the Blackfin
+		 * which sends a break signal must allow at least 1.5 character
+		 * times after the end of the break for things to stabilize.  This
+		 * timeout was picked as it must absolutely be larger than 1
+		 * character time +/- some percent.  So 1.5 sounds good.  All other
+		 * Blackfin families operate properly.  Woo.
 		 * Note: While Anomaly 05000230 does not directly address this,
 		 *       the changes that went in for it also fixed this issue.
+		 *       That anomaly was fixed in 0.5+ silicon.  I like bunnies.
 		 */
-		if (in_break) {
-			if (ch != 0) {
-				in_break = 0;
-				ch = UART_GET_CHAR(uart);
-				if (bfin_revid() < 5)
-					return;
-			} else
-				return;
+		if (anomaly_start.tv_sec) {
+			struct timeval curr;
+			suseconds_t usecs;
+
+			if ((~ch & (~ch + 1)) & 0xff)
+				goto known_good_char;
+
+			do_gettimeofday(&curr);
+			if (curr.tv_sec - anomaly_start.tv_sec > 1)
+				goto known_good_char;
+
+			usecs = 0;
+			if (curr.tv_sec != anomaly_start.tv_sec)
+				usecs += USEC_PER_SEC;
+			usecs += curr.tv_usec - anomaly_start.tv_usec;
+
+			if (usecs > UART_GET_ANOMALY_THRESHOLD(uart))
+				goto known_good_char;
+
+			if (ch)
+				anomaly_start.tv_sec = 0;
+			else
+				anomaly_start = curr;
+
+			return;
+
+ known_good_char:
+			anomaly_start.tv_sec = 0;
 		}
 	}
 
 	if (status & BI) {
 		if (ANOMALY_05000230)
-			in_break = 1;
+			if (bfin_revid() < 5)
+				do_gettimeofday(&anomaly_start);
 		uart->port.icount.brk++;
 		if (uart_handle_break(&uart->port))
 			goto ignore_char;
@@ -778,6 +814,8 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	quot = uart_get_divisor(port, baud);
 	spin_lock_irqsave(&uart->port.lock, flags);
 
+	UART_SET_ANOMALY_THRESHOLD(uart, USEC_PER_SEC / baud * 15);
+
 	do {
 		lsr = UART_GET_LSR(uart);
 	} while (!(lsr & TEMT));
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index b619065..a1b4f4e 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -57,6 +57,9 @@ struct bfin_serial_port {
 	struct work_struct	tx_dma_workqueue;
 #else
 	struct work_struct 	cts_workqueue;
+# if ANOMALY_05000230
+	unsigned int anomaly_threshold;
+# endif
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	int			cts_pin;
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index b619065..a1b4f4e 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -57,6 +57,9 @@ struct bfin_serial_port {
 	struct work_struct	tx_dma_workqueue;
 #else
 	struct work_struct 	cts_workqueue;
+# if ANOMALY_05000230
+	unsigned int anomaly_threshold;
+# endif
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	int			cts_pin;
-- 
1.5.3.4
