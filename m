Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbYGOM2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbYGOM2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbYGOM2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:28:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:39661 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbYGOM16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:27:58 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/4] kgdb: kgdboc console poll hooks for mpsc uart
Date: Tue, 15 Jul 2008 07:27:56 -0500
Message-Id: <1216124876-19108-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1216124876-19108-4-git-send-email-jason.wessel@windriver.com>
References: <1216124876-19108-1-git-send-email-jason.wessel@windriver.com>
 <1216124876-19108-2-git-send-email-jason.wessel@windriver.com>
 <1216124876-19108-3-git-send-email-jason.wessel@windriver.com>
 <1216124876-19108-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 Jul 2008 12:27:57.0930 (UTC) FILETIME=[36C26CA0:01C8E676]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in console polling hooks for the mpsc uart for use with kgdb and
kgdboc.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/mpsc.c |  148 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 147 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index e8819c4..08aa806 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -921,6 +921,10 @@ static int mpsc_make_ready(struct mpsc_port_info *pi)
 	return 0;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int serial_polled;
+#endif
+
 /*
  ******************************************************************************
  *
@@ -956,7 +960,12 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi)
 	while (!((cmdstat = be32_to_cpu(rxre->cmdstat))
 				& SDMA_DESC_CMDSTAT_O)) {
 		bytes_in = be16_to_cpu(rxre->bytecnt);
-
+#ifdef CONFIG_CONSOLE_POLL
+		if (unlikely(serial_polled)) {
+			serial_polled = 0;
+			return 0;
+		}
+#endif
 		/* Following use of tty struct directly is deprecated */
 		if (unlikely(tty_buffer_request_room(tty, bytes_in)
 					< bytes_in)) {
@@ -1017,6 +1026,12 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi)
 		if (uart_handle_sysrq_char(&pi->port, *bp)) {
 			bp++;
 			bytes_in--;
+#ifdef CONFIG_CONSOLE_POLL
+			if (unlikely(serial_polled)) {
+				serial_polled = 0;
+				return 0;
+			}
+#endif
 			goto next_frame;
 		}
 
@@ -1519,6 +1534,133 @@ static int mpsc_verify_port(struct uart_port *port, struct serial_struct *ser)
 
 	return rc;
 }
+#ifdef CONFIG_CONSOLE_POLL
+/* Serial polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+static char poll_buf[2048];
+static int poll_ptr;
+static int poll_cnt;
+static void mpsc_put_poll_char(struct uart_port *port,
+							   unsigned char c);
+
+static int mpsc_get_poll_char(struct uart_port *port)
+{
+	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_rx_desc *rxre;
+	u32	cmdstat, bytes_in, i;
+	u8	*bp;
+
+	if (!serial_polled)
+		serial_polled = 1;
+
+	pr_debug("mpsc_rx_intr[%d]: Handling Rx intr\n", pi->port.line);
+
+	if (poll_cnt) {
+		poll_cnt--;
+		return poll_buf[poll_ptr++];
+	}
+	poll_ptr = 0;
+	poll_cnt = 0;
+
+	while (poll_cnt == 0) {
+		rxre = (struct mpsc_rx_desc *)(pi->rxr +
+		       (pi->rxr_posn*MPSC_RXRE_SIZE));
+		dma_cache_sync(pi->port.dev, (void *)rxre,
+			       MPSC_RXRE_SIZE, DMA_FROM_DEVICE);
+#if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
+		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
+			invalidate_dcache_range((ulong)rxre,
+			(ulong)rxre + MPSC_RXRE_SIZE);
+#endif
+		/*
+		 * Loop through Rx descriptors handling ones that have
+		 * been completed.
+		 */
+		while (poll_cnt == 0 &&
+		       !((cmdstat = be32_to_cpu(rxre->cmdstat)) &
+			 SDMA_DESC_CMDSTAT_O)){
+			bytes_in = be16_to_cpu(rxre->bytecnt);
+			bp = pi->rxb + (pi->rxr_posn * MPSC_RXBE_SIZE);
+			dma_cache_sync(pi->port.dev, (void *) bp,
+				       MPSC_RXBE_SIZE, DMA_FROM_DEVICE);
+#if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
+			if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
+				invalidate_dcache_range((ulong)bp,
+					(ulong)bp + MPSC_RXBE_SIZE);
+#endif
+			if ((unlikely(cmdstat & (SDMA_DESC_CMDSTAT_BR |
+			 SDMA_DESC_CMDSTAT_FR | SDMA_DESC_CMDSTAT_OR))) &&
+				!(cmdstat & pi->port.ignore_status_mask)) {
+				poll_buf[poll_cnt] = *bp;
+				poll_cnt++;
+			} else {
+				for (i = 0; i < bytes_in; i++) {
+					poll_buf[poll_cnt] = *bp++;
+					poll_cnt++;
+				}
+				pi->port.icount.rx += bytes_in;
+			}
+			rxre->bytecnt = cpu_to_be16(0);
+			wmb();
+			rxre->cmdstat = cpu_to_be32(SDMA_DESC_CMDSTAT_O |
+						    SDMA_DESC_CMDSTAT_EI |
+						    SDMA_DESC_CMDSTAT_F |
+						    SDMA_DESC_CMDSTAT_L);
+			wmb();
+			dma_cache_sync(pi->port.dev, (void *)rxre,
+				       MPSC_RXRE_SIZE, DMA_BIDIRECTIONAL);
+#if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
+			if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
+				flush_dcache_range((ulong)rxre,
+					   (ulong)rxre + MPSC_RXRE_SIZE);
+#endif
+
+			/* Advance to next descriptor */
+			pi->rxr_posn = (pi->rxr_posn + 1) &
+				(MPSC_RXR_ENTRIES - 1);
+			rxre = (struct mpsc_rx_desc *)(pi->rxr +
+				       (pi->rxr_posn * MPSC_RXRE_SIZE));
+			dma_cache_sync(pi->port.dev, (void *)rxre,
+				       MPSC_RXRE_SIZE, DMA_FROM_DEVICE);
+#if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
+			if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
+				invalidate_dcache_range((ulong)rxre,
+						(ulong)rxre + MPSC_RXRE_SIZE);
+#endif
+		}
+
+		/* Restart rx engine, if its stopped */
+		if ((readl(pi->sdma_base + SDMA_SDCM) & SDMA_SDCM_ERD) == 0)
+			mpsc_start_rx(pi);
+	}
+	if (poll_cnt) {
+		poll_cnt--;
+		return poll_buf[poll_ptr++];
+	}
+
+	return 0;
+}
+
+
+static void mpsc_put_poll_char(struct uart_port *port,
+			 unsigned char c)
+{
+	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	u32 data;
+
+	data = readl(pi->mpsc_base + MPSC_MPCR);
+	writeb(c, pi->mpsc_base + MPSC_CHR_1);
+	mb();
+	data = readl(pi->mpsc_base + MPSC_CHR_2);
+	data |= MPSC_CHR_2_TTCS;
+	writel(data, pi->mpsc_base + MPSC_CHR_2);
+	mb();
+
+	while (readl(pi->mpsc_base + MPSC_CHR_2) & MPSC_CHR_2_TTCS);
+}
+#endif
 
 static struct uart_ops mpsc_pops = {
 	.tx_empty	= mpsc_tx_empty,
@@ -1537,6 +1679,10 @@ static struct uart_ops mpsc_pops = {
 	.request_port	= mpsc_request_port,
 	.config_port	= mpsc_config_port,
 	.verify_port	= mpsc_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = mpsc_get_poll_char,
+	.poll_put_char = mpsc_put_poll_char,
+#endif
 };
 
 /*
-- 
1.5.5.1

