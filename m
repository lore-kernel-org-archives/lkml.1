Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZAZGTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZAZGTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZAZGPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:50 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:61769 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZAZGPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g4M3Rvuwp+tR6KmPBAHdCpEW4CkBwiK/qMsl2YZ3nmOxMUjIyE7SquELxXvJUB4Tjv
         XPLGwLffSPOeBFQ/dRpcVTDQYMJKfX5XQ77Ag9XbValW9eR62CKmbgHtXUNVnHgr2IhY
         4wdrS3wns3sqa6yRixcD8t221foT0yYg0PLME=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] x86: Load new GDT after setting up boot cpu per-cpu area
Date: Mon, 26 Jan 2009 01:15:32 -0500
Message-Id: <1232950532-22923-12-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: sync 32 and 64-bit code

Merge load_gs_base() into switch_to_new_gdt().  Load the GDT and
per-cpu state for the boot cpu when its new area is set up.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/processor.h |    5 -----
 arch/x86/kernel/cpu/common.c     |   15 +++++++++------
 arch/x86/kernel/setup_percpu.c   |    6 +++---
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 794234e..befa20b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -394,11 +394,6 @@ union irq_stack_union {
 
 DECLARE_PER_CPU(union irq_stack_union, irq_stack_union);
 DECLARE_PER_CPU(char *, irq_stack_ptr);
-
-static inline void load_gs_base(int cpu)
-{
-	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
-}
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 67e30c8..0c766b8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -258,12 +258,17 @@ __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 void switch_to_new_gdt(void)
 {
 	struct desc_ptr gdt_descr;
+	int cpu = smp_processor_id();
 
-	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.address = (long)get_cpu_gdt_table(cpu);
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
+	/* Reload the per-cpu base */
 #ifdef CONFIG_X86_32
-	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
+	loadsegment(fs, __KERNEL_PERCPU);
+#else
+	loadsegment(gs, 0);
+	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
 #endif
 }
 
@@ -968,10 +973,6 @@ void __cpuinit cpu_init(void)
 	struct task_struct *me;
 	int i;
 
-	loadsegment(fs, 0);
-	loadsegment(gs, 0);
-	load_gs_base(cpu);
-
 #ifdef CONFIG_NUMA
 	if (cpu != 0 && percpu_read(node_number) == 0 &&
 	    cpu_to_node(cpu) != NUMA_NO_NODE)
@@ -993,6 +994,8 @@ void __cpuinit cpu_init(void)
 	 */
 
 	switch_to_new_gdt();
+	loadsegment(fs, 0);
+
 	load_idt((const struct desc_ptr *)&idt_descr);
 
 	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index bcca3a7..4caa78d 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -113,13 +113,13 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(x86_cpu_to_node_map, cpu) =
 				early_per_cpu_map(x86_cpu_to_node_map, cpu);
 #endif
+#endif
 		/*
 		 * Up to this point, the boot CPU has been using .data.init
-		 * area.  Reload %gs offset for the boot CPU.
+		 * area.  Reload any changed state for the boot CPU.
 		 */
 		if (cpu == boot_cpu_id)
-			load_gs_base(cpu);
-#endif
+			switch_to_new_gdt();
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
-- 
1.6.1

