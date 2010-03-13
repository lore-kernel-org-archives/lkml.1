Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934886Ab0CMBaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:30:24 -0500
Received: from kroah.org ([198.145.64.141]:60669 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934875Ab0CMAT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:56 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:08 2010
Message-Id: <20100313001508.063085254@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Richter <robert.richter@amd.com>
Subject: [patch 033/123] oprofile/x86: fix perfctr nmi reservation for mulitplexing
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Robert Richter <robert.richter@amd.com>

commit 68dc819ce829f7e7977a56524e710473bdb55115 upstream.

Multiple virtual counters share one physical counter. The reservation
of virtual counters fails due to duplicate allocation of the same
counter. The counters are already reserved. Thus, virtual counter
reservation may removed at all. This also makes the code easier.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c      |   11 ++++++-----
 arch/x86/oprofile/op_model_amd.c |   19 -------------------
 2 files changed, 6 insertions(+), 24 deletions(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -179,7 +179,6 @@ static void nmi_cpu_setup_mux(int cpu, s
 		if (counter_config[i].enabled) {
 			multiplex[i].saved = -(u64)counter_config[i].count;
 		} else {
-			multiplex[i].addr  = 0;
 			multiplex[i].saved = 0;
 		}
 	}
@@ -189,25 +188,27 @@ static void nmi_cpu_setup_mux(int cpu, s
 
 static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
 {
+	struct op_msr *counters = msrs->counters;
 	struct op_msr *multiplex = msrs->multiplex;
 	int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (multiplex[virt].addr)
-			rdmsrl(multiplex[virt].addr, multiplex[virt].saved);
+		if (counters[i].addr)
+			rdmsrl(counters[i].addr, multiplex[virt].saved);
 	}
 }
 
 static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
 {
+	struct op_msr *counters = msrs->counters;
 	struct op_msr *multiplex = msrs->multiplex;
 	int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (multiplex[virt].addr)
-			wrmsrl(multiplex[virt].addr, multiplex[virt].saved);
+		if (counters[i].addr)
+			wrmsrl(counters[i].addr, multiplex[virt].saved);
 	}
 }
 
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -76,19 +76,6 @@ static struct op_ibs_config ibs_config;
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
-static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
-		int hw_counter = op_x86_virt_to_phys(i);
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
-		else
-			msrs->multiplex[i].addr = 0;
-	}
-}
-
 static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 			       struct op_msrs const * const msrs)
 {
@@ -107,10 +94,6 @@ static void op_mux_switch_ctrl(struct op
 	}
 }
 
-#else
-
-static inline void op_mux_fill_in_addresses(struct op_msrs * const msrs) { }
-
 #endif
 
 /* functions for op_amd_spec */
@@ -132,8 +115,6 @@ static void op_amd_fill_in_addresses(str
 		else
 			msrs->controls[i].addr = 0;
 	}
-
-	op_mux_fill_in_addresses(msrs);
 }
 
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,


