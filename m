Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZICT1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZICT1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbZICT1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:27:15 -0400
Received: from claw.goop.org ([74.207.240.146]:59938 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbZICT1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:27:14 -0400
Message-ID: <4AA01893.6000507@goop.org>
Date: Thu, 03 Sep 2009 12:27:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/i386: make sure stack-protector segment base is cache
 aligned
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel Optimization Reference Guide says:

	In Intel Atom microarchitecture, the address generation unit
	assumes that the segment base will be 0 by default. Non-zero
	segment base will cause load and store operations to experience
	a delay.
		- If the segment base isn't aligned to a cache line
		  boundary, the max throughput of memory operations is
		  reduced to one [e]very 9 cycles.
	[...]
	Assembly/Compiler Coding Rule 15. (H impact, ML generality)
	For Intel Atom processors, use segments with base set to 0
	whenever possible; avoid non-zero segment base address that is
	not aligned to cache line boundary at all cost.

We can't avoid having a non-zero base for the stack-protector segment, but
we can make it cache-aligned.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0bfcf7e..f7d2c8f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -403,7 +403,17 @@ extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
-DECLARE_PER_CPU(unsigned long, stack_canary);
+/*
+ * Make sure stack canary segment base is cached-aligned:
+ *   "For Intel Atom processors, avoid non zero segment base address
+ *    that is not aligned to cache line boundary at all cost."
+ * (Optim Ref Manual Assembly/Compiler Coding Rule 15.)
+ */
+struct stack_canary {
+	char __pad[20];		/* canary at %gs:20 */
+	unsigned long canary;
+};
+DECLARE_PER_CPU(struct stack_canary, stack_canary) ____cacheline_aligned;
 #endif
 #endif	/* X86_64 */
 
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index c2d742c..decad97 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -78,14 +78,14 @@ static __always_inline void boot_init_stack_canary(void)
 #ifdef CONFIG_X86_64
 	percpu_write(irq_stack_union.stack_canary, canary);
 #else
-	percpu_write(stack_canary, canary);
+	percpu_write(stack_canary.canary, canary);
 #endif
 }
 
 static inline void setup_stack_canary_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
-	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu) - 20;
+	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu);
 	struct desc_struct *gdt_table = get_cpu_gdt_table(cpu);
 	struct desc_struct desc;
 
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 643c59b..5bd119b 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -31,7 +31,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 	"movl %P[task_canary](%[next]), %%ebx\n\t"			\
 	"movl %%ebx, "__percpu_arg([stack_canary])"\n\t"
 #define __switch_canary_oparam						\
-	, [stack_canary] "=m" (per_cpu_var(stack_canary))
+	, [stack_canary] "=m" (per_cpu_var(stack_canary.canary))
 #define __switch_canary_iparam						\
 	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
 #else	/* CC_STACKPROTECTOR */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5ce60a8..e338b5c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1043,7 +1043,7 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist);
 #else	/* CONFIG_X86_64 */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-DEFINE_PER_CPU(unsigned long, stack_canary);
+DEFINE_PER_CPU(struct stack_canary, stack_canary) ____cacheline_aligned;
 #endif
 
 /* Make sure %fs and %gs are initialized properly in idle threads */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index cc827ac..7ffec6b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -439,7 +439,6 @@ is386:	movl $2,%ecx		# set MP
 	jne 1f
 	movl $per_cpu__gdt_page,%eax
 	movl $per_cpu__stack_canary,%ecx
-	subl $20, %ecx
 	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
 	shrl $16, %ecx
 	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)


