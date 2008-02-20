Return-Path: <linux-kernel-owner+w=401wt.eu-S933163AbYBTTez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbYBTTez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762193AbYBTTeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:34:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:53049 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761260AbYBTTeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:34:00 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] kgdb: kgdboc pl011 I/O module
Date: Wed, 20 Feb 2008 13:33:39 -0600
Message-Id: <1203536020-20102-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203536020-20102-2-git-send-email-jason.wessel@windriver.com>
References: <1203536020-20102-1-git-send-email-jason.wessel@windriver.com>
 <1203536020-20102-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Feb 2008 19:33:41.0828 (UTC) FILETIME=[7FCC7040:01C873F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the serial polling hooks for the pl011 uart for use with
kgdboc.

This patch was specifically tested on the ARM Versatile AB reference
platform.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/serial/amba-pl011.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 40604a0..ecd3dad 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -314,6 +314,32 @@ static void pl011_break_ctl(struct uart_port *port, int break_state)
 	spin_unlock_irqrestore(&uap->port.lock, flags);
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int pl010_get_poll_char(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int status;
+	int ch;
+	do {
+		status = readw(uap->port.membase + UART01x_FR);
+	} while (status & UART01x_FR_RXFE);
+	ch = readw(uap->port.membase + UART01x_DR);
+
+	return ch;
+}
+
+static void pl010_put_poll_char(struct uart_port *port,
+			 unsigned char ch)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+
+	while (readw(uap->port.membase + UART01x_FR) & UART01x_FR_TXFF)
+		barrier();
+	writew(ch, uap->port.membase + UART01x_DR);
+}
+
+#endif /* CONFIG_CONSOLE_POLL */
+
 static int pl011_startup(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
@@ -572,6 +598,10 @@ static struct uart_ops amba_pl011_pops = {
 	.request_port	= pl010_request_port,
 	.config_port	= pl010_config_port,
 	.verify_port	= pl010_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = pl010_get_poll_char,
+	.poll_put_char = pl010_put_poll_char,
+#endif
 };
 
 static struct uart_amba_port *amba_ports[UART_NR];
-- 
1.5.4

