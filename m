Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYCKUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYCKUOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYCKUOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:14:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:31373 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYCKUN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:13:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=s70h9lsWOkdZFYqQHenVkaKFBA70G7Bscq63TuPg14w2TiFL9ZXtsXrZy1FCaRIynJTDm/JbIGbaVGz9G6QGkpvoiSxoJ6wbCTIGmuQTAKWXDc95TLXCIkKDL4VJgCBBmWRNgbSKLsvKrBvn3I7ry4MeOWImF97K9TrX+ZyHlaY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove obsoleted "idex=" kernel parameters
Date: Tue, 11 Mar 2008 21:26:14 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112126.14904.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove obsoleted "idex=" kernel parameters.

* Make probe_* and cmd640_vlb variables static.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Andrew, this should fix "IDE tree vs i386 allmodconfig" issue.

 Documentation/ide/ide.txt           |    2 
 Documentation/kernel-parameters.txt |    4 -
 drivers/ide/ide.c                   |  115 ------------------------------------
 drivers/ide/legacy/ali14xx.c        |    2 
 drivers/ide/legacy/dtc2278.c        |    2 
 drivers/ide/legacy/ht6560b.c        |    2 
 drivers/ide/legacy/ide-4drives.c    |    2 
 drivers/ide/legacy/qd65xx.c         |    2 
 drivers/ide/legacy/umc8672.c        |    2 
 drivers/ide/pci/cmd640.c            |    5 -
 10 files changed, 8 insertions(+), 130 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -193,8 +193,6 @@ Summary of ide driver parameters for ker
 
  "hdx="  is recognized for all "x" from "a" to "h", such as "hdc".
 
- "idex=" is recognized for all "x" from "0" to "3", such as "ide1".
-
  "hdx=noprobe"		: drive may be present, but do not probe for it
 
  "hdx=none"		: drive is NOT present, ignore cmos and do not probe
Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -768,10 +768,6 @@ and is between 256 and 4096 characters. 
 			Format: ide=nodma or ide=doubler or ide=reverse
 			See Documentation/ide/ide.txt.
 
-	ide?=		[HW] (E)IDE subsystem
-			Format: ide?=ata66 or chipset specific parameters.
-			See Documentation/ide/ide.txt.
-
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
 			See Documentation/ide/ide.txt.
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -839,16 +839,6 @@ static int __init match_parm (char *s, c
 	return 0;	/* zero = nothing matched */
 }
 
-extern int probe_ali14xx;
-extern int probe_umc8672;
-extern int probe_dtc2278;
-extern int probe_ht6560b;
-extern int probe_qd65xx;
-extern int cmd640_vlb;
-extern int probe_4drives;
-
-static int __initdata is_chipset_set;
-
 /*
  * ide_setup() gets called VERY EARLY during initialization,
  * to handle kernel "command line" strings beginning with "hdx=" or "ide".
@@ -857,14 +847,12 @@ static int __initdata is_chipset_set;
  */
 static int __init ide_setup(char *s)
 {
-	int i, vals[3];
 	ide_hwif_t *hwif;
 	ide_drive_t *drive;
 	unsigned int hw, unit;
+	int vals[3];
 	const char max_drive = 'a' + ((MAX_HWIFS * MAX_DRIVES) - 1);
-	const char max_hwif  = '0' + (MAX_HWIFS - 1);
 
-	
 	if (strncmp(s,"hd",2) == 0 && s[2] == '=')	/* hd= is for hd.c   */
 		return 0;				/* driver and not us */
 
@@ -996,114 +984,13 @@ static int __init ide_setup(char *s)
 			printk(" -- BAD BUS SPEED! Expected value from 20 to 66");
 		goto done;
 	}
-	/*
-	 * Look for interface options:  "idex="
-	 */
-	if (s[3] >= '0' && s[3] <= max_hwif) {
-		/*
-		 * Be VERY CAREFUL changing this: note hardcoded indexes below
-		 * (-8, -9, -10) are reserved to ease the hardcoding.
-		 */
-		static const char *ide_words[] = {
-			"minus1", "minus2", "minus3", "minus4",
-			"minus5", "minus6", "ata66", "minus8", "minus9",
-			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
-			"dtc2278", "umc8672", "ali14xx", NULL };
 
-		hw = s[3] - '0';
-		hwif = &ide_hwifs[hw];
-		i = match_parm(&s[4], ide_words, vals, 3);
-
-		/*
-		 * Cryptic check to ensure chipset not already set for hwif.
-		 * Note: we can't depend on hwif->chipset here.
-		 */
-		if (i >= -18 && i <= -11) {
-			/* chipset already specified */
-			if (is_chipset_set)
-				goto bad_option;
-			/* these drivers are for "ide0=" only */
-			if (hw != 0)
-				goto bad_hwif;
-			is_chipset_set = 1;
-			printk("\n");
-		}
-
-		switch (i) {
-#ifdef CONFIG_BLK_DEV_ALI14XX
-			case -17: /* "ali14xx" */
-				probe_ali14xx = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_UMC8672
-			case -16: /* "umc8672" */
-				probe_umc8672 = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_DTC2278
-			case -15: /* "dtc2278" */
-				probe_dtc2278 = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_CMD640
-			case -14: /* "cmd640_vlb" */
-				cmd640_vlb = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_HT6560B
-			case -13: /* "ht6560b" */
-				probe_ht6560b = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_QD65XX
-			case -12: /* "qd65xx" */
-				probe_qd65xx = 1;
-				goto obsolete_option;
-#endif
-#ifdef CONFIG_BLK_DEV_4DRIVES
-			case -11: /* "four" drives on one set of ports */
-				probe_4drives = 1;
-				goto obsolete_option;
-#endif
-			case -10: /* minus10 */
-			case -9: /* minus9 */
-			case -8: /* minus8 */
-			case -6:
-			case -4:
-			case -3:
-				goto bad_option;
-			case -7: /* ata66 */
-#ifdef CONFIG_BLK_DEV_IDEPCI
-				/*
-				 * Use ATA_CBL_PATA40_SHORT so drive side
-				 * cable detection is also overriden.
-				 */
-				hwif->cbl = ATA_CBL_PATA40_SHORT;
-				goto obsolete_option;
-#else
-				goto bad_hwif;
-#endif
-			case -5:
-			case -2:
-			case -1:
-			case 0:
-			case 1:
-			case 2:
-			case 3:
-				goto bad_option;
-			default:
-				printk(" -- SUPPORT NOT CONFIGURED IN THIS KERNEL\n");
-				return 1;
-		}
-	}
 bad_option:
 	printk(" -- BAD OPTION\n");
 	return 1;
 obsolete_option:
 	printk(" -- OBSOLETE OPTION, WILL BE REMOVED SOON!\n");
 	return 1;
-bad_hwif:
-	printk("-- NOT SUPPORTED ON ide%d", hw);
 done:
 	printk("\n");
 	return 1;
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -220,7 +220,7 @@ static int __init ali14xx_probe(void)
 	return ide_legacy_device_add(&ali14xx_port_info, 0);
 }
 
-int probe_ali14xx;
+static int probe_ali14xx;
 
 module_param_named(probe, probe_ali14xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -131,7 +131,7 @@ static int __init dtc2278_probe(void)
 	return ide_legacy_device_add(&dtc2278_port_info, 0);
 }
 
-int probe_dtc2278 = 0;
+static int probe_dtc2278;
 
 module_param_named(probe, probe_dtc2278, bool, 0);
 MODULE_PARM_DESC(probe, "probe for DTC2278xx chipsets");
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -323,7 +323,7 @@ static void __init ht6560b_port_init_dev
 	hwif->drives[1].drive_data = t;
 }
 
-int probe_ht6560b = 0;
+static int probe_ht6560b;
 
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -6,7 +6,7 @@
 
 #define DRV_NAME "ide-4drives"
 
-int probe_4drives;
+static int probe_4drives;
 
 module_param_named(probe, probe_4drives, bool, 0);
 MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -399,7 +399,7 @@ static int __init qd_probe(int base)
 	return rc;
 }
 
-int probe_qd65xx = 0;
+static int probe_qd65xx;
 
 module_param_named(probe, probe_qd65xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for QD65xx chipsets");
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -158,7 +158,7 @@ static int __init umc8672_probe(void)
 	return ide_legacy_device_add(&umc8672_port_info, 0);
 }
 
-int probe_umc8672;
+static int probe_umc8672;
 
 module_param_named(probe, probe_umc8672, bool, 0);
 MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -111,10 +111,7 @@
 
 #define DRV_NAME "cmd640"
 
-/*
- * This flag is set in ide.c by the parameter:  ide0=cmd640_vlb
- */
-int cmd640_vlb;
+static int cmd640_vlb;
 
 /*
  * CMD640 specific registers definition.
