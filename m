Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYCNFUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYCNFUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYCNFUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:20:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYCNFUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gaSa03zAX3H8KikRaQ8V7CJvLF1LNJ872FiNOu0T4GjtYatQ+qSMlOSdiyN16hkMR4DjCBmQeUjN8O1jFL4SPYaOnPc0aUT9E75x+qnyxckcQMzU70C+r0jTRXNTbLVr70YvVAyi6W9NPH90M4hC588puDrggmWKyEE47FJZkMU=
Subject: [PATCH 02/10] ide: eliminate FIT() macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:20:07 -0700
Message-Id: <1205472007.19712.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the FIT() macro with the kernel-provided clamp_val() macro.

FIT was always being called with a member of a struct ide_timing,
which are shorts, and constant constraints for the min and max.

Thus we can use clamp_val, rather than clamp_t.

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
1.5.4.4.653.g7cf1e


