Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbZG1PKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbZG1PKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZG1PKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:10:10 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:12288 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753710AbZG1PKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:10:05 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KNHZAQ-02-6PD-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 07/20] EDAC: beef up ErrorCodeExt error signatures
Date: Tue, 28 Jul 2009 17:06:07 +0200
Message-ID: <1248793580-29899-8-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:25.0472 (UTC) FILETIME=[F9D7B400:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   71 ++++++++++++++++++++++--------------------
 1 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index cf84654..918567e 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -63,39 +63,42 @@ const char *ii_msgs[] = {	/* memory or i/o */
 };
 EXPORT_SYMBOL_GPL(ii_msgs);
 
-/* Map the 5 bits of Extended Error code to the string table. */
-const char *ext_msgs[] = {	/* extended error */
-	"K8 ECC error/F10 reserved",	/* 0_0000b */
-	"CRC error",			/* 0_0001b */
-	"sync error",			/* 0_0010b */
-	"mst abort",			/* 0_0011b */
-	"tgt abort",			/* 0_0100b */
-	"GART error",			/* 0_0101b */
-	"RMW error",			/* 0_0110b */
-	"Wdog timer error",		/* 0_0111b */
-	"F10-ECC/K8-Chipkill error",	/* 0_1000b */
-	"DEV Error",			/* 0_1001b */
-	"Link Data error",		/* 0_1010b */
-	"Link or L3 Protocol error",	/* 0_1011b */
-	"NB Array error",		/* 0_1100b */
-	"DRAM Parity error",		/* 0_1101b */
-	"Link Retry/GART Table Walk/DEV Table Walk error", /* 0_1110b */
-	"Res 0x0ff error",		/* 0_1111b */
-	"Res 0x100 error",		/* 1_0000b */
-	"Res 0x101 error",		/* 1_0001b */
-	"Res 0x102 error",		/* 1_0010b */
-	"Res 0x103 error",		/* 1_0011b */
-	"Res 0x104 error",		/* 1_0100b */
-	"Res 0x105 error",		/* 1_0101b */
-	"Res 0x106 error",		/* 1_0110b */
-	"Res 0x107 error",		/* 1_0111b */
-	"Res 0x108 error",		/* 1_1000b */
-	"Res 0x109 error",		/* 1_1001b */
-	"Res 0x10A error",		/* 1_1010b */
-	"Res 0x10B error",		/* 1_1011b */
-	"L3 Cache Data error",		/* 1_1100b */
-	"L3 CacheTag error",		/* 1_1101b */
-	"L3 Cache LRU error",		/* 1_1110b */
-	"Res 0x1FF error"		/* 1_1111b */
+/*
+ * Map the 4 or 5 (family-specific) bits of Extended Error code to the
+ * string table.
+ */
+const char *ext_msgs[] = {
+	"K8 ECC error",					/* 0_0000b */
+	"CRC error on link",				/* 0_0001b */
+	"Sync error packets on link",			/* 0_0010b */
+	"Master Abort during link operation",		/* 0_0011b */
+	"Target Abort during link operation",		/* 0_0100b */
+	"Invalid GART PTE entry during table walk",	/* 0_0101b */
+	"Unsupported atomic RMW command received",	/* 0_0110b */
+	"WDT error: NB transaction timeout",		/* 0_0111b */
+	"ECC/ChipKill ECC error",			/* 0_1000b */
+	"SVM DEV Error",				/* 0_1001b */
+	"Link Data error",				/* 0_1010b */
+	"Link/L3/Probe Filter Protocol error",		/* 0_1011b */
+	"NB Internal Arrays Parity error",		/* 0_1100b */
+	"DRAM Address/Control Parity error",		/* 0_1101b */
+	"Link Transmission error",			/* 0_1110b */
+	"GART/DEV Table Walk Data error"		/* 0_1111b */
+	"Res 0x100 error",				/* 1_0000b */
+	"Res 0x101 error",				/* 1_0001b */
+	"Res 0x102 error",				/* 1_0010b */
+	"Res 0x103 error",				/* 1_0011b */
+	"Res 0x104 error",				/* 1_0100b */
+	"Res 0x105 error",				/* 1_0101b */
+	"Res 0x106 error",				/* 1_0110b */
+	"Res 0x107 error",				/* 1_0111b */
+	"Res 0x108 error",				/* 1_1000b */
+	"Res 0x109 error",				/* 1_1001b */
+	"Res 0x10A error",				/* 1_1010b */
+	"Res 0x10B error",				/* 1_1011b */
+	"ECC error in L3 Cache Data",			/* 1_1100b */
+	"L3 Cache Tag error",				/* 1_1101b */
+	"L3 Cache LRU Parity error",			/* 1_1110b */
+	"Probe Filter error"				/* 1_1111b */
 };
 EXPORT_SYMBOL_GPL(ext_msgs);
-- 
1.6.3.3


