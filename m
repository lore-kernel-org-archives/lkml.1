Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYKUHOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYKUHOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYKUHNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:13:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57896 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYKUHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:13:30 -0500
Message-Id: <20081121071328.029912673@goodmis.org>
References: <20081121071213.365288293@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 02:12:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] trace: consolidate unlikely and likely profiler
Content-Disposition: inline; filename=0002-trace-consolidate-unlikely-and-likely-profiler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up to make one profiler of like and unlikely tracer

The likely and unlikely profiler prints out the file and line numbers
of the annotated branches that it is profiling. It shows the number
of times it was correct or incorrect in its guess. Having two
different files or sections for that matter to tell us if it was a
likely or unlikely is pretty pointless. We really only care if
it was correct or not.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/asm-generic/vmlinux.lds.h |    9 ++-----
 include/linux/compiler.h          |   24 ++++------------------
 kernel/trace/Kconfig              |    3 +-
 kernel/trace/trace_branch.c       |   39 ++++++++++++------------------------
 4 files changed, 22 insertions(+), 53 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index dbb4f4a..62679ae 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -46,12 +46,9 @@
 #endif
 
 #ifdef CONFIG_TRACE_BRANCH_PROFILING
-#define LIKELY_PROFILE()	VMLINUX_SYMBOL(__start_likely_profile) = .;   \
-				*(_ftrace_likely)			      \
-				VMLINUX_SYMBOL(__stop_likely_profile) = .;    \
-				VMLINUX_SYMBOL(__start_unlikely_profile) = .; \
-				*(_ftrace_unlikely)			      \
-				VMLINUX_SYMBOL(__stop_unlikely_profile) = .;
+#define LIKELY_PROFILE()	VMLINUX_SYMBOL(__start_annotated_branch_profile) = .; \
+				*(_ftrace_annotated_branch)			      \
+				VMLINUX_SYMBOL(__stop_annotated_branch_profile) = .;
 #else
 #define LIKELY_PROFILE()
 #endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c25e525..0628a20 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -77,32 +77,18 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define likely_notrace(x)	__builtin_expect(!!(x), 1)
 #define unlikely_notrace(x)	__builtin_expect(!!(x), 0)
 
-#define likely_check(x) ({						\
+#define __branch_check__(x, expect) ({					\
 			int ______r;					\
 			static struct ftrace_branch_data		\
 				__attribute__((__aligned__(4)))		\
-				__attribute__((section("_ftrace_likely"))) \
+				__attribute__((section("_ftrace_annotated_branch"))) \
 				______f = {				\
 				.func = __func__,			\
 				.file = __FILE__,			\
 				.line = __LINE__,			\
 			};						\
 			______r = likely_notrace(x);			\
-			ftrace_likely_update(&______f, ______r, 1);	\
-			______r;					\
-		})
-#define unlikely_check(x) ({						\
-			int ______r;					\
-			static struct ftrace_branch_data		\
-				__attribute__((__aligned__(4)))		\
-				__attribute__((section("_ftrace_unlikely"))) \
-				______f = {				\
-				.func = __func__,			\
-				.file = __FILE__,			\
-				.line = __LINE__,			\
-			};						\
-			______r = unlikely_notrace(x);			\
-			ftrace_likely_update(&______f, ______r, 0);	\
+			ftrace_likely_update(&______f, ______r, expect); \
 			______r;					\
 		})
 
@@ -112,10 +98,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  * written by Daniel Walker.
  */
 # ifndef likely
-#  define likely(x)	(__builtin_constant_p(x) ? !!(x) : likely_check(x))
+#  define likely(x)	(__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
 # endif
 # ifndef unlikely
-#  define unlikely(x)	(__builtin_constant_p(x) ? !!(x) : unlikely_check(x))
+#  define unlikely(x)	(__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
 # endif
 #else
 # define likely(x)	__builtin_expect(!!(x), 1)
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b8378fa..7e35487 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -166,8 +166,7 @@ config TRACE_BRANCH_PROFILING
 	  This tracer profiles all the the likely and unlikely macros
 	  in the kernel. It will display the results in:
 
-	  /debugfs/tracing/profile_likely
-	  /debugfs/tracing/profile_unlikely
+	  /debugfs/tracing/profile_annotated_branch
 
 	  Note: this will add a significant overhead, only turn this
 	  on if you need to profile the system's use of these macros.
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 23f9b02..21dedc8 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -261,7 +261,7 @@ static struct seq_operations tracing_likely_seq_ops = {
 	.show		= t_show,
 };
 
-static int tracing_likely_open(struct inode *inode, struct file *file)
+static int tracing_branch_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
@@ -274,25 +274,18 @@ static int tracing_likely_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static struct file_operations tracing_likely_fops = {
-	.open		= tracing_likely_open,
+static const struct file_operations tracing_branch_fops = {
+	.open		= tracing_branch_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 };
 
-extern unsigned long __start_likely_profile[];
-extern unsigned long __stop_likely_profile[];
-extern unsigned long __start_unlikely_profile[];
-extern unsigned long __stop_unlikely_profile[];
+extern unsigned long __start_annotated_branch_profile[];
+extern unsigned long __stop_annotated_branch_profile[];
 
-static struct ftrace_pointer ftrace_likely_pos = {
-	.start			= __start_likely_profile,
-	.stop			= __stop_likely_profile,
-};
-
-static struct ftrace_pointer ftrace_unlikely_pos = {
-	.start			= __start_unlikely_profile,
-	.stop			= __stop_unlikely_profile,
+static const struct ftrace_pointer ftrace_annotated_branch_pos = {
+	.start			= __start_annotated_branch_profile,
+	.stop			= __stop_annotated_branch_profile,
 };
 
 static __init int ftrace_branch_init(void)
@@ -302,18 +295,12 @@ static __init int ftrace_branch_init(void)
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("profile_likely", 0444, d_tracer,
-				    &ftrace_likely_pos,
-				    &tracing_likely_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'profile_likely' entry\n");
-
-	entry = debugfs_create_file("profile_unlikely", 0444, d_tracer,
-				    &ftrace_unlikely_pos,
-				    &tracing_likely_fops);
+	entry = debugfs_create_file("profile_annotated_branch", 0444, d_tracer,
+				    &ftrace_annotated_branch_pos,
+				    &tracing_branch_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs"
-			   " 'profile_unlikely' entry\n");
+		pr_warning("Could not create debugfs "
+			   "'profile_annotatet_branch' entry\n");
 
 	return 0;
 }
-- 
1.5.6.5

-- 
