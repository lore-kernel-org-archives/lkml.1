Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbYCCRV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbYCCRV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbYCCRPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbYCCRPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:13 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 30/52] move equal types to common file
Date: Mon,  3 Mar 2008 14:12:58 -0300
Message-Id: <1204564400-17636-31-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-30-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move definitions that are now equal in type from
smpboot_{32,64}.c to smpboot.c

cpu_callin_map is put temporarily in smp_64.h (already
exists in smp_32.h), and will soon be merged.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   28 ++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   27 ---------------------------
 arch/x86/kernel/smpboot_64.c |   33 ---------------------------------
 include/asm-x86/smp_64.h     |    1 +
 4 files changed, 29 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bffe108..40a3b56 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1,6 +1,34 @@
 #include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/module.h>
 
+/* Number of siblings per CPU package */
+int smp_num_siblings = 1;
+EXPORT_SYMBOL(smp_num_siblings);
+
+/* Last level cache ID of each logical CPU */
+DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
+
+/* bitmap of online cpus */
+cpumask_t cpu_online_map __read_mostly;
+EXPORT_SYMBOL(cpu_online_map);
+
+cpumask_t cpu_callin_map;
+cpumask_t cpu_callout_map;
+cpumask_t cpu_possible_map;
+EXPORT_SYMBOL(cpu_possible_map);
+
+/* representing HT siblings of each logical CPU */
+DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
+EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
+
+/* representing HT and core siblings of each logical CPU */
+DEFINE_PER_CPU(cpumask_t, cpu_core_map);
+EXPORT_PER_CPU_SYMBOL(cpu_core_map);
+
+/* Per CPU bogomips and other parameters */
+DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+EXPORT_PER_CPU_SYMBOL(cpu_info);
 #ifdef CONFIG_HOTPLUG_CPU
 
 int additional_cpus __initdata = -1;
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 5a446f0..0fbc981 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -62,35 +62,8 @@
 /* Set if we find a B stepping CPU */
 static int __cpuinitdata smp_b_stepping;
 
-/* Number of siblings per CPU package */
-int smp_num_siblings = 1;
-EXPORT_SYMBOL(smp_num_siblings);
-
-/* Last level cache ID of each logical CPU */
-DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
-
-/* representing HT siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
-EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
-
-/* representing HT and core siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_t, cpu_core_map);
-EXPORT_PER_CPU_SYMBOL(cpu_core_map);
-
-/* bitmap of online cpus */
-cpumask_t cpu_online_map __read_mostly;
-EXPORT_SYMBOL(cpu_online_map);
-
-cpumask_t cpu_callin_map;
-cpumask_t cpu_callout_map;
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
 static cpumask_t smp_commenced_mask;
 
-/* Per CPU bogomips and other parameters */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
-EXPORT_PER_CPU_SYMBOL(cpu_info);
-
 /* which logical CPU number maps to which CPU (physical APIC ID) */
 u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
 			{ [0 ... NR_CPUS-1] = BAD_APICID };
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 953b0ff..c51279f 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -60,42 +60,9 @@
 #include <asm/hw_irq.h>
 #include <asm/numa.h>
 
-/* Number of siblings per CPU package */
-int smp_num_siblings = 1;
-EXPORT_SYMBOL(smp_num_siblings);
-
-/* Last level cache ID of each logical CPU */
-DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
-
-/* Bitmask of currently online CPUs */
-cpumask_t cpu_online_map __read_mostly;
-
-EXPORT_SYMBOL(cpu_online_map);
-
-/*
- * Private maps to synchronize booting between AP and BP.
- * Probably not needed anymore, but it makes for easier debugging. -AK
- */
-cpumask_t cpu_callin_map;
-cpumask_t cpu_callout_map;
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
-
-/* Per CPU bogomips and other parameters */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
-EXPORT_PER_CPU_SYMBOL(cpu_info);
-
 /* Set when the idlers are all forked */
 int smp_threads_ready;
 
-/* representing HT siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
-EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
-
-/* representing HT and core siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_t, cpu_core_map);
-EXPORT_PER_CPU_SYMBOL(cpu_core_map);
-
 /*
  * Trampoline 80x86 program as an array.
  */
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index e5bc1be..1ecf813 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -14,6 +14,7 @@
 #include <asm/thread_info.h>
 
 extern cpumask_t cpu_initialized;
+extern cpumask_t cpu_callin_map;
 
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
-- 
1.5.0.6

