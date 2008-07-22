Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYGVT2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYGVT2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYGVTYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:11 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14086 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbYGVTYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:03 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VC-01-8PN-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 12/24] x86/oprofile: Separating the IBS handler
Date: Tue, 22 Jul 2008 21:08:56 +0200
Message-ID: <1216753748-11261-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0855 (UTC) FILETIME=[723265F0:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |   45 +++++++++++++++++++++-------------
 1 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 229e0b4..a2c8e2e 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -195,27 +195,18 @@ static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 	}
 }
 
-
-static int op_amd_check_ctrs(struct pt_regs * const regs,
-			     struct op_msrs const * const msrs)
+static inline int
+op_amd_handle_ibs(struct pt_regs * const regs,
+		  struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
-	int i;
 	struct ibs_fetch_sample ibs_fetch;
 	struct ibs_op_sample ibs_op;
 
-	for (i = 0 ; i < NUM_COUNTERS; ++i) {
-		if (!reset_value[i])
-			continue;
-		CTR_READ(low, high, msrs, i);
-		if (CTR_OVERFLOWED(low)) {
-			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], msrs, i);
-		}
-	}
+	if (!ibs_allowed)
+		return 1;
 
-	/*If AMD and IBS is available */
-	if (ibs_allowed && ibs_config.fetch_enabled) {
+	if (ibs_config.fetch_enabled) {
 		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 		if (high & IBS_FETCH_VALID_BIT) {
 			ibs_fetch.ibs_fetch_ctl_high = high;
@@ -240,7 +231,7 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
-	if (ibs_allowed && ibs_config.op_enabled) {
+	if (ibs_config.op_enabled) {
 		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
 		if (low & IBS_OP_VALID_BIT) {
 			rdmsr(MSR_AMD64_IBSOPRIP, low, high);
@@ -273,10 +264,30 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
-	/* See op_model_ppro.c */
 	return 1;
 }
 
+static int op_amd_check_ctrs(struct pt_regs * const regs,
+			     struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+
+	for (i = 0 ; i < NUM_COUNTERS; ++i) {
+		if (!reset_value[i])
+			continue;
+		CTR_READ(low, high, msrs, i);
+		if (CTR_OVERFLOWED(low)) {
+			oprofile_add_sample(regs, i);
+			CTR_WRITE(reset_value[i], msrs, i);
+		}
+	}
+
+	op_amd_handle_ibs(regs, msrs);
+
+	/* See op_model_ppro.c */
+	return 1;
+}
 
 static void op_amd_start(struct op_msrs const * const msrs)
 {
-- 
1.5.5.4


