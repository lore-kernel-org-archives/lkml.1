Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbYFIOY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbYFIOY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761475AbYFIOX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:23:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738AbYFIOXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:23:55 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 14/15] x86: move cpu_exit_clear to process_32.c
Date: Mon,  9 Jun 2008 11:16:57 -0300
Message-Id: <1213021018-14159-15-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-14-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
 <1213021018-14159-12-git-send-email-gcosta@redhat.com>
 <1213021018-14159-13-git-send-email-gcosta@redhat.com>
 <1213021018-14159-14-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take it out of smpboot.c, and move it to process_32.c, closer
to its only user.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/process_32.c |   16 ++++++++++++++++
 arch/x86/kernel/smpboot.c    |   19 +------------------
 include/asm-x86/numa_32.h    |    1 +
 include/asm-x86/smp.h        |    1 -
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 1aaca76..99f8e7d 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -128,6 +128,22 @@ EXPORT_SYMBOL(default_idle);
 
 #ifdef CONFIG_HOTPLUG_CPU
 #include <asm/nmi.h>
+
+static void cpu_exit_clear(void)
+{
+	int cpu = raw_smp_processor_id();
+
+	idle_task_exit();
+
+	cpu_uninit();
+	irq_ctx_exit(cpu);
+
+	cpu_clear(cpu, cpu_callout_map);
+	cpu_clear(cpu, cpu_callin_map);
+
+	numa_remove_cpu(cpu);
+}
+
 /* We don't actually take CPU down, just spin without interrupts. */
 static inline void play_dead(void)
 {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f6b99b6..7952c39 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -181,7 +181,7 @@ static void map_cpu_to_logical_apicid(void)
 	map_cpu_to_node(cpu, node);
 }
 
-static void numa_remove_cpu(int cpu)
+void numa_remove_cpu(int cpu)
 {
 	cpu_2_logical_apicid[cpu] = BAD_APICID;
 	unmap_cpu_to_node(cpu);
@@ -1229,23 +1229,6 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-#  ifdef CONFIG_X86_32
-void cpu_exit_clear(void)
-{
-	int cpu = raw_smp_processor_id();
-
-	idle_task_exit();
-
-	cpu_uninit();
-	irq_ctx_exit(cpu);
-
-	cpu_clear(cpu, cpu_callout_map);
-	cpu_clear(cpu, cpu_callin_map);
-
-	numa_remove_cpu(cpu);
-}
-#  endif /* CONFIG_X86_32 */
-
 static void remove_siblinginfo(int cpu)
 {
 	int sibling;
diff --git a/include/asm-x86/numa_32.h b/include/asm-x86/numa_32.h
index 03d0f7a..205015f 100644
--- a/include/asm-x86/numa_32.h
+++ b/include/asm-x86/numa_32.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_32_NUMA_H 1
 
 extern int pxm_to_nid(int pxm);
+extern void numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA
 extern void __init remap_numa_kva(void);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index fc10073..fad45f6 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -188,7 +188,6 @@ static inline int hard_smp_processor_id(void)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_HOTPLUG_CPU
-extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
 #endif
 
-- 
1.5.4.5

