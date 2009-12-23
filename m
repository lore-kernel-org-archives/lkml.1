Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZLWV12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZLWV12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZLWV1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:27:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:45084 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbZLWVUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:34 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 15/37] sparc,sunzilog: Add console polling support for sunzilog serial driver
Date: Wed, 23 Dec 2009 15:19:28 -0600
Message-Id: <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:14.0786 (UTC) FILETIME=[B7E46A20:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kgdboc to work on sparc hardware with the Zilog serial chips.

CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/sunzilog.c |   52 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index 2c7a66a..8748796 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -102,6 +102,8 @@ struct uart_sunzilog_port {
 #endif
 };
 
+static void sunzilog_putchar(struct uart_port *port, int ch);
+
 #define ZILOG_CHANNEL_FROM_PORT(PORT)	((struct zilog_channel __iomem *)((PORT)->membase))
 #define UART_ZILOG(PORT)		((struct uart_sunzilog_port *)(PORT))
 
@@ -996,6 +998,52 @@ static int sunzilog_verify_port(struct uart_port *port, struct serial_struct *se
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
+	udelay(2);
+
+}
+#endif /* CONFIG_CONSOLE_POLL */
+
 static struct uart_ops sunzilog_pops = {
 	.tx_empty	=	sunzilog_tx_empty,
 	.set_mctrl	=	sunzilog_set_mctrl,
@@ -1013,6 +1061,10 @@ static struct uart_ops sunzilog_pops = {
 	.request_port	=	sunzilog_request_port,
 	.config_port	=	sunzilog_config_port,
 	.verify_port	=	sunzilog_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	= sunzilog_get_poll_char,
+	.poll_put_char	= sunzilog_put_poll_char,
+#endif
 };
 
 static int uart_chip_count;
-- 
1.6.4.rc1

