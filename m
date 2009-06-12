Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbZFLNEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbZFLNEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761484AbZFLM7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:31 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:46674
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762726AbZFLM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:29 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KL4MQL-04-6AG-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/23] x86/oprofile: remove MSR macros for p4 cpus
Date: Fri, 12 Jun 2009 14:35:28 +0200
Message-ID: <1244810140-20595-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:06.0795 (UTC) FILETIME=[91D597B0:01C9EB5D]
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
 arch/x86/oprofile/op_model_p4.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 420c15e..365d8a9 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -350,8 +350,6 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 #define ESCR_SET_OS_1(escr, os) ((escr) |= (((os) & 1) << 1))
 #define ESCR_SET_EVENT_SELECT(escr, sel) ((escr) |= (((sel) & 0x3f) << 25))
 #define ESCR_SET_EVENT_MASK(escr, mask) ((escr) |= (((mask) & 0xffff) << 9))
-#define ESCR_READ(escr, high, ev, i) do {rdmsr(ev->bindings[(i)].escr_address, (escr), (high)); } while (0)
-#define ESCR_WRITE(escr, high, ev, i) do {wrmsr(ev->bindings[(i)].escr_address, (escr), (high)); } while (0)
 
 #define CCCR_RESERVED_BITS 0x38030FFF
 #define CCCR_CLEAR(cccr) ((cccr) &= CCCR_RESERVED_BITS)
@@ -361,13 +359,9 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 #define CCCR_SET_PMI_OVF_1(cccr) ((cccr) |= (1<<27))
 #define CCCR_SET_ENABLE(cccr) ((cccr) |= (1<<12))
 #define CCCR_SET_DISABLE(cccr) ((cccr) &= ~(1<<12))
-#define CCCR_READ(low, high, i) do {rdmsr(p4_counters[(i)].cccr_address, (low), (high)); } while (0)
-#define CCCR_WRITE(low, high, i) do {wrmsr(p4_counters[(i)].cccr_address, (low), (high)); } while (0)
 #define CCCR_OVF_P(cccr) ((cccr) & (1U<<31))
 #define CCCR_CLEAR_OVF(cccr) ((cccr) &= (~(1U<<31)))
 
-#define CTR_READ(l, h, i) do {rdmsr(p4_counters[(i)].counter_address, (l), (h)); } while (0)
-#define CTR_WRITE(l, i) do {wrmsr(p4_counters[(i)].counter_address, -(u32)(l), -1); } while (0)
 #define CTR_OVERFLOW_P(ctr) (!((ctr) & 0x80000000))
 
 
@@ -513,7 +507,7 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 		if (ev->bindings[i].virt_counter & counter_bit) {
 
 			/* modify ESCR */
-			ESCR_READ(escr, high, ev, i);
+			rdmsr(ev->bindings[i].escr_address, escr, high);
 			ESCR_CLEAR(escr);
 			if (stag == 0) {
 				ESCR_SET_USR_0(escr, counter_config[ctr].user);
@@ -524,10 +518,11 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 			}
 			ESCR_SET_EVENT_SELECT(escr, ev->event_select);
 			ESCR_SET_EVENT_MASK(escr, counter_config[ctr].unit_mask);
-			ESCR_WRITE(escr, high, ev, i);
+			wrmsr(ev->bindings[i].escr_address, escr, high);
 
 			/* modify CCCR */
-			CCCR_READ(cccr, high, VIRT_CTR(stag, ctr));
+			rdmsr(p4_counters[VIRT_CTR(stag, ctr)].cccr_address,
+			      cccr, high);
 			CCCR_CLEAR(cccr);
 			CCCR_SET_REQUIRED_BITS(cccr);
 			CCCR_SET_ESCR_SELECT(cccr, ev->escr_select);
@@ -535,7 +530,8 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 				CCCR_SET_PMI_OVF_0(cccr);
 			else
 				CCCR_SET_PMI_OVF_1(cccr);
-			CCCR_WRITE(cccr, high, VIRT_CTR(stag, ctr));
+			wrmsr(p4_counters[VIRT_CTR(stag, ctr)].cccr_address,
+			      cccr, high);
 			return;
 		}
 	}
@@ -582,7 +578,8 @@ static void p4_setup_ctrs(struct op_msrs const * const msrs)
 		if ((counter_config[i].enabled) && (CTRL_IS_RESERVED(msrs, i))) {
 			reset_value[i] = counter_config[i].count;
 			pmc_setup_one_p4_counter(i);
-			CTR_WRITE(counter_config[i].count, VIRT_CTR(stag, i));
+			wrmsr(p4_counters[VIRT_CTR(stag, i)].counter_address,
+			      -(u32)counter_config[i].count, -1);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -622,14 +619,16 @@ static int p4_check_ctrs(struct pt_regs * const regs,
 
 		real = VIRT_CTR(stag, i);
 
-		CCCR_READ(low, high, real);
-		CTR_READ(ctr, high, real);
+		rdmsr(p4_counters[real].cccr_address, low, high);
+		rdmsr(p4_counters[real].counter_address, ctr, high);
 		if (CCCR_OVF_P(low) || CTR_OVERFLOW_P(ctr)) {
 			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], real);
+			wrmsr(p4_counters[real].counter_address,
+			      -(u32)reset_value[i], -1);
 			CCCR_CLEAR_OVF(low);
-			CCCR_WRITE(low, high, real);
-			CTR_WRITE(reset_value[i], real);
+			wrmsr(p4_counters[real].cccr_address, low, high);
+			wrmsr(p4_counters[real].counter_address,
+			      -(u32)reset_value[i], -1);
 		}
 	}
 
@@ -651,9 +650,9 @@ static void p4_start(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		CCCR_READ(low, high, VIRT_CTR(stag, i));
+		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 		CCCR_SET_ENABLE(low);
-		CCCR_WRITE(low, high, VIRT_CTR(stag, i));
+		wrmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 	}
 }
 
@@ -668,9 +667,9 @@ static void p4_stop(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		CCCR_READ(low, high, VIRT_CTR(stag, i));
+		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 		CCCR_SET_DISABLE(low);
-		CCCR_WRITE(low, high, VIRT_CTR(stag, i));
+		wrmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 	}
 }
 
-- 
1.6.3.1


