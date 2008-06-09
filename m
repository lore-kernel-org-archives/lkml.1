Return-Path: <linux-kernel-owner+w=401wt.eu-S1761152AbYFIOUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761152AbYFIOUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759450AbYFIOSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758493AbYFIOSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:36 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 06/15] x86: boot secondary cpus through initial_code
Date: Mon,  9 Jun 2008 11:16:49 -0300
Message-Id: <1213021018-14159-7-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-6-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove "initialize_secondary". Boot both architectures via
initial_code.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/head_32.S |    2 +-
 arch/x86/kernel/smpboot.c |   25 +------------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ffb73a5..f67e934 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -452,7 +452,7 @@ is386:	movl $2,%ecx		# set MP
 	je   1f
 	movl $(__KERNEL_PERCPU), %eax
 	movl %eax,%fs		# set this cpu's percpu
-	jmp initialize_secondary # all other CPUs call initialize_secondary
+	movl (stack_start), %esp
 1:
 #endif /* CONFIG_SMP */
 	jmp *(initial_code)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 69639fd..0e4a44a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -349,28 +349,6 @@ static void __cpuinit start_secondary(void *unused)
 	cpu_idle();
 }
 
-#ifdef CONFIG_X86_32
-/*
- * Everything has been set up for the secondary
- * CPUs - they just need to reload everything
- * from the task structure
- * This function must not return.
- */
-void __devinit initialize_secondary(void)
-{
-	/*
-	 * We don't actually need to load the full TSS,
-	 * basically just the stack pointer and the ip.
-	 */
-
-	asm volatile(
-		"movl %0,%%esp\n\t"
-		"jmp *%1"
-		:
-		:"m" (current->thread.sp), "m" (current->thread.ip));
-}
-#endif
-
 static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_32
@@ -892,15 +870,14 @@ do_rest:
 #ifdef CONFIG_X86_32
 	per_cpu(current_task, cpu) = c_idle.idle;
 	init_gdt(cpu);
-	c_idle.idle->thread.ip = (unsigned long) start_secondary;
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
 #else
 	cpu_pda(cpu)->pcurrent = c_idle.idle;
 	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
-	initial_code = (unsigned long)start_secondary;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 #endif
+	initial_code = (unsigned long)start_secondary;
 	stack_start.sp = (void *) c_idle.idle->thread.sp;
 
 	/* start_ip had better be page-aligned! */
-- 
1.5.4.5

