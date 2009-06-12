Return-Path: <linux-kernel-owner+w=401wt.eu-S1764305AbZFLNDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764305AbZFLNDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762763AbZFLM73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:29 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:14331 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762486AbZFLM7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:24 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j)
X-FB-SS: 5,
X-WSS-ID: 0KL4MQO-04-6AL-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 19/23] x86/oprofile: use 64 bit wrmsr functions
Date: Fri, 12 Jun 2009 14:35:36 +0200
Message-ID: <1244810140-20595-20-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:08.0483 (UTC) FILETIME=[92D72930:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces some wrmsr() functions with wrmsrl().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    7 ++++---
 arch/x86/oprofile/op_model_p4.c  |   12 ++++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index c5c5eec..9bf9017 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -101,14 +101,15 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (unlikely(!msrs->counters[i].addr))
 			continue;
-		wrmsr(msrs->counters[i].addr, -1, -1);
+		wrmsrl(msrs->counters[i].addr, -1LL);
 	}
 
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (counter_config[i].enabled && msrs->counters[i].addr) {
 			reset_value[i] = counter_config[i].count;
-			wrmsr(msrs->counters[i].addr, -(unsigned int)counter_config[i].count, -1);
+			wrmsrl(msrs->counters[i].addr,
+			       -(s64)counter_config[i].count);
 			rdmsrl(msrs->controls[i].addr, val);
 			val &= model->reserved;
 			val |= op_x86_get_ctrl(model, &counter_config[i]);
@@ -251,7 +252,7 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 		if (val & OP_CTR_OVERFLOW)
 			continue;
 		oprofile_add_sample(regs, i);
-		wrmsr(msrs->counters[i].addr, -(unsigned int)reset_value[i], -1);
+		wrmsrl(msrs->counters[i].addr, -(s64)reset_value[i]);
 	}
 
 	op_amd_handle_ibs(regs, msrs);
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 9db0ca9..f01e53b 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -579,8 +579,8 @@ static void p4_setup_ctrs(struct op_x86_model_spec const *model,
 		if (counter_config[i].enabled && msrs->controls[i].addr) {
 			reset_value[i] = counter_config[i].count;
 			pmc_setup_one_p4_counter(i);
-			wrmsr(p4_counters[VIRT_CTR(stag, i)].counter_address,
-			      -(u32)counter_config[i].count, -1);
+			wrmsrl(p4_counters[VIRT_CTR(stag, i)].counter_address,
+			       -(s64)counter_config[i].count);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -624,12 +624,12 @@ static int p4_check_ctrs(struct pt_regs * const regs,
 		rdmsr(p4_counters[real].counter_address, ctr, high);
 		if (CCCR_OVF_P(low) || !(ctr & OP_CTR_OVERFLOW)) {
 			oprofile_add_sample(regs, i);
-			wrmsr(p4_counters[real].counter_address,
-			      -(u32)reset_value[i], -1);
+			wrmsrl(p4_counters[real].counter_address,
+			       -(s64)reset_value[i]);
 			CCCR_CLEAR_OVF(low);
 			wrmsr(p4_counters[real].cccr_address, low, high);
-			wrmsr(p4_counters[real].counter_address,
-			      -(u32)reset_value[i], -1);
+			wrmsrl(p4_counters[real].counter_address,
+			       -(s64)reset_value[i]);
 		}
 	}
 
-- 
1.6.3.1


