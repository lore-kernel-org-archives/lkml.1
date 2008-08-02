Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbYHBRUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbYHBRUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYHBRTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:19:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:8687 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYHBRTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=Ki63/CPZpGMP8/gyfP3czm0SzxIiKUDa2WU6Tn66nlWatnbFhbrnj1su9UpMHfzQDS
         XSvjJwxtfRgmp5JX0n9YmM9ODGem9cYFB1b77qggbzCYaxymS0Jfn5QvVOcx6vF+Yb7Q
         G6jrdaHN6OKsEpeqe9vpYDIyrbHcyybH8msD8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide: add proper PCI PM support
Date: Sat, 2 Aug 2008 19:17:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808021917.04847.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Keep pointer to ->init_chipset method also in
  struct ide_host and set it in ide_host_alloc_all().

* Add ide_pci_suspend() and ide_pci_resume() helpers
  (default ->suspend and ->resume implementations).

* ->init_chipset can no longer be marked __devinit.

* Add proper PCI PM support to IDE PCI host drivers
  (rz1000.c and tc86c001.c are skipped for now since
  they need to be converted from using ->init_hwif
  to use ->init_chipset instead).

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c        |    4 +++-
 drivers/ide/pci/aec62xx.c      |    6 +++++-
 drivers/ide/pci/alim15x3.c     |    6 +++++-
 drivers/ide/pci/amd74xx.c      |   10 +++++++---
 drivers/ide/pci/atiixp.c       |    4 ++++
 drivers/ide/pci/cmd64x.c       |    6 +++++-
 drivers/ide/pci/cs5520.c       |    4 ++++
 drivers/ide/pci/cs5530.c       |    6 +++++-
 drivers/ide/pci/cs5535.c       |   12 ++++++++----
 drivers/ide/pci/cy82c693.c     |    6 +++++-
 drivers/ide/pci/generic.c      |    4 ++++
 drivers/ide/pci/hpt34x.c       |    6 +++++-
 drivers/ide/pci/hpt366.c       |   10 +++++++---
 drivers/ide/pci/it8213.c       |    4 ++++
 drivers/ide/pci/it821x.c       |    8 ++++++--
 drivers/ide/pci/jmicron.c      |    4 ++++
 drivers/ide/pci/ns87415.c      |    4 ++++
 drivers/ide/pci/opti621.c      |    4 ++++
 drivers/ide/pci/pdc202xx_new.c |   12 ++++++++----
 drivers/ide/pci/pdc202xx_old.c |    6 +++++-
 drivers/ide/pci/piix.c         |    6 +++++-
 drivers/ide/pci/serverworks.c  |    6 +++++-
 drivers/ide/pci/siimage.c      |    6 +++++-
 drivers/ide/pci/sis5513.c      |    6 +++++-
 drivers/ide/pci/sl82c105.c     |    6 +++++-
 drivers/ide/pci/slc90e66.c     |    4 ++++
 drivers/ide/pci/triflex.c      |    4 ++++
 drivers/ide/pci/via82cxxx.c    |    8 ++++++--
 drivers/ide/setup-pci.c        |   33 +++++++++++++++++++++++++++++++++
 include/linux/ide.h            |    7 +++++++
 30 files changed, 181 insertions(+), 31 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1586,8 +1586,10 @@ struct ide_host *ide_host_alloc_all(cons
 	if (hws[0])
 		host->dev[0] = hws[0]->dev;
 
-	if (d)
+	if (d) {
+		host->init_chipset = d->init_chipset;
 		host->host_flags = d->host_flags;
+	}
 
 	return host;
 }
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -139,7 +139,7 @@ static void aec_set_pio_mode(ide_drive_t
 	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
-static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev)
+static unsigned int init_chipset_aec62xx(struct pci_dev *dev)
 {
 	/* These are necessary to get AEC6280 Macintosh cards to work */
 	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
@@ -307,6 +307,10 @@ static struct pci_driver driver = {
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
 	.remove		= aec62xx_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init aec62xx_ide_init(void)
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -213,7 +213,7 @@ static int ali15x3_dma_setup(ide_drive_t
  *	appropriate also sets up the 1533 southbridge.
  */
 
-static unsigned int __devinit init_chipset_ali15x3(struct pci_dev *dev)
+static unsigned int init_chipset_ali15x3(struct pci_dev *dev)
 {
 	unsigned long flags;
 	u8 tmpbyte;
@@ -581,6 +581,10 @@ static struct pci_driver driver = {
 	.id_table	= alim15x3_pci_tbl,
 	.probe		= alim15x3_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init ali15x3_ide_init(void)
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -112,13 +112,13 @@ static void amd_set_pio_mode(ide_drive_t
 	amd_set_drive(drive, XFER_PIO_0 + pio);
 }
 
-static void __devinit amd7409_cable_detect(struct pci_dev *dev)
+static void amd7409_cable_detect(struct pci_dev *dev)
 {
 	/* no host side cable detection */
 	amd_80w = 0x03;
 }
 
-static void __devinit amd7411_cable_detect(struct pci_dev *dev)
+static void amd7411_cable_detect(struct pci_dev *dev)
 {
 	int i;
 	u32 u = 0;
@@ -140,7 +140,7 @@ static void __devinit amd7411_cable_dete
  * The initialization callback.  Initialize drive independent registers.
  */
 
-static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev)
+static unsigned int init_chipset_amd74xx(struct pci_dev *dev)
 {
 	u8 t = 0, offset = amd_offset(dev);
 
@@ -324,6 +324,10 @@ static struct pci_driver driver = {
 	.id_table	= amd74xx_pci_tbl,
 	.probe		= amd74xx_probe,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init amd74xx_ide_init(void)
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -187,6 +187,10 @@ static struct pci_driver driver = {
 	.id_table	= atiixp_pci_tbl,
 	.probe		= atiixp_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init atiixp_ide_init(void)
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -331,7 +331,7 @@ static int cmd646_1_dma_end(ide_drive_t 
 	return (dma_stat & 7) != 4;
 }
 
-static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev)
+static unsigned int init_chipset_cmd64x(struct pci_dev *dev)
 {
 	u8 mrdmode = 0;
 
@@ -510,6 +510,10 @@ static struct pci_driver driver = {
 	.id_table	= cmd64x_pci_tbl,
 	.probe		= cmd64x_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init cmd64x_ide_init(void)
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -148,6 +148,10 @@ static struct pci_driver driver = {
 	.name		= "Cyrix_IDE",
 	.id_table	= cs5520_pci_tbl,
 	.probe		= cs5520_init_one,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init cs5520_ide_init(void)
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -134,7 +134,7 @@ static void cs5530_set_dma_mode(ide_driv
  *	Initialize the cs5530 bridge for reliable IDE DMA operation.
  */
 
-static unsigned int __devinit init_chipset_cs5530(struct pci_dev *dev)
+static unsigned int init_chipset_cs5530(struct pci_dev *dev)
 {
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
 
@@ -272,6 +272,10 @@ static struct pci_driver driver = {
 	.id_table	= cs5530_pci_tbl,
 	.probe		= cs5530_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init cs5530_ide_init(void)
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -193,10 +193,14 @@ static const struct pci_device_id cs5535
 MODULE_DEVICE_TABLE(pci, cs5535_pci_tbl);
 
 static struct pci_driver driver = {
-	.name       = "CS5535_IDE",
-	.id_table   = cs5535_pci_tbl,
-	.probe      = cs5535_init_one,
-	.remove     = ide_pci_remove,
+	.name		= "CS5535_IDE",
+	.id_table	= cs5535_pci_tbl,
+	.probe		= cs5535_init_one,
+	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init cs5535_ide_init(void)
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -332,7 +332,7 @@ static void cy82c693_set_pio_mode(ide_dr
 /*
  * this function is called during init and is used to setup the cy82c693 chip
  */
-static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev)
+static unsigned int init_chipset_cy82c693(struct pci_dev *dev)
 {
 	if (PCI_FUNC(dev->devfn) != 1)
 		return 0;
@@ -448,6 +448,10 @@ static struct pci_driver driver = {
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
 	.remove		= cy82c693_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init cy82c693_ide_init(void)
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -171,6 +171,10 @@ static struct pci_driver driver = {
 	.id_table	= generic_pci_tbl,
 	.probe		= generic_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init generic_ide_init(void)
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -78,7 +78,7 @@ static void hpt34x_set_pio_mode(ide_driv
  */
 #define	HPT34X_PCI_INIT_REG		0x80
 
-static unsigned int __devinit init_chipset_hpt34x(struct pci_dev *dev)
+static unsigned int init_chipset_hpt34x(struct pci_dev *dev)
 {
 	int i = 0;
 	unsigned long hpt34xIoBase = pci_resource_start(dev, 4);
@@ -171,6 +171,10 @@ static struct pci_driver driver = {
 	.id_table	= hpt34x_pci_tbl,
 	.probe		= hpt34x_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init hpt34x_ide_init(void)
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -941,7 +941,7 @@ static void hpt3xxn_rw_disk(ide_drive_t 
  *	Perform a calibration cycle on the DPLL.
  *	Returns 1 if this succeeds
  */
-static int __devinit hpt37x_calibrate_dpll(struct pci_dev *dev, u16 f_low, u16 f_high)
+static int hpt37x_calibrate_dpll(struct pci_dev *dev, u16 f_low, u16 f_high)
 {
 	u32 dpll = (f_high << 16) | f_low | 0x100;
 	u8  scr2;
@@ -969,7 +969,7 @@ static int __devinit hpt37x_calibrate_dp
 	return 1;
 }
 
-static void __devinit hpt3xx_disable_fast_irq(struct pci_dev *dev, u8 mcr_addr)
+static void hpt3xx_disable_fast_irq(struct pci_dev *dev, u8 mcr_addr)
 {
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
@@ -999,7 +999,7 @@ static void __devinit hpt3xx_disable_fas
 		pci_write_config_byte(dev, mcr_addr + 1, new_mcr);
 }
 
-static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
+static unsigned int init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
 	struct ide_host *host	= pci_get_drvdata(dev);
@@ -1628,6 +1628,10 @@ static struct pci_driver driver = {
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
 	.remove		= hpt366_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init hpt366_ide_init(void)
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -194,6 +194,10 @@ static struct pci_driver driver = {
 	.id_table	= it8213_pci_tbl,
 	.probe		= it8213_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init it8213_ide_init(void)
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -586,7 +586,7 @@ static void __devinit init_hwif_it821x(i
 	hwif->mwdma_mask = ATA_MWDMA2;
 }
 
-static void __devinit it8212_disable_raid(struct pci_dev *dev)
+static void it8212_disable_raid(struct pci_dev *dev)
 {
 	/* Reset local CPU, and set BIOS not ready */
 	pci_write_config_byte(dev, 0x5E, 0x01);
@@ -603,7 +603,7 @@ static void __devinit it8212_disable_rai
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-static unsigned int __devinit init_chipset_it821x(struct pci_dev *dev)
+static unsigned int init_chipset_it821x(struct pci_dev *dev)
 {
 	u8 conf;
 	static char *mode[2] = { "pass through", "smart" };
@@ -685,6 +685,10 @@ static struct pci_driver driver = {
 	.id_table	= it821x_pci_tbl,
 	.probe		= it821x_init_one,
 	.remove		= it821x_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init it821x_ide_init(void)
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -154,6 +154,10 @@ static struct pci_driver driver = {
 	.id_table	= jmicron_pci_tbl,
 	.probe		= jmicron_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init jmicron_ide_init(void)
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -339,6 +339,10 @@ static struct pci_driver driver = {
 	.id_table	= ns87415_pci_tbl,
 	.probe		= ns87415_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init ns87415_ide_init(void)
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -225,6 +225,10 @@ static struct pci_driver driver = {
 	.id_table	= opti621_pci_tbl,
 	.probe		= opti621_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init opti621_ide_init(void)
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -226,7 +226,7 @@ static void pdcnew_reset(ide_drive_t *dr
  * read_counter - Read the byte count registers
  * @dma_base: for the port address
  */
-static long __devinit read_counter(u32 dma_base)
+static long read_counter(u32 dma_base)
 {
 	u32  pri_dma_base = dma_base, sec_dma_base = dma_base + 0x08;
 	u8   cnt0, cnt1, cnt2, cnt3;
@@ -266,7 +266,7 @@ static long __devinit read_counter(u32 d
  * @dma_base: for the port address
  * E.g. 16949000 on 33 MHz PCI bus, i.e. half of the PCI clock.
  */
-static long __devinit detect_pll_input_clock(unsigned long dma_base)
+static long detect_pll_input_clock(unsigned long dma_base)
 {
 	struct timeval start_time, end_time;
 	long start_count, end_count;
@@ -309,7 +309,7 @@ static long __devinit detect_pll_input_c
 }
 
 #ifdef CONFIG_PPC_PMAC
-static void __devinit apple_kiwi_init(struct pci_dev *pdev)
+static void apple_kiwi_init(struct pci_dev *pdev)
 {
 	struct device_node *np = pci_device_to_OF_node(pdev);
 	u8 conf;
@@ -325,7 +325,7 @@ static void __devinit apple_kiwi_init(st
 }
 #endif /* CONFIG_PPC_PMAC */
 
-static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev)
+static unsigned int init_chipset_pdcnew(struct pci_dev *dev)
 {
 	const char *name = DRV_NAME;
 	unsigned long dma_base = pci_resource_start(dev, 4);
@@ -566,6 +566,10 @@ static struct pci_driver driver = {
 	.id_table	= pdc202new_pci_tbl,
 	.probe		= pdc202new_init_one,
 	.remove		= pdc202new_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init pdc202new_ide_init(void)
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -264,7 +264,7 @@ static void pdc202xx_dma_timeout(ide_dri
 	ide_dma_timeout(drive);
 }
 
-static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev)
+static unsigned int init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
@@ -431,6 +431,10 @@ static struct pci_driver driver = {
 	.id_table	= pdc202xx_pci_tbl,
 	.probe		= pdc202xx_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init pdc202xx_ide_init(void)
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -204,7 +204,7 @@ static void piix_set_dma_mode(ide_drive_
  *	out to be nice and simple.
  */
 
-static unsigned int __devinit init_chipset_ich(struct pci_dev *dev)
+static unsigned int init_chipset_ich(struct pci_dev *dev)
 {
 	u32 extra = 0;
 
@@ -449,6 +449,10 @@ static struct pci_driver driver = {
 	.id_table	= piix_pci_tbl,
 	.probe		= piix_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init piix_ide_init(void)
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -175,7 +175,7 @@ static void svwks_set_dma_mode(ide_drive
 	pci_write_config_byte(dev, 0x54, ultra_enable);
 }
 
-static unsigned int __devinit init_chipset_svwks(struct pci_dev *dev)
+static unsigned int init_chipset_svwks(struct pci_dev *dev)
 {
 	unsigned int reg;
 	u8 btr;
@@ -448,6 +448,10 @@ static struct pci_driver driver = {
 	.id_table	= svwks_pci_tbl,
 	.probe		= svwks_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init svwks_ide_init(void)
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -463,7 +463,7 @@ static void sil_sata_pre_reset(ide_drive
  *	to 133 MHz clocking if the system isn't already set up to do it.
  */
 
-static unsigned int __devinit init_chipset_siimage(struct pci_dev *dev)
+static unsigned int init_chipset_siimage(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	void __iomem *ioaddr = host->host_priv;
@@ -834,6 +834,10 @@ static struct pci_driver driver = {
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
 	.remove		= siimage_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init siimage_ide_init(void)
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -447,7 +447,7 @@ static int __devinit sis_find_family(str
 	return chipset_family;
 }
 
-static unsigned int __devinit init_chipset_sis5513(struct pci_dev *dev)
+static unsigned int init_chipset_sis5513(struct pci_dev *dev)
 {
 	/* Make general config ops here
 	   1/ tell IDE channels to operate in Compatibility mode only
@@ -610,6 +610,10 @@ static struct pci_driver driver = {
 	.id_table	= sis5513_pci_tbl,
 	.probe		= sis5513_init_one,
 	.remove		= sis5513_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init sis5513_ide_init(void)
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -271,7 +271,7 @@ static u8 sl82c105_bridge_revision(struc
  * channel 0 here at least, but channel 1 has to be enabled by
  * firmware or arch code. We still set both to 16 bits mode.
  */
-static unsigned int __devinit init_chipset_sl82c105(struct pci_dev *dev)
+static unsigned int init_chipset_sl82c105(struct pci_dev *dev)
 {
 	u32 val;
 
@@ -350,6 +350,10 @@ static struct pci_driver driver = {
 	.id_table	= sl82c105_pci_tbl,
 	.probe		= sl82c105_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init sl82c105_ide_init(void)
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -159,6 +159,10 @@ static struct pci_driver driver = {
 	.id_table	= slc90e66_pci_tbl,
 	.probe		= slc90e66_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init slc90e66_ide_init(void)
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -119,6 +119,10 @@ static struct pci_driver driver = {
 	.id_table	= triflex_pci_tbl,
 	.probe		= triflex_init_one,
 	.remove		= ide_pci_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init triflex_ide_init(void)
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -215,7 +215,7 @@ static struct via_isa_bridge *via_config
 /*
  * Check and handle 80-wire cable presence
  */
-static void __devinit via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
+static void via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
 {
 	int i;
 
@@ -267,7 +267,7 @@ static void __devinit via_cable_detect(s
  *	and initialize its drive independent registers.
  */
 
-static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev)
+static unsigned int init_chipset_via82cxxx(struct pci_dev *dev)
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
@@ -492,6 +492,10 @@ static struct pci_driver driver = {
 	.id_table 	= via_pci_tbl,
 	.probe 		= via_init_one,
 	.remove		= via_remove,
+#ifdef CONFIG_PM
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+#endif
 };
 
 static int __init via_ide_init(void)
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -659,3 +659,36 @@ void ide_pci_remove(struct pci_dev *dev)
 	pci_disable_device(dev);
 }
 EXPORT_SYMBOL_GPL(ide_pci_remove);
+
+#ifdef CONFIG_PM
+int ide_pci_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	pci_save_state(dev);
+	pci_disable_device(dev);
+	pci_set_power_state(dev, pci_choose_state(dev, state));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_pci_suspend);
+
+int ide_pci_resume(struct pci_dev *dev)
+{
+	struct ide_host *host = pci_get_drvdata(dev);
+	int rc;
+
+	pci_set_power_state(dev, PCI_D0);
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
+
+	pci_restore_state(dev);
+	pci_set_master(dev);
+
+	if (host->init_chipset)
+		host->init_chipset(dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_pci_resume);
+#endif
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -17,6 +17,7 @@
 #include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/completion.h>
+#include <linux/pm.h>
 #ifdef CONFIG_BLK_DEV_IDEACPI
 #include <acpi/acpi.h>
 #endif
@@ -637,6 +638,7 @@ struct ide_host {
 	ide_hwif_t	*ports[MAX_HWIFS];
 	unsigned int	n_ports;
 	struct device	*dev[2];
+	unsigned int	(*init_chipset)(struct pci_dev *);
 	unsigned long	host_flags;
 	void		*host_priv;
 };
@@ -1263,6 +1265,11 @@ int ide_pci_init_two(struct pci_dev *, s
 		     const struct ide_port_info *, void *);
 void ide_pci_remove(struct pci_dev *);
 
+#ifdef CONFIG_PM
+int ide_pci_suspend(struct pci_dev *, pm_message_t);
+int ide_pci_resume(struct pci_dev *);
+#endif
+
 void ide_map_sg(ide_drive_t *, struct request *);
 void ide_init_sg_cmd(ide_drive_t *, struct request *);
 
