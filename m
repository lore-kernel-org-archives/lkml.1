Return-Path: <linux-kernel-owner+w=401wt.eu-S1762783AbYBWS7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783AbYBWS7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761149AbYBWS6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:58:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:7301 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956AbYBWS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:58:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PuHkWnAsmjMZF9/tAnZuSlUsHS2XMWXc5MT7QX+dwButbBp9xvu1lleW0bstqv2N+mkhX2UXYpmTTkeHy/2yDx4Ko0AxXGGwcVS6CiCoxF6TKR8l2TLJjXSn7KfIhht42R25UqNngkMQgh5QFf4ypvs+Edg4LUPUI5SptRil5tw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] qd65xx: use IDE_HFLAG_SINGLE host flag
Date: Sat, 23 Feb 2008 20:12:40 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802232012.40791.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Set IDE_HFLAG_SINGLE host flag in qd_probe() for QD6500 and QD6580
  with the second port disabled.

* Check for IDE_HFLAG_SINGLE in qd6580_port_init_devs() instead of
  using cached value of QD6580 Control register.

* Don't cache QD6580 Control register value in hwif->config_data
  (bits 8-15) and remove no longer needed QD_CONTROL() macro.

* Cache QD65xx base address in hwif->config_data (bits 8-15)
  instead of hwif->select_data.

* Set hwif->config_data in qd_probe() and remove qd_setup() helper.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/qd65xx.c |   35 +++++++++++++++--------------------
 drivers/ide/legacy/qd65xx.h |    1 -
 2 files changed, 15 insertions(+), 21 deletions(-)

Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -204,10 +204,11 @@ static void qd6500_set_pio_mode(ide_driv
 
 static void qd6580_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	int base = HWIF(drive)->select_data;
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned int cycle_time;
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
+	u8 base = (hwif->config_data & 0xff00) >> 8;
 
 	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)) {
 		cycle_time = ide_pio_cycle_time(drive, pio);
@@ -278,21 +279,10 @@ static int __init qd_testreg(int port)
 	return (readreg != QD_TESTVAL);
 }
 
-/*
- * qd_setup:
- *
- * called to setup an ata channel : adjusts attributes & links for tuning
- */
-
-static void __init qd_setup(ide_hwif_t *hwif, int base, int config)
-{
-	hwif->select_data = base;
-	hwif->config_data = config;
-}
-
 static void __init qd6500_port_init_devs(ide_hwif_t *hwif)
 {
-	u8 base = hwif->select_data, config = QD_CONFIG(hwif);
+	u8 base = (hwif->config_data & 0xff00) >> 8;
+	u8 config = QD_CONFIG(hwif);
 
 	hwif->drives[0].drive_data = QD6500_DEF_DATA;
 	hwif->drives[1].drive_data = QD6500_DEF_DATA;
@@ -301,9 +291,10 @@ static void __init qd6500_port_init_devs
 static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
 {
 	u16 t1, t2;
-	u8 base = hwif->select_data, config = QD_CONFIG(hwif);
+	u8 base = (hwif->config_data & 0xff00) >> 8;
+	u8 config = QD_CONFIG(hwif);
 
-	if (QD_CONTROL(hwif) & QD_CONTR_SEC_DISABLED) {
+	if (hwif->host_flags & IDE_HFLAG_SINGLE) {
 		t1 = QD6580_DEF_DATA;
 		t2 = QD6580_DEF_DATA2;
 	} else
@@ -370,13 +361,15 @@ static int __init qd_probe(int base)
 		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
 			config, QD_ID3);
 
+		d.host_flags |= IDE_HFLAG_SINGLE;
+
 		hwif = ide_find_port_slot(&d);
 		if (hwif == NULL)
 			return -ENOENT;
 
 		ide_init_port_hw(hwif, &hw[unit]);
 
-		qd_setup(hwif, base, config);
+		hwif->config_data = (base << 8) | config;
 
 		hwif->port_init_devs = qd6500_port_init_devs;
 		hwif->set_pio_mode   = qd6500_set_pio_mode;
@@ -412,13 +405,15 @@ static int __init qd_probe(int base)
 
 			printk(KERN_INFO "qd6580: single IDE board\n");
 
+			d.host_flags |= IDE_HFLAG_SINGLE;
+
 			hwif = ide_find_port_slot(&d);
 			if (hwif == NULL)
 				return -ENOENT;
 
 			ide_init_port_hw(hwif, &hw[unit]);
 
-			qd_setup(hwif, base, config | (control << 8));
+			hwif->config_data = (base << 8) | config;
 
 			hwif->port_init_devs = qd6580_port_init_devs;
 			hwif->set_pio_mode   = qd6580_set_pio_mode;
@@ -438,7 +433,7 @@ static int __init qd_probe(int base)
 			hwif = ide_find_port();
 			if (hwif) {
 				ide_init_port_hw(hwif, &hw[0]);
-				qd_setup(hwif, base, config | (control << 8));
+				hwif->config_data = (base << 8) | config;
 				hwif->port_init_devs = qd6580_port_init_devs;
 				hwif->set_pio_mode   = qd6580_set_pio_mode;
 				hwif->selectproc     = qd65xx_select;
@@ -448,7 +443,7 @@ static int __init qd_probe(int base)
 			mate = ide_find_port();
 			if (mate) {
 				ide_init_port_hw(mate, &hw[1]);
-				qd_setup(mate, base, config | (control << 8));
+				mate->config_data = (base << 8) | config;
 				mate->port_init_devs = qd6580_port_init_devs;
 				mate->set_pio_mode   = qd6580_set_pio_mode;
 				hwif->selectproc     = qd65xx_select;
Index: b/drivers/ide/legacy/qd65xx.h
===================================================================
--- a/drivers/ide/legacy/qd65xx.h
+++ b/drivers/ide/legacy/qd65xx.h
@@ -30,7 +30,6 @@
 #define QD_ID3			((config & QD_CONFIG_ID3)!=0)
 
 #define QD_CONFIG(hwif)		((hwif)->config_data & 0x00ff)
-#define QD_CONTROL(hwif)	(((hwif)->config_data & 0xff00) >> 8)
 
 #define QD_TIMING(drive)	(byte)(((drive)->drive_data) & 0x00ff)
 #define QD_TIMREG(drive)	(byte)((((drive)->drive_data) & 0xff00) >> 8)
