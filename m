Return-Path: <linux-kernel-owner+w=401wt.eu-S1765297AbXLRBkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765297AbXLRBkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbXLRBhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:37:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995AbXLRBhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:37:17 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 9/21] [PATCH] unify tss_struct
Date: Mon, 17 Dec 2007 20:52:32 -0200
Message-Id: <11979320114180-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197932006634-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although slighly different, the tss_struct is very similar in x86_64 and
i386. The really different part, which matchs the hardware vision of it, is
now called x86_hw_tss, and each of the architectures provides yours.
It's then used as a field in the outter tss_struct.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/asm-offsets_64.c |    2 +-
 arch/x86/kernel/doublefault_32.c |    2 +-
 arch/x86/kernel/process_64.c     |    2 +-
 arch/x86/kernel/setup64.c        |    4 +-
 arch/x86/kernel/smpboot_64.c     |    2 +-
 include/asm-x86/lguest.h         |    2 +-
 include/asm-x86/processor.h      |   77 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor_32.h   |   62 ------------------------------
 include/asm-x86/processor_64.h   |   35 +-----------------
 9 files changed, 85 insertions(+), 103 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/asm-offsets_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/asm-offsets_64.c
+++ linux-2.6-x86/arch/x86/kernel/asm-offsets_64.c
@@ -109,7 +109,7 @@ int main(void)
 	ENTRY(cr4);
 	BLANK();
 #undef ENTRY
-	DEFINE(TSS_ist, offsetof(struct tss_struct, ist));
+	DEFINE(TSS_ist, offsetof(struct tss_struct, x86_tss.ist));
 	BLANK();
 	DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
 	BLANK();
Index: linux-2.6-x86/arch/x86/kernel/doublefault_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/doublefault_32.c
+++ linux-2.6-x86/arch/x86/kernel/doublefault_32.c
@@ -33,7 +33,7 @@ static void doublefault_fn(void)
 		printk(KERN_EMERG "double fault, tss at %08lx\n", tss);
 
 		if (ptr_ok(tss)) {
-			struct i386_hw_tss *t = (struct i386_hw_tss *)tss;
+			struct x86_hw_tss *t = (struct x86_hw_tss *)tss;
 
 			printk(KERN_EMERG "eip = %08lx, esp = %08lx\n",
 			       t->ip, t->sp);
Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-x86/arch/x86/kernel/process_64.c
@@ -628,7 +628,7 @@ __switch_to(struct task_struct *prev_p, 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
 	 */
-	tss->sp0 = next->sp0;
+	tss->x86_tss.sp0 = next->sp0;
 
 	/* 
 	 * Switch DS and ES.
Index: linux-2.6-x86/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/setup64.c
+++ linux-2.6-x86/arch/x86/kernel/setup64.c
@@ -258,10 +258,10 @@ void __cpuinit cpu_init (void)
 				      v, cpu); 
 		}
 		estacks += PAGE_SIZE << order[v];
-		orig_ist->ist[v] = t->ist[v] = (unsigned long)estacks;
+		orig_ist->ist[v] = t->x86_tss.ist[v] = (unsigned long)estacks;
 	}
 
-	t->io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
 	/*
 	 * <= is required because the CPU will access up to
 	 * 8 bits beyond the end of the IO permission bitmap.
Index: linux-2.6-x86/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/smpboot_64.c
+++ linux-2.6-x86/arch/x86/kernel/smpboot_64.c
@@ -614,7 +614,7 @@ do_rest:
 	start_rip = setup_trampoline();
 
 	init_rsp = c_idle.idle->thread.sp;
-	per_cpu(init_tss,cpu).sp0 = init_rsp;
+	per_cpu(init_tss, cpu).x86_tss.sp0 = init_rsp;
 	initial_code = start_secondary;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 
Index: linux-2.6-x86/include/asm-x86/lguest.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/lguest.h
+++ linux-2.6-x86/include/asm-x86/lguest.h
@@ -51,7 +51,7 @@ struct lguest_ro_state
 	/* Fields which are used when guest is running. */
 	struct desc_ptr guest_idt_desc;
 	struct desc_ptr guest_gdt_desc;
-	struct i386_hw_tss guest_tss;
+	struct x86_hw_tss guest_tss;
 	struct desc_struct guest_idt[IDT_ENTRIES];
 	struct desc_struct guest_gdt[GDT_ENTRIES];
 };
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -4,6 +4,7 @@
 #include <asm/processor-flags.h>
 
 #include <asm/page.h>
+#include <asm/percpu.h>
 #include <asm/system.h>
 
 /*
@@ -35,6 +36,82 @@ static inline void load_cr3(pgd_t *pgdir
 }
 
 #ifdef CONFIG_X86_32
+/* This is the TSS defined by the hardware. */
+struct x86_hw_tss {
+	unsigned short	back_link, __blh;
+	unsigned long	sp0;
+	unsigned short	ss0, __ss0h;
+	unsigned long	sp1;
+	unsigned short	ss1, __ss1h;	/* ss1 caches MSR_IA32_SYSENTER_CS */
+	unsigned long	sp2;
+	unsigned short	ss2, __ss2h;
+	unsigned long	__cr3;
+	unsigned long	ip;
+	unsigned long	flags;
+	unsigned long	ax, cx, dx, bx;
+	unsigned long	sp, bp, si, di;
+	unsigned short	es, __esh;
+	unsigned short	cs, __csh;
+	unsigned short	ss, __ssh;
+	unsigned short	ds, __dsh;
+	unsigned short	fs, __fsh;
+	unsigned short	gs, __gsh;
+	unsigned short	ldt, __ldth;
+	unsigned short	trace, io_bitmap_base;
+} __attribute__((packed));
+#else
+struct x86_hw_tss {
+	u32 reserved1;
+	u64 sp0;
+	u64 sp1;
+	u64 sp2;
+	u64 reserved2;
+	u64 ist[7];
+	u32 reserved3;
+	u32 reserved4;
+	u16 reserved5;
+	u16 io_bitmap_base;
+} __attribute__((packed)) ____cacheline_aligned;
+#endif
+
+/*
+ * Size of io_bitmap.
+ */
+#define IO_BITMAP_BITS  65536
+#define IO_BITMAP_BYTES (IO_BITMAP_BITS/8)
+#define IO_BITMAP_LONGS (IO_BITMAP_BYTES/sizeof(long))
+#define IO_BITMAP_OFFSET offsetof(struct tss_struct, io_bitmap)
+#define INVALID_IO_BITMAP_OFFSET 0x8000
+#define INVALID_IO_BITMAP_OFFSET_LAZY 0x9000
+
+struct tss_struct {
+	struct x86_hw_tss x86_tss;
+
+	/*
+	 * The extra 1 is there because the CPU will access an
+	 * additional byte beyond the end of the IO permission
+	 * bitmap. The extra byte must be all 1 bits, and must
+	 * be within the limit.
+	 */
+	unsigned long	io_bitmap[IO_BITMAP_LONGS + 1];
+	/*
+	 * Cache the current maximum and the last task that used the bitmap:
+	 */
+	unsigned long io_bitmap_max;
+	struct thread_struct *io_bitmap_owner;
+	/*
+	 * pads the TSS to be cacheline-aligned (size is 0x100)
+	 */
+	unsigned long __cacheline_filler[35];
+	/*
+	 * .. and then another 0x100 bytes for emergency kernel stack
+	 */
+	unsigned long stack[64];
+} __attribute__((packed));
+
+DECLARE_PER_CPU(struct tss_struct, init_tss);
+
+#ifdef CONFIG_X86_32
 # include "processor_32.h"
 #else
 # include "processor_64.h"
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -81,7 +81,6 @@ struct cpuinfo_x86 {
 extern struct cpuinfo_x86 boot_cpu_data;
 extern struct cpuinfo_x86 new_cpu_data;
 extern struct tss_struct doublefault_tss;
-DECLARE_PER_CPU(struct tss_struct, init_tss);
 
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
@@ -123,16 +122,6 @@ extern unsigned int mca_pentium_flag;
 #define TASK_SIZE	(PAGE_OFFSET)
 
 
-/*
- * Size of io_bitmap.
- */
-#define IO_BITMAP_BITS  65536
-#define IO_BITMAP_BYTES (IO_BITMAP_BITS/8)
-#define IO_BITMAP_LONGS (IO_BITMAP_BYTES/sizeof(long))
-#define IO_BITMAP_OFFSET offsetof(struct tss_struct,io_bitmap)
-#define INVALID_IO_BITMAP_OFFSET 0x8000
-#define INVALID_IO_BITMAP_OFFSET_LAZY 0x9000
-
 struct i387_fsave_struct {
 	long	cwd;
 	long	swd;
@@ -185,57 +174,6 @@ typedef struct {
 	unsigned long seg;
 } mm_segment_t;
 
-struct thread_struct;
-
-/* This is the TSS defined by the hardware. */
-struct i386_hw_tss {
-	unsigned short	back_link,__blh;
-	unsigned long	sp0;
-	unsigned short	ss0,__ss0h;
-	unsigned long	sp1;
-	unsigned short	ss1,__ss1h;	/* ss1 is used to cache MSR_IA32_SYSENTER_CS */
-	unsigned long	sp2;
-	unsigned short	ss2,__ss2h;
-	unsigned long	__cr3;
-	unsigned long	ip;
-	unsigned long	flags;
-	unsigned long	ax, cx, dx, bx;
-	unsigned long	sp, bp, si, di;
-	unsigned short	es, __esh;
-	unsigned short	cs, __csh;
-	unsigned short	ss, __ssh;
-	unsigned short	ds, __dsh;
-	unsigned short	fs, __fsh;
-	unsigned short	gs, __gsh;
-	unsigned short	ldt, __ldth;
-	unsigned short	trace, io_bitmap_base;
-} __attribute__((packed));
-
-struct tss_struct {
-	struct i386_hw_tss x86_tss;
-
-	/*
-	 * The extra 1 is there because the CPU will access an
-	 * additional byte beyond the end of the IO permission
-	 * bitmap. The extra byte must be all 1 bits, and must
-	 * be within the limit.
-	 */
-	unsigned long	io_bitmap[IO_BITMAP_LONGS + 1];
-	/*
-	 * Cache the current maximum and the last task that used the bitmap:
-	 */
-	unsigned long io_bitmap_max;
-	struct thread_struct *io_bitmap_owner;
-	/*
-	 * pads the TSS to be cacheline-aligned (size is 0x100)
-	 */
-	unsigned long __cacheline_filler[35];
-	/*
-	 * .. and then another 0x100 bytes for emergency kernel stack
-	 */
-	unsigned long stack[64];
-} __attribute__((packed));
-
 #define ARCH_MIN_TASKALIGN	16
 
 struct thread_struct {
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -91,14 +91,6 @@ extern void identify_cpu(struct cpuinfo_
 #define TASK_SIZE 		(test_thread_flag(TIF_IA32) ? IA32_PAGE_OFFSET : TASK_SIZE64)
 #define TASK_SIZE_OF(child) 	((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)
 
-/*
- * Size of io_bitmap.
- */
-#define IO_BITMAP_BITS  65536
-#define IO_BITMAP_BYTES (IO_BITMAP_BITS/8)
-#define IO_BITMAP_LONGS (IO_BITMAP_BYTES/sizeof(long))
-#define IO_BITMAP_OFFSET offsetof(struct tss_struct,io_bitmap)
-#define INVALID_IO_BITMAP_OFFSET 0x8000
 
 struct i387_fxsave_struct {
 	u16	cwd;
@@ -118,32 +110,7 @@ union i387_union {
 	struct i387_fxsave_struct	fxsave;
 };
 
-struct tss_struct {
-	u32 reserved1;
-	u64 sp0;	
-	u64 sp1;
-	u64 sp2;
-	u64 reserved2;
-	u64 ist[7];
-	u32 reserved3;
-	u32 reserved4;
-	u16 reserved5;
-	u16 io_bitmap_base;
-	/*
-	 * The extra 1 is there because the CPU will access an
-	 * additional byte beyond the end of the IO permission
-	 * bitmap. The extra byte must be all 1 bits, and must
-	 * be within the limit. Thus we have:
-	 *
-	 * 128 bytes, the bitmap itself, for ports 0..0x3ff
-	 * 8 bytes, for an extra "long" of ~0UL
-	 */
-	unsigned long io_bitmap[IO_BITMAP_LONGS + 1];
-} __attribute__((packed)) ____cacheline_aligned;
-
-
 extern struct cpuinfo_x86 boot_cpu_data;
-DECLARE_PER_CPU(struct tss_struct,init_tss);
 /* Save the original ist values for checking stack pointers during debugging */
 struct orig_ist {
 	unsigned long ist[7];
@@ -195,7 +162,7 @@ struct thread_struct {
 }
 
 #define INIT_TSS  { \
-	.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
+	.x86_tss.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
 }
 
 #define INIT_MMAP \
