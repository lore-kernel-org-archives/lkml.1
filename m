Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZDGOnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZDGOnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZDGOmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:42:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43326 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757682AbZDGOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:42:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/11] Both software emulated and hardware based CTS and RTS
	are enabled in
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:41:30 +0100
Message-ID: <20090407154128.17182.16040.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
References: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

serial driver.

The CTS RTS PIN connection on BF548 UART port is defined as a modem device
not as a host device.  In order to test it under Linux, please nake a
cross UART cable to exchange CTS and RTS signal.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 .../mach-bf518/include/mach/bfin_serial_5xx.h      |   10 +
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |   10 +
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    9 +
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |   10 +
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |   10 +
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |   72 ++++-----
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    9 +
 drivers/serial/Kconfig                             |   26 ++-
 drivers/serial/bfin_5xx.c                          |  169 ++++++++++++++------
 9 files changed, 209 insertions(+), 116 deletions(-)


diff --git a/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
index e21c1c3..0fb2ce5 100644
--- a/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
@@ -53,9 +53,9 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
-#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
-#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
+#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
+#define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
 #define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
 
@@ -87,6 +87,7 @@
 struct bfin_serial_port {
 	struct uart_port port;
 	unsigned int old_status;
+	int status_irq;
 	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int tx_done;
@@ -125,6 +126,7 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 struct bfin_serial_res {
 	unsigned long uart_base_addr;
 	int uart_irq;
+	int uart_status_irq;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	unsigned int uart_tx_dma_channel;
 	unsigned int uart_rx_dma_channel;
@@ -140,6 +142,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	 0xFFC00400,
 	 IRQ_UART0_RX,
+	 IRQ_UART0_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	 CH_UART0_TX,
 	 CH_UART0_RX,
@@ -154,6 +157,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	 0xFFC02000,
 	 IRQ_UART1_RX,
+	 IRQ_UART1_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	 CH_UART1_TX,
 	 CH_UART1_RX,
diff --git a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
index d2b160c..a625659 100644
--- a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
@@ -53,9 +53,9 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
-#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
-#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
+#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
+#define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
 #define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
 
@@ -87,6 +87,7 @@
 struct bfin_serial_port {
 	struct uart_port port;
 	unsigned int old_status;
+	int status_irq;
 	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int tx_done;
@@ -125,6 +126,7 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 struct bfin_serial_res {
 	unsigned long uart_base_addr;
 	int uart_irq;
+	int uart_status_irq;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	unsigned int uart_tx_dma_channel;
 	unsigned int uart_rx_dma_channel;
@@ -140,6 +142,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	 0xFFC00400,
 	 IRQ_UART0_RX,
+	 IRQ_UART0_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	 CH_UART0_TX,
 	 CH_UART0_RX,
@@ -154,6 +157,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	 0xFFC02000,
 	 IRQ_UART1_RX,
+	 IRQ_UART1_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	 CH_UART1_TX,
 	 CH_UART1_RX,
diff --git a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
index 70356dd..a3789d7 100644
--- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
@@ -53,9 +53,9 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
-#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
-#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
+#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
+#define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
 #define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
 
@@ -74,6 +74,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	int			status_irq;
 	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
@@ -116,6 +117,7 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
+	int		uart_status_irq;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	unsigned int	uart_tx_dma_channel;
 	unsigned int	uart_rx_dma_channel;
@@ -130,6 +132,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC00400,
 	IRQ_UART_RX,
+	IRQ_UART_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART_TX,
 	CH_UART_RX,
diff --git a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
index d46fc4f..b86662f 100644
--- a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
@@ -53,9 +53,9 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
-#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
-#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
+#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
+#define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
 #define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
 
@@ -87,6 +87,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	int			status_irq;
 	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
@@ -124,6 +125,7 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
+	int		uart_status_irq;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	unsigned int	uart_tx_dma_channel;
 	unsigned int	uart_rx_dma_channel;
@@ -139,6 +141,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC00400,
 	IRQ_UART0_RX,
+	IRQ_UART0_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART0_TX,
 	CH_UART0_RX,
@@ -153,6 +156,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC02000,
 	IRQ_UART1_RX,
+	IRQ_UART1_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART1_TX,
 	CH_UART1_RX,
diff --git a/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
index 3c2811e..c536551 100644
--- a/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
@@ -53,9 +53,9 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
-#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
-#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
+#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
+#define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
 #define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
 
@@ -87,6 +87,7 @@
 struct bfin_serial_port {
 	struct uart_port	port;
 	unsigned int		old_status;
+	int			status_irq;
 	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
@@ -125,6 +126,7 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
+	int		uart_status_irq;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	unsigned int	uart_tx_dma_channel;
 	unsigned int	uart_rx_dma_channel;
@@ -140,6 +142,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC00400,
 	IRQ_UART0_RX,
+	IRQ_UART0_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART0_TX,
 	CH_UART0_RX,
@@ -154,6 +157,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC02000,
 	IRQ_UART1_RX,
+	IRQ_UART1_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART1_TX,
 	CH_UART1_RX,
diff --git a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
index 388e232..2d1b5fa 100644
--- a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
@@ -46,41 +46,27 @@
 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase + OFFSET_THR),v)
 #define UART_PUT_DLL(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_DLL),v)
 #define UART_SET_IER(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_IER_SET),v)
-#define UART_CLEAR_IER(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_IER_CLEAR),v)
+#define UART_CLEAR_IER(uart,v)  bfin_write16(((uart)->port.membase + OFFSET_IER_CLEAR),v)
 #define UART_PUT_DLH(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_DLH),v)
 #define UART_PUT_LSR(uart,v)	bfin_write16(((uart)->port.membase + OFFSET_LSR),v)
 #define UART_PUT_LCR(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_LCR),v)
 #define UART_CLEAR_LSR(uart)    bfin_write16(((uart)->port.membase + OFFSET_LSR), -1)
 #define UART_PUT_GCTL(uart,v)   bfin_write16(((uart)->port.membase + OFFSET_GCTL),v)
 #define UART_PUT_MCR(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_MCR),v)
+#define UART_CLEAR_SCTS(uart)   bfin_write16(((uart)->port.membase + OFFSET_MSR),SCTS)
 
 #define UART_SET_DLAB(uart)     /* MMRs not muxed on BF54x */
 #define UART_CLEAR_DLAB(uart)   /* MMRs not muxed on BF54x */
 
 #define UART_GET_CTS(x) (UART_GET_MSR(x) & CTS)
-#define UART_SET_RTS(x) (UART_PUT_MCR(x, UART_GET_MCR(x) | MRTS))
-#define UART_CLEAR_RTS(x) (UART_PUT_MCR(x, UART_GET_MCR(x) & ~MRTS))
+#define UART_DISABLE_RTS(x) UART_PUT_MCR(x, UART_GET_MCR(x) & ~(ARTS|MRTS))
+#define UART_ENABLE_RTS(x) UART_PUT_MCR(x, UART_GET_MCR(x) | MRTS | ARTS)
 #define UART_ENABLE_INTS(x, v) UART_SET_IER(x, v)
 #define UART_DISABLE_INTS(x) UART_CLEAR_IER(x, 0xF)
 
-#if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART2_CTSRTS)
-# define CONFIG_SERIAL_BFIN_CTSRTS
-
-# ifndef CONFIG_UART0_CTS_PIN
-#  define CONFIG_UART0_CTS_PIN -1
-# endif
-
-# ifndef CONFIG_UART0_RTS_PIN
-#  define CONFIG_UART0_RTS_PIN -1
-# endif
-
-# ifndef CONFIG_UART2_CTS_PIN
-#  define CONFIG_UART2_CTS_PIN -1
-# endif
-
-# ifndef CONFIG_UART2_RTS_PIN
-#  define CONFIG_UART2_RTS_PIN -1
-# endif
+#if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS) || \
+	defined(CONFIG_BFIN_UART2_CTSRTS) || defined(CONFIG_BFIN_UART3_CTSRTS)
+# define CONFIG_SERIAL_BFIN_HARD_CTSRTS
 #endif
 
 #define BFIN_UART_TX_FIFO_SIZE	2
@@ -91,6 +77,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	int			status_irq;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
 	int			tx_count;
@@ -101,23 +88,24 @@ struct bfin_serial_port {
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
 #endif
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct timer_list 	cts_timer;
-	int		cts_pin;
-	int 		rts_pin;
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	int			scts;
+	int			cts_pin;
+	int			rts_pin;
 #endif
 };
 
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
+	int		uart_status_irq;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	unsigned int	uart_tx_dma_channel;
 	unsigned int	uart_rx_dma_channel;
 #endif
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	int	uart_cts_pin;
-	int	uart_rts_pin;
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	int		uart_cts_pin;
+	int		uart_rts_pin;
 #endif
 };
 
@@ -126,13 +114,14 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC00400,
 	IRQ_UART0_RX,
+	IRQ_UART0_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART0_TX,
 	CH_UART0_RX,
 #endif
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	CONFIG_UART0_CTS_PIN,
-	CONFIG_UART0_RTS_PIN,
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	0,
+	0,
 #endif
 	},
 #endif
@@ -140,13 +129,14 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC02000,
 	IRQ_UART1_RX,
+	IRQ_UART1_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART1_TX,
 	CH_UART1_RX,
 #endif
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	0,
-	0,
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	GPIO_PE10,
+	GPIO_PE9,
 #endif
 	},
 #endif
@@ -154,13 +144,14 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC02100,
 	IRQ_UART2_RX,
+	IRQ_UART2_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART2_TX,
 	CH_UART2_RX,
 #endif
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	CONFIG_UART2_CTS_PIN,
-	CONFIG_UART2_RTS_PIN,
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	0,
+	0,
 #endif
 	},
 #endif
@@ -168,13 +159,14 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC03100,
 	IRQ_UART3_RX,
+	IRQ_UART3_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART3_TX,
 	CH_UART3_RX,
 #endif
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	0,
-	0,
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	GPIO_PB3,
+	GPIO_PB2,
 #endif
 	},
 #endif
diff --git a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
index d0469e3..a1b5087 100644
--- a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
@@ -53,9 +53,9 @@
 #define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart, UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
 #define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart, UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
 
-#define UART_GET_CTS(x) gpio_get_value(x->cts_pin)
-#define UART_SET_RTS(x) gpio_set_value(x->rts_pin, 1)
-#define UART_CLEAR_RTS(x) gpio_set_value(x->rts_pin, 0)
+#define UART_GET_CTS(x) (!gpio_get_value(x->cts_pin))
+#define UART_DISABLE_RTS(x) gpio_set_value(x->rts_pin, 1)
+#define UART_ENABLE_RTS(x) gpio_set_value(x->rts_pin, 0)
 #define UART_ENABLE_INTS(x, v) UART_PUT_IER(x, v)
 #define UART_DISABLE_INTS(x) UART_PUT_IER(x, 0)
 
@@ -74,6 +74,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	int			status_irq;
 	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
@@ -116,6 +117,7 @@ static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
+	int		uart_status_irq;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	unsigned int	uart_tx_dma_channel;
 	unsigned int	uart_rx_dma_channel;
@@ -130,6 +132,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	{
 	0xFFC00400,
 	IRQ_UART_RX,
+	IRQ_UART_ERROR,
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	CH_UART_TX,
 	CH_UART_RX,
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index d89972b..f2e5736 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -734,7 +734,7 @@ config BFIN_UART0_CTSRTS
 
 config UART0_CTS_PIN
 	int "UART0 CTS pin"
-	depends on BFIN_UART0_CTSRTS
+	depends on BFIN_UART0_CTSRTS && !BF548
 	default 23
 	help
 	  The default pin is GPIO_GP7.
@@ -742,7 +742,7 @@ config UART0_CTS_PIN
 
 config UART0_RTS_PIN
 	int "UART0 RTS pin"
-	depends on BFIN_UART0_CTSRTS
+	depends on BFIN_UART0_CTSRTS && !BF548
 	default 22
 	help
 	  The default pin is GPIO_GP6.
@@ -763,14 +763,14 @@ config BFIN_UART1_CTSRTS
 
 config UART1_CTS_PIN
 	int "UART1 CTS pin"
-	depends on BFIN_UART1_CTSRTS && !BF54x
+	depends on BFIN_UART1_CTSRTS && !BF548
 	default -1
 	help
 	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
 
 config UART1_RTS_PIN
 	int "UART1 RTS pin"
-	depends on BFIN_UART1_CTSRTS && !BF54x
+	depends on BFIN_UART1_CTSRTS && !BF548
 	default -1
 	help
 	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
@@ -790,14 +790,14 @@ config BFIN_UART2_CTSRTS
 
 config UART2_CTS_PIN
 	int "UART2 CTS pin"
-	depends on BFIN_UART2_CTSRTS
+	depends on BFIN_UART2_CTSRTS && !BF548
 	default -1
 	help
 	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
 
 config UART2_RTS_PIN
 	int "UART2 RTS pin"
-	depends on BFIN_UART2_CTSRTS
+	depends on BFIN_UART2_CTSRTS && !BF548
 	default -1
 	help
 	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
@@ -815,6 +815,20 @@ config BFIN_UART3_CTSRTS
 	  Enable hardware flow control in the driver. Using GPIO emulate the CTS/RTS
 	  signal.
 
+config UART3_CTS_PIN
+	int "UART3 CTS pin"
+	depends on BFIN_UART3_CTSRTS && !BF548
+	default -1
+	help
+	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+
+config UART3_RTS_PIN
+	int "UART3 RTS pin"
+	depends on BFIN_UART3_CTSRTS && !BF548
+	default -1
+	help
+	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+
 config SERIAL_IMX
 	bool "IMX serial port support"
 	depends on ARM && (ARCH_IMX || ARCH_MXC)
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index fbbddb9..18ba812 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -72,6 +72,63 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart);
 
 static void bfin_serial_reset_irda(struct uart_port *port);
 
+#if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
+	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
+static unsigned int bfin_serial_get_mctrl(struct uart_port *port)
+{
+	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+	if (uart->cts_pin < 0)
+		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
+
+	/* CTS PIN is negative assertive. */
+	if (UART_GET_CTS(uart))
+		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
+	else
+		return TIOCM_DSR | TIOCM_CAR;
+}
+
+static void bfin_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+	if (uart->rts_pin < 0)
+		return;
+
+	/* RTS PIN is negative assertive. */
+	if (mctrl & TIOCM_RTS)
+		UART_ENABLE_RTS(uart);
+	else
+		UART_DISABLE_RTS(uart);
+}
+
+/*
+ * Handle any change of modem status signal.
+ */
+static irqreturn_t bfin_serial_mctrl_cts_int(int irq, void *dev_id)
+{
+	struct bfin_serial_port *uart = dev_id;
+	unsigned int status;
+
+	status = bfin_serial_get_mctrl(&uart->port);
+	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	uart->scts = 1;
+	UART_CLEAR_SCTS(uart);
+	UART_CLEAR_IER(uart, EDSSI);
+#endif
+
+	return IRQ_HANDLED;
+}
+#else
+static unsigned int bfin_serial_get_mctrl(struct uart_port *port)
+{
+	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
+}
+
+static void bfin_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+}
+#endif
+
 /*
  * interrupts are disabled on entry
  */
@@ -108,6 +165,13 @@ static void bfin_serial_start_tx(struct uart_port *port)
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 	struct tty_struct *tty = uart->port.info->port.tty;
 
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+		uart->scts = 0;
+		uart_handle_cts_change(&uart->port, uart->scts);
+	}
+#endif
+
 	/*
 	 * To avoid losting RX interrupt, we reset IR function
 	 * before sending data.
@@ -303,6 +367,12 @@ static irqreturn_t bfin_serial_tx_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
 
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+		uart->scts = 0;
+		uart_handle_cts_change(&uart->port, uart->scts);
+	}
+#endif
 	spin_lock(&uart->port.lock);
 	if (UART_GET_LSR(uart) & THRE)
 		bfin_serial_tx_chars(uart);
@@ -433,6 +503,13 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq, void *dev_id)
 	struct bfin_serial_port *uart = dev_id;
 	struct circ_buf *xmit = &uart->port.info->xmit;
 
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+		uart->scts = 0;
+		uart_handle_cts_change(&uart->port, uart->scts);
+	}
+#endif
+
 	spin_lock(&uart->port.lock);
 	if (!(get_dma_curr_irqstat(uart->tx_dma_channel)&DMA_RUN)) {
 		disable_dma(uart->tx_dma_channel);
@@ -481,53 +558,6 @@ static unsigned int bfin_serial_tx_empty(struct uart_port *port)
 		return 0;
 }
 
-static unsigned int bfin_serial_get_mctrl(struct uart_port *port)
-{
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	if (uart->cts_pin < 0)
-		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
-
-	if (UART_GET_CTS(uart))
-		return TIOCM_DSR | TIOCM_CAR;
-	else
-#endif
-		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
-}
-
-static void bfin_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
-{
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	if (uart->rts_pin < 0)
-		return;
-
-	if (mctrl & TIOCM_RTS)
-		UART_CLEAR_RTS(uart);
-	else
-		UART_SET_RTS(uart);
-#endif
-}
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-/*
- * Handle any change of modem status signal.
- */
-static irqreturn_t bfin_serial_mctrl_cts_int(int irq, void *dev_id)
-{
-	struct bfin_serial_port *uart = dev_id;
-	unsigned int status;
-
-	status = bfin_serial_get_mctrl(&uart->port);
-	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
-
-	return IRQ_HANDLED;
-}
-#endif
-
-/*
- * Interrupts are always disabled.
- */
 static void bfin_serial_break_ctl(struct uart_port *port, int break_state)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
@@ -660,6 +690,28 @@ static int bfin_serial_startup(struct uart_port *port)
 		gpio_direction_output(uart->rts_pin, 0);
 	}
 #endif
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	if (request_irq(uart->status_irq,
+		bfin_serial_mctrl_cts_int,
+		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
+		pr_info("Unable to attach BlackFin UART Modem \
+			Status interrupt.\n");
+	}
+
+	if (uart->cts_pin >= 0) {
+		gpio_request(uart->cts_pin, DRIVER_NAME);
+		gpio_direction_output(uart->cts_pin, 1);
+	}
+	if (uart->rts_pin >= 0) {
+		gpio_request(uart->rts_pin, DRIVER_NAME);
+		gpio_direction_output(uart->rts_pin, 0);
+	}
+
+	/* CTS RTS PINs are negative assertive. */
+	UART_PUT_MCR(uart, ACTS);
+	UART_SET_IER(uart, EDSSI);
+#endif
+
 	UART_SET_IER(uart, ERBFI);
 	return 0;
 }
@@ -694,12 +746,20 @@ static void bfin_serial_shutdown(struct uart_port *port)
 	free_irq(uart->port.irq+1, uart);
 #endif
 
-# ifdef CONFIG_SERIAL_BFIN_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0)
 		free_irq(gpio_to_irq(uart->cts_pin), uart);
 	if (uart->rts_pin >= 0)
 		gpio_free(uart->rts_pin);
-# endif
+#endif
+#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	if (uart->cts_pin >= 0)
+		gpio_free(uart->cts_pin);
+	if (uart->rts_pin >= 0)
+		gpio_free(uart->rts_pin);
+	if (UART_GET_IER(uart) && EDSSI)
+		free_irq(uart->status_irq, uart);
+#endif
 }
 
 static void
@@ -1009,6 +1069,8 @@ static void __init bfin_serial_init_ports(void)
 			bfin_serial_resource[i].uart_base_addr;
 		bfin_serial_ports[i].port.irq       =
 			bfin_serial_resource[i].uart_irq;
+		bfin_serial_ports[i].status_irq	    =
+			bfin_serial_resource[i].uart_status_irq;
 		bfin_serial_ports[i].port.flags     = UPF_BOOT_AUTOCONF;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 		bfin_serial_ports[i].tx_done	    = 1;
@@ -1019,7 +1081,8 @@ static void __init bfin_serial_init_ports(void)
 			bfin_serial_resource[i].uart_rx_dma_channel;
 		init_timer(&(bfin_serial_ports[i].rx_dma_timer));
 #endif
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+#if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
+	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
 		bfin_serial_ports[i].cts_pin	    =
 			bfin_serial_resource[i].uart_cts_pin;
 		bfin_serial_ports[i].rts_pin	    =
@@ -1082,7 +1145,8 @@ bfin_serial_console_setup(struct console *co, char *options)
 	int baud = 57600;
 	int bits = 8;
 	int parity = 'n';
-# ifdef CONFIG_SERIAL_BFIN_CTSRTS
+# if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
+	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
 	int flow = 'r';
 # else
 	int flow = 'n';
@@ -1279,7 +1343,8 @@ static int bfin_serial_remove(struct platform_device *dev)
 			continue;
 		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
 		bfin_serial_ports[i].port.dev = NULL;
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+#if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
+	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
 		gpio_free(bfin_serial_ports[i].cts_pin);
 		gpio_free(bfin_serial_ports[i].rts_pin);
 #endif

