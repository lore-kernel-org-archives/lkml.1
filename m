Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbZHLKku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbZHLKku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZHLKkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:40:49 -0400
Received: from d1.icnet.pl ([212.160.220.21]:37435 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbZHLKkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:40:47 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jhnikula@gmail.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>
Subject: [RFC][PATCH] ARM: OMAP: McBSP: Use register cache
Date: Wed, 12 Aug 2009 12:39:25 +0200
User-Agent: KMail/1.9.10
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908121239.26346.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the way McBSP registers are updated: use cached values instead of
relying upon those read back from the device.

With this patch, I have finally managed to get rid of all random
playback/recording hangups on my OMAP1510 based Amstrad Delta (buggy?)
hardware. Before that, I could suspect that values read back from McBSP
registers before updating them happened to be errornous.

I think there is one important point that makes this patch worth of applying,
apart from my hardware quality. With the current code, if it ever happens to
any machine, no matter if OMAP1510 or newer, to read incorrect value from a
McBSP register, this wrong value will get written back without any checking.
That can lead to hardware damage if, for example, an input pin is turned into
output as a result.

Created against linux-2.6.31-rc5

Tested on Amstrad Delta

Signed-off-by: Janusz Krzysztofik

---
--- linux-2.6.31-rc5/arch/arm/plat-omap/include/mach/mcbsp.h.orig	2009-08-11 23:43:25.000000000 +0200
+++ linux-2.6.31-rc5/arch/arm/plat-omap/include/mach/mcbsp.h	2009-08-11 23:45:46.000000000 +0200
@@ -377,6 +377,8 @@ struct omap_mcbsp {
 	struct omap_mcbsp_platform_data *pdata;
 	struct clk *iclk;
 	struct clk *fclk;
+
+	struct omap_mcbsp_reg_cfg reg_cache;
 };
 extern struct omap_mcbsp **mcbsp_ptr;
 extern int omap_mcbsp_count;
--- linux-2.6.31-rc5/arch/arm/plat-omap/mcbsp.c.orig	2009-08-11 23:43:25.000000000 +0200
+++ linux-2.6.31-rc5/arch/arm/plat-omap/mcbsp.c	2009-08-11 23:45:35.000000000 +0200
@@ -91,6 +91,7 @@ static void omap_mcbsp_dump_reg(u8 id)
 static irqreturn_t omap_mcbsp_tx_irq_handler(int irq, void *dev_id)
 {
 	struct omap_mcbsp *mcbsp_tx = dev_id;
+	struct omap_mcbsp_reg_cfg *reg_cache = &mcbsp_tx->reg_cache;
 	u16 irqst_spcr2;
 
 	irqst_spcr2 = OMAP_MCBSP_READ(mcbsp_tx->io_base, SPCR2);
@@ -101,7 +102,7 @@ static irqreturn_t omap_mcbsp_tx_irq_han
 			irqst_spcr2);
 		/* Writing zero to XSYNC_ERR clears the IRQ */
 		OMAP_MCBSP_WRITE(mcbsp_tx->io_base, SPCR2,
-			irqst_spcr2 & ~(XSYNC_ERR));
+			reg_cache->spcr2 &= ~(XSYNC_ERR));
 	} else {
 		complete(&mcbsp_tx->tx_irq_completion);
 	}
@@ -112,6 +113,7 @@ static irqreturn_t omap_mcbsp_tx_irq_han
 static irqreturn_t omap_mcbsp_rx_irq_handler(int irq, void *dev_id)
 {
 	struct omap_mcbsp *mcbsp_rx = dev_id;
+	struct omap_mcbsp_reg_cfg *reg_cache = &mcbsp_rx->reg_cache;
 	u16 irqst_spcr1;
 
 	irqst_spcr1 = OMAP_MCBSP_READ(mcbsp_rx->io_base, SPCR1);
@@ -122,7 +124,7 @@ static irqreturn_t omap_mcbsp_rx_irq_han
 			irqst_spcr1);
 		/* Writing zero to RSYNC_ERR clears the IRQ */
 		OMAP_MCBSP_WRITE(mcbsp_rx->io_base, SPCR1,
-			irqst_spcr1 & ~(RSYNC_ERR));
+			reg_cache->spcr1 &= ~(RSYNC_ERR));
 	} else {
 		complete(&mcbsp_rx->tx_irq_completion);
 	}
@@ -167,6 +169,7 @@ static void omap_mcbsp_rx_dma_callback(i
 void omap_mcbsp_config(unsigned int id, const struct omap_mcbsp_reg_cfg *config)
 {
 	struct omap_mcbsp *mcbsp;
+	struct omap_mcbsp_reg_cfg *reg_cache;
 	void __iomem *io_base;
 
 	if (!omap_mcbsp_check_valid_id(id)) {
@@ -174,26 +177,27 @@ void omap_mcbsp_config(unsigned int id, 
 		return;
 	}
 	mcbsp = id_to_mcbsp_ptr(id);
+	reg_cache = &mcbsp->reg_cache;
 
 	io_base = mcbsp->io_base;
 	dev_dbg(mcbsp->dev, "Configuring McBSP%d  phys_base: 0x%08lx\n",
 			mcbsp->id, mcbsp->phys_base);
 
 	/* We write the given config */
-	OMAP_MCBSP_WRITE(io_base, SPCR2, config->spcr2);
-	OMAP_MCBSP_WRITE(io_base, SPCR1, config->spcr1);
-	OMAP_MCBSP_WRITE(io_base, RCR2, config->rcr2);
-	OMAP_MCBSP_WRITE(io_base, RCR1, config->rcr1);
-	OMAP_MCBSP_WRITE(io_base, XCR2, config->xcr2);
-	OMAP_MCBSP_WRITE(io_base, XCR1, config->xcr1);
-	OMAP_MCBSP_WRITE(io_base, SRGR2, config->srgr2);
-	OMAP_MCBSP_WRITE(io_base, SRGR1, config->srgr1);
-	OMAP_MCBSP_WRITE(io_base, MCR2, config->mcr2);
-	OMAP_MCBSP_WRITE(io_base, MCR1, config->mcr1);
-	OMAP_MCBSP_WRITE(io_base, PCR0, config->pcr0);
+	OMAP_MCBSP_WRITE(io_base, SPCR2, reg_cache->spcr2 = config->spcr2);
+	OMAP_MCBSP_WRITE(io_base, SPCR1, reg_cache->spcr1 = config->spcr1);
+	OMAP_MCBSP_WRITE(io_base, RCR2, reg_cache->rcr2 = config->rcr2);
+	OMAP_MCBSP_WRITE(io_base, RCR1, reg_cache->rcr1 = config->rcr1);
+	OMAP_MCBSP_WRITE(io_base, XCR2, reg_cache->xcr2 = config->xcr2);
+	OMAP_MCBSP_WRITE(io_base, XCR1, reg_cache->xcr1 = config->xcr1);
+	OMAP_MCBSP_WRITE(io_base, SRGR2, reg_cache->srgr2 = config->srgr2);
+	OMAP_MCBSP_WRITE(io_base, SRGR1, reg_cache->srgr1 = config->srgr1);
+	OMAP_MCBSP_WRITE(io_base, MCR2, reg_cache->mcr2 = config->mcr2);
+	OMAP_MCBSP_WRITE(io_base, MCR1, reg_cache->mcr1 = config->mcr1);
+	OMAP_MCBSP_WRITE(io_base, PCR0, reg_cache->pcr0 = config->pcr0);
 	if (cpu_is_omap2430() || cpu_is_omap34xx()) {
-		OMAP_MCBSP_WRITE(io_base, XCCR, config->xccr);
-		OMAP_MCBSP_WRITE(io_base, RCCR, config->rccr);
+		OMAP_MCBSP_WRITE(io_base, XCCR, reg_cache->xccr = config->xccr);
+		OMAP_MCBSP_WRITE(io_base, RCCR, reg_cache->rccr = config->rccr);
 	}
 }
 EXPORT_SYMBOL(omap_mcbsp_config);
@@ -232,6 +236,7 @@ EXPORT_SYMBOL(omap_mcbsp_set_io_type);
 int omap_mcbsp_request(unsigned int id)
 {
 	struct omap_mcbsp *mcbsp;
+	struct omap_mcbsp_reg_cfg *reg_cache;
 	int err;
 
 	if (!omap_mcbsp_check_valid_id(id)) {
@@ -239,6 +244,7 @@ int omap_mcbsp_request(unsigned int id)
 		return -ENODEV;
 	}
 	mcbsp = id_to_mcbsp_ptr(id);
+	reg_cache = &mcbsp->reg_cache;
 
 	spin_lock(&mcbsp->lock);
 	if (!mcbsp->free) {
@@ -261,8 +267,8 @@ int omap_mcbsp_request(unsigned int id)
 	 * Make sure that transmitter, receiver and sample-rate generator are
 	 * not running before activating IRQs.
 	 */
-	OMAP_MCBSP_WRITE(mcbsp->io_base, SPCR1, 0);
-	OMAP_MCBSP_WRITE(mcbsp->io_base, SPCR2, 0);
+	OMAP_MCBSP_WRITE(mcbsp->io_base, SPCR1, reg_cache->spcr1 = 0);
+	OMAP_MCBSP_WRITE(mcbsp->io_base, SPCR2, reg_cache->spcr2 = 0);
 
 	if (mcbsp->io_type == OMAP_MCBSP_IRQ_IO) {
 		/* We need to get IRQs here */
@@ -335,42 +341,38 @@ EXPORT_SYMBOL(omap_mcbsp_free);
 void omap_mcbsp_start(unsigned int id, int tx, int rx)
 {
 	struct omap_mcbsp *mcbsp;
+	struct omap_mcbsp_reg_cfg *reg_cache;
 	void __iomem *io_base;
 	int idle;
-	u16 w;
 
 	if (!omap_mcbsp_check_valid_id(id)) {
 		printk(KERN_ERR "%s: Invalid id (%d)\n", __func__, id + 1);
 		return;
 	}
 	mcbsp = id_to_mcbsp_ptr(id);
+	reg_cache = &mcbsp->reg_cache;
 	io_base = mcbsp->io_base;
 
-	mcbsp->rx_word_length = (OMAP_MCBSP_READ(io_base, RCR1) >> 5) & 0x7;
-	mcbsp->tx_word_length = (OMAP_MCBSP_READ(io_base, XCR1) >> 5) & 0x7;
+	mcbsp->rx_word_length = (reg_cache->rcr1 >> 5) & 0x7;
+	mcbsp->tx_word_length = (reg_cache->xcr1 >> 5) & 0x7;
 
-	idle = !((OMAP_MCBSP_READ(io_base, SPCR2) |
-		OMAP_MCBSP_READ(io_base, SPCR1)) & 1);
+	idle = !((reg_cache->spcr2 | reg_cache->spcr1) & 1);
 
 	if (idle) {
 		/* Start the sample generator */
-		w = OMAP_MCBSP_READ(io_base, SPCR2);
-		OMAP_MCBSP_WRITE(io_base, SPCR2, w | (1 << 6));
+		OMAP_MCBSP_WRITE(io_base, SPCR2, reg_cache->spcr2 |= (1 << 6));
 	}
 
 	/* Enable transmitter and receiver */
-	w = OMAP_MCBSP_READ(io_base, SPCR2);
-	OMAP_MCBSP_WRITE(io_base, SPCR2, w | (tx & 1));
+	OMAP_MCBSP_WRITE(io_base, SPCR2, reg_cache->spcr2 |= (tx & 1));
 
-	w = OMAP_MCBSP_READ(io_base, SPCR1);
-	OMAP_MCBSP_WRITE(io_base, SPCR1, w | (rx & 1));
+	OMAP_MCBSP_WRITE(io_base, SPCR1, reg_cache->spcr1 |= (rx & 1));
 
 	udelay(100);
 
 	if (idle) {
 		/* Start frame sync */
-		w = OMAP_MCBSP_READ(io_base, SPCR2);
-		OMAP_MCBSP_WRITE(io_base, SPCR2, w | (1 << 7));
+		OMAP_MCBSP_WRITE(io_base, SPCR2, reg_cache->spcr2 |= (1 << 7));
 	}
 
 	/* Dump McBSP Regs */
@@ -381,9 +383,9 @@ EXPORT_SYMBOL(omap_mcbsp_start);
 void omap_mcbsp_stop(unsigned int id, int tx, int rx)
 {
 	struct omap_mcbsp *mcbsp;
+	struct omap_mcbsp_reg_cfg *reg_cache;
 	void __iomem *io_base;
 	int idle;
-	u16 w;
 
 	if (!omap_mcbsp_check_valid_id(id)) {
 		printk(KERN_ERR "%s: Invalid id (%d)\n", __func__, id + 1);
@@ -391,23 +393,20 @@ void omap_mcbsp_stop(unsigned int id, in
 	}
 
 	mcbsp = id_to_mcbsp_ptr(id);
+	reg_cache = &mcbsp->reg_cache;
 	io_base = mcbsp->io_base;
 
 	/* Reset transmitter */
-	w = OMAP_MCBSP_READ(io_base, SPCR2);
-	OMAP_MCBSP_WRITE(io_base, SPCR2, w & ~(tx & 1));
+	OMAP_MCBSP_WRITE(io_base, SPCR2, reg_cache->spcr2 &= ~(tx & 1));
 
 	/* Reset receiver */
-	w = OMAP_MCBSP_READ(io_base, SPCR1);
-	OMAP_MCBSP_WRITE(io_base, SPCR1, w & ~(rx & 1));
+	OMAP_MCBSP_WRITE(io_base, SPCR1, reg_cache->spcr1 &= ~(rx & 1));
 
-	idle = !((OMAP_MCBSP_READ(io_base, SPCR2) |
-		OMAP_MCBSP_READ(io_base, SPCR1)) & 1);
+	idle = !((reg_cache->spcr2 | reg_cache->spcr1) & 1);
 
 	if (idle) {
 		/* Reset the sample rate generator */
-		w = OMAP_MCBSP_READ(io_base, SPCR2);
-		OMAP_MCBSP_WRITE(io_base, SPCR2, w & ~(1 << 6));
+		OMAP_MCBSP_WRITE(io_base, SPCR2, reg_cache->spcr2 &= ~(1 << 6));
 	}
 }
 EXPORT_SYMBOL(omap_mcbsp_stop);
@@ -557,6 +556,7 @@ EXPORT_SYMBOL(omap_mcbsp_recv_word);
 int omap_mcbsp_spi_master_xmit_word_poll(unsigned int id, u32 word)
 {
 	struct omap_mcbsp *mcbsp;
+	struct omap_mcbsp_reg_cfg *reg_cache;
 	void __iomem *io_base;
 	omap_mcbsp_word_length tx_word_length;
 	omap_mcbsp_word_length rx_word_length;
@@ -567,6 +567,7 @@ int omap_mcbsp_spi_master_xmit_word_poll
 		return -ENODEV;
 	}
 	mcbsp = id_to_mcbsp_ptr(id);
+	reg_cache = &mcbsp->reg_cache;
 	io_base = mcbsp->io_base;
 	tx_word_length = mcbsp->tx_word_length;
 	rx_word_length = mcbsp->rx_word_length;
@@ -580,9 +581,11 @@ int omap_mcbsp_spi_master_xmit_word_poll
 		spcr2 = OMAP_MCBSP_READ(io_base, SPCR2);
 		if (attempts++ > 1000) {
 			/* We must reset the transmitter */
-			OMAP_MCBSP_WRITE(io_base, SPCR2, spcr2 & (~XRST));
+			OMAP_MCBSP_WRITE(io_base, SPCR2,
+					reg_cache->spcr2 &= (~XRST));
 			udelay(10);
-			OMAP_MCBSP_WRITE(io_base, SPCR2, spcr2 | XRST);
+			OMAP_MCBSP_WRITE(io_base, SPCR2,
+					reg_cache->spcr2 |= XRST);
 			udelay(10);
 			dev_err(mcbsp->dev, "McBSP%d transmitter not "
 				"ready\n", mcbsp->id);
@@ -601,9 +604,11 @@ int omap_mcbsp_spi_master_xmit_word_poll
 		spcr1 = OMAP_MCBSP_READ(io_base, SPCR1);
 		if (attempts++ > 1000) {
 			/* We must reset the receiver */
-			OMAP_MCBSP_WRITE(io_base, SPCR1, spcr1 & (~RRST));
+			OMAP_MCBSP_WRITE(io_base, SPCR1,
+					reg_cache->spcr1 &= (~RRST));
 			udelay(10);
-			OMAP_MCBSP_WRITE(io_base, SPCR1, spcr1 | RRST);
+			OMAP_MCBSP_WRITE(io_base, SPCR1,
+					reg_cache->spcr1 |= RRST);
 			udelay(10);
 			dev_err(mcbsp->dev, "McBSP%d receiver not "
 				"ready\n", mcbsp->id);
@@ -623,6 +628,7 @@ EXPORT_SYMBOL(omap_mcbsp_spi_master_xmit
 int omap_mcbsp_spi_master_recv_word_poll(unsigned int id, u32 *word)
 {
 	struct omap_mcbsp *mcbsp;
+	struct omap_mcbsp_reg_cfg *reg_cache;
 	u32 clock_word = 0;
 	void __iomem *io_base;
 	omap_mcbsp_word_length tx_word_length;
@@ -635,6 +641,7 @@ int omap_mcbsp_spi_master_recv_word_poll
 	}
 
 	mcbsp = id_to_mcbsp_ptr(id);
+	reg_cache = &mcbsp->reg_cache;
 	io_base = mcbsp->io_base;
 
 	tx_word_length = mcbsp->tx_word_length;
@@ -649,9 +656,11 @@ int omap_mcbsp_spi_master_recv_word_poll
 		spcr2 = OMAP_MCBSP_READ(io_base, SPCR2);
 		if (attempts++ > 1000) {
 			/* We must reset the transmitter */
-			OMAP_MCBSP_WRITE(io_base, SPCR2, spcr2 & (~XRST));
+			OMAP_MCBSP_WRITE(io_base, SPCR2,
+					reg_cache->spcr2 &= (~XRST));
 			udelay(10);
-			OMAP_MCBSP_WRITE(io_base, SPCR2, spcr2 | XRST);
+			OMAP_MCBSP_WRITE(io_base, SPCR2,
+					reg_cache->spcr2 |= XRST);
 			udelay(10);
 			dev_err(mcbsp->dev, "McBSP%d transmitter not "
 				"ready\n", mcbsp->id);
@@ -670,9 +679,11 @@ int omap_mcbsp_spi_master_recv_word_poll
 		spcr1 = OMAP_MCBSP_READ(io_base, SPCR1);
 		if (attempts++ > 1000) {
 			/* We must reset the receiver */
-			OMAP_MCBSP_WRITE(io_base, SPCR1, spcr1 & (~RRST));
+			OMAP_MCBSP_WRITE(io_base, SPCR1,
+					reg_cache->spcr1 &= (~RRST));
 			udelay(10);
-			OMAP_MCBSP_WRITE(io_base, SPCR1, spcr1 | RRST);
+			OMAP_MCBSP_WRITE(io_base, SPCR1,
+					reg_cache->spcr1 |= RRST);
 			udelay(10);
 			dev_err(mcbsp->dev, "McBSP%d receiver not "
 				"ready\n", mcbsp->id);
