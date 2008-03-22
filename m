Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbYCVVxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbYCVVxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYCVVwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:52:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:4232 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbYCVVwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mb4foQQcylOpIM2CzfzFR8vZeAoANhRXX3Oh77uo7a04vn+bNtaVWnVA4qxYAruNQa3IwNgK2ekIYxUGZDnOjU24UvPOzIwFfIrJj9E1xgVdgVG22wIlS6EeHohQdepcZtEgPJEM6Rpe831gWbKxSQEEECjGMyx4MTRCi/Fw4Hc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2008 23:07:01 +0100
Message-Id: <20080322220701.17636.90584.sendpatchset@localhost.localdomain>
In-Reply-To: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
References: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/8] ide: add "cdrom=" and "chs=" parameters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add "cdrom=" and "chs=" parameters.

* Obsolete "hdx=cdrom" and "hdx=cyls,heads,sects" kernel parameters.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |   31 +++++++++-----------
 drivers/ide/ide.c         |   71 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 80 insertions(+), 22 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -82,17 +82,16 @@ Drives are normally found by auto-probin
 For really weird situations, the apparent (fdisk) geometry can also be specified
 on the kernel "command line" using LILO.  The format of such lines is:
 
-	hdx=cyls,heads,sects
-or	hdx=cdrom
+	ide_core.chs=[interface_number.device_number]:cyls,heads,sects
+or	ide_core.cdrom=[interface_number.device_number]
 
-where hdx can be any of hda through hdh, Three values are required
-(cyls,heads,sects).  For example:
+For example:
 
-	hdc=1050,32,64  hdd=cdrom
+	ide_core.chs=1.0:1050,32,64  ide_core.cdrom=1.1
 
-either {hda,hdb} or {hdc,hdd}.  The results of successful auto-probing may
-override the physical geometry/irq specified, though the "original" geometry
-may be retained as the "logical" geometry for partitioning purposes (fdisk).
+The results of successful auto-probing may override the physical geometry/irq
+specified, though the "original" geometry may be retained as the "logical"
+geometry for partitioning purposes (fdisk).
 
 If the auto-probing during boot time confuses a drive (ie. the drive works
 with hd.c but not with ide.c), then an command line option may be specified
@@ -101,7 +100,7 @@ probe/identification sequence.  For exam
 
 	ide_core.noprobe=0.1
 or
-	hdc=768,16,32
+	ide_core.chs=1.0:768,16,32
 	ide_core.noprobe=1.0
 
 Note that when only one IDE device is attached to an interface, it should be
@@ -118,9 +117,9 @@ If for some reason your cdrom drive is *
 the probe to look harder by supplying a kernel command line parameter
 via LILO, such as:
 
-	hdc=cdrom	/* hdc = "master" on second interface */
+	ide_core.cdrom=1.0	/* "master" on second interface (hdc) */
 or
-	hdd=cdrom	/* hdd = "slave" on second interface */
+	ide_core.cdrom=1.1	/* "slave" on second interface (hdd) */
 
 For example, a GW2000 system might have a hard drive on the primary
 interface (/dev/hda) and an IDE cdrom drive on the secondary interface
@@ -182,12 +181,6 @@ driver using the "options=" keyword to i
 Summary of ide driver parameters for kernel command line
 --------------------------------------------------------
 
- "hdx="  is recognized for all "x" from "a" to "u", such as "hdc".
-
- "hdx=cdrom"		: drive is present, and is a cdrom drive
-
- "hdx=cyl,head,sect"	: disk drive is present, with specified geometry
-
  "ide=doubler"		: probe/support IDE doublers on Amiga
 
 There may be more options than shown -- use the source, Luke!
@@ -230,6 +223,10 @@ Other kernel parameters for ide_core are
 
 * "nowerr=[interface_number.device_number]" to ignore the WRERR_STAT bit
 
+* "cdrom=[interface_number.device_number]" to force device as a CD-ROM
+
+* "chs=[interface_number.device_number]" to force device as a disk (using CHS)
+
 ================================================================================
 
 Some Terminology
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -875,7 +875,7 @@ static int __init ide_setup(char *s)
 				drive->media = ide_cdrom;
 				/* an ATAPI device ignores DRDY */
 				drive->ready_stat = 0;
-				goto done;
+				goto obsolete_option;
 			case -5: /* nodma */
 				drive->nodma = 1;
 				goto obsolete_option;
@@ -899,7 +899,7 @@ static int __init ide_setup(char *s)
 				drive->sect	= drive->bios_sect = vals[2];
 				drive->present	= 1;
 				drive->forced_geom = 1;
-				goto done;
+				goto obsolete_option;
 			default:
 				goto bad_option;
 		}
@@ -911,9 +911,6 @@ bad_option:
 obsolete_option:
 	printk(" -- OBSOLETE OPTION, WILL BE REMOVED SOON!\n");
 	return 1;
-done:
-	printk("\n");
-	return 1;
 }
 
 EXPORT_SYMBOL(ide_lock);
@@ -1103,6 +1100,51 @@ static unsigned int ide_nowerr;
 module_param_call(nowerr, ide_set_dev_param_mask, NULL, &ide_nowerr, 0);
 MODULE_PARM_DESC(nowerr, "ignore the WRERR_STAT bit for a device");
 
+static unsigned int ide_cdroms;
+
+module_param_call(cdrom, ide_set_dev_param_mask, NULL, &ide_cdroms, 0);
+MODULE_PARM_DESC(cdrom, "force device as a CD-ROM");
+
+struct chs_geom {
+	unsigned int	cyl;
+	u8		head;
+	u8		sect;
+};
+
+static unsigned int ide_disks;
+static struct chs_geom ide_disks_chs[MAX_HWIFS * MAX_DRIVES];
+
+static int ide_set_disk_chs(const char *str, struct kernel_param *kp)
+{
+	int a, b, c = 0, h = 0, s = 0, i, j = 1;
+
+	if (sscanf(str, "%d.%d:%d,%d,%d", &a, &b, &c, &h, &s) != 5 &&
+	    sscanf(str, "%d.%d:%d", &a, &b, &j) != 3)
+		return -EINVAL;
+
+	i = a * MAX_DRIVES + b;
+
+	if (i >= MAX_HWIFS * MAX_DRIVES || j < 0 || j > 1)
+		return -EINVAL;
+
+	if (c > INT_MAX || h > 255 || s > 255)
+		return -EINVAL;
+
+	if (j)
+		ide_disks |= (1 << i);
+	else
+		ide_disks &= (1 << i);
+
+	ide_disks_chs[i].cyl  = c;
+	ide_disks_chs[i].head = h;
+	ide_disks_chs[i].sect = s;
+
+	return 0;
+}
+
+module_param_call(chs, ide_set_disk_chs, NULL, NULL, 0);
+MODULE_PARM_DESC(chs, "force device as a disk (using CHS)");
+
 static void ide_dev_apply_params(ide_drive_t *drive)
 {
 	int i = drive->hwif->index * MAX_DRIVES + drive->select.b.unit;
@@ -1125,6 +1167,25 @@ static void ide_dev_apply_params(ide_dri
 				 drive->name);
 		drive->bad_wstat = BAD_R_STAT;
 	}
+	if (ide_cdroms & (1 << i)) {
+		printk(KERN_INFO "ide: forcing %s as a CD-ROM\n", drive->name);
+		drive->present = 1;
+		drive->media = ide_cdrom;
+		/* an ATAPI device ignores DRDY */
+		drive->ready_stat = 0;
+	}
+	if (ide_disks & (1 << i)) {
+		drive->cyl  = drive->bios_cyl  = ide_disks_chs[i].cyl;
+		drive->head = drive->bios_head = ide_disks_chs[i].head;
+		drive->sect = drive->bios_sect = ide_disks_chs[i].sect;
+		drive->forced_geom = 1;
+		printk(KERN_INFO "ide: forcing %s as a disk (%d/%d/%d)\n",
+				 drive->name,
+				 drive->cyl, drive->head, drive->sect);
+		drive->present = 1;
+		drive->media = ide_disk;
+		drive->ready_stat = READY_STAT;
+	}
 }
 
 static unsigned int ide_ignore_cable;
