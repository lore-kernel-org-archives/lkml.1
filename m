Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYI3L5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYI3L5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYI3L5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:57:33 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59759 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbYI3L5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:57:32 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] mtd: AT49BV6416 has swapped erase regions
Date: Tue, 30 Sep 2008 13:55:33 +0200
Message-Id: <1222775733-6690-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 30 Sep 2008 11:55:19.0025 (UTC) FILETIME=[68F7FE10:01C922F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CFI information read from AT49BV6416 lists the erase regions in the
wrong order, causing problems when trying to erase or update the first
or last 64K block.

Work around this by inverting the "top boot" flag, which will
effectively reverse the order of the erase regions.

This chip is obsolete, but it's used in some existing designs.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
I'd like this fix to be applied before 2.6.27. However, it's not a big
deal since the affected regions are write protected on STK1000, which
is the only board I know that's affected by this.

This bug will hurt people who are un-protecting those sectors in order
to reflash the boot loader from Linux.

 drivers/mtd/chips/cfi_cmdset_0002.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index a972cc6..c6c7e75 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -178,10 +178,18 @@ static void fixup_convert_atmel_pri(struct mtd_info *mtd, void *param)
 	if (atmel_pri.Features & 0x02)
 		extp->EraseSuspend = 2;
 
-	if (atmel_pri.BottomBoot)
-		extp->TopBottom = 2;
-	else
-		extp->TopBottom = 3;
+	/* Some chips got it backwards... */
+	if (cfi->id == AT49BV6416) {
+		if (atmel_pri.BottomBoot)
+			extp->TopBottom = 3;
+		else
+			extp->TopBottom = 2;
+	} else {
+		if (atmel_pri.BottomBoot)
+			extp->TopBottom = 2;
+		else
+			extp->TopBottom = 3;
+	}
 
 	/* burst write mode not supported */
 	cfi->cfiq->BufWriteTimeoutTyp = 0;
-- 
1.5.6.5

