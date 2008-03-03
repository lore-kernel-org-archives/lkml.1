Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbYCCRY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbYCCRY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759421AbYCCRPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759109AbYCCRPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:36 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 35/52] move cpu_coregroup_map to common file
Date: Mon,  3 Mar 2008 14:13:03 -0300
Message-Id: <1204564400-17636-36-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-35-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is equal between architectures

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   16 ++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   14 --------------
 arch/x86/kernel/smpboot_64.c |   14 --------------
 3 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d774520..644e609 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -95,6 +96,21 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	}
 }
 
+/* maps the cpu to the sched domain representing multi-core */
+cpumask_t cpu_coregroup_map(int cpu)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	/*
+	 * For perf, we return last level cache shared map.
+	 * And for power savings, we return cpu_core_map
+	 */
+	if (sched_mc_power_savings || sched_smt_power_savings)
+		return per_cpu(cpu_core_map, cpu);
+	else
+		return c->llc_shared_map;
+}
+
+
 #ifdef CONFIG_HOTPLUG_CPU
 void remove_siblinginfo(int cpu)
 {
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 322f466..a58ca7f 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -260,20 +260,6 @@ static void __cpuinit smp_callin(void)
 
 static int cpucount;
 
-/* maps the cpu to the sched domain representing multi-core */
-cpumask_t cpu_coregroup_map(int cpu)
-{
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	/*
-	 * For perf, we return last level cache shared map.
-	 * And for power savings, we return cpu_core_map
-	 */
-	if (sched_mc_power_savings || sched_smt_power_savings)
-		return per_cpu(cpu_core_map, cpu);
-	else
-		return c->llc_shared_map;
-}
-
 /*
  * Activate a secondary processor.
  */
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 329f9c5..1a59240 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -211,20 +211,6 @@ void __cpuinit smp_callin(void)
 	cpu_set(cpuid, cpu_callin_map);
 }
 
-/* maps the cpu to the sched domain representing multi-core */
-cpumask_t cpu_coregroup_map(int cpu)
-{
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	/*
-	 * For perf, we return last level cache shared map.
-	 * And for power savings, we return cpu_core_map
-	 */
-	if (sched_mc_power_savings || sched_smt_power_savings)
-		return per_cpu(cpu_core_map, cpu);
-	else
-		return c->llc_shared_map;
-}
-
 /*
  * Setup code on secondary processor (after comming out of the trampoline)
  */
-- 
1.5.0.6

