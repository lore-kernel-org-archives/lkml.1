Return-Path: <linux-kernel-owner+w=401wt.eu-S933702AbZGQAI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbZGQAI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbZGQAI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:08:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39121 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933699AbZGQAFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:54 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 10/21] Blackfin: update handling of anomaly 364 (wrong rev id in BF527-0.1)
Date: Thu, 16 Jul 2009 20:05:35 -0400
Message-Id: <1247789146-18786-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

This anomaly only applies to the BF527-0.1, not the BF526-0.1, and not any
other revision of the BF527.  So make sure we don't go returning 0xffff
for other cases.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/processor.h |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/blackfin/include/asm/processor.h b/arch/blackfin/include/asm/processor.h
index d0be99b..a36ad8d 100644
--- a/arch/blackfin/include/asm/processor.h
+++ b/arch/blackfin/include/asm/processor.h
@@ -105,23 +105,16 @@ static inline uint32_t __pure bfin_revid(void)
 	/* Always use CHIPID, to work around ANOMALY_05000234 */
 	uint32_t revid = (bfin_read_CHIPID() & CHIPID_VERSION) >> 28;
 
-#ifdef CONFIG_BF52x
-	/* ANOMALY_05000357
+#ifdef _BOOTROM_GET_DXE_ADDRESS_TWI
+	/*
+	 * ANOMALY_05000364
 	 * Incorrect Revision Number in DSPID Register
 	 */
-	if (revid == 0)
-		switch (bfin_read16(_BOOTROM_GET_DXE_ADDRESS_TWI)) {
-		case 0x0010:
-			revid = 0;
-			break;
-		case 0x2796:
-			revid = 1;
-			break;
-		default:
-			revid = 0xFFFF;
-			break;
-		}
+	if (ANOMALY_05000364 &&
+	    bfin_read16(_BOOTROM_GET_DXE_ADDRESS_TWI) == 0x2796)
+		revid = 1;
 #endif
+
 	return revid;
 }
 
-- 
1.6.3.3

