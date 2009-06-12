Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbZFLNFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbZFLNFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762831AbZFLM7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:37 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:39758
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762804AbZFLM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:33 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KL4MQQ-04-6AM-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 22/23] x86/oprofile: use 64 bit values in IBS functions
Date: Fri, 12 Jun 2009 14:35:39 +0200
Message-ID: <1244810140-20595-23-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:09.0092 (UTC) FILETIME=[93341640:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IBS code internally uses 32 bit values (a low and a high value) to
represent a 64 bit value. This patch changes this and now 64 bit
values are used instead. 64 bit MSR functions can be used now.

No functional changes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |  131 ++++++++++++++++++--------------------
 1 files changed, 61 insertions(+), 70 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 9bf9017..6493ef7 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -35,16 +35,18 @@ static unsigned long reset_value[NUM_COUNTERS];
 #ifdef CONFIG_OPROFILE_IBS
 
 /* IbsFetchCtl bits/masks */
-#define IBS_FETCH_HIGH_VALID_BIT	(1UL << 17)	/* bit 49 */
-#define IBS_FETCH_HIGH_ENABLE		(1UL << 16)	/* bit 48 */
-#define IBS_FETCH_LOW_MAX_CNT_MASK	0x0000FFFFUL	/* MaxCnt mask */
+#define IBS_FETCH_RAND_EN		(1ULL<<57)
+#define IBS_FETCH_VAL			(1ULL<<49)
+#define IBS_FETCH_ENABLE		(1ULL<<48)
+#define IBS_FETCH_CNT_MASK		0xFFFF0000ULL
 
 /*IbsOpCtl bits */
-#define IBS_OP_LOW_VALID_BIT		(1ULL<<18)	/* bit 18 */
-#define IBS_OP_LOW_ENABLE		(1ULL<<17)	/* bit 17 */
+#define IBS_OP_CNT_CTL			(1ULL<<19)
+#define IBS_OP_VAL			(1ULL<<18)
+#define IBS_OP_ENABLE			(1ULL<<17)
 
-#define IBS_FETCH_SIZE	6
-#define IBS_OP_SIZE	12
+#define IBS_FETCH_SIZE			6
+#define IBS_OP_SIZE			12
 
 static int has_ibs;	/* AMD Family10h and later */
 
@@ -126,66 +128,63 @@ static inline int
 op_amd_handle_ibs(struct pt_regs * const regs,
 		  struct op_msrs const * const msrs)
 {
-	u32 low, high;
-	u64 msr;
+	u64 val, ctl;
 	struct op_entry entry;
 
 	if (!has_ibs)
 		return 1;
 
 	if (ibs_config.fetch_enabled) {
-		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
-		if (high & IBS_FETCH_HIGH_VALID_BIT) {
-			rdmsrl(MSR_AMD64_IBSFETCHLINAD, msr);
-			oprofile_write_reserve(&entry, regs, msr,
+		rdmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
+		if (ctl & IBS_FETCH_VAL) {
+			rdmsrl(MSR_AMD64_IBSFETCHLINAD, val);
+			oprofile_write_reserve(&entry, regs, val,
 					       IBS_FETCH_CODE, IBS_FETCH_SIZE);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			oprofile_add_data(&entry, low);
-			oprofile_add_data(&entry, high);
-			rdmsrl(MSR_AMD64_IBSFETCHPHYSAD, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data(&entry, (u32)val);
+			oprofile_add_data(&entry, (u32)(val >> 32));
+			oprofile_add_data(&entry, (u32)ctl);
+			oprofile_add_data(&entry, (u32)(ctl >> 32));
+			rdmsrl(MSR_AMD64_IBSFETCHPHYSAD, val);
+			oprofile_add_data(&entry, (u32)val);
+			oprofile_add_data(&entry, (u32)(val >> 32));
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			high &= ~IBS_FETCH_HIGH_VALID_BIT;
-			high |= IBS_FETCH_HIGH_ENABLE;
-			low &= IBS_FETCH_LOW_MAX_CNT_MASK;
-			wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+			ctl &= ~(IBS_FETCH_VAL | IBS_FETCH_CNT_MASK);
+			ctl |= IBS_FETCH_ENABLE;
+			wrmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
 		}
 	}
 
 	if (ibs_config.op_enabled) {
-		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
-		if (low & IBS_OP_LOW_VALID_BIT) {
-			rdmsrl(MSR_AMD64_IBSOPRIP, msr);
-			oprofile_write_reserve(&entry, regs, msr,
+		rdmsrl(MSR_AMD64_IBSOPCTL, ctl);
+		if (ctl & IBS_OP_VAL) {
+			rdmsrl(MSR_AMD64_IBSOPRIP, val);
+			oprofile_write_reserve(&entry, regs, val,
 					       IBS_OP_CODE, IBS_OP_SIZE);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSOPDATA, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSOPDATA2, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSOPDATA3, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSDCLINAD, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSDCPHYSAD, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data(&entry, (u32)val);
+			oprofile_add_data(&entry, (u32)(val >> 32));
+			rdmsrl(MSR_AMD64_IBSOPDATA, val);
+			oprofile_add_data(&entry, (u32)val);
+			oprofile_add_data(&entry, (u32)(val >> 32));
+			rdmsrl(MSR_AMD64_IBSOPDATA2, val);
+			oprofile_add_data(&entry, (u32)val);
+			oprofile_add_data(&entry, (u32)(val >> 32));
+			rdmsrl(MSR_AMD64_IBSOPDATA3, val);
+			oprofile_add_data(&entry, (u32)val);
+			oprofile_add_data(&entry, (u32)(val >> 32));
+			rdmsrl(MSR_AMD64_IBSDCLINAD, val);
+			oprofile_add_data(&entry, (u32)val);
+			oprofile_add_data(&entry, (u32)(val >> 32));
+			rdmsrl(MSR_AMD64_IBSDCPHYSAD, val);
+			oprofile_add_data(&entry, (u32)val);
+			oprofile_add_data(&entry, (u32)(val >> 32));
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			high = 0;
-			low &= ~IBS_OP_LOW_VALID_BIT;
-			low |= IBS_OP_LOW_ENABLE;
-			wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+			ctl &= ~IBS_OP_VAL & 0xFFFFFFFF;
+			ctl |= IBS_OP_ENABLE;
+			wrmsrl(MSR_AMD64_IBSOPCTL, ctl);
 		}
 	}
 
@@ -194,39 +193,31 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 
 static inline void op_amd_start_ibs(void)
 {
-	unsigned int low, high;
+	u64 val;
 	if (has_ibs && ibs_config.fetch_enabled) {
-		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
-		high = ((ibs_config.rand_en & 0x1) << 25) /* bit 57 */
-			+ IBS_FETCH_HIGH_ENABLE;
-		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+		val = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
+		val |= IBS_FETCH_ENABLE;
+		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
 	}
 
 	if (has_ibs && ibs_config.op_enabled) {
-		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF)
-			+ ((ibs_config.dispatched_ops & 0x1) << 19) /* bit 19 */
-			+ IBS_OP_LOW_ENABLE;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+		val = (ibs_config.max_cnt_op >> 4) & 0xFFFF;
+		val |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
+		val |= IBS_OP_ENABLE;
+		wrmsrl(MSR_AMD64_IBSOPCTL, val);
 	}
 }
 
 static void op_amd_stop_ibs(void)
 {
-	unsigned int low, high;
-	if (has_ibs && ibs_config.fetch_enabled) {
+	if (has_ibs && ibs_config.fetch_enabled)
 		/* clear max count and enable */
-		low = 0;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
-	}
+		wrmsrl(MSR_AMD64_IBSFETCHCTL, 0);
 
-	if (has_ibs && ibs_config.op_enabled) {
+	if (has_ibs && ibs_config.op_enabled)
 		/* clear max count and enable */
-		low = 0;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
-	}
+		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
 #else
-- 
1.6.3.1


