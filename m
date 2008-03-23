Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbYCWUR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbYCWUR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 16:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbYCWUQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 16:16:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:33108 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbYCWUQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 16:16:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JzyTHrjIQK5C6UXceU55QkAV9Gqk6qItPdJmesTLLmhY2OWFc//2XjeD6ghYC92W6wwf2Ai40gUKLpGec9MNjHzTkteEwc4wz+n9wHpevXnsisplVcxihuR9sNfQ/TTCJkV/ucq2SilFBzNCr5rHZvlx+Yqq3mX/74rdhBdLmHA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: add "noacpi" / "acpigtf" / "acpionboot" parameters
Date: Sun, 23 Mar 2008 21:28:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803232128.08339.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rename ide_noacpi{tfs,onboot} to ide_acpi{gtf,onboot} (+ reverse logic).

* Move ide_*acpi* variables to ide-acpi.c and remove unnecessary initializers.

* Add "noacpi" / "acpigtf" / "acpionboot" parameters.

* Obsolete "ide=noacpi" / "ide=acpigtf" / "ide=acpionboot" kernel parameters.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c |   18 +++++++++++++-----
 drivers/ide/ide.c      |   16 +++++-----------
 include/linux/ide.h    |    3 +++
 3 files changed, 21 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -60,9 +60,17 @@ struct ide_acpi_hwif_link {
 #define DEBPRINT(fmt, args...)	do {} while (0)
 #endif	/* DEBUGGING */
 
-extern int ide_noacpi;
-extern int ide_noacpitfs;
-extern int ide_noacpionboot;
+int ide_noacpi;
+module_param_named(noacpi, ide_noacpi, bool, 0);
+MODULE_PARM_DESC(noacpi, "disable IDE ACPI support");
+
+int ide_acpigtf;
+module_param_named(acpigtf, ide_acpigtf, bool, 0);
+MODULE_PARM_DESC(acpigtf, "enable IDE ACPI _GTF support");
+
+int ide_acpionboot;
+module_param_named(acpionboot, ide_acpionboot, bool, 0);
+MODULE_PARM_DESC(acpionboot, "call IDE ACPI methods on boot");
 
 static bool ide_noacpi_psx;
 static int no_acpi_psx(const struct dmi_system_id *id)
@@ -376,7 +384,7 @@ static int taskfile_load_raw(ide_drive_t
 	memcpy(&args.tf_array[7], &gtf->tfa, 7);
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	if (ide_noacpitfs) {
+	if (!ide_acpigtf) {
 		DEBPRINT("_GTF execution disabled\n");
 		return err;
 	}
@@ -721,7 +729,7 @@ void ide_acpi_port_init_devices(ide_hwif
 				 drive->name, err);
 	}
 
-	if (ide_noacpionboot) {
+	if (!ide_acpionboot) {
 		DEBPRINT("ACPI methods disabled on boot\n");
 		return;
 	}
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -91,12 +91,6 @@ DEFINE_MUTEX(ide_cfg_mtx);
 
 int noautodma = 0;
 
-#ifdef CONFIG_BLK_DEV_IDEACPI
-int ide_noacpi = 0;
-int ide_noacpitfs = 1;
-int ide_noacpionboot = 1;
-#endif
-
 ide_hwif_t ide_hwifs[MAX_HWIFS];	/* master data repository */
 
 static void ide_port_init_devices_data(ide_hwif_t *);
@@ -731,17 +725,17 @@ static int __init ide_setup(char *s)
 	if (!strcmp(s, "ide=noacpi")) {
 		//printk(" : Disable IDE ACPI support.\n");
 		ide_noacpi = 1;
-		return 1;
+		goto obsolete_option;
 	}
 	if (!strcmp(s, "ide=acpigtf")) {
 		//printk(" : Enable IDE ACPI _GTF support.\n");
-		ide_noacpitfs = 0;
-		return 1;
+		ide_acpigtf = 1;
+		goto obsolete_option;
 	}
 	if (!strcmp(s, "ide=acpionboot")) {
 		//printk(" : Call IDE ACPI methods on boot.\n");
-		ide_noacpionboot = 0;
-		return 1;
+		ide_acpionboot = 1;
+		goto obsolete_option;
 	}
 #endif /* CONFIG_BLK_DEV_IDEACPI */
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -799,6 +799,9 @@ int generic_ide_ioctl(ide_drive_t *, str
 #ifndef _IDE_C
 extern	ide_hwif_t	ide_hwifs[];		/* master data repository */
 #endif
+extern int ide_noacpi;
+extern int ide_acpigtf;
+extern int ide_acpionboot;
 extern int noautodma;
 
 extern int ide_vlb_clk;
