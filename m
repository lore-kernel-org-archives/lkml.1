Return-Path: <linux-kernel-owner+w=401wt.eu-S1762478AbXGEVwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762478AbXGEVwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760373AbXGEVv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:51:56 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:37649 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759907AbXGEVvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:51:55 -0400
Date: Thu, 5 Jul 2007 17:51:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] Thread Migration Preemption
Message-ID: <20070705215152.GA4865@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:47:02 up 4 days, 16:30,  4 users,  load average: 0.43, 0.45, 0.51
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thread Migration Preemption

This patch adds the ability to protect critical sections from migration to
another CPU without disabling preemption.

This will be useful to minimize the amount of preemption disabling for the -rt
patch. It will help leveraging improvements brought by the local_t types in
asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
variables protected by migration_disable must be either atomic or protected from
concurrent updates done by other threads.

Typical use:

migration_disable();
local_inc(&__get_cpu_var(&my_local_t_var));
migration_enable();

Which will increment the variable atomically wrt the local CPU.

Comments (such as how to integrate this in the already almost full
preempt_count) are welcome.

It applies on 2.6.22-rc6-mm1.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-alpha/thread_info.h     |    1 +
 include/asm-arm/thread_info.h       |    2 ++
 include/asm-arm26/thread_info.h     |    2 ++
 include/asm-avr32/thread_info.h     |    2 ++
 include/asm-blackfin/thread_info.h  |    2 ++
 include/asm-cris/thread_info.h      |    2 ++
 include/asm-frv/thread_info.h       |    2 ++
 include/asm-h8300/thread_info.h     |    2 ++
 include/asm-i386/thread_info.h      |    4 ++--
 include/asm-ia64/thread_info.h      |    2 ++
 include/asm-m32r/thread_info.h      |    2 ++
 include/asm-m68k/thread_info.h      |    1 +
 include/asm-m68knommu/thread_info.h |    1 +
 include/asm-mips/thread_info.h      |    2 ++
 include/asm-parisc/thread_info.h    |    2 ++
 include/asm-powerpc/thread_info.h   |    2 ++
 include/asm-s390/thread_info.h      |    2 ++
 include/asm-sh/thread_info.h        |    2 ++
 include/asm-sh64/thread_info.h      |    2 ++
 include/asm-sparc/thread_info.h     |    2 ++
 include/asm-sparc64/thread_info.h   |    2 ++
 include/asm-um/thread_info.h        |    2 ++
 include/asm-v850/thread_info.h      |    2 ++
 include/asm-x86_64/thread_info.h    |    2 ++
 include/asm-xtensa/thread_info.h    |    2 ++
 include/linux/preempt.h             |   26 +++++++++++++++++++++++++-
 kernel/sched.c                      |   26 ++++++++++++++++++++++++++
 27 files changed, 98 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-i386/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/thread_info.h	2007-07-05 16:23:14.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/thread_info.h	2007-07-05 17:50:51.000000000 -0400
@@ -31,8 +31,7 @@
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
-
-
+	int			migration_count;/* 0: can migrate, <0: BUG */
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread
@@ -74,6 +73,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/linux/preempt.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/preempt.h	2007-07-05 16:19:00.000000000 -0400
+++ linux-2.6-lttng/include/linux/preempt.h	2007-07-05 16:33:29.000000000 -0400
@@ -12,15 +12,24 @@
 #ifdef CONFIG_DEBUG_PREEMPT
   extern void fastcall add_preempt_count(int val);
   extern void fastcall sub_preempt_count(int val);
+  extern void fastcall add_migration_count(int val);
+  extern void fastcall sub_migration_count(int val);
 #else
 # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
 # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
+# define add_migration_count(val) do { migration_count() += (val); } while (0)
+# define sub_migration_count(val) do { migration_count() -= (val); } while (0)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
 #define dec_preempt_count() sub_preempt_count(1)
 
-#define preempt_count()	(current_thread_info()->preempt_count)
+#define preempt_count() (current_thread_info()->preempt_count)
+
+#define inc_migration_count() add_migration_count(1)
+#define dec_migration_count() sub_migration_count(1)
+
+#define migration_count() (current_thread_info()->migration_count)
 
 #ifdef CONFIG_PREEMPT
 
@@ -51,6 +60,18 @@
 	preempt_check_resched(); \
 } while (0)
 
+#define migration_disable() \
+do { \
+	inc_migration_count(); \
+	barrier(); \
+} while (0)
+
+#define migration_enable() \
+do { \
+	barrier(); \
+	dec_migration_count(); \
+} while (0)
+
 #else
 
 #define preempt_disable()		do { } while (0)
@@ -58,6 +79,9 @@
 #define preempt_enable()		do { } while (0)
 #define preempt_check_resched()		do { } while (0)
 
+#define migration_disable()		do { } while (0)
+#define migration_enable()		do { } while (0)
+
 #endif
 
 #endif /* __LINUX_PREEMPT_H */
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2007-07-05 16:28:15.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2007-07-05 16:53:24.000000000 -0400
@@ -1996,6 +1996,7 @@
 	 * 1) running (obviously), or
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
+	 * 4) migration preemption is non 0 for this non running task.
 	 */
 	if (!cpu_isset(this_cpu, p->cpus_allowed))
 		return 0;
@@ -2003,6 +2004,8 @@
 
 	if (task_running(rq, p))
 		return 0;
+	if (task_thread_info(p)->migration_count)
+		return 0;
 
 	/*
 	 * Aggressive migration if too many balance attempts have failed:
@@ -3220,6 +3223,29 @@
 }
 EXPORT_SYMBOL(sub_preempt_count);
 
+void fastcall add_migration_count(int val)
+{
+	/*
+	 * Underflow?
+	 */
+	if (DEBUG_LOCKS_WARN_ON((migration_count() < 0)))
+		return;
+	migration_count() += val;
+}
+EXPORT_SYMBOL(add_migration_count);
+
+void fastcall sub_migration_count(int val)
+{
+	/*
+	 * Underflow?
+	 */
+	if (DEBUG_LOCKS_WARN_ON(val > migration_count()))
+		return;
+
+	migration_count() -= val;
+}
+EXPORT_SYMBOL(sub_migration_count);
+
 #endif
 
 /*
Index: linux-2.6-lttng/include/asm-alpha/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-alpha/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-alpha/thread_info.h	2007-07-05 16:55:39.000000000 -0400
@@ -21,6 +21,7 @@
 	mm_segment_t		addr_limit;	/* thread address space */
 	unsigned		cpu;		/* current CPU */
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 
 	int bpt_nsaved;
 	unsigned long bpt_addr[2];		/* breakpoint handling  */
Index: linux-2.6-lttng/include/asm-arm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-arm/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-arm/thread_info.h	2007-07-05 17:00:39.000000000 -0400
@@ -51,6 +51,7 @@
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	mm_segment_t		addr_limit;	/* address limit */
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
@@ -72,6 +73,7 @@
 	.exec_domain	= &default_exec_domain,				\
 	.flags		= 0,						\
 	.preempt_count	= 1,						\
+	.migration_count = 0,						\
 	.addr_limit	= KERNEL_DS,					\
 	.cpu_domain	= domain_val(DOMAIN_USER, DOMAIN_MANAGER) |	\
 			  domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) |	\
Index: linux-2.6-lttng/include/asm-arm26/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-arm26/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-arm26/thread_info.h	2007-07-05 16:59:55.000000000 -0400
@@ -45,6 +45,7 @@
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	mm_segment_t		addr_limit;	/* address limit */
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain      *exec_domain;   /* execution domain */
@@ -60,6 +61,7 @@
 	.exec_domain	&default_exec_domain,	\
 	.flags		0,			\
 	.preempt_count	0,			\
+	.migration_count 0,			\
 	.addr_limit	KERNEL_DS,		\
 	.restart_block  = {                             \
 		.fn     = do_no_restart_syscall,        \
Index: linux-2.6-lttng/include/asm-avr32/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-avr32/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-avr32/thread_info.h	2007-07-05 17:00:52.000000000 -0400
@@ -25,6 +25,7 @@
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;
 	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	struct restart_block	restart_block;
 	__u8			supervisor_stack[0];
 };
@@ -36,6 +37,7 @@
 	.flags		= 0,						\
 	.cpu		= 0,						\
 	.preempt_count	= 1,						\
+	.migration_count = 0,						\
 	.restart_block	= {						\
 		.fn	= do_no_restart_syscall				\
 	}								\
Index: linux-2.6-lttng/include/asm-blackfin/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-blackfin/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-blackfin/thread_info.h	2007-07-05 17:00:58.000000000 -0400
@@ -54,6 +54,7 @@
 	unsigned long flags;	/* low level flags */
 	int cpu;		/* cpu we're on */
 	int preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int migration_count;	/* 0: can migrate, <0 => BUG */
 	mm_segment_t addr_limit;	/* address limit */
 	struct restart_block restart_block;
 	struct l1_scratch_task_info l1_task_info;
@@ -69,6 +70,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count  = 1,                    \
+	.migration_count = 0,			\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6-lttng/include/asm-cris/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-cris/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-cris/thread_info.h	2007-07-05 17:01:16.000000000 -0400
@@ -32,6 +32,7 @@
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
@@ -58,6 +59,7 @@
 	.flags		= 0,				\
 	.cpu		= 0,				\
 	.preempt_count	= 1,				\
+	.migration_count = 0,				\
 	.addr_limit	= KERNEL_DS,			\
 	.restart_block = {				\
 		       .fn = do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/asm-frv/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-frv/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-frv/thread_info.h	2007-07-05 17:01:28.000000000 -0400
@@ -36,6 +36,7 @@
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
@@ -68,6 +69,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/asm-h8300/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-h8300/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-h8300/thread_info.h	2007-07-05 17:01:52.000000000 -0400
@@ -24,6 +24,7 @@
 	unsigned long	   flags;		/* low level flags */
 	int		   cpu;			/* cpu we're on */
 	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 };
 
@@ -37,6 +38,7 @@
 	.flags =	0,			\
 	.cpu =		0,			\
 	.preempt_count = 1,			\
+	.migration_count = 0,			\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6-lttng/include/asm-ia64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ia64/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-ia64/thread_info.h	2007-07-05 17:02:31.000000000 -0400
@@ -30,6 +30,7 @@
 	__u32 status;			/* Thread synchronous flags */
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
+	int migration_count;		/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 };
 
@@ -43,6 +44,7 @@
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= 0,			\
+	.migration_count = 0,			\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6-lttng/include/asm-m32r/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m32r/thread_info.h	2007-07-05 16:54:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-m32r/thread_info.h	2007-07-05 17:02:44.000000000 -0400
@@ -29,6 +29,7 @@
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thread
@@ -69,6 +70,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/asm-m68k/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68k/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68k/thread_info.h	2007-07-05 17:02:59.000000000 -0400
@@ -9,6 +9,7 @@
 	unsigned long		flags;
 	struct exec_domain	*exec_domain;	/* execution domain */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	__u32 cpu; /* should always be 0 on m68k */
 	struct restart_block    restart_block;
 };
Index: linux-2.6-lttng/include/asm-m68knommu/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68knommu/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68knommu/thread_info.h	2007-07-05 17:02:56.000000000 -0400
@@ -37,6 +37,7 @@
 	unsigned long	   flags;		/* low level flags */
 	int		   cpu;			/* cpu we're on */
 	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int		   migration_count;	/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 };
 
Index: linux-2.6-lttng/include/asm-mips/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/thread_info.h	2007-07-05 17:03:14.000000000 -0400
@@ -28,6 +28,7 @@
 	unsigned long		tp_value;	/* thread pointer */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 						   0-0xBFFFFFFF for user-thead
@@ -49,6 +50,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/asm-parisc/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-parisc/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-parisc/thread_info.h	2007-07-05 17:03:27.000000000 -0400
@@ -13,6 +13,7 @@
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	__u32 cpu;			/* current CPU */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
+	int migration_count;		/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 };
 
@@ -24,6 +25,7 @@
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
   	.restart_block	= {			\
 		.fn = do_no_restart_syscall	\
 	}					\
Index: linux-2.6-lttng/include/asm-powerpc/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/thread_info.h	2007-07-05 17:03:47.000000000 -0400
@@ -35,6 +35,7 @@
 	int		cpu;			/* cpu we're on */
 	int		preempt_count;		/* 0 => preemptable,
 						   <0 => BUG */
+	int		migration_count;	/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 	unsigned long	local_flags;		/* private flags for thread */
 
@@ -53,6 +54,7 @@
 	.exec_domain =	&default_exec_domain,	\
 	.cpu =		0,			\
 	.preempt_count = 1,			\
+	.migration_count = 0,			\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6-lttng/include/asm-s390/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-s390/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-s390/thread_info.h	2007-07-05 17:04:04.000000000 -0400
@@ -51,6 +51,7 @@
 	unsigned long		flags;		/* low level flags */
 	unsigned int		cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	struct restart_block	restart_block;
 };
 
@@ -64,6 +65,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
Index: linux-2.6-lttng/include/asm-sh/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sh/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-sh/thread_info.h	2007-07-05 17:04:32.000000000 -0400
@@ -21,6 +21,7 @@
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	mm_segment_t		addr_limit;	/* thread address space */
 	struct restart_block	restart_block;
 	unsigned long		previous_sp;	/* sp of previous stack in case
@@ -58,6 +59,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/asm-sh64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sh64/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-sh64/thread_info.h	2007-07-05 17:04:18.000000000 -0400
@@ -23,6 +23,7 @@
 	unsigned long		flags;		/* low level flags */
 	/* Put the 4 32-bit fields together to make asm offsetting easier. */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	__u16			cpu;
 
 	mm_segment_t		addr_limit;
@@ -41,6 +42,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
 	.addr_limit     = KERNEL_DS,            \
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/asm-sparc/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc/thread_info.h	2007-07-05 17:05:16.000000000 -0400
@@ -33,6 +33,7 @@
 	int			cpu;		/* cpu we're on */
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	int			softirq_count;
 	int			hardirq_count;
 
@@ -65,6 +66,7 @@
 	.flags		=	0,			\
 	.cpu		=	0,			\
 	.preempt_count	=	1,			\
+	.migration_count =	0,			\
 	.restart_block	= {				\
 		.fn	=	do_no_restart_syscall,	\
 	},						\
Index: linux-2.6-lttng/include/asm-sparc64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc64/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc64/thread_info.h	2007-07-05 17:05:00.000000000 -0400
@@ -47,6 +47,7 @@
 	struct pt_regs		*kregs;
 	struct exec_domain	*exec_domain;
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	__u8			new_child;
 	__u8			syscall_noerror;
 	__u16			cpu;
@@ -137,6 +138,7 @@
 	.flags		= ((unsigned long)ASI_P) << TI_FLAG_CURRENT_DS_SHIFT,	\
 	.exec_domain	=	&default_exec_domain,	\
 	.preempt_count	=	1,			\
+	.migration_count =	0,			\
 	.restart_block	= {				\
 		.fn	=	do_no_restart_syscall,	\
 	},						\
Index: linux-2.6-lttng/include/asm-um/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-um/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-um/thread_info.h	2007-07-05 17:05:30.000000000 -0400
@@ -18,6 +18,7 @@
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;  /* 0 => preemptable,
 						   <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user
 						   0-0xFFFFFFFF for kernel */
@@ -32,6 +33,7 @@
 	.flags =		0,		\
 	.cpu =		0,			\
 	.preempt_count =	1,		\
+	.migration_count =	0,		\
 	.addr_limit =	KERNEL_DS,		\
 	.restart_block =  {			\
 		.fn =  do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/asm-v850/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-v850/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-v850/thread_info.h	2007-07-05 17:05:41.000000000 -0400
@@ -32,6 +32,7 @@
 	int			cpu;		/* cpu we're on */
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 	struct restart_block	restart_block;
 };
 
@@ -42,6 +43,7 @@
 	.flags =	0,						      \
 	.cpu =		0,						      \
 	.preempt_count = 1,						      \
+	.migration_count = 0,						      \
 	.restart_block = {						      \
 		.fn = do_no_restart_syscall,				      \
 	},								      \
Index: linux-2.6-lttng/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/thread_info.h	2007-07-05 17:05:49.000000000 -0400
@@ -30,6 +30,7 @@
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int 			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migration_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	
 	struct restart_block    restart_block;
@@ -48,6 +49,7 @@
 	.flags	       = 0,			\
 	.cpu	       = 0,			\
 	.preempt_count = 1,			\
+	.migration_count = 0,			\
 	.addr_limit     = KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-2.6-lttng/include/asm-xtensa/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-xtensa/thread_info.h	2007-07-05 16:54:50.000000000 -0400
+++ linux-2.6-lttng/include/asm-xtensa/thread_info.h	2007-07-05 17:06:07.000000000 -0400
@@ -34,6 +34,7 @@
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	__s32			preempt_count;	/* 0 => preemptable,< 0 => BUG*/
+	__s32			migration_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space */
 	struct restart_block    restart_block;
@@ -72,6 +73,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migration_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
