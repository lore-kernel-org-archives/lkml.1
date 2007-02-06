Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbXBFRQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbXBFRQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXBFRQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:16:39 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54989 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752153AbXBFRQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:16:38 -0500
Date: Tue, 6 Feb 2007 18:16:12 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <andrew@sanpeople.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] atmel_serial: Use __raw I/O register access
Message-ID: <20070206181612.3002449a@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Access to chip-internal registers should always be native-endian.
This is especially important for AVR32 since it's a big-endian
architecture and the non-raw readl() and writel() macros are defined
to do little-endian accesses.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |   54 ++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index ed7f720..896c51c 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -73,35 +73,35 @@
 
 #define ATMEL_ISR_PASS_LIMIT	256
 
-#define UART_PUT_CR(port,v)	writel(v, (port)->membase + ATMEL_US_CR)
-#define UART_GET_MR(port)	readl((port)->membase + ATMEL_US_MR)
-#define UART_PUT_MR(port,v)	writel(v, (port)->membase + ATMEL_US_MR)
-#define UART_PUT_IER(port,v)	writel(v, (port)->membase + ATMEL_US_IER)
-#define UART_PUT_IDR(port,v)	writel(v, (port)->membase + ATMEL_US_IDR)
-#define UART_GET_IMR(port)	readl((port)->membase + ATMEL_US_IMR)
-#define UART_GET_CSR(port)	readl((port)->membase + ATMEL_US_CSR)
-#define UART_GET_CHAR(port)	readl((port)->membase + ATMEL_US_RHR)
-#define UART_PUT_CHAR(port,v)	writel(v, (port)->membase + ATMEL_US_THR)
-#define UART_GET_BRGR(port)	readl((port)->membase + ATMEL_US_BRGR)
-#define UART_PUT_BRGR(port,v)	writel(v, (port)->membase + ATMEL_US_BRGR)
-#define UART_PUT_RTOR(port,v)	writel(v, (port)->membase + ATMEL_US_RTOR)
-
-// #define UART_GET_CR(port)	readl((port)->membase + ATMEL_US_CR)		// is write-only
+#define UART_PUT_CR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_CR)
+#define UART_GET_MR(port)	__raw_readl((port)->membase + ATMEL_US_MR)
+#define UART_PUT_MR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_MR)
+#define UART_PUT_IER(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_IER)
+#define UART_PUT_IDR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_IDR)
+#define UART_GET_IMR(port)	__raw_readl((port)->membase + ATMEL_US_IMR)
+#define UART_GET_CSR(port)	__raw_readl((port)->membase + ATMEL_US_CSR)
+#define UART_GET_CHAR(port)	__raw_readl((port)->membase + ATMEL_US_RHR)
+#define UART_PUT_CHAR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_THR)
+#define UART_GET_BRGR(port)	__raw_readl((port)->membase + ATMEL_US_BRGR)
+#define UART_PUT_BRGR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_BRGR)
+#define UART_PUT_RTOR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_RTOR)
+
+// #define UART_GET_CR(port)	__raw_readl((port)->membase + ATMEL_US_CR)		// is write-only
 
  /* PDC registers */
-#define UART_PUT_PTCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_PTCR)
-#define UART_GET_PTSR(port)	readl((port)->membase + ATMEL_PDC_PTSR)
-
-#define UART_PUT_RPR(port,v)	writel(v, (port)->membase + ATMEL_PDC_RPR)
-#define UART_GET_RPR(port)	readl((port)->membase + ATMEL_PDC_RPR)
-#define UART_PUT_RCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_RCR)
-#define UART_PUT_RNPR(port,v)	writel(v, (port)->membase + ATMEL_PDC_RNPR)
-#define UART_PUT_RNCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_RNCR)
-
-#define UART_PUT_TPR(port,v)	writel(v, (port)->membase + ATMEL_PDC_TPR)
-#define UART_PUT_TCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_TCR)
-//#define UART_PUT_TNPR(port,v)	writel(v, (port)->membase + ATMEL_PDC_TNPR)
-//#define UART_PUT_TNCR(port,v)	writel(v, (port)->membase + ATMEL_PDC_TNCR)
+#define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
+#define UART_GET_PTSR(port)	__raw_readl((port)->membase + ATMEL_PDC_PTSR)
+
+#define UART_PUT_RPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RPR)
+#define UART_GET_RPR(port)	__raw_readl((port)->membase + ATMEL_PDC_RPR)
+#define UART_PUT_RCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RCR)
+#define UART_PUT_RNPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RNPR)
+#define UART_PUT_RNCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RNCR)
+
+#define UART_PUT_TPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TPR)
+#define UART_PUT_TCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TCR)
+//#define UART_PUT_TNPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TNPR)
+//#define UART_PUT_TNCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TNCR)
 
 static int (*atmel_open_hook)(struct uart_port *);
 static void (*atmel_close_hook)(struct uart_port *);
-- 
1.4.4.3

