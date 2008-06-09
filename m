Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbYFIOS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbYFIOS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYFIOS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbYFIOS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:28 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 01/15] x86: use stack_start in x86_64
Date: Mon,  9 Jun 2008 11:16:44 -0300
Message-Id: <1213021018-14159-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call x86_64's init_rsp stack_start, just as i386 does.
Put a zeroed stack segment for consistency. With this,
we can eliminate one ugly ifdef in smpboot.c.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/acpi/sleep.c |    2 +-
 arch/x86/kernel/head_64.S    |    5 +++--
 arch/x86/kernel/smpboot.c    |    7 +------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index afc25ee..0103af2 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -72,7 +72,7 @@ int acpi_save_state_mem(void)
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 	header->trampoline_segment = setup_trampoline() >> 4;
-	init_rsp = (unsigned long)temp_stack + 4096;
+	stack_start.sp = temp_stack + 4096;
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
 #endif /* CONFIG_64BIT */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d8ed325..4949c32 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -191,7 +191,7 @@ ENTRY(secondary_startup_64)
 	movq	%rax, %cr0
 
 	/* Setup a boot time stack */
-	movq init_rsp(%rip),%rsp
+	movq stack_start(%rip),%rsp
 
 	/* zero EFLAGS after setting rsp */
 	pushq $0
@@ -252,8 +252,9 @@ ENTRY(secondary_startup_64)
 	.quad	x86_64_start_kernel
 	__FINITDATA
 
-	ENTRY(init_rsp)
+	ENTRY(stack_start)
 	.quad  init_thread_union+THREAD_SIZE-8
+	.word  0
 
 bad_address:
 	jmp bad_address
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 722b24b..c77a7d2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -714,11 +714,7 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 	 * target processor state.
 	 */
 	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
-#ifdef CONFIG_X86_64
-			 (unsigned long)init_rsp);
-#else
 			 (unsigned long)stack_start.sp);
-#endif
 
 	/*
 	 * Run STARTUP IPI loop.
@@ -905,15 +901,14 @@ do_rest:
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	c_idle.idle->thread.ip = (unsigned long) start_secondary;
 	/* Stack for startup_32 can be just as for start_secondary onwards */
-	stack_start.sp = (void *) c_idle.idle->thread.sp;
 	irq_ctx_init(cpu);
 #else
 	cpu_pda(cpu)->pcurrent = c_idle.idle;
-	init_rsp = c_idle.idle->thread.sp;
 	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
 	initial_code = (unsigned long)start_secondary;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 #endif
+	stack_start.sp = (void *) c_idle.idle->thread.sp;
 
 	/* start_ip had better be page-aligned! */
 	start_ip = setup_trampoline();
-- 
1.5.4.5

