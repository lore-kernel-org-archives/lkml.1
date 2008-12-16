Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbYLPC1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbYLPC1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYLPCYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:22 -0500
Received: from relay1.sgi.com ([192.48.179.29]:36154 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022410.796724000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:16 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [PATCH 07/16] xen: convert to cpumask_var_t and new cpumask primitives.
Content-Disposition: inline; filename=0011-xen-convert-to-cpumask_var_t-and-new-cpumask-primit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple change, and eventual space saving when NR_CPUS >> nr_cpu_ids.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/xen/smp.c     |    9 ++++++---
 arch/x86/xen/suspend.c |    3 ++-
 arch/x86/xen/xen-ops.h |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 2cce362..b3a9586 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -33,7 +33,7 @@
 #include "xen-ops.h"
 #include "mmu.h"
 
-cpumask_t xen_cpu_initialized_map;
+cpumask_var_t xen_cpu_initialized_map;
 
 static DEFINE_PER_CPU(int, resched_irq);
 static DEFINE_PER_CPU(int, callfunc_irq);
@@ -192,7 +192,10 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	if (xen_smp_intr_init(0))
 		BUG();
 
-	xen_cpu_initialized_map = cpumask_of_cpu(0);
+	if (!alloc_cpumask_var(&xen_cpu_initialized_map, GFP_KERNEL))
+		panic("could not allocate xen_cpu_initialized_map\n");
+
+	cpumask_copy(xen_cpu_initialized_map, cpumask_of(0));
 
 	/* Restrict the possible_map according to max_cpus. */
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
@@ -221,7 +224,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	struct vcpu_guest_context *ctxt;
 	struct desc_struct *gdt;
 
-	if (cpu_test_and_set(cpu, xen_cpu_initialized_map))
+	if (cpumask_test_and_set_cpu(cpu, xen_cpu_initialized_map))
 		return 0;
 
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 2a234db..212ffe0 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -35,7 +35,8 @@ void xen_post_suspend(int suspend_cancelled)
 			pfn_to_mfn(xen_start_info->console.domU.mfn);
 	} else {
 #ifdef CONFIG_SMP
-		xen_cpu_initialized_map = cpu_online_map;
+		BUG_ON(xen_cpu_initialized_map == NULL);
+		cpumask_copy(xen_cpu_initialized_map, cpu_online_mask);
 #endif
 		xen_vcpu_restore();
 	}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 9e1afae..c1f8faf 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -58,7 +58,7 @@ void __init xen_init_spinlocks(void);
 __cpuinit void xen_init_lock_cpu(int cpu);
 void xen_uninit_lock_cpu(int cpu);
 
-extern cpumask_t xen_cpu_initialized_map;
+extern cpumask_var_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
 #endif
-- 
1.6.0

-- 
