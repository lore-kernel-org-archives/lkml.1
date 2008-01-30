Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbYA3JfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbYA3JfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758220AbYA3Jai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:38 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:63088 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbYA3JaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:21 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47624090"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 08/12] [Blackfin] serial driver: fix bug - cache the bits of the LSR on systems where the LSR is read-to-clear
Date: Wed, 30 Jan 2008 17:30:08 +0800
Message-Id: <1201685412-29095-9-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Cache the bits of the LSR on systems where the LSR is read-to-clear
so that we can safely read the LSR in random places.  this fixes
older parts where break/framing/parity/overflow was not being detected
at all in PIO mode, and this fixes newer parts where
break/framing/parity/overflow was being reported all the time
without being cleared.

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c                         |   10 +++++++---
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |   19 ++++++++++++++++++-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |   19 ++++++++++++++++++-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |   19 ++++++++++++++++++-
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |    1 +
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |   19 ++++++++++++++++++-
 6 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index ca9ceaa..af84984 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -216,8 +216,10 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 	struct pt_regs *regs = get_irq_regs();
 #endif
 
- 	ch = UART_GET_CHAR(uart);
 	status = UART_GET_LSR(uart);
+	UART_CLEAR_LSR(uart);
+
+ 	ch = UART_GET_CHAR(uart);
  	uart->port.icount.rx++;
 
 #ifdef CONFIG_KGDB_UART
@@ -335,7 +337,7 @@ static irqreturn_t bfin_serial_rx_int(int irq, void *dev_id)
 	struct bfin_serial_port *uart = dev_id;
 
 	spin_lock(&uart->port.lock);
-	while ((UART_GET_IER(uart) & ERBFI) && (UART_GET_LSR(uart) & DR))
+	while (UART_GET_LSR(uart) & DR)
 		bfin_serial_rx_chars(uart);
 	spin_unlock(&uart->port.lock);
 
@@ -347,7 +349,7 @@ static irqreturn_t bfin_serial_tx_int(int irq, void *dev_id)
 	struct bfin_serial_port *uart = dev_id;
 
 	spin_lock(&uart->port.lock);
-	if ((UART_GET_IER(uart) & ETBEI) && (UART_GET_LSR(uart) & THRE))
+	if (UART_GET_LSR(uart) & THRE)
 		bfin_serial_tx_chars(uart);
 	spin_unlock(&uart->port.lock);
 
@@ -428,6 +430,8 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 	int i, flg, status;
 
 	status = UART_GET_LSR(uart);
+	UART_CLEAR_LSR(uart);
+
 	uart->port.icount.rx += CIRC_CNT(uart->rx_dma_buf.head, uart->rx_dma_buf.tail, UART_XMIT_SIZE);;
 
 	if (status & BI) {
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
index 15dbc21..233c585 100644
--- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -23,7 +23,6 @@
 #define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
 #define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase + OFFSET_IIR))
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LCR))
-#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase + OFFSET_GCTL))
 
 #define UART_PUT_CHAR(uart, v)   bfin_write16(((uart)->port.membase + OFFSET_THR), v)
@@ -58,6 +57,7 @@
 struct bfin_serial_port {
 	struct uart_port port;
 	unsigned int old_status;
+	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int tx_done;
 	int tx_count;
@@ -76,6 +76,23 @@ struct bfin_serial_port {
 #endif
 };
 
+/* The hardware clears the LSR bits upon read, so we need to cache
+ * some of the more fun bits in software so they don't get lost
+ * when checking the LSR in other code paths (TX).
+ */
+static inline unsigned int UART_GET_LSR(struct bfin_serial_port *uart)
+{
+	unsigned int lsr = bfin_read16(uart->port.membase + OFFSET_LSR);
+	uart->lsr |= (lsr & (BI|FE|PE|OE));
+	return lsr | uart->lsr;
+}
+
+static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
+{
+	uart->lsr = 0;
+	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
+}
+
 struct bfin_serial_port bfin_serial_ports[NR_PORTS];
 struct bfin_serial_res {
 	unsigned long uart_base_addr;
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index 7871d43..b619065 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -23,7 +23,6 @@
 #define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
 #define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase + OFFSET_IIR))
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LCR))
-#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase + OFFSET_GCTL))
 
 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase + OFFSET_THR),v)
@@ -46,6 +45,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
 	int			tx_count;
@@ -64,6 +64,23 @@ struct bfin_serial_port {
 #endif
 };
 
+/* The hardware clears the LSR bits upon read, so we need to cache
+ * some of the more fun bits in software so they don't get lost
+ * when checking the LSR in other code paths (TX).
+ */
+static inline unsigned int UART_GET_LSR(struct bfin_serial_port *uart)
+{
+	unsigned int lsr = bfin_read16(uart->port.membase + OFFSET_LSR);
+	uart->lsr |= (lsr & (BI|FE|PE|OE));
+	return lsr | uart->lsr;
+}
+
+static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
+{
+	uart->lsr = 0;
+	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
+}
+
 struct bfin_serial_port bfin_serial_ports[NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 86e45c3..f18c517 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -23,7 +23,6 @@
 #define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
 #define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase + OFFSET_IIR))
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LCR))
-#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase + OFFSET_GCTL))
 
 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase + OFFSET_THR),v)
@@ -58,6 +57,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
 	int			tx_count;
@@ -76,6 +76,23 @@ struct bfin_serial_port {
 #endif
 };
 
+/* The hardware clears the LSR bits upon read, so we need to cache
+ * some of the more fun bits in software so they don't get lost
+ * when checking the LSR in other code paths (TX).
+ */
+static inline unsigned int UART_GET_LSR(struct bfin_serial_port *uart)
+{
+	unsigned int lsr = bfin_read16(uart->port.membase + OFFSET_LSR);
+	uart->lsr |= (lsr & (BI|FE|PE|OE));
+	return lsr | uart->lsr;
+}
+
+static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
+{
+	uart->lsr = 0;
+	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
+}
+
 struct bfin_serial_port bfin_serial_ports[NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 3770aa3..8733d47 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -32,6 +32,7 @@
 #define UART_PUT_DLH(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_DLH),v)
 #define UART_PUT_LSR(uart,v)	bfin_write16(((uart)->port.membase + OFFSET_LSR),v)
 #define UART_PUT_LCR(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_LCR),v)
+#define UART_CLEAR_LSR(uart)    bfin_write16(((uart)->port.membase + OFFSET_LSR), -1)
 #define UART_PUT_GCTL(uart,v)   bfin_write16(((uart)->port.membase + OFFSET_GCTL),v)
 
 #if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index 7871d43..b619065 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -23,7 +23,6 @@
 #define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
 #define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase + OFFSET_IIR))
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LCR))
-#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase + OFFSET_GCTL))
 
 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase + OFFSET_THR),v)
@@ -46,6 +45,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
 	int			tx_count;
@@ -64,6 +64,23 @@ struct bfin_serial_port {
 #endif
 };
 
+/* The hardware clears the LSR bits upon read, so we need to cache
+ * some of the more fun bits in software so they don't get lost
+ * when checking the LSR in other code paths (TX).
+ */
+static inline unsigned int UART_GET_LSR(struct bfin_serial_port *uart)
+{
+	unsigned int lsr = bfin_read16(uart->port.membase + OFFSET_LSR);
+	uart->lsr |= (lsr & (BI|FE|PE|OE));
+	return lsr | uart->lsr;
+}
+
+static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
+{
+	uart->lsr = 0;
+	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
+}
+
 struct bfin_serial_port bfin_serial_ports[NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
-- 
1.5.3.4
