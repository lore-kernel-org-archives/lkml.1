Return-Path: <linux-kernel-owner+w=401wt.eu-S934975AbZAPOQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975AbZAPOQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760277AbZAPOQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:16:43 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:14025 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167AbZAPOQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YhNA6ZECEpufP8B87nmOR6cun525IkscCTvYZAtnSeFUh0ihYoKMl2LDw2YHxOodM8
         7NF6BLfxkJy+thT/g78lGGgz0JnlTU1qEtCvpRlvtl7WdXpLIRRqoktprDY/lQKKl8aZ
         ZW2vxYY25SHyzPpgAGEKVFRT871vQ+1Zy2KFE=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 03/17] x86-64: Convert irqstacks to per-cpu
Date: Fri, 16 Jan 2009 09:16:22 -0500
Message-Id: <1232115396-26367-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-2-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the irqstackptr variable from the PDA to per-cpu.
Make the stacks themselves per-cpu, removing some specific allocation code.
Add a seperate flag (is_boot_cpu) to simplify the per-cpu boot adjustments.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h       |    1 -
 arch/x86/include/asm/processor.h |    3 +++
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |   14 ++------------
 arch/x86/kernel/dumpstack_64.c   |    6 +++---
 arch/x86/kernel/entry_64.S       |    6 +++---
 arch/x86/kernel/head_64.S        |   16 +++++-----------
 arch/x86/kernel/setup_percpu.c   |    3 ++-
 arch/x86/kernel/smpboot.c        |    3 +++
 9 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 8ee835e..09965f7 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -22,7 +22,6 @@ struct x8664_pda {
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
 #endif
-	char *irqstackptr;
 	short nodenumber;		/* number of current node (32k max) */
 	short in_bootmem;		/* pda lives in bootmem */
 	short isidle;
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 091cd88..e32ee80 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -378,6 +378,9 @@ union thread_xstate {
 
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
+
+DECLARE_PER_CPU(char, irqstack[IRQSTACKSIZE]);
+DECLARE_PER_CPU(char *, irqstackptr);
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index f4cc81b..5b821fb 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -54,7 +54,6 @@ int main(void)
 	ENTRY(pcurrent); 
 	ENTRY(irqcount);
 	ENTRY(cpunumber);
-	ENTRY(irqstackptr);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
 #undef ENTRY
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3d0cc6f..5ddbca0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -881,7 +881,8 @@ __setup("clearcpuid=", setup_disablecpuid);
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-static char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
+DEFINE_PER_CPU_PAGE_ALIGNED(char, irqstack[IRQSTACKSIZE]) __aligned(PAGE_SIZE);
+DEFINE_PER_CPU(char *, irqstackptr) = per_cpu_var(irqstack) + IRQSTACKSIZE - 64;
 
 void __cpuinit pda_init(int cpu)
 {
@@ -901,18 +902,7 @@ void __cpuinit pda_init(int cpu)
 	if (cpu == 0) {
 		/* others are initialized in smpboot.c */
 		pda->pcurrent = &init_task;
-		pda->irqstackptr = boot_cpu_stack;
-		pda->irqstackptr += IRQSTACKSIZE - 64;
 	} else {
-		if (!pda->irqstackptr) {
-			pda->irqstackptr = (char *)
-				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-			if (!pda->irqstackptr)
-				panic("cannot allocate irqstack for cpu %d",
-				      cpu);
-			pda->irqstackptr += IRQSTACKSIZE - 64;
-		}
-
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
 			pda->nodenumber = cpu_to_node(cpu);
 	}
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index c302d07..46c6bf0 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -106,7 +106,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
+	unsigned long *irqstack_end = (unsigned long *)per_cpu(irqstackptr, cpu);
 	unsigned used = 0;
 	struct thread_info *tinfo;
 	int graph = 0;
@@ -200,9 +200,9 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	int i;
 	const int cpu = smp_processor_id();
 	unsigned long *irqstack_end =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
+		(unsigned long *) (per_cpu(irqstackptr, cpu));
 	unsigned long *irqstack =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+		(unsigned long *) (per_cpu(irqstackptr, cpu) - IRQSTACKSIZE);
 
 	/*
 	 * debugging aid: "show_stack(NULL, NULL);" prints the
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4833f3a..5cd892f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -345,7 +345,7 @@ ENTRY(save_args)
 1:	incl %gs:pda_irqcount
 	jne 2f
 	popq_cfi %rax			/* move return address... */
-	mov %gs:pda_irqstackptr,%rsp
+	mov PER_CPU_VAR(irqstackptr),%rsp
 	EMPTY_FRAME 0
 	pushq_cfi %rax			/* ... to the new stack */
 	/*
@@ -1261,7 +1261,7 @@ ENTRY(call_softirq)
 	mov  %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
 	incl %gs:pda_irqcount
-	cmove %gs:pda_irqstackptr,%rsp
+	cmove PER_CPU_VAR(irqstackptr),%rsp
 	push  %rbp			# backlink for old unwinder
 	call __do_softirq
 	leaveq
@@ -1300,7 +1300,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 11:	incl %gs:pda_irqcount
 	movq %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	cmovzq %gs:pda_irqstackptr,%rsp
+	cmovzq PER_CPU_VAR(irqstackptr),%rsp
 	pushq %rbp			# backlink for old unwinder
 	call xen_evtchn_do_upcall
 	popq %rsp
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index c8ace88..b565719 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -211,15 +211,13 @@ ENTRY(secondary_startup_64)
 	 * data area.  Computing this requires two symbols - __per_cpu_load
 	 * and per_cpu__gdt_page.  As linker can't do no such relocation, do
 	 * it by hand.  As early_gdt_descr is manipulated by C code for
-	 * secondary CPUs, this should be done only once for the boot CPU
-	 * when early_gdt_descr_base contains zero.
+	 * secondary CPUs, this should be done only once for the boot CPU.
 	 */
-	movq	early_gdt_descr_base(%rip), %rax
-	testq	%rax, %rax
-	jnz	1f
+	cmpb	$0, is_boot_cpu(%rip)
+	je	1f
 	movq	$__per_cpu_load, %rax
-	addq	$per_cpu__gdt_page, %rax
-	movq	%rax, early_gdt_descr_base(%rip)
+	addq	%rax, early_gdt_descr_base(%rip)
+	addq	%rax, per_cpu__irqstackptr(%rax)
 1:
 #endif
 	/*
@@ -431,12 +429,8 @@ NEXT_PAGE(level2_spare_pgt)
 	.globl early_gdt_descr
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
-#ifdef CONFIG_SMP
 early_gdt_descr_base:
-	.quad   0x0000000000000000
-#else
 	.quad	per_cpu__gdt_page
-#endif
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index b5c35af..e3d399f 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -192,7 +192,9 @@ void __init setup_per_cpu_areas(void)
 
 		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
+		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 #ifdef CONFIG_X86_64
+		per_cpu(irqstackptr, cpu) = per_cpu(irqstack, cpu) + IRQSTACKSIZE - 64;
 		/*
 		 * CPU0 modified pda in the init data area, reload pda
 		 * offset for CPU0 and clear the area for others.
@@ -202,7 +204,6 @@ void __init setup_per_cpu_areas(void)
 		else
 			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
 #endif
-		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2f0e0f1..a33da98 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -73,6 +73,8 @@ u8 apicid_2_node[MAX_APICID];
 static int low_mappings;
 #endif
 
+unsigned char is_boot_cpu = 1;
+
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
@@ -800,6 +802,7 @@ do_rest:
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
 #endif
+	is_boot_cpu = 0;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
 	stack_start.sp = (void *) c_idle.idle->thread.sp;
-- 
1.6.1.rc1

