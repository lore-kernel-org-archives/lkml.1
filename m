Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYGHRlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYGHRlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYGHRlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:41:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:27851 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbYGHRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=MM+2hiEXz4EvTMx6NZDcI9teE0NvcVeV4Bl9o+z4v/UCV0XhatwKoHRtHFYnNi9jhk
         QtodULf91egOX4Avr58pi9cGhRmzhcMj2l263eqLMKvX5mUPzSZ8luz7dR0jV7r7i/xu
         Ghl0HTzyJ4vl+mx40lg6+/yn8eD/Oj2KM+5fc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 8 Jul 2008 19:38:17 +0200
Message-Id: <200807081938.17334.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Regression fix, palm_bk3710 bugfix from Sergei and an obvious it8213 fixup.

Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/arm/palm_bk3710.c |   38 ++++++++++++++++++--------------------
 drivers/ide/ide-probe.c       |    8 ++------
 drivers/ide/pci/it8213.c      |    3 +--
 drivers/ide/pci/ns87415.c     |    6 +-----
 include/linux/ide.h           |   15 +++++++++++++++
 5 files changed, 37 insertions(+), 33 deletions(-)


Bartlomiej Zolnierkiewicz (2):
      ide: add __ide_default_irq() inline helper
      it8213: fix return value in it8213_init_one()

Sergei Shtylyov (1):
      palm_bk3710: fix IDECLK period calculation


diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index cc24803..2f2b4f4 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -76,7 +76,7 @@ struct palm_bk3710_udmatiming {
 
 #include "../ide-timing.h"
 
-static long ide_palm_clk;
+static unsigned ideclk_period; /* in nanoseconds */
 
 static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
 	{160, 240},		/* UDMA Mode 0 */
@@ -86,8 +86,6 @@ static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
 	{85,  60},		/* UDMA Mode 4 */
 };
 
-static struct clk *ideclkp;
-
 static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
 				    unsigned int mode)
 {
@@ -97,10 +95,10 @@ static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
 
 	/* DMA Data Setup */
 	t0 = DIV_ROUND_UP(palm_bk3710_udmatimings[mode].cycletime,
-			  ide_palm_clk) - 1;
-	tenv = DIV_ROUND_UP(20, ide_palm_clk) - 1;
+			  ideclk_period) - 1;
+	tenv = DIV_ROUND_UP(20, ideclk_period) - 1;
 	trp = DIV_ROUND_UP(palm_bk3710_udmatimings[mode].rptime,
-			   ide_palm_clk) - 1;
+			   ideclk_period) - 1;
 
 	/* udmatim Register */
 	val16 = readw(base + BK3710_UDMATIM) & (dev ? 0xFF0F : 0xFFF0);
@@ -141,8 +139,8 @@ static void palm_bk3710_setdmamode(void __iomem *base, unsigned int dev,
 	cycletime = max_t(int, t->cycle, min_cycle);
 
 	/* DMA Data Setup */
-	t0 = DIV_ROUND_UP(cycletime, ide_palm_clk);
-	td = DIV_ROUND_UP(t->active, ide_palm_clk);
+	t0 = DIV_ROUND_UP(cycletime, ideclk_period);
+	td = DIV_ROUND_UP(t->active, ideclk_period);
 	tkw = t0 - td - 1;
 	td -= 1;
 
@@ -168,9 +166,9 @@ static void palm_bk3710_setpiomode(void __iomem *base, ide_drive_t *mate,
 	struct ide_timing *t;
 
 	/* PIO Data Setup */
-	t0 = DIV_ROUND_UP(cycletime, ide_palm_clk);
+	t0 = DIV_ROUND_UP(cycletime, ideclk_period);
 	t2 = DIV_ROUND_UP(ide_timing_find_mode(XFER_PIO_0 + mode)->active,
-			  ide_palm_clk);
+			  ideclk_period);
 
 	t2i = t0 - t2 - 1;
 	t2 -= 1;
@@ -192,8 +190,8 @@ static void palm_bk3710_setpiomode(void __iomem *base, ide_drive_t *mate,
 
 	/* TASKFILE Setup */
 	t = ide_timing_find_mode(XFER_PIO_0 + mode);
-	t0 = DIV_ROUND_UP(t->cyc8b, ide_palm_clk);
-	t2 = DIV_ROUND_UP(t->act8b, ide_palm_clk);
+	t0 = DIV_ROUND_UP(t->cyc8b, ideclk_period);
+	t2 = DIV_ROUND_UP(t->act8b, ideclk_period);
 
 	t2i = t0 - t2 - 1;
 	t2 -= 1;
@@ -350,22 +348,22 @@ static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
 
 static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 {
-	struct clk *clkp;
+	struct clk *clk;
 	struct resource *mem, *irq;
 	ide_hwif_t *hwif;
-	unsigned long base;
+	unsigned long base, rate;
 	int i;
 	hw_regs_t hw;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
-	clkp = clk_get(NULL, "IDECLK");
-	if (IS_ERR(clkp))
+	clk = clk_get(NULL, "IDECLK");
+	if (IS_ERR(clk))
 		return -ENODEV;
 
-	ideclkp = clkp;
-	clk_enable(ideclkp);
-	ide_palm_clk = clk_get_rate(ideclkp)/100000;
-	ide_palm_clk = (10000/ide_palm_clk) + 1;
+	clk_enable(clk);
+	rate = clk_get_rate(clk);
+	ideclk_period = 1000000000UL / rate;
+
 	/* Register the IDE interface with Linux ATA Interface */
 	memset(&hw, 0, sizeof(hw));
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index d27061b..26e68b6 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1218,16 +1218,12 @@ static void drive_release_dev (struct device *dev)
 	complete(&drive->gendev_rel_comp);
 }
 
-#ifndef ide_default_irq
-#define ide_default_irq(irq) 0
-#endif
-
 static int hwif_init(ide_hwif_t *hwif)
 {
 	int old_irq;
 
 	if (!hwif->irq) {
-		hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 		if (!hwif->irq) {
 			printk("%s: DISABLED, NO IRQ\n", hwif->name);
 			return 0;
@@ -1257,7 +1253,7 @@ static int hwif_init(ide_hwif_t *hwif)
 	 *	It failed to initialise. Find the default IRQ for 
 	 *	this port and try that.
 	 */
-	hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+	hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 	if (!hwif->irq) {
 		printk("%s: Disabled unable to get IRQ %d.\n",
 			hwif->name, old_irq);
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 9053c87..2b71bdf 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -184,8 +184,7 @@ static const struct ide_port_info it8213_chipsets[] __devinitdata = {
 
 static int __devinit it8213_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_setup_pci_device(dev, &it8213_chipsets[id->driver_data]);
-	return 0;
+	return ide_setup_pci_device(dev, &it8213_chipsets[id->driver_data]);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index fec4955..a7a41bb 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -225,10 +225,6 @@ static int ns87415_dma_setup(ide_drive_t *drive)
 	return 1;
 }
 
-#ifndef ide_default_irq
-#define ide_default_irq(irq) 0
-#endif
-
 static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -288,7 +284,7 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 	}
 
 	if (!using_inta)
-		hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 	else if (!hwif->irq && hwif->mate && hwif->mate->irq)
 		hwif->irq = hwif->mate->irq;	/* share IRQ with mate */
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9918772..eddb6da 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -189,6 +189,21 @@ static inline void ide_std_init_ports(hw_regs_t *hw,
 	hw->io_ports.ctl_addr = ctl_addr;
 }
 
+/* for IDE PCI controllers in legacy mode, temporary */
+static inline int __ide_default_irq(unsigned long base)
+{
+	switch (base) {
+#ifdef CONFIG_IA64
+	case 0x1f0: return isa_irq_to_vector(14);
+	case 0x170: return isa_irq_to_vector(15);
+#else
+	case 0x1f0: return 14;
+	case 0x170: return 15;
+#endif
+	}
+	return 0;
+}
+
 #include <asm/ide.h>
 
 #if !defined(MAX_HWIFS) || defined(CONFIG_EMBEDDED)
