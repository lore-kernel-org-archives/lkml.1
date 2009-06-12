Return-Path: <linux-kernel-owner+w=401wt.eu-S1764393AbZFLNDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764393AbZFLNDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762784AbZFLM7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:30 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:42111
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762548AbZFLM72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:28 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KL4MQK-04-6AD-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/23] x86/oprofile: remove MSR macros for AMD cpus
Date: Fri, 12 Jun 2009 14:35:26 +0200
Message-ID: <1244810140-20595-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:06.0483 (UTC) FILETIME=[91A5FC30:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros CTRL_READ() and CTRL_WRITE() make the code hard to read and
maintain. This patch replaces them by rdmsr()/wrmsr() functions and
simplifies the code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 4b9254a..c6181c2 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -26,12 +26,7 @@
 #define NUM_COUNTERS 4
 #define NUM_CONTROLS 4
 
-#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
-#define CTR_WRITE(l, msrs, c) do {wrmsr(msrs->counters[(c)].addr, -(unsigned int)(l), -1); } while (0)
 #define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
-
-#define CTRL_READ(l, h, msrs, c) do {rdmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
-#define CTRL_WRITE(l, h, msrs, c) do {wrmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
 #define CTRL_CLEAR_LO(x) (x &= (1<<21))
 #define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
 #define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
@@ -101,17 +96,17 @@ static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 	for (i = 0 ; i < NUM_CONTROLS; ++i) {
 		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
 			continue;
-		CTRL_READ(low, high, msrs, i);
+		rdmsr(msrs->controls[i].addr, low, high);
 		CTRL_CLEAR_LO(low);
 		CTRL_CLEAR_HI(high);
-		CTRL_WRITE(low, high, msrs, i);
+		wrmsr(msrs->controls[i].addr, low, high);
 	}
 
 	/* avoid a false detection of ctr overflows in NMI handler */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
 			continue;
-		CTR_WRITE(1, msrs, i);
+		wrmsr(msrs->counters[i].addr, -1, -1);
 	}
 
 	/* enable active counters */
@@ -119,9 +114,9 @@ static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
 			reset_value[i] = counter_config[i].count;
 
-			CTR_WRITE(counter_config[i].count, msrs, i);
+			wrmsr(msrs->counters[i].addr, -(unsigned int)counter_config[i].count, -1);
 
-			CTRL_READ(low, high, msrs, i);
+			rdmsr(msrs->controls[i].addr, low, high);
 			CTRL_CLEAR_LO(low);
 			CTRL_CLEAR_HI(high);
 			CTRL_SET_ENABLE(low);
@@ -133,7 +128,7 @@ static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 			CTRL_SET_HOST_ONLY(high, 0);
 			CTRL_SET_GUEST_ONLY(high, 0);
 
-			CTRL_WRITE(low, high, msrs, i);
+			wrmsr(msrs->controls[i].addr, low, high);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -267,10 +262,10 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 	for (i = 0 ; i < NUM_COUNTERS; ++i) {
 		if (!reset_value[i])
 			continue;
-		CTR_READ(low, high, msrs, i);
+		rdmsr(msrs->counters[i].addr, low, high);
 		if (CTR_OVERFLOWED(low)) {
 			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], msrs, i);
+			wrmsr(msrs->counters[i].addr, -(unsigned int)reset_value[i], -1);
 		}
 	}
 
@@ -286,9 +281,9 @@ static void op_amd_start(struct op_msrs const * const msrs)
 	int i;
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (reset_value[i]) {
-			CTRL_READ(low, high, msrs, i);
+			rdmsr(msrs->controls[i].addr, low, high);
 			CTRL_SET_ACTIVE(low);
-			CTRL_WRITE(low, high, msrs, i);
+			wrmsr(msrs->controls[i].addr, low, high);
 		}
 	}
 
@@ -307,9 +302,9 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (!reset_value[i])
 			continue;
-		CTRL_READ(low, high, msrs, i);
+		rdmsr(msrs->controls[i].addr, low, high);
 		CTRL_SET_INACTIVE(low);
-		CTRL_WRITE(low, high, msrs, i);
+		wrmsr(msrs->controls[i].addr, low, high);
 	}
 
 	op_amd_stop_ibs();
-- 
1.6.3.1


