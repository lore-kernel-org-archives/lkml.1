Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZCFGpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZCFGpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbZCFGlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:07 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50912 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbZCFGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:57 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883660"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Philippe Gerum <rpm@xenomai.org>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 15/18] Blackfin Serial Driver: merge the upstream adeos/xenomai
Date: Fri,  6 Mar 2009 14:42:57 +0800
Message-Id: <1236321780-28718-16-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

add ipipe serial debug function for adeos

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 71a9e6b..8aa0e37 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1145,6 +1145,51 @@ static void bfin_serial_console_putchar(struct uart_port *port, int ch)
 	SSYNC();
 }
 
+#ifdef CONFIG_IPIPE
+
+#include <stdarg.h>
+
+void __ipipe_serial_debug(const char *fmt, ...)
+{
+	struct bfin_serial_port *uart = &bfin_serial_ports[0];
+	unsigned short status, tmp;
+	int flags, i, count;
+	char buf[128];
+	va_list ap;
+
+	va_start(ap, fmt);
+	vsprintf(buf, fmt, ap);
+	va_end(ap);
+	count = strlen(buf);
+
+	local_irq_save_hw(flags);
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
+
+		UART_PUT_CHAR(uart, buf[i]);
+		if (buf[i] == '\n') {
+			do {
+				status = UART_GET_LSR(uart);
+			} while (!(status & THRE));
+			UART_PUT_CHAR(uart, '\r');
+		}
+	}
+
+	local_irq_restore_hw(flags);
+}
+EXPORT_SYMBOL(__ipipe_serial_debug);
+
+#endif /* CONFIG_IPIPE */
+
 /*
  * Interrupts are disabled on entering
  */
-- 
1.5.6.3
