Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYI2SJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYI2SJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYI2SDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36487 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753981AbYI2SCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:53 -0400
Message-Id: <20080929180252.989127000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:11 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 21/31] cpumask: clean acpi files
Content-Disposition: inline; filename=clean-acpi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/acpi/boot.c         |    4 ++--
 arch/x86/kernel/acpi/cstate.c       |    2 +-
 drivers/acpi/processor_perflib.c    |    6 +++---
 drivers/acpi/processor_throttling.c |   12 ++++++------
 include/acpi/processor.h            |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/acpi/boot.c
+++ struct-cpumasks/arch/x86/kernel/acpi/boot.c
@@ -520,7 +520,7 @@ static int __cpuinit _acpi_map_lsapic(ac
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	struct acpi_madt_local_apic *lapic;
-	cpumask_t tmp_map, new_map;
+	cpumask_var_t tmp_map, new_map;
 	u8 physid;
 	int cpu;
 
@@ -551,7 +551,7 @@ static int __cpuinit _acpi_map_lsapic(ac
 	buffer.length = ACPI_ALLOCATE_BUFFER;
 	buffer.pointer = NULL;
 
-	tmp_map = cpu_present_map;
+	cpus_copy(tmp_map, cpu_present_map);
 	acpi_register_lapic(physid, lapic->lapic_flags & ACPI_MADT_ENABLED);
 
 	/*
--- struct-cpumasks.orig/arch/x86/kernel/acpi/cstate.c
+++ struct-cpumasks/arch/x86/kernel/acpi/cstate.c
@@ -128,7 +128,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 		 cx->address);
 
 out:
-	set_cpus_allowed(current, &saved_mask);
+	set_cpus_allowed(current, saved_mask);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
--- struct-cpumasks.orig/drivers/acpi/processor_perflib.c
+++ struct-cpumasks/drivers/acpi/processor_perflib.c
@@ -571,7 +571,7 @@ int acpi_processor_preregister_performan
 	int count, count_target;
 	int retval = 0;
 	unsigned int i, j;
-	cpumask_t covered_cpus;
+	cpumask_var_t covered_cpus;
 	struct acpi_processor *pr;
 	struct acpi_psd_package *pdomain;
 	struct acpi_processor *match_pr;
@@ -701,8 +701,8 @@ int acpi_processor_preregister_performan
 
 			match_pr->performance->shared_type = 
 					pr->performance->shared_type;
-			match_pr->performance->shared_cpu_map =
-				pr->performance->shared_cpu_map;
+			cpus_copy(match_pr->performance->shared_cpu_map,
+					pr->performance->shared_cpu_map);
 		}
 	}
 
--- struct-cpumasks.orig/drivers/acpi/processor_throttling.c
+++ struct-cpumasks/drivers/acpi/processor_throttling.c
@@ -61,7 +61,7 @@ static int acpi_processor_update_tsd_coo
 	int count, count_target;
 	int retval = 0;
 	unsigned int i, j;
-	cpumask_t covered_cpus;
+	cpumask_var_t covered_cpus;
 	struct acpi_processor *pr, *match_pr;
 	struct acpi_tsd_package *pdomain, *match_pdomain;
 	struct acpi_processor_throttling *pthrottling, *match_pthrottling;
@@ -841,7 +841,7 @@ static int acpi_processor_get_throttling
 	set_cpus_allowed(current, cpumask_of_cpu(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
-	set_cpus_allowed(current, &saved_mask);
+	set_cpus_allowed(current, saved_mask);
 
 	return ret;
 }
@@ -986,13 +986,13 @@ static int acpi_processor_set_throttling
 
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
-	cpumask_t saved_mask;
+	cpumask_var_t saved_mask;
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
 	struct acpi_processor_throttling *p_throttling;
 	struct throttling_tstate t_state;
-	cpumask_t online_throttling_cpus;
+	cpumask_var_t online_throttling_cpus;
 
 	if (!pr)
 		return -EINVAL;
@@ -1003,7 +1003,7 @@ int acpi_processor_set_throttling(struct
 	if ((state < 0) || (state > (pr->throttling.state_count - 1)))
 		return -EINVAL;
 
-	saved_mask = current->cpus_allowed;
+	cpus_copy(saved_mask, current->cpus_allowed);
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
 	cpus_and(online_throttling_cpus, cpu_online_map,
@@ -1074,7 +1074,7 @@ int acpi_processor_set_throttling(struct
 							&t_state);
 	}
 	/* restore the previous state */
-	set_cpus_allowed(current, &saved_mask);
+	set_cpus_allowed(current, saved_mask);
 	return ret;
 }
 
--- struct-cpumasks.orig/include/acpi/processor.h
+++ struct-cpumasks/include/acpi/processor.h
@@ -127,7 +127,7 @@ struct acpi_processor_performance {
 	unsigned int state_count;
 	struct acpi_processor_px *states;
 	struct acpi_psd_package domain_info;
-	cpumask_t shared_cpu_map;
+	cpumask_map_t shared_cpu_map;
 	unsigned int shared_type;
 };
 

-- 
