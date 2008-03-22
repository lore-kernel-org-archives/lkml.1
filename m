Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYCVVwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYCVVwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbYCVVv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:51:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:30158 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbYCVVv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=eb9+Nar/MO0Fowxh2sFlXs4Zh7yBa9xLobtsIUKfwo8Exko47sEJ6h8zkXCoCbUY8S2Am2ZKIa7qSr183ybVq7rji2ss1J7di0NIcanJzX0XmIF6YO5ZsKo/oQJ275Oz+MXTpHkLOqI0I5lM8259W5+kD+viv1sT9jFqe7XXTIs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2008 23:06:53 +0100
Message-Id: <20080322220653.17636.69237.sendpatchset@localhost.localdomain>
In-Reply-To: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
References: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/8] ide: add "nodma|noflush|noprobe|nowerr=" parameters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add "nodma|noflush|noprobe|nowerr=" parameters.

* Obsolete "hdx=noprobe|none|nowerr|nodma|noflush" kernel parameters.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |   26 +++++++--------
 drivers/ide/ide.c         |   79 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 88 insertions(+), 17 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -99,10 +99,10 @@ with hd.c but not with ide.c), then an c
 for each drive for which you'd like the drive to skip the hardware
 probe/identification sequence.  For example:
 
-	hdb=noprobe
+	ide_core.noprobe=0.1
 or
 	hdc=768,16,32
-	hdc=noprobe
+	ide_core.noprobe=1.0
 
 Note that when only one IDE device is attached to an interface, it should be
 jumpered as "single" or "master", *not* "slave".  Many folks have had
@@ -174,9 +174,7 @@ to /etc/modprobe.conf.
 
 When ide.c is used as a module, you can pass command line parameters to the
 driver using the "options=" keyword to insmod, while replacing any ',' with
-';'.  For example:
-
-	insmod ide.o options="hda=nodma hdb=nodma"
+';'.
 
 
 ================================================================================
@@ -186,18 +184,10 @@ Summary of ide driver parameters for ker
 
  "hdx="  is recognized for all "x" from "a" to "u", such as "hdc".
 
- "hdx=noprobe"		: drive may be present, but do not probe for it
-
- "hdx=none"		: drive is NOT present, ignore cmos and do not probe
-
- "hdx=nowerr"		: ignore the WRERR_STAT bit on this drive
-
  "hdx=cdrom"		: drive is present, and is a cdrom drive
 
  "hdx=cyl,head,sect"	: disk drive is present, with specified geometry
 
- "hdx=nodma"		: disallow DMA
-
  "ide=doubler"		: probe/support IDE doublers on Amiga
 
 There may be more options than shown -- use the source, Luke!
@@ -230,6 +220,16 @@ a case please report it as a bug instead
 * "ignore_cable=[interface_number]" module parameter (for ide_core module)
   if IDE is compiled as module
 
+Other kernel parameters for ide_core are:
+
+* "nodma=[interface_number.device_number]" to disallow DMA for a device
+
+* "noflush=[interface_number.device_number]" to disable flush requests
+
+* "noprobe=[interface_number.device_number]" to skip probing
+
+* "nowerr=[interface_number.device_number]" to ignore the WRERR_STAT bit
+
 ================================================================================
 
 Some Terminology
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -866,10 +866,10 @@ static int __init ide_setup(char *s)
 			case -1: /* "none" */
 			case -2: /* "noprobe" */
 				drive->noprobe = 1;
-				goto done;
+				goto obsolete_option;
 			case -3: /* "nowerr" */
 				drive->bad_wstat = BAD_R_STAT;
-				goto done;
+				goto obsolete_option;
 			case -4: /* "cdrom" */
 				drive->present = 1;
 				drive->media = ide_cdrom;
@@ -878,10 +878,10 @@ static int __init ide_setup(char *s)
 				goto done;
 			case -5: /* nodma */
 				drive->nodma = 1;
-				goto done;
+				goto obsolete_option;
 			case -11: /* noflush */
 				drive->noflush = 1;
-				goto done;
+				goto obsolete_option;
 			case -12: /* "remap" */
 				drive->remap_0_to_1 = 1;
 				goto obsolete_option;
@@ -1061,6 +1061,72 @@ EXPORT_SYMBOL_GPL(ide_pci_clk);
 module_param_named(pci_clock, ide_pci_clk, int, 0);
 MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
 
+static int ide_set_dev_param_mask(const char *s, struct kernel_param *kp)
+{
+	int a, b, i, j = 1;
+	unsigned int *dev_param_mask = (unsigned int *)kp->arg;
+
+	if (sscanf(s, "%d.%d:%d", &a, &b, &j) != 3 &&
+	    sscanf(s, "%d.%d", &a, &b) != 2)
+		return -EINVAL;
+
+	i = a * MAX_DRIVES + b;
+
+	if (i >= MAX_HWIFS * MAX_DRIVES || j < 0 || j > 1)
+		return -EINVAL;
+
+	if (j)
+		*dev_param_mask |= (1 << i);
+	else
+		*dev_param_mask &= (1 << i);
+
+	return 0;
+}
+
+static unsigned int ide_nodma;
+
+module_param_call(nodma, ide_set_dev_param_mask, NULL, &ide_nodma, 0);
+MODULE_PARM_DESC(nodma, "disallow DMA for a device");
+
+static unsigned int ide_noflush;
+
+module_param_call(noflush, ide_set_dev_param_mask, NULL, &ide_noflush, 0);
+MODULE_PARM_DESC(noflush, "disable flush requests for a device");
+
+static unsigned int ide_noprobe;
+
+module_param_call(noprobe, ide_set_dev_param_mask, NULL, &ide_noprobe, 0);
+MODULE_PARM_DESC(noprobe, "skip probing for a device");
+
+static unsigned int ide_nowerr;
+
+module_param_call(nowerr, ide_set_dev_param_mask, NULL, &ide_nowerr, 0);
+MODULE_PARM_DESC(nowerr, "ignore the WRERR_STAT bit for a device");
+
+static void ide_dev_apply_params(ide_drive_t *drive)
+{
+	int i = drive->hwif->index * MAX_DRIVES + drive->select.b.unit;
+
+	if (ide_nodma & (1 << i)) {
+		printk(KERN_INFO "ide: disallowing DMA for %s\n", drive->name);
+		drive->nodma = 1;
+	}
+	if (ide_noflush & (1 << i)) {
+		printk(KERN_INFO "ide: disabling flush requests for %s\n",
+				 drive->name);
+		drive->noflush = 1;
+	}
+	if (ide_noprobe & (1 << i)) {
+		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
+		drive->noprobe = 1;
+	}
+	if (ide_nowerr & (1 << i)) {
+		printk(KERN_INFO "ide: ignoring the WRERR_STAT bit for %s\n",
+				 drive->name);
+		drive->bad_wstat = BAD_R_STAT;
+	}
+}
+
 static unsigned int ide_ignore_cable;
 
 static int ide_set_ignore_cable(const char *s, struct kernel_param *kp)
@@ -1086,11 +1152,16 @@ MODULE_PARM_DESC(ignore_cable, "ignore c
 
 void ide_port_apply_params(ide_hwif_t *hwif)
 {
+	int i;
+
 	if (ide_ignore_cable & (1 << hwif->index)) {
 		printk(KERN_INFO "ide: ignoring cable detection for %s\n",
 				 hwif->name);
 		hwif->cbl = ATA_CBL_PATA40_SHORT;
 	}
+
+	for (i = 0; i < MAX_DRIVES; i++)
+		ide_dev_apply_params(&hwif->drives[i]);
 }
 
 /*
