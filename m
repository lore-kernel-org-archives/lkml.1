Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYCKUOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYCKUOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYCKUN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:13:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31634 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYCKUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=x0VlGFUuXfrSqJkzkuaBKLbtcjlXOfNvTqIwuBuOPlckr8g2zE+5A4/BDJW4dyWxYUcTuZHq82jPJT2+RuNDwjQNww4He++jxr0do8y4cBTrGV+y6PE/LMcWF1lquC/qZvqLqjptLzJa9AfxiS+ySIgn23JixFIndu9z8/KEmmI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove obsoleted "idex=base[,ctl[,irq]]" kernel parameters (take 2)
Date: Tue, 11 Mar 2008 21:24:39 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112124.39940.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove obsoleted "idex=base[,ctl[,irq]]" kernel parameters
  and update Documentation/ide/ide.txt.

* Remove no longer needed ide_forced chipset type.

v2:
* is_chipset_set[] -> is_chipset_set in ide.c.

* Documentation/ide/ide.txt fix.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch

 Documentation/ide/ide.txt |   33 +--------------------------------
 drivers/ide/ide-generic.c |    3 +--
 drivers/ide/ide-probe.c   |    3 +--
 drivers/ide/ide-proc.c    |    3 ---
 drivers/ide/ide.c         |   41 ++++++++++++-----------------------------
 drivers/ide/pci/cmd640.c  |    2 +-
 drivers/ide/setup-pci.c   |   11 -----------
 include/linux/ide.h       |    2 +-
 8 files changed, 17 insertions(+), 81 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -71,29 +71,6 @@ This driver automatically probes for mos
 ones), for the drives/geometries attached to those interfaces, and for the IRQ
 lines being used by the interfaces (normally 14, 15 for ide0/ide1).
 
-For special cases, interfaces may be specified using kernel "command line"
-options.  For example,
-
-	ide3=0x168,0x36e,10	/* ioports 0x168-0x16f,0x36e, irq 10 */
-
-Normally the irq number need not be specified, as ide.c will probe for it:
-
-	ide3=0x168,0x36e	/* ioports 0x168-0x16f,0x36e */
-
-The standard port, and irq values are these:
-
-	ide0=0x1f0,0x3f6,14
-	ide1=0x170,0x376,15
-	ide2=0x1e8,0x3ee,11
-	ide3=0x168,0x36e,10
-
-Note that the first parameter reserves 8 contiguous ioports, whereas the
-second value denotes a single ioport. If in doubt, do a 'cat /proc/ioports'.
-
-In all probability the device uses these ports and IRQs if it is attached
-to the appropriate ide channel.  Pass the parameter for the correct ide
-channel to the kernel, as explained above.
-
 Any number of interfaces may share a single IRQ if necessary, at a slight
 performance penalty, whether on separate cards or a single VLB card.
 The IDE driver automatically detects and handles this.  However, this may
@@ -206,7 +183,7 @@ When ide.c is used as a module, you can 
 driver using the "options=" keyword to insmod, while replacing any ',' with
 ';'.  For example:
 
-	insmod ide.o options="ide0=serialize ide1=serialize ide2=0x1e8;0x3ee;11"
+	insmod ide.o options="hda=nodma hdb=nodma"
 
 
 ================================================================================
@@ -258,14 +235,6 @@ Summary of ide driver parameters for ker
 			  As for VLB, it is safest to not specify it.
 			  Bigger values are safer than smaller ones.
 
- "idex=base"		: probe for an interface at the addr specified,
-			  where "base" is usually 0x1f0 or 0x170
-			  and "ctl" is assumed to be "base"+0x206
-
- "idex=base,ctl"	: specify both base and ctl
-
- "idex=base,ctl,irq"	: specify base, ctl, and irq number
-
  "idex=serialize"	: do not overlap operations on idex. Please note
 			  that you will have to specify this option for
 			  both the respective primary and secondary channel
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -93,8 +93,7 @@ static int __init ide_generic_init(void)
 		ide_hwif_t *hwif = &ide_hwifs[i];
 
 		if (hwif->io_ports[IDE_DATA_OFFSET] &&
-		    (hwif->chipset == ide_unknown ||
-		     hwif->chipset == ide_forced))
+		    hwif->chipset == ide_unknown)
 			idx[i] = i;
 		else
 			idx[i] = 0xff;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1515,8 +1515,7 @@ int ide_device_add_all(u8 *idx, const st
 		hwif = &ide_hwifs[idx[i]];
 
 		if (hwif->present) {
-			if (hwif->chipset == ide_unknown ||
-			    hwif->chipset == ide_forced)
+			if (hwif->chipset == ide_unknown)
 				hwif->chipset = ide_generic;
 			hwif_register_devices(hwif);
 		}
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -46,9 +46,6 @@ static int proc_ide_read_imodel
 	int		len;
 	const char	*name;
 
-	/*
-	 * Neither ide_unknown nor ide_forced should be set at this point.
-	 */
 	switch (hwif->chipset) {
 		case ide_generic:	name = "generic";	break;
 		case ide_pci:		name = "pci";		break;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1172,7 +1172,7 @@ extern int probe_ht6560b;
 extern int probe_qd65xx;
 extern int cmd640_vlb;
 
-static int __initdata is_chipset_set[MAX_HWIFS];
+static int __initdata is_chipset_set;
 
 /*
  * ide_setup() gets called VERY EARLY during initialization,
@@ -1338,8 +1338,6 @@ static int __init ide_setup(char *s)
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
 
-		hw_regs_t hwregs;
-
 		hw = s[3] - '0';
 		hwif = &ide_hwifs[hw];
 		i = match_parm(&s[4], ide_words, vals, 3);
@@ -1348,19 +1346,14 @@ static int __init ide_setup(char *s)
 		 * Cryptic check to ensure chipset not already set for hwif.
 		 * Note: we can't depend on hwif->chipset here.
 		 */
-		if ((i >= -18 && i <= -11) || (i > 0 && i <= 3)) {
+		if (i >= -18 && i <= -11) {
 			/* chipset already specified */
-			if (is_chipset_set[hw])
+			if (is_chipset_set)
 				goto bad_option;
-			if (i > -18 && i <= -11) {
-				/* these drivers are for "ide0=" only */
-				if (hw != 0)
-					goto bad_hwif;
-				/* chipset already specified for 2nd port */
-				if (is_chipset_set[hw+1])
-					goto bad_option;
-			}
-			is_chipset_set[hw] = 1;
+			/* these drivers are for "ide0=" only */
+			if (hw != 0)
+				goto bad_hwif;
+			is_chipset_set = 1;
 			printk("\n");
 		}
 
@@ -1440,21 +1433,11 @@ static int __init ide_setup(char *s)
 			case -1: /* "noprobe" */
 				hwif->noprobe = 1;
 				goto obsolete_option;
-
-			case 1:	/* base */
-				vals[1] = vals[0] + 0x206; /* default ctl */
-			case 2: /* base,ctl */
-				vals[2] = 0;	/* default irq = probe for it */
-			case 3: /* base,ctl,irq */
-				memset(&hwregs, 0, sizeof(hwregs));
-				ide_init_hwif_ports(&hwregs, vals[0], vals[1], &hwif->irq);
-				memcpy(hwif->io_ports, hwregs.io_ports, sizeof(hwif->io_ports));
-				hwif->irq      = vals[2];
-				hwif->noprobe  = 0;
-				hwif->chipset  = ide_forced;
-				goto obsolete_option;
-
-			case 0: goto bad_option;
+			case 0:
+			case 1:
+			case 2:
+			case 3:
+				goto bad_option;
 			default:
 				printk(" -- SUPPORT NOT CONFIGURED IN THIS KERNEL\n");
 				return 1;
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -415,7 +415,7 @@ static void __init setup_device_ptrs (vo
 	cmd_hwif1 = &ide_hwifs[1]; /* default, if not found below */
 	for (i = 0; i < MAX_HWIFS; i++) {
 		ide_hwif_t *hwif = &ide_hwifs[i];
-		if (hwif->chipset == ide_unknown || hwif->chipset == ide_forced) {
+		if (hwif->chipset == ide_unknown) {
 			if (hwif->io_ports[IDE_DATA_OFFSET] == 0x1f0)
 				cmd_hwif0 = hwif;
 			else if (hwif->io_ports[IDE_DATA_OFFSET] == 0x170)
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -41,17 +41,6 @@ static ide_hwif_t *ide_match_hwif(unsign
 	ide_hwif_t *hwif;
 
 	/*
-	 * Look for a hwif with matching io_base specified using
-	 * parameters to ide_setup().
-	 */
-	for (h = 0; h < MAX_HWIFS; ++h) {
-		hwif = &ide_hwifs[h];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == io_base) {
-			if (hwif->chipset == ide_forced)
-				return hwif; /* a perfect match */
-		}
-	}
-	/*
 	 * Look for a hwif with matching io_base default value.
 	 * If chipset is "ide_unknown", then claim that hwif slot.
 	 * Otherwise, some other chipset has already claimed it..  :(
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -169,7 +169,7 @@ enum {		ide_unknown,	ide_generic,	ide_pc
 		ide_rz1000,	ide_trm290,
 		ide_cmd646,	ide_cy82c693,	ide_4drives,
 		ide_pmac,	ide_etrax100,	ide_acorn,
-		ide_au1xxx,	ide_palm3710,	ide_forced
+		ide_au1xxx,	ide_palm3710
 };
 
 typedef u8 hwif_chipset_t;
