Return-Path: <linux-kernel-owner+w=401wt.eu-S1765479AbXLRBj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765479AbXLRBj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbXLRBhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:37:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbXLRBhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:37:04 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 7/21] [PATCH] unify common parts of processor.h
Date: Mon, 17 Dec 2007 20:52:30 -0200
Message-Id: <11979320011968-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979319953427-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the pieces of processor_32.h and processor_64 that are
equal to processor.h. Only what's exactly the same is moved around, the rest
not being touched.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h    |  116 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor_32.h |  111 --------------------------------------
 include/asm-x86/processor_64.h |  116 ----------------------------------------
 3 files changed, 116 insertions(+), 227 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -29,6 +29,11 @@ static inline void load_cr3(pgd_t *pgdir
 # include "processor_64.h"
 #endif
 
+extern void print_cpu_info(struct cpuinfo_x86 *);
+extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
+extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
+extern unsigned short num_cache_leaves;
+
 static inline unsigned long native_get_debugreg(int regno)
 {
 	unsigned long val = 0; 	/* Damn you, gcc! */
@@ -138,7 +143,53 @@ static inline void clear_in_cr4(unsigned
 	write_cr4(cr4);
 }
 
+struct microcode_header {
+	unsigned int hdrver;
+	unsigned int rev;
+	unsigned int date;
+	unsigned int sig;
+	unsigned int cksum;
+	unsigned int ldrver;
+	unsigned int pf;
+	unsigned int datasize;
+	unsigned int totalsize;
+	unsigned int reserved[3];
+};
+
+struct microcode {
+	struct microcode_header hdr;
+	unsigned int bits[0];
+};
+
+typedef struct microcode microcode_t;
+typedef struct microcode_header microcode_header_t;
+
+/* microcode format is extended from prescott processors */
+struct extended_signature {
+	unsigned int sig;
+	unsigned int pf;
+	unsigned int cksum;
+};
+
+struct extended_sigtable {
+	unsigned int count;
+	unsigned int cksum;
+	unsigned int reserved[3];
+	struct extended_signature sigs[0];
+};
+
+/*
+ * create a kernel thread without removing it from tasklists
+ */
+extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+
+/* Free all resources held by a thread. */
+extern void release_thread(struct task_struct *);
+
+/* Prepare to copy thread state - unlazy all lazy status */
+extern void prepare_to_copy(struct task_struct *tsk);
 
+unsigned long get_wchan(struct task_struct *p);
 
 /*
  * Generic CPUID function
@@ -196,4 +247,69 @@ static inline unsigned int cpuid_edx(uns
 	return edx;
 }
 
+/* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
+static inline void rep_nop(void)
+{
+	__asm__ __volatile__("rep;nop": : :"memory");
+}
+
+/* Stop speculative execution */
+static inline void sync_core(void)
+{
+	int tmp;
+	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
+					  : "ebx", "ecx", "edx", "memory");
+}
+
+#define cpu_relax()   rep_nop()
+
+static inline void __monitor(const void *eax, unsigned long ecx,
+		unsigned long edx)
+{
+	/* "monitor %eax,%ecx,%edx;" */
+	asm volatile(
+		".byte 0x0f,0x01,0xc8;"
+		: :"a" (eax), "c" (ecx), "d"(edx));
+}
+
+static inline void __mwait(unsigned long eax, unsigned long ecx)
+{
+	/* "mwait %eax,%ecx;" */
+	asm volatile(
+		".byte 0x0f,0x01,0xc9;"
+		: :"a" (eax), "c" (ecx));
+}
+
+static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
+{
+	/* "mwait %eax,%ecx;" */
+	asm volatile(
+		"sti; .byte 0x0f,0x01,0xc9;"
+		: :"a" (eax), "c" (ecx));
+}
+
+extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
+
+extern int force_mwait;
+
+extern void select_idle_routine(const struct cpuinfo_x86 *c);
+
+extern unsigned long boot_option_idle_override;
+
+/* Boot loader type from the setup header */
+extern int bootloader_type;
+#define cache_line_size() (boot_cpu_data.x86_cache_alignment)
+
+#define HAVE_ARCH_PICK_MMAP_LAYOUT 1
+#define ARCH_HAS_PREFETCHW
+#define ARCH_HAS_SPINLOCK_PREFETCH
+
+#define spin_lock_prefetch(x)	prefetchw(x)
+/* This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
+
+#define KSTK_EIP(task) (task_pt_regs(task)->ip)
+
 #endif
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -109,10 +109,6 @@ void __init cpu_detect(struct cpuinfo_x8
 
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
-extern void print_cpu_info(struct cpuinfo_x86 *);
-extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
-extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
-extern unsigned short num_cache_leaves;
 
 #ifdef CONFIG_X86_HT
 extern void detect_ht(struct cpuinfo_x86 *c);
@@ -120,32 +116,6 @@ extern void detect_ht(struct cpuinfo_x86
 static inline void detect_ht(struct cpuinfo_x86 *c) {}
 #endif
 
-/* Stop speculative execution */
-static inline void sync_core(void)
-{
-	int tmp;
-	asm volatile("cpuid" : "=a" (tmp) : "0" (1) : "ebx","ecx","edx","memory");
-}
-
-static inline void __monitor(const void *eax, unsigned long ecx,
-		unsigned long edx)
-{
-	/* "monitor %eax,%ecx,%edx;" */
-	asm volatile(
-		".byte 0x0f,0x01,0xc8;"
-		: :"a" (eax), "c" (ecx), "d"(edx));
-}
-
-static inline void __mwait(unsigned long eax, unsigned long ecx)
-{
-	/* "mwait %eax,%ecx;" */
-	asm volatile(
-		".byte 0x0f,0x01,0xc9;"
-		: :"a" (eax), "c" (ecx));
-}
-
-extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
-
 /* from system description table in BIOS.  Mostly for MCA use, but
 others may find it useful. */
 extern unsigned int machine_id;
@@ -153,20 +123,11 @@ extern unsigned int machine_submodel_id;
 extern unsigned int BIOS_revision;
 extern unsigned int mca_pentium_flag;
 
-/* Boot loader type from the setup header */
-extern int bootloader_type;
-
 /*
  * User space process size: 3GB (default).
  */
 #define TASK_SIZE	(PAGE_OFFSET)
 
-/* This decides where the kernel will search for a free chunk of vm
- * space during mmap's.
- */
-#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
-
-#define HAVE_ARCH_PICK_MMAP_LAYOUT
 
 /*
  * Size of io_bitmap.
@@ -356,25 +317,9 @@ struct thread_struct {
 	regs->sp = new_esp;					\
 } while (0)
 
-/* Forward declaration, a strange C thing */
-struct task_struct;
-struct mm_struct;
-
-/* Free all resources held by a thread. */
-extern void release_thread(struct task_struct *);
-
-/* Prepare to copy thread state - unlazy all lazy status */
-extern void prepare_to_copy(struct task_struct *tsk);
-
-/*
- * create a kernel thread without removing it from tasklists
- */
-extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
-unsigned long get_wchan(struct task_struct *p);
-
 #define THREAD_SIZE_LONGS      (THREAD_SIZE/sizeof(unsigned long))
 #define KSTK_TOP(info)                                                 \
 ({                                                                     \
@@ -399,53 +344,8 @@ unsigned long get_wchan(struct task_stru
        __regs__ - 1;                                                   \
 })
 
-#define KSTK_EIP(task) (task_pt_regs(task)->ip)
 #define KSTK_ESP(task) (task_pt_regs(task)->sp)
 
-
-struct microcode_header {
-	unsigned int hdrver;
-	unsigned int rev;
-	unsigned int date;
-	unsigned int sig;
-	unsigned int cksum;
-	unsigned int ldrver;
-	unsigned int pf;
-	unsigned int datasize;
-	unsigned int totalsize;
-	unsigned int reserved[3];
-};
-
-struct microcode {
-	struct microcode_header hdr;
-	unsigned int bits[0];
-};
-
-typedef struct microcode microcode_t;
-typedef struct microcode_header microcode_header_t;
-
-/* microcode format is extended from prescott processors */
-struct extended_signature {
-	unsigned int sig;
-	unsigned int pf;
-	unsigned int cksum;
-};
-
-struct extended_sigtable {
-	unsigned int count;
-	unsigned int cksum;
-	unsigned int reserved[3];
-	struct extended_signature sigs[0];
-};
-
-/* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
-static inline void rep_nop(void)
-{
-	__asm__ __volatile__("rep;nop": : :"memory");
-}
-
-#define cpu_relax()	rep_nop()
-
 static inline void native_load_sp0(struct tss_struct *tss, struct thread_struct *thread)
 {
 	tss->x86_tss.sp0 = thread->sp0;
@@ -555,7 +455,6 @@ static inline void load_sp0(struct tss_s
    because they are microcoded there and very slow.
    However we don't do prefetches for pre XP Athlons currently
    That should be fixed. */
-#define ARCH_HAS_PREFETCH
 static inline void prefetch(const void *x)
 {
 	alternative_input(ASM_NOP4,
@@ -565,8 +464,6 @@ static inline void prefetch(const void *
 }
 
 #define ARCH_HAS_PREFETCH
-#define ARCH_HAS_PREFETCHW
-#define ARCH_HAS_SPINLOCK_PREFETCH
 
 /* 3dnow! prefetch to get an exclusive cache line. Useful for 
    spinlocks to avoid one state transition in the cache coherency protocol. */
@@ -577,13 +474,7 @@ static inline void prefetchw(const void 
 			  X86_FEATURE_3DNOW,
 			  "r" (x));
 }
-#define spin_lock_prefetch(x)	prefetchw(x)
-
-extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
-#define cache_line_size() (boot_cpu_data.x86_cache_alignment)
-
-extern unsigned long boot_option_idle_override;
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
@@ -595,6 +486,4 @@ extern void switch_to_new_gdt(void);
 extern void cpu_init(void);
 extern void init_gdt(int cpu);
 
-extern int force_mwait;
-
 #endif /* __ASM_I386_PROCESSOR_H */
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -83,11 +83,6 @@ DECLARE_PER_CPU(struct cpuinfo_x86, cpu_
 extern char ignore_irq13;
 
 extern void identify_cpu(struct cpuinfo_x86 *);
-extern void print_cpu_info(struct cpuinfo_x86 *);
-extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
-extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
-extern unsigned short num_cache_leaves;
-
 
 /*
  * User space process size. 47bits minus one guard page.
@@ -102,8 +97,6 @@ extern unsigned short num_cache_leaves;
 #define TASK_SIZE 		(test_thread_flag(TIF_IA32) ? IA32_PAGE_OFFSET : TASK_SIZE64)
 #define TASK_SIZE_OF(child) 	((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)
 
-#define TASK_UNMAPPED_BASE	PAGE_ALIGN(TASK_SIZE/3)
-
 /*
  * Size of io_bitmap.
  */
@@ -226,68 +219,16 @@ struct thread_struct {
 	set_fs(USER_DS);							 \
 } while(0) 
 
-struct task_struct;
-struct mm_struct;
-
-/* Free all resources held by a thread. */
-extern void release_thread(struct task_struct *);
-
-/* Prepare to copy thread state - unlazy all lazy status */
-extern void prepare_to_copy(struct task_struct *tsk);
-
-/*
- * create a kernel thread without removing it from tasklists
- */
-extern long kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
-
 /*
  * Return saved PC of a blocked thread.
  * What is this good for? it will be always the scheduler or ret_from_fork.
  */
 #define thread_saved_pc(t) (*(unsigned long *)((t)->thread.sp - 8))
 
-extern unsigned long get_wchan(struct task_struct *p);
 #define task_pt_regs(tsk) ((struct pt_regs *)(tsk)->thread.sp0 - 1)
-#define KSTK_EIP(tsk) (task_pt_regs(tsk)->ip)
 #define KSTK_ESP(tsk) -1 /* sorry. doesn't work for syscall. */
 
 
-struct microcode_header {
-	unsigned int hdrver;
-	unsigned int rev;
-	unsigned int date;
-	unsigned int sig;
-	unsigned int cksum;
-	unsigned int ldrver;
-	unsigned int pf;
-	unsigned int datasize;
-	unsigned int totalsize;
-	unsigned int reserved[3];
-};
-
-struct microcode {
-	struct microcode_header hdr;
-	unsigned int bits[0];
-};
-
-typedef struct microcode microcode_t;
-typedef struct microcode_header microcode_header_t;
-
-/* microcode format is extended from prescott processors */
-struct extended_signature {
-	unsigned int sig;
-	unsigned int pf;
-	unsigned int cksum;
-};
-
-struct extended_sigtable {
-	unsigned int count;
-	unsigned int cksum;
-	unsigned int reserved[3];
-	struct extended_signature sigs[0];
-};
-
-
 #if defined(CONFIG_MPSC) || defined(CONFIG_MCORE2)
 #define ASM_NOP1 P6_NOP1
 #define ASM_NOP2 P6_NOP2
@@ -331,20 +272,6 @@ struct extended_sigtable {
 
 #define ASM_NOP_MAX 8
 
-/* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
-static inline void rep_nop(void)
-{
-	__asm__ __volatile__("rep;nop": : :"memory");
-}
-
-/* Stop speculative execution */
-static inline void sync_core(void)
-{ 
-	int tmp;
-	asm volatile("cpuid" : "=a" (tmp) : "0" (1) : "ebx","ecx","edx","memory");
-} 
-
-#define ARCH_HAS_PREFETCHW 1
 static inline void prefetchw(void *x) 
 { 
 	alternative_input("prefetcht0 (%1)",
@@ -353,42 +280,6 @@ static inline void prefetchw(void *x) 
 			  "r" (x));
 } 
 
-#define ARCH_HAS_SPINLOCK_PREFETCH 1
-
-#define spin_lock_prefetch(x)  prefetchw(x)
-
-#define cpu_relax()   rep_nop()
-
-static inline void __monitor(const void *eax, unsigned long ecx,
-		unsigned long edx)
-{
-	/* "monitor %eax,%ecx,%edx;" */
-	asm volatile(
-		".byte 0x0f,0x01,0xc8;"
-		: :"a" (eax), "c" (ecx), "d"(edx));
-}
-
-static inline void __mwait(unsigned long eax, unsigned long ecx)
-{
-	/* "mwait %eax,%ecx;" */
-	asm volatile(
-		".byte 0x0f,0x01,0xc9;"
-		: :"a" (eax), "c" (ecx));
-}
-
-static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
-{
-	/* "mwait %eax,%ecx;" */
-	asm volatile(
-		"sti; .byte 0x0f,0x01,0xc9;"
-		: :"a" (eax), "c" (ecx));
-}
-
-extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
-
-extern int force_mwait;
-
-extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
 #define stack_current() \
 ({								\
@@ -397,12 +288,5 @@ extern void select_idle_routine(const st
 	ti->task;					\
 })
 
-#define cache_line_size() (boot_cpu_data.x86_cache_alignment)
-
-extern unsigned long boot_option_idle_override;
-/* Boot loader type from the setup header */
-extern int bootloader_type;
-
-#define HAVE_ARCH_PICK_MMAP_LAYOUT 1
 
 #endif /* __ASM_X86_64_PROCESSOR_H */
