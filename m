Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0CDQuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:50:13 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:29229
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756130Ab0CDQtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:51 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO27-02-MPE-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/9] oprofile/x86: return -EBUSY if counters are already reserved
Date: Thu, 4 Mar 2010 16:22:09 +0100
Message-ID: <1267716131-17908-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0332 (UTC) FILETIME=[9F3C49C0:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case a counter is already reserved by the watchdog or perf_event
subsystem, oprofile ignored this counters silently. This case is
handled now and oprofile_setup() now reports an error.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |    5 ++++-
 arch/x86/oprofile/op_model_amd.c  |   10 +++++++++-
 arch/x86/oprofile/op_model_p4.c   |   15 ++++++++++++++-
 arch/x86/oprofile/op_model_ppro.c |   10 +++++++++-
 arch/x86/oprofile/op_x86_model.h  |    2 +-
 5 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index c0c21f2..9f001d9 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -357,7 +357,10 @@ static int nmi_setup(void)
 	 */
 
 	/* Assume saved/restored counters are the same on all CPUs */
-	model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
+	err = model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
+	if (err)
+		goto fail;
+
 	for_each_possible_cpu(cpu) {
 		if (!cpu)
 			continue;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 905995d..128d84c 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -129,7 +129,9 @@ static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 
 /* functions for op_amd_spec */
 
-static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
+static void op_amd_shutdown(struct op_msrs const * const msrs);
+
+static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
 
@@ -137,8 +139,14 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 		if (reserve_perfctr(i)) {
 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
 			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		} else if (counter_config[i].enabled) {
+			op_x86_warn_reserved(i);
+			op_amd_shutdown(msrs);
+			return -EBUSY;
 		}
 	}
+
+	return 0;
 }
 
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index e6a160a..599fcae 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -385,8 +385,9 @@ static unsigned int get_stagger(void)
 
 static unsigned long reset_value[NUM_COUNTERS_NON_HT];
 
+static void p4_shutdown(struct op_msrs const * const msrs);
 
-static void p4_fill_in_addresses(struct op_msrs * const msrs)
+static int p4_fill_in_addresses(struct op_msrs * const msrs)
 {
 	unsigned int i;
 	unsigned int addr, cccraddr, stag;
@@ -468,6 +469,18 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
 		}
 	}
+
+	for (i = 0; i < num_counters; ++i) {
+		if (!counter_config[i].enabled)
+			continue;
+		if (msrs->controls[i].addr)
+			continue;
+		op_x86_warn_reserved(i);
+		p4_shutdown(msrs);
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index a838ee4..3cf4e2f 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -30,7 +30,9 @@ static int counter_width = 32;
 
 static u64 *reset_value;
 
-static void ppro_fill_in_addresses(struct op_msrs * const msrs)
+static void ppro_shutdown(struct op_msrs const * const msrs);
+
+static int ppro_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
 
@@ -38,8 +40,14 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 		if (reserve_perfctr(i)) {
 			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
 			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
+		} else if (counter_config[i].enabled) {
+			op_x86_warn_reserved(i);
+			ppro_shutdown(msrs);
+			return -EBUSY;
 		}
 	}
+
+	return 0;
 }
 
 
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index ff82a75..5514013 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -41,7 +41,7 @@ struct op_x86_model_spec {
 	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
 	void		(*exit)(void);
-	void		(*fill_in_addresses)(struct op_msrs * const msrs);
+	int		(*fill_in_addresses)(struct op_msrs * const msrs);
 	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
 				      struct op_msrs const * const msrs);
 	int		(*check_ctrs)(struct pt_regs * const regs,
-- 
1.7.0


