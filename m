Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbXJ3Piy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbXJ3Piy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXJ3Pir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:38:47 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:51675 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753544AbXJ3Piq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:38:46 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] More CFI fixups for Atmel chips
Date: Tue, 30 Oct 2007 16:33:07 +0100
Message-Id: <1193758387-9325-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Convert CFI tables from Atmel cmdset_0001 chips to Intel format and set
BufWrite timeouts to 0 for Atmel cmdset_0001 and cmdset_0002 chips.
Some chips may indicate support for buffered writes even though they
only support dual-word writes.

The CFI fixup must run before fixup_use_write_buffers for this to work.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
This patch (or some variation of it) has been posted a couple of times
before to the MTD list, and I find myself applying it over and over
again when testing stuff against the latest mainline tree. I'd
appreciate if you could either apply it or thoroughly NAK it, as MTD
on the ATNGW100 board is currently broken.

Håvard

 drivers/mtd/chips/cfi_cmdset_0001.c |   43 +++++++++++++++++++++++++++++++++++
 drivers/mtd/chips/cfi_cmdset_0002.c |    6 ++++-
 2 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index a9eb1c5..da851c2 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -50,6 +50,7 @@
 #define I82802AC	0x00ac
 #define MANUFACTURER_ST         0x0020
 #define M50LPW080       0x002F
+#define AT49BV640D	0x02de
 
 static int cfi_intelext_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int cfi_intelext_write_words(struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
@@ -157,6 +158,47 @@ static void cfi_tell_features(struct cfi_pri_intelext *extp)
 }
 #endif
 
+/* Atmel chips don't use the same PRI format as Intel chips */
+static void fixup_convert_atmel_pri(struct mtd_info *mtd, void *param)
+{
+	struct map_info *map = mtd->priv;
+	struct cfi_private *cfi = map->fldrv_priv;
+	struct cfi_pri_intelext *extp = cfi->cmdset_priv;
+	struct cfi_pri_atmel atmel_pri;
+	uint32_t features = 0;
+
+	/* Reverse byteswapping */
+	extp->FeatureSupport = cpu_to_le32(extp->FeatureSupport);
+	extp->BlkStatusRegMask = cpu_to_le16(extp->BlkStatusRegMask);
+	extp->ProtRegAddr = cpu_to_le16(extp->ProtRegAddr);
+
+	memcpy(&atmel_pri, extp, sizeof(atmel_pri));
+	memset((char *)extp + 5, 0, sizeof(*extp) - 5);
+
+	printk(KERN_ERR "atmel Features: %02x\n", atmel_pri.Features);
+
+	if (atmel_pri.Features & 0x01) /* chip erase supported */
+		features |= (1<<0);
+	if (atmel_pri.Features & 0x02) /* erase suspend supported */
+		features |= (1<<1);
+	if (atmel_pri.Features & 0x04) /* program suspend supported */
+		features |= (1<<2);
+	if (atmel_pri.Features & 0x08) /* simultaneous operations supported */
+		features |= (1<<9);
+	if (atmel_pri.Features & 0x20) /* page mode read supported */
+		features |= (1<<7);
+	if (atmel_pri.Features & 0x40) /* queued erase supported */
+		features |= (1<<4);
+	if (atmel_pri.Features & 0x80) /* Protection bits supported */
+		features |= (1<<6);
+
+	extp->FeatureSupport = features;
+
+	/* burst write mode not supported */
+	cfi->cfiq->BufWriteTimeoutTyp = 0;
+	cfi->cfiq->BufWriteTimeoutMax = 0;
+}
+
 #ifdef CMDSET0001_DISABLE_ERASE_SUSPEND_ON_WRITE
 /* Some Intel Strata Flash prior to FPO revision C has bugs in this area */
 static void fixup_intel_strataflash(struct mtd_info *mtd, void* param)
@@ -234,6 +276,7 @@ static void fixup_use_powerup_lock(struct mtd_info *mtd, void *param)
 }
 
 static struct cfi_fixup cfi_fixup_table[] = {
+	{ CFI_MFR_ATMEL, CFI_ID_ANY, fixup_convert_atmel_pri, NULL },
 #ifdef CMDSET0001_DISABLE_ERASE_SUSPEND_ON_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_intel_strataflash, NULL },
 #endif
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 389acc6..571226e 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -185,6 +185,10 @@ static void fixup_convert_atmel_pri(struct mtd_info *mtd, void *param)
 		extp->TopBottom = 2;
 	else
 		extp->TopBottom = 3;
+
+	/* burst write mode not supported */
+	cfi->cfiq->BufWriteTimeoutTyp = 0;
+	cfi->cfiq->BufWriteTimeoutMax = 0;
 }
 
 static void fixup_use_secsi(struct mtd_info *mtd, void *param)
@@ -217,6 +221,7 @@ static void fixup_use_atmel_lock(struct mtd_info *mtd, void *param)
 }
 
 static struct cfi_fixup cfi_fixup_table[] = {
+	{ CFI_MFR_ATMEL, CFI_ID_ANY, fixup_convert_atmel_pri, NULL },
 #ifdef AMD_BOOTLOC_BUG
 	{ CFI_MFR_AMD, CFI_ID_ANY, fixup_amd_bootblock, NULL },
 #endif
@@ -229,7 +234,6 @@ static struct cfi_fixup cfi_fixup_table[] = {
 #if !FORCE_WORD_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers, NULL, },
 #endif
-	{ CFI_MFR_ATMEL, CFI_ID_ANY, fixup_convert_atmel_pri, NULL },
 	{ 0, 0, NULL, NULL }
 };
 static struct cfi_fixup jedec_fixup_table[] = {
-- 
1.5.3.4

