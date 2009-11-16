Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZKPOTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZKPOTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZKPOTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:19:18 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26495 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZKPOQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:25 -0500
X-SpamScore: 2
X-BigFish: VPS2(zza9c5izz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GYZ-02-PYR-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 02/21] amd64_edac: make DRAM regions output more human-readable
Date: Mon, 16 Nov 2009 15:16:29 +0100
Message-ID: <1258381008-18783-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:12.0579 (UTC) FILETIME=[59DEF730:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not shift the TOP_MEM and TOP_MEM2 values by 23 but rather save the
whole 64-bit value read from the MSR. Although the TOP_MEM/TOP_MEM2 bits
are only a subset of the 64bit register, the values are correct since
the remaining bits are Read-As-Zero and no shifting is needed.

Also, cleanup DRAM base/limit debug output.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 0252a61..3408b94 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2399,16 +2399,14 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved bits since
 	 * those are Read-As-Zero
 	 */
-	rdmsrl(MSR_K8_TOP_MEM1, msr_val);
-	pvt->top_mem = msr_val >> 23;
-	debugf0("  TOP_MEM=0x%08llx\n", pvt->top_mem);
+	rdmsrl(MSR_K8_TOP_MEM1, pvt->top_mem);
+	debugf0("  TOP_MEM:  0x%016llx\n", pvt->top_mem);
 
 	/* check first whether TOP_MEM2 is enabled */
 	rdmsrl(MSR_K8_SYSCFG, msr_val);
 	if (msr_val & (1U << 21)) {
-		rdmsrl(MSR_K8_TOP_MEM2, msr_val);
-		pvt->top_mem2 = msr_val >> 23;
-		debugf0("  TOP_MEM2=0x%08llx\n", pvt->top_mem2);
+		rdmsrl(MSR_K8_TOP_MEM2, pvt->top_mem2);
+		debugf0("  TOP_MEM2: 0x%016llx\n", pvt->top_mem2);
 	} else
 		debugf0("  TOP_MEM2 disabled.\n");
 
@@ -2434,13 +2432,12 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 		 * debug output block away.
 		 */
 		if (pvt->dram_rw_en[dram] != 0) {
-			debugf1("  DRAM_BASE[%d]: 0x%8.08x-%8.08x "
-				"DRAM_LIMIT:  0x%8.08x-%8.08x\n",
+			debugf1("  DRAM-BASE[%d]: 0x%016llx "
+				"DRAM-LIMIT:  0x%016llx\n",
 				dram,
-				(u32)(pvt->dram_base[dram] >> 32),
-				(u32)(pvt->dram_base[dram] & 0xFFFFFFFF),
-				(u32)(pvt->dram_limit[dram] >> 32),
-				(u32)(pvt->dram_limit[dram] & 0xFFFFFFFF));
+				pvt->dram_base[dram],
+				pvt->dram_limit[dram]);
+
 			debugf1("        IntlvEn=%s %s %s "
 				"IntlvSel=%d DstNode=%d\n",
 				pvt->dram_IntlvEn[dram] ?
-- 
1.6.4.3


