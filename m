Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbYCAUn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbYCAUn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbYCAUnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:28247 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691AbYCAUnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hOQfVzNB0+INS76Rkk4q9ytQlM0MZASQ9iXzlq5dRTfjV2fzg48KYU2O3mW+vocxrUu+M3nu0N4fGwIuhxFkcu+ojvCJLkGo157VfFWSWnyb+IKeEeAhC+tKpPQQHpYSEa7iawrdXl7w4E/68Q75fKUVk6NBVubAWT2gmJJlbqw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: use ide_legacy_device_add() for qd65xx (take 2)
Date: Sat, 1 Mar 2008 18:54:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803011854.24796.bzolnier@gmail.com>
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

v2:
* Update ali14xx, dtc2278, ht6560b and umc8672 host drivers.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c      |   19 ++++++++++----
 drivers/ide/legacy/ali14xx.c |    2 -
 drivers/ide/legacy/dtc2278.c |    2 -
 drivers/ide/legacy/ht6560b.c |    2 -
 drivers/ide/legacy/qd65xx.c  |   58 +++++--------------------------------------
 drivers/ide/legacy/umc8672.c |    2 -
 include/linux/ide.h          |    2 -
 7 files changed, 26 insertions(+), 61 deletions(-)

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
 
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -214,7 +214,7 @@ static int __init ali14xx_probe(void)
 		return 1;
 	}
 
-	return ide_legacy_device_add(&ali14xx_port_info);
+	return ide_legacy_device_add(&ali14xx_port_info, 0);
 }
 
 int probe_ali14xx;
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -125,7 +125,7 @@ static int __init dtc2278_probe(void)
 #endif
 	local_irq_restore(flags);
 
-	return ide_legacy_device_add(&dtc2278_port_info);
+	return ide_legacy_device_add(&dtc2278_port_info, 0);
 }
 
 int probe_dtc2278 = 0;
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -360,7 +360,7 @@ static int __init ht6560b_init(void)
 		goto release_region;
 	}
 
-	return ide_legacy_device_add(&ht6560b_port_info);
+	return ide_legacy_device_add(&ht6560b_port_info, 0);
 
 release_region:
 	release_region(HT_CONFIG_PORT, 1);
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
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -152,7 +152,7 @@ static int __init umc8672_probe(void)
 	umc_set_speeds(current_speeds);
 	local_irq_restore(flags);
 
-	return ide_legacy_device_add(&umc8672_port_info);
+	return ide_legacy_device_add(&umc8672_port_info, 0);
 }
 
 int probe_umc8672;
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
 
