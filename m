Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbZHJIvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbZHJIvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZHJIvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:51:31 -0400
Received: from d1.icnet.pl ([212.160.220.21]:52674 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZHJIv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:51:28 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: [RFC][PATCH 1/3] ARM: OMAP: DMA: Add support for DMA channel self linking on OMAP1510
Date: Mon, 10 Aug 2009 10:50:00 +0200
User-Agent: KMail/1.9.10
Cc: Jarkko Nikula <jhnikula@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908101050.02530.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement DMA channel self linking on OMAP1510 using AUTO_INIT and REPEAT
flags of the DMA CCR register.

Created against linux-2.6.31-rc5.

Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

---
Note:
In its current form, enable_lnk() seems not very consistent (ie. result of a
conditional assignment is then overwritten unconditionally). As rather
different from OMAP1510 that I am familiar with, I am not quite sure how
support for other OMAP models should really look like. So I decided to leave
it as is and put my bit in a separate block, adding an additional FIXME
comment.

--- linux-2.6.31-rc5/arch/arm/plat-omap/dma.c.orig	2009-08-07 13:38:02.000000000 +0200
+++ linux-2.6.31-rc5/arch/arm/plat-omap/dma.c	2009-08-10 09:01:41.000000000 +0200
@@ -653,8 +653,21 @@ static inline void enable_lnk(int lch)
 {
 	u32 l;
 
+	if (omap_dma_in_1510_mode()) {
+		/* only self linking is supported */
+		if (dma_chan[lch].next_lch == lch) {
+			/* set AUTO_INIT | REPEAT bits in CCR */
+			l = dma_read(CCR(lch));
+			l |= 3 << 8;
+			dma_write(l, CCR(lch));
+		}
+		return;
+	}
+
 	l = dma_read(CLNK_CTRL(lch));
 
+	/* FIXME:
+	 * this conditional assignment is then overwritten unconditionally */
 	if (cpu_class_is_omap1())
 		l &= ~(1 << 14);
 
@@ -675,13 +688,21 @@ static inline void disable_lnk(int lch)
 {
 	u32 l;
 
-	l = dma_read(CLNK_CTRL(lch));
+	if (omap_dma_in_1510_mode())
+		l = dma_read(CCR(lch));
+	else
+		l = dma_read(CLNK_CTRL(lch));
 
 	/* Disable interrupts */
 	if (cpu_class_is_omap1()) {
 		dma_write(0, CICR(lch));
-		/* Set the STOP_LNK bit */
-		l |= 1 << 14;
+		if (omap_dma_in_1510_mode()) {
+			/* Unset AUTO_INIT & REPEAT bits */
+			l &= ~(3 << 8);
+		} else {
+			/* Set the STOP_LNK bit */
+			l |= 1 << 14;
+		}
 	}
 
 	if (cpu_class_is_omap2()) {
@@ -690,7 +711,10 @@ static inline void disable_lnk(int lch)
 		l &= ~(1 << 15);
 	}
 
-	dma_write(l, CLNK_CTRL(lch));
+	if (omap_dma_in_1510_mode())
+		dma_write(l, CCR(lch));
+	else
+		dma_write(l, CLNK_CTRL(lch));
 	dma_chan[lch].flags &= ~OMAP_DMA_ACTIVE;
 }
 
@@ -928,7 +952,7 @@ void omap_start_dma(int lch)
 {
 	u32 l;
 
-	if (!omap_dma_in_1510_mode() && dma_chan[lch].next_lch != -1) {
+	if (dma_chan[lch].next_lch != -1) {
 		int next_lch, cur_lch;
 		char dma_chan_link_map[OMAP_DMA4_LOGICAL_DMA_CH_COUNT];
 
@@ -979,7 +1003,7 @@ void omap_stop_dma(int lch)
 {
 	u32 l;
 
-	if (!omap_dma_in_1510_mode() && dma_chan[lch].next_lch != -1) {
+	if (dma_chan[lch].next_lch != -1) {
 		int next_lch, cur_lch = lch;
 		char dma_chan_link_map[OMAP_DMA4_LOGICAL_DMA_CH_COUNT];
 
@@ -1130,7 +1154,7 @@ int omap_dma_running(void)
  */
 void omap_dma_link_lch(int lch_head, int lch_queue)
 {
-	if (omap_dma_in_1510_mode()) {
+	if (omap_dma_in_1510_mode() && (lch_head != lch_queue)) {
 		printk(KERN_ERR "DMA linking is not supported in 1510 mode\n");
 		BUG();
 		return;
@@ -1152,7 +1176,7 @@ EXPORT_SYMBOL(omap_dma_link_lch);
  */
 void omap_dma_unlink_lch(int lch_head, int lch_queue)
 {
-	if (omap_dma_in_1510_mode()) {
+	if (omap_dma_in_1510_mode() && (lch_head != lch_queue)) {
 		printk(KERN_ERR "DMA linking is not supported in 1510 mode\n");
 		BUG();
 		return;
@@ -1822,7 +1846,7 @@ static int omap1_dma_handle_ch(int ch)
 	if (unlikely(csr & OMAP_DMA_DROP_IRQ))
 		printk(KERN_WARNING "DMA synchronization event drop occurred "
 		       "with device %d\n", dma_chan[ch].dev_id);
-	if (likely(csr & OMAP_DMA_BLOCK_IRQ))
+	if (likely(csr & OMAP_DMA_BLOCK_IRQ) && (dma_chan[ch].next_lch != ch))
 		dma_chan[ch].flags &= ~OMAP_DMA_ACTIVE;
 	if (likely(dma_chan[ch].callback != NULL))
 		dma_chan[ch].callback(ch, csr, dma_chan[ch].data);
