Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYH1VzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYH1VzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbYH1VzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:55:07 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:53326 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbYH1VzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:55:04 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48B71EB5.2080702@avtrex.com>
Date: Thu, 28 Aug 2008 14:55:01 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 2/6] MIPS: Add HARDWARE_WATCHPOINTS definitions and support
 code.
References: <48B71ADD.601@avtrex.com>
In-Reply-To: <48B71ADD.601@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Aug 2008 21:55:02.0500 (UTC) FILETIME=[B928CA40:01C90958]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the support code for watch register support.  It is not hooked
up to anything yet, that comes next.

There are two new files (watch.c, watch.h) the rest is additions.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/Makefile      |    2 +-
 arch/mips/kernel/watch.c       |  163 ++++++++++++++++++++++++++++++++++++++++
 include/asm-mips/cpu-info.h    |    4 +
 include/asm-mips/processor.h   |   21 +++++
 include/asm-mips/thread_info.h |    2 +
 include/asm-mips/watch.h       |   32 ++++++++
 6 files changed, 223 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/kernel/watch.c
 create mode 100644 include/asm-mips/watch.h

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 706f939..2504f15 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y		:= head.o init_task.o vmlinux.lds
 
 obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 		   ptrace.o reset.o setup.o signal.o syscall.o \
-		   time.o topology.o traps.o unaligned.o
+		   time.o topology.o traps.o unaligned.o watch.o
 
 obj-$(CONFIG_CEVT_BCM1480)	+= cevt-bcm1480.o
 obj-$(CONFIG_CEVT_R4K)		+= cevt-r4k.o
diff --git a/arch/mips/kernel/watch.c b/arch/mips/kernel/watch.c
new file mode 100644
index 0000000..14ce610
--- /dev/null
+++ b/arch/mips/kernel/watch.c
@@ -0,0 +1,163 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 David Daney
+ */
+
+#include <linux/sched.h>
+
+#include <asm/processor.h>
+#include <asm/watch.h>
+
+/*
+ * Install the watch registers for the current thread.  A maximum of
+ * four registers are installed although the machine may have more.
+ */
+void mips_install_watch_registers(void)
+{
+	struct mips3264_watch_reg_state *watches =
+		&current->thread.watch.mips3264;
+	switch (current_cpu_data.watch_reg_use_cnt) {
+	default:
+		BUG();
+	case 4:
+		write_c0_watchlo3(watches->watchlo[3]);
+		/* Write 1 to the I, R, and W bits to clear them. */
+		write_c0_watchhi3(watches->watchhi[3] | 7);
+	case 3:
+		write_c0_watchlo2(watches->watchlo[2]);
+		write_c0_watchhi2(watches->watchhi[2] | 7);
+	case 2:
+		write_c0_watchlo1(watches->watchlo[1]);
+		write_c0_watchhi1(watches->watchhi[1] | 7);
+	case 1:
+		write_c0_watchlo0(watches->watchlo[0]);
+		write_c0_watchhi0(watches->watchhi[0] | 7);
+	}
+}
+
+/*
+ * Read back the watchhi registers so the user space debugger has
+ * access to the I, R, and W bits.  A maximum of four registers are
+ * read although the machine may have more.
+ */
+void mips_read_watch_registers(void)
+{
+	struct mips3264_watch_reg_state *watches =
+		&current->thread.watch.mips3264;
+	switch (current_cpu_data.watch_reg_use_cnt) {
+	default:
+		BUG();
+	case 4:
+		watches->watchhi[3] = read_c0_watchhi3();
+	case 3:
+		watches->watchhi[2] = read_c0_watchhi2();
+	case 2:
+		watches->watchhi[1] = read_c0_watchhi1();
+	case 1:
+		watches->watchhi[0] = read_c0_watchhi0();
+	}
+	if (current_cpu_data.watch_reg_use_cnt == 1 &&
+	    (watches->watchhi[0] & 7) == 0) {
+		/* Pathological case of release 1 archetecture that
+		 * doesn't set the condition bits.  We assume that
+		 * since we got here, the watch condition was met and
+		 * signal that the conditions requested in watchlo
+		 * were met.  */
+		watches->watchhi[0] |= (watches->watchlo[0] & 7);
+	}
+ }
+
+/*
+ * Disable all watch registers.  Although only four registers are
+ * installed, all are cleared to eliminate the possibility of endless
+ * looping in the watch handler.
+ */
+void mips_clear_watch_registers(void)
+{
+	switch (current_cpu_data.watch_reg_count) {
+	default:
+		BUG();
+	case 8:
+		write_c0_watchlo7(0);
+	case 7:
+		write_c0_watchlo6(0);
+	case 6:
+		write_c0_watchlo5(0);
+	case 5:
+		write_c0_watchlo4(0);
+	case 4:
+		write_c0_watchlo3(0);
+	case 3:
+		write_c0_watchlo2(0);
+	case 2:
+		write_c0_watchlo1(0);
+	case 1:
+		write_c0_watchlo0(0);
+	}
+}
+
+__init void mips_probe_watch_registers(struct cpuinfo_mips *c)
+{
+	unsigned int t;
+
+	if ((c->options & MIPS_CPU_WATCH) == 0)
+		return;
+	/*
+	 * Check which of the I,R and W bits are supported, then
+	 * disable the register.
+	 */
+	write_c0_watchlo0(7);
+	t = read_c0_watchlo0();
+	write_c0_watchlo0(0);
+	c->watch_reg_irw = t & 7;
+
+	/* Write the mask bits and read them back to determine which
+	 * can be used. */
+	c->watch_reg_count = 1;
+	c->watch_reg_use_cnt = 1;
+	t = read_c0_watchhi0();
+	write_c0_watchhi0(t | 0xff8);
+	t = read_c0_watchhi0();
+	c->watch_reg_mask = t & 0xff8;
+	if ((t & 0x80000000) == 0)
+		return;
+
+	c->watch_reg_count = 2;
+	c->watch_reg_use_cnt = 2;
+	t = read_c0_watchhi1();
+	if ((t & 0x80000000) == 0)
+		return;
+
+	c->watch_reg_count = 3;
+	c->watch_reg_use_cnt = 3;
+	t = read_c0_watchhi2();
+	if ((t & 0x80000000) == 0)
+		return;
+
+	c->watch_reg_count = 4;
+	c->watch_reg_use_cnt = 4;
+	t = read_c0_watchhi3();
+	if ((t & 0x80000000) == 0)
+		return;
+
+	/* We use at most 4, but probe and report up to 8. */
+	c->watch_reg_count = 5;
+	t = read_c0_watchhi4();
+	if ((t & 0x80000000) == 0)
+		return;
+
+	c->watch_reg_count = 6;
+	t = read_c0_watchhi5();
+	if ((t & 0x80000000) == 0)
+		return;
+
+	c->watch_reg_count = 7;
+	t = read_c0_watchhi6();
+	if ((t & 0x80000000) == 0)
+		return;
+
+	c->watch_reg_count = 8;
+}
diff --git a/include/asm-mips/cpu-info.h b/include/asm-mips/cpu-info.h
index 2de73db..246ac0b 100644
--- a/include/asm-mips/cpu-info.h
+++ b/include/asm-mips/cpu-info.h
@@ -49,6 +49,10 @@ struct cpuinfo_mips {
 	unsigned int		fpu_id;
 	unsigned int		cputype;
 	int			isa_level;
+	unsigned int		watch_reg_count;   /* Number that exist */
+	unsigned int		watch_reg_use_cnt; /* Usable by ptrace */
+	unsigned int		watch_reg_mask;
+	unsigned int		watch_reg_irw;
 	int			tlbsize;
 	struct cache_desc	icache;	/* Primary I-cache */
 	struct cache_desc	dcache;	/* Primary D or combined I/D cache */
diff --git a/include/asm-mips/processor.h b/include/asm-mips/processor.h
index a1e4453..f82d1e2 100644
--- a/include/asm-mips/processor.h
+++ b/include/asm-mips/processor.h
@@ -105,6 +105,20 @@ struct mips_dsp_state {
 	{0,} \
 }
 
+#define NUM_WATCH_REGS 4
+
+struct mips3264_watch_reg_state {
+	/* The width of watchlo is 32 in a 32 bit kernel and 64 in a
+	   64 bit kernel.  We use unsiged long as it has the same
+	   property. */
+	unsigned long watchlo[NUM_WATCH_REGS];
+	/* The width of watchhi is always 32 bits. */
+	__u32 watchhi[NUM_WATCH_REGS]; };
+
+union mips_watch_reg_state {
+	struct mips3264_watch_reg_state mips3264;
+};
+
 typedef struct {
 	unsigned long seg;
 } mm_segment_t;
@@ -137,6 +151,9 @@ struct thread_struct {
 	/* Saved state of the DSP ASE, if available. */
 	struct mips_dsp_state dsp;
 
+	/* Saved watch register state, if available. */
+	union mips_watch_reg_state watch;
+
 	/* Other stuff associated with the thread. */
 	unsigned long cp0_badvaddr;	/* Last user fault */
 	unsigned long cp0_baduaddr;	/* Last kernel fault accessing USEG */
@@ -193,6 +210,10 @@ struct thread_struct {
 		.dspcontrol	= 0,				\
 	},							\
 	/*							\
+	 * saved watch register stuff				\
+	 */							\
+	.watch = {{{0,},},},					\
+	/*							\
 	 * Other stuff associated with the process		\
 	 */							\
 	.cp0_badvaddr		= 0,				\
diff --git a/include/asm-mips/thread_info.h b/include/asm-mips/thread_info.h
index bb30606..3f76de7 100644
--- a/include/asm-mips/thread_info.h
+++ b/include/asm-mips/thread_info.h
@@ -124,6 +124,7 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define TIF_32BIT_REGS		22	/* also implies 16/32 fprs */
 #define TIF_32BIT_ADDR		23	/* 32-bit address space (o32/n32) */
 #define TIF_FPUBOUND		24	/* thread bound to FPU-full CPU set */
+#define TIF_LOAD_WATCH		25	/* If set, load watch registers */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -140,6 +141,7 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define _TIF_32BIT_REGS		(1<<TIF_32BIT_REGS)
 #define _TIF_32BIT_ADDR		(1<<TIF_32BIT_ADDR)
 #define _TIF_FPUBOUND		(1<<TIF_FPUBOUND)
+#define _TIF_LOAD_WATCH		(1<<TIF_LOAD_WATCH)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
diff --git a/include/asm-mips/watch.h b/include/asm-mips/watch.h
new file mode 100644
index 0000000..20126ec
--- /dev/null
+++ b/include/asm-mips/watch.h
@@ -0,0 +1,32 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 David Daney
+ */
+#ifndef _ASM_WATCH_H
+#define _ASM_WATCH_H
+
+#include <linux/bitops.h>
+
+#include <asm/mipsregs.h>
+
+void mips_install_watch_registers(void);
+void mips_read_watch_registers(void);
+void mips_clear_watch_registers(void);
+void mips_probe_watch_registers(struct cpuinfo_mips *c);
+
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+#define __restore_watch() do {						\
+	if (unlikely(test_bit(TIF_LOAD_WATCH,				\
+			      &current_thread_info()->flags))) {	\
+		mips_install_watch_registers();				\
+	}								\
+} while (0)
+
+#else
+#define __restore_watch() do {} while (0)
+#endif
+
+#endif /* _ASM_WATCH_H */
-- 
1.5.5.1

