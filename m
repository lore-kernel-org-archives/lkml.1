Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYFJUtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYFJUtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYFJUth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:49:37 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:29680 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYFJUtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tefsXEJiy8VYUEbY5K6P3n4MTFoLWzQOiqFHdlFPJpPR+KlE3057QNrYZXniyZhbxN
         eePtqHtuoOJGHrlgjuG4uki6HorND/FFQp0NkIHN97yTsb1tK99SUCOiqpb8Da+F/O2l
         OcQhU/BCHVXR/aMPZXgAI+tglg+exuhUPwq6U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:51:09 +0200
Message-Id: <20080610205109.18469.82083.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/14] ide: ->port_init_devs -> ->init_dev
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ->port_init_devs method to take 'ide_drive_t *' as an argument
instead of 'ide_hwif_t *' and rename it to ->init_dev.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c          |    6 +++---
 drivers/ide/legacy/ht6560b.c     |    8 ++++----
 drivers/ide/legacy/ide-4drives.c |   10 ++++------
 drivers/ide/legacy/qd65xx.c      |   16 ++++++++--------
 drivers/ide/pci/opti621.c        |    7 +++----
 include/linux/ide.h              |    4 ++--
 6 files changed, 24 insertions(+), 27 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1326,10 +1326,10 @@ static void ide_port_init_devices(ide_hw
 			drive->unmask = 1;
 		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
 			drive->no_unmask = 1;
-	}
 
-	if (port_ops && port_ops->port_init_devs)
-		port_ops->port_init_devs(hwif);
+		if (port_ops && port_ops->init_dev)
+			port_ops->init_dev(drive);
+	}
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -310,16 +310,16 @@ static void ht6560b_set_pio_mode(ide_dri
 #endif
 }
 
-static void __init ht6560b_port_init_devs(ide_hwif_t *hwif)
+static void __init ht6560b_init_dev(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	/* Setting default configurations for drives. */
 	int t = (HT_CONFIG_DEFAULT << 8) | HT_TIMING_DEFAULT;
 
 	if (hwif->channel)
 		t |= (HT_SECONDARY_IF << 8);
 
-	hwif->drives[0].drive_data = t;
-	hwif->drives[1].drive_data = t;
+	drive->drive_data = t;
 }
 
 static int probe_ht6560b;
@@ -328,7 +328,7 @@ module_param_named(probe, probe_ht6560b,
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 
 static const struct ide_port_ops ht6560b_port_ops = {
-	.port_init_devs		= ht6560b_port_init_devs,
+	.init_dev		= ht6560b_init_dev,
 	.set_pio_mode		= ht6560b_set_pio_mode,
 	.selectproc		= ht6560b_selectproc,
 };
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -11,16 +11,14 @@ static int probe_4drives;
 module_param_named(probe, probe_4drives, bool, 0);
 MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
 
-static void ide_4drives_port_init_devs(ide_hwif_t *hwif)
+static void ide_4drives_init_dev(ide_drive_t *drive)
 {
-	if (hwif->channel) {
-		hwif->drives[0].select.all ^= 0x20;
-		hwif->drives[1].select.all ^= 0x20;
-	}
+	if (drive->hwif->channel)
+		drive->select.all ^= 0x20;
 }
 
 static const struct ide_port_ops ide_4drives_port_ops = {
-	.port_init_devs		= ide_4drives_port_init_devs,
+	.init_dev		= ide_4drives_init_dev,
 };
 
 static const struct ide_port_info ide_4drives_port_info = {
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -282,17 +282,18 @@ static int __init qd_testreg(int port)
 	return (readreg != QD_TESTVAL);
 }
 
-static void __init qd6500_port_init_devs(ide_hwif_t *hwif)
+static void __init qd6500_init_dev(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	u8 base = (hwif->config_data & 0xff00) >> 8;
 	u8 config = QD_CONFIG(hwif);
 
-	hwif->drives[0].drive_data = QD6500_DEF_DATA;
-	hwif->drives[1].drive_data = QD6500_DEF_DATA;
+	drive->drive_data = QD6500_DEF_DATA;
 }
 
-static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
+static void __init qd6580_init_dev(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	u16 t1, t2;
 	u8 base = (hwif->config_data & 0xff00) >> 8;
 	u8 config = QD_CONFIG(hwif);
@@ -303,18 +304,17 @@ static void __init qd6580_port_init_devs
 	} else
 		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
 
-	hwif->drives[0].drive_data = t1;
-	hwif->drives[1].drive_data = t2;
+	drive->drive_data = drive->select.b.unit ? t2 : t1;
 }
 
 static const struct ide_port_ops qd6500_port_ops = {
-	.port_init_devs		= qd6500_port_init_devs,
+	.init_dev		= qd6500_init_dev,
 	.set_pio_mode		= qd6500_set_pio_mode,
 	.selectproc		= qd65xx_select,
 };
 
 static const struct ide_port_ops qd6580_port_ops = {
-	.port_init_devs		= qd6580_port_init_devs,
+	.init_dev		= qd6580_init_dev,
 	.set_pio_mode		= qd6580_set_pio_mode,
 	.selectproc		= qd65xx_select,
 };
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -319,14 +319,13 @@ static void opti621_set_pio_mode(ide_dri
 	spin_unlock_irqrestore(&opti621_lock, flags);
 }
 
-static void __devinit opti621_port_init_devs(ide_hwif_t *hwif)
+static void __devinit opti621_init_dev(ide_drive_t *drive)
 {
-	hwif->drives[0].drive_data = PIO_DONT_KNOW;
-	hwif->drives[1].drive_data = PIO_DONT_KNOW;
+	drive->drive_data = PIO_DONT_KNOW;
 }
 
 static const struct ide_port_ops opti621_port_ops = {
-	.port_init_devs		= opti621_port_init_devs,
+	.init_dev		= opti621_init_dev,
 	.set_pio_mode		= opti621_set_pio_mode,
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -390,8 +390,8 @@ typedef struct ide_drive_s {
 struct ide_port_info;
 
 struct ide_port_ops {
-	/* host specific initialization of devices on a port */
-	void	(*port_init_devs)(struct hwif_s *);
+	/* host specific initialization of a device */
+	void	(*init_dev)(ide_drive_t *);
 	/* routine to program host for PIO mode */
 	void	(*set_pio_mode)(ide_drive_t *, const u8);
 	/* routine to program host for DMA mode */
