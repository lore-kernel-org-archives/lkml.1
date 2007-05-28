Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbXE1KZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbXE1KZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXE1KZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:25:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35065 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbXE1KZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:25:28 -0400
Date: Mon, 28 May 2007 06:25:26 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Convert sata_sx4 to new libata EH
Message-ID: <20070528102526.GA16707@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Yet another of the completely-untested conversions to new libata
EH, this time for sata_sx4.  The handling of the ATA ports
freeze/thaw/error_handler is the same as sata_promise, save for a
few constants.  The big question is HDMA EH, which is explained in
both the Theory of operation section added at the beginning, and in
the FIXME comments in the EH code.

Like the others, this is stored on the 'new-eh' branch of
libata-dev.git.

 drivers/ata/sata_sx4.c |  262 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 174 insertions(+), 88 deletions(-)

diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 2d14f3d..a2c3352 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -30,6 +30,54 @@
  *
  */
 
+/*
+	Theory of operation
+	-------------------
+
+	The SX4 (PDC20621) chip features a single Host DMA (HDMA) copy
+	engine, DIMM memory, and four ATA engines (one per SATA port).
+	Data is copied to/from DIMM memory by the HDMA engine, before
+	handing off to one (or more) of the ATA engines.  The ATA
+	engines operate solely on DIMM memory.
+
+	The SX4 behaves like a PATA chip, with no SATA controls or
+	knowledge whatsoever, leading to the presumption that
+	PATA<->SATA bridges exist on SX4 boards, external to the
+	PDC20621 chip itself.
+
+	The chip is quite capable, supporting an XOR engine and linked
+	hardware commands (permits a string to transactions to be
+	submitted and waited-on as a single unit), and an optional
+	microprocessor.
+
+	The limiting factor is largely software.  This Linux driver was
+	written to multiplex the single HDMA engine to copy disk
+	transactions into a fixed DIMM memory space, from where an ATA
+	engine takes over.  As a result, each WRITE looks like this:
+
+		submit HDMA packet to hardware
+		hardware copies data from system memory to DIMM
+		hardware raises interrupt
+
+		submit ATA packet to hardware
+		hardware executes ATA WRITE command, w/ data in DIMM
+		hardware raises interrupt
+	
+	and each READ looks like this:
+
+		submit ATA packet to hardware
+		hardware executes ATA READ command, w/ data in DIMM
+		hardware raises interrupt
+	
+		submit HDMA packet to hardware
+		hardware copies data from DIMM to system memory
+		hardware raises interrupt
+
+	This is a very slow, lock-step way of doing things that can
+	certainly be improved by motivated kernel hackers.
+
+ */
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -58,6 +106,8 @@ enum {
 	PDC_INT_SEQMASK		= 0x40,	/* Mask of asserted SEQ INTs */
 	PDC_HDMA_CTLSTAT	= 0x12C, /* Host DMA control / status */
 
+	PDC_CTLSTAT		= 0x60,	/* IDEn control / status */
+
 	PDC_20621_SEQCTL	= 0x400,
 	PDC_20621_SEQMASK	= 0x480,
 	PDC_20621_GENERAL_CTL	= 0x484,
@@ -87,48 +137,60 @@ enum {
 
 	board_20621		= 0,	/* FastTrak S150 SX4 */
 
-	PDC_RESET		= (1 << 11), /* HDMA reset */
+	PDC_MASK_INT		= (1 << 10), /* HDMA/ATA mask int */
+	PDC_RESET		= (1 << 11), /* HDMA/ATA reset */
+	PDC_DMA_ENABLE		= (1 << 7),  /* DMA start/stop */
 
 	PDC_MAX_HDMA		= 32,
 	PDC_HDMA_Q_MASK		= (PDC_MAX_HDMA - 1),
 
-	PDC_DIMM0_SPD_DEV_ADDRESS     = 0x50,
-	PDC_DIMM1_SPD_DEV_ADDRESS     = 0x51,
-	PDC_MAX_DIMM_MODULE           = 0x02,
-	PDC_I2C_CONTROL_OFFSET        = 0x48,
-	PDC_I2C_ADDR_DATA_OFFSET      = 0x4C,
-	PDC_DIMM0_CONTROL_OFFSET      = 0x80,
-	PDC_DIMM1_CONTROL_OFFSET      = 0x84,
-	PDC_SDRAM_CONTROL_OFFSET      = 0x88,
-	PDC_I2C_WRITE                 = 0x00000000,
-	PDC_I2C_READ                  = 0x00000040,
-	PDC_I2C_START                 = 0x00000080,
-	PDC_I2C_MASK_INT              = 0x00000020,
-	PDC_I2C_COMPLETE              = 0x00010000,
-	PDC_I2C_NO_ACK                = 0x00100000,
-	PDC_DIMM_SPD_SUBADDRESS_START = 0x00,
-	PDC_DIMM_SPD_SUBADDRESS_END   = 0x7F,
-	PDC_DIMM_SPD_ROW_NUM          = 3,
-	PDC_DIMM_SPD_COLUMN_NUM       = 4,
-	PDC_DIMM_SPD_MODULE_ROW       = 5,
-	PDC_DIMM_SPD_TYPE             = 11,
-	PDC_DIMM_SPD_FRESH_RATE       = 12,
-	PDC_DIMM_SPD_BANK_NUM         = 17,
-	PDC_DIMM_SPD_CAS_LATENCY      = 18,
-	PDC_DIMM_SPD_ATTRIBUTE        = 21,
-	PDC_DIMM_SPD_ROW_PRE_CHARGE   = 27,
-	PDC_DIMM_SPD_ROW_ACTIVE_DELAY = 28,
-	PDC_DIMM_SPD_RAS_CAS_DELAY    = 29,
-	PDC_DIMM_SPD_ACTIVE_PRECHARGE = 30,
-	PDC_DIMM_SPD_SYSTEM_FREQ      = 126,
-	PDC_CTL_STATUS		      = 0x08,
-	PDC_DIMM_WINDOW_CTLR	      = 0x0C,
-	PDC_TIME_CONTROL              = 0x3C,
-	PDC_TIME_PERIOD               = 0x40,
-	PDC_TIME_COUNTER              = 0x44,
-	PDC_GENERAL_CTLR	      = 0x484,
-	PCI_PLL_INIT                  = 0x8A531824,
-	PCI_X_TCOUNT                  = 0xEE1E5CFF
+	PDC_DIMM0_SPD_DEV_ADDRESS	= 0x50,
+	PDC_DIMM1_SPD_DEV_ADDRESS	= 0x51,
+	PDC_I2C_CONTROL			= 0x48,
+	PDC_I2C_ADDR_DATA		= 0x4C,
+	PDC_DIMM0_CONTROL		= 0x80,
+	PDC_DIMM1_CONTROL		= 0x84,
+	PDC_SDRAM_CONTROL		= 0x88,
+	PDC_I2C_WRITE			= 0,		/* master -> slave */
+	PDC_I2C_READ			= (1 << 6),	/* master <- slave */
+	PDC_I2C_START			= (1 << 7),	/* start I2C proto */
+	PDC_I2C_MASK_INT		= (1 << 5),	/* mask I2C interrupt */
+	PDC_I2C_COMPLETE		= (1 << 16),	/* I2C normal compl. */
+	PDC_I2C_NO_ACK			= (1 << 20),	/* slave no-ack addr */
+	PDC_DIMM_SPD_SUBADDRESS_START	= 0x00,
+	PDC_DIMM_SPD_SUBADDRESS_END	= 0x7F,
+	PDC_DIMM_SPD_ROW_NUM		= 3,
+	PDC_DIMM_SPD_COLUMN_NUM		= 4,
+	PDC_DIMM_SPD_MODULE_ROW		= 5,
+	PDC_DIMM_SPD_TYPE		= 11,
+	PDC_DIMM_SPD_FRESH_RATE		= 12,
+	PDC_DIMM_SPD_BANK_NUM		= 17,
+	PDC_DIMM_SPD_CAS_LATENCY	= 18,
+	PDC_DIMM_SPD_ATTRIBUTE		= 21,
+	PDC_DIMM_SPD_ROW_PRE_CHARGE	= 27,
+	PDC_DIMM_SPD_ROW_ACTIVE_DELAY	= 28,
+	PDC_DIMM_SPD_RAS_CAS_DELAY	= 29,
+	PDC_DIMM_SPD_ACTIVE_PRECHARGE	= 30,
+	PDC_DIMM_SPD_SYSTEM_FREQ	= 126,
+	PDC_CTL_STATUS			= 0x08,
+	PDC_DIMM_WINDOW_CTLR		= 0x0C,
+	PDC_TIME_CONTROL		= 0x3C,
+	PDC_TIME_PERIOD			= 0x40,
+	PDC_TIME_COUNTER		= 0x44,
+	PDC_GENERAL_CTLR		= 0x484,
+	PCI_PLL_INIT			= 0x8A531824,
+	PCI_X_TCOUNT			= 0xEE1E5CFF,
+
+	/* PDC_TIME_CONTROL bits */
+	PDC_TIMER_BUZZER		= (1 << 10),
+	PDC_TIMER_MODE_PERIODIC		= 0,		/* bits 9:8 == 00 */
+	PDC_TIMER_MODE_ONCE		= (1 << 8),	/* bits 9:8 == 01 */
+	PDC_TIMER_ENABLE		= (1 << 7),
+	PDC_TIMER_MASK_INT		= (1 << 5),
+	PDC_TIMER_SEQ_MASK		= 0x1f,		/* SEQ ID for timer */
+	PDC_TIMER_DEFAULT		= PDC_TIMER_MODE_ONCE |
+					  PDC_TIMER_ENABLE |
+					  PDC_TIMER_MASK_INT,
 };
 
 
@@ -151,8 +213,9 @@ struct pdc_host_priv {
 
 
 static int pdc_sata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static void pdc_eng_timeout(struct ata_port *ap);
-static void pdc_20621_phy_reset (struct ata_port *ap);
+static void pdc_error_handler(struct ata_port *ap);
+static void pdc_freeze(struct ata_port *ap);
+static void pdc_thaw(struct ata_port *ap);
 static int pdc_port_start(struct ata_port *ap);
 static void pdc20621_qc_prep(struct ata_queued_cmd *qc);
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
@@ -198,11 +261,12 @@ static const struct ata_port_operations pdc_20621_ops = {
 	.check_status		= ata_check_status,
 	.exec_command		= pdc_exec_command_mmio,
 	.dev_select		= ata_std_dev_select,
-	.phy_reset		= pdc_20621_phy_reset,
 	.qc_prep		= pdc20621_qc_prep,
 	.qc_issue		= pdc20621_qc_issue_prot,
 	.data_xfer		= ata_data_xfer,
-	.eng_timeout		= pdc_eng_timeout,
+	.freeze			= pdc_freeze,
+	.thaw			= pdc_thaw,
+	.error_handler		= pdc_error_handler,
 	.irq_clear		= pdc20621_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
@@ -260,14 +324,6 @@ static int pdc_port_start(struct ata_port *ap)
 	return 0;
 }
 
-static void pdc_20621_phy_reset (struct ata_port *ap)
-{
-	VPRINTK("ENTER\n");
-        ap->cbl = ATA_CBL_SATA;
-        ata_port_probe(ap);
-        ata_bus_reset(ap);
-}
-
 static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
 				    	   unsigned int portno,
 					   unsigned int total_len)
@@ -808,40 +864,70 @@ static irqreturn_t pdc20621_interrupt (int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static void pdc_eng_timeout(struct ata_port *ap)
+static void pdc_freeze(struct ata_port *ap)
 {
-	u8 drv_stat;
-	struct ata_host *host = ap->host;
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
+	void __iomem *mmio = ap->ioaddr.cmd_addr;
+	u32 tmp;
 
-	DPRINTK("ENTER\n");
+	/* FIXME: this should handle HDMA copy engine freezing */
 
-	spin_lock_irqsave(&host->lock, flags);
+	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp |= PDC_MASK_INT;
+	tmp &= ~PDC_DMA_ENABLE;
+	writel(tmp, mmio + PDC_CTLSTAT);
+	readl(mmio + PDC_CTLSTAT); /* flush */
+}
 
-	qc = ata_qc_from_tag(ap, ap->active_tag);
+static void pdc_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.cmd_addr;
+	void __iomem *mmio_base;
+	u32 tmp;
 
-	switch (qc->tf.protocol) {
-	case ATA_PROT_DMA:
-	case ATA_PROT_NODATA:
-		ata_port_printk(ap, KERN_ERR, "command timeout\n");
-		qc->err_mask |= __ac_err_mask(ata_wait_idle(ap));
-		break;
+	/* FIXME: this should handle HDMA copy engine thawing */
 
-	default:
-		drv_stat = ata_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
+	/* reading SEQ mask register clears IRQ */
+	mmio_base = ap->host->iomap[PDC_MMIO_BAR] + PDC_CHIP0_OFS;
+	readl(mmio_base + PDC_20621_SEQMASK);
 
-		ata_port_printk(ap, KERN_ERR,
-				"unknown timeout, cmd 0x%x stat 0x%x\n",
-				qc->tf.command, drv_stat);
+	/* turn IRQ back on */
+	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp &= ~PDC_MASK_INT;
+	writel(tmp, mmio + PDC_CTLSTAT);
+	readl(mmio + PDC_CTLSTAT); /* flush */
+}
 
-		qc->err_mask |= ac_err_mask(drv_stat);
-		break;
+static void pdc_reset_port(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.cmd_addr + PDC_CTLSTAT;
+	unsigned int i;
+	u32 tmp;
+
+	/* FIXME: handle HDMA copy engine */
+
+	for (i = 11; i > 0; i--) {
+		tmp = readl(mmio);
+		if (tmp & PDC_RESET)
+			break;
+
+		udelay(100);
+
+		tmp |= PDC_RESET;
+		writel(tmp, mmio);
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
-	ata_eh_qc_complete(qc);
-	DPRINTK("EXIT\n");
+	tmp &= ~PDC_RESET;
+	writel(tmp, mmio);
+	readl(mmio);	/* flush */
+}
+
+static void pdc_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN))
+		pdc_reset_port(ap);
+	
+	ata_do_eh(ap, ata_std_prereset, ata_std_softreset, NULL,
+		  ata_std_postreset);
 }
 
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
@@ -999,17 +1085,17 @@ static unsigned int pdc20621_i2c_read(struct ata_host *host, u32 device,
 	i2creg |= subaddr << 16;
 
 	/* Set the device and subaddress */
-	writel(i2creg, mmio + PDC_I2C_ADDR_DATA_OFFSET);
-	readl(mmio + PDC_I2C_ADDR_DATA_OFFSET);
+	writel(i2creg, mmio + PDC_I2C_ADDR_DATA);
+	readl(mmio + PDC_I2C_ADDR_DATA);
 
 	/* Write Control to perform read operation, mask int */
 	writel(PDC_I2C_READ | PDC_I2C_START | PDC_I2C_MASK_INT,
-	       mmio + PDC_I2C_CONTROL_OFFSET);
+	       mmio + PDC_I2C_CONTROL);
 
 	for (count = 0; count <= 1000; count ++) {
-		status = readl(mmio + PDC_I2C_CONTROL_OFFSET);
+		status = readl(mmio + PDC_I2C_CONTROL);
 		if (status & PDC_I2C_COMPLETE) {
-			status = readl(mmio + PDC_I2C_ADDR_DATA_OFFSET);
+			status = readl(mmio + PDC_I2C_ADDR_DATA);
 			break;
 		} else if (count == 1000)
 			return 0;
@@ -1099,8 +1185,8 @@ static int pdc20621_prog_dimm0(struct ata_host *host)
    	data |= (((size / 16) - 1) << 16);
    	data |= (0 << 23);
 	data |= 8;
-   	writel(data, mmio + PDC_DIMM0_CONTROL_OFFSET);
-	readl(mmio + PDC_DIMM0_CONTROL_OFFSET);
+   	writel(data, mmio + PDC_DIMM0_CONTROL);
+	readl(mmio + PDC_DIMM0_CONTROL);
    	return size;
 }
 
@@ -1122,27 +1208,27 @@ static unsigned int pdc20621_prog_dimm_global(struct ata_host *host)
 	*/
 
 	data = 0x022259F1;
-	writel(data, mmio + PDC_SDRAM_CONTROL_OFFSET);
-	readl(mmio + PDC_SDRAM_CONTROL_OFFSET);
+	writel(data, mmio + PDC_SDRAM_CONTROL);
+	readl(mmio + PDC_SDRAM_CONTROL);
 
 	/* Turn on for ECC */
 	pdc20621_i2c_read(host, PDC_DIMM0_SPD_DEV_ADDRESS,
 			  PDC_DIMM_SPD_TYPE, &spd0);
 	if (spd0 == 0x02) {
 		data |= (0x01 << 16);
-		writel(data, mmio + PDC_SDRAM_CONTROL_OFFSET);
-		readl(mmio + PDC_SDRAM_CONTROL_OFFSET);
+		writel(data, mmio + PDC_SDRAM_CONTROL);
+		readl(mmio + PDC_SDRAM_CONTROL);
 		printk(KERN_ERR "Local DIMM ECC Enabled\n");
    	}
 
    	/* DIMM Initialization Select/Enable (bit 18/19) */
    	data &= (~(1<<18));
    	data |= (1<<19);
-   	writel(data, mmio + PDC_SDRAM_CONTROL_OFFSET);
+   	writel(data, mmio + PDC_SDRAM_CONTROL);
 
    	error = 1;
    	for (i = 1; i <= 10; i++) {   /* polling ~5 secs */
-		data = readl(mmio + PDC_SDRAM_CONTROL_OFFSET);
+		data = readl(mmio + PDC_SDRAM_CONTROL);
 		if (!(data & (1<<19))) {
 	   		error = 0;
 	   		break;
@@ -1176,7 +1262,7 @@ static unsigned int pdc20621_dimm_init(struct ata_host *host)
 	VPRINTK("Time Period Register (0x40): 0x%x\n", time_period);
 
 	/* Enable timer */
-	writel(0x00001a0, mmio + PDC_TIME_CONTROL);
+	writel(PDC_TIMER_DEFAULT, mmio + PDC_TIME_CONTROL);
 	readl(mmio + PDC_TIME_CONTROL);
 
 	/* Wait 3 seconds */
