Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbYEOEAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbYEOEAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 00:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYEOD7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:59:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbYEOD7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:59:20 -0400
Message-Id: <20080515035918.896765954@goodmis.org>
References: <20080515034942.109223655@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 May 2008 23:49:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       paulus@samba.org, benh@kernel.crashing.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: support for PowerPC
Content-Disposition: inline; filename=ftrace-powerpc-port.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds full support for ftrace for PowerPC (both 64 and 32 bit).
This includes dynamic tracing and function filtering.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/Kconfig                     |    5 
 arch/powerpc/kernel/Makefile             |   14 ++
 arch/powerpc/kernel/entry_32.S           |  130 ++++++++++++++++++++++++
 arch/powerpc/kernel/entry_64.S           |   62 +++++++++++
 arch/powerpc/kernel/ftrace.c             |  165 +++++++++++++++++++++++++++++++
 arch/powerpc/kernel/io.c                 |    3 
 arch/powerpc/kernel/irq.c                |    6 -
 arch/powerpc/kernel/setup_32.c           |   11 +-
 arch/powerpc/kernel/setup_64.c           |    5 
 arch/powerpc/platforms/powermac/Makefile |    5 
 kernel/trace/trace_selftest.c            |   11 +-
 11 files changed, 406 insertions(+), 11 deletions(-)

Index: linux-sched-devel.git/arch/powerpc/kernel/io.c
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/kernel/io.c	2008-05-14 19:30:53.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/kernel/io.c	2008-05-14 19:31:48.000000000 -0700
@@ -120,7 +120,8 @@ EXPORT_SYMBOL(_outsl_ns);
 
 #define IO_CHECK_ALIGN(v,a) ((((unsigned long)(v)) & ((a) - 1)) == 0)
 
-void _memset_io(volatile void __iomem *addr, int c, unsigned long n)
+notrace void
+_memset_io(volatile void __iomem *addr, int c, unsigned long n)
 {
 	void *p = (void __force *)addr;
 	u32 lc = c;
Index: linux-sched-devel.git/arch/powerpc/kernel/Makefile
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/kernel/Makefile	2008-05-14 19:30:53.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/kernel/Makefile	2008-05-14 19:31:56.000000000 -0700
@@ -12,6 +12,18 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+ifdef CONFIG_FTRACE
+# Do not trace early boot code
+CFLAGS_REMOVE_cputable.o = -pg
+CFLAGS_REMOVE_prom_init.o = -pg
+
+ifdef CONFIG_DYNAMIC_FTRACE
+# dynamic ftrace setup.
+CFLAGS_REMOVE_ftrace.o = -pg
+endif
+
+endif
+
 obj-y				:= cputable.o ptrace.o syscalls.o \
 				   irq.o align.o signal_32.o pmc.o vdso.o \
 				   init_task.o process.o systbl.o idle.o \
@@ -79,6 +91,8 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o 
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
+obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+
 obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
 
 ifneq ($(CONFIG_PPC_INDIRECT_IO),y)
Index: linux-sched-devel.git/arch/powerpc/platforms/powermac/Makefile
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/platforms/powermac/Makefile	2008-05-14 19:30:53.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/platforms/powermac/Makefile	2008-05-14 19:31:48.000000000 -0700
@@ -1,5 +1,10 @@
 CFLAGS_bootx_init.o  		+= -fPIC
 
+ifdef CONFIG_FTRACE
+# Do not trace early boot code
+CFLAGS_REMOVE_bootx_init.o = -pg
+endif
+
 obj-y				+= pic.o setup.o time.o feature.o pci.o \
 				   sleep.o low_i2c.o cache.o pfunc_core.o \
 				   pfunc_base.o
Index: linux-sched-devel.git/arch/powerpc/Kconfig
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/Kconfig	2008-05-14 19:30:50.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/Kconfig	2008-05-14 19:31:56.000000000 -0700
@@ -106,11 +106,12 @@ config PPC
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_OPROFILE
+	select HAVE_IMMEDIATE
+	select HAVE_FTRACE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
-	select HAVE_IMMEDIATE
+	select HAVE_OPROFILE
 
 config EARLY_PRINTK
 	bool
Index: linux-sched-devel.git/arch/powerpc/kernel/entry_32.S
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/kernel/entry_32.S	2008-05-14 19:30:50.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/kernel/entry_32.S	2008-05-14 19:31:56.000000000 -0700
@@ -1035,3 +1035,133 @@ machine_check_in_rtas:
 	/* XXX load up BATs and panic */
 
 #endif /* CONFIG_PPC_RTAS */
+
+#ifdef CONFIG_FTRACE
+#ifdef CONFIG_DYNAMIC_FTRACE
+_GLOBAL(mcount)
+_GLOBAL(_mcount)
+	stwu	r1,-48(r1)
+	stw	r3, 12(r1)
+	stw	r4, 16(r1)
+	stw	r5, 20(r1)
+	stw	r6, 24(r1)
+	mflr	r3
+	stw	r7, 28(r1)
+	mfcr	r5
+	stw	r8, 32(r1)
+	stw	r9, 36(r1)
+	stw	r10,40(r1)
+	stw	r3, 44(r1)
+	stw	r5, 8(r1)
+	.globl mcount_call
+mcount_call:
+	bl	ftrace_stub
+	nop
+	lwz	r6, 8(r1)
+	lwz	r0, 44(r1)
+	lwz	r3, 12(r1)
+	mtctr	r0
+	lwz	r4, 16(r1)
+	mtcr	r6
+	lwz	r5, 20(r1)
+	lwz	r6, 24(r1)
+	lwz	r0, 52(r1)
+	lwz	r7, 28(r1)
+	lwz	r8, 32(r1)
+	mtlr	r0
+	lwz	r9, 36(r1)
+	lwz	r10,40(r1)
+	addi	r1, r1, 48
+	bctr
+
+_GLOBAL(ftrace_caller)
+	/* Based off of objdump optput from glibc */
+	stwu	r1,-48(r1)
+	stw	r3, 12(r1)
+	stw	r4, 16(r1)
+	stw	r5, 20(r1)
+	stw	r6, 24(r1)
+	mflr	r3
+	lwz	r4, 52(r1)
+	mfcr	r5
+	stw	r7, 28(r1)
+	stw	r8, 32(r1)
+	stw	r9, 36(r1)
+	stw	r10,40(r1)
+	stw	r3, 44(r1)
+	stw	r5, 8(r1)
+.globl ftrace_call
+ftrace_call:
+	bl	ftrace_stub
+	nop
+	lwz	r6, 8(r1)
+	lwz	r0, 44(r1)
+	lwz	r3, 12(r1)
+	mtctr	r0
+	lwz	r4, 16(r1)
+	mtcr	r6
+	lwz	r5, 20(r1)
+	lwz	r6, 24(r1)
+	lwz	r0, 52(r1)
+	lwz	r7, 28(r1)
+	lwz	r8, 32(r1)
+	mtlr	r0
+	lwz	r9, 36(r1)
+	lwz	r10,40(r1)
+	addi	r1, r1, 48
+	bctr
+#else
+_GLOBAL(mcount)
+_GLOBAL(_mcount)
+	stwu	r1,-48(r1)
+	stw	r3, 12(r1)
+	stw	r4, 16(r1)
+	stw	r5, 20(r1)
+	stw	r6, 24(r1)
+	mflr	r3
+	lwz	r4, 52(r1)
+	mfcr	r5
+	stw	r7, 28(r1)
+	stw	r8, 32(r1)
+	stw	r9, 36(r1)
+	stw	r10,40(r1)
+	stw	r3, 44(r1)
+	stw	r5, 8(r1)
+
+	LOAD_REG_ADDR(r5, ftrace_trace_function)
+#if 0
+	mtctr	r3
+	mr	r1, r5
+	bctrl
+#endif
+	lwz	r5,0(r5)
+#if 1
+	mtctr	r5
+	bctrl
+#else
+	bl	ftrace_stub
+#endif
+	nop
+
+	lwz	r6, 8(r1)
+	lwz	r0, 44(r1)
+	lwz	r3, 12(r1)
+	mtctr	r0
+	lwz	r4, 16(r1)
+	mtcr	r6
+	lwz	r5, 20(r1)
+	lwz	r6, 24(r1)
+	lwz	r0, 52(r1)
+	lwz	r7, 28(r1)
+	lwz	r8, 32(r1)
+	mtlr	r0
+	lwz	r9, 36(r1)
+	lwz	r10,40(r1)
+	addi	r1, r1, 48
+	bctr
+#endif
+
+_GLOBAL(ftrace_stub)
+	blr
+
+#endif /* CONFIG_MCOUNT */
Index: linux-sched-devel.git/arch/powerpc/kernel/entry_64.S
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/kernel/entry_64.S	2008-05-14 19:30:50.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/kernel/entry_64.S	2008-05-14 19:31:56.000000000 -0700
@@ -870,3 +870,65 @@ _GLOBAL(enter_prom)
 	ld	r0,16(r1)
 	mtlr    r0
         blr
+
+#ifdef CONFIG_FTRACE
+#ifdef CONFIG_DYNAMIC_FTRACE
+_GLOBAL(mcount)
+_GLOBAL(_mcount)
+	/* Taken from output of objdump from lib64/glibc */
+	mflr	r3
+	stdu	r1, -112(r1)
+	std	r3, 128(r1)
+	.globl mcount_call
+mcount_call:
+	bl	ftrace_stub
+	nop
+	ld	r0, 128(r1)
+	mtlr	r0
+	addi	r1, r1, 112
+	blr
+
+_GLOBAL(ftrace_caller)
+	/* Taken from output of objdump from lib64/glibc */
+	mflr	r3
+	ld	r11, 0(r1)
+	stdu	r1, -112(r1)
+	std	r3, 128(r1)
+	ld	r4, 16(r11)
+.globl ftrace_call
+ftrace_call:
+	bl	ftrace_stub
+	nop
+	ld	r0, 128(r1)
+	mtlr	r0
+	addi	r1, r1, 112
+_GLOBAL(ftrace_stub)
+	blr
+#else
+_GLOBAL(mcount)
+	blr
+
+_GLOBAL(_mcount)
+	/* Taken from output of objdump from lib64/glibc */
+	mflr	r3
+	ld	r11, 0(r1)
+	stdu	r1, -112(r1)
+	std	r3, 128(r1)
+	ld	r4, 16(r11)
+
+
+	LOAD_REG_ADDR(r5,ftrace_trace_function)
+	ld	r5,0(r5)
+	ld	r5,0(r5)
+	mtctr	r5
+	bctrl
+
+	nop
+	ld	r0, 128(r1)
+	mtlr	r0
+	addi	r1, r1, 112
+_GLOBAL(ftrace_stub)
+	blr
+
+#endif
+#endif
Index: linux-sched-devel.git/arch/powerpc/kernel/ftrace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-sched-devel.git/arch/powerpc/kernel/ftrace.c	2008-05-14 19:31:56.000000000 -0700
@@ -0,0 +1,165 @@
+/*
+ * Code for replacing ftrace calls with jumps.
+ *
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ *
+ * Thanks goes out to P.A. Semi, Inc for supplying me with a PPC64 box.
+ *
+ */
+
+#include <linux/spinlock.h>
+#include <linux/hardirq.h>
+#include <linux/ftrace.h>
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <linux/list.h>
+
+#include <asm/cacheflush.h>
+
+#define CALL_BACK		4
+
+static unsigned int ftrace_nop = 0x60000000;
+
+#ifdef CONFIG_PPC32
+# define GET_ADDR(addr) addr
+#else
+/* PowerPC64's functions are data that points to the functions */
+# define GET_ADDR(addr) *(unsigned long *)addr
+#endif
+
+notrace int ftrace_ip_converted(unsigned long ip)
+{
+	unsigned int save;
+
+	ip -= CALL_BACK;
+	save = *(unsigned int *)ip;
+
+	return save == ftrace_nop;
+}
+
+static unsigned int notrace ftrace_calc_offset(long ip, long addr)
+{
+	return (int)((addr + CALL_BACK) - ip);
+}
+
+notrace unsigned char *ftrace_nop_replace(void)
+{
+	return (char *)&ftrace_nop;
+}
+
+notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+{
+	static unsigned int op;
+
+	addr = GET_ADDR(addr);
+
+	/* Set to "bl addr" */
+	op = 0x48000001 | (ftrace_calc_offset(ip, addr) & 0x03fffffe);
+
+	/*
+	 * No locking needed, this must be called via kstop_machine
+	 * which in essence is like running on a uniprocessor machine.
+	 */
+	return (unsigned char *)&op;
+}
+
+#ifdef CONFIG_PPC64
+# define _ASM_ALIGN	" .align 3 "
+# define _ASM_PTR	" .llong "
+#else
+# define _ASM_ALIGN	" .align 2 "
+# define _ASM_PTR	" .long "
+#endif
+
+notrace int
+ftrace_modify_code(unsigned long ip, unsigned char *old_code,
+		   unsigned char *new_code)
+{
+	unsigned replaced;
+	unsigned old = *(unsigned *)old_code;
+	unsigned new = *(unsigned *)new_code;
+	int faulted = 0;
+
+	/* move the IP back to the start of the call */
+	ip -= CALL_BACK;
+
+	/*
+	 * Note: Due to modules and __init, code can
+	 *  disappear and change, we need to protect against faulting
+	 *  as well as code changing.
+	 *
+	 * No real locking needed, this code is run through
+	 * kstop_machine.
+	 */
+	asm volatile (
+		"1: lwz		%1, 0(%2)\n"
+		"   cmpw	%1, %5\n"
+		"   bne		2f\n"
+		"   stwu	%3, 0(%2)\n"
+		"2:\n"
+		".section .fixup, \"ax\"\n"
+		"3:	li %0, 1\n"
+		"	b 2b\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		_ASM_ALIGN "\n"
+		_ASM_PTR "1b, 3b\n"
+		".previous"
+		: "=r"(faulted), "=r"(replaced)
+		: "r"(ip), "r"(new),
+		  "0"(faulted), "r"(old)
+		: "memory");
+
+	if (replaced != old && replaced != new)
+		faulted = 2;
+
+	if (!faulted)
+		flush_icache_range(ip, ip + 8);
+
+	return faulted;
+}
+
+notrace int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	unsigned long ip = (unsigned long)(&ftrace_call);
+	unsigned char old[4], *new;
+	int ret;
+
+	ip += CALL_BACK;
+
+	memcpy(old, &ftrace_call, 4);
+	new = ftrace_call_replace(ip, (unsigned long)func);
+	ret = ftrace_modify_code(ip, old, new);
+
+	return ret;
+}
+
+notrace int ftrace_mcount_set(unsigned long *data)
+{
+	unsigned long ip = (long)(&mcount_call);
+	unsigned long *addr = data;
+	unsigned char old[4], *new;
+
+	/* ip is at the location, but modify code will subtact this */
+	ip += CALL_BACK;
+
+	/*
+	 * Replace the mcount stub with a pointer to the
+	 * ip recorder function.
+	 */
+	memcpy(old, &mcount_call, 4);
+	new = ftrace_call_replace(ip, *addr);
+	*addr = ftrace_modify_code(ip, old, new);
+
+	return 0;
+}
+
+int __init ftrace_dyn_arch_init(void *data)
+{
+	/* This is running in kstop_machine */
+
+	ftrace_mcount_set(data);
+
+	return 0;
+}
+
Index: linux-sched-devel.git/arch/powerpc/kernel/irq.c
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/kernel/irq.c	2008-05-14 19:30:50.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/kernel/irq.c	2008-05-14 19:31:56.000000000 -0700
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(irq_desc);
 
 int distribute_irqs = 1;
 
-static inline unsigned long get_hard_enabled(void)
+static inline notrace unsigned long get_hard_enabled(void)
 {
 	unsigned long enabled;
 
@@ -108,13 +108,13 @@ static inline unsigned long get_hard_ena
 	return enabled;
 }
 
-static inline void set_soft_enabled(unsigned long enable)
+static inline notrace void set_soft_enabled(unsigned long enable)
 {
 	__asm__ __volatile__("stb %0,%1(13)"
 	: : "r" (enable), "i" (offsetof(struct paca_struct, soft_enabled)));
 }
 
-void raw_local_irq_restore(unsigned long en)
+notrace void raw_local_irq_restore(unsigned long en)
 {
 	/*
 	 * get_paca()->soft_enabled = en;
Index: linux-sched-devel.git/arch/powerpc/kernel/setup_32.c
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/kernel/setup_32.c	2008-05-14 19:30:50.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/kernel/setup_32.c	2008-05-14 19:31:56.000000000 -0700
@@ -47,6 +47,11 @@
 #include <asm/kgdb.h>
 #endif
 
+#ifdef CONFIG_FTRACE
+extern void _mcount(void);
+EXPORT_SYMBOL(_mcount);
+#endif
+
 extern void bootx_init(unsigned long r4, unsigned long phys);
 
 int boot_cpuid;
@@ -81,7 +86,7 @@ int ucache_bsize;
  * from the address that it was linked at, so we must use RELOC/PTRRELOC
  * to access static data (including strings).  -- paulus
  */
-unsigned long __init early_init(unsigned long dt_ptr)
+notrace unsigned long __init early_init(unsigned long dt_ptr)
 {
 	unsigned long offset = reloc_offset();
 	struct cpu_spec *spec;
@@ -111,7 +116,7 @@ unsigned long __init early_init(unsigned
  * This is called very early on the boot process, after a minimal
  * MMU environment has been set up but before MMU_init is called.
  */
-void __init machine_init(unsigned long dt_ptr, unsigned long phys)
+notrace void __init machine_init(unsigned long dt_ptr, unsigned long phys)
 {
 	/* Enable early debugging if any specified (see udbg.h) */
 	udbg_early_init();
@@ -133,7 +138,7 @@ void __init machine_init(unsigned long d
 
 #ifdef CONFIG_BOOKE_WDT
 /* Checks wdt=x and wdt_period=xx command-line option */
-int __init early_parse_wdt(char *p)
+notrace int __init early_parse_wdt(char *p)
 {
 	if (p && strncmp(p, "0", 1) != 0)
 	       booke_wdt_enabled = 1;
Index: linux-sched-devel.git/arch/powerpc/kernel/setup_64.c
===================================================================
--- linux-sched-devel.git.orig/arch/powerpc/kernel/setup_64.c	2008-05-14 19:30:50.000000000 -0700
+++ linux-sched-devel.git/arch/powerpc/kernel/setup_64.c	2008-05-14 19:31:56.000000000 -0700
@@ -85,6 +85,11 @@ struct ppc64_caches ppc64_caches = {
 };
 EXPORT_SYMBOL_GPL(ppc64_caches);
 
+#ifdef CONFIG_FTRACE
+extern void _mcount(void);
+EXPORT_SYMBOL(_mcount);
+#endif
+
 /*
  * These are used in binfmt_elf.c to put aux entries on the stack
  * for each elf executable being started.
Index: linux-sched-devel.git/kernel/trace/trace_selftest.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace_selftest.c	2008-05-14 19:30:50.000000000 -0700
+++ linux-sched-devel.git/kernel/trace/trace_selftest.c	2008-05-14 19:31:56.000000000 -0700
@@ -123,6 +123,7 @@ int trace_selftest_startup_dynamic_traci
 	int ret;
 	int save_ftrace_enabled = ftrace_enabled;
 	int save_tracer_enabled = tracer_enabled;
+	char *func_name;
 
 	/* The ftrace test PASSED */
 	printk(KERN_CONT "PASSED\n");
@@ -142,9 +143,15 @@ int trace_selftest_startup_dynamic_traci
 		return ret;
 	}
 
+	/*
+	 * Some archs *cough*PowerPC*cough* add charachters to the
+	 * start of the function names. We simply put a '*' to
+	 * accomodate them.
+	 */
+	func_name = "*" STR(DYN_FTRACE_TEST_NAME);
+
 	/* filter only on our function */
-	ftrace_set_filter(STR(DYN_FTRACE_TEST_NAME),
-			  sizeof(STR(DYN_FTRACE_TEST_NAME)), 1);
+	ftrace_set_filter(func_name, strlen(func_name), 1);
 
 	/* enable tracing */
 	tr->ctrl = 1;

-- 
