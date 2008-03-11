Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYCKVNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYCKVNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYCKVML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:12:11 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:35320 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030AbYCKVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BOPLajHORjePV6Q5/GPzrFxUCQcRNpbtTvJLOLBd2lU7A3Sn6pAJGz7W4zZgoVVZ94PGOjFaK76lZDHKK4MdYX2d9j2za0Z7tW0r1Im0QU0NMNaPUnhAzYXxBims/+emnbKMDoiy9ySSjmRHVBSFQr4icHOBgZNnk4mkUSp+KIM=
Subject: [PATCH 4/6] ide: use clamp_val macro instead of FIT macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 14:12:00 -0700
Message-Id: <1205269920.22317.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the kernel-provided clamp_val macro rather than an ide-specific
FIT macro.  FIT() was always called with constant range arguments
which makes this safe.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ide/ide-timing.h    |    1 -
 drivers/ide/pci/amd74xx.c   |   14 +++++++-------
 drivers/ide/pci/via82cxxx.c |   14 +++++++-------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/ide/ide-timing.h b/drivers/ide/ide-timing.h
index 3b12ffe..2e91c58 100644
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -95,7 +95,6 @@ static struct ide_timing ide_timing[] = {
 #define IDE_TIMING_UDMA		0x80
 #define IDE_TIMING_ALL		0xff
 
-#define FIT(v,vmin,vmax)	max_t(short,min_t(short,v,vmax),vmin)
 #define ENOUGH(v,unit)		(((v)-1)/(unit)+1)
 #define EZ(v,unit)		((v)?ENOUGH(v,unit):0)
 
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 2ef890c..b5f9194 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -53,20 +53,20 @@ static void amd_set_speed(struct pci_dev *dev, u8 dn, u8 udma_mask,
 	u8 t = 0, offset = amd_offset(dev);
 
 	pci_read_config_byte(dev, AMD_ADDRESS_SETUP + offset, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
+	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
 	pci_write_config_byte(dev, AMD_ADDRESS_SETUP + offset, t);
 
 	pci_write_config_byte(dev, AMD_8BIT_TIMING + offset + (1 - (dn >> 1)),
-		((FIT(timing->act8b, 1, 16) - 1) << 4) | (FIT(timing->rec8b, 1, 16) - 1));
+		((clamp_val(timing->act8b, 1, 16) - 1) << 4) | (clamp_val(timing->rec8b, 1, 16) - 1));
 
 	pci_write_config_byte(dev, AMD_DRIVE_TIMING + offset + (3 - dn),
-		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
+		((clamp_val(timing->active, 1, 16) - 1) << 4) | (clamp_val(timing->recover, 1, 16) - 1));
 
 	switch (udma_mask) {
-	case ATA_UDMA2: t = timing->udma ? (0xc0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
-	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 2, 10)]) : 0x03; break;
-	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 10)]) : 0x03; break;
-	case ATA_UDMA6: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 15)]) : 0x03; break;
+	case ATA_UDMA2: t = timing->udma ? (0xc0 | (clamp_val(timing->udma, 2, 5) - 2)) : 0x03; break;
+	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 2, 10)]) : 0x03; break;
+	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 1, 10)]) : 0x03; break;
+	case ATA_UDMA6: t = timing->udma ? (0xc0 | amd_cyc2udma[clamp_val(timing->udma, 1, 15)]) : 0x03; break;
 	default: return;
 	}
 
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 9004e75..8665048 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -120,21 +120,21 @@ static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
 
 	if (~vdev->via_config->flags & VIA_BAD_AST) {
 		pci_read_config_byte(dev, VIA_ADDRESS_SETUP, &t);
-		t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
+		t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
 		pci_write_config_byte(dev, VIA_ADDRESS_SETUP, t);
 	}
 
 	pci_write_config_byte(dev, VIA_8BIT_TIMING + (1 - (dn >> 1)),
-		((FIT(timing->act8b, 1, 16) - 1) << 4) | (FIT(timing->rec8b, 1, 16) - 1));
+		((clamp_val(timing->act8b, 1, 16) - 1) << 4) | (clamp_val(timing->rec8b, 1, 16) - 1));
 
 	pci_write_config_byte(dev, VIA_DRIVE_TIMING + (3 - dn),
-		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
+		((clamp_val(timing->active, 1, 16) - 1) << 4) | (clamp_val(timing->recover, 1, 16) - 1));
 
 	switch (vdev->via_config->udma_mask) {
-	case ATA_UDMA2: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
-	case ATA_UDMA4: t = timing->udma ? (0xe8 | (FIT(timing->udma, 2, 9) - 2)) : 0x0f; break;
-	case ATA_UDMA5: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
-	case ATA_UDMA6: t = timing->udma ? (0xe0 | (FIT(timing->udma, 2, 9) - 2)) : 0x07; break;
+	case ATA_UDMA2: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 5) - 2)) : 0x03; break;
+	case ATA_UDMA4: t = timing->udma ? (0xe8 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x0f; break;
+	case ATA_UDMA5: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
+	case ATA_UDMA6: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
 	default: return;
 	}
 
-- 
1.5.4.4.592.g32d4c


