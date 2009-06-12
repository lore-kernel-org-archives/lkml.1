Return-Path: <linux-kernel-owner+w=401wt.eu-S1764865AbZFLNPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764865AbZFLNPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762689AbZFLNOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:14:43 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:35513 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763769AbZFLNOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:14:42 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL4MQN-04-6AJ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 16/23] x86/oprofile: replace CTR_OVERFLOWED macros
Date: Fri, 12 Jun 2009 14:35:33 +0200
Message-ID: <1244810140-20595-17-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:07.0889 (UTC) FILETIME=[927C8610:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces all CTR_OVERFLOWED macros. 64 bit MSR functions and
64 bit counter values are used now. Thus, it will be easier to later
extend the models to use more than 32 bit width counters.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |   16 ++++++++--------
 arch/x86/oprofile/op_model_p4.c   |    6 +++---
 arch/x86/oprofile/op_model_ppro.c |   10 ++++------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 2406ab8..b5d678f 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -26,11 +26,10 @@
 #define NUM_COUNTERS 4
 #define NUM_CONTROLS 4
 #define OP_EVENT_MASK			0x0FFF
+#define OP_CTR_OVERFLOW			(1ULL<<31)
 
 #define MSR_AMD_EVENTSEL_RESERVED	((0xFFFFFCF0ULL<<32)|(1ULL<<21))
 
-#define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
-
 static unsigned long reset_value[NUM_COUNTERS];
 
 #ifdef CONFIG_OPROFILE_IBS
@@ -241,17 +240,18 @@ static inline void op_amd_stop_ibs(void) { }
 static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	for (i = 0 ; i < NUM_COUNTERS; ++i) {
 		if (!reset_value[i])
 			continue;
-		rdmsr(msrs->counters[i].addr, low, high);
-		if (CTR_OVERFLOWED(low)) {
-			oprofile_add_sample(regs, i);
-			wrmsr(msrs->counters[i].addr, -(unsigned int)reset_value[i], -1);
-		}
+		rdmsrl(msrs->counters[i].addr, val);
+		/* bit is clear if overflowed: */
+		if (val & OP_CTR_OVERFLOW)
+			continue;
+		oprofile_add_sample(regs, i);
+		wrmsr(msrs->counters[i].addr, -(unsigned int)reset_value[i], -1);
 	}
 
 	op_amd_handle_ibs(regs, msrs);
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 05ba028..ac4ca28 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -32,6 +32,8 @@
 #define NUM_CCCRS_HT2 9
 #define NUM_CONTROLS_HT2 (NUM_ESCRS_HT2 + NUM_CCCRS_HT2)
 
+#define OP_CTR_OVERFLOW			(1ULL<<31)
+
 static unsigned int num_counters = NUM_COUNTERS_NON_HT;
 static unsigned int num_controls = NUM_CONTROLS_NON_HT;
 
@@ -362,8 +364,6 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 #define CCCR_OVF_P(cccr) ((cccr) & (1U<<31))
 #define CCCR_CLEAR_OVF(cccr) ((cccr) &= (~(1U<<31)))
 
-#define CTR_OVERFLOW_P(ctr) (!((ctr) & 0x80000000))
-
 
 /* this assigns a "stagger" to the current CPU, which is used throughout
    the code in this module as an extra array offset, to select the "even"
@@ -622,7 +622,7 @@ static int p4_check_ctrs(struct pt_regs * const regs,
 
 		rdmsr(p4_counters[real].cccr_address, low, high);
 		rdmsr(p4_counters[real].counter_address, ctr, high);
-		if (CCCR_OVF_P(low) || CTR_OVERFLOW_P(ctr)) {
+		if (CCCR_OVF_P(low) || !(ctr & OP_CTR_OVERFLOW)) {
 			oprofile_add_sample(regs, i);
 			wrmsr(p4_counters[real].counter_address,
 			      -(u32)reset_value[i], -1);
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 3092f99..82db396 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -26,8 +26,6 @@
 static int num_counters = 2;
 static int counter_width = 32;
 
-#define CTR_OVERFLOWED(n) (!((n) & (1ULL<<(counter_width-1))))
-
 #define MSR_PPRO_EVENTSEL_RESERVED	((0xFFFFFFFFULL<<32)|(1ULL<<21))
 
 static u64 *reset_value;
@@ -124,10 +122,10 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
-		if (CTR_OVERFLOWED(val)) {
-			oprofile_add_sample(regs, i);
-			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
-		}
+		if (val & (1ULL << (counter_width - 1)))
+			continue;
+		oprofile_add_sample(regs, i);
+		wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 	}
 
 	/* Only P6 based Pentium M need to re-unmask the apic vector but it
-- 
1.6.3.1


