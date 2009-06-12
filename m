Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbZFLNGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbZFLNGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762812AbZFLM7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:50 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:3845 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762803AbZFLM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:48 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KL4MQK-04-6AE-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/23] x86/oprofile: remove #ifdefs in ibs functions
Date: Fri, 12 Jun 2009 14:35:23 +0200
Message-ID: <1244810140-20595-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:05.0873 (UTC) FILETIME=[9148E810:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IBS code is moved to separate functions. This allows the removal
of #ifdefs in functions.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   80 ++++++++++++++++++++++----------------
 1 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 8fdf06e..b54c088 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -220,6 +220,50 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	return 1;
 }
 
+static inline void op_amd_start_ibs(void)
+{
+	unsigned int low, high;
+	if (has_ibs && ibs_config.fetch_enabled) {
+		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		high = ((ibs_config.rand_en & 0x1) << 25) /* bit 57 */
+			+ IBS_FETCH_HIGH_ENABLE;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (has_ibs && ibs_config.op_enabled) {
+		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF)
+			+ ((ibs_config.dispatched_ops & 0x1) << 19) /* bit 19 */
+			+ IBS_OP_LOW_ENABLE;
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
+}
+
+static void op_amd_stop_ibs(void)
+{
+	unsigned int low, high;
+	if (has_ibs && ibs_config.fetch_enabled) {
+		/* clear max count and enable */
+		low = 0;
+		high = 0;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (has_ibs && ibs_config.op_enabled) {
+		/* clear max count and enable */
+		low = 0;
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
+}
+
+#else
+
+static inline int op_amd_handle_ibs(struct pt_regs * const regs,
+				    struct op_msrs const * const msrs) { }
+static inline void op_amd_start_ibs(void) { }
+static inline void op_amd_stop_ibs(void) { }
+
 #endif
 
 static int op_amd_check_ctrs(struct pt_regs * const regs,
@@ -238,9 +282,7 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
-#ifdef CONFIG_OPROFILE_IBS
 	op_amd_handle_ibs(regs, msrs);
-#endif
 
 	/* See op_model_ppro.c */
 	return 1;
@@ -258,25 +300,9 @@ static void op_amd_start(struct op_msrs const * const msrs)
 		}
 	}
 
-#ifdef CONFIG_OPROFILE_IBS
-	if (has_ibs && ibs_config.fetch_enabled) {
-		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
-		high = ((ibs_config.rand_en & 0x1) << 25) /* bit 57 */
-			+ IBS_FETCH_HIGH_ENABLE;
-		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
-	}
-
-	if (has_ibs && ibs_config.op_enabled) {
-		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF)
-			+ ((ibs_config.dispatched_ops & 0x1) << 19) /* bit 19 */
-			+ IBS_OP_LOW_ENABLE;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
-	}
-#endif
+	op_amd_start_ibs();
 }
 
-
 static void op_amd_stop(struct op_msrs const * const msrs)
 {
 	unsigned int low, high;
@@ -294,21 +320,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 		CTRL_WRITE(low, high, msrs, i);
 	}
 
-#ifdef CONFIG_OPROFILE_IBS
-	if (has_ibs && ibs_config.fetch_enabled) {
-		/* clear max count and enable */
-		low = 0;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
-	}
-
-	if (has_ibs && ibs_config.op_enabled) {
-		/* clear max count and enable */
-		low = 0;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
-	}
-#endif
+	op_amd_stop_ibs();
 }
 
 static void op_amd_shutdown(struct op_msrs const * const msrs)
-- 
1.6.3.1


