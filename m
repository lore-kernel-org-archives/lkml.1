Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965547Ab0BZRhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:37:35 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:53754 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965521Ab0BZRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:06 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7P-02-2LP-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 14/15] perf, x86: add some IBS macros to perf_event.h
Date: Fri, 26 Feb 2010 18:30:06 +0100
Message-ID: <1267205407-6523-15-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0601 (UTC) FILETIME=[21ACD010:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h |    4 +++-
 arch/x86/oprofile/op_model_amd.c  |    6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 4745f65..237c3d9 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -109,12 +109,14 @@ union cpuid10_edx {
 #define IBS_FETCH_RAND_EN		(1ULL<<57)
 #define IBS_FETCH_VAL			(1ULL<<49)
 #define IBS_FETCH_ENABLE		(1ULL<<48)
-#define IBS_FETCH_CNT_MASK		0xFFFF0000ULL
+#define IBS_FETCH_CNT			0xFFFF0000ULL
+#define IBS_FETCH_MAX_CNT		0x0000FFFFULL
 
 /* IbsOpCtl bits */
 #define IBS_OP_CNT_CTL			(1ULL<<19)
 #define IBS_OP_VAL			(1ULL<<18)
 #define IBS_OP_ENABLE			(1ULL<<17)
+#define IBS_OP_MAX_CNT			0x0000FFFFULL
 
 #ifdef CONFIG_PERF_EVENTS
 extern void init_hw_perf_events(void);
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index c671749..8ddb9fa 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -279,7 +279,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			ctl &= ~(IBS_FETCH_VAL | IBS_FETCH_CNT_MASK);
+			ctl &= ~(IBS_FETCH_VAL | IBS_FETCH_CNT);
 			ctl |= IBS_FETCH_ENABLE;
 			wrmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
 		}
@@ -319,7 +319,7 @@ static inline void op_amd_start_ibs(void)
 		return;
 
 	if (ibs_config.fetch_enabled) {
-		val = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		val = (ibs_config.max_cnt_fetch >> 4) & IBS_FETCH_MAX_CNT;
 		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
 		val |= IBS_FETCH_ENABLE;
 		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
@@ -341,7 +341,7 @@ static inline void op_amd_start_ibs(void)
 			 * avoid underflows.
 			 */
 			ibs_op_ctl = min(ibs_op_ctl + IBS_RANDOM_MAXCNT_OFFSET,
-					 0xFFFFULL);
+					 IBS_OP_MAX_CNT);
 		}
 		if (ibs_caps & IBS_CAPS_OPCNT && ibs_config.dispatched_ops)
 			ibs_op_ctl |= IBS_OP_CNT_CTL;
-- 
1.6.6


