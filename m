Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZG1Ppp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZG1Ppp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZG1Ppl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:45:41 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:19290 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754535AbZG1Pph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:45:37 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI12B-04-65S-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86/oprofile: Fix cast of counter value
Date: Tue, 28 Jul 2009 17:43:05 +0200
Message-ID: <1248795785-29786-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 28 Jul 2009 15:44:36.0995 (UTC) FILETIME=[4FB25D30:01CA0F9A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When casting the counter value to a 64 bit value in 32 bit mode, sign
extension may lead to broken counter values. This patch fixes this by
casting to (u64) instead of (s64).

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    4 ++--
 arch/x86/oprofile/op_model_p4.c  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index e95268e..7ca8306 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -111,7 +111,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 		if (counter_config[i].enabled && msrs->counters[i].addr) {
 			reset_value[i] = counter_config[i].count;
 			wrmsrl(msrs->counters[i].addr,
-			       -(s64)counter_config[i].count);
+			       -(u64)counter_config[i].count);
 			rdmsrl(msrs->controls[i].addr, val);
 			val &= model->reserved;
 			val |= op_x86_get_ctrl(model, &counter_config[i]);
@@ -237,7 +237,7 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 		if (val & OP_CTR_OVERFLOW)
 			continue;
 		oprofile_add_sample(regs, i);
-		wrmsrl(msrs->counters[i].addr, -(s64)reset_value[i]);
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[i]);
 	}
 
 	op_amd_handle_ibs(regs, msrs);
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index f01e53b..9db9e36 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -580,7 +580,7 @@ static void p4_setup_ctrs(struct op_x86_model_spec const *model,
 			reset_value[i] = counter_config[i].count;
 			pmc_setup_one_p4_counter(i);
 			wrmsrl(p4_counters[VIRT_CTR(stag, i)].counter_address,
-			       -(s64)counter_config[i].count);
+			       -(u64)counter_config[i].count);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -625,11 +625,11 @@ static int p4_check_ctrs(struct pt_regs * const regs,
 		if (CCCR_OVF_P(low) || !(ctr & OP_CTR_OVERFLOW)) {
 			oprofile_add_sample(regs, i);
 			wrmsrl(p4_counters[real].counter_address,
-			       -(s64)reset_value[i]);
+			       -(u64)reset_value[i]);
 			CCCR_CLEAR_OVF(low);
 			wrmsr(p4_counters[real].cccr_address, low, high);
 			wrmsrl(p4_counters[real].counter_address,
-			       -(s64)reset_value[i]);
+			       -(u64)reset_value[i]);
 		}
 	}
 
-- 
1.6.3.3


