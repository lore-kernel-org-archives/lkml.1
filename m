Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYKLVWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYKLVWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYKLVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:21:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYKLVVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:21:51 -0500
Message-Id: <20081112212150.097588288@goodmis.org>
References: <20081112212127.455979814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 16:21:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4] trace: rename unlikely profiler to branch profiler
Content-Disposition: inline; filename=0001-trace-rename-unlikely-profiler-to-branch-profiler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: name change of unlikely tracer and profiler

Ingo Molnar suggested changing the config from UNLIKELY_PROFILE
to BRANCH_PROFILING. I never did like the "unlikely" name so I
went one step farther, and renamed all the unlikely configurations
to a "BRANCH" variant.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/vsyscall_64.c     |    2 +-
 arch/x86/vdso/vclock_gettime.c    |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/compiler.h          |   19 ++++++++++---------
 kernel/trace/Kconfig              |   10 +++++-----
 kernel/trace/Makefile             |    7 +++----
 kernel/trace/trace.c              |    2 +-
 kernel/trace/trace.h              |    6 +++---
 kernel/trace/trace_unlikely.c     |    4 ++--
 9 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 9a596ae..44153af 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -18,7 +18,7 @@
  */
 
 /* Disable profiling for userspace code: */
-#define DISABLE_UNLIKELY_PROFILE
+#define DISABLE_BRANCH_PROFILING
 
 #include <linux/time.h>
 #include <linux/init.h>
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6e66763..d9d3582 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -10,7 +10,7 @@
  */
 
 /* Disable profiling for userspace code: */
-#define DISABLE_UNLIKELY_PROFILE
+#define DISABLE_BRANCH_PROFILING
 
 #include <linux/kernel.h>
 #include <linux/posix-timers.h>
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 2110312..ae7ef0c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -45,7 +45,7 @@
 #define MCOUNT_REC()
 #endif
 
-#ifdef CONFIG_TRACE_UNLIKELY_PROFILE
+#ifdef CONFIG_TRACE_BRANCH_PROFILING
 #define LIKELY_PROFILE()	VMLINUX_SYMBOL(__start_likely_profile) = .;   \
 				*(_ftrace_likely)			      \
 				VMLINUX_SYMBOL(__stop_likely_profile) = .;    \
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 63b7d90..c7d804a 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -59,26 +59,27 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  * specific implementations come from the above header files
  */
 
-/*
- * Note: DISABLE_UNLIKELY_PROFILE can be used by special lowlevel code
- * to disable branch tracing on a per file basis.
- */
-#if defined(CONFIG_TRACE_UNLIKELY_PROFILE) && !defined(DISABLE_UNLIKELY_PROFILE)
-struct ftrace_likely_data {
+struct ftrace_branch_data {
 	const char *func;
 	const char *file;
 	unsigned line;
 	unsigned long correct;
 	unsigned long incorrect;
 };
-void ftrace_likely_update(struct ftrace_likely_data *f, int val, int expect);
+
+/*
+ * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
+ * to disable branch tracing on a per file basis.
+ */
+#if defined(CONFIG_TRACE_BRANCH_PROFILING) && !defined(DISABLE_BRANCH_PROFILING)
+void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #define likely_notrace(x)	__builtin_expect(!!(x), 1)
 #define unlikely_notrace(x)	__builtin_expect(!!(x), 0)
 
 #define likely_check(x) ({						\
 			int ______r;					\
-			static struct ftrace_likely_data		\
+			static struct ftrace_branch_data		\
 				__attribute__((__aligned__(4)))		\
 				__attribute__((section("_ftrace_likely"))) \
 				______f = {				\
@@ -93,7 +94,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val, int expect);
 		})
 #define unlikely_check(x) ({						\
 			int ______r;					\
-			static struct ftrace_likely_data		\
+			static struct ftrace_branch_data		\
 				__attribute__((__aligned__(4)))		\
 				__attribute__((section("_ftrace_unlikely"))) \
 				______f = {				\
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8abcaf8..9c89526 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -159,7 +159,7 @@ config BOOT_TRACER
 	    selected, because the self-tests are an initcall as well and that
 	    would invalidate the boot trace. )
 
-config TRACE_UNLIKELY_PROFILE
+config TRACE_BRANCH_PROFILING
 	bool "Trace likely/unlikely profiler"
 	depends on DEBUG_KERNEL
 	select TRACING
@@ -175,7 +175,7 @@ config TRACE_UNLIKELY_PROFILE
 
 	  Say N if unsure.
 
-config TRACING_UNLIKELY
+config TRACING_BRANCHES
 	bool
 	help
 	  Selected by tracers that will trace the likely and unlikely
@@ -183,10 +183,10 @@ config TRACING_UNLIKELY
 	  profiled. Profiling the tracing infrastructure can only happen
 	  when the likelys and unlikelys are not being traced.
 
-config UNLIKELY_TRACER
+config BRANCH_TRACER
 	bool "Trace likely/unlikely instances"
-	depends on TRACE_UNLIKELY_PROFILE
-	select TRACING_UNLIKELY
+	depends on TRACE_BRANCH_PROFILING
+	select TRACING_BRANCHES
 	help
 	  This traces the events of likely and unlikely condition
 	  calls in the kernel.  The difference between this and the
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c938d03..0087df7 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -11,9 +11,8 @@ obj-y += trace_selftest_dynamic.o
 endif
 
 # If unlikely tracing is enabled, do not trace these files
-ifdef CONFIG_TRACING_UNLIKELY
-KBUILD_CFLAGS += '-Dlikely(x)=likely_notrace(x)'
-KBUILD_CFLAGS += '-Dunlikely(x)=unlikely_notrace(x)'
+ifdef CONFIG_TRACING_BRANCHES
+KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 endif
 
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
@@ -31,6 +30,6 @@ obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_RET_TRACER) += trace_functions_return.o
-obj-$(CONFIG_TRACE_UNLIKELY_PROFILE) += trace_unlikely.o
+obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_unlikely.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d842db1..bad59d3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -258,7 +258,7 @@ static const char *trace_options[] = {
 	"sched-tree",
 	"ftrace_printk",
 	"ftrace_preempt",
-#ifdef CONFIG_UNLIKELY_TRACER
+#ifdef CONFIG_BRANCH_TRACER
 	"unlikely",
 #endif
 	NULL
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9635aa2..dccae63 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -468,7 +468,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
 	TRACE_ITER_PREEMPTONLY		= 0x800,
-#ifdef CONFIG_UNLIKELY_TRACER
+#ifdef CONFIG_BRANCH_TRACER
 	TRACE_ITER_UNLIKELY		= 0x1000,
 #endif
 };
@@ -530,7 +530,7 @@ static inline void ftrace_preempt_enable(int resched)
 		preempt_enable_notrace();
 }
 
-#ifdef CONFIG_UNLIKELY_TRACER
+#ifdef CONFIG_BRANCH_TRACER
 extern int enable_unlikely_tracing(struct trace_array *tr);
 extern void disable_unlikely_tracing(void);
 static inline int trace_unlikely_enable(struct trace_array *tr)
@@ -552,6 +552,6 @@ static inline int trace_unlikely_enable(struct trace_array *tr)
 static inline void trace_unlikely_disable(void)
 {
 }
-#endif /* CONFIG_UNLIKELY_TRACER */
+#endif /* CONFIG_BRANCH_TRACER */
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_unlikely.c b/kernel/trace/trace_unlikely.c
index 7290e0e..856eb3b 100644
--- a/kernel/trace/trace_unlikely.c
+++ b/kernel/trace/trace_unlikely.c
@@ -15,7 +15,7 @@
 #include <asm/local.h>
 #include "trace.h"
 
-#ifdef CONFIG_UNLIKELY_TRACER
+#ifdef CONFIG_BRANCH_TRACER
 
 static int unlikely_tracing_enabled __read_mostly;
 static DEFINE_MUTEX(unlikely_tracing_mutex);
@@ -119,7 +119,7 @@ static inline
 void trace_likely_condition(struct ftrace_likely_data *f, int val, int expect)
 {
 }
-#endif /* CONFIG_UNLIKELY_TRACER */
+#endif /* CONFIG_BRANCH_TRACER */
 
 void ftrace_likely_update(struct ftrace_likely_data *f, int val, int expect)
 {
-- 
1.5.6.5

-- 
