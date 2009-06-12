Return-Path: <linux-kernel-owner+w=401wt.eu-S1763800AbZFLNCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763800AbZFLNCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762649AbZFLM70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:26 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:11957
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762305AbZFLM7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:20 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KL4MQP-03-HWA-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 18/23] x86/oprofile: replace CTR*_IS_RESERVED macros
Date: Fri, 12 Jun 2009 14:35:35 +0200
Message-ID: <1244810140-20595-19-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:08.0279 (UTC) FILETIME=[92B80870:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces all CTR*_IS_RESERVED macros.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |   10 +++++-----
 arch/x86/oprofile/op_model_p4.c   |   10 +++++-----
 arch/x86/oprofile/op_model_ppro.c |   10 +++++-----
 arch/x86/oprofile/op_x86_model.h  |    3 ---
 4 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 4ac9d28..c5c5eec 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -90,7 +90,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0 ; i < NUM_CONTROLS; ++i) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
 		val &= model->reserved;
@@ -99,14 +99,14 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* avoid a false detection of ctr overflows in NMI handler */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->counters[i].addr))
 			continue;
 		wrmsr(msrs->counters[i].addr, -1, -1);
 	}
 
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
+		if (counter_config[i].enabled && msrs->counters[i].addr) {
 			reset_value[i] = counter_config[i].count;
 			wrmsr(msrs->counters[i].addr, -(unsigned int)counter_config[i].count, -1);
 			rdmsrl(msrs->controls[i].addr, val);
@@ -300,11 +300,11 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	int i;
 
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (CTR_IS_RESERVED(msrs, i))
+		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
 	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
-		if (CTRL_IS_RESERVED(msrs, i))
+		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
 }
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index ac4ca28..9db0ca9 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -559,7 +559,7 @@ static void p4_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear the cccrs we will use */
 	for (i = 0 ; i < num_counters ; i++) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 		CCCR_CLEAR(low);
@@ -569,14 +569,14 @@ static void p4_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all escrs (including those outside our concern) */
 	for (i = num_counters; i < num_controls; i++) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		wrmsr(msrs->controls[i].addr, 0, 0);
 	}
 
 	/* setup all counters */
 	for (i = 0 ; i < num_counters ; ++i) {
-		if ((counter_config[i].enabled) && (CTRL_IS_RESERVED(msrs, i))) {
+		if (counter_config[i].enabled && msrs->controls[i].addr) {
 			reset_value[i] = counter_config[i].count;
 			pmc_setup_one_p4_counter(i);
 			wrmsr(p4_counters[VIRT_CTR(stag, i)].counter_address,
@@ -679,7 +679,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	int i;
 
 	for (i = 0 ; i < num_counters ; ++i) {
-		if (CTR_IS_RESERVED(msrs, i))
+		if (msrs->counters[i].addr)
 			release_perfctr_nmi(msrs->counters[i].addr);
 	}
 	/*
@@ -688,7 +688,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	 * This saves a few bits.
 	 */
 	for (i = num_counters ; i < num_controls ; ++i) {
-		if (CTRL_IS_RESERVED(msrs, i))
+		if (msrs->controls[i].addr)
 			release_evntsel_nmi(msrs->controls[i].addr);
 	}
 }
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 566b43f..0a261a5 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -82,7 +82,7 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0 ; i < num_counters; ++i) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
 		val &= model->reserved;
@@ -91,14 +91,14 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* avoid a false detection of ctr overflows in NMI handler */
 	for (i = 0; i < num_counters; ++i) {
-		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->counters[i].addr))
 			continue;
 		wrmsrl(msrs->counters[i].addr, -1LL);
 	}
 
 	/* enable active counters */
 	for (i = 0; i < num_counters; ++i) {
-		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
+		if (counter_config[i].enabled && msrs->counters[i].addr) {
 			reset_value[i] = counter_config[i].count;
 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 			rdmsrl(msrs->controls[i].addr, val);
@@ -181,11 +181,11 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 	int i;
 
 	for (i = 0 ; i < num_counters ; ++i) {
-		if (CTR_IS_RESERVED(msrs, i))
+		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
 	}
 	for (i = 0 ; i < num_counters ; ++i) {
-		if (CTRL_IS_RESERVED(msrs, i))
+		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
 	}
 	if (reset_value) {
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 1c45777..69f1eb4 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -15,9 +15,6 @@
 #include <asm/types.h>
 #include <asm/intel_arch_perfmon.h>
 
-#define CTR_IS_RESERVED(msrs, c)	((msrs)->counters[(c)].addr ? 1 : 0)
-#define CTRL_IS_RESERVED(msrs, c)	((msrs)->controls[(c)].addr ? 1 : 0)
-
 struct op_saved_msr {
 	unsigned int high;
 	unsigned int low;
-- 
1.6.3.1


