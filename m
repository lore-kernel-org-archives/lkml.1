Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbYDVALK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbYDVALK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbYDVAKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:10:55 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:51037 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbYDVAKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:10:53 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <480D2D0A.2030705@avtrex.com>
Date: Mon, 21 Apr 2008 17:10:50 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 2/6] Add HARDWARE_WATCHPOINTS definitions and support code.
References: <480D2151.2020701@avtrex.com>
In-Reply-To: <480D2151.2020701@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 00:10:51.0663 (UTC) FILETIME=[5326A1F0:01C8A40D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds arch/mips/kernel/watch.c which contains support code for
manipulating the watch registers.  It also adds the needed fields to the
thread_struct and thread_info.  The cpu_info structure is augmented to 
contain the characteristics of the watch registers.


Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/Makefile      |    1 +
 arch/mips/kernel/watch.c       |  177 ++++++++++++++++++++++++++++++++++++++++
 include/asm-mips/cpu-info.h    |    5 +
 include/asm-mips/processor.h   |   29 +++++++
 include/asm-mips/thread_info.h |    2 +
 include/asm-mips/watch.h       |   29 +++++++
 6 files changed, 243 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/kernel/watch.c
 create mode 100644 include/asm-mips/watch.h

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 938be3a..5b1e017 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_MIPS32_O32)	+= binfmt_elfo32.o scall64-o32.o
 
 obj-$(CONFIG_KGDB)		+= gdb-low.o gdb-stub.o
 obj-$(CONFIG_PROC_FS)		+= proc.o
+obj-$(CONFIG_HARDWARE_WATCHPOINTS) += watch.o
 
 obj-$(CONFIG_64BIT)		+= cpu-bugs64.o
 
diff --git a/arch/mips/kernel/watch.c b/arch/mips/kernel/watch.c
new file mode 100644
index 0000000..6217682
--- /dev/null
+++ b/arch/mips/kernel/watch.c
@@ -0,0 +1,177 @@
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
+#include <asm/watch.h>
+
+void mips_install_watch_registers()
+{
+	struct mips32_watch_reg_state *watches = &current->thread.watch.mips32;
+	switch (current_cpu_data.watch_reg_count) {
+	default:
+		BUG();
+	case 8:
+		write_c0_watchlo7(watches->watchlo[7]);
+		/* Write 1 to the I, R, and W bits to clear them. */
+		write_c0_watchhi7(watches->watchhi[7] | 7);
+	case 7:
+		write_c0_watchlo6(watches->watchlo[6]);
+		write_c0_watchhi6(watches->watchhi[6] | 7);
+	case 6:
+		write_c0_watchlo5(watches->watchlo[5]);
+		write_c0_watchhi5(watches->watchhi[5] | 7);
+	case 5:
+		write_c0_watchlo4(watches->watchlo[4]);
+		write_c0_watchhi4(watches->watchhi[4] | 7);
+	case 4:
+		write_c0_watchlo3(watches->watchlo[3]);
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
+ * access to the I, R, and W bits.
+ */
+void mips_read_watch_registers()
+{
+	struct mips32_watch_reg_state *watches = &current->thread.watch.mips32;
+	switch (current_cpu_data.watch_reg_count) {
+	default:
+		BUG();
+	case 8:
+		watches->watchhi[7] = read_c0_watchhi7();
+	case 7:
+		watches->watchhi[6] = read_c0_watchhi6();
+	case 6:
+		watches->watchhi[5] = read_c0_watchhi5();
+	case 5:
+		watches->watchhi[4] = read_c0_watchhi4();
+	case 4:
+		watches->watchhi[3] = read_c0_watchhi3();
+	case 3:
+		watches->watchhi[2] = read_c0_watchhi2();
+	case 2:
+		watches->watchhi[1] = read_c0_watchhi1();
+	case 1:
+		watches->watchhi[0] = read_c0_watchhi0();
+	}
+}
+
+void mips_clear_watch_registers()
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
+	t = read_c0_watchhi0();
+	write_c0_watchhi0(t | 0xff8);
+	t = read_c0_watchhi0();
+	c->watch_reg_count = 1;
+	c->watch_reg_mask = t & 0xff8;
+	if ((t & 0x80000000) == 0)
+		return;
+
+	t = read_c0_watchhi1();
+	write_c0_watchhi1(t | 0xff8);
+	t = read_c0_watchhi1();
+	c->watch_reg_count = 2;
+	/* Calculate the smallest common mask.  */
+	c->watch_reg_mask &= t;
+	if ((t & 0x80000000) == 0)
+		return;
+
+	t = read_c0_watchhi2();
+	write_c0_watchhi2(t | 0xff8);
+	t = read_c0_watchhi2();
+	c->watch_reg_count = 3;
+	c->watch_reg_mask &= t;
+	if ((t & 0x80000000) == 0)
+		return;
+
+	t = read_c0_watchhi3();
+	write_c0_watchhi3(t | 0xff8);
+	t = read_c0_watchhi3();
+	c->watch_reg_count = 4;
+	c->watch_reg_mask &= t;
+	if ((t & 0x80000000) == 0)
+		return;
+
+	t = read_c0_watchhi4();
+	write_c0_watchhi4(t | 0xff8);
+	t = read_c0_watchhi4();
+	c->watch_reg_count = 5;
+	c->watch_reg_mask &= t;
+	if ((t & 0x80000000) == 0)
+		return;
+
+	t = read_c0_watchhi5();
+	write_c0_watchhi5(t | 0xff8);
+	t = read_c0_watchhi5();
+	c->watch_reg_count = 6;
+	c->watch_reg_mask &= t;
+	if ((t & 0x80000000) == 0)
+		return;
+
+	t = read_c0_watchhi6();
+	write_c0_watchhi6(t | 0xff8);
+	t = read_c0_watchhi6();
+	c->watch_reg_count = 7;
+	c->watch_reg_mask &= t;
+	if ((t & 0x80000000) == 0)
+		return;
+
+	t = read_c0_watchhi7();
+	write_c0_watchhi7(t | 0xff8);
+	t = read_c0_watchhi7();
+	c->watch_reg_count = 8;
+	c->watch_reg_mask &= t;
+}
diff --git a/include/asm-mips/cpu-info.h b/include/asm-mips/cpu-info.h
index 0c5a358..7d3a093 100644
--- a/include/asm-mips/cpu-info.h
+++ b/include/asm-mips/cpu-info.h
@@ -49,6 +49,11 @@ struct cpuinfo_mips {
 	unsigned int		fpu_id;
 	unsigned int		cputype;
 	int			isa_level;
+#if defined(CONFIG_HARDWARE_WATCHPOINTS)
+	unsigned int		watch_reg_count;
+	unsigned int		watch_reg_mask;
+	unsigned int		watch_reg_irw;
+#endif
 	int			tlbsize;
 	struct cache_desc	icache;	/* Primary I-cache */
 	struct cache_desc	dcache;	/* Primary D or combined I/D cache */
diff --git a/include/asm-mips/processor.h b/include/asm-mips/processor.h
index 58cbac5..423e04d 100644
--- a/include/asm-mips/processor.h
+++ b/include/asm-mips/processor.h
@@ -105,6 +105,26 @@ struct mips_dsp_state {
 	{0,} \
 }
 
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+
+#define NUM_WATCH_REGS 8
+
+struct mips32_watch_reg_state {
+	__u32 watchlo[NUM_WATCH_REGS];
+	__u32 watchhi[NUM_WATCH_REGS];
+};
+
+union mips_watch_reg_state {
+	struct mips32_watch_reg_state mips32;
+};
+
+#define INIT_WATCH .watch = {{{0,},},}
+
+#define OPTIONAL_INIT_WATCH INIT_WATCH,
+#else
+#define OPTIONAL_INIT_WATCH
+#endif
+
 typedef struct {
 	unsigned long seg;
 } mm_segment_t;
@@ -137,6 +157,11 @@ struct thread_struct {
 	/* Saved state of the DSP ASE, if available. */
 	struct mips_dsp_state dsp;
 
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+	/* Saved watch register state, if available. */
+	union mips_watch_reg_state watch;
+#endif
+
 	/* Other stuff associated with the thread. */
 	unsigned long cp0_badvaddr;	/* Last user fault */
 	unsigned long cp0_baduaddr;	/* Last kernel fault accessing USEG */
@@ -193,6 +218,10 @@ struct thread_struct {
 		.dspcontrol	= 0,				\
 	},							\
 	/*							\
+	 * saved watch register stuff				\
+	 */							\
+	OPTIONAL_INIT_WATCH					\
+	/*							\
 	 * Other stuff associated with the process		\
 	 */							\
 	.cp0_badvaddr		= 0,				\
diff --git a/include/asm-mips/thread_info.h b/include/asm-mips/thread_info.h
index b2772df..e31de4b 100644
--- a/include/asm-mips/thread_info.h
+++ b/include/asm-mips/thread_info.h
@@ -122,6 +122,7 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define TIF_32BIT_REGS		22	/* also implies 16/32 fprs */
 #define TIF_32BIT_ADDR		23	/* 32-bit address space (o32/n32) */
 #define TIF_FPUBOUND		24	/* thread bound to FPU-full CPU set */
+#define TIF_LOAD_WATCH		25	/* If set, load watch registers */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -138,6 +139,7 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define _TIF_32BIT_REGS		(1<<TIF_32BIT_REGS)
 #define _TIF_32BIT_ADDR		(1<<TIF_32BIT_ADDR)
 #define _TIF_FPUBOUND		(1<<TIF_FPUBOUND)
+#define _TIF_LOAD_WATCH		(1<<TIF_LOAD_WATCH)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
diff --git a/include/asm-mips/watch.h b/include/asm-mips/watch.h
new file mode 100644
index 0000000..72607be
--- /dev/null
+++ b/include/asm-mips/watch.h
@@ -0,0 +1,29 @@
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
+#include <asm/mipsregs.h>
+
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+void mips_install_watch_registers(void);
+void mips_read_watch_registers(void);
+void mips_clear_watch_registers(void);
+void mips_probe_watch_registers(struct cpuinfo_mips *c);
+
+#define __restore_watch() do {						\
+	if (unlikely(current_thread_info()->flags & _TIF_LOAD_WATCH)) {	\
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
1.5.5

