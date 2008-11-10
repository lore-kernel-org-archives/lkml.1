Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYKJBbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYKJBbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 20:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYKJBay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 20:30:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbYKJBaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 20:30:52 -0500
Message-ID: <49178E89.2000307@zytor.com>
Date: Sun, 09 Nov 2008 17:29:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com>    <20081104150729.GC21470@localhost>    <20081104170501.GE29626@one.firstfloor.org>    <1225822006.21441.1282961299@webmail.messagingengine.com>    <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com>
In-Reply-To: <1226243805.27361.1283784629@webmail.messagingengine.com>
Content-Type: multipart/mixed;
 boundary="------------050502010904080504040404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050502010904080504040404
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Alexander van Heukelum wrote:
> 
> In general: after applying the patch, latencies are more
> often seen by the rdtsctest. It also seems to cause a
> small percentage decrease in speed of hackbench. 
> Looking at the latency histograms I believe this is
> a real effect, but I could not do enough boots/runs to
> make this a certainty from the runtimes alone.
> 
> At least for this PC, doing hpa's suggested cleanup of
> the stub table is the right way to go for now... A
> second option would be to get rid of the stub table by
> assigning each important vector a unique handler and
> to make sure those handlers do not rely on the vector
> number at all.
> 

Hi Alexander,

First of all, great job on the timing analysis.  I believe this confirms
the concerns that I had about this technique.

Here is a prototype patch of the compressed IRQ stubs -- this patch
compresses them down to 7 stubs per 32-byte cache line (or part of cache
line) at the expense of a back-to-back jmp which has the potential of
being ugly on some pipelines (we can only get 4 stubs into 32 bytes
without that).

Would you be willing to run your timing test on this patch?  This isn't
submission-quality since it commingles multiple changes, and it needs
some cleanup, but it should be useful for testing.

As a side benefit it eliminates some gratuitous differences between the
32- and 64-bit code.

	-hpa

--------------050502010904080504040404
Content-Type: text/x-patch;
 name="irqstubs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="irqstubs.patch"

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b97aecb..8de644b 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -109,9 +109,7 @@ extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 #endif
 
-#ifdef CONFIG_X86_32
-extern void (*const interrupt[NR_VECTORS])(void);
-#endif
+extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 28b597e..ffd1a55 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -619,29 +619,38 @@ END(syscall_badsys)
 27:;
 
 /*
- * Build the entry stubs and pointer table with
- * some assembler magic.
+ * Build the entry stubs and pointer table with some assembler magic.
+ * We pack 7 stubs into a single 32-byte chunk, which will fit in a
+ * single cache line on all modern x86 implementations.
  */
-.section .rodata,"a"
+	.section ".init.rodata","a"
 ENTRY(interrupt)
-.text
-
+	.text
+	.balign 32
 ENTRY(irq_entries_start)
 	RING0_INT_FRAME
-vector=0
-.rept NR_VECTORS
-	ALIGN
- .if vector
+vector=FIRST_EXTERNAL_VECTOR
+.rept (NR_VECTORS-FIRST_EXTERNAL_VECTOR+6)/7
+	.balign 32
+  .rept	7
+    .if vector < NR_VECTORS
+      .if vector != FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -4
- .endif
-1:	pushl $~(vector)
+      .endif
+1:	pushl $(~vector+0x80)	/* Note: always in signed byte range */
 	CFI_ADJUST_CFA_OFFSET 4
-	jmp common_interrupt
- .previous
+      .if ((vector-FIRST_EXTERNAL_VECTOR)%7) != 6
+	jmp 2f
+      .endif
+	.previous
 	.long 1b
- .text
+	.text
 vector=vector+1
+    .endif
+  .endr
+2:	jmp common_interrupt
 .endr
+	.balign 32
 END(irq_entries_start)
 
 .previous
@@ -654,6 +663,7 @@ END(interrupt)
  */
 	ALIGN
 common_interrupt:
+	addl $-0x80,(%esp)	/* Adjust vector into the [-256,-1] range */
 	SAVE_ALL
 	TRACE_IRQS_OFF
 	movl %esp,%eax
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ddeeb10..cd0ca70 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -629,6 +629,46 @@ END(stub_rt_sigreturn)
    vector already pushed) */
 #define XCPT_FRAME _frame ORIG_RAX
 
+/*
+ * Build the entry stubs and pointer table with some assembler magic.
+ * We pack 7 stubs into a single 32-byte chunk, which will fit in a
+ * single cache line on all modern x86 implementations.
+ */
+	.section ".init.rodata","a"
+ENTRY(interrupt)
+	.text
+	.balign 32
+ENTRY(irq_entries_start)
+	INTR_FRAME
+vector=FIRST_EXTERNAL_VECTOR
+.rept (NR_VECTORS-FIRST_EXTERNAL_VECTOR+6)/7
+	.balign 32
+  .rept	7
+    .if vector < NR_VECTORS
+      .if vector != FIRST_EXTERNAL_VECTOR
+	CFI_ADJUST_CFA_OFFSET -8
+      .endif
+1:	pushq $(~vector+0x80)	/* Note: always in signed byte range */
+	CFI_ADJUST_CFA_OFFSET 8
+      .if ((vector-FIRST_EXTERNAL_VECTOR)%7) != 6
+	jmp 2f
+      .endif
+	.previous
+	.quad 1b
+	.text
+vector=vector+1
+    .endif
+  .endr
+2:	jmp common_interrupt
+.endr
+	CFI_ENDPROC
+	.balign 32
+END(irq_entries_start)
+
+.previous
+END(interrupt)
+.previous
+
 /* 
  * Interrupt entry/exit.
  *
@@ -637,11 +677,12 @@ END(stub_rt_sigreturn)
  * Entry runs with interrupts off.	
  */ 
 
-/* 0(%rsp): interrupt number */ 
+/* 0(%rsp): ~(interrupt number)+0x80 */ 
 	.macro interrupt func
+	addq $-0x80,(%rsp)		/* Adjust vector to [-256,-1] range */
 	cld
 	SAVE_ARGS
-	leaq -ARGOFFSET(%rsp),%rdi	# arg1 for handler
+	leaq -ARGOFFSET(%rsp),%rdi	/* arg1 for handler */
 	pushq %rbp
 	/*
 	 * Save rbp twice: One is for marking the stack frame, as usual, and the
@@ -672,7 +713,7 @@ END(stub_rt_sigreturn)
 	call \func
 	.endm
 
-ENTRY(common_interrupt)
+common_interrupt:
 	XCPT_FRAME
 	interrupt do_IRQ
 	/* 0(%rsp): oldrsp-ARGOFFSET */
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 845aa98..607db63 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -129,7 +129,7 @@ void __init native_init_IRQ(void)
 	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* SYSCALL_VECTOR was reserved in trap_init. */
 		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i]);
+			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
 	}
 
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index ff02353..8670b3c 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -24,41 +24,6 @@
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
- */
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
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
  * (these are usually mapped to vectors 0x30-0x3f)
  */
@@ -73,37 +38,6 @@
  *
  * (these are usually mapped into the 0x30-0xff vector range)
  */
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
 
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index a5d8e1a..50a7792 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -590,7 +590,8 @@ static void __init lguest_init_IRQ(void)
 		 * a straightforward 1 to 1 mapping, so force that here. */
 		__get_cpu_var(vector_irq)[vector] = i;
 		if (vector != SYSCALL_VECTOR) {
-			set_intr_gate(vector, interrupt[vector]);
+			set_intr_gate(vector,
+				      interrupt[vector-FIRST_EXTERNAL_VECTOR]);
 			set_irq_chip_and_handler_name(i, &lguest_irq_controller,
 						      handle_level_irq,
 						      "level");

--------------050502010904080504040404--
