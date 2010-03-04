Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0CDQtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:49:42 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:39835 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab0CDQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:36 -0500
X-SpamScore: 1
X-BigFish: VPS1(zba6lz936eMab9bha84eizz1202hzzz32i6bh2a8h87h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO26-01-NBN-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 9/9] oprofile/x86: implement perfctr reservation for IBS
Date: Thu, 4 Mar 2010 16:22:11 +0100
Message-ID: <1267716131-17908-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0395 (UTC) FILETIME=[9F45E6B0:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For sharing IBS with oprofile and perf a resource allocation is
needed. This patch implements IBS allocation by extending the perfctr
reservation code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h |    3 +
 arch/x86/oprofile/op_model_amd.c  |  104 +++++++++++++++++++++++++------------
 2 files changed, 74 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 80e6936..2a95e01 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -117,6 +117,9 @@ union cpuid10_edx {
  */
 #define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
 
+#define X86_PMC_IDX_SPECIAL_IBS_FETCH			(X86_PMC_IDX_FIXED + 17)
+#define X86_PMC_IDX_SPECIAL_IBS_OP			(X86_PMC_IDX_FIXED + 18)
+
 /* IbsFetchCtl bits/masks */
 #define IBS_FETCH_RAND_EN		(1ULL<<57)
 #define IBS_FETCH_VAL			(1ULL<<49)
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 9c0d978..9bd040d 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -61,6 +61,7 @@ struct op_ibs_config {
 };
 
 static struct op_ibs_config ibs_config;
+static u64 ibs_fetch_ctl;
 static u64 ibs_op_ctl;
 
 /*
@@ -105,6 +106,63 @@ static u32 get_ibs_caps(void)
 	return ibs_caps;
 }
 
+static void shutdown_ibs(void)
+{
+	if (ibs_fetch_ctl) {
+		ibs_fetch_ctl = 0;
+		release_perfctr(X86_PMC_IDX_SPECIAL_IBS_FETCH);
+	}
+
+	if (ibs_op_ctl) {
+		ibs_op_ctl = 0;
+		release_perfctr(X86_PMC_IDX_SPECIAL_IBS_OP);
+	}
+}
+
+static int setup_ibs(void)
+{
+	ibs_fetch_ctl = 0;
+	if (ibs_caps && ibs_config.fetch_enabled) {
+		if (!reserve_perfctr(X86_PMC_IDX_SPECIAL_IBS_FETCH))
+			goto fail;
+		ibs_fetch_ctl =
+			((ibs_config.max_cnt_fetch >> 4) & IBS_FETCH_MAX_CNT)
+			| (ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0)
+			| IBS_FETCH_ENABLE;
+	}
+
+	ibs_op_ctl = 0;
+	if (ibs_caps && ibs_config.op_enabled) {
+		if (!reserve_perfctr(X86_PMC_IDX_SPECIAL_IBS_OP))
+			goto fail;
+		ibs_op_ctl = ibs_config.max_cnt_op >> 4;
+		if (!(ibs_caps & IBS_CAPS_RDWROPCNT)) {
+			/*
+			 * IbsOpCurCnt not supported.  See
+			 * op_amd_randomize_ibs_op() for details.
+			 */
+			ibs_op_ctl = clamp(ibs_op_ctl, 0x0081ULL, 0xFF80ULL);
+		} else {
+			/*
+			 * The start value is randomized with a
+			 * positive offset, we need to compensate it
+			 * with the half of the randomized range. Also
+			 * avoid underflows.
+			 */
+			ibs_op_ctl = min(ibs_op_ctl + IBS_RANDOM_MAXCNT_OFFSET,
+					 IBS_OP_MAX_CNT);
+		}
+		if (ibs_caps & IBS_CAPS_OPCNT && ibs_config.dispatched_ops)
+			ibs_op_ctl |= IBS_OP_CNT_CTL;
+		ibs_op_ctl |= IBS_OP_ENABLE;
+	}
+
+	return 0;
+fail:
+	shutdown_ibs();
+	return -EBUSY;
+}
+
 /*
  * 16-bit Linear Feedback Shift Register (LFSR)
  *
@@ -170,7 +228,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	if (!ibs_caps)
 		return;
 
-	if (ibs_config.fetch_enabled) {
+	if (ibs_fetch_ctl) {
 		rdmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
 		if (ctl & IBS_FETCH_VAL) {
 			rdmsrl(MSR_AMD64_IBSFETCHLINAD, val);
@@ -183,13 +241,11 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			ctl &= ~(IBS_FETCH_VAL | IBS_FETCH_CNT);
-			ctl |= IBS_FETCH_ENABLE;
-			wrmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
+			wrmsrl(MSR_AMD64_IBSFETCHCTL, ibs_fetch_ctl);
 		}
 	}
 
-	if (ibs_config.op_enabled) {
+	if (ibs_op_ctl) {
 		rdmsrl(MSR_AMD64_IBSOPCTL, ctl);
 		if (ctl & IBS_OP_VAL) {
 			rdmsrl(MSR_AMD64_IBSOPRIP, val);
@@ -222,34 +278,10 @@ static inline void op_amd_start_ibs(void)
 	if (!ibs_caps)
 		return;
 
-	if (ibs_config.fetch_enabled) {
-		val = (ibs_config.max_cnt_fetch >> 4) & IBS_FETCH_MAX_CNT;
-		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
-		val |= IBS_FETCH_ENABLE;
-		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
-	}
+	if (ibs_fetch_ctl)
+		wrmsrl(MSR_AMD64_IBSFETCHCTL, ibs_fetch_ctl);
 
-	if (ibs_config.op_enabled) {
-		ibs_op_ctl = ibs_config.max_cnt_op >> 4;
-		if (!(ibs_caps & IBS_CAPS_RDWROPCNT)) {
-			/*
-			 * IbsOpCurCnt not supported.  See
-			 * op_amd_randomize_ibs_op() for details.
-			 */
-			ibs_op_ctl = clamp(ibs_op_ctl, 0x0081ULL, 0xFF80ULL);
-		} else {
-			/*
-			 * The start value is randomized with a
-			 * positive offset, we need to compensate it
-			 * with the half of the randomized range. Also
-			 * avoid underflows.
-			 */
-			ibs_op_ctl = min(ibs_op_ctl + IBS_RANDOM_MAXCNT_OFFSET,
-					 IBS_OP_MAX_CNT);
-		}
-		if (ibs_caps & IBS_CAPS_OPCNT && ibs_config.dispatched_ops)
-			ibs_op_ctl |= IBS_OP_CNT_CTL;
-		ibs_op_ctl |= IBS_OP_ENABLE;
+	if (ibs_op_ctl) {
 		val = op_amd_randomize_ibs_op(ibs_op_ctl);
 		wrmsrl(MSR_AMD64_IBSOPCTL, val);
 	}
@@ -297,7 +329,11 @@ static void op_amd_shutdown(struct op_msrs const * const msrs);
 
 static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
 {
-	int i;
+	int err, i;
+
+	err = setup_ibs();
+	if (err)
+		return err;
 
 	for (i = 0; i < NUM_COUNTERS; i++) {
 		if (reserve_perfctr(i)) {
@@ -438,6 +474,8 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 		if (msrs->counters[i].addr)
 			release_perfctr(i);
 	}
+
+	shutdown_ibs();
 }
 
 static u8 ibs_eilvt_off;
-- 
1.7.0


