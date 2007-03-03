Return-Path: <linux-kernel-owner+w=401wt.eu-S1030343AbXCCRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030343AbXCCRSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030347AbXCCRSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:18:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:60713 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030326AbXCCRSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:18:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NRWixswdNfnHfRt7GAimim1kkKnwO3JqgMEcM5J/O5g5xyMYH681uivWl/kg8wFn1JcCE8iW4GnitCSKwAbobekDb9nl3L5oEsIleAseNjOV9DBKwG/gqabC/vU5uqmmK8xT4xx0tyrkdVrf64mVbK5AJ1Yan1dqLze+pPrmaS4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates
Date: Sat, 3 Mar 2007 18:25:11 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703031825.11710.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Bunch of fixes all over the map:

* Tejun's fix for incorrect drive side cable detection (before the fix
  UDMA3-6 could be enabled on hosts lacking host side cable detection
  resulting in error recovery code triggering up)

* workaround for older X servers having problems because of incoherency
  in the raw and kernel reported PCI configuration space (Jan Beulich)

* alim15x3/cmd64x/piix/slc90e66 PIO mode setup fixes from Sergei

* the other/misc changes listed below in git-log output
  (thanks to all contributors!)


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/ide.txt         |   29 ++++-------
 drivers/ide/Kconfig           |   10 +--
 drivers/ide/cris/ide-cris.c   |    2 
 drivers/ide/ide-disk.c        |    2 
 drivers/ide/ide-iops.c        |    2 
 drivers/ide/ide-lib.c         |   18 ++-----
 drivers/ide/ide-probe.c       |    2 
 drivers/ide/ide.c             |   39 +++++----------
 drivers/ide/legacy/ali14xx.c  |   11 +++-
 drivers/ide/legacy/dtc2278.c  |   14 +++--
 drivers/ide/legacy/ht6560b.c  |   10 +++
 drivers/ide/legacy/ide-cs.c   |    7 +-
 drivers/ide/legacy/qd65xx.c   |   14 +++--
 drivers/ide/legacy/umc8672.c  |   15 ++++-
 drivers/ide/mips/au1xxx-ide.c |    2 
 drivers/ide/pci/alim15x3.c    |   35 ++++++++++---
 drivers/ide/pci/cmd640.c      |    1 
 drivers/ide/pci/cmd64x.c      |  108 ++++++++++++++++--------------------------
 drivers/ide/pci/delkin_cb.c   |    2 
 drivers/ide/pci/generic.c     |    2 
 drivers/ide/pci/opti621.c     |    3 -
 drivers/ide/pci/piix.c        |   49 +++++++++++--------
 drivers/ide/pci/rz1000.c      |    2 
 drivers/ide/pci/siimage.c     |    5 +
 drivers/ide/pci/slc90e66.c    |   38 +++++++-------
 drivers/ide/ppc/pmac.c        |   33 +++++++++---
 drivers/ide/ppc/scc_pata.c    |   27 ++++++++++
 drivers/pci/probe.c           |   45 ++++++++++++-----
 include/linux/ide.h           |    3 -
 29 files changed, 306 insertions(+), 224 deletions(-)


Akira Iguchi (1):
      scc_pata: bugfix for checking DMA IRQ status

Alan Cox (2):
      siimage: DRAC4 note
      ide: remove a ton of pointless #undef REALLY_SLOW_IO

Andrew Morton (1):
      ide: fix pmac breakage

Bartlomiej Zolnierkiewicz (2):
      ide: remove some obsoleted kernel params (v2)
      ide: make legacy IDE VLB modules check for the "probe" kernel params (v2)

Jan Beulich (1):
      adjust legacy IDE resource setting (v2)

Magnus Damm (1):
      ide-cs: Update device table

Richard Knutsson (1):
      ide/pci/delkin_cb.c: pci_module_init to pci_register_driver

Sergei Shtylyov (4):
      alim15x3: fix PIO mode setup
      cmd64x: fix PIO mode setup (take 3)
      piix/slc90e66: more tuneproc() fixing (take 2)
      ide: ide_get_best_pio_mode() returns incorrect IORDY setting (take 2)

Tejun Heo (1):
      ide: fix drive side 80c cable check, take 2


diff --git a/Documentation/ide.txt b/Documentation/ide.txt
index 786c3a7..3bb9f9c 100644
--- a/Documentation/ide.txt
+++ b/Documentation/ide.txt
@@ -232,7 +232,9 @@ Summary of ide driver parameters for kernel command line
 
  "hdx=remap63"		: remap the drive: add 63 to all sector numbers
 			  (for DM OnTrack)
- 
+
+ "idex=noautotune"	: driver will NOT attempt to tune interface speed
+
  "hdx=autotune"		: driver will attempt to tune interface speed
 			  to the fastest PIO mode supported,
 			  if possible for this drive only.
@@ -267,17 +269,6 @@ Summary of ide driver parameters for kernel command line
  "idex=base,ctl"	: specify both base and ctl
 
  "idex=base,ctl,irq"	: specify base, ctl, and irq number
- 
- "idex=autotune"	: driver will attempt to tune interface speed
-			  to the fastest PIO mode supported,
-			  for all drives on this interface.
-			  Not fully supported by all chipset types,
-			  and quite likely to cause trouble with
-			  older/odd IDE drives.
-
- "idex=noautotune"	: driver will NOT attempt to tune interface speed 
-			  This is the default for most chipsets,
-			  except the cmd640.
 
  "idex=serialize"	: do not overlap operations on idex. Please note
 			  that you will have to specify this option for
@@ -303,13 +294,8 @@ The following are valid ONLY on ide0, which usually corresponds
 to the first ATA interface found on the particular host, and the defaults for
 the base,ctl ports must not be altered.
 
- "ide0=dtc2278"		: probe/support DTC2278 interface
- "ide0=ht6560b"		: probe/support HT6560B interface
  "ide0=cmd640_vlb"	: *REQUIRED* for VLB cards with the CMD640 chip
 			  (not for PCI -- automatically detected)
- "ide0=qd65xx"		: probe/support qd65xx interface
- "ide0=ali14xx"		: probe/support ali14xx chipsets (ALI M1439/M1443/M1445)
- "ide0=umc8672"		: probe/support umc8672 chipsets
 
  "ide=doubler"		: probe/support IDE doublers on Amiga
 
@@ -317,6 +303,15 @@ There may be more options than shown -- use the source, Luke!
 
 Everything else is rejected with a "BAD OPTION" message.
 
+For legacy IDE VLB host drivers (ali14xx/dtc2278/ht6560b/qd65xx/umc8672)
+you need to explicitly enable probing by using "probe" kernel parameter,
+i.e. to enable probing for ALI M14xx chipsets (ali14xx host driver) use:
+
+* "ali14xx.probe" boot option when ali14xx driver is built-in the kernel
+
+* "probe" module parameter when ali14xx driver is compiled as module
+  ("modprobe ali14xx probe")
+
 ================================================================================
 
 IDE ATAPI streaming tape driver
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 49234e3..5d134bb 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1023,7 +1023,7 @@ config BLK_DEV_4DRIVES
 config BLK_DEV_ALI14XX
 	tristate "ALI M14xx support"
 	help
-	  This driver is enabled at runtime using the "ide0=ali14xx" kernel
+	  This driver is enabled at runtime using the "ali14xx.probe" kernel
 	  boot parameter.  It enables support for the secondary IDE interface
 	  of the ALI M1439/1443/1445/1487/1489 chipsets, and permits faster
 	  I/O speeds to be set as well.  See the files
@@ -1033,7 +1033,7 @@ config BLK_DEV_ALI14XX
 config BLK_DEV_DTC2278
 	tristate "DTC-2278 support"
 	help
-	  This driver is enabled at runtime using the "ide0=dtc2278" kernel
+	  This driver is enabled at runtime using the "dtc2278.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the DTC-2278 card, and permits faster I/O speeds to be set as
 	  well. See the <file:Documentation/ide.txt> and
@@ -1042,7 +1042,7 @@ config BLK_DEV_DTC2278
 config BLK_DEV_HT6560B
 	tristate "Holtek HT6560B support"
 	help
-	  This driver is enabled at runtime using the "ide0=ht6560b" kernel
+	  This driver is enabled at runtime using the "ht6560b.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the Holtek card, and permits faster I/O speeds to be set as well.
 	  See the <file:Documentation/ide.txt> and
@@ -1051,7 +1051,7 @@ config BLK_DEV_HT6560B
 config BLK_DEV_QD65XX
 	tristate "QDI QD65xx support"
 	help
-	  This driver is enabled at runtime using the "ide0=qd65xx" kernel
+	  This driver is enabled at runtime using the "qd65xx.probe" kernel
 	  boot parameter.  It permits faster I/O speeds to be set.  See the
 	  <file:Documentation/ide.txt> and <file:drivers/ide/legacy/qd65xx.c> for
 	  more info.
@@ -1059,7 +1059,7 @@ config BLK_DEV_QD65XX
 config BLK_DEV_UMC8672
 	tristate "UMC-8672 support"
 	help
-	  This driver is enabled at runtime using the "ide0=umc8672" kernel
+	  This driver is enabled at runtime using the "umc8672.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the UMC-8672, and permits faster I/O speeds to be set as well.
 	  See the files <file:Documentation/ide.txt> and
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 6b2d152..556455f 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -17,8 +17,6 @@
  * device can't do DMA handshaking for some stupid reason. We don't need to do that.
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/timer.h>
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index e2cea18..37aa6dd 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -43,8 +43,6 @@
 
 #define IDEDISK_VERSION	"1.18"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 //#define DEBUG
 
 #include <linux/module.h>
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index c67b3b1..bd513f5 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -583,6 +583,8 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 	if(!(drive->id->hw_config & 0x4000))
 		return 0;
 #endif /* CONFIG_IDEDMA_IVB */
+	if (!(drive->id->hw_config & 0x2000))
+		return 0;
 	return 1;
 }
 
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 8afce4c..6871931 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -345,16 +345,16 @@ static int ide_scan_pio_blacklist (char *model)
 
 /**
  *	ide_get_best_pio_mode	-	get PIO mode from drive
- *	@driver: drive to consider
+ *	@drive: drive to consider
  *	@mode_wanted: preferred mode
- *	@max_mode: highest allowed
- *	@d: pio data
+ *	@max_mode: highest allowed mode
+ *	@d: PIO data
  *
  *	This routine returns the recommended PIO settings for a given drive,
  *	based on the drive->id information and the ide_pio_blacklist[].
- *	This is used by most chipset support modules when "auto-tuning".
  *
- *	Drive PIO mode auto selection
+ *	Drive PIO mode is auto-selected if 255 is passed as mode_wanted.
+ *	This is used by most chipset support modules when "auto-tuning".
  */
 
 u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode, ide_pio_data_t *d)
@@ -367,6 +367,7 @@ u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode, ide_p
 
 	if (mode_wanted != 255) {
 		pio_mode = mode_wanted;
+		use_iordy = (pio_mode > 2);
 	} else if (!drive->id) {
 		pio_mode = 0;
 	} else if ((pio_mode = ide_scan_pio_blacklist(id->model)) != -1) {
@@ -396,19 +397,12 @@ u8 ide_get_best_pio_mode (ide_drive_t *drive, u8 mode_wanted, u8 max_mode, ide_p
 			}
 		}
 
-#if 0
-		if (drive->id->major_rev_num & 0x0004) printk("ATA-2 ");
-#endif
-
 		/*
 		 * Conservative "downgrade" for all pre-ATA2 drives
 		 */
 		if (pio_mode && pio_mode < 4) {
 			pio_mode--;
 			overridden = 1;
-#if 0
-			use_iordy = (pio_mode > 2);
-#endif
 			if (cycle_time && cycle_time < ide_pio_timings[pio_mode].cycle_time)
 				cycle_time = 0; /* use standard timing */
 		}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 8afbd6c..8f15c23 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -31,8 +31,6 @@
  *			valid after probe time even with noprobe
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index b3c0818..dfbd744 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -126,8 +126,6 @@
 #define	REVISION	"Revision: 7.00alpha2"
 #define	VERSION		"Id: ide.c 7.00a2 20020906"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #define _IDE_C			/* Tell ide.h it's really us */
 
 #include <linux/module.h>
@@ -1486,23 +1484,23 @@ static int __init match_parm (char *s, const char *keywords[], int vals[], int m
 }
 
 #ifdef CONFIG_BLK_DEV_ALI14XX
-static int __initdata probe_ali14xx;
+extern int probe_ali14xx;
 extern int ali14xx_init(void);
 #endif
 #ifdef CONFIG_BLK_DEV_UMC8672
-static int __initdata probe_umc8672;
+extern int probe_umc8672;
 extern int umc8672_init(void);
 #endif
 #ifdef CONFIG_BLK_DEV_DTC2278
-static int __initdata probe_dtc2278;
+extern int probe_dtc2278;
 extern int dtc2278_init(void);
 #endif
 #ifdef CONFIG_BLK_DEV_HT6560B
-static int __initdata probe_ht6560b;
+extern int probe_ht6560b;
 extern int ht6560b_init(void);
 #endif
 #ifdef CONFIG_BLK_DEV_QD65XX
-static int __initdata probe_qd65xx;
+extern int probe_qd65xx;
 extern int qd65xx_init(void);
 #endif
 
@@ -1580,7 +1578,7 @@ static int __init ide_setup(char *s)
 	 */
 	if (s[0] == 'h' && s[1] == 'd' && s[2] >= 'a' && s[2] <= max_drive) {
 		const char *hd_words[] = {
-			"none", "noprobe", "nowerr", "cdrom", "serialize",
+			"none", "noprobe", "nowerr", "cdrom", "minus5",
 			"autotune", "noautotune", "minus8", "swapdata", "bswap",
 			"noflush", "remap", "remap63", "scsi", NULL };
 		unit = s[2] - 'a';
@@ -1608,9 +1606,6 @@ static int __init ide_setup(char *s)
 				drive->ready_stat = 0;
 				hwif->noprobe = 0;
 				goto done;
-			case -5: /* "serialize" */
-				printk(" -- USE \"ide%d=serialize\" INSTEAD", hw);
-				goto do_serialize;
 			case -6: /* "autotune" */
 				drive->autotune = IDE_TUNE_AUTO;
 				goto obsolete_option;
@@ -1671,7 +1666,7 @@ static int __init ide_setup(char *s)
 		 * (-8, -9, -10) are reserved to ease the hardcoding.
 		 */
 		static const char *ide_words[] = {
-			"noprobe", "serialize", "autotune", "noautotune", 
+			"noprobe", "serialize", "minus3", "minus4",
 			"reset", "dma", "ata66", "minus8", "minus9",
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
@@ -1742,12 +1737,17 @@ static int __init ide_setup(char *s)
 				hwif->chipset = mate->chipset = ide_4drives;
 				mate->irq = hwif->irq;
 				memcpy(mate->io_ports, hwif->io_ports, sizeof(hwif->io_ports));
-				goto do_serialize;
+				hwif->mate = mate;
+				mate->mate = hwif;
+				hwif->serialized = mate->serialized = 1;
+				goto obsolete_option;
 			}
 #endif /* CONFIG_BLK_DEV_4DRIVES */
 			case -10: /* minus10 */
 			case -9: /* minus9 */
 			case -8: /* minus8 */
+			case -4:
+			case -3:
 				goto bad_option;
 			case -7: /* ata66 */
 #ifdef CONFIG_BLK_DEV_IDEPCI
@@ -1762,16 +1762,7 @@ static int __init ide_setup(char *s)
 			case -5: /* "reset" */
 				hwif->reset = 1;
 				goto obsolete_option;
-			case -4: /* "noautotune" */
-				hwif->drives[0].autotune = IDE_TUNE_NOAUTO;
-				hwif->drives[1].autotune = IDE_TUNE_NOAUTO;
-				goto obsolete_option;
-			case -3: /* "autotune" */
-				hwif->drives[0].autotune = IDE_TUNE_AUTO;
-				hwif->drives[1].autotune = IDE_TUNE_AUTO;
-				goto obsolete_option;
 			case -2: /* "serialize" */
-			do_serialize:
 				hwif->mate = &ide_hwifs[hw^1];
 				hwif->mate->mate = hwif;
 				hwif->serialized = hwif->mate->serialized = 1;
@@ -1840,8 +1831,8 @@ static void __init probe_for_hwifs (void)
 #endif /* CONFIG_BLK_DEV_CMD640 */
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
 	{
-		extern void pmac_ide_probe(void);
-		pmac_ide_probe();
+		extern int pmac_ide_probe(void);
+		(void)pmac_ide_probe();
 	}
 #endif /* CONFIG_BLK_DEV_IDE_PMAC */
 #ifdef CONFIG_BLK_DEV_GAYLE
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 9c54446..91961aa 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -37,8 +37,6 @@
  * mode 4 for a while now with no trouble.)  -Derek
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -230,9 +228,17 @@ static int __init ali14xx_probe(void)
 	return 0;
 }
 
+int probe_ali14xx = 0;
+
+module_param_named(probe, probe_ali14xx, bool, 0);
+MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
+
 /* Can be called directly from ide.c. */
 int __init ali14xx_init(void)
 {
+	if (probe_ali14xx == 0)
+		goto out;
+
 	/* auto-detect IDE controller port */
 	if (findPort()) {
 		if (ali14xx_probe())
@@ -240,6 +246,7 @@ int __init ali14xx_init(void)
 		return 0;
 	}
 	printk(KERN_ERR "ali14xx: not found.\n");
+out:
 	return -ENODEV;
 }
 
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index 3b1d33b..0219ffa 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -4,8 +4,6 @@
  *  Copyright (C) 1996  Linus Torvalds & author (see below)
  */
 
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -94,7 +92,7 @@ static void tune_dtc2278 (ide_drive_t *drive, u8 pio)
 	HWIF(drive)->drives[!drive->select.b.unit].io_32bit = 1;
 }
 
-static int __init probe_dtc2278(void)
+static int __init dtc2278_probe(void)
 {
 	unsigned long flags;
 	ide_hwif_t *hwif, *mate;
@@ -145,10 +143,18 @@ static int __init probe_dtc2278(void)
 	return 0;
 }
 
+int probe_dtc2278 = 0;
+
+module_param_named(probe, probe_dtc2278, bool, 0);
+MODULE_PARM_DESC(probe, "probe for DTC2278xx chipsets");
+
 /* Can be called directly from ide.c. */
 int __init dtc2278_init(void)
 {
-	if (probe_dtc2278()) {
+	if (probe_dtc2278 == 0)
+		return -ENODEV;
+
+	if (dtc2278_probe()) {
 		printk(KERN_ERR "dtc2278: ide interfaces already in use!\n");
 		return -EBUSY;
 	}
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 19ccd00..a283264 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -36,8 +36,6 @@
 
 #define HT6560B_VERSION "v0.07"
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -303,12 +301,20 @@ static void tune_ht6560b (ide_drive_t *drive, u8 pio)
 #endif
 }
 
+int probe_ht6560b = 0;
+
+module_param_named(probe, probe_ht6560b, bool, 0);
+MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
+
 /* Can be called directly from ide.c. */
 int __init ht6560b_init(void)
 {
 	ide_hwif_t *hwif, *mate;
 	int t;
 
+	if (probe_ht6560b == 0)
+		return -ENODEV;
+
 	hwif = &ide_hwifs[0];
 	mate = &ide_hwifs[1];
 
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index a5023cd..b08c37c 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -359,14 +359,17 @@ void ide_release(struct pcmcia_device *link)
 static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_FUNC_ID(4),
 	PCMCIA_DEVICE_MANF_CARD(0x0007, 0x0000),	/* Hitachi */
+	PCMCIA_DEVICE_MANF_CARD(0x000a, 0x0000),	/* I-O Data CFA */
+	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
-	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),
+	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
 	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
  	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
 	PCMCIA_DEVICE_MANF_CARD(0x2080, 0x0001),
-	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0200),	/* Lexar */
+	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0100),	/* Viking CFA */
+	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0200),	/* Lexar, Viking CFA */
 	PCMCIA_DEVICE_PROD_ID123("Caravelle", "PSC-IDE ", "PSC000", 0x8c36137c, 0xd0693ab8, 0x2768a9f0),
 	PCMCIA_DEVICE_PROD_ID123("CDROM", "IDE", "MCD-601p", 0x1b9179ca, 0xede88951, 0x0d902f74),
 	PCMCIA_DEVICE_PROD_ID123("PCMCIA", "IDE CARD", "F1", 0x281f1c5d, 0x1907960c, 0xf7fde8b9),
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index d3c3bc2..2fb8f50 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -16,8 +16,8 @@
  * Please set local bus speed using kernel parameter idebus
  * 	for example, "idebus=33" stands for 33Mhz VLbus
  * To activate controller support, use "ide0=qd65xx"
- * To enable tuning, use "ide0=autotune"
- * To enable second channel tuning (qd6580 only), use "ide1=autotune"
+ * To enable tuning, use "hda=autotune hdb=autotune"
+ * To enable 2nd channel tuning (qd6580 only), use "hdc=autotune hdd=autotune"
  */
 
 /*
@@ -25,8 +25,6 @@
  * Samuel Thibault <samuel.thibault@fnac.net>
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -490,9 +488,17 @@ static int __init qd_probe(int base)
 	return 1;
 }
 
+int probe_qd65xx = 0;
+
+module_param_named(probe, probe_qd65xx, bool, 0);
+MODULE_PARM_DESC(probe, "probe for QD65xx chipsets");
+
 /* Can be called directly from ide.c. */
 int __init qd65xx_init(void)
 {
+	if (probe_qd65xx == 0)
+		return -ENODEV;
+
 	if (qd_probe(0x30))
 		qd_probe(0xb0);
 	if (ide_hwifs[0].chipset != ide_qd65xx &&
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index 6e2c58c..ca79744 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -165,12 +165,21 @@ static int __init umc8672_probe(void)
 	return 0;
 }
 
+int probe_umc8672 = 0;
+
+module_param_named(probe, probe_umc8672, bool, 0);
+MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
+
 /* Can be called directly from ide.c. */
 int __init umc8672_init(void)
 {
-	if (umc8672_probe())
-		return -ENODEV;
-	return 0;
+	if (probe_umc8672 == 0)
+		goto out;
+
+	if (umc8672_probe() == 0)
+		return 0;;
+out:
+	return -ENODEV;;
 }
 
 #ifdef MODULE
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 0a59d5e..b2dc028 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -29,8 +29,6 @@
  * Note: for more information, please refer "AMD Alchemy Au1200/Au1550 IDE
  *       Interface and Linux Device Driver" Application Note.
  */
-#undef REALLY_SLOW_IO           /* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 4debd18..83e0aa6 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/alim15x3.c		Version 0.17	2003/01/02
+ * linux/drivers/ide/pci/alim15x3.c		Version 0.21	2007/02/03
  *
  *  Copyright (C) 1998-2000 Michel Aubry, Maintainer
  *  Copyright (C) 1998-2000 Andrzej Krzysztofowicz, Maintainer
@@ -9,6 +9,7 @@
  *  May be copied or modified under the terms of the GNU General Public License
  *  Copyright (C) 2002 Alan Cox <alan@redhat.com>
  *  ALi (now ULi M5228) support by Clear Zhang <Clear.Zhang@ali.com.tw>
+ *  Copyright (C) 2007 MontaVista Software, Inc. <source@mvista.com>
  *
  *  (U)DMA capable version of ali 1533/1543(C), 1535(D)
  *
@@ -280,15 +281,17 @@ static int ali_get_info (char *buffer, char **addr, off_t offset, int count)
 #endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_PROC_FS) */
 
 /**
- *	ali15x3_tune_drive	-	set up a drive
+ *	ali15x3_tune_pio	-	set up chipset for PIO mode
  *	@drive: drive to tune
- *	@pio: unused
+ *	@pio: desired mode
  *
- *	Select the best PIO timing for the drive in question. Then
- *	program the controller for this drive set up
+ *	Select the best PIO mode for the drive in question.
+ *	Then program the controller for this mode.
+ *
+ *	Returns the PIO mode programmed.
  */
  
-static void ali15x3_tune_drive (ide_drive_t *drive, u8 pio)
+static u8 ali15x3_tune_pio (ide_drive_t *drive, u8 pio)
 {
 	ide_pio_data_t d;
 	ide_hwif_t *hwif = HWIF(drive);
@@ -356,6 +359,22 @@ static void ali15x3_tune_drive (ide_drive_t *drive, u8 pio)
 	 * { 20,   50,     30  }    PIO Mode 5 with IORDY (nonstandard)
 	 */
 
+	return pio;
+}
+
+/**
+ *	ali15x3_tune_drive	-	set up drive for PIO mode
+ *	@drive: drive to tune
+ *	@pio: desired mode
+ *
+ *	Program the controller with the best PIO timing for the given drive.
+ *	Then set up the drive itself.
+ */
+
+static void ali15x3_tune_drive (ide_drive_t *drive, u8 pio)
+{
+	pio = ali15x3_tune_pio(drive, pio);
+	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 /**
@@ -430,7 +449,7 @@ static u8 ali15x3_ratemask (ide_drive_t *drive)
 }
 
 /**
- *	ali15x3_tune_chipset	-	set up chiset for new speed
+ *	ali15x3_tune_chipset	-	set up chipset/drive for new speed
  *	@drive: drive to configure for
  *	@xferspeed: desired speed
  *
@@ -461,7 +480,7 @@ static int ali15x3_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		pci_write_config_byte(dev, m5229_udma, tmpbyte);
 
 		if (speed < XFER_SW_DMA_0)
-			ali15x3_tune_drive(drive, speed);
+			(void) ali15x3_tune_pio(drive, speed - XFER_PIO_0);
 	} else {
 		pci_read_config_byte(dev, m5229_udma, &tmpbyte);
 		tmpbyte &= (0x0f << ((1-unit) << 2));
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index 61b5f9c..dc43f00 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -98,7 +98,6 @@
  *			 (patch courtesy of Zoltan Hidvegi)
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
 #define CMD640_PREFETCH_MASKS 1
 
 //#define CMD640_DUMP_REGS
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 49df275..b0d4825 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -1,6 +1,6 @@
 /* $Id: cmd64x.c,v 1.21 2000/01/30 23:23:16
  *
- * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
+ * linux/drivers/ide/pci/cmd64x.c		Version 1.41	Feb 3, 2007
  *
  * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
  *           Note, this driver is not used at all on other systems because
@@ -12,6 +12,7 @@
  * Copyright (C) 1998		David S. Miller (davem@redhat.com)
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
+ * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
  */
 
 #include <linux/module.h>
@@ -262,43 +263,25 @@ static void program_drive_counts (ide_drive_t *drive, int setup_count, int activ
 }
 
 /*
- * Attempts to set the interface PIO mode.
- * The preferred method of selecting PIO modes (e.g. mode 4) is 
- * "echo 'piomode:4' > /proc/ide/hdx/settings".  Special cases are
- * 8: prefetch off, 9: prefetch on, 255: auto-select best mode.
- * Called with 255 at boot time.
+ * This routine selects drive's best PIO mode, calculates setup/active/recovery
+ * counts, and then writes them into the chipset registers.
  */
-
-static void cmd64x_tuneproc (ide_drive_t *drive, u8 mode_wanted)
+static u8 cmd64x_tune_pio (ide_drive_t *drive, u8 mode_wanted)
 {
 	int setup_time, active_time, recovery_time;
 	int clock_time, pio_mode, cycle_time;
 	u8 recovery_count2, cycle_count;
 	int setup_count, active_count, recovery_count;
 	int bus_speed = system_bus_clock();
-	/*byte b;*/
 	ide_pio_data_t  d;
 
-	switch (mode_wanted) {
-		case 8: /* set prefetch off */
-		case 9: /* set prefetch on */
-			mode_wanted &= 1;
-			/*set_prefetch_mode(index, mode_wanted);*/
-			cmdprintk("%s: %sabled cmd640 prefetch\n",
-				drive->name, mode_wanted ? "en" : "dis");
-			return;
-	}
-
-	mode_wanted = ide_get_best_pio_mode (drive, mode_wanted, 5, &d);
-	pio_mode = d.pio_mode;
+	pio_mode = ide_get_best_pio_mode(drive, mode_wanted, 5, &d);
 	cycle_time = d.cycle_time;
 
 	/*
 	 * I copied all this complicated stuff from cmd640.c and made a few
 	 * minor changes.  For now I am just going to pray that it is correct.
 	 */
-	if (pio_mode > 5)
-		pio_mode = 5;
 	setup_time  = ide_pio_timings[pio_mode].setup_time;
 	active_time = ide_pio_timings[pio_mode].active_time;
 	recovery_time = cycle_time - (setup_time + active_time);
@@ -320,22 +303,33 @@ static void cmd64x_tuneproc (ide_drive_t *drive, u8 mode_wanted)
 	if (active_count > 16)
 		active_count = 16; /* maximum allowed by cmd646 */
 
-	/*
-	 * In a perfect world, we might set the drive pio mode here
-	 * (using WIN_SETFEATURE) before continuing.
-	 *
-	 * But we do not, because:
-	 *	1) this is the wrong place to do it
-	 *		(proper is do_special() in ide.c)
-	 * 	2) in practice this is rarely, if ever, necessary
-	 */
 	program_drive_counts (drive, setup_count, active_count, recovery_count);
 
-	cmdprintk("%s: selected cmd646 PIO mode%d : %d (%dns)%s, "
+	cmdprintk("%s: PIO mode wanted %d, selected %d (%dns)%s, "
 		"clocks=%d/%d/%d\n",
-		drive->name, pio_mode, mode_wanted, cycle_time,
+		drive->name, mode_wanted, pio_mode, cycle_time,
 		d.overridden ? " (overriding vendor mode)" : "",
 		setup_count, active_count, recovery_count);
+
+	return pio_mode;
+}
+
+/*
+ * Attempts to set drive's PIO mode.
+ * Special cases are 8: prefetch off, 9: prefetch on (both never worked),
+ * and 255: auto-select best mode (used at boot time).
+ */
+static void cmd64x_tune_drive (ide_drive_t *drive, u8 pio)
+{
+	/*
+	 * Filter out the prefetch control values
+	 * to prevent PIO5 from being programmed
+	 */
+	if (pio == 8 || pio == 9)
+		return;
+
+	pio = cmd64x_tune_pio(drive, pio);
+	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 static u8 cmd64x_ratemask (ide_drive_t *drive)
@@ -387,22 +381,6 @@ static u8 cmd64x_ratemask (ide_drive_t *drive)
 	return mode;
 }
 
-static void config_cmd64x_chipset_for_pio (ide_drive_t *drive, u8 set_speed)
-{
-	u8 speed	= 0x00;
-	u8 set_pio	= ide_get_best_pio_mode(drive, 4, 5, NULL);
-
-	cmd64x_tuneproc(drive, set_pio);
-	speed = XFER_PIO_0 + set_pio;
-	if (set_speed)
-		(void) ide_config_drive_speed(drive, speed);
-}
-
-static void config_chipset_for_pio (ide_drive_t *drive, u8 set_speed)
-{
-	config_cmd64x_chipset_for_pio(drive, set_speed);
-}
-
 static int cmd64x_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -414,7 +392,7 @@ static int cmd64x_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 
 	u8 speed	= ide_rate_filter(cmd64x_ratemask(drive), xferspeed);
 
-	if (speed > XFER_PIO_4) {
+	if (speed >= XFER_SW_DMA_0) {
 		(void) pci_read_config_byte(dev, pciD, &regD);
 		(void) pci_read_config_byte(dev, pciU, &regU);
 		regD &= ~(unit ? 0x40 : 0x20);
@@ -438,17 +416,20 @@ static int cmd64x_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_SW_DMA_2:	regD |= (unit ? 0x40 : 0x10); break;
 		case XFER_SW_DMA_1:	regD |= (unit ? 0x80 : 0x20); break;
 		case XFER_SW_DMA_0:	regD |= (unit ? 0xC0 : 0x30); break;
-		case XFER_PIO_4:	cmd64x_tuneproc(drive, 4); break;
-		case XFER_PIO_3:	cmd64x_tuneproc(drive, 3); break;
-		case XFER_PIO_2:	cmd64x_tuneproc(drive, 2); break;
-		case XFER_PIO_1:	cmd64x_tuneproc(drive, 1); break;
-		case XFER_PIO_0:	cmd64x_tuneproc(drive, 0); break;
+		case XFER_PIO_5:
+		case XFER_PIO_4:
+		case XFER_PIO_3:
+		case XFER_PIO_2:
+		case XFER_PIO_1:
+		case XFER_PIO_0:
+			(void) cmd64x_tune_pio(drive, speed - XFER_PIO_0);
+			break;
 
 		default:
 			return 1;
 	}
 
-	if (speed > XFER_PIO_4) {
+	if (speed >= XFER_SW_DMA_0) {
 		(void) pci_write_config_byte(dev, pciU, regU);
 		regD |= (unit ? 0x40 : 0x20);
 		(void) pci_write_config_byte(dev, pciD, regD);
@@ -461,8 +442,6 @@ static int config_chipset_for_dma (ide_drive_t *drive)
 {
 	u8 speed	= ide_dma_speed(drive, cmd64x_ratemask(drive));
 
-	config_chipset_for_pio(drive, !speed);
-
 	if (!speed)
 		return 0;
 
@@ -478,7 +457,7 @@ static int cmd64x_config_drive_for_dma (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		config_chipset_for_pio(drive, 1);
+		cmd64x_tune_drive(drive, 255);
 
 	return -1;
 }
@@ -679,14 +658,13 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
 	class_rev &= 0xff;
 
-	hwif->tuneproc  = &cmd64x_tuneproc;
+	hwif->tuneproc  = &cmd64x_tune_drive;
 	hwif->speedproc = &cmd64x_tune_chipset;
 
-	if (!hwif->dma_base) {
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
+
+	if (!hwif->dma_base)
 		return;
-	}
 
 	hwif->atapi_dma = 1;
 
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index e2672fc..d4b753e 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -122,7 +122,7 @@ static struct pci_driver driver = {
 static int
 delkin_cb_init (void)
 {
-	return pci_module_init(&driver);
+	return pci_register_driver(&driver);
 }
 
 static void
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index b408c6c..f2c5a14 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -21,8 +21,6 @@
  * are deemed to be part of the source code.
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 9ca60dd..aede7ee 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -57,7 +57,7 @@
  * There is a 25/33MHz switch in configuration
  * register, but driver is written for use at any frequency which get
  * (use idebus=xx to select PCI bus speed).
- * Use ide0=autotune for automatical tune of the PIO modes.
+ * Use hda=autotune and hdb=autotune for automatical tune of the PIO modes.
  * If you get strange results, do not use this and set PIO manually
  * by hdparm.
  *
@@ -87,7 +87,6 @@
  * 0.5 doesn't work.
  */
 
-#undef REALLY_SLOW_IO	/* most systems can safely undef this */
 #define OPTI621_DEBUG		/* define for debug messages */
 
 #include <linux/types.h>
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 569822f..061d300 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,10 +1,10 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.46	December 3, 2006
+ *  linux/drivers/ide/pci/piix.c	Version 0.47	February 8, 2007
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
- *  Copyright (C) 2006 MontaVista Software, Inc. <source@mvista.com>
+ *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *
@@ -205,14 +205,13 @@ static u8 piix_dma_2_pio (u8 xfer_rate) {
 }
 
 /**
- *	piix_tune_drive		-	tune a drive attached to a PIIX
+ *	piix_tune_pio		-	tune PIIX for PIO mode
  *	@drive: drive to tune
  *	@pio: desired PIO mode
  *
- *	Set the interface PIO mode based upon  the settings done by AMI BIOS
- *	(might be useful if drive is not registered in CMOS for any reason).
+ *	Set the interface PIO mode based upon the settings done by AMI BIOS.
  */
-static void piix_tune_drive (ide_drive_t *drive, u8 pio)
+static void piix_tune_pio (ide_drive_t *drive, u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -233,8 +232,6 @@ static void piix_tune_drive (ide_drive_t *drive, u8 pio)
 					{ 2, 1 },
 					{ 2, 3 }, };
 
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
-
 	/*
 	 * Master vs slave is synchronized above us but the slave register is
 	 * shared by the two hwifs so the corner case of two slave timeouts in
@@ -253,19 +250,20 @@ static void piix_tune_drive (ide_drive_t *drive, u8 pio)
 		master_data |=  0x4000;
 		master_data &= ~0x0070;
 		if (pio > 1) {
-			/* enable PPE, IE and TIME */
-			master_data = master_data | (control << 4);
+			/* Set PPE, IE and TIME */
+			master_data |= control << 4;
 		}
 		pci_read_config_byte(dev, slave_port, &slave_data);
-		slave_data = slave_data & (hwif->channel ? 0x0f : 0xf0);
-		slave_data = slave_data | (((timings[pio][0] << 2) | timings[pio][1]) << (hwif->channel ? 4 : 0));
+		slave_data &= hwif->channel ? 0x0f : 0xf0;
+		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) <<
+			       (hwif->channel ? 4 : 0);
 	} else {
 		master_data &= ~0x3307;
 		if (pio > 1) {
 			/* enable PPE, IE and TIME */
-			master_data = master_data | control;
+			master_data |= control;
 		}
-		master_data = master_data | (timings[pio][0] << 12) | (timings[pio][1] << 8);
+		master_data |= (timings[pio][0] << 12) | (timings[pio][1] << 8);
 	}
 	pci_write_config_word(dev, master_port, master_data);
 	if (is_slave)
@@ -274,6 +272,21 @@ static void piix_tune_drive (ide_drive_t *drive, u8 pio)
 }
 
 /**
+ *	piix_tune_drive		-	tune a drive attached to PIIX
+ *	@drive: drive to tune
+ *	@pio: desired PIO mode
+ *
+ *	Set the drive's PIO mode (might be useful if drive is not registered
+ *	in CMOS for any reason).
+ */
+static void piix_tune_drive (ide_drive_t *drive, u8 pio)
+{
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	piix_tune_pio(drive, pio);
+	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
+}
+
+/**
  *	piix_tune_chipset	-	tune a PIIX interface
  *	@drive: IDE drive to tune
  *	@xferspeed: speed to configure
@@ -348,8 +361,8 @@ static int piix_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 	}
 
-	piix_tune_drive(drive, piix_dma_2_pio(speed));
-	return (ide_config_drive_speed(drive, speed));
+	piix_tune_pio(drive, piix_dma_2_pio(speed));
+	return ide_config_drive_speed(drive, speed);
 }
 
 /**
@@ -392,9 +405,7 @@ static int piix_config_drive_xfer_rate (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		/* Find best PIO mode. */
-		piix_tune_chipset(drive, XFER_PIO_0 +
-				  ide_get_best_pio_mode(drive, 255, 4, NULL));
+		piix_tune_drive(drive, 255);
 
 	return -1;
 }
diff --git a/drivers/ide/pci/rz1000.c b/drivers/ide/pci/rz1000.c
index c185531..f8c9546 100644
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -15,8 +15,6 @@
  *  Dunno if this fixes both ports, or only the primary port (?).
  */
 
-#undef REALLY_SLOW_IO		/* most systems can safely undef this */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 7b4c189..71eccdf 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -26,6 +26,11 @@
  *	If you have strange problems with nVidia chipset systems please
  *	see the SI support documentation and update your system BIOS
  *	if neccessary
+ *
+ *  The Dell DRAC4 has some interesting features including effectively hot
+ *  unplugging/replugging the virtual CD interface when the DRAC is reset.
+ *  This often causes drivers/ide/siimage to panic but is ok with the rather
+ *  smarter code in libata.
  */
 
 #include <linux/types.h>
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index ae7eb58..852ccb3 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -1,8 +1,8 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.13	December 30, 2006
+ *  linux/drivers/ide/pci/slc90e66.c	Version 0.14	February 8, 2007
  *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2006 MontaVista Software, Inc. <source@mvista.com>
+ *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
  *
  * This is a look-alike variation of the ICH0 PIIX4 Ultra-66,
  * but this keeps the ISA-Bridge and slots alive.
@@ -57,11 +57,7 @@ static u8 slc90e66_dma_2_pio (u8 xfer_rate) {
 	}
 }
 
-/*
- *  Based on settings done by AMI BIOS
- *  (might be useful if drive is not registered in CMOS for any reason).
- */
-static void slc90e66_tune_drive (ide_drive_t *drive, u8 pio)
+static void slc90e66_tune_pio (ide_drive_t *drive, u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -80,7 +76,6 @@ static void slc90e66_tune_drive (ide_drive_t *drive, u8 pio)
 					{ 2, 1 },
 					{ 2, 3 }, };
 
-	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
 	spin_lock_irqsave(&ide_lock, flags);
 	pci_read_config_word(dev, master_port, &master_data);
 
@@ -94,19 +89,20 @@ static void slc90e66_tune_drive (ide_drive_t *drive, u8 pio)
 		master_data |=  0x4000;
 		master_data &= ~0x0070;
 		if (pio > 1) {
-			/* enable PPE, IE and TIME */
-			master_data = master_data | (control << 4);
+			/* Set PPE, IE and TIME */
+			master_data |= control << 4;
 		}
 		pci_read_config_byte(dev, slave_port, &slave_data);
-		slave_data = slave_data & (hwif->channel ? 0x0f : 0xf0);
-		slave_data = slave_data | (((timings[pio][0] << 2) | timings[pio][1]) << (hwif->channel ? 4 : 0));
+		slave_data &= hwif->channel ? 0x0f : 0xf0;
+		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) <<
+			       (hwif->channel ? 4 : 0);
 	} else {
 		master_data &= ~0x3307;
 		if (pio > 1) {
 			/* enable PPE, IE and TIME */
-			master_data = master_data | control;
+			master_data |= control;
 		}
-		master_data = master_data | (timings[pio][0] << 12) | (timings[pio][1] << 8);
+		master_data |= (timings[pio][0] << 12) | (timings[pio][1] << 8);
 	}
 	pci_write_config_word(dev, master_port, master_data);
 	if (is_slave)
@@ -114,6 +110,13 @@ static void slc90e66_tune_drive (ide_drive_t *drive, u8 pio)
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
+static void slc90e66_tune_drive (ide_drive_t *drive, u8 pio)
+{
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	slc90e66_tune_pio(drive, pio);
+	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
+}
+
 static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -162,8 +165,8 @@ static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
 	}
 
-	slc90e66_tune_drive(drive, slc90e66_dma_2_pio(speed));
-	return (ide_config_drive_speed(drive, speed));
+	slc90e66_tune_pio(drive, slc90e66_dma_2_pio(speed));
+	return ide_config_drive_speed(drive, speed);
 }
 
 static int slc90e66_config_drive_for_dma (ide_drive_t *drive)
@@ -185,8 +188,7 @@ static int slc90e66_config_drive_xfer_rate (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		(void)slc90e66_tune_chipset(drive, XFER_PIO_0 +
-				ide_get_best_pio_mode(drive, 255, 4, NULL));
+		slc90e66_tune_drive(drive, 255);
 
 	return -1;
 }
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 395d352..071a030 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -48,7 +48,7 @@
 #include <asm/mediabay.h>
 #endif
 
-#include "ide-timing.h"
+#include "../ide-timing.h"
 
 #undef IDE_PMAC_DEBUG
 
@@ -1551,19 +1551,34 @@ static struct pci_driver pmac_ide_pci_driver = {
 };
 MODULE_DEVICE_TABLE(pci, pmac_ide_pci_match);
 
-void __init
-pmac_ide_probe(void)
+int __init pmac_ide_probe(void)
 {
+	int error;
+
 	if (!machine_is(powermac))
-		return;
+		return -ENODEV;
 
 #ifdef CONFIG_BLK_DEV_IDE_PMAC_ATA100FIRST
-	pci_register_driver(&pmac_ide_pci_driver);
-	macio_register_driver(&pmac_ide_macio_driver);
+	error = pci_register_driver(&pmac_ide_pci_driver);
+	if (error)
+		goto out;
+	error = macio_register_driver(&pmac_ide_macio_driver);
+	if (error) {
+		pci_unregister_driver(&pmac_ide_pci_driver);
+		goto out;
+	}
 #else
-	macio_register_driver(&pmac_ide_macio_driver);
-	pci_register_driver(&pmac_ide_pci_driver);
+	error = macio_register_driver(&pmac_ide_macio_driver);
+	if (error)
+		goto out;
+	error = pci_register_driver(&pmac_ide_pci_driver);
+	if (error) {
+		macio_unregister_driver(&pmac_ide_macio_driver);
+		goto out;
+	}
 #endif
+out:
+	return error;
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
@@ -1983,7 +1998,7 @@ static void pmac_ide_dma_host_off(ide_drive_t *drive)
 {
 }
 
-static int pmac_ide_dma_host_on(ide_drive_t *drive)
+static void pmac_ide_dma_host_on(ide_drive_t *drive)
 {
 }
 
diff --git a/drivers/ide/ppc/scc_pata.c b/drivers/ide/ppc/scc_pata.c
index de64b02..f84bf79 100644
--- a/drivers/ide/ppc/scc_pata.c
+++ b/drivers/ide/ppc/scc_pata.c
@@ -509,6 +509,32 @@ static int scc_ide_dma_end(ide_drive_t * drive)
 	return __ide_dma_end(drive);
 }
 
+/* returns 1 if dma irq issued, 0 otherwise */
+static int scc_dma_test_irq(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	u8 dma_stat		= hwif->INB(hwif->dma_status);
+
+	/* return 1 if INTR asserted */
+	if ((dma_stat & 4) == 4)
+		return 1;
+
+	/* Workaround for PTERADD: emulate DMA_INTR when
+	 * - IDE_STATUS[ERR] = 1
+	 * - INT_STATUS[INTRQ] = 1
+	 * - DMA_STATUS[IORACTA] = 1
+	 */
+	if (in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT &&
+	    in_be32((void __iomem *)(hwif->dma_base + 0x014)) & INTSTS_INTRQ &&
+		dma_stat & 1)
+		return 1;
+
+	if (!drive->waiting_for_dma)
+		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
+			drive->name, __FUNCTION__);
+	return 0;
+}
+
 /**
  *	setup_mmio_scc	-	map CTRL/BMID region
  *	@dev: PCI device we are configuring
@@ -712,6 +738,7 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 	hwif->speedproc = scc_tune_chipset;
 	hwif->tuneproc = scc_tuneproc;
 	hwif->ide_dma_check = scc_config_drive_for_dma;
+	hwif->ide_dma_test_irq = scc_dma_test_irq;
 
 	hwif->drives[0].autotune = IDE_TUNE_AUTO;
 	hwif->drives[1].autotune = IDE_TUNE_AUTO;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2fe1d69..a4a9682 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -682,7 +682,34 @@ static void pci_read_irq(struct pci_dev *dev)
 	dev->irq = irq;
 }
 
-#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+static void change_legacy_io_resource(struct pci_dev * dev, unsigned index,
+                                      unsigned start, unsigned end)
+{
+	unsigned base = start & PCI_BASE_ADDRESS_IO_MASK;
+	unsigned len = (end | ~PCI_BASE_ADDRESS_IO_MASK) - base + 1;
+
+	/*
+	 * Some X versions get confused when the BARs reported through
+	 * /sys or /proc differ from those seen in config space, thus
+	 * try to update the config space values, too.
+	 */
+	if (!(pci_resource_flags(dev, index) & IORESOURCE_IO))
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (not I/O)\n",
+		       pci_name(dev), index);
+	else if (pci_resource_len(dev, index) != len)
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (size %04X)\n",
+		       pci_name(dev), index, (unsigned)pci_resource_len(dev, index));
+	else {
+		printk(KERN_INFO "%s: trying to change BAR%u from %04X to %04X\n",
+		       pci_name(dev), index,
+		       (unsigned)pci_resource_start(dev, index), base);
+		pci_write_config_dword(dev, PCI_BASE_ADDRESS_0 + index * 4, base);
+	}
+	pci_resource_start(dev, index) = start;
+	pci_resource_end(dev, index)   = end;
+	pci_resource_flags(dev, index) =
+		IORESOURCE_IO | IORESOURCE_PCI_FIXED | PCI_BASE_ADDRESS_SPACE_IO;
+}
 
 /**
  * pci_setup_device - fill in class and map information of a device
@@ -735,20 +762,12 @@ static int pci_setup_device(struct pci_dev * dev)
 			u8 progif;
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				dev->resource[0].start = 0x1F0;
-				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = LEGACY_IO_RESOURCE;
-				dev->resource[1].start = 0x3F6;
-				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 0, 0x1F0, 0x1F7);
+				change_legacy_io_resource(dev, 1, 0x3F6, 0x3F6);
 			}
 			if ((progif & 4) == 0) {
-				dev->resource[2].start = 0x170;
-				dev->resource[2].end = 0x177;
-				dev->resource[2].flags = LEGACY_IO_RESOURCE;
-				dev->resource[3].start = 0x376;
-				dev->resource[3].end = 0x376;
-				dev->resource[3].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 2, 0x170, 0x177);
+				change_legacy_io_resource(dev, 3, 0x376, 0x376);
 			}
 		}
 		break;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 79c0282..34f2676 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1359,7 +1359,8 @@ u8 ide_dump_status(ide_drive_t *, const char *, u8);
 typedef struct ide_pio_timings_s {
 	int	setup_time;	/* Address setup (ns) minimum */
 	int	active_time;	/* Active pulse (ns) minimum */
-	int	cycle_time;	/* Cycle time (ns) minimum = (setup + active + recovery) */
+	int	cycle_time;	/* Cycle time (ns) minimum = */
+				/* active + recovery (+ setup for some chips) */
 } ide_pio_timings_t;
 
 typedef struct ide_pio_data_s {
