Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbZFDF1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbZFDF1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbZFDF0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:26:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61039 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZFDF0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:26:13 -0400
Message-Id: <20090604052613.424656440@goodmis.org>
References: <20090604052540.528802957@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 01:25:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/6] tracing/branch-profiler: move macro defines to kernel.h
Content-Disposition: inline; filename=0004-tracing-branch-profiler-move-macro-defines-to-kernel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The branch profiler should not profile boot up code in the archs.
Moving it from compiler.h to kernel.h brings down its use.

This movement means we can also reference functions and variables
from the macros.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/compiler.h |   87 +--------------------------------------------
 include/linux/kernel.h   |   81 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 85 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index dd42294..24b35c6 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -55,91 +55,8 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  * specific implementations come from the above header files
  */
 
-struct ftrace_branch_data {
-	const char *func;
-	const char *file;
-	unsigned line;
-	union {
-		struct {
-			unsigned long correct;
-			unsigned long incorrect;
-		};
-		struct {
-			unsigned long miss;
-			unsigned long hit;
-		};
-		unsigned long miss_hit[2];
-	};
-};
-
-/*
- * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
- * to disable branch tracing on a per file basis.
- *  We currently do not profile modules.
- */
-#if defined(CONFIG_TRACE_BRANCH_PROFILING)				\
-	&& !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)	\
-	&& !defined(MODULE)
-void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
-
-#define likely_notrace(x)	__builtin_expect(!!(x), 1)
-#define unlikely_notrace(x)	__builtin_expect(!!(x), 0)
-
-#define __branch_check__(x, expect) ({					\
-			int ______r;					\
-			static struct ftrace_branch_data		\
-				__attribute__((__aligned__(4)))		\
-				__attribute__((section("_ftrace_annotated_branch"))) \
-				______f = {				\
-				.func = __func__,			\
-				.file = __FILE__,			\
-				.line = __LINE__,			\
-			};						\
-			______r = likely_notrace(x);			\
-			ftrace_likely_update(&______f, ______r, expect); \
-			______r;					\
-		})
-
-/*
- * Using __builtin_constant_p(x) to ignore cases where the return
- * value is always the same.  This idea is taken from a similar patch
- * written by Daniel Walker.
- */
-# ifndef likely
-#  define likely(x)	(__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
-# endif
-# ifndef unlikely
-#  define unlikely(x)	(__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
-# endif
-
-#ifdef CONFIG_PROFILE_ALL_BRANCHES
-/*
- * "Define 'is'", Bill Clinton
- * "Define 'if'", Steven Rostedt
- */
-#define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
-#define __trace_if(cond) \
-	if (__builtin_constant_p((cond)) ? !!(cond) :			\
-	({								\
-		int ______r;						\
-		static struct ftrace_branch_data			\
-			__attribute__((__aligned__(4)))			\
-			__attribute__((section("_ftrace_branch")))	\
-			______f = {					\
-				.func = __func__,			\
-				.file = __FILE__,			\
-				.line = __LINE__,			\
-			};						\
-		______r = !!(cond);					\
-		______f.miss_hit[______r]++;					\
-		______r;						\
-	}))
-#endif /* CONFIG_PROFILE_ALL_BRANCHES */
-
-#else
-# define likely(x)	__builtin_expect(!!(x), 1)
-# define unlikely(x)	__builtin_expect(!!(x), 0)
-#endif
+#define likely(x)	__builtin_expect(!!(x), 1)
+#define unlikely(x)	__builtin_expect(!!(x), 0)
 
 /* Optimization barrier */
 #ifndef barrier
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..f96a481 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -20,6 +20,87 @@
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
+
+struct ftrace_branch_data {
+	const char *func;
+	const char *file;
+	unsigned line;
+	union {
+		struct {
+			unsigned long correct;
+			unsigned long incorrect;
+		};
+		struct {
+			unsigned long miss;
+			unsigned long hit;
+		};
+		unsigned long miss_hit[2];
+	};
+};
+
+/*
+ * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
+ * to disable branch tracing on a per file basis.
+ *  We currently do not profile modules.
+ */
+#if defined(CONFIG_TRACE_BRANCH_PROFILING)				\
+	&& !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)	\
+	&& !defined(MODULE)
+void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
+
+#define likely_notrace(x)	__builtin_expect(!!(x), 1)
+#define unlikely_notrace(x)	__builtin_expect(!!(x), 0)
+
+#define __branch_check__(x, expect) ({					\
+			int ______r;					\
+			static struct ftrace_branch_data		\
+				__attribute__((__aligned__(4)))		\
+				__attribute__((section("_ftrace_annotated_branch"))) \
+				______f = {				\
+				.func = __func__,			\
+				.file = __FILE__,			\
+				.line = __LINE__,			\
+			};						\
+			______r = likely_notrace(x);			\
+			ftrace_likely_update(&______f, ______r, expect); \
+			______r;					\
+		})
+
+/*
+ * Using __builtin_constant_p(x) to ignore cases where the return
+ * value is always the same.  This idea is taken from a similar patch
+ * written by Daniel Walker.
+ */
+#undef likely
+#define likely(x)	(__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
+#undef unlikely
+#define unlikely(x)	(__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
+
+#ifdef CONFIG_PROFILE_ALL_BRANCHES
+/*
+ * "Define 'is'", Bill Clinton
+ * "Define 'if'", Steven Rostedt
+ */
+#define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
+#define __trace_if(cond) \
+	if (__builtin_constant_p((cond)) ? !!(cond) :			\
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
+		______f.miss_hit[______r]++;				\
+		______r;						\
+	}))
+#endif /* CONFIG_PROFILE_ALL_BRANCHES */
+#endif
+
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-- 
1.6.3.1

-- 
