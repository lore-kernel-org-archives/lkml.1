Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbYCVQKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbYCVQKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYCVQJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:09:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:42167 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYCVQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JkhKmEnP/EAxYRkcDUOKUdfjhggeM+KqJ11s3g2aCALrdmj85BUMty9Rd2NQn+okckpItwcUQn2xbJ2Hmr/H+Vh8U0GvDy0RxessCSTRJiIFsJxCO6V9xSJYcEQjZOjEpjMd11r0/8uvqKAFJOMlaOf61wRtmAPpeN9FVJmiE1k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: remove obsoleted "idebus=" kernel parameter
Date: Sat, 22 Mar 2008 17:23:20 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221723.20896.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove obsoleted "idebus=" kernel parameter.

* Remove no longer needed ide_system_bus_speed() and system_bus_clock()
  (together with idebus_parameter and system_bus_speed variables).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c            |   71 -------------------------------------------
 drivers/ide/legacy/ali14xx.c |    2 -
 drivers/ide/legacy/ht6560b.c |    2 -
 drivers/ide/legacy/qd65xx.c  |    4 +-
 drivers/ide/pci/aec62xx.c    |    2 -
 drivers/ide/pci/alim15x3.c   |    2 -
 drivers/ide/pci/amd74xx.c    |    2 -
 drivers/ide/pci/cmd640.c     |    8 +---
 drivers/ide/pci/cmd64x.c     |    4 +-
 drivers/ide/pci/cy82c693.c   |    2 -
 drivers/ide/pci/opti621.c    |    2 -
 drivers/ide/pci/via82cxxx.c  |    2 -
 include/linux/ide.h          |    2 -
 13 files changed, 16 insertions(+), 89 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -86,9 +86,6 @@ static const u8 ide_hwif_to_major[] = { 
 					IDE6_MAJOR, IDE7_MAJOR,
 					IDE8_MAJOR, IDE9_MAJOR };
 
-static int idebus_parameter;	/* holds the "idebus=" parameter */
-static int system_bus_speed;	/* holds what we think is VESA/PCI bus speed */
-
 DEFINE_MUTEX(ide_cfg_mtx);
  __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 
@@ -195,38 +192,6 @@ static void __init init_ide_data (void)
 	}
 }
 
-/**
- *	ide_system_bus_speed	-	guess bus speed
- *
- *	ide_system_bus_speed() returns what we think is the system VESA/PCI
- *	bus speed (in MHz). This is used for calculating interface PIO timings.
- *	The default is 40 for known PCI systems, 50 otherwise.
- *	The "idebus=xx" parameter can be used to override this value.
- *	The actual value to be used is computed/displayed the first time
- *	through. Drivers should only use this as a last resort.
- *
- *	Returns a guessed speed in MHz.
- */
-
-static int ide_system_bus_speed(void)
-{
-#ifdef CONFIG_PCI
-	static struct pci_device_id pci_default[] = {
-		{ PCI_DEVICE(PCI_ANY_ID, PCI_ANY_ID) },
-		{ }
-	};
-#else
-#define pci_default 0
-#endif /* CONFIG_PCI */
-
-	/* user supplied value */
-	if (idebus_parameter)
-		return idebus_parameter;
-
-	/* safe default value for PCI or VESA and PCI*/
-	return pci_dev_present(pci_default) ? 33 : 50;
-}
-
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
@@ -546,20 +511,6 @@ static int set_unmaskirq(ide_drive_t *dr
 	return 0;
 }
 
-/**
- *	system_bus_clock	-	clock guess
- *
- *	External version of the bus clock guess used by very old IDE drivers
- *	for things like VLB timings. Should not be used.
- */
-
-int system_bus_clock (void)
-{
-	return system_bus_speed;
-}
-
-EXPORT_SYMBOL(system_bus_clock);
-
 static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
 	ide_drive_t *drive = dev->driver_data;
@@ -854,7 +805,7 @@ static int __init ide_setup(char *s)
 	if (strncmp(s,"hd",2) == 0 && s[2] == '=')	/* hd= is for hd.c   */
 		return 0;				/* driver and not us */
 
-	if (strncmp(s,"ide",3) && strncmp(s,"idebus",6) && strncmp(s,"hd",2))
+	if (strncmp(s, "ide", 3) && strncmp(s, "hd", 2))
 		return 0;
 
 	printk(KERN_INFO "ide_setup: %s", s);
@@ -957,21 +908,6 @@ static int __init ide_setup(char *s)
 		}
 	}
 
-	if (s[0] != 'i' || s[1] != 'd' || s[2] != 'e')
-		goto bad_option;
-	/*
-	 * Look for bus speed option:  "idebus="
-	 */
-	if (s[3] == 'b' && s[4] == 'u' && s[5] == 's') {
-		if (match_parm(&s[6], NULL, vals, 1) != 1)
-			goto bad_option;
-		if (vals[0] >= 20 && vals[0] <= 66) {
-			idebus_parameter = vals[0];
-		} else
-			printk(" -- BAD BUS SPEED! Expected value from 20 to 66");
-		goto obsolete_option;
-	}
-
 bad_option:
 	printk(" -- BAD OPTION\n");
 	return 1;
@@ -1168,11 +1104,6 @@ static int __init ide_init(void)
 	int ret;
 
 	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver\n");
-	system_bus_speed = ide_system_bus_speed();
-
-	printk(KERN_INFO "ide: Assuming %dMHz system bus speed "
-			 "for PIO modes%s\n", system_bus_speed,
-			idebus_parameter ? "" : "; override with idebus=xx");
 
 	ret = bus_register(&ide_bus_type);
 	if (ret < 0) {
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -116,7 +116,7 @@ static void ali14xx_set_pio_mode(ide_dri
 	int time1, time2;
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
-	int bus_speed = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
 
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -212,7 +212,7 @@ static u8 ht_pio2timings(ide_drive_t *dr
 {
 	int active_time, recovery_time;
 	int active_cycles, recovery_cycles;
-	int bus_speed = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
 
         if (pio) {
 		unsigned int cycle_time;
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -112,7 +112,7 @@ static void qd65xx_select(ide_drive_t *d
 
 static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery_time)
 {
-	int clk = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	int clk = ide_vlb_clk ? ide_vlb_clk : 50;
 	u8 act_cyc, rec_cyc;
 
 	if (clk <= 33) {
@@ -134,7 +134,7 @@ static u8 qd6500_compute_timing (ide_hwi
 
 static u8 qd6580_compute_timing (int active_time, int recovery_time)
 {
-	int clk = ide_vlb_clk ? ide_vlb_clk : system_bus_clock();
+	int clk = ide_vlb_clk ? ide_vlb_clk : 50;
 	u8 act_cyc, rec_cyc;
 
 	act_cyc = 17 - IDE_IN(active_time   * clk / 1000 + 1, 2, 17);
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -140,7 +140,7 @@ static void aec_set_pio_mode(ide_drive_t
 
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
 {
-	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
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
-	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
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
 
-	amd_clock = (ide_pci_clk ? ide_pci_clk : system_bus_clock()) * 1000;
+	amd_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
 
 	switch (amd_clock) {
 		case 33000: amd_clock = 33333; break;
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -554,12 +554,10 @@ static void cmd640_set_mode(ide_drive_t 
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
 	int bus_speed;
 
-	if (cmd640_vlb && ide_vlb_clk)
-		bus_speed = ide_vlb_clk;
-	else if (!cmd640_vlb && ide_pci_clk)
-		bus_speed = ide_pci_clk;
+	if (cmd640_vlb)
+		bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
 	else
-		bus_speed = system_bus_clock();
+		bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
 	if (pio_mode > 5)
 		pio_mode = 5;
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -69,7 +69,7 @@ static u8 quantize_timing(int timing, in
 static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_time)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
-	int clock_time = 1000 / (ide_pci_clk ? ide_pci_clk : system_bus_clock());
+	int clock_time = 1000 / (ide_pci_clk ? ide_pci_clk : 33);
 	u8  cycle_count, active_count, recovery_count, drwtim;
 	static const u8 recovery_values[] =
 		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
@@ -128,7 +128,7 @@ static void cmd64x_tune_pio(ide_drive_t 
 			    ide_pio_timings[pio].active_time);
 
 	setup_count = quantize_timing(ide_pio_timings[pio].setup_time,
-			1000 / (ide_pci_clk ? ide_pci_clk : system_bus_clock()));
+			1000 / (ide_pci_clk ? ide_pci_clk : 33));
 
 	/*
 	 * The primary channel has individual address setup timing registers
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -134,7 +134,7 @@ static int calc_clk(int time, int bus_sp
 static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 {
 	int clk1, clk2;
-	int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
 	/* we don't check against CY82C693's min and max speed,
 	 * so you can play with the idebus=xx parameter
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -209,7 +209,7 @@ static void compute_clocks(int pio, pio_
 {
 	if (pio != PIO_NOT_EXIST) {
 		int adr_setup, data_pls;
-		int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
+		int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
 		adr_setup = ide_pio_timings[pio].setup_time;
 		data_pls = ide_pio_timings[pio].active_time;
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -340,7 +340,7 @@ static unsigned int __devinit init_chips
 	 * Determine system bus clock.
 	 */
 
-	via_clock = (ide_pci_clk ? ide_pci_clk : system_bus_clock()) * 1000;
+	via_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
 
 	switch (via_clock) {
 		case 33000: via_clock = 33333; break;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -978,8 +978,6 @@ int ide_taskfile_ioctl(ide_drive_t *, un
 int ide_cmd_ioctl(ide_drive_t *, unsigned int, unsigned long);
 int ide_task_ioctl(ide_drive_t *, unsigned int, unsigned long);
 
-extern int system_bus_clock(void);
-
 extern int ide_driveid_update(ide_drive_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
 extern u8 eighty_ninty_three (ide_drive_t *);
