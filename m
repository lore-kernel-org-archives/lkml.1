Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZAZGSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZAZGSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZAZGPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:46 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:44602 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZAZGPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Bos9PSy6kldmRJeUuzgNK2L688Oyn5XuV3vf820ruMWdPwB223HVTiz2G6f/o2L3Bn
         PfkkHVV5yPlwufU53Rb5EHGJNXXzD6ux7Mr6s+Xh2/qKWUmvsxz9POhkliEUoG0biJ2+
         LMEGCj5dluluGKzP00doEmwFZSSNFk2ZVVkqY=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] x86: Make Voyager use x86 per-cpu setup.
Date: Mon, 26 Jan 2009 01:15:29 -0500
Message-Id: <1232950532-22923-9-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: standardize all x86 platforms on same setup code

With the preceding changes, Voyager can use the same per-cpu setup
code as all the other x86 platforms.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/Kconfig                    |    2 +-
 arch/x86/kernel/setup_percpu.c      |    5 -----
 arch/x86/mach-voyager/voyager_smp.c |    3 ---
 3 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5a29b79..d6218e6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -133,7 +133,7 @@ config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
 
 config HAVE_SETUP_PER_CPU_AREA
-	def_bool X86_64_SMP || (X86_SMP && !X86_VOYAGER)
+	def_bool y
 
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index be77f1a..599dc1c 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -35,8 +35,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_number);
 DEFINE_PER_CPU(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
-#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
-
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
 	[0 ... NR_CPUS-1] = BOOT_PERCPU_OFFSET,
 };
@@ -125,6 +123,3 @@ void __init setup_per_cpu_areas(void)
 	/* Setup cpu initialized, callin, callout masks */
 	setup_cpu_local_masks();
 }
-
-#endif
-
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 96f15b0..dd82f20 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -531,7 +531,6 @@ static void __init do_boot_cpu(__u8 cpu)
 	stack_start.sp = (void *)idle->thread.sp;
 
 	init_gdt(cpu);
-	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(current_task, cpu) = idle;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
@@ -1749,7 +1748,6 @@ static void __init voyager_smp_prepare_cpus(unsigned int max_cpus)
 static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 {
 	init_gdt(smp_processor_id());
-	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	switch_to_new_gdt();
 
 	cpu_set(smp_processor_id(), cpu_online_map);
@@ -1782,7 +1780,6 @@ static void __init voyager_smp_cpus_done(unsigned int max_cpus)
 void __init smp_setup_processor_id(void)
 {
 	current_thread_info()->cpu = hard_smp_processor_id();
-	percpu_write(cpu_number, hard_smp_processor_id());
 }
 
 static void voyager_send_call_func(cpumask_t callmask)
-- 
1.6.1

