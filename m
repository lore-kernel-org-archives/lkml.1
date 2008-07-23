Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYGWShz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYGWShz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYGWSgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:36:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:64590 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYGWSgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:36:13 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, galak@kernel.crashing.org
Subject: [PATCH 4/5] kgdb: kgdboc console poll hooks for cpm uart
Date: Wed, 23 Jul 2008 13:35:38 -0500
Message-Id: <1216838139-719-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1216838139-719-4-git-send-email-jason.wessel@windriver.com>
References: <1216838139-719-1-git-send-email-jason.wessel@windriver.com>
 <1216838139-719-2-git-send-email-jason.wessel@windriver.com>
 <1216838139-719-3-git-send-email-jason.wessel@windriver.com>
 <1216838139-719-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Jul 2008 18:35:55.0326 (UTC) FILETIME=[F137B5E0:01C8ECF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in console polling hooks for the cpm uart for use with kgdb and
kgdboc.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: galak@kernel.crashing.org
---
 drivers/serial/cpm_uart/cpm_uart_core.c |   95 ++++++++++++++++++++++++++++++-
 1 files changed, 94 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index 93e407e..1ff80de 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -201,6 +201,10 @@ static void cpm_uart_int_tx(struct uart_port *port)
 	cpm_uart_tx_pump(port);
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int serial_polled;
+#endif
+
 /*
  * Receive characters
  */
@@ -222,6 +226,12 @@ static void cpm_uart_int_rx(struct uart_port *port)
 	 */
 	bdp = pinfo->rx_cur;
 	for (;;) {
+#ifdef CONFIG_CONSOLE_POLL
+		if (unlikely(serial_polled)) {
+			serial_polled = 0;
+			return;
+		}
+#endif
 		/* get status */
 		status = in_be16(&bdp->cbd_sc);
 		/* If this one is empty, return happy */
@@ -253,7 +263,12 @@ static void cpm_uart_int_rx(struct uart_port *port)
 				goto handle_error;
 			if (uart_handle_sysrq_char(port, ch))
 				continue;
-
+#ifdef CONFIG_CONSOLE_POLL
+			if (unlikely(serial_polled)) {
+				serial_polled = 0;
+				return;
+			}
+#endif
 		      error_return:
 			tty_insert_flip_char(tty, ch, flg);
 
@@ -865,6 +880,80 @@ static void cpm_uart_config_port(struct uart_port *port, int flags)
 		cpm_uart_request_port(port);
 	}
 }
+
+#ifdef CONFIG_CONSOLE_POLL
+/* Serial polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+#define GDB_BUF_SIZE	512	/* power of 2, please */
+
+static char poll_buf[GDB_BUF_SIZE];
+static char *pollp;
+static int poll_chars;
+
+static int poll_wait_key(char *obuf, struct uart_cpm_port *pinfo)
+{
+	u_char		c, *cp;
+	volatile cbd_t	*bdp;
+	int		i;
+
+	/* Get the address of the host memory buffer.
+	 */
+	bdp = pinfo->rx_cur;
+	while (bdp->cbd_sc & BD_SC_EMPTY)
+		;
+
+	/* If the buffer address is in the CPM DPRAM, don't
+	 * convert it.
+	 */
+	cp = cpm2cpu_addr(bdp->cbd_bufaddr, pinfo);
+
+	if (obuf) {
+		i = c = bdp->cbd_datlen;
+		while (i-- > 0)
+			*obuf++ = *cp++;
+	} else
+		c = *cp;
+	bdp->cbd_sc &= ~(BD_SC_BR | BD_SC_FR | BD_SC_PR | BD_SC_OV | BD_SC_ID);
+	bdp->cbd_sc |= BD_SC_EMPTY;
+
+	if (bdp->cbd_sc & BD_SC_WRAP)
+		bdp = pinfo->rx_bd_base;
+	else
+		bdp++;
+	pinfo->rx_cur = (cbd_t *)bdp;
+
+	return (int)c;
+}
+
+static int cpm_get_poll_char(struct uart_port *port)
+{
+	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+
+	if (!serial_polled) {
+		serial_polled = 1;
+		poll_chars = 0;
+	}
+	if (poll_chars <= 0) {
+		poll_chars = poll_wait_key(poll_buf, pinfo);
+		pollp = poll_buf;
+	}
+	poll_chars--;
+	return *pollp++;
+}
+
+static void cpm_put_poll_char(struct uart_port *port,
+			 unsigned char c)
+{
+	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	static char ch[2];
+
+	ch[0] = (char)c;
+	cpm_uart_early_write(pinfo->port.line, ch, 1);
+}
+#endif /* CONFIG_CONSOLE_POLL */
+
 static struct uart_ops cpm_uart_pops = {
 	.tx_empty	= cpm_uart_tx_empty,
 	.set_mctrl	= cpm_uart_set_mctrl,
@@ -882,6 +971,10 @@ static struct uart_ops cpm_uart_pops = {
 	.request_port	= cpm_uart_request_port,
 	.config_port	= cpm_uart_config_port,
 	.verify_port	= cpm_uart_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = cpm_get_poll_char,
+	.poll_put_char = cpm_put_poll_char,
+#endif
 };
 
 struct uart_cpm_port cpm_uart_ports[UART_NR];
-- 
1.5.5.1

