Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab0BLWnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:43:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:44105 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab0BLWg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:29 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 12/28] sparc,sunzilog: Add console polling support for sunzilog serial driver
Date: Fri, 12 Feb 2010 16:35:27 -0600
Message-Id: <1266014143-29444-13-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:14.0083 (UTC) FILETIME=[C8832D30:01CAAC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kgdboc to work on sparc hardware with the Zilog serial chips.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 drivers/serial/sunzilog.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index 2c7a66a..978b3ce 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -102,6 +102,8 @@ struct uart_sunzilog_port {
 #endif
 };
 
+static void sunzilog_putchar(struct uart_port *port, int ch);
+
 #define ZILOG_CHANNEL_FROM_PORT(PORT)	((struct zilog_channel __iomem *)((PORT)->membase))
 #define UART_ZILOG(PORT)		((struct uart_sunzilog_port *)(PORT))
 
@@ -996,6 +998,50 @@ static int sunzilog_verify_port(struct uart_port *port, struct serial_struct *se
 	return -EINVAL;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int sunzilog_get_poll_char(struct uart_port *port)
+{
+	unsigned char ch, r1;
+	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
+	struct zilog_channel __iomem *channel
+		= ZILOG_CHANNEL_FROM_PORT(&up->port);
+
+
+	r1 = read_zsreg(channel, R1);
+	if (r1 & (PAR_ERR | Rx_OVR | CRC_ERR)) {
+		writeb(ERR_RES, &channel->control);
+		ZSDELAY();
+		ZS_WSYNC(channel);
+	}
+
+	ch = readb(&channel->control);
+	ZSDELAY();
+
+	/* This funny hack depends upon BRK_ABRT not interfering
+	 * with the other bits we care about in R1.
+	 */
+	if (ch & BRK_ABRT)
+		r1 |= BRK_ABRT;
+
+	if (!(ch & Rx_CH_AV))
+		return NO_POLL_CHAR;
+
+	ch = readb(&channel->data);
+	ZSDELAY();
+
+	ch &= up->parity_mask;
+	return ch;
+}
+
+static void sunzilog_put_poll_char(struct uart_port *port,
+			unsigned char ch)
+{
+	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *)port;
+
+	sunzilog_putchar(&up->port, ch);
+}
+#endif /* CONFIG_CONSOLE_POLL */
+
 static struct uart_ops sunzilog_pops = {
 	.tx_empty	=	sunzilog_tx_empty,
 	.set_mctrl	=	sunzilog_set_mctrl,
@@ -1013,6 +1059,10 @@ static struct uart_ops sunzilog_pops = {
 	.request_port	=	sunzilog_request_port,
 	.config_port	=	sunzilog_config_port,
 	.verify_port	=	sunzilog_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	=	sunzilog_get_poll_char,
+	.poll_put_char	=	sunzilog_put_poll_char,
+#endif
 };
 
 static int uart_chip_count;
-- 
1.6.4.rc1

