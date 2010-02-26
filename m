Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580Ab0BZRhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:37:31 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48590 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965520Ab0BZRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:06 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz936eMab9bha84eizz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7T-01-R6Q-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/15] oprofile/x86: implement randomization for IBS periodic op counter
Date: Fri, 26 Feb 2010 18:29:59 +0100
Message-ID: <1267205407-6523-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0320 (UTC) FILETIME=[2181EF80:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IBS selects an op (execution operation) for sampling by counting
either cycles or dispatched ops. Better statistical samples can be
produced by adding a software generated random offset to the periodic
op counter value with each sample.

This patch adds software randomization to the IBS periodic op
counter. The lower 12 bits of the 20 bit counter are
randomized. IbsOpCurCnt is initialized with a 12 bit random value.

There is a work around if the hw can not write to IbsOpCurCnt. Then
the lower 8 bits of the 16 bit IbsOpMaxCnt [15:0] value are randomized
in the range of -128 to +127 by adding/subtracting an offset to the
maximum count (IbsOpMaxCnt).

The linear feedback shift register (LFSR) algorithm is used for
pseudo-random number generation to have low impact to the memory
system.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   69 ++++++++++++++++++++++++++++++++++---
 1 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 97c84eb..a9d1947 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -52,7 +52,7 @@ static unsigned long reset_value[NUM_VIRT_COUNTERS];
 #define IBS_FETCH_ENABLE		(1ULL<<48)
 #define IBS_FETCH_CNT_MASK		0xFFFF0000ULL
 
-/*IbsOpCtl bits */
+/* IbsOpCtl bits */
 #define IBS_OP_CNT_CTL			(1ULL<<19)
 #define IBS_OP_VAL			(1ULL<<18)
 #define IBS_OP_ENABLE			(1ULL<<17)
@@ -72,6 +72,7 @@ struct op_ibs_config {
 };
 
 static struct op_ibs_config ibs_config;
+static u64 ibs_op_ctl;
 
 /*
  * IBS cpuid feature detection
@@ -84,8 +85,16 @@ static struct op_ibs_config ibs_config;
  * bit 0 is used to indicate the existence of IBS.
  */
 #define IBS_CAPS_AVAIL			(1LL<<0)
+#define IBS_CAPS_RDWROPCNT		(1LL<<3)
 #define IBS_CAPS_OPCNT			(1LL<<4)
 
+/*
+ * IBS randomization macros
+ */
+#define IBS_RANDOM_BITS			12
+#define IBS_RANDOM_MASK			((1ULL << IBS_RANDOM_BITS) - 1)
+#define IBS_RANDOM_MAXCNT_OFFSET	(1ULL << (IBS_RANDOM_BITS - 5))
+
 static u32 get_ibs_caps(void)
 {
 	u32 ibs_caps;
@@ -241,6 +250,38 @@ static unsigned int lfsr_random(void)
 	return lfsr_value;
 }
 
+/*
+ * IBS software randomization
+ *
+ * The IBS periodic op counter is randomized in software. The lower 12
+ * bits of the 20 bit counter are randomized. IbsOpCurCnt is
+ * initialized with a 12 bit random value.
+ */
+static inline u64 op_amd_randomize_ibs_op(u64 val)
+{
+	unsigned int random = lfsr_random();
+
+	if (!(ibs_caps & IBS_CAPS_RDWROPCNT))
+		/*
+		 * Work around if the hw can not write to IbsOpCurCnt
+		 *
+		 * Randomize the lower 8 bits of the 16 bit
+		 * IbsOpMaxCnt [15:0] value in the range of -128 to
+		 * +127 by adding/subtracting an offset to the
+		 * maximum count (IbsOpMaxCnt).
+		 *
+		 * To avoid over or underflows and protect upper bits
+		 * starting at bit 16, the initial value for
+		 * IbsOpMaxCnt must fit in the range from 0x0081 to
+		 * 0xff80.
+		 */
+		val += (s8)(random >> 4);
+	else
+		val |= (u64)(random & IBS_RANDOM_MASK) << 32;
+
+	return val;
+}
+
 static inline void
 op_amd_handle_ibs(struct pt_regs * const regs,
 		  struct op_msrs const * const msrs)
@@ -290,8 +331,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			ctl &= ~IBS_OP_VAL & 0xFFFFFFFF;
-			ctl |= IBS_OP_ENABLE;
+			ctl = op_amd_randomize_ibs_op(ibs_op_ctl);
 			wrmsrl(MSR_AMD64_IBSOPCTL, ctl);
 		}
 	}
@@ -312,10 +352,27 @@ static inline void op_amd_start_ibs(void)
 	}
 
 	if (ibs_config.op_enabled) {
-		val = (ibs_config.max_cnt_op >> 4) & 0xFFFF;
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
+					 0xFFFFULL);
+		}
 		if (ibs_caps & IBS_CAPS_OPCNT && ibs_config.dispatched_ops)
-			val |= IBS_OP_CNT_CTL;
-		val |= IBS_OP_ENABLE;
+			ibs_op_ctl |= IBS_OP_CNT_CTL;
+		ibs_op_ctl |= IBS_OP_ENABLE;
+		val = op_amd_randomize_ibs_op(ibs_op_ctl);
 		wrmsrl(MSR_AMD64_IBSOPCTL, val);
 	}
 }
-- 
1.6.6


