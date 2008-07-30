Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbYG3Boy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbYG3Boy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYG3Bnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:43:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYG3Bnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:43:52 -0400
Message-Id: <20080730014350.649489150@goodmis.org>
References: <20080730012939.885172468@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 21:29:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ftrace: do not trace nmi callers in x86
Content-Disposition: inline; filename=ftrace-no-trace-nmi-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic ftrace code performs run time modification of the code text
section. This is not safe to do unless all other CPUS are halted. Because
there is no good way to halt NMIs while doing the modification, we must
make sure that the NMIs will not execute code that will be modified.

This patch adds notrace annotation to functions called by NMIs in x86.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/Makefile               |    6 ++++++
 arch/x86/kernel/cpu/perfctr-watchdog.c |   13 +++++++------
 arch/x86/kernel/traps_32.c             |    3 ++-
 arch/x86/kernel/traps_64.c             |    3 ++-
 arch/x86/mm/kmemcheck/smp.c            |    2 +-
 arch/x86/mm/kmmio.c                    |    9 +++++----
 arch/x86/oprofile/Makefile             |    5 +++++
 include/asm-x86/apic.h                 |    8 ++++----
 8 files changed, 32 insertions(+), 17 deletions(-)

Index: linux-tip.git/arch/x86/kernel/Makefile
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/Makefile	2008-07-29 19:56:58.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/Makefile	2008-07-29 19:57:52.000000000 -0400
@@ -11,6 +11,12 @@ ifdef CONFIG_FTRACE
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_kgdb.o = -pg
+CFLAGS_REMOVE_kprobes.o = -pg
+ifdef CONFIG_DYNAMIC_FTRACE
+CFLAGS_REMOVE_nmi.o = -pg
+CFLAGS_REMOVE_crash.o = -pg
+endif
 endif
 
 #
Index: linux-tip.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/traps_32.c	2008-07-29 19:56:58.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/traps_32.c	2008-07-29 19:57:53.000000000 -0400
@@ -389,7 +389,8 @@ unsigned __kprobes long oops_begin(void)
 	return flags;
 }
 
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+void notrace __kprobes
+oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
 	bust_spinlocks(0);
 	die_owner = -1;
Index: linux-tip.git/arch/x86/kernel/traps_64.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/traps_64.c	2008-07-29 19:56:58.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/traps_64.c	2008-07-29 19:57:53.000000000 -0400
@@ -506,7 +506,8 @@ unsigned __kprobes long oops_begin(void)
 	return flags;
 }
 
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+void __kprobes notrace
+oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
 	die_owner = -1;
 	bust_spinlocks(0);
Index: linux-tip.git/arch/x86/mm/kmemcheck/smp.c
===================================================================
--- linux-tip.git.orig/arch/x86/mm/kmemcheck/smp.c	2008-07-29 19:56:58.000000000 -0400
+++ linux-tip.git/arch/x86/mm/kmemcheck/smp.c	2008-07-29 19:57:53.000000000 -0400
@@ -13,7 +13,7 @@ static atomic_t nmi_wait;
 static atomic_t nmi_resume;
 static atomic_t paused;
 
-static int nmi_notifier(struct notifier_block *self,
+static int notrace nmi_notifier(struct notifier_block *self,
 	unsigned long val, void *data)
 {
 	if (val != DIE_NMI_IPI || !atomic_read(&nmi_wait))
Index: linux-tip.git/arch/x86/mm/kmmio.c
===================================================================
--- linux-tip.git.orig/arch/x86/mm/kmmio.c	2008-07-29 19:56:58.000000000 -0400
+++ linux-tip.git/arch/x86/mm/kmmio.c	2008-07-29 19:57:53.000000000 -0400
@@ -147,7 +147,7 @@ static void set_page_present(unsigned lo
 }
 
 /** Mark the given page as not present. Access to it will trigger a fault. */
-static void arm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
+static notrace void arm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
 {
 	set_page_present(page & PAGE_MASK, false, pglevel);
 }
@@ -269,7 +269,8 @@ no_kmmio:
  * and they remain disabled thorough out this function.
  * This must always get called as the pair to kmmio_handler().
  */
-static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
+static notrace int
+post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 {
 	int ret = 0;
 	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
@@ -484,8 +485,8 @@ void unregister_kmmio_probe(struct kmmio
 }
 EXPORT_SYMBOL(unregister_kmmio_probe);
 
-static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
-								void *args)
+static int notrace
+kmmio_die_notifier(struct notifier_block *nb, unsigned long val, void *args)
 {
 	struct die_args *arg = args;
 
Index: linux-tip.git/arch/x86/oprofile/Makefile
===================================================================
--- linux-tip.git.orig/arch/x86/oprofile/Makefile	2008-07-29 19:56:58.000000000 -0400
+++ linux-tip.git/arch/x86/oprofile/Makefile	2008-07-29 19:57:53.000000000 -0400
@@ -6,6 +6,11 @@ DRIVER_OBJS = $(addprefix ../../../drive
 		oprofilefs.o oprofile_stats.o  \
 		timer_int.o )
 
+ifdef CONFIG_DYNAMIC_FTRACE
+CFLAGS_REMOVE_nmi_int.o = -pg
+CFLAGS_REMOVE_nmi_timer_int.o = -pg
+endif
+
 oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o
 oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_amd.o \
 					   op_model_ppro.o op_model_p4.o
Index: linux-tip.git/arch/x86/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-07-29 20:02:19.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-07-29 20:02:36.000000000 -0400
@@ -243,7 +243,7 @@ static unsigned int adjust_for_32bit_ctr
 	return retval;
 }
 
-static void write_watchdog_counter(unsigned int perfctr_msr,
+static notrace void write_watchdog_counter(unsigned int perfctr_msr,
 				const char *descr, unsigned nmi_hz)
 {
 	u64 count = (u64)cpu_khz * 1000;
@@ -254,7 +254,7 @@ static void write_watchdog_counter(unsig
 	wrmsrl(perfctr_msr, 0 - count);
 }
 
-static void write_watchdog_counter32(unsigned int perfctr_msr,
+static notrace void write_watchdog_counter32(unsigned int perfctr_msr,
 				const char *descr, unsigned nmi_hz)
 {
 	u64 count = (u64)cpu_khz * 1000;
@@ -330,7 +330,8 @@ static void single_msr_unreserve(void)
 	release_perfctr_nmi(wd_ops->perfctr);
 }
 
-static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+static notrace void
+single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 {
 	/* start the cycle over again */
 	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
@@ -389,7 +390,7 @@ static int setup_p6_watchdog(unsigned nm
 	return 1;
 }
 
-static void p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+static notrace void p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 {
 	/*
 	 * P6 based Pentium M need to re-unmask
@@ -541,7 +542,7 @@ static void p4_unreserve(void)
 	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
 }
 
-static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+static notrace void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 {
 	unsigned dummy;
 	/*
@@ -716,7 +717,7 @@ unsigned lapic_adjust_nmi_hz(unsigned hz
 	return hz;
 }
 
-int lapic_wd_event(unsigned nmi_hz)
+notrace int lapic_wd_event(unsigned nmi_hz)
 {
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 	u64 ctr;
Index: linux-tip.git/include/asm-x86/apic.h
===================================================================
--- linux-tip.git.orig/include/asm-x86/apic.h	2008-07-29 20:02:19.000000000 -0400
+++ linux-tip.git/include/asm-x86/apic.h	2008-07-29 20:02:37.000000000 -0400
@@ -60,7 +60,7 @@ extern u64 xapic_icr_read(void);
 extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
 
-static inline void native_apic_mem_write(u32 reg, u32 v)
+static inline notrace void native_apic_mem_write(u32 reg, u32 v)
 {
 	volatile u32 *addr = (volatile u32 *)(APIC_BASE + reg);
 
@@ -69,12 +69,12 @@ static inline void native_apic_mem_write
 		       ASM_OUTPUT2("0" (v), "m" (*addr)));
 }
 
-static inline u32 native_apic_mem_read(u32 reg)
+static inline notrace u32 native_apic_mem_read(u32 reg)
 {
 	return *((volatile u32 *)(APIC_BASE + reg));
 }
 
-static inline void native_apic_msr_write(u32 reg, u32 v)
+static inline notrace void native_apic_msr_write(u32 reg, u32 v)
 {
 	if (reg == APIC_DFR || reg == APIC_ID || reg == APIC_LDR ||
 	    reg == APIC_LVR)
@@ -83,7 +83,7 @@ static inline void native_apic_msr_write
 	wrmsr(APIC_BASE_MSR + (reg >> 4), v, 0);
 }
 
-static inline u32 native_apic_msr_read(u32 reg)
+static inline notrace u32 native_apic_msr_read(u32 reg)
 {
 	u32 low, high;
 

-- 
