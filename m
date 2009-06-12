Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbZFLNEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbZFLNEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762814AbZFLM7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:33 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:8374 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762801AbZFLM7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:32 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i17ch43j)
X-FB-SS: 5,
X-WSS-ID: 0KL4MQL-04-6AF-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/23] x86/oprofile: remove MSR macros for ppro cpus
Date: Fri, 12 Jun 2009 14:35:27 +0200
Message-ID: <1244810140-20595-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:06.0608 (UTC) FILETIME=[91B90F00:01C9EB5D]
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
 arch/x86/oprofile/op_model_ppro.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index a922a1a..6c5d288 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -27,9 +27,6 @@ static int num_counters = 2;
 static int counter_width = 32;
 
 #define CTR_OVERFLOWED(n) (!((n) & (1ULL<<(counter_width-1))))
-
-#define CTRL_READ(l, h, msrs, c) do {rdmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
-#define CTRL_WRITE(l, h, msrs, c) do {wrmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
 #define CTRL_CLEAR(x) (x &= (1<<21))
 #define CTRL_SET_EVENT(val, e) (val |= e)
 
@@ -88,9 +85,9 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	for (i = 0 ; i < num_counters; ++i) {
 		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
 			continue;
-		CTRL_READ(low, high, msrs, i);
+		rdmsr(msrs->controls[i].addr, low, high);
 		CTRL_CLEAR(low);
-		CTRL_WRITE(low, high, msrs, i);
+		wrmsr(msrs->controls[i].addr, low, high);
 	}
 
 	/* avoid a false detection of ctr overflows in NMI handler */
@@ -107,14 +104,14 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 
 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 
-			CTRL_READ(low, high, msrs, i);
+			rdmsr(msrs->controls[i].addr, low, high);
 			CTRL_CLEAR(low);
 			CTRL_SET_ENABLE(low);
 			CTRL_SET_USR(low, counter_config[i].user);
 			CTRL_SET_KERN(low, counter_config[i].kernel);
 			CTRL_SET_UM(low, counter_config[i].unit_mask);
 			CTRL_SET_EVENT(low, counter_config[i].event);
-			CTRL_WRITE(low, high, msrs, i);
+			wrmsr(msrs->controls[i].addr, low, high);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -162,9 +159,9 @@ static void ppro_start(struct op_msrs const * const msrs)
 		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
-			CTRL_READ(low, high, msrs, i);
+			rdmsr(msrs->controls[i].addr, low, high);
 			CTRL_SET_ACTIVE(low);
-			CTRL_WRITE(low, high, msrs, i);
+			wrmsr(msrs->controls[i].addr, low, high);
 		}
 	}
 }
@@ -180,9 +177,9 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		CTRL_READ(low, high, msrs, i);
+		rdmsr(msrs->controls[i].addr, low, high);
 		CTRL_SET_INACTIVE(low);
-		CTRL_WRITE(low, high, msrs, i);
+		wrmsr(msrs->controls[i].addr, low, high);
 	}
 }
 
-- 
1.6.3.1


