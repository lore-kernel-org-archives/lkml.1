Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965247Ab0CMB3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:29:16 -0500
Received: from kroah.org ([198.145.64.141]:60662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934825Ab0CMAT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:59 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:08 2010
Message-Id: <20100313001508.510310151@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Richter <robert.richter@amd.com>
Subject: [patch 038/123] oprofile/x86: use kzalloc() instead of kmalloc()
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Robert Richter <robert.richter@amd.com>

commit c17c8fbf349482e89b57d1b800e83e9f4cf40c47 upstream.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c       |    6 +++---
 arch/x86/oprofile/op_model_amd.c  |    4 ----
 arch/x86/oprofile/op_model_p4.c   |    6 ------
 arch/x86/oprofile/op_model_ppro.c |    6 +-----
 4 files changed, 4 insertions(+), 18 deletions(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -159,7 +159,7 @@ static int nmi_setup_mux(void)
 
 	for_each_possible_cpu(i) {
 		per_cpu(cpu_msrs, i).multiplex =
-			kmalloc(multiplex_size, GFP_KERNEL);
+			kzalloc(multiplex_size, GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).multiplex)
 			return 0;
 	}
@@ -304,11 +304,11 @@ static int allocate_msrs(void)
 
 	int i;
 	for_each_possible_cpu(i) {
-		per_cpu(cpu_msrs, i).counters = kmalloc(counters_size,
+		per_cpu(cpu_msrs, i).counters = kzalloc(counters_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).counters)
 			return 0;
-		per_cpu(cpu_msrs, i).controls = kmalloc(controls_size,
+		per_cpu(cpu_msrs, i).controls = kzalloc(controls_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).controls)
 			return 0;
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -105,15 +105,11 @@ static void op_amd_fill_in_addresses(str
 	for (i = 0; i < NUM_COUNTERS; i++) {
 		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-		else
-			msrs->counters[i].addr = 0;
 	}
 
 	for (i = 0; i < NUM_CONTROLS; i++) {
 		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
-		else
-			msrs->controls[i].addr = 0;
 	}
 }
 
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -394,12 +394,6 @@ static void p4_fill_in_addresses(struct
 	setup_num_counters();
 	stag = get_stagger();
 
-	/* initialize some registers */
-	for (i = 0; i < num_counters; ++i)
-		msrs->counters[i].addr = 0;
-	for (i = 0; i < num_controls; ++i)
-		msrs->controls[i].addr = 0;
-
 	/* the counter & cccr registers we pay attention to */
 	for (i = 0; i < num_counters; ++i) {
 		addr = p4_counters[VIRT_CTR(stag, i)].counter_address;
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -37,15 +37,11 @@ static void ppro_fill_in_addresses(struc
 	for (i = 0; i < num_counters; i++) {
 		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
-		else
-			msrs->counters[i].addr = 0;
 	}
 
 	for (i = 0; i < num_counters; i++) {
 		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
-		else
-			msrs->controls[i].addr = 0;
 	}
 }
 
@@ -57,7 +53,7 @@ static void ppro_setup_ctrs(struct op_x8
 	int i;
 
 	if (!reset_value) {
-		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,
+		reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
 					GFP_ATOMIC);
 		if (!reset_value)
 			return;


