Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbYAPXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbYAPXQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYAPXOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:14:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbYAPXOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HaBsiqn3A1uDlSuuusH1bq4bp8Uf2dGi+XXbw1Alb74yCGU2EOTfCukBqwbXXXY4496QJ/lC6bioFZJZbv4cpflP1QP3aztgV9yKAzpDHQGa3aa3dxkFQn7tlEEhImGZ47djWcwJBIXLvE1KErOJwNTyQO1u8KkaTlf3z6vPy0o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:27:02 +0100
Message-Id: <20080116232702.9166.77564.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/22] ide: add ->init_port_devs method to ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ->init_port_devs method to ide_hwif_t for a host specific
  initialization of devices on a port.  Call the new method from
  ide_port_init_devices().

* Convert ht6560b, qd65xx and opti621 host drivers to use the new
  ->init_port_devs method.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c      |    3 ++
 drivers/ide/legacy/ht6560b.c |   26 +++++++++++++------------
 drivers/ide/legacy/qd65xx.c  |   44 ++++++++++++++++++++++++++++++++-----------
 drivers/ide/pci/opti621.c    |   10 ++++++---
 include/linux/ide.h          |    2 +
 5 files changed, 59 insertions(+), 26 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1305,6 +1305,9 @@ static void ide_port_init_devices(ide_hw
 		if ((hwif->host_flags & IDE_HFLAG_NO_AUTOTUNE) == 0)
 			drive->autotune = 1;
 	}
+
+	if (hwif->port_init_devs)
+		hwif->port_init_devs(hwif);
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -300,6 +300,18 @@ static void ht6560b_set_pio_mode(ide_dri
 #endif
 }
 
+static void __init ht6560b_port_init_devs(ide_hwif_t *hwif)
+{
+	/* Setting default configurations for drives. */
+	int t = (HT_CONFIG_DEFAULT << 8) | HT_TIMING_DEFAULT;
+
+	if (hwif->channel)
+		t |= (HT_SECONDARY_IF << 8);
+
+	hwif->drives[0].drive_data = t;
+	hwif->drives[1].drive_data = t;
+}
+
 int probe_ht6560b = 0;
 
 module_param_named(probe, probe_ht6560b, bool, 0);
@@ -318,7 +330,6 @@ static int __init ht6560b_init(void)
 {
 	ide_hwif_t *hwif, *mate;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
-	int t;
 
 	if (probe_ht6560b == 0)
 		return -ENODEV;
@@ -343,17 +354,8 @@ static int __init ht6560b_init(void)
 	mate->selectproc = &ht6560b_selectproc;
 	mate->set_pio_mode = &ht6560b_set_pio_mode;
 
-	/*
-	 * Setting default configurations for drives
-	 */
-	t = (HT_CONFIG_DEFAULT << 8);
-	t |= HT_TIMING_DEFAULT;
-	hwif->drives[0].drive_data = t;
-	hwif->drives[1].drive_data = t;
-
-	t |= (HT_SECONDARY_IF << 8);
-	mate->drives[0].drive_data = t;
-	mate->drives[1].drive_data = t;
+	hwif->port_init_devs = ht6560b_port_init_devs;
+	mate->port_init_devs = ht6560b_port_init_devs;
 
 	ide_device_add(idx, &ht6560b_port_info);
 
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -305,13 +305,33 @@ static int __init qd_testreg(int port)
  * called to setup an ata channel : adjusts attributes & links for tuning
  */
 
-static void __init qd_setup(ide_hwif_t *hwif, int base, int config,
-			    unsigned int data0, unsigned int data1)
+static void __init qd_setup(ide_hwif_t *hwif, int base, int config)
 {
 	hwif->select_data = base;
 	hwif->config_data = config;
-	hwif->drives[0].drive_data = data0;
-	hwif->drives[1].drive_data = data1;
+}
+
+static void __init qd6500_port_init_devs(ide_hwif_t *hwif)
+{
+	u8 base = hwif->select_data, config = QD_CONFIG(hwif);
+
+	hwif->drives[0].drive_data = QD6500_DEF_DATA;
+	hwif->drives[1].drive_data = QD6500_DEF_DATA;
+}
+
+static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
+{
+	u16 t1, t2;
+	u8 base = hwif->select_data, config = QD_CONFIG(hwif);
+
+	if (QD_CONTROL(hwif) & QD_CONTR_SEC_DISABLED) {
+		t1 = QD6580_DEF_DATA;
+		t2 = QD6580_DEF_DATA2;
+	} else
+		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
+
+	hwif->drives[0].drive_data = t1;
+	hwif->drives[1].drive_data = t2;
 }
 
 /*
@@ -396,8 +416,9 @@ static int __init qd_probe(int base)
 			return 1;
 		}
 
-		qd_setup(hwif, base, config, QD6500_DEF_DATA, QD6500_DEF_DATA);
+		qd_setup(hwif, base, config);
 
+		hwif->port_init_devs = qd6500_port_init_devs;
 		hwif->set_pio_mode = &qd6500_set_pio_mode;
 
 		idx[unit] = unit;
@@ -429,9 +450,10 @@ static int __init qd_probe(int base)
 			hwif = &ide_hwifs[unit];
 			printk(KERN_INFO "%s: qd6580: single IDE board\n",
 					 hwif->name);
-			qd_setup(hwif, base, config | (control << 8),
-				 QD6580_DEF_DATA, QD6580_DEF_DATA2);
 
+			qd_setup(hwif, base, config | (control << 8));
+
+			hwif->port_init_devs = qd6580_port_init_devs;
 			hwif->set_pio_mode = &qd6580_set_pio_mode;
 
 			idx[unit] = unit;
@@ -450,14 +472,14 @@ static int __init qd_probe(int base)
 			printk(KERN_INFO "%s&%s: qd6580: dual IDE board\n",
 					hwif->name, mate->name);
 
-			qd_setup(hwif, base, config | (control << 8),
-				 QD6580_DEF_DATA, QD6580_DEF_DATA);
+			qd_setup(hwif, base, config | (control << 8));
 
+			hwif->port_init_devs = qd6580_port_init_devs;
 			hwif->set_pio_mode = &qd6580_set_pio_mode;
 
-			qd_setup(mate, base, config | (control << 8),
-				 QD6580_DEF_DATA2, QD6580_DEF_DATA2);
+			qd_setup(mate, base, config | (control << 8));
 
+			mate->port_init_devs = qd6580_port_init_devs;
 			mate->set_pio_mode = &qd6580_set_pio_mode;
 
 			idx[0] = 0;
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -315,14 +315,18 @@ static void opti621_set_pio_mode(ide_dri
 	spin_unlock_irqrestore(&opti621_lock, flags);
 }
 
+static void __devinit opti621_port_init_devs(ide_hwif_t *hwif)
+{
+	hwif->drives[0].drive_data = PIO_DONT_KNOW;
+	hwif->drives[1].drive_data = PIO_DONT_KNOW;
+}
+
 /*
  * init_hwif_opti621() is called once for each hwif found at boot.
  */
 static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
 {
-	hwif->drives[0].drive_data = PIO_DONT_KNOW;
-	hwif->drives[1].drive_data = PIO_DONT_KNOW;
-
+	hwif->port_init_devs = opti621_port_init_devs;
 	hwif->set_pio_mode = &opti621_set_pio_mode;
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -514,6 +514,8 @@ typedef struct hwif_s {
 #if 0
 	ide_hwif_ops_t	*hwifops;
 #else
+	/* host specific initialization of devices on a port */
+	void	(*port_init_devs)(struct hwif_s *);
 	/* routine to program host for PIO mode */
 	void	(*set_pio_mode)(ide_drive_t *, const u8);
 	/* routine to program host for DMA mode */
