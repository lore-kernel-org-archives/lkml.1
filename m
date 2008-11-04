Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYKDMcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYKDMcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYKDMbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:31:48 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:22825 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYKDMbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:31:44 -0500
Date: Tue, 4 Nov 2008 13:28:39 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       heukelum@fastmail.fm
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Travis <travis@sgi.com>
Subject: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104122839.GA22864@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Tue, 04 Nov 2008 13:30:49 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.10; VDF: 7.1.0.33; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

An x86 processor handles an interrupt (from an external
source, software generated or due to an exception),
depending on the contents if the IDT. Normally the IDT
contains mostly interrupt gates. Linux points each
interrupt gate to a unique function. Some are specific
to some task (handling traps, IPI's, ...), the others
are stubs that push the interrupt number to the stack
and jump to 'common_interrupt'.

This patch removes the need for the stubs.

An interrupt gate contains a FAR pointer to the interrupt
handler, meaning that the code segment of the interrupt
handler is also reloaded. Instead of pointing each (non-
specific) interrupt gate to a unique handler, we set a
unique code segment and use a common handler. When the
handler finishes the code segment is restored to the
'normal'/previous one.

In order to have a unique code segment for each interrupt
vector, the GDT is extended to 512 entries (1 full page),
and the last half of the page describes identical code
segments (identical, except for the number in the cs
register), which are refered to by the 256 interrupt
gates.

In this version, even the specialized handlers get run
with their code segment switched. This is not necessary,
but I like the fact that in a register dump one can now
see from the code segment that the code is ran due to
a (hard) interrupt. The exception I made is the int 0x80
(syscall), which runs with the normal kernel code segment.


Concluding: changing interrupt handling to this way
removes quite a bit of source code. It also removes the
need for the interrupt stubs and, on i386, pointers to
them. This saves a few kilobytes of code. The page
reserved for the GDT is now fully used. The cs register
indicating directly that code is executed on behalf of
a (hardware) interrupt is a nice debugging aid. This way
of handling interrupts also leads to cleaner code: this
patch already gets rid of some 'ugly' macro magic in
entry_32.S and irqinit_64.c.

More cleanup is certainly possible, but I have tried to
keep the changes local and small. If switching code
segments is too expensive for some paths, that can be
fixed by not doing that ;).

I'ld welcome some numbers on a few benchmarks on real
hardware (I only tested on qemu: debian runs without
noticable differences before/after this patch).

Greetings,
    Alexander

P.S. Just in case someone thinks this is a great idea and
testing and benchmarking goes well...

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

 arch/x86/include/asm/desc.h    |   24 +++++-----
 arch/x86/include/asm/segment.h |   14 +-----
 arch/x86/kernel/cpu/common.c   |    3 +
 arch/x86/kernel/entry_32.S     |   33 ++++----------
 arch/x86/kernel/head64.c       |    4 --
 arch/x86/kernel/head_32.S      |   37 +++++----------
 arch/x86/kernel/head_64.S      |   18 ++-----
 arch/x86/kernel/irqinit_32.c   |    4 +-
 arch/x86/kernel/irqinit_64.c   |   96 +++++++---------------------------------
 arch/x86/kernel/traps.c        |    4 +-
 10 files changed, 64 insertions(+), 173 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index e6b82b1..3125345 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -50,7 +50,7 @@ static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
 	gate->offset_low = PTR_LOW(func);
-	gate->segment = __KERNEL_CS;
+	gate->segment = seg;
 	gate->ist = ist;
 	gate->p = 1;
 	gate->dpl = dpl;
@@ -317,7 +317,7 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
 static inline void set_intr_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
+	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, (256 + n) * 8);
 }
 
 #define SYS_VECTOR_FREE		0
@@ -348,37 +348,37 @@ static inline void alloc_intr_gate(unsigned int n, void *addr)
 static inline void set_system_intr_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
+	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, (256 + n) * 8);
 }
 
-static inline void set_system_trap_gate(unsigned int n, void *addr)
+static inline void set_system_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
+#ifdef CONFIG_X86_64
+	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
+#else
 	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
+#endif
 }
 
-static inline void set_trap_gate(unsigned int n, void *addr)
-{
-	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_TRAP, addr, 0, 0, __KERNEL_CS);
-}
-
+#ifdef CONFIG_X86_32
 static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
 {
 	BUG_ON((unsigned)n > 0xFF);
 	_set_gate(n, GATE_TASK, (void *)0, 0, 0, (gdt_entry<<3));
 }
+#endif
 
 static inline void set_intr_gate_ist(int n, void *addr, unsigned ist)
 {
 	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_INTERRUPT, addr, 0, ist, __KERNEL_CS);
+	_set_gate(n, GATE_INTERRUPT, addr, 0, ist, (256 + n) * 8);
 }
 
 static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 {
 	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
+	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, (256 + n) * 8);
 }
 
 #else
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 1dc1b51..c494a15 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -97,11 +97,6 @@
 
 #define GDT_ENTRY_DOUBLEFAULT_TSS	31
 
-/*
- * The GDT has 32 entries
- */
-#define GDT_ENTRIES 32
-
 /* The PnP BIOS entries in the GDT */
 #define GDT_ENTRY_PNPBIOS_CS32		(GDT_ENTRY_PNPBIOS_BASE + 0)
 #define GDT_ENTRY_PNPBIOS_CS16		(GDT_ENTRY_PNPBIOS_BASE + 1)
@@ -171,8 +166,6 @@
 #define GS_TLS_SEL ((GDT_ENTRY_TLS_MIN+GS_TLS)*8 + 3)
 #define FS_TLS_SEL ((GDT_ENTRY_TLS_MIN+FS_TLS)*8 + 3)
 
-#define GDT_ENTRIES 16
-
 #endif
 
 #define __KERNEL_CS	(GDT_ENTRY_KERNEL_CS * 8)
@@ -195,15 +188,10 @@
 #define SEGMENT_TI_MASK		0x4
 
 #define IDT_ENTRIES 256
+#define GDT_ENTRIES 512
 #define NUM_EXCEPTION_VECTORS 32
 #define GDT_SIZE (GDT_ENTRIES * 8)
 #define GDT_ENTRY_TLS_ENTRIES 3
 #define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8)
 
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
-#endif
-#endif
-
 #endif /* _ASM_X86_SEGMENT_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b9c9ea0..8aed74b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -55,6 +55,7 @@ DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
 	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
+	[256 ... 511] = { { { 0x0000ffff, 0x00af9b00 } } }
 } };
 #else
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
@@ -90,6 +91,8 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 
 	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
 	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
+
+	[256 ... 511] = { { { 0x0000ffff, 0x00cf9a00 } } }
 } };
 #endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 28b597e..fadc971 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -622,31 +622,18 @@ END(syscall_badsys)
  * Build the entry stubs and pointer table with
  * some assembler magic.
  */
-.section .rodata,"a"
-ENTRY(interrupt)
-.text
-
-ENTRY(irq_entries_start)
+.p2align
+ENTRY(maininterrupt)
 	RING0_INT_FRAME
-vector=0
-.rept NR_VECTORS
-	ALIGN
- .if vector
-	CFI_ADJUST_CFA_OFFSET -4
- .endif
-1:	pushl $~(vector)
-	CFI_ADJUST_CFA_OFFSET 4
+	push %eax
+	push %eax
+	mov %cs,%eax
+	shr $3,%eax
+	and $0xff,%eax
+	not %eax
+	mov %eax,4(%esp)
+	pop %eax
 	jmp common_interrupt
- .previous
-	.long 1b
- .text
-vector=vector+1
-.endr
-END(irq_entries_start)
-
-.previous
-END(interrupt)
-.previous
 
 /*
  * the CPU automatically disables interrupts when executing an IRQ vector,
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index d16084f..3d4e142 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -100,11 +100,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	cleanup_highmap();
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
-#ifdef CONFIG_EARLY_PRINTK
-		set_intr_gate(i, &early_idt_handlers[i]);
-#else
 		set_intr_gate(i, early_idt_handler);
-#endif
 	}
 	load_idt((const struct desc_ptr *)&idt_descr);
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index eb7515c..028427c 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -486,7 +486,7 @@ check_x87:
  */
 setup_idt:
 	lea ignore_int,%edx
-	movl $(__KERNEL_CS << 16),%eax
+	movl $((256 * 8) << 16),%eax	/* cs = (256 + irq_nr) * 8 */
 	movw %dx,%ax		/* selector = 0x0010 = cs */
 	movw $0x8E00,%dx	/* interrupt gate - dpl=0, present */
 
@@ -496,12 +496,13 @@ rp_sidt:
 	movl %eax,(%edi)
 	movl %edx,4(%edi)
 	addl $8,%edi
+	addl $(8 << 16),%eax	/* cs = (256 + irq_nr) * 8 */
 	dec %ecx
 	jne rp_sidt
 
 .macro	set_early_handler handler,trapno
 	lea \handler,%edx
-	movl $(__KERNEL_CS << 16),%eax
+	movl $(((256 + \trapno) * 8) << 16),%eax
 	movw %dx,%ax
 	movw $0x8E00,%dx	/* interrupt gate - dpl=0, present */
 	lea idt_table,%edi
@@ -509,30 +510,15 @@ rp_sidt:
 	movl %edx,8*\trapno+4(%edi)
 .endm
 
-	set_early_handler handler=early_divide_err,trapno=0
-	set_early_handler handler=early_illegal_opcode,trapno=6
-	set_early_handler handler=early_protection_fault,trapno=13
-	set_early_handler handler=early_page_fault,trapno=14
+	set_early_handler handler=early_fault_fake_errorcode,trapno=0
+	set_early_handler handler=early_fault_fake_errorcode,trapno=6
+	set_early_handler handler=early_fault,trapno=13
+	set_early_handler handler=early_fault,trapno=14
 
 	ret
 
-early_divide_err:
-	xor %edx,%edx
-	pushl $0	/* fake errcode */
-	jmp early_fault
-
-early_illegal_opcode:
-	movl $6,%edx
-	pushl $0	/* fake errcode */
-	jmp early_fault
-
-early_protection_fault:
-	movl $13,%edx
-	jmp early_fault
-
-early_page_fault:
-	movl $14,%edx
-	jmp early_fault
+early_fault_fake_errorcode:
+	pushl $0
 
 early_fault:
 	cld
@@ -546,7 +532,10 @@ early_fault:
 	incl early_recursion_flag
 	movl %cr2,%eax
 	pushl %eax
-	pushl %edx		/* trapno */
+	mov %cs, %eax
+	shr $3, %eax
+	and $0xff, %eax
+	pushl %eax		/* trapno */
 	pushl $fault_msg
 #ifdef CONFIG_EARLY_PRINTK
 	call early_printk
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 26cfdc1..c2ec12f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -267,17 +267,6 @@ bad_address:
 	jmp bad_address
 
 	.section ".init.text","ax"
-#ifdef CONFIG_EARLY_PRINTK
-	.globl early_idt_handlers
-early_idt_handlers:
-	i = 0
-	.rept NUM_EXCEPTION_VECTORS
-	movl $i, %esi
-	jmp early_idt_handler
-	i = i + 1
-	.endr
-#endif
-
 ENTRY(early_idt_handler)
 #ifdef CONFIG_EARLY_PRINTK
 	cmpl $2,early_recursion_flag(%rip)
@@ -286,7 +275,9 @@ ENTRY(early_idt_handler)
 	GET_CR2_INTO_RCX
 	movq %rcx,%r9
 	xorl %r8d,%r8d		# zero for error code
-	movl %esi,%ecx		# get vector number
+	mov %cs, %ecx
+	shr $3, %ecx
+	and $0xff, %ecx		# get vector number from CS
 	# Test %ecx against mask of vectors that push error code.
 	cmpl $31,%ecx
 	ja 0f
@@ -295,7 +286,8 @@ ENTRY(early_idt_handler)
 	testl $0x27d00,%eax
 	je 0f
 	popq %r8		# get error code
-0:	movq 0(%rsp),%rcx	# get ip
+0:	mov %ecx, %esi		# vector number
+	movq 0(%rsp),%rcx	# get ip
 	movq 8(%rsp),%rdx	# get cs
 	xorl %eax,%eax
 	leaq early_idt_msg(%rip),%rdi
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 845aa98..d7c4b01 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -21,7 +21,7 @@
 #include <asm/arch_hooks.h>
 #include <asm/i8259.h>
 
-
+void maininterrupt(void);
 
 /*
  * Note that on a 486, we don't want to do a SIGFPE on an irq13
@@ -129,7 +129,7 @@ void __init native_init_IRQ(void)
 	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* SYSCALL_VECTOR was reserved in trap_init. */
 		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i]);
+			set_intr_gate(i, maininterrupt);
 	}
 
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index ff02353..36e7f6d 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -24,86 +24,22 @@
 #include <asm/i8259.h>
 
 /*
- * Common place to define all x86 IRQ vectors
- *
- * This builds up the IRQ handler stubs using some ugly macros in irq.h
- *
- * These macros create the low-level assembly IRQ routines that save
- * register context and call do_IRQ(). do_IRQ() then does all the
- * operations that are needed to keep the AT (or SMP IOAPIC)
- * interrupt-controller happy.
+ * All incoming IRQs are caught here.
  */
-
-#define IRQ_NAME2(nr) nr##_interrupt(void)
-#define IRQ_NAME(nr) IRQ_NAME2(IRQ##nr)
-
-/*
- *	SMP has a few special interrupts for IPI messages
- */
-
-#define BUILD_IRQ(nr)				\
-	asmlinkage void IRQ_NAME(nr);		\
-	asm("\n.text\n.p2align\n"		\
-	    "IRQ" #nr "_interrupt:\n\t"		\
-	    "push $~(" #nr ") ; "		\
-	    "jmp common_interrupt\n"		\
-	    ".previous");
-
-#define BI(x,y) \
-	BUILD_IRQ(x##y)
-
-#define BUILD_16_IRQS(x) \
-	BI(x,0) BI(x,1) BI(x,2) BI(x,3) \
-	BI(x,4) BI(x,5) BI(x,6) BI(x,7) \
-	BI(x,8) BI(x,9) BI(x,a) BI(x,b) \
-	BI(x,c) BI(x,d) BI(x,e) BI(x,f)
-
-/*
- * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
- * (these are usually mapped to vectors 0x30-0x3f)
- */
-
-/*
- * The IO-APIC gives us many more interrupt sources. Most of these
- * are unused but an SMP system is supposed to have enough memory ...
- * sometimes (mostly wrt. hw bugs) we get corrupted vectors all
- * across the spectrum, so we really want to be prepared to get all
- * of these. Plus, more powerful systems might have more than 64
- * IO-APIC registers.
- *
- * (these are usually mapped into the 0x30-0xff vector range)
- */
-				      BUILD_16_IRQS(0x2) BUILD_16_IRQS(0x3)
-BUILD_16_IRQS(0x4) BUILD_16_IRQS(0x5) BUILD_16_IRQS(0x6) BUILD_16_IRQS(0x7)
-BUILD_16_IRQS(0x8) BUILD_16_IRQS(0x9) BUILD_16_IRQS(0xa) BUILD_16_IRQS(0xb)
-BUILD_16_IRQS(0xc) BUILD_16_IRQS(0xd) BUILD_16_IRQS(0xe) BUILD_16_IRQS(0xf)
-
-#undef BUILD_16_IRQS
-#undef BI
-
-
-#define IRQ(x,y) \
-	IRQ##x##y##_interrupt
-
-#define IRQLIST_16(x) \
-	IRQ(x,0), IRQ(x,1), IRQ(x,2), IRQ(x,3), \
-	IRQ(x,4), IRQ(x,5), IRQ(x,6), IRQ(x,7), \
-	IRQ(x,8), IRQ(x,9), IRQ(x,a), IRQ(x,b), \
-	IRQ(x,c), IRQ(x,d), IRQ(x,e), IRQ(x,f)
-
-/* for the irq vectors */
-static void (*__initdata interrupt[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) = {
-					  IRQLIST_16(0x2), IRQLIST_16(0x3),
-	IRQLIST_16(0x4), IRQLIST_16(0x5), IRQLIST_16(0x6), IRQLIST_16(0x7),
-	IRQLIST_16(0x8), IRQLIST_16(0x9), IRQLIST_16(0xa), IRQLIST_16(0xb),
-	IRQLIST_16(0xc), IRQLIST_16(0xd), IRQLIST_16(0xe), IRQLIST_16(0xf)
-};
-
-#undef IRQ
-#undef IRQLIST_16
-
-
-
+asmlinkage void maininterrupt(void);
+asm("\n.text\n.p2align\n"
+	"maininterrupt:\n\t"
+	"push %rax\n\t"
+	"push %rax\n\t"
+	"mov %cs,%eax\n\t"
+	"shr $3,%eax\n\t"
+	"and $0xff,%eax\n\t"
+	"not %rax\n\t"
+	"mov %rax,8(%rsp)\n\t"
+	"pop %rax\n\t"
+	"jmp common_interrupt\n"
+	".previous"
+);
 
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
@@ -219,7 +155,7 @@ void __init native_init_IRQ(void)
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
 		if (vector != IA32_SYSCALL_VECTOR)
-			set_intr_gate(vector, interrupt[i]);
+			set_intr_gate(vector, maininterrupt);
 	}
 
 	apic_intr_init();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 47f6041..c2a794a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -996,7 +996,7 @@ void __init trap_init(void)
 	set_intr_gate(19, &simd_coprocessor_error);
 
 #ifdef CONFIG_IA32_EMULATION
-	set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
+	set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
 #endif
 
 #ifdef CONFIG_X86_32
@@ -1012,7 +1012,7 @@ void __init trap_init(void)
 		printk("done.\n");
 	}
 
-	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
+	set_system_gate(SYSCALL_VECTOR, &system_call);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
