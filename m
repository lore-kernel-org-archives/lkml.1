Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbYKUHOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbYKUHOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYKUHNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:13:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64871 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYKUHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:13:30 -0500
Message-Id: <20081121071328.462456268@goodmis.org>
References: <20081121071213.365288293@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 02:12:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] trace: profile all if conditionals
Content-Disposition: inline; filename=0004-trace-profile-all-if-conditionals.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: feature to profile if statements

This patch adds a branch profiler for all if () statements.
The results will be found in:

  /debugfs/tracing/profile_branch

For example:

   miss      hit    %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0        1 100 x86_64_start_reservations      head64.c             127
       0        1 100 copy_bootdata                  head64.c             69
       1        0   0 x86_64_start_kernel            head64.c             111
      32        0   0 set_intr_gate                  desc.h               319
       1        0   0 reserve_ebda_region            head.c               51
       1        0   0 reserve_ebda_region            head.c               47
       0        1 100 reserve_ebda_region            head.c               42
       0        0   X maxcpus                        main.c               165

Miss means the branch was not taken. Hit means the branch was taken.
The percent is the percentage the branch was taken.

This adds a significant amount of overhead and should only be used
by those analyzing their system.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/asm-generic/vmlinux.lds.h |   11 +++++++++-
 include/linux/compiler.h          |   38 +++++++++++++++++++++++++++++++++++-
 kernel/trace/Kconfig              |   16 +++++++++++++++
 kernel/trace/trace_branch.c       |   33 ++++++++++++++++++++++++++++++-
 4 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 62679ae..30536c3 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -53,6 +53,14 @@
 #define LIKELY_PROFILE()
 #endif
 
+#ifdef CONFIG_PROFILE_ALL_BRANCHES
+#define BRANCH_PROFILE()	VMLINUX_SYMBOL(__start_branch_profile) = .;   \
+				*(_ftrace_branch)			      \
+				VMLINUX_SYMBOL(__stop_branch_profile) = .;
+#else
+#define BRANCH_PROFILE()
+#endif
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
@@ -72,7 +80,8 @@
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
 	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
-	LIKELY_PROFILE()
+	LIKELY_PROFILE()		       				\
+	BRANCH_PROFILE()
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 0628a20..ea7c6be 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -63,8 +63,16 @@ struct ftrace_branch_data {
 	const char *func;
 	const char *file;
 	unsigned line;
-	unsigned long correct;
-	unsigned long incorrect;
+	union {
+		struct {
+			unsigned long correct;
+			unsigned long incorrect;
+		};
+		struct {
+			unsigned long miss;
+			unsigned long hit;
+		};
+	};
 };
 
 /*
@@ -103,6 +111,32 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # ifndef unlikely
 #  define unlikely(x)	(__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
 # endif
+
+#ifdef CONFIG_PROFILE_ALL_BRANCHES
+/*
+ * "Define 'is'", Bill Clinton
+ * "Define 'if'", Steven Rostedt
+ */
+#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
+	({								\
+		int ______r;						\
+		static struct ftrace_branch_data			\
+			__attribute__((__aligned__(4)))			\
+			__attribute__((section("_ftrace_branch")))	\
+			______f = {					\
+				.func = __func__,			\
+				.file = __FILE__,			\
+				.line = __LINE__,			\
+			};						\
+		______r = !!(cond);					\
+		if (______r)						\
+			______f.hit++;					\
+		else							\
+			______f.miss++;					\
+		______r;						\
+	}))
+#endif /* CONFIG_PROFILE_ALL_BRANCHES */
+
 #else
 # define likely(x)	__builtin_expect(!!(x), 1)
 # define unlikely(x)	__builtin_expect(!!(x), 0)
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 7e35487..61e8cca 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -173,6 +173,22 @@ config TRACE_BRANCH_PROFILING
 
 	  Say N if unsure.
 
+config PROFILE_ALL_BRANCHES
+	bool "Profile all if conditionals"
+	depends on TRACE_BRANCH_PROFILING
+	help
+	  This tracer profiles all branch conditions. Every if ()
+	  taken in the kernel is recorded whether it hit or miss.
+	  The results will be displayed in:
+
+	  /debugfs/tracing/profile_branch
+
+	  This configuration, when enabled, will impose a great overhead
+	  on the system. This should only be enabled when the system
+	  is to be analyzed
+
+	  Say N if unsure.
+
 config TRACING_BRANCHES
 	bool
 	help
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 142acb3..85792ae 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -185,6 +185,7 @@ EXPORT_SYMBOL(ftrace_likely_update);
 struct ftrace_pointer {
 	void		*start;
 	void		*stop;
+	int		hit;
 };
 
 static void *
@@ -223,13 +224,17 @@ static void t_stop(struct seq_file *m, void *p)
 
 static int t_show(struct seq_file *m, void *v)
 {
+	struct ftrace_pointer *fp = m->private;
 	struct ftrace_branch_data *p = v;
 	const char *f;
 	long percent;
 
 	if (v == (void *)1) {
-		seq_printf(m, " correct incorrect  %% "
-			      "       Function                "
+		if (fp->hit)
+			seq_printf(m, "   miss      hit    %% ");
+		else
+			seq_printf(m, " correct incorrect  %% ");
+		seq_printf(m, "       Function                "
 			      "  File              Line\n"
 			      " ------- ---------  - "
 			      "       --------                "
@@ -243,6 +248,9 @@ static int t_show(struct seq_file *m, void *v)
 		f--;
 	f++;
 
+	/*
+	 * The miss is overlayed on correct, and hit on incorrect.
+	 */
 	if (p->correct) {
 		percent = p->incorrect * 100;
 		percent /= p->correct + p->incorrect;
@@ -284,6 +292,18 @@ static const struct file_operations tracing_branch_fops = {
 	.llseek		= seq_lseek,
 };
 
+#ifdef CONFIG_PROFILE_ALL_BRANCHES
+extern unsigned long __start_branch_profile[];
+extern unsigned long __stop_branch_profile[];
+
+static struct ftrace_pointer ftrace_branch_pos = {
+	.start			= __start_branch_profile,
+	.stop			= __stop_branch_profile,
+	.hit			= 1,
+};
+
+#endif /* CONFIG_PROFILE_ALL_BRANCHES */
+
 extern unsigned long __start_annotated_branch_profile[];
 extern unsigned long __stop_annotated_branch_profile[];
 
@@ -306,6 +326,15 @@ static __init int ftrace_branch_init(void)
 		pr_warning("Could not create debugfs "
 			   "'profile_annotatet_branch' entry\n");
 
+#ifdef CONFIG_PROFILE_ALL_BRANCHES
+	entry = debugfs_create_file("profile_branch", 0444, d_tracer,
+				    &ftrace_branch_pos,
+				    &tracing_branch_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs"
+			   " 'profile_branch' entry\n");
+#endif
+
 	return 0;
 }
 
-- 
1.5.6.5

-- 
