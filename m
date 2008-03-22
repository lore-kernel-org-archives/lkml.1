Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYCVQJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYCVQJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYCVQJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:09:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:40572 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYCVQJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nux5p1UQl0C2D6Kz9GlCewqZQ83g2/UlKKBM+72nDViBYiA772NC4T69LoThaR5PRo+KcdXMVnySW81J7QH/fvxlm2p9VLQxSbopmNEYblSg4cmjViUXxc50zdrNtCJryBmRiNGppVqWekEE51fsIom70K3mvTZYK0HTg2PBHRM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: add "vlb|pci_clock=" parameter
Date: Sat, 22 Mar 2008 17:22:11 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221722.11689.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add "vlb_clock=" parameter for specifying VLB clock frequency (in MHz).

* Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).

While at it:

* qd65xx.c: rename {active,recovery}_cycle variables to {act,rec}_cyc.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c            |   12 ++++++++++++
 drivers/ide/legacy/ali14xx.c |    2 +-
 drivers/ide/legacy/ht6560b.c |    4 ++--
 drivers/ide/legacy/qd65xx.c  |   24 ++++++++++++++----------
 drivers/ide/pci/aec62xx.c    |    2 +-
 drivers/ide/pci/alim15x3.c   |    2 +-
 drivers/ide/pci/amd74xx.c    |    2 +-
 drivers/ide/pci/cmd640.c     |    9 ++++++++-
 drivers/ide/pci/cmd64x.c     |    6 +++---
 drivers/ide/pci/cy82c693.c   |    2 +-
 drivers/ide/pci/opti621.c    |    2 +-
 drivers/ide/pci/via82cxxx.c  |    2 +-
 include/linux/ide.h          |    3 +++
 13 files changed, 49 insertions(+), 23 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1116,6 +1116,18 @@ static void ide_port_class_release(struc
 	put_device(&hwif->gendev);
 }
 
+int ide_vlb_clk;
+EXPORT_SYMBOL_GPL(ide_vlb_clk);
+
+module_param_named(vlb_clock, ide_vlb_clk, int, 0);
+MODULE_PARM_DESC(vlb_clock, "VLB clock frequency (in MHz)");
+
+int ide_pci_clk;
+EXPORT_SYMBOL_GPL(ide_pci_clk);
+
+module_param_named(pci_clock, ide_pci_clk, int, 0);
+MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
+
 static unsigned int ide_ignore_cable;
 
 static int ide_set_ignore_cable(const char *s, struct kernel_param *kp)
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -116,7 +116,7 @@ static void ali14xx_set_pio_mode(ide_dri
 	int time1, time2;
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
-	int bus_speed = system_bus_clock();
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
 
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -212,8 +212,8 @@ static u8 ht_pio2timings(ide_drive_t *dr
 {
 	int active_time, recovery_time;
 	int active_cycles, recovery_cycles;
-	int bus_speed = system_bus_clock();
-	
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+
         if (pio) {
 		unsigned int cycle_time;
 
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -114,17 +114,18 @@ static void qd65xx_select(ide_drive_t *d
 
 static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery_time)
 {
-	u8 active_cycle,recovery_cycle;
+	int clk = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	u8 act_cyc, rec_cyc;
 
-	if (system_bus_clock()<=33) {
-		active_cycle =   9  - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 2, 9);
-		recovery_cycle = 15 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 0, 15);
+	if (clk <= 33) {
+		act_cyc =  9 - IDE_IN(active_time   * clk / 1000 + 1, 2,  9);
+		rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 0, 15);
 	} else {
-		active_cycle =   8  - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 1, 8);
-		recovery_cycle = 18 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 3, 18);
+		act_cyc =  8 - IDE_IN(active_time   * clk / 1000 + 1, 1,  8);
+		rec_cyc = 18 - IDE_IN(recovery_time * clk / 1000 + 1, 3, 18);
 	}
 
-	return((recovery_cycle<<4) | 0x08 | active_cycle);
+	return (rec_cyc << 4) | 0x08 | act_cyc;
 }
 
 /*
@@ -135,10 +136,13 @@ static u8 qd6500_compute_timing (ide_hwi
 
 static u8 qd6580_compute_timing (int active_time, int recovery_time)
 {
-	u8 active_cycle   = 17 - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 2, 17);
-	u8 recovery_cycle = 15 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 2, 15);
+	int clk = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	u8 act_cyc, rec_cyc;
 
-	return((recovery_cycle<<4) | active_cycle);
+	act_cyc = 17 - IDE_IN(active_time   * clk / 1000 + 1, 2, 17);
+	rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 2, 15);
+
+	return (rec_cyc << 4) | act_cyc;
 }
 
 /*
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -140,7 +140,7 @@ static void aec_set_pio_mode(ide_drive_t
 
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
 {
-	int bus_speed = system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
 
 	if (bus_speed <= 33)
 		pci_set_drvdata(dev, (void *) aec6xxx_33_base);
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -294,7 +294,7 @@ static void ali_set_pio_mode(ide_drive_t
 	int s_time, a_time, c_time;
 	u8 s_clc, a_clc, r_clc;
 	unsigned long flags;
-	int bus_speed = system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
 	int port = hwif->channel ? 0x5c : 0x58;
 	int portFIFO = hwif->channel ? 0x55 : 0x54;
 	u8 cd_dma_fifo = 0;
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -179,7 +179,7 @@ static unsigned int __devinit init_chips
  * Determine the system bus clock.
  */
 
-	amd_clock = system_bus_clock() * 1000;
+	amd_clock = (ide_pci_clk ? ide_pci_clk : system_bus_clock()) * 1000;
 
 	switch (amd_clock) {
 		case 33000: amd_clock = 33333; break;
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -552,7 +552,14 @@ static void cmd640_set_mode(ide_drive_t 
 {
 	int setup_time, active_time, recovery_time, clock_time;
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
-	int bus_speed = system_bus_clock();
+	int bus_speed;
+
+	if (cmd640_vlb && ide_vlb_clk)
+		bus_speed = ide_vlb_clk;
+	else if (!cmd640_vlb && ide_pci_clk)
+		bus_speed = ide_pci_clk;
+	else
+		bus_speed = system_bus_clock();
 
 	if (pio_mode > 5)
 		pio_mode = 5;
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -68,8 +68,8 @@ static u8 quantize_timing(int timing, in
  */
 static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_time)
 {
-	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
-	int clock_time		= 1000 / system_bus_clock();
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
+	int clock_time = 1000 / (ide_pci_clk ? ide_pci_clk : system_bus_clock());
 	u8  cycle_count, active_count, recovery_count, drwtim;
 	static const u8 recovery_values[] =
 		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
@@ -128,7 +128,7 @@ static void cmd64x_tune_pio(ide_drive_t 
 			    ide_pio_timings[pio].active_time);
 
 	setup_count = quantize_timing(ide_pio_timings[pio].setup_time,
-				      1000 / system_bus_clock());
+			1000 / (ide_pci_clk ? ide_pci_clk : system_bus_clock()));
 
 	/*
 	 * The primary channel has individual address setup timing registers
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -136,7 +136,7 @@ static int calc_clk(int time, int bus_sp
 static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 {
 	int clk1, clk2;
-	int bus_speed = system_bus_clock();	/* get speed of PCI bus */
+	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
 
 	/* we don't check against CY82C693's min and max speed,
 	 * so you can play with the idebus=xx parameter
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -210,7 +210,7 @@ static void compute_clocks(int pio, pio_
 {
 	if (pio != PIO_NOT_EXIST) {
 		int adr_setup, data_pls;
-		int bus_speed = system_bus_clock();
+		int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
 
 		adr_setup = ide_pio_timings[pio].setup_time;
 		data_pls = ide_pio_timings[pio].active_time;
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -340,7 +340,7 @@ static unsigned int __devinit init_chips
 	 * Determine system bus clock.
 	 */
 
-	via_clock = system_bus_clock() * 1000;
+	via_clock = (ide_pci_clk ? ide_pci_clk : system_bus_clock()) * 1000;
 
 	switch (via_clock) {
 		case 33000: via_clock = 33333; break;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -802,6 +802,9 @@ extern	ide_hwif_t	ide_hwifs[];		/* maste
 #endif
 extern int noautodma;
 
+extern int ide_vlb_clk;
+extern int ide_pci_clk;
+
 ide_hwif_t *ide_find_port_slot(const struct ide_port_info *);
 
 static inline ide_hwif_t *ide_find_port(void)
