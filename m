Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589Ab0BZRkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:40:13 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:53754 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965508Ab0BZRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:05 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7N-02-2LJ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
       Shashi Belur <shashi-kiran.belur@hp.com>, Tony Jones <tonyj@suse.de>
Subject: [PATCH 08/15] oprofile/x86: warn user if a counter is already active
Date: Fri, 26 Feb 2010 18:30:00 +0100
Message-ID: <1267205407-6523-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0335 (UTC) FILETIME=[21843970:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch generates a warning if a counter is already active.

Implemented for AMD and P6 models. P4 is not supported.

Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Shashi Belur <shashi-kiran.belur@hp.com>
Cc: Tony Jones <tonyj@suse.de>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |   11 ++++++++++-
 arch/x86/oprofile/op_model_ppro.c |   11 ++++++++++-
 arch/x86/oprofile/op_x86_model.h  |   11 +++++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index a9d1947..ef9d735 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -194,9 +194,18 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0; i < NUM_CONTROLS; ++i) {
-		if (unlikely(!msrs->controls[i].addr))
+		if (unlikely(!msrs->controls[i].addr)) {
+			if (counter_config[i].enabled && !smp_processor_id())
+				/*
+				 * counter is reserved, this is on all
+				 * cpus, so report only for cpu #0
+				 */
+				op_x86_warn_reserved(i);
 			continue;
+		}
 		rdmsrl(msrs->controls[i].addr, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 8eb0587..c344525 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -82,9 +82,18 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0; i < num_counters; ++i) {
-		if (unlikely(!msrs->controls[i].addr))
+		if (unlikely(!msrs->controls[i].addr)) {
+			if (counter_config[i].enabled && !smp_processor_id())
+				/*
+				 * counter is reserved, this is on all
+				 * cpus, so report only for cpu #0
+				 */
+				op_x86_warn_reserved(i);
 			continue;
+		}
 		rdmsrl(msrs->controls[i].addr, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
 	}
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 7b8e75d..59fa2bd 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -57,6 +57,17 @@ struct op_x86_model_spec {
 
 struct op_counter_config;
 
+static inline void op_x86_warn_in_use(int counter)
+{
+	pr_warning("oprofile: counter #%d on cpu #%d may already be used\n",
+		   counter, smp_processor_id());
+}
+
+static inline void op_x86_warn_reserved(int counter)
+{
+	pr_warning("oprofile: counter #%d is already reserved\n", counter);
+}
+
 extern u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 			   struct op_counter_config *counter_config);
 extern int op_x86_phys_to_virt(int phys);
-- 
1.6.6


