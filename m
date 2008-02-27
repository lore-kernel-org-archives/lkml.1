Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbYB0WJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbYB0WJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758938AbYB0WIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:08:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:48933 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760758AbYB0WI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:08:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HQza5rvnertWFWM69rt9VIMJZDptd9ixnjW6Ryep5OTTzWVyTsiwQWhmJY2xYdmnWM0m3mrK+0X/IK5oLjcXn899xnZ1svjQMEzPps6UVjP4PtcMJ5DvhFcX4+wTgx5aM/Nn2CmKajzqY37+l6HtsbocCCWkcl09SaWPwgZ+vuY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] ide: use ide_legacy_device_add() for qd65xx
Date: Wed, 27 Feb 2008 23:21:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802272321.17474.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'unsigned long config' argument to ide_legacy_device_add()
  for setting hwif->config_data.

* Use ide_find_port_slot() instead of ide_find_port() in
  ide_legacy_device_add().

* Handle IDE_HFLAG_QD_2ND_PORT and IDE_HFLAG_SINGLE host flags in
  ide_legacy_device_add().

* Convert qd65xx host driver to use ide_legacy_device_add().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c     |   19 ++++++++++----
 drivers/ide/legacy/qd65xx.c |   58 +++++---------------------------------------
 include/linux/ide.h         |    2 -
 3 files changed, 22 insertions(+), 57 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1630,7 +1630,7 @@ void ide_port_scan(ide_hwif_t *hwif)
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
 
-int ide_legacy_device_add(const struct ide_port_info *d)
+int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 {
 	ide_hwif_t *hwif, *mate;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
@@ -1644,15 +1644,24 @@ int ide_legacy_device_add(const struct i
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	hwif = ide_find_port();
+	hwif = ide_find_port_slot(d);
 	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		idx[0] = hwif->index;
+		u8 j = (d->host_flags & IDE_HFLAG_QD_2ND_PORT) ? 1 : 0;
+
+		ide_init_port_hw(hwif, &hw[j]);
+		if (config)
+			hwif->config_data = config;
+		idx[j] = hwif->index;
 	}
 
-	mate = ide_find_port();
+	if (hwif == NULL && (d->host_flags & IDE_HFLAG_SINGLE))
+		return -ENOENT;
+
+	mate = ide_find_port_slot(d);
 	if (mate) {
 		ide_init_port_hw(mate, &hw[1]);
+		if (config)
+			mate->config_data = config;
 		idx[1] = mate->index;
 	}
 
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -333,10 +333,8 @@ static const struct ide_port_info qd65xx
 
 static int __init qd_probe(int base)
 {
-	ide_hwif_t *hwif;
+	int rc;
 	u8 config, unit;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
 	struct ide_port_info d = qd65xx_port_info;
 
 	config = inb(QD_CONFIG_PORT);
@@ -349,14 +347,6 @@ static int __init qd_probe(int base)
 	if (unit)
 		d.host_flags |= IDE_HFLAG_QD_2ND_PORT;
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
 	if ((config & 0xf0) == QD_CONFIG_QD6500) {
 
 		if (qd_testreg(base))
@@ -376,19 +366,9 @@ static int __init qd_probe(int base)
 		d.port_ops = &qd6500_port_ops;
 		d.host_flags |= IDE_HFLAG_SINGLE;
 
-		hwif = ide_find_port_slot(&d);
-		if (hwif == NULL)
-			return -ENOENT;
-
-		ide_init_port_hw(hwif, &hw[unit]);
-
-		hwif->config_data = (base << 8) | config;
-
-		idx[unit] = hwif->index;
-
-		ide_device_add(idx, &d);
+		rc = ide_legacy_device_add(&d, (base << 8) | config);
 
-		return 1;
+		return (rc == 0) ? 1 : rc;
 	}
 
 	if (((config & 0xf0) == QD_CONFIG_QD6580_A) ||
@@ -418,40 +398,16 @@ static int __init qd_probe(int base)
 
 			d.host_flags |= IDE_HFLAG_SINGLE;
 
-			hwif = ide_find_port_slot(&d);
-			if (hwif == NULL)
-				return -ENOENT;
+			rc = ide_legacy_device_add(&d, (base << 8) | config);
 
-			ide_init_port_hw(hwif, &hw[unit]);
-
-			hwif->config_data = (base << 8) | config;
-
-			idx[unit] = hwif->index;
-
-			ide_device_add(idx, &d);
-
-			return 1;
+			return (rc == 0) ? 1 : rc;
 		} else {
-			ide_hwif_t *mate;
-
 			/* secondary enabled */
 			printk(KERN_INFO "qd6580: dual IDE board\n");
 
-			hwif = ide_find_port();
-			if (hwif) {
-				ide_init_port_hw(hwif, &hw[0]);
-				idx[0] = hwif->index;
-			}
-
-			mate = ide_find_port();
-			if (mate) {
-				ide_init_port_hw(mate, &hw[1]);
-				idx[1] = mate->index;
-			}
-
-			ide_device_add(idx, &d);
+			rc = ide_legacy_device_add(&d, (base << 8) | config);
 
-			return 0; /* no other qd65xx possible */
+			return rc; /* no other qd65xx possible */
 		}
 	}
 	/* no qd65xx found */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1215,7 +1215,7 @@ void ide_undecoded_slave(ide_drive_t *);
 
 int ide_device_add_all(u8 *idx, const struct ide_port_info *);
 int ide_device_add(u8 idx[4], const struct ide_port_info *);
-int ide_legacy_device_add(const struct ide_port_info *);
+int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
 void ide_port_unregister_devices(ide_hwif_t *);
 void ide_port_scan(ide_hwif_t *);
 
