Return-Path: <linux-kernel-owner+w=401wt.eu-S1763657AbZFLNB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763657AbZFLNB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZFLM7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:22 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:27085 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZFLM7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:19 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i17ch43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KL4MQO-03-HW9-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 17/23] x86/oprofile: replace CTRL_SET_*ACTIVE macros
Date: Fri, 12 Jun 2009 14:35:34 +0200
Message-ID: <1244810140-20595-18-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:08.0061 (UTC) FILETIME=[9296C4D0:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces all CTRL_SET_*ACTIVE macros. 64 bit MSR functions
and 64 bit counter values are used now. The code uses bit masks from
<asm/intel_arch_perfmon.h>.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |   16 ++++++++--------
 arch/x86/oprofile/op_model_ppro.c |   16 ++++++++--------
 arch/x86/oprofile/op_x86_model.h  |    2 --
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index b5d678f..4ac9d28 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -262,13 +262,13 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 
 static void op_amd_start(struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (reset_value[i]) {
-			rdmsr(msrs->controls[i].addr, low, high);
-			CTRL_SET_ACTIVE(low);
-			wrmsr(msrs->controls[i].addr, low, high);
+			rdmsrl(msrs->controls[i].addr, val);
+			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+			wrmsrl(msrs->controls[i].addr, val);
 		}
 	}
 
@@ -277,7 +277,7 @@ static void op_amd_start(struct op_msrs const * const msrs)
 
 static void op_amd_stop(struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	/*
@@ -287,9 +287,9 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (!reset_value[i])
 			continue;
-		rdmsr(msrs->controls[i].addr, low, high);
-		CTRL_SET_INACTIVE(low);
-		wrmsr(msrs->controls[i].addr, low, high);
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
 	op_amd_stop_ibs();
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 82db396..566b43f 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -145,16 +145,16 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 
 static void ppro_start(struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	if (!reset_value)
 		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
-			rdmsr(msrs->controls[i].addr, low, high);
-			CTRL_SET_ACTIVE(low);
-			wrmsr(msrs->controls[i].addr, low, high);
+			rdmsrl(msrs->controls[i].addr, val);
+			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+			wrmsrl(msrs->controls[i].addr, val);
 		}
 	}
 }
@@ -162,7 +162,7 @@ static void ppro_start(struct op_msrs const * const msrs)
 
 static void ppro_stop(struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	if (!reset_value)
@@ -170,9 +170,9 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		rdmsr(msrs->controls[i].addr, low, high);
-		CTRL_SET_INACTIVE(low);
-		wrmsr(msrs->controls[i].addr, low, high);
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 }
 
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 3220d4c..1c45777 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -17,8 +17,6 @@
 
 #define CTR_IS_RESERVED(msrs, c)	((msrs)->counters[(c)].addr ? 1 : 0)
 #define CTRL_IS_RESERVED(msrs, c)	((msrs)->controls[(c)].addr ? 1 : 0)
-#define CTRL_SET_ACTIVE(val)		((val) |= ARCH_PERFMON_EVENTSEL0_ENABLE)
-#define CTRL_SET_INACTIVE(val)		((val) &= ~ARCH_PERFMON_EVENTSEL0_ENABLE)
 
 struct op_saved_msr {
 	unsigned int high;
-- 
1.6.3.1


