Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbYEGIeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbYEGIeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761715AbYEGId6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:33:58 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:21125 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYEGIdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=npe1dxalUKT7aRWr07SglbYHMUo3FYO2yOW3/FCqgGrHfNeTI63Pi4MRK2hhQUFBggEFp2XkZ2iLTMIsYCqcku0y7tAAIFoiMdC9ERa8CSdInGQLVUKA4e7+T52MfKbZ1FEiN+/47otgnxFQym+BS7rCtvBIGgxbj+e5ijmjuas=
Message-ID: <7c86c4470805070133q29515056s386c137f644b7f3b@mail.gmail.com>
Date: Wed, 7 May 2008 10:33:47 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] perfmon: add context switch hooks for x86
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <andi@firstfloor.org>, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


Here is a first perfmon patch. It provides the following:

   - minimal perfmon source tree layout with a topdir perfmon for
generic code and
     the x86 arch specific subdir in arch/x86.

   - the x86 perfmon context switch hooks in switch_to() and related
TIF flag for both
     32 and 64 bits.

   - a new X86 compile option (CONFIG_PERFMON) to enable/disable perfmon

   - placeholders for the actual generic context switch in/out
routines in perfmon_ctxsw.c

The patch does not do anything useful for end-users. Its goal is to
establish the code layout
and put in place the x86 context switch hooks and reserve the
corresponding TIF bits.

Please review.

Changelog:
   - minimal perfmon source tree layout with a topdir perfmon for
generic code and
     the x86 arch specific subdir in arch/x86/perfmon.

   - the x86 perfmon context switch hooks in switch_to() and related
TIF flag for both
     32 and 64 bits.

   - a new X86 compile option (CONFIG_PERFMON) to enable/disable perfmon

   - placeholders for the actual generic context switch in/out routine
in perfmon_ctxsw.c


Signed-off-by: Stephane Eranian <eranian@gmail.com>

---
 Makefile                         |    2 -
 arch/x86/Kconfig                 |    2 +
 arch/x86/kernel/process_32.c     |    7 +++
 arch/x86/kernel/process_64.c     |    7 +++
 arch/x86/perfmon/Kconfig         |   10 +++++
 include/asm-x86/thread_info_32.h |    8 ++--
 include/asm-x86/thread_info_64.h |    5 ++
 include/linux/perfmon_kern.h     |   54 ++++++++++++++++++++++++++++++
 perfmon/Makefile                 |    5 ++
 perfmon/perfmon_ctxsw.c          |   69 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 164 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 4492984..2385826 100644
--- a/Makefile
+++ b/Makefile
@@ -607,7 +607,7 @@ export mod_strip_cmd


 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ perfmon/

 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bbcafaa..b43ae0c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1312,6 +1312,8 @@ config COMPAT_VDSO

 	  If unsure, say Y.

+source "arch/x86/perfmon/Kconfig"
+
 endmenu

 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f8476df..10856c4 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -37,6 +37,7 @@
 #include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
+#include <linux/perfmon_kern.h>

 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -486,6 +487,9 @@ __switch_to_xtra(struct task_struct *prev_p,
struct task_struct *next_p,
 	prev = &prev_p->thread;
 	next = &next_p->thread;

+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 	if (next->ds_area_msr != prev->ds_area_msr) {
 		/* we clear debugctl to make sure DS
@@ -498,6 +502,9 @@ __switch_to_xtra(struct task_struct *prev_p,
struct task_struct *next_p,
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);

+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev_p, next_p);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		set_debugreg(next->debugreg0, 0);
 		set_debugreg(next->debugreg1, 1);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e2319f3..ee7eaff 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -37,6 +37,7 @@
 #include <linux/kdebug.h>
 #include <linux/tick.h>
 #include <linux/prctl.h>
+#include <linux/perfmon_kern.h>

 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -496,6 +497,9 @@ static inline void __switch_to_xtra(struct
task_struct *prev_p,
 	prev = &prev_p->thread,
 	next = &next_p->thread;

+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 	if (next->ds_area_msr != prev->ds_area_msr) {
 		/* we clear debugctl to make sure DS
@@ -508,6 +512,9 @@ static inline void __switch_to_xtra(struct
task_struct *prev_p,
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);

+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev_p, next_p);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		loaddebug(next, 0);
 		loaddebug(next, 1);
diff --git a/arch/x86/perfmon/Kconfig b/arch/x86/perfmon/Kconfig
new file mode 100644
index 0000000..4c4813c
--- /dev/null
+++ b/arch/x86/perfmon/Kconfig
@@ -0,0 +1,10 @@
+menu "Hardware Performance Monitoring support"
+config PERFMON
+	bool "Perfmon2 performance monitoring interface"
+	select X86_LOCAL_APIC
+	default n
+	help
+	Enables the perfmon2 interface to access the hardware
+	performance counters. See <http://perfmon2.sf.net/> for
+	more details.
+endmenu
diff --git a/include/asm-x86/thread_info_32.h b/include/asm-x86/thread_info_32.h
index b633882..626e326 100644
--- a/include/asm-x86/thread_info_32.h
+++ b/include/asm-x86/thread_info_32.h
@@ -141,6 +141,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_DEBUGCTLMSR		22	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR 	23      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS        24      /* record scheduling event
timestamps */
+#define TIF_PERFMON_CTXSW	25	/* perfmon needs ctxsw calls */

 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -159,6 +160,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
+#define _TIF_PERFMON_CTXSW	(1 << TIF_PERFMON_CTXSW)

 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -168,9 +170,9 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)

 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW						\
-	(_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR |	\
-	 _TIF_DS_AREA_MSR | _TIF_BTS_TRACE_TS)
+#define _TIF_WORK_CTXSW \
+    (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR | \
+     _TIF_DS_AREA_MSR | _TIF_BTS_TRACE_TS | _TIF_PERFMON_CTXSW)
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW | _TIF_DEBUG)

diff --git a/include/asm-x86/thread_info_64.h b/include/asm-x86/thread_info_64.h
index cb69f70..f0f50f6 100644
--- a/include/asm-x86/thread_info_64.h
+++ b/include/asm-x86/thread_info_64.h
@@ -124,6 +124,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
 #define TIF_NOTSC		28	/* TSC is not accessible in userland */
+#define TIF_PERFMON_CTXSW	29	/* perfmon needs ctxsw calls */

 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -145,6 +146,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)

 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -158,7 +160,8 @@ static inline struct thread_info *stack_thread_info(void)

 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS|_TIF_NOTSC)
+	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS|\
+	 _TIF_NOTSC|_TIF_PERFMON_CTXSW)
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)

diff --git a/include/linux/perfmon_kern.h b/include/linux/perfmon_kern.h
new file mode 100644
index 0000000..c7a8ace
--- /dev/null
+++ b/include/linux/perfmon_kern.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (c) 2001-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+
+#ifndef __LINUX_PERFMON_KERN_H__
+#define __LINUX_PERFMON_KERN_H__
+/*
+ * This file contains all the definitions of data structures, variables, macros
+ * that are to be shared between generic code and arch-specific code
+ *
+ * For generic only definitions, use perfmon/perfmon_priv.h
+ */
+#ifdef __KERNEL__
+
+#include <linux/sched.h>
+
+#ifdef CONFIG_PERFMON
+
+
+void pfm_ctxsw_in(struct task_struct *prev, struct task_struct *next);
+void pfm_ctxsw_out(struct task_struct *prev, struct task_struct *next);
+
+#else /* !CONFIG_PERFMON */
+
+/*
+ * perfmon hooks are nops when CONFIG_PERFMON is undefined
+ */
+static inline void pfm_ctxsw_in(struct task_struct *prev,
+				struct task_struct *next)
+{}
+
+static inline void pfm_ctxsw_out(struct task_struct *prev,
+				 struct task_struct *next)
+{}
+
+#endif /* CONFIG_PERFMON */
+
+#endif /* __KERNEL__*/
+#endif /* __LINUX_PERFMON_KERN_H__ */
diff --git a/perfmon/Makefile b/perfmon/Makefile
new file mode 100644
index 0000000..48563bd
--- /dev/null
+++ b/perfmon/Makefile
@@ -0,0 +1,5 @@
+#
+# Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
+# Contributed by Stephane Eranian <eranian@gmail.com>
+#
+obj-$(CONFIG_PERFMON) = perfmon_ctxsw.o
diff --git a/perfmon/perfmon_ctxsw.c b/perfmon/perfmon_ctxsw.c
new file mode 100644
index 0000000..8399da7
--- /dev/null
+++ b/perfmon/perfmon_ctxsw.c
@@ -0,0 +1,69 @@
+/*
+ * perfmon_cxtsw.c: perfmon2 context switch code
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@gmail.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://perfmon2.sf.net
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/kernel.h>
+#include <linux/perfmon_kern.h>
+
+/**
+ * pfm_ctxsw_out - save PMU state on context switch out
+ * @prev: thread being switched out
+ * @next: thread being switched in
+ *
+ * We pass the next thread as on some platforms it may be necessary to
+ * pass some settings from the current thread to the next
+ *
+ * Interrupts are masked
+ */
+void pfm_ctxsw_out(struct task_struct *prev,
+		   struct task_struct *next)
+{
+}
+
+/**
+ * pfm_ctxsw_in - restore PMU state on context switch in
+ * @prev: thread being switched out
+ * @next: thread being switched in
+ *
+ * We pass the prev thread as on some platforms it may be necessary to
+ * pass some settings from the current thread to the next
+ *
+ * Interrupts are masked
+ */
+void pfm_ctxsw_in(struct task_struct *prev,
+		  struct task_struct *next)
+{
+}
