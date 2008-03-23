Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbYCWURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbYCWURl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbYCWUQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 16:16:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:33897 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbYCWUQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 16:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=agGgMRHeKLk6AB55/GdYKeZ3ktDl6iEd1M0UtxNtSwn5GgQWEaKcddQAAfGTykE51rzsE9So5+Ga73Ryn6/6U+xhCX5OdLULueEgyjs9/J62JqUsetWveC3ku4Tp5wsIjB+sqyCD8+oEM3x/PIagSMDAsg9oXL1GsvpLFNtucAQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: remove obsoleted "ide=" kernel parameters
Date: Sun, 23 Mar 2008 21:29:36 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803232129.36412.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove obsoleted "ide=" kernel parameters.

* Remove no longer needed:
  - ide_setup()
  - parse_options()
  - __setup("", ...)
  - module_param(options, ...)

* Use module_{init,exit}() for MODULE=y case and remove MODULE ifdef.

* Make ide_*acpi* and ide_doubler variables static.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c     |    6 +-
 drivers/ide/ide-dma.c      |    2 
 drivers/ide/ide.c          |   91 ++-------------------------------------------
 drivers/ide/legacy/gayle.c |    3 -
 include/linux/ide.h        |    4 -
 5 files changed, 11 insertions(+), 95 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -60,15 +60,15 @@ struct ide_acpi_hwif_link {
 #define DEBPRINT(fmt, args...)	do {} while (0)
 #endif	/* DEBUGGING */
 
-int ide_noacpi;
+static int ide_noacpi;
 module_param_named(noacpi, ide_noacpi, bool, 0);
 MODULE_PARM_DESC(noacpi, "disable IDE ACPI support");
 
-int ide_acpigtf;
+static int ide_acpigtf;
 module_param_named(acpigtf, ide_acpigtf, bool, 0);
 MODULE_PARM_DESC(acpigtf, "enable IDE ACPI _GTF support");
 
-int ide_acpionboot;
+static int ide_acpionboot;
 module_param_named(acpionboot, ide_acpionboot, bool, 0);
 MODULE_PARM_DESC(acpionboot, "call IDE ACPI methods on boot");
 
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -691,7 +691,7 @@ static int ide_tune_dma(ide_drive_t *dri
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (noautodma || drive->nodma || (drive->id->capability & 1) == 0)
+	if (drive->nodma || (drive->id->capability & 1) == 0)
 		return 0;
 
 	/* consult the list of known "bad" drives */
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -87,9 +87,9 @@ static const u8 ide_hwif_to_major[] = { 
 					IDE8_MAJOR, IDE9_MAJOR };
 
 DEFINE_MUTEX(ide_cfg_mtx);
- __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 
-int noautodma = 0;
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
+EXPORT_SYMBOL(ide_lock);
 
 ide_hwif_t ide_hwifs[MAX_HWIFS];	/* master data repository */
 
@@ -695,59 +695,6 @@ set_val:
 
 EXPORT_SYMBOL(generic_ide_ioctl);
 
-/*
- * ide_setup() gets called VERY EARLY during initialization,
- * to handle kernel "command line" strings beginning with "ide".
- *
- * Remember to update Documentation/ide/ide.txt if you change something here.
- */
-static int __init ide_setup(char *s)
-{
-	printk(KERN_INFO "ide_setup: %s", s);
-
-#ifdef CONFIG_BLK_DEV_IDEDOUBLER
-	if (!strcmp(s, "ide=doubler")) {
-		extern int ide_doubler;
-
-		printk(" : Enabled support for IDE doublers\n");
-		ide_doubler = 1;
-		goto obsolete_option;
-	}
-#endif /* CONFIG_BLK_DEV_IDEDOUBLER */
-
-	if (!strcmp(s, "ide=nodma")) {
-		printk(" : Prevented DMA\n");
-		noautodma = 1;
-		goto obsolete_option;
-	}
-
-#ifdef CONFIG_BLK_DEV_IDEACPI
-	if (!strcmp(s, "ide=noacpi")) {
-		//printk(" : Disable IDE ACPI support.\n");
-		ide_noacpi = 1;
-		goto obsolete_option;
-	}
-	if (!strcmp(s, "ide=acpigtf")) {
-		//printk(" : Enable IDE ACPI _GTF support.\n");
-		ide_acpigtf = 1;
-		goto obsolete_option;
-	}
-	if (!strcmp(s, "ide=acpionboot")) {
-		//printk(" : Call IDE ACPI methods on boot.\n");
-		ide_acpionboot = 1;
-		goto obsolete_option;
-	}
-#endif /* CONFIG_BLK_DEV_IDEACPI */
-
-	printk(" -- BAD OPTION\n");
-	return 1;
-obsolete_option:
-	printk(" -- OBSOLETE OPTION, WILL BE REMOVED SOON!\n");
-	return 1;
-}
-
-EXPORT_SYMBOL(ide_lock);
-
 static int ide_bus_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -1092,32 +1039,7 @@ out_port_class:
 	return ret;
 }
 
-#ifdef MODULE
-static char *options = NULL;
-module_param(options, charp, 0);
-MODULE_LICENSE("GPL");
-
-static void __init parse_options (char *line)
-{
-	char *next = line;
-
-	if (line == NULL || !*line)
-		return;
-	while ((line = next) != NULL) {
- 		if ((next = strchr(line,' ')) != NULL)
-			*next++ = 0;
-		if (!ide_setup(line))
-			printk (KERN_INFO "Unknown option '%s'\n", line);
-	}
-}
-
-int __init init_module (void)
-{
-	parse_options(options);
-	return ide_init();
-}
-
-void __exit cleanup_module (void)
+static void __exit ide_exit(void)
 {
 	int index;
 
@@ -1131,10 +1053,7 @@ void __exit cleanup_module (void)
 	bus_unregister(&ide_bus_type);
 }
 
-#else /* !MODULE */
-
-__setup("", ide_setup);
-
 module_init(ide_init);
+module_exit(ide_exit);
 
-#endif /* MODULE */
+MODULE_LICENSE("GPL");
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -62,7 +62,8 @@
 					       GAYLE_NUM_HWIFS-1)
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
 #define GAYLE_IDEREG_SIZE	(ide_doubler ? 0x1000 : 0x2000)
-int ide_doubler = 0;	/* support IDE doublers? */
+
+static int ide_doubler;
 module_param_named(doubler, ide_doubler, bool, 0);
 MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
 #endif /* CONFIG_BLK_DEV_IDEDOUBLER */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -799,10 +799,6 @@ int generic_ide_ioctl(ide_drive_t *, str
 #ifndef _IDE_C
 extern	ide_hwif_t	ide_hwifs[];		/* master data repository */
 #endif
-extern int ide_noacpi;
-extern int ide_acpigtf;
-extern int ide_acpionboot;
-extern int noautodma;
 
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
