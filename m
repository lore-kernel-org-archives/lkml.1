Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZADNVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZADNVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZADNSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:18 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54026 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751531AbZADNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:09 -0500
Message-Id: <20090104131800.046360000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:18:00 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] [PATCH] ia64: cpumask fix for is_affinity_mask_valid()
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=ia64:fixup-cpumask-refs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The function prototype should use 'struct cpumask *' to declare
cpumask arguments (instead of cpumask_var_t).

Note: arch/ia64/kernel/irq.c still had the following "old cpumask_t" usages:

105:	cpumask_t mask = CPU_MASK_NONE;
107:	cpu_set(cpu_logical_id(hwid), mask);
110:                 irq_desc[irq].affinity = mask;

	... replaced with a simple "cpumask_of(cpu_logical_id(hwid))".

161:			new_cpu = any_online_cpu(cpu_online_map);
194:		time_keeper_id = first_cpu(cpu_online_map);

	... replaced with cpu_online_mask refs.

Based on tip/cpus4096-v2.

Build tested with ia64-allyesconfig.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/ia64/include/asm/irq.h |    2 +-
 arch/ia64/kernel/irq.c      |   15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

--- linux-2.6-for-ingo.orig/arch/ia64/include/asm/irq.h
+++ linux-2.6-for-ingo/arch/ia64/include/asm/irq.h
@@ -27,7 +27,7 @@ irq_canonicalize (int irq)
 }
 
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
-bool is_affinity_mask_valid(cpumask_var_t cpumask);
+bool is_affinity_mask_valid(const struct cpumask *cpumask);
 
 #define is_affinity_mask_valid is_affinity_mask_valid
 
--- linux-2.6-for-ingo.orig/arch/ia64/kernel/irq.c
+++ linux-2.6-for-ingo/arch/ia64/kernel/irq.c
@@ -102,17 +102,14 @@ static char irq_redir [NR_IRQS]; // = { 
 
 void set_irq_affinity_info (unsigned int irq, int hwid, int redir)
 {
-	cpumask_t mask = CPU_MASK_NONE;
-
-	cpu_set(cpu_logical_id(hwid), mask);
-
 	if (irq < NR_IRQS) {
-		irq_desc[irq].affinity = mask;
+		cpumask_copy(&irq_desc[irq].affinity,
+			     cpumask_of(cpu_logical_id(hwid)));
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
 }
 
-bool is_affinity_mask_valid(cpumask_var_t cpumask)
+bool is_affinity_mask_valid(const struct cpumask *cpumask)
 {
 	if (ia64_platform_is("sn2")) {
 		/* Only allow one CPU to be specified in the smp_affinity mask */
@@ -128,7 +125,7 @@ bool is_affinity_mask_valid(cpumask_var_
 unsigned int vectors_in_migration[NR_IRQS];
 
 /*
- * Since cpu_online_map is already updated, we just need to check for
+ * Since cpu_online_mask is already updated, we just need to check for
  * affinity that has zeros
  */
 static void migrate_irqs(void)
@@ -158,7 +155,7 @@ static void migrate_irqs(void)
 			 */
 			vectors_in_migration[irq] = irq;
 
-			new_cpu = any_online_cpu(cpu_online_map);
+			new_cpu = cpumask_any(cpu_online_mask);
 
 			/*
 			 * Al three are essential, currently WARN_ON.. maybe panic?
@@ -191,7 +188,7 @@ void fixup_irqs(void)
 	 * Find a new timesync master
 	 */
 	if (smp_processor_id() == time_keeper_id) {
-		time_keeper_id = first_cpu(cpu_online_map);
+		time_keeper_id = cpumask_first(cpu_online_mask);
 		printk ("CPU %d is now promoted to time-keeper master\n", time_keeper_id);
 	}
 

