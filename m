Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbZIPWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbZIPWdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760204AbZIPWdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:33:23 -0400
Received: from kroah.org ([198.145.64.141]:40972 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758479AbZIPWcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:03 2009
Message-Id: <20090916222903.695585319@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 18/24] x86/i386: Make sure stack-protector segment base is cache aligned
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=x86-i386-make-sure-stack-protector-segment-base-is-cache-aligned.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 1ea0d14e480c245683927eecc03a70faf06e80c8 upstream.

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

We can't avoid having a non-zero base for the stack-protector
segment, but we can make it cache-aligned.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
LKML-Reference: <4AA01893.6000507@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/processor.h      |   12 +++++++++++-
 arch/x86/include/asm/stackprotector.h |    4 ++--
 arch/x86/include/asm/system.h         |    2 +-
 arch/x86/kernel/cpu/common.c          |    2 +-
 arch/x86/kernel/head_32.S             |    1 -
 5 files changed, 15 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,7 +402,17 @@ extern unsigned long kernel_eflags;
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
 
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -78,14 +78,14 @@ static __always_inline void boot_init_st
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
 
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -31,7 +31,7 @@ void __switch_to_xtra(struct task_struct
 	"movl %P[task_canary](%[next]), %%ebx\n\t"			\
 	"movl %%ebx, "__percpu_arg([stack_canary])"\n\t"
 #define __switch_canary_oparam						\
-	, [stack_canary] "=m" (per_cpu_var(stack_canary))
+	, [stack_canary] "=m" (per_cpu_var(stack_canary.canary))
 #define __switch_canary_iparam						\
 	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
 #else	/* CC_STACKPROTECTOR */
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1033,7 +1033,7 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist
 #else	/* CONFIG_X86_64 */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-DEFINE_PER_CPU(unsigned long, stack_canary);
+DEFINE_PER_CPU(struct stack_canary, stack_canary) ____cacheline_aligned;
 #endif
 
 /* Make sure %fs and %gs are initialized properly in idle threads */
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -442,7 +442,6 @@ is386:	movl $2,%ecx		# set MP
 	jne 1f
 	movl $per_cpu__gdt_page,%eax
 	movl $per_cpu__stack_canary,%ecx
-	subl $20, %ecx
 	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
 	shrl $16, %ecx
 	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)


