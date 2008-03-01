Return-Path: <linux-kernel-owner+w=401wt.eu-S1762732AbYCAUqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762732AbYCAUqH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYCAUnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:28111 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908AbYCAUni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=tOTLbjW79JoyrxvPTLsC+m0DflVwC9S+x1+NBSvmS99Ncv8ANFVqU9zTH7Np9fun9rXjO17db/A7G7BbkNvKYQksjAiytiJqb+u/V9wb29w34bKdfOf70JMT7glzAmrOpr1jcQLekJMzZcOegzlwXvTNcSms+pzbM0euk/m/Qzg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/9] ide: add ide_legacy_init_one() helper
Date: Sat, 1 Mar 2008 19:47:54 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803011947.54984.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the common code for primary/seconary port setup from
ide_legacy_device_add() to ide_legacy_init_one().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   58 ++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1626,40 +1626,50 @@ void ide_port_scan(ide_hwif_t *hwif)
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
 
-int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
+static void ide_legacy_init_one(u8 *idx, hw_regs_t *hw, u8 port_no,
+				const struct ide_port_info *d,
+				unsigned long config)
 {
-	ide_hwif_t *hwif, *mate;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
-
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
+	ide_hwif_t *hwif;
+	unsigned long base, ctl;
+	int irq;
+
+	if (port_no == 0) {
+		base = 0x1f0;
+		ctl  = 0x3f6;
+		irq  = 14;
+	} else {
+		base = 0x170;
+		ctl  = 0x376;
+		irq  = 15;
+	}
 
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
+	ide_std_init_ports(hw, base, ctl);
+	hw->irq = irq;
 
 	hwif = ide_find_port_slot(d);
 	if (hwif) {
-		u8 j = (d->host_flags & IDE_HFLAG_QD_2ND_PORT) ? 1 : 0;
-
-		ide_init_port_hw(hwif, &hw[j]);
+		ide_init_port_hw(hwif, hw);
 		if (config)
 			hwif->config_data = config;
-		idx[j] = hwif->index;
+		idx[port_no] = hwif->index;
 	}
+}
 
-	if (hwif == NULL && (d->host_flags & IDE_HFLAG_SINGLE))
-		return -ENOENT;
+int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
+{
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[2];
 
-	mate = ide_find_port_slot(d);
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		if (config)
-			mate->config_data = config;
-		idx[1] = mate->index;
-	}
+	memset(&hw, 0, sizeof(hw));
+
+	if ((d->host_flags & IDE_HFLAG_QD_2ND_PORT) == 0)
+		ide_legacy_init_one(idx, &hw[0], 0, d, config);
+	ide_legacy_init_one(idx, &hw[1], 1, d, config);
+
+	if (idx[0] == 0xff && idx[1] == 0xff &&
+	    (d->host_flags & IDE_HFLAG_SINGLE))
+		return -ENOENT;
 
 	ide_device_add(idx, d);
 
