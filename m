Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbYEMQxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbYEMQxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbYEMQww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:52:52 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47248 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756334AbYEMQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:52:51 -0400
From: Sebastian Siewior <bigeasy@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
Cc: Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, Sebastian Siewior <bigeasy@linutronix.de>
Subject: [PATCH] m68knommu: add FTRACE support
Date: Tue, 13 May 2008 18:52:43 +0200
Message-Id: <1210697565-3106-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1210697565-3106-1-git-send-email-bigeasy@linutronix.de>
References: <1210697565-3106-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

due to a gcc bug or feature, the following patch has to be applied to gcc:

|m68k: remove label generation on -pg
|
|haven't found a reason why this flag is needed. Maybe glibc needs this label.
|However this implementation puts the labels too far away.
|
|Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
|
|--- a/gcc/config/m68k/linux.h
|+++ b/gcc/config/m68k/linux.h
|@@ -143,7 +143,6 @@ along with GCC; see the file COPYING3.
| #undef FUNCTION_PROFILER
| #define FUNCTION_PROFILER(FILE, LABELNO) \
| {                                                                     \
|-  asm_fprintf (FILE, "\tlea (%LLP%d,%Rpc),%Ra1\n", (LABELNO));                \
|   if (flag_pic)                                                               \
|     fprintf (FILE, "\tbsr.l _mcount@PLTPC\n");                                \
|   else                                                                        \
|--- a/gcc/config/m68k/m68k.h
|+++ b/gcc/config/m68k/m68k.h
|@@ -576,7 +576,7 @@ extern enum reg_class regno_reg_class[];
| #define FUNCTION_ARG(CUM, MODE, TYPE, NAMED) 0
|
| #define FUNCTION_PROFILER(FILE, LABELNO)  \
|-  asm_fprintf (FILE, "\tlea %LLP%d,%Ra0\n\tjsr mcount\n", (LABELNO))
|+  asm_fprintf (FILE, "\tjsr mcount\n", (LABELNO))
|
| #define EXIT_IGNORE_STACK 1
|

GCC bug report: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=36047

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
 arch/m68knommu/Kconfig                   |    1 +
 arch/m68knommu/kernel/process.c          |    2 +
 arch/m68knommu/platform/coldfire/entry.S |   33 ++++++++++++++++++++++++++++++
 kernel/trace/Kconfig                     |    2 +-
 4 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 07eb4c4..90ce97b 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -166,6 +166,7 @@ config M527x
 config COLDFIRE
 	bool
 	depends on (M5206 || M5206e || M520x || M523x || M5249 || M527x || M5272 || M528x || M5307 || M532x || M5407)
+	select HAVE_FTRACE
 	default y
 
 config CLOCK_SET
diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 47502d5..57678a5 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -74,7 +74,9 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		stop_critical_timings();
 		idle();
+		start_critical_timings();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/m68knommu/platform/coldfire/entry.S b/arch/m68knommu/platform/coldfire/entry.S
index 111b66d..0301a80 100644
--- a/arch/m68knommu/platform/coldfire/entry.S
+++ b/arch/m68knommu/platform/coldfire/entry.S
@@ -55,6 +55,39 @@ sw_usp:
 .globl inthandler
 .globl fasthandler
 
+#ifdef CONFIG_FTRACE
+ENTRY(_mcount)
+	linkw	%fp, #0
+
+	moveal	ftrace_trace_function, %a0
+	movel	#ftrace_stub, %d0
+	cmpl	%a0@, %d0
+
+	bnew	do_mcount
+
+	unlk	%fp
+	rts
+
+do_mcount:
+
+	movel	%fp, %d0
+	moveal	%d0, %a1
+
+	moveal	%a1@, %a0
+	movel	%a0@(4), %sp@-	/* push parent ip */
+	movel	%a1@(4), %sp@-	/* push ip */
+
+	moveal	ftrace_trace_function, %a0
+	jsr	%a0@
+
+	unlk %fp
+
+.globl ftrace_stub
+ftrace_stub:
+	rts
+END(mcount)
+#endif
+
 enosys:
 	mov.l	#sys_ni_syscall,%d3
 	bra	1f
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index c93446e..deaa9a5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -101,7 +101,7 @@ config CONTEXT_SWITCH_TRACER
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
-	depends on FTRACE
+	depends on FTRACE && !COLDFIRE
 	default y
 	help
          This option will modify all the calls to ftrace dynamically
-- 
1.5.4.3

