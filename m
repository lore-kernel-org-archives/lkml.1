Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYBQShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYBQShH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYBQSgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:36:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:63739 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYBQSgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Bnr3+ONX9r9U5KRoiBZu70+LcFlI4IghP4dcZp1eLC6q1jpisFr6SigaHq6moKXg51S2hjllXwcp0ebTkM4Ldm0XTBINvyEHiMCycbnGwQutrZkfTqEy1VsR99jfn5it2noaSIYwPsDd9K1/qx2fDB03JTjrGkfRXYXlaY/kXPY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Feb 2008 19:51:15 +0100
Message-Id: <20080217185115.16210.78887.sendpatchset@localhost.localdomain>
In-Reply-To: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
References: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/5] ide: merge ide_match_hwif() and ide_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Change ide_match_hwif() argument from 'u8 bootable' to
  'struct ide_port_info *d'.

* Move ide_match_hwif() to ide-probe.c from setup-pci.c and rename
  it to ide_find_port_slot().  Update some comments while at it.

* ide_find_port() can be now just a wrapper for ide_find_port_slot().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide.c       |   15 ---------------
 drivers/ide/setup-pci.c |   48 +-----------------------------------------------
 include/linux/ide.h     |    8 +++++++-
 4 files changed, 54 insertions(+), 63 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1435,6 +1435,52 @@ static int ide_sysfs_register_port(ide_h
 	return rc;
 }
 
+/**
+ *	ide_find_port_slot	-	find free ide_hwifs[] slot
+ *	@d: IDE port info
+ *
+ *	Return the new hwif.  If we are out of free slots return NULL.
+ */
+
+ide_hwif_t *ide_find_port_slot(const struct ide_port_info *d)
+{
+	ide_hwif_t *hwif;
+	int i;
+	u8 bootable = (d && (d->host_flags & IDE_HFLAG_NON_BOOTABLE)) ? 0 : 1;
+
+	/*
+	 * Claim an unassigned slot.
+	 *
+	 * Give preference to claiming other slots before claiming ide0/ide1,
+	 * just in case there's another interface yet-to-be-scanned
+	 * which uses ports 0x1f0/0x170 (the ide0/ide1 defaults).
+	 *
+	 * Unless there is a bootable card that does not use the standard
+	 * ports 0x1f0/0x170 (the ide0/ide1 defaults).
+	 */
+	if (bootable) {
+		for (i = 0; i < MAX_HWIFS; i++) {
+			hwif = &ide_hwifs[i];
+			if (hwif->chipset == ide_unknown)
+				return hwif;
+		}
+	} else {
+		for (i = 2; i < MAX_HWIFS; i++) {
+			hwif = &ide_hwifs[i];
+			if (hwif->chipset == ide_unknown)
+				return hwif;
+		}
+		for (i = 0; i < 2 && i < MAX_HWIFS; i++) {
+			hwif = &ide_hwifs[i];
+			if (hwif->chipset == ide_unknown)
+				return hwif;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(ide_find_port_slot);
+
 int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 {
 	ide_hwif_t *hwif, *mate = NULL;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -234,21 +234,6 @@ static int ide_system_bus_speed(void)
 	return pci_dev_present(pci_default) ? 33 : 50;
 }
 
-ide_hwif_t *ide_find_port(void)
-{
-	ide_hwif_t *hwif;
-	int i;
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->chipset == ide_unknown)
-			return hwif;
-	}
-
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(ide_find_port);
-
 static struct resource* hwif_request_region(ide_hwif_t *hwif,
 					    unsigned long addr, int num)
 {
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -20,51 +20,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-
-/**
- *	ide_match_hwif	-	find free ide_hwifs[] slot
- *	@bootable: bootable flag
- *
- *	Return the new hwif.  If we are out of free slots return NULL.
- */
-
-static ide_hwif_t *ide_match_hwif(u8 bootable)
-{
-	ide_hwif_t *hwif;
-	int h;
-
-	/*
-	 * Claim an unassigned slot.
-	 *
-	 * Give preference to claiming other slots before claiming ide0/ide1,
-	 * just in case there's another interface yet-to-be-scanned
-	 * which uses ports 1f0/170 (the ide0/ide1 defaults).
-	 *
-	 * Unless there is a bootable card that does not use the standard
-	 * ports 1f0/170 (the ide0/ide1 defaults). The (bootable) flag.
-	 */
-	if (bootable) {
-		for (h = 0; h < MAX_HWIFS; ++h) {
-			hwif = &ide_hwifs[h];
-			if (hwif->chipset == ide_unknown)
-				return hwif;	/* pick an unused entry */
-		}
-	} else {
-		for (h = 2; h < MAX_HWIFS; ++h) {
-			hwif = ide_hwifs + h;
-			if (hwif->chipset == ide_unknown)
-				return hwif;	/* pick an unused entry */
-		}
-	}
-	for (h = 0; h < 2 && h < MAX_HWIFS; ++h) {
-		hwif = ide_hwifs + h;
-		if (hwif->chipset == ide_unknown)
-			return hwif;	/* pick an unused entry */
-	}
-
-	return NULL;
-}
-
 /**
  *	ide_setup_pci_baseregs	-	place a PCI IDE controller native
  *	@dev: PCI device of interface to switch native
@@ -322,7 +277,6 @@ static ide_hwif_t *ide_hwif_configure(st
 {
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
-	u8 bootable = (d->host_flags & IDE_HFLAG_NON_BOOTABLE) ? 0 : 1;
 	u8 oldnoprobe = 0;
 	struct hw_regs_s hw;
 
@@ -346,7 +300,7 @@ static ide_hwif_t *ide_hwif_configure(st
 		base = port ? 0x170 : 0x1f0;
 	}
 
-	hwif = ide_match_hwif(bootable);
+	hwif = ide_find_port_slot(d);
 	if (hwif == NULL) {
 		printk(KERN_ERR "%s: too many IDE interfaces, no room in "
 				"table\n", d->name);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -171,7 +171,6 @@ typedef struct hw_regs_s {
 	struct device	*dev;
 } hw_regs_t;
 
-struct hwif_s *ide_find_port(void);
 void ide_init_port_data(struct hwif_s *, unsigned int);
 void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
 
@@ -812,6 +811,13 @@ extern	ide_hwif_t	ide_hwifs[];		/* maste
 #endif
 extern int noautodma;
 
+ide_hwif_t *ide_find_port_slot(const struct ide_port_info *);
+
+static inline ide_hwif_t *ide_find_port(void)
+{
+	return ide_find_port_slot(NULL);
+}
+
 extern int ide_end_request (ide_drive_t *drive, int uptodate, int nrsecs);
 int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, int nr_sectors);
