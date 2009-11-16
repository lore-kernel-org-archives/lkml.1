Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZKPOQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZKPOQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZKPOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:29 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:37663 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZKPOQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:22 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ3-02-PZ0-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 07/21] amd64_edac: cleanup DRAM cfg low debug output
Date: Mon, 16 Nov 2009 15:16:34 +0100
Message-ID: <1258381008-18783-8-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:12.0907 (UTC) FILETIME=[5A1103B0:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carve out the register-specific debug statements into a separate
function, clarify meanings of the single bitfields in the register,
remove irrelevant output and macros.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   65 ++++++++++++++++++++++-----------------------
 drivers/edac/amd64_edac.h |    2 -
 2 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3e5ece6..cdda8d4 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -825,31 +825,42 @@ static enum edac_type amd64_determine_edac_cap(struct amd64_pvt *pvt)
 static void f10_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt,
 					 int ganged);
 
+static void amd64_dump_dramcfg_low(u32 dclr, int chan)
+{
+	debugf1("F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
+
+	debugf1("  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
+		(dclr & BIT(16)) ?  "un" : "",
+		(dclr & BIT(19)) ? "yes" : "no");
+
+	debugf1("  PAR/ERR parity: %s\n",
+		(dclr & BIT(8)) ?  "enabled" : "disabled");
+
+	debugf1("  DCT 128bit mode width: %s\n",
+		(dclr & BIT(11)) ?  "128b" : "64b");
+
+	debugf1("  x4 logical DIMMs present: L0: %s L1: %s L2: %s L3: %s\n",
+		(dclr & BIT(12)) ?  "yes" : "no",
+		(dclr & BIT(13)) ?  "yes" : "no",
+		(dclr & BIT(14)) ?  "yes" : "no",
+		(dclr & BIT(15)) ?  "yes" : "no");
+}
+
 /* Display and decode various NB registers for debug purposes. */
 static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 {
 	int ganged;
 
-	debugf1("  nbcap:0x%8.08x DctDualCap=%s DualNode=%s 8-Node=%s\n",
-		pvt->nbcap,
-		(pvt->nbcap & K8_NBCAP_DCT_DUAL) ? "True" : "False",
-		(pvt->nbcap & K8_NBCAP_DUAL_NODE) ? "True" : "False",
-		(pvt->nbcap & K8_NBCAP_8_NODE) ? "True" : "False");
-	debugf1("    ECC Capable=%s   ChipKill Capable=%s\n",
-		(pvt->nbcap & K8_NBCAP_SECDED) ? "True" : "False",
-		(pvt->nbcap & K8_NBCAP_CHIPKILL) ? "True" : "False");
-	debugf1("  DramCfg0-low=0x%08x DIMM-ECC=%s Parity=%s Width=%s\n",
-		pvt->dclr0,
-		(pvt->dclr0 & BIT(19)) ?  "Enabled" : "Disabled",
-		(pvt->dclr0 & BIT(8)) ?  "Enabled" : "Disabled",
-		(pvt->dclr0 & BIT(11)) ?  "128b" : "64b");
-	debugf1("    DIMM x4 Present: L0=%s L1=%s L2=%s L3=%s  DIMM Type=%s\n",
-		(pvt->dclr0 & BIT(12)) ?  "Y" : "N",
-		(pvt->dclr0 & BIT(13)) ?  "Y" : "N",
-		(pvt->dclr0 & BIT(14)) ?  "Y" : "N",
-		(pvt->dclr0 & BIT(15)) ?  "Y" : "N",
-		(pvt->dclr0 & BIT(16)) ?  "UN-Buffered" : "Buffered");
+	debugf1("F3xE8 (NB Cap): 0x%08x\n", pvt->nbcap);
+
+	debugf1("  NB two channel DRAM capable: %s\n",
+		(pvt->nbcap & K8_NBCAP_DCT_DUAL) ? "yes" : "no");
+
+	debugf1("  ECC capable: %s, ChipKill ECC capable: %s\n",
+		(pvt->nbcap & K8_NBCAP_SECDED) ? "yes" : "no",
+		(pvt->nbcap & K8_NBCAP_CHIPKILL) ? "yes" : "no");
 
+	amd64_dump_dramcfg_low(pvt->dclr0, 0);
 
 	debugf1("  online-spare: 0x%8.08x\n", pvt->online_spare);
 
@@ -877,20 +888,8 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 	}
 
 	/* Only if NOT ganged does dcl1 have valid info */
-	if (!dct_ganging_enabled(pvt)) {
-		debugf1("  DramCfg1-low=0x%08x DIMM-ECC=%s Parity=%s "
-			"Width=%s\n", pvt->dclr1,
-			(pvt->dclr1 & BIT(19)) ?  "Enabled" : "Disabled",
-			(pvt->dclr1 & BIT(8)) ?  "Enabled" : "Disabled",
-			(pvt->dclr1 & BIT(11)) ?  "128b" : "64b");
-		debugf1("    DIMM x4 Present: L0=%s L1=%s L2=%s L3=%s  "
-			"DIMM Type=%s\n",
-			(pvt->dclr1 & BIT(12)) ?  "Y" : "N",
-			(pvt->dclr1 & BIT(13)) ?  "Y" : "N",
-			(pvt->dclr1 & BIT(14)) ?  "Y" : "N",
-			(pvt->dclr1 & BIT(15)) ?  "Y" : "N",
-			(pvt->dclr1 & BIT(16)) ?  "UN-Buffered" : "Buffered");
-	}
+	if (!dct_ganging_enabled(pvt))
+		amd64_dump_dramcfg_low(pvt->dclr1, 1);
 
 	/*
 	 * Determine if ganged and then dump memory sizes for first controller,
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 16f2df4..24e2804 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -384,8 +384,6 @@ enum {
 #define K8_NBCAP_CORES			(BIT(12)|BIT(13))
 #define K8_NBCAP_CHIPKILL		BIT(4)
 #define K8_NBCAP_SECDED			BIT(3)
-#define K8_NBCAP_8_NODE			BIT(2)
-#define K8_NBCAP_DUAL_NODE		BIT(1)
 #define K8_NBCAP_DCT_DUAL		BIT(0)
 
 /* MSRs */
-- 
1.6.4.3


