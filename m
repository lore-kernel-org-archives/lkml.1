Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZA2Nn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZA2Nn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZA2Nnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:43:49 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:16347 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZA2Nns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:43:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uowttWnr1NBAZXo/ZjtCk7LhTvjkaNmGsIbbCx39cgO3U81/rMTbaASS9pZ5FOAViT
         dLzo1uuAI6QiUxN5AOOJ48+ESDjqSfBiU4sDBaAn/HlMQGSF64OwRhonfUh3+SVwp/Wp
         MHXhhOlLVdQLDS3SxgadhogPGRba3HK/M3iiM=
From: Brian Gerst <brgerst@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: pass in cpu number to switch_to_new_gdt()
Date: Thu, 29 Jan 2009 08:43:45 -0500
Message-Id: <1233236625-17928-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <49818842.5020004@goop.org>
References: <49818842.5020004@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, prepare for xen boot fix.

Xen needs to call this function very early to setup the GDT and
per-cpu segments.  Remove the call to smp_processor_id() and just
pass in the cpu number.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/processor.h    |    2 +-
 arch/x86/kernel/cpu/common.c        |    7 +++----
 arch/x86/kernel/setup_percpu.c      |    2 +-
 arch/x86/kernel/smpboot.c           |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |   11 ++++++-----
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index befa20b..1c25eb6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -768,7 +768,7 @@ extern int sysenter_setup(void);
 extern struct desc_ptr		early_gdt_descr;
 
 extern void cpu_set_gdt(int);
-extern void switch_to_new_gdt(void);
+extern void switch_to_new_gdt(int);
 extern void cpu_init(void);
 
 static inline unsigned long get_debugctlmsr(void)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 652fdc9..6eacd64 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -255,10 +255,9 @@ __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one. */
-void switch_to_new_gdt(void)
+void switch_to_new_gdt(int cpu)
 {
 	struct desc_ptr gdt_descr;
-	int cpu = smp_processor_id();
 
 	gdt_descr.address = (long)get_cpu_gdt_table(cpu);
 	gdt_descr.size = GDT_SIZE - 1;
@@ -993,7 +992,7 @@ void __cpuinit cpu_init(void)
 	 * and set up the GDT descriptor:
 	 */
 
-	switch_to_new_gdt();
+	switch_to_new_gdt(cpu);
 	loadsegment(fs, 0);
 
 	load_idt((const struct desc_ptr *)&idt_descr);
@@ -1098,7 +1097,7 @@ void __cpuinit cpu_init(void)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	load_idt(&idt_descr);
-	switch_to_new_gdt();
+	switch_to_new_gdt(cpu);
 
 	/*
 	 * Set up and load the per-CPU TSS and LDT
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 0d1e7ac..ef91747 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -122,7 +122,7 @@ void __init setup_per_cpu_areas(void)
 		 * area.  Reload any changed state for the boot CPU.
 		 */
 		if (cpu == boot_cpu_id)
-			switch_to_new_gdt();
+			switch_to_new_gdt(cpu);
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f9dbcff..612d3c7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1185,7 +1185,7 @@ out:
 void __init native_smp_prepare_boot_cpu(void)
 {
 	int me = smp_processor_id();
-	switch_to_new_gdt();
+	switch_to_new_gdt(me);
 	/* already set me in cpu_online_mask in boot_cpu_init() */
 	cpumask_set_cpu(me, cpu_callout_mask);
 	per_cpu(cpu_state, me) = CPU_ONLINE;
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 331cd6d..58c7cac 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1746,12 +1746,13 @@ static void __init voyager_smp_prepare_cpus(unsigned int max_cpus)
 
 static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 {
-	switch_to_new_gdt();
+	int cpu = smp_processor_id();
+	switch_to_new_gdt(cpu);
 
-	cpu_set(smp_processor_id(), cpu_online_map);
-	cpu_set(smp_processor_id(), cpu_callout_map);
-	cpu_set(smp_processor_id(), cpu_possible_map);
-	cpu_set(smp_processor_id(), cpu_present_map);
+	cpu_set(cpu, cpu_online_map);
+	cpu_set(cpu, cpu_callout_map);
+	cpu_set(cpu, cpu_possible_map);
+	cpu_set(cpu, cpu_present_map);
 }
 
 static int __cpuinit voyager_cpu_up(unsigned int cpu)
-- 
1.6.1

