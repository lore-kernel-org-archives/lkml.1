Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbZAMKmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbZAMKmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbZAMKj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:51183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141AbZAMKj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:27 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/13] x86_64: load pointer to pda into %gs while brining up a CPU
Date: Tue, 13 Jan 2009 19:38:10 +0900
Message-Id: <1231843097-18003-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU startup code in head_64.S loaded address of a zero page into %gs
for temporary use till pda is loaded but address to the actual pda is
available at the point.  Load the real address directly instead.

This will help unifying percpu and pda handling later on.

This patch is mostly taken from Mike Travis' "x86_64: Fold pda into
per cpu area" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/trampoline.h |    1 +
 arch/x86/kernel/acpi/sleep.c      |    1 +
 arch/x86/kernel/head64.c          |    4 ++--
 arch/x86/kernel/head_64.S         |   15 ++++++++++-----
 arch/x86/kernel/smpboot.c         |    1 +
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index 780ba0a..90f06c2 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -13,6 +13,7 @@ extern unsigned char *trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
+extern unsigned long initial_gs;
 
 #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
 #define TRAMPOLINE_BASE 0x6000
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 806b4e9..fe23ff8 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -101,6 +101,7 @@ int acpi_save_state_mem(void)
 	stack_start.sp = temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_table(smp_processor_id());
+	initial_gs = (unsigned long)cpu_pda(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index a63261b..54f52cf 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,8 +26,8 @@
 #include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
 
-/* boot cpu pda */
-static struct x8664_pda _boot_cpu_pda __read_mostly;
+/* boot cpu pda, referenced by head_64.S to initialize %gs for boot CPU */
+struct x8664_pda _boot_cpu_pda __read_mostly;
 
 #ifdef CONFIG_SMP
 /*
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5ab77b3..3f56a8f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -243,12 +243,15 @@ ENTRY(secondary_startup_64)
 	movl %eax,%fs
 	movl %eax,%gs
 
-	/* 
-	 * Setup up a dummy PDA. this is just for some early bootup code
-	 * that does in_interrupt() 
-	 */ 
+	/* Set up %gs.
+	 *
+	 * %gs should point to the pda.  For initial boot, make %gs point
+	 * to the _boot_cpu_pda in data section.  For a secondary CPU,
+	 * initial_gs should be set to its pda address before the CPU runs
+	 * this code.
+	 */
 	movl	$MSR_GS_BASE,%ecx
-	movq	$empty_zero_page,%rax
+	movq	initial_gs(%rip),%rax
 	movq    %rax,%rdx
 	shrq	$32,%rdx
 	wrmsr	
@@ -274,6 +277,8 @@ ENTRY(secondary_startup_64)
 	.align	8
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
+	ENTRY(initial_gs)
+	.quad	_boot_cpu_pda
 	__FINITDATA
 
 	ENTRY(stack_start)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f8500c9..7cd97d9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -860,6 +860,7 @@ do_rest:
 #else
 	cpu_pda(cpu)->pcurrent = c_idle.idle;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
+	initial_gs = (unsigned long)cpu_pda(cpu);
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
-- 
1.5.6

