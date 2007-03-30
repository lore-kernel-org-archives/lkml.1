Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXC3Cg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXC3Cg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 22:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbXC3Cg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 22:36:58 -0400
Received: from ozlabs.org ([203.10.76.45]:48999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810AbXC3Cg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 22:36:57 -0400
Subject: [PATCH] Cleanup: i386 separate hardware-defined TSS from Linux
	additions
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: akpm@linux-foundation.org, bunk@stusta.de,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200703291316.56393.ak@suse.de>
References: <200703270607.l2R672de009090@shell0.pdx.osdl.net>
	 <200703291219.47276.ak@suse.de>
	 <1175165905.12230.201.camel@localhost.localdomain>
	 <200703291316.56393.ak@suse.de>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 12:36:35 +1000
Message-Id: <1175222195.12230.363.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-29 at 13:16 +0200, Andi Kleen wrote:
> Please clean it up properly with two structs.

Not sure about this, now I've done it.  Running it here.

If you like it, I can do x86-64 as well.

==
lguest defines its own TSS struct because the "struct tss_struct"
contains linux-specific additions.  Andi asked me to split the struct
in processor.h.

Unfortunately it makes usage a little awkward.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 7edfac26a523 include/asm-i386/processor.h
--- a/include/asm-i386/processor.h	Thu Mar 29 20:02:17 2007 +1000
+++ b/include/asm-i386/processor.h	Fri Mar 30 12:22:38 2007 +1000
@@ -325,7 +325,8 @@ typedef struct {
 
 struct thread_struct;
 
-struct tss_struct {
+/* This is the TSS defined by the hardware. */
+struct i386_hw_tss {
 	unsigned short	back_link,__blh;
 	unsigned long	esp0;
 	unsigned short	ss0,__ss0h;
@@ -349,6 +350,11 @@ struct tss_struct {
 	unsigned short	gs, __gsh;
 	unsigned short	ldt, __ldth;
 	unsigned short	trace, io_bitmap_base;
+} __attribute__((packed));
+
+struct tss_struct {
+	struct i386_hw_tss x86_tss;
+
 	/*
 	 * The extra 1 is there because the CPU will access an
 	 * additional byte beyond the end of the IO permission
@@ -415,10 +421,12 @@ struct thread_struct {
  * be within the limit.
  */
 #define INIT_TSS  {							\
-	.esp0		= sizeof(init_stack) + (long)&init_stack,	\
-	.ss0		= __KERNEL_DS,					\
-	.ss1		= __KERNEL_CS,					\
-	.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,			\
+	.x86_tss = {							\
+		.esp0		= sizeof(init_stack) + (long)&init_stack, \
+		.ss0		= __KERNEL_DS,				\
+		.ss1		= __KERNEL_CS,				\
+		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,		\
+	 },								\
 	.io_bitmap	= { [ 0 ... IO_BITMAP_LONGS] = ~0 },		\
 }
 
@@ -527,10 +535,10 @@ static inline void rep_nop(void)
 
 static inline void native_load_esp0(struct tss_struct *tss, struct thread_struct *thread)
 {
-	tss->esp0 = thread->esp0;
+	tss->x86_tss.esp0 = thread->esp0;
 	/* This can only happen when SEP is enabled, no need to test "SEP"arately */
-	if (unlikely(tss->ss1 != thread->sysenter_cs)) {
-		tss->ss1 = thread->sysenter_cs;
+	if (unlikely(tss->x86_tss.ss1 != thread->sysenter_cs)) {
+		tss->x86_tss.ss1 = thread->sysenter_cs;
 		wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
 	}
 }
diff -r 7edfac26a523 arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c	Thu Mar 29 20:02:17 2007 +1000
+++ b/arch/i386/kernel/asm-offsets.c	Fri Mar 30 12:23:11 2007 +1000
@@ -93,7 +93,7 @@ void foo(void)
 	OFFSET(pbe_next, pbe, next);
 
 	/* Offset from the sysenter stack to tss.esp0 */
-	DEFINE(TSS_sysenter_esp0, offsetof(struct tss_struct, esp0) -
+	DEFINE(TSS_sysenter_esp0, offsetof(struct tss_struct, x86_tss.esp0) -
 		 sizeof(struct tss_struct));
 
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
diff -r 7edfac26a523 arch/i386/kernel/doublefault.c
--- a/arch/i386/kernel/doublefault.c	Thu Mar 29 20:02:17 2007 +1000
+++ b/arch/i386/kernel/doublefault.c	Fri Mar 30 12:26:12 2007 +1000
@@ -33,7 +33,7 @@ static void doublefault_fn(void)
 		printk("double fault, tss at %08lx\n", tss);
 
 		if (ptr_ok(tss)) {
-			struct tss_struct *t = (struct tss_struct *)tss;
+			struct i386_hw_tss *t = (struct i386_hw_tss *)tss;
 
 			printk("eip = %08lx, esp = %08lx\n", t->eip, t->esp);
 
@@ -49,18 +49,21 @@ static void doublefault_fn(void)
 }
 
 struct tss_struct doublefault_tss __cacheline_aligned = {
-	.esp0		= STACK_START,
-	.ss0		= __KERNEL_DS,
-	.ldt		= 0,
-	.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,
+	.x86_tss = {
+		.esp0		= STACK_START,
+		.ss0		= __KERNEL_DS,
+		.ldt		= 0,
+		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,
 
-	.eip		= (unsigned long) doublefault_fn,
-	.eflags		= X86_EFLAGS_SF | 0x2,	/* 0x2 bit is always set */
-	.esp		= STACK_START,
-	.es		= __USER_DS,
-	.cs		= __KERNEL_CS,
-	.ss		= __KERNEL_DS,
-	.ds		= __USER_DS,
+		.eip		= (unsigned long) doublefault_fn,
+		/* 0x2 bit is always set */
+		.eflags		= X86_EFLAGS_SF | 0x2,
+		.esp		= STACK_START,
+		.es		= __USER_DS,
+		.cs		= __KERNEL_CS,
+		.ss		= __KERNEL_DS,
+		.ds		= __USER_DS,
 
-	.__cr3		= __pa(swapper_pg_dir)
+		.__cr3		= __pa(swapper_pg_dir)
+	}
 };
diff -r 7edfac26a523 arch/i386/kernel/ioport.c
--- a/arch/i386/kernel/ioport.c	Thu Mar 29 20:02:17 2007 +1000
+++ b/arch/i386/kernel/ioport.c	Fri Mar 30 12:22:38 2007 +1000
@@ -113,7 +113,7 @@ asmlinkage long sys_ioperm(unsigned long
 	 * Reset the owner so that a process switch will not set
 	 * tss->io_bitmap_base to IO_BITMAP_OFFSET.
 	 */
-	tss->io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
+	tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
 	tss->io_bitmap_owner = NULL;
 
 	put_cpu();
diff -r 7edfac26a523 arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c	Thu Mar 29 20:02:17 2007 +1000
+++ b/arch/i386/kernel/process.c	Fri Mar 30 12:22:38 2007 +1000
@@ -376,7 +376,7 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		tss->io_bitmap_owner = NULL;
 		tss->io_bitmap_max = 0;
-		tss->io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
+		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
 }
@@ -555,7 +555,7 @@ static noinline void __switch_to_xtra(st
 		 * Disable the bitmap via an invalid offset. We still cache
 		 * the previous bitmap owner and the IO bitmap contents:
 		 */
-		tss->io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
+		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		return;
 	}
 
@@ -565,7 +565,7 @@ static noinline void __switch_to_xtra(st
 		 * matches the next task, we dont have to do anything but
 		 * to set a valid offset in the TSS:
 		 */
-		tss->io_bitmap_base = IO_BITMAP_OFFSET;
+		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
 		return;
 	}
 	/*
@@ -577,7 +577,7 @@ static noinline void __switch_to_xtra(st
 	 * redundant copies when the currently switched task does not
 	 * perform any I/O during its timeslice.
 	 */
-	tss->io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
+	tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
 }
 
 /*
diff -r 7edfac26a523 arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c	Thu Mar 29 20:02:17 2007 +1000
+++ b/arch/i386/kernel/sysenter.c	Fri Mar 30 12:22:38 2007 +1000
@@ -56,10 +56,10 @@ void enable_sep_cpu(void)
 		return;
 	}
 
-	tss->ss1 = __KERNEL_CS;
-	tss->esp1 = sizeof(struct tss_struct) + (unsigned long) tss;
+	tss->x86_tss.ss1 = __KERNEL_CS;
+	tss->x86_tss.esp1 = sizeof(struct tss_struct) + (unsigned long) tss;
 	wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
-	wrmsr(MSR_IA32_SYSENTER_ESP, tss->esp1, 0);
+	wrmsr(MSR_IA32_SYSENTER_ESP, tss->x86_tss.esp1, 0);
 	wrmsr(MSR_IA32_SYSENTER_EIP, (unsigned long) sysenter_entry, 0);
 	put_cpu();	
 }
diff -r 7edfac26a523 arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c	Thu Mar 29 20:02:17 2007 +1000
+++ b/arch/i386/kernel/traps.c	Fri Mar 30 12:22:38 2007 +1000
@@ -585,7 +585,7 @@ fastcall void __kprobes do_general_prote
 	 * and we set the offset field correctly. Then we let the CPU to
 	 * restart the faulting instruction.
 	 */
-	if (tss->io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
+	if (tss->x86_tss.io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
 	    thread->io_bitmap_ptr) {
 		memcpy(tss->io_bitmap, thread->io_bitmap_ptr,
 		       thread->io_bitmap_max);
@@ -598,7 +598,7 @@ fastcall void __kprobes do_general_prote
 				thread->io_bitmap_max, 0xff,
 				tss->io_bitmap_max - thread->io_bitmap_max);
 		tss->io_bitmap_max = thread->io_bitmap_max;
-		tss->io_bitmap_base = IO_BITMAP_OFFSET;
+		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
 		tss->io_bitmap_owner = thread;
 		put_cpu();
 		return;
diff -r 7edfac26a523 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Thu Mar 29 20:02:17 2007 +1000
+++ b/arch/i386/kernel/vmi.c	Fri Mar 30 12:22:38 2007 +1000
@@ -229,14 +229,14 @@ static void vmi_load_esp0(struct tss_str
 static void vmi_load_esp0(struct tss_struct *tss,
 				   struct thread_struct *thread)
 {
-	tss->esp0 = thread->esp0;
+	tss->x86_tss.esp0 = thread->esp0;
 
 	/* This can only happen when SEP is enabled, no need to test "SEP"arately */
-	if (unlikely(tss->ss1 != thread->sysenter_cs)) {
-		tss->ss1 = thread->sysenter_cs;
+	if (unlikely(tss->x86_tss.ss1 != thread->sysenter_cs)) {
+		tss->x86_tss.ss1 = thread->sysenter_cs;
 		wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
 	}
-	vmi_ops.set_kernel_stack(__KERNEL_DS, tss->esp0);
+	vmi_ops.set_kernel_stack(__KERNEL_DS, tss->x86_tss.esp0);
 }
 
 static void vmi_flush_tlb_user(void)


