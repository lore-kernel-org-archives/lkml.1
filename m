Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZHCFMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZHCFMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZHCFMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:12:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:57296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbZHCFMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:12:42 -0400
Message-ID: <4A7671B3.1050208@kernel.org>
Date: Mon, 03 Aug 2009 14:12:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86: collect hot percpu variables into one cacheline
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A76421E.3040005@kernel.org> <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 05:12:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64, percpu variables current_task and kernel_stack are used for
get_current() and current_thread_info() respectively and thus are
often used close to each other.  Move definition of current_task to
kernel/cpu/common.c right above kernel_stack definition and align it
to cacheline so that they always fall into the same cacheline.  Two
percpu variables defined there together - irq_stack_ptr and irq_count
- are also pretty hot and will benefit from sharing the cacheline.

For consistency, current_task definition for x86_32 is also moved to
kernel/cpu/common.c.

Putting current_task and kernel_stack into the same cacheline was
suggested by Linus Tolvards.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Tolvards <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
For now this should do but adding DEFINE_PER_CPU_HOT() definitely is a
viable option.

 arch/x86/kernel/cpu/common.c |   15 +++++++++++++--
 arch/x86/kernel/process_32.c |    3 ---
 arch/x86/kernel/process_64.c |    3 ---
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 12493c5..1bd88ed 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -987,13 +987,21 @@ struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);

-DEFINE_PER_CPU(char *, irq_stack_ptr) =
-	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
+/*
+ * The following four percpu variables are hot.  Align current_task to
+ * cacheline size such that all four fall in the same cacheline.
+ */
+DEFINE_PER_CPU(struct task_struct *, current_task) ____cacheline_aligned =
+	&init_task;
+EXPORT_PER_CPU_SYMBOL(current_task);

 DEFINE_PER_CPU(unsigned long, kernel_stack) =
 	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(kernel_stack);

+DEFINE_PER_CPU(char *, irq_stack_ptr) =
+	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
+
 DEFINE_PER_CPU(unsigned int, irq_count) = -1;

 /*
@@ -1041,6 +1049,9 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist);

 #else	/* CONFIG_X86_64 */

+DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
+EXPORT_PER_CPU_SYMBOL(current_task);
+
 #ifdef CONFIG_CC_STACKPROTECTOR
 DEFINE_PER_CPU(unsigned long, stack_canary);
 #endif
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 59f4524..daa4107 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -61,9 +61,6 @@

 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");

-DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
-EXPORT_PER_CPU_SYMBOL(current_task);
-
 /*
  * Return saved PC of a blocked thread.
  */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ebefb54..c4c675d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -55,9 +55,6 @@

 asmlinkage extern void ret_from_fork(void);

-DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
-EXPORT_PER_CPU_SYMBOL(current_task);
-
 DEFINE_PER_CPU(unsigned long, old_rsp);
 static DEFINE_PER_CPU(unsigned char, is_idle);

-- 
1.6.0.2

