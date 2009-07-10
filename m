Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZGJEgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZGJEgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 00:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZGJEgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 00:36:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47516 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZGJEfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 00:35:54 -0400
Date: Fri, 10 Jul 2009 06:35:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [RFC GIT PULL] perfcounters updates and fixes
Message-ID: <20090710043526.GA19189@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling the latest perfcounters-fixes-for-linus git 
tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

This is the last bigger batch of perfcounters updates - but if it's 
too large i can cut it down some by phasing the atomic64_t patches 
to v2.6.32. I included it here because 32-bit atomic64_t is new in 
2.6.31 so there's no risk of regression. The remaining generic 
impact is:

 arch/x86/include/asm/stacktrace.h        |    2 +
 arch/x86/kernel/dumpstack_32.c           |    6 +
 arch/x86/kernel/dumpstack_64.c           |   22 +-

Which change is related to callchains. The tree is well-tested, the 
last commit is 5 days old and the tree has calmed down.

The updates are:

 - module symbols and annotation support
 - complete call-chain support on the tooling side
 - atomic64_t cleanups
 - cleanups/code-removal
 - fixes

 Thanks,

	Ingo

------------------>
Anton Blanchard (7):
      perf report: Fix -z option
      perf_counter tools: Remove zlib dependency
      perf top: Move skip symbols to an array
      perf top: Add ppc64 specific skip symbols and strip ppc64 . prefix
      perf report: Fix reporting of hypervisor
      perf report: Add hypervisor dso
      powerpc/perf_counter: Enable alternate PR/HV bits for POWER7

Arnaldo Carvalho de Melo (3):
      perf_counter tools: Share rbtree.with the kernel
      perf_counter tools: Share list.h with the kernel
      perf_counter tools: Adjust symbols in ET_EXEC files too

Eric Dumazet (5):
      x86: atomic64: The atomic64_t data type should be 8 bytes aligned on 32-bit too
      x86: atomic64: Improve atomic64_read()
      x86: atomic64: Improve cmpxchg8b()
      x86: atomic64: Improve atomic64_read()
      x86: atomic64: Inline atomic64_read() again

Frederic Weisbecker (16):
      perf_counter tools: Fix storage size allocation of callchain list
      perf_counter tools: Resolve symbols in callchains
      perf_counter tools: Various fixes for callchains
      perf_counter: Ignore the nmi call frames in the x86-64 backtraces
      perf stat: Handle pipe read failures in perf stat
      perf_counter tools: Create new chain_for_each_child() iterator
      perf_counter tools: Add new OPT_CALLBACK_DEFAULT option
      perf report: Add support for callchain graph output
      perf_counter tools: Set the minimum percent for callchains to be displayed
      perf_counter tools: Provide helper to print percents color
      perf_counter tools: Display percents of hits in callchain with overhead colors
      perf report: Warn on callchain output request from non-callchain file
      perf report: Use a modifiable string for default callchain options
      perf report: Change default callchain parameters
      perf_counter tools: callchains: Manage the cumul hits on the fly
      perf report: Add "Fractal" mode output - support callchains with relative overhead rate

Ingo Molnar (11):
      perf report: Fix HV bit mismerge
      perf_counter tools: Add more warnings and fix/annotate them
      perf report: Annotate variable initialization
      x86: atomic64: Move the 32-bit atomic64_t implementation to a .c file
      x86: atomic64: Improve atomic64_add_return()
      x86: atomic64: Reduce size of functions
      x86: atomic64: Make atomic_read() type-safe
      x86: atomic64: Fix unclean type use in atomic64_xchg()
      x86: atomic64: Export APIs to modules
      x86: atomic64: Improve atomic64_xchg()
      x86: atomic64: Clean up atomic64_sub_and_test() and atomic64_add_negative()

Jaswinder Singh Rajput (2):
      perf stat: Define MATCH_EVENT for easy attr checking
      perf list: Add cache events

Mike Galbraith (4):
      perf_counter tools: Make symbol loading consistently return number of loaded symbols
      perf_counter tools: Add infrastructure to support loading of kernel module symbols
      perf_counter tools: Connect module support infrastructure to symbol loading infrastructure
      perf_counter tools: Enable kernel module symbol loading in tools

Paul Mackerras (2):
      perf_counter tools: Rework event string parsing/syntax
      x86: atomic64: Code atomic(64)_read and atomic(64)_set in C not CPP


 arch/powerpc/kernel/power7-pmu.c         |    1 +
 arch/x86/include/asm/atomic_32.h         |  185 +++-------
 arch/x86/include/asm/atomic_64.h         |   42 ++-
 arch/x86/include/asm/stacktrace.h        |    2 +
 arch/x86/kernel/cpu/perf_counter.c       |    8 +-
 arch/x86/kernel/dumpstack_32.c           |    6 +
 arch/x86/kernel/dumpstack_64.c           |   22 +-
 arch/x86/lib/Makefile                    |    1 +
 arch/x86/lib/atomic64_32.c               |  230 ++++++++++++
 tools/perf/Makefile                      |   20 +-
 tools/perf/builtin-annotate.c            |   69 ++--
 tools/perf/builtin-help.c                |    6 +-
 tools/perf/builtin-list.c                |    2 +-
 tools/perf/builtin-record.c              |    4 +-
 tools/perf/builtin-report.c              |  383 +++++++++++++++----
 tools/perf/builtin-stat.c                |   51 ++--
 tools/perf/builtin-top.c                 |   70 ++--
 tools/perf/perf.c                        |    5 +-
 tools/perf/perf.h                        |    2 +
 tools/perf/util/alias.c                  |    2 +-
 tools/perf/util/cache.h                  |    1 +
 tools/perf/util/callchain.c              |  255 ++++++++++---
 tools/perf/util/callchain.h              |   41 ++-
 tools/perf/util/color.c                  |   37 ++-
 tools/perf/util/color.h                  |    5 +
 tools/perf/util/config.c                 |   18 +-
 tools/perf/util/exec_cmd.c               |    5 +-
 tools/perf/util/help.c                   |   26 +-
 tools/perf/util/help.h                   |    6 +-
 tools/perf/util/include/asm/system.h     |    1 +
 tools/perf/util/include/linux/kernel.h   |   21 +
 tools/perf/util/include/linux/list.h     |   18 +
 tools/perf/util/include/linux/module.h   |    6 +
 tools/perf/util/include/linux/poison.h   |    1 +
 tools/perf/util/include/linux/prefetch.h |    6 +
 tools/perf/util/include/linux/rbtree.h   |    1 +
 tools/perf/util/list.h                   |  603 ------------------------------
 tools/perf/util/module.c                 |  509 +++++++++++++++++++++++++
 tools/perf/util/module.h                 |   53 +++
 tools/perf/util/parse-events.c           |  251 +++++++++----
 tools/perf/util/parse-options.c          |    5 +-
 tools/perf/util/parse-options.h          |   27 +-
 tools/perf/util/quote.c                  |   46 ++-
 tools/perf/util/quote.h                  |    2 +-
 tools/perf/util/rbtree.c                 |  383 -------------------
 tools/perf/util/rbtree.h                 |  171 ---------
 tools/perf/util/strbuf.c                 |   13 +-
 tools/perf/util/strbuf.h                 |   10 +-
 tools/perf/util/strlist.h                |    2 +-
 tools/perf/util/symbol.c                 |  179 ++++++++-
 tools/perf/util/symbol.h                 |   11 +-
 tools/perf/util/wrapper.c                |    5 +-
 52 files changed, 2105 insertions(+), 1724 deletions(-)
 create mode 100644 arch/x86/lib/atomic64_32.c
 create mode 100644 tools/perf/util/include/asm/system.h
 create mode 100644 tools/perf/util/include/linux/kernel.h
 create mode 100644 tools/perf/util/include/linux/list.h
 create mode 100644 tools/perf/util/include/linux/module.h
 create mode 100644 tools/perf/util/include/linux/poison.h
 create mode 100644 tools/perf/util/include/linux/prefetch.h
 create mode 100644 tools/perf/util/include/linux/rbtree.h
 delete mode 100644 tools/perf/util/list.h
 create mode 100644 tools/perf/util/module.c
 create mode 100644 tools/perf/util/module.h
 delete mode 100644 tools/perf/util/rbtree.c
 delete mode 100644 tools/perf/util/rbtree.h

diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 5d755ef..5a9f5cb 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -358,6 +358,7 @@ static struct power_pmu power7_pmu = {
 	.get_constraint		= power7_get_constraint,
 	.get_alternatives	= power7_get_alternatives,
 	.disable_pmc		= power7_disable_pmc,
+	.flags			= PPMU_ALT_SIPR,
 	.n_generic		= ARRAY_SIZE(power7_generic_events),
 	.generic_events		= power7_generic_events,
 	.cache_events		= &power7_cache_events,
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 2503d4e..dc5a667 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -19,7 +19,10 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		((v)->counter)
+static inline int atomic_read(const atomic_t *v)
+{
+	return v->counter;
+}
 
 /**
  * atomic_set - set atomic variable
@@ -28,7 +31,10 @@
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic_set(v, i)	(((v)->counter) = (i))
+static inline void atomic_set(atomic_t *v, int i)
+{
+	v->counter = i;
+}
 
 /**
  * atomic_add - add integer to atomic variable
@@ -200,8 +206,15 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	return atomic_add_return(-i, v);
 }
 
-#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline int atomic_xchg(atomic_t *v, int new)
+{
+	return xchg(&v->counter, new);
+}
 
 /**
  * atomic_add_unless - add unless the number is already a given value
@@ -250,45 +263,12 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 /* An 64bit atomic type */
 
 typedef struct {
-	unsigned long long counter;
+	u64 __aligned(8) counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(val)	{ (val) }
 
-/**
- * atomic64_read - read atomic64 variable
- * @ptr: pointer of type atomic64_t
- *
- * Atomically reads the value of @v.
- * Doesn't imply a read memory barrier.
- */
-#define __atomic64_read(ptr)		((ptr)->counter)
-
-static inline unsigned long long
-cmpxchg8b(unsigned long long *ptr, unsigned long long old, unsigned long long new)
-{
-	asm volatile(
-
-		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
-
-		     :		"=A" (old)
-
-		     : [ptr]	"D" (ptr),
-				"A" (old),
-				"b" (ll_low(new)),
-				"c" (ll_high(new))
-
-		     : "memory");
-
-	return old;
-}
-
-static inline unsigned long long
-atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
-		 unsigned long long new_val)
-{
-	return cmpxchg8b(&ptr->counter, old_val, new_val);
-}
+extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
 
 /**
  * atomic64_xchg - xchg atomic64 variable
@@ -298,18 +278,7 @@ atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
  * Atomically xchgs the value of @ptr to @new_val and returns
  * the old value.
  */
-
-static inline unsigned long long
-atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
-{
-	unsigned long long old_val;
-
-	do {
-		old_val = atomic_read(ptr);
-	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
-
-	return old_val;
-}
+extern u64 atomic64_xchg(atomic64_t *ptr, u64 new_val);
 
 /**
  * atomic64_set - set atomic64 variable
@@ -318,10 +287,7 @@ atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
  *
  * Atomically sets the value of @ptr to @new_val.
  */
-static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
-{
-	atomic64_xchg(ptr, new_val);
-}
+extern void atomic64_set(atomic64_t *ptr, u64 new_val);
 
 /**
  * atomic64_read - read atomic64 variable
@@ -329,17 +295,30 @@ static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
  *
  * Atomically reads the value of @ptr and returns it.
  */
-static inline unsigned long long atomic64_read(atomic64_t *ptr)
+static inline u64 atomic64_read(atomic64_t *ptr)
 {
-	unsigned long long curr_val;
-
-	do {
-		curr_val = __atomic64_read(ptr);
-	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
-
-	return curr_val;
+	u64 res;
+
+	/*
+	 * Note, we inline this atomic64_t primitive because
+	 * it only clobbers EAX/EDX and leaves the others
+	 * untouched. We also (somewhat subtly) rely on the
+	 * fact that cmpxchg8b returns the current 64-bit value
+	 * of the memory location we are touching:
+	 */
+	asm volatile(
+		"mov %%ebx, %%eax\n\t"
+		"mov %%ecx, %%edx\n\t"
+		LOCK_PREFIX "cmpxchg8b %1\n"
+			: "=&A" (res)
+			: "m" (*ptr)
+		);
+
+	return res;
 }
 
+extern u64 atomic64_read(atomic64_t *ptr);
+
 /**
  * atomic64_add_return - add and return
  * @delta: integer value to add
@@ -347,34 +326,14 @@ static inline unsigned long long atomic64_read(atomic64_t *ptr)
  *
  * Atomically adds @delta to @ptr and returns @delta + *@ptr
  */
-static inline unsigned long long
-atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
-{
-	unsigned long long old_val, new_val;
-
-	do {
-		old_val = atomic_read(ptr);
-		new_val = old_val + delta;
-
-	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
-
-	return new_val;
-}
-
-static inline long atomic64_sub_return(unsigned long long delta, atomic64_t *ptr)
-{
-	return atomic64_add_return(-delta, ptr);
-}
+extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
 
-static inline long atomic64_inc_return(atomic64_t *ptr)
-{
-	return atomic64_add_return(1, ptr);
-}
-
-static inline long atomic64_dec_return(atomic64_t *ptr)
-{
-	return atomic64_sub_return(1, ptr);
-}
+/*
+ * Other variants with different arithmetic operators:
+ */
+extern u64 atomic64_sub_return(u64 delta, atomic64_t *ptr);
+extern u64 atomic64_inc_return(atomic64_t *ptr);
+extern u64 atomic64_dec_return(atomic64_t *ptr);
 
 /**
  * atomic64_add - add integer to atomic64 variable
@@ -383,10 +342,7 @@ static inline long atomic64_dec_return(atomic64_t *ptr)
  *
  * Atomically adds @delta to @ptr.
  */
-static inline void atomic64_add(unsigned long long delta, atomic64_t *ptr)
-{
-	atomic64_add_return(delta, ptr);
-}
+extern void atomic64_add(u64 delta, atomic64_t *ptr);
 
 /**
  * atomic64_sub - subtract the atomic64 variable
@@ -395,10 +351,7 @@ static inline void atomic64_add(unsigned long long delta, atomic64_t *ptr)
  *
  * Atomically subtracts @delta from @ptr.
  */
-static inline void atomic64_sub(unsigned long long delta, atomic64_t *ptr)
-{
-	atomic64_add(-delta, ptr);
-}
+extern void atomic64_sub(u64 delta, atomic64_t *ptr);
 
 /**
  * atomic64_sub_and_test - subtract value from variable and test result
@@ -409,13 +362,7 @@ static inline void atomic64_sub(unsigned long long delta, atomic64_t *ptr)
  * true if the result is zero, or false for all
  * other cases.
  */
-static inline int
-atomic64_sub_and_test(unsigned long long delta, atomic64_t *ptr)
-{
-	unsigned long long old_val = atomic64_sub_return(delta, ptr);
-
-	return old_val == 0;
-}
+extern int atomic64_sub_and_test(u64 delta, atomic64_t *ptr);
 
 /**
  * atomic64_inc - increment atomic64 variable
@@ -423,10 +370,7 @@ atomic64_sub_and_test(unsigned long long delta, atomic64_t *ptr)
  *
  * Atomically increments @ptr by 1.
  */
-static inline void atomic64_inc(atomic64_t *ptr)
-{
-	atomic64_add(1, ptr);
-}
+extern void atomic64_inc(atomic64_t *ptr);
 
 /**
  * atomic64_dec - decrement atomic64 variable
@@ -434,10 +378,7 @@ static inline void atomic64_inc(atomic64_t *ptr)
  *
  * Atomically decrements @ptr by 1.
  */
-static inline void atomic64_dec(atomic64_t *ptr)
-{
-	atomic64_sub(1, ptr);
-}
+extern void atomic64_dec(atomic64_t *ptr);
 
 /**
  * atomic64_dec_and_test - decrement and test
@@ -447,10 +388,7 @@ static inline void atomic64_dec(atomic64_t *ptr)
  * returns true if the result is 0, or false for all other
  * cases.
  */
-static inline int atomic64_dec_and_test(atomic64_t *ptr)
-{
-	return atomic64_sub_and_test(1, ptr);
-}
+extern int atomic64_dec_and_test(atomic64_t *ptr);
 
 /**
  * atomic64_inc_and_test - increment and test
@@ -460,10 +398,7 @@ static inline int atomic64_dec_and_test(atomic64_t *ptr)
  * and returns true if the result is zero, or false for all
  * other cases.
  */
-static inline int atomic64_inc_and_test(atomic64_t *ptr)
-{
-	return atomic64_sub_and_test(-1, ptr);
-}
+extern int atomic64_inc_and_test(atomic64_t *ptr);
 
 /**
  * atomic64_add_negative - add and test if negative
@@ -474,13 +409,7 @@ static inline int atomic64_inc_and_test(atomic64_t *ptr)
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
-static inline int
-atomic64_add_negative(unsigned long long delta, atomic64_t *ptr)
-{
-	long long old_val = atomic64_add_return(delta, ptr);
-
-	return old_val < 0;
-}
+extern int atomic64_add_negative(u64 delta, atomic64_t *ptr);
 
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index 0d63602..d605dc2 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -18,7 +18,10 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		((v)->counter)
+static inline int atomic_read(const atomic_t *v)
+{
+	return v->counter;
+}
 
 /**
  * atomic_set - set atomic variable
@@ -27,7 +30,10 @@
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic_set(v, i)		(((v)->counter) = (i))
+static inline void atomic_set(atomic_t *v, int i)
+{
+	v->counter = i;
+}
 
 /**
  * atomic_add - add integer to atomic variable
@@ -192,7 +198,10 @@ static inline int atomic_sub_return(int i, atomic_t *v)
  * Atomically reads the value of @v.
  * Doesn't imply a read memory barrier.
  */
-#define atomic64_read(v)		((v)->counter)
+static inline long atomic64_read(const atomic64_t *v)
+{
+	return v->counter;
+}
 
 /**
  * atomic64_set - set atomic64 variable
@@ -201,7 +210,10 @@ static inline int atomic_sub_return(int i, atomic_t *v)
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic64_set(v, i)		(((v)->counter) = (i))
+static inline void atomic64_set(atomic64_t *v, long i)
+{
+	v->counter = i;
+}
 
 /**
  * atomic64_add - add integer to atomic64 variable
@@ -355,11 +367,25 @@ static inline long atomic64_sub_return(long i, atomic64_t *v)
 #define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
 #define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
 
-#define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
-#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline long atomic64_xchg(atomic64_t *v, long new)
+{
+	return xchg(&v->counter, new);
+}
 
-#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
+static inline long atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline long atomic_xchg(atomic_t *v, int new)
+{
+	return xchg(&v->counter, new);
+}
 
 /**
  * atomic_add_unless - add unless the number is a given value
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index f517944..cf86a5e 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -3,6 +3,8 @@
 
 extern int kstack_depth_to_print;
 
+int x86_is_stack_id(int id, char *name);
+
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d4cf4ce..36c3dc7 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1561,6 +1561,7 @@ void callchain_store(struct perf_callchain_entry *entry, u64 ip)
 
 static DEFINE_PER_CPU(struct perf_callchain_entry, irq_entry);
 static DEFINE_PER_CPU(struct perf_callchain_entry, nmi_entry);
+static DEFINE_PER_CPU(int, in_nmi_frame);
 
 
 static void
@@ -1576,7 +1577,9 @@ static void backtrace_warning(void *data, char *msg)
 
 static int backtrace_stack(void *data, char *name)
 {
-	/* Process all stacks: */
+	per_cpu(in_nmi_frame, smp_processor_id()) =
+			x86_is_stack_id(NMI_STACK, name);
+
 	return 0;
 }
 
@@ -1584,6 +1587,9 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
+	if (per_cpu(in_nmi_frame, smp_processor_id()))
+		return;
+
 	if (reliable)
 		callchain_store(entry, addr);
 }
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index d593cd1..bca5fba 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -19,6 +19,12 @@
 
 #include "dumpstack.h"
 
+/* Just a stub for now */
+int x86_is_stack_id(int id, char *name)
+{
+	return 0;
+}
+
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index d35db59..54b0a32 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -19,10 +19,8 @@
 
 #include "dumpstack.h"
 
-static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
-					unsigned *usedp, char **idp)
-{
-	static char ids[][8] = {
+
+static char x86_stack_ids[][8] = {
 		[DEBUG_STACK - 1] = "#DB",
 		[NMI_STACK - 1] = "NMI",
 		[DOUBLEFAULT_STACK - 1] = "#DF",
@@ -33,6 +31,15 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
 #endif
 	};
+
+int x86_is_stack_id(int id, char *name)
+{
+	return x86_stack_ids[id - 1] == name;
+}
+
+static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
+					unsigned *usedp, char **idp)
+{
 	unsigned k;
 
 	/*
@@ -61,7 +68,7 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 			if (*usedp & (1U << k))
 				break;
 			*usedp |= 1U << k;
-			*idp = ids[k];
+			*idp = x86_stack_ids[k];
 			return (unsigned long *)end;
 		}
 		/*
@@ -81,12 +88,13 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 			do {
 				++j;
 				end -= EXCEPTION_STKSZ;
-				ids[j][4] = '1' + (j - N_EXCEPTION_STACKS);
+				x86_stack_ids[j][4] = '1' +
+						(j - N_EXCEPTION_STACKS);
 			} while (stack < end - EXCEPTION_STKSZ);
 			if (*usedp & (1U << j))
 				break;
 			*usedp |= 1U << j;
-			*idp = ids[j];
+			*idp = x86_stack_ids[j];
 			return (unsigned long *)end;
 		}
 #endif
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f9d3563..07c3189 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -10,6 +10,7 @@ lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 
 ifeq ($(CONFIG_X86_32),y)
+        obj-y += atomic64_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += semaphore_32.o string_32.o
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
new file mode 100644
index 0000000..824fa0b
--- /dev/null
+++ b/arch/x86/lib/atomic64_32.c
@@ -0,0 +1,230 @@
+#include <linux/compiler.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+#include <asm/processor.h>
+#include <asm/cmpxchg.h>
+#include <asm/atomic.h>
+
+static noinline u64 cmpxchg8b(u64 *ptr, u64 old, u64 new)
+{
+	u32 low = new;
+	u32 high = new >> 32;
+
+	asm volatile(
+		LOCK_PREFIX "cmpxchg8b %1\n"
+		     : "+A" (old), "+m" (*ptr)
+		     :  "b" (low),  "c" (high)
+		     );
+	return old;
+}
+
+u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val)
+{
+	return cmpxchg8b(&ptr->counter, old_val, new_val);
+}
+EXPORT_SYMBOL(atomic64_cmpxchg);
+
+/**
+ * atomic64_xchg - xchg atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically xchgs the value of @ptr to @new_val and returns
+ * the old value.
+ */
+u64 atomic64_xchg(atomic64_t *ptr, u64 new_val)
+{
+	/*
+	 * Try first with a (possibly incorrect) assumption about
+	 * what we have there. We'll do two loops most likely,
+	 * but we'll get an ownership MESI transaction straight away
+	 * instead of a read transaction followed by a
+	 * flush-for-ownership transaction:
+	 */
+	u64 old_val, real_val = 0;
+
+	do {
+		old_val = real_val;
+
+		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
+
+	} while (real_val != old_val);
+
+	return old_val;
+}
+EXPORT_SYMBOL(atomic64_xchg);
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically sets the value of @ptr to @new_val.
+ */
+void atomic64_set(atomic64_t *ptr, u64 new_val)
+{
+	atomic64_xchg(ptr, new_val);
+}
+EXPORT_SYMBOL(atomic64_set);
+
+/**
+EXPORT_SYMBOL(atomic64_read);
+ * atomic64_add_return - add and return
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ */
+noinline u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
+{
+	/*
+	 * Try first with a (possibly incorrect) assumption about
+	 * what we have there. We'll do two loops most likely,
+	 * but we'll get an ownership MESI transaction straight away
+	 * instead of a read transaction followed by a
+	 * flush-for-ownership transaction:
+	 */
+	u64 old_val, new_val, real_val = 0;
+
+	do {
+		old_val = real_val;
+		new_val = old_val + delta;
+
+		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
+
+	} while (real_val != old_val);
+
+	return new_val;
+}
+EXPORT_SYMBOL(atomic64_add_return);
+
+u64 atomic64_sub_return(u64 delta, atomic64_t *ptr)
+{
+	return atomic64_add_return(-delta, ptr);
+}
+EXPORT_SYMBOL(atomic64_sub_return);
+
+u64 atomic64_inc_return(atomic64_t *ptr)
+{
+	return atomic64_add_return(1, ptr);
+}
+EXPORT_SYMBOL(atomic64_inc_return);
+
+u64 atomic64_dec_return(atomic64_t *ptr)
+{
+	return atomic64_sub_return(1, ptr);
+}
+EXPORT_SYMBOL(atomic64_dec_return);
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr.
+ */
+void atomic64_add(u64 delta, atomic64_t *ptr)
+{
+	atomic64_add_return(delta, ptr);
+}
+EXPORT_SYMBOL(atomic64_add);
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr.
+ */
+void atomic64_sub(u64 delta, atomic64_t *ptr)
+{
+	atomic64_add(-delta, ptr);
+}
+EXPORT_SYMBOL(atomic64_sub);
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+int atomic64_sub_and_test(u64 delta, atomic64_t *ptr)
+{
+	u64 new_val = atomic64_sub_return(delta, ptr);
+
+	return new_val == 0;
+}
+EXPORT_SYMBOL(atomic64_sub_and_test);
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1.
+ */
+void atomic64_inc(atomic64_t *ptr)
+{
+	atomic64_add(1, ptr);
+}
+EXPORT_SYMBOL(atomic64_inc);
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1.
+ */
+void atomic64_dec(atomic64_t *ptr)
+{
+	atomic64_sub(1, ptr);
+}
+EXPORT_SYMBOL(atomic64_dec);
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+int atomic64_dec_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(1, ptr);
+}
+EXPORT_SYMBOL(atomic64_dec_and_test);
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+int atomic64_inc_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(-1, ptr);
+}
+EXPORT_SYMBOL(atomic64_inc_and_test);
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+int atomic64_add_negative(u64 delta, atomic64_t *ptr)
+{
+	s64 new_val = atomic64_add_return(delta, ptr);
+
+	return new_val < 0;
+}
+EXPORT_SYMBOL(atomic64_add_negative);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9c6d0ae..7822b3d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -164,7 +164,7 @@ endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -Werror -O6
+CFLAGS = $(M64) -ggdb3 -Wall -Wextra -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -Werror -O6
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
@@ -223,7 +223,7 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS =
+BASIC_CFLAGS = -Iutil/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -289,10 +289,11 @@ export PERL_PATH
 LIB_FILE=libperf.a
 
 LIB_H += ../../include/linux/perf_counter.h
+LIB_H += ../../include/linux/rbtree.h
+LIB_H += ../../include/linux/list.h
+LIB_H += util/include/linux/list.h
 LIB_H += perf.h
 LIB_H += util/types.h
-LIB_H += util/list.h
-LIB_H += util/rbtree.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
@@ -305,6 +306,7 @@ LIB_H += util/strlist.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
+LIB_H += util/module.h
 LIB_H += util/color.h
 
 LIB_OBJS += util/abspath.o
@@ -328,6 +330,7 @@ LIB_OBJS += util/usage.o
 LIB_OBJS += util/wrapper.o
 LIB_OBJS += util/sigchain.o
 LIB_OBJS += util/symbol.o
+LIB_OBJS += util/module.o
 LIB_OBJS += util/color.o
 LIB_OBJS += util/pager.o
 LIB_OBJS += util/header.o
@@ -381,12 +384,6 @@ ifndef CC_LD_DYNPATH
 	endif
 endif
 
-ifdef ZLIB_PATH
-	BASIC_CFLAGS += -I$(ZLIB_PATH)/include
-	EXTLIBS += -L$(ZLIB_PATH)/$(lib) $(CC_LD_DYNPATH)$(ZLIB_PATH)/$(lib)
-endif
-EXTLIBS += -lz
-
 ifdef NEEDS_SOCKET
 	EXTLIBS += -lsocket
 endif
@@ -697,6 +694,9 @@ builtin-init-db.o: builtin-init-db.c PERF-CFLAGS
 util/config.o: util/config.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+util/rbtree.o: ../../lib/rbtree.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o util/rbtree.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
 perf-%$X: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 722c0f5..5f9eefe 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -10,9 +10,9 @@
 #include "util/util.h"
 
 #include "util/color.h"
-#include "util/list.h"
+#include <linux/list.h>
 #include "util/cache.h"
-#include "util/rbtree.h"
+#include <linux/rbtree.h>
 #include "util/symbol.h"
 #include "util/string.h"
 
@@ -25,10 +25,6 @@
 #define SHOW_USER	2
 #define SHOW_HV		4
 
-#define MIN_GREEN		0.5
-#define MIN_RED		5.0
-
-
 static char		const *input_name = "perf.data";
 static char		*vmlinux = "vmlinux";
 
@@ -43,6 +39,10 @@ static int		dump_trace = 0;
 
 static int		verbose;
 
+static int		modules;
+
+static int		full_paths;
+
 static int		print_line;
 
 static unsigned long	page_size;
@@ -160,7 +160,7 @@ static void dsos__fprintf(FILE *fp)
 
 static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
 {
-	return dso__find_symbol(kernel_dso, ip);
+	return dso__find_symbol(dso, ip);
 }
 
 static int load_kernel(void)
@@ -171,8 +171,8 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
-	if (err) {
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
+	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
 	} else
@@ -203,7 +203,7 @@ static u64 map__map_ip(struct map *map, u64 ip)
 	return ip - map->start + map->pgoff;
 }
 
-static u64 vdso__map_ip(struct map *map, u64 ip)
+static u64 vdso__map_ip(struct map *map __used, u64 ip)
 {
 	return ip;
 }
@@ -600,7 +600,7 @@ static LIST_HEAD(hist_entry__sort_list);
 
 static int sort_dimension__add(char *tok)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
 		struct sort_dimension *sd = &sort_dimensions[i];
@@ -1043,24 +1043,6 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static char *get_color(double percent)
-{
-	char *color = PERF_COLOR_NORMAL;
-
-	/*
-	 * We color high-overhead entries in red, mid-overhead
-	 * entries in green - and keep the low overhead places
-	 * normal:
-	 */
-	if (percent >= MIN_RED)
-		color = PERF_COLOR_RED;
-	else {
-		if (percent > MIN_GREEN)
-			color = PERF_COLOR_GREEN;
-	}
-	return color;
-}
-
 static int
 parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 {
@@ -1069,7 +1051,7 @@ parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 	static const char *prev_color;
 	unsigned int offset;
 	size_t line_len;
-	u64 line_ip;
+	s64 line_ip;
 	int ret;
 	char *c;
 
@@ -1122,7 +1104,7 @@ parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 		} else if (sym->hist_sum)
 			percent = 100.0 * hits / sym->hist_sum;
 
-		color = get_color(percent);
+		color = get_percent_color(percent);
 
 		/*
 		 * Also color the filename and line if needed, with
@@ -1258,7 +1240,7 @@ static void print_summary(char *filename)
 
 		sym_ext = rb_entry(node, struct sym_ext, node);
 		percent = sym_ext->percent;
-		color = get_color(percent);
+		color = get_percent_color(percent);
 		path = sym_ext->path;
 
 		color_fprintf(stdout, color, " %7.2f %s", percent, path);
@@ -1268,19 +1250,25 @@ static void print_summary(char *filename)
 
 static void annotate_sym(struct dso *dso, struct symbol *sym)
 {
-	char *filename = dso->name;
+	char *filename = dso->name, *d_filename;
 	u64 start, end, len;
 	char command[PATH_MAX*2];
 	FILE *file;
 
 	if (!filename)
 		return;
-	if (dso == kernel_dso)
+	if (sym->module)
+		filename = sym->module->path;
+	else if (dso == kernel_dso)
 		filename = vmlinux;
 
 	start = sym->obj_start;
 	if (!start)
 		start = sym->start;
+	if (full_paths)
+		d_filename = filename;
+	else
+		d_filename = basename(filename);
 
 	end = start + sym->end - sym->start + 1;
 	len = sym->end - sym->start;
@@ -1291,13 +1279,14 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	}
 
 	printf("\n\n------------------------------------------------\n");
-	printf(" Percent |	Source code & Disassembly of %s\n", filename);
+	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
 	printf("------------------------------------------------\n");
 
 	if (verbose >= 2)
 		printf("annotating [%p] %30s : [%p] %30s\n", dso, dso->name, sym, sym->name);
 
-	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (u64)start, (u64)end, filename);
+	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s",
+			(u64)start, (u64)end, filename, filename);
 
 	if (verbose >= 3)
 		printf("doing: %s\n", command);
@@ -1428,7 +1417,7 @@ more:
 
 	head += size;
 
-	if (offset + head < stat.st_size)
+	if (offset + head < (unsigned long)stat.st_size)
 		goto more;
 
 	rc = EXIT_SUCCESS;
@@ -1472,8 +1461,12 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('m', "modules", &modules,
+		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('l', "print-line", &print_line,
 		    "print matching source lines (may be slow)"),
+	OPT_BOOLEAN('P', "full-paths", &full_paths,
+		    "Don't shorten the displayed pathnames"),
 	OPT_END()
 };
 
@@ -1492,7 +1485,7 @@ static void setup_sorting(void)
 	free(str);
 }
 
-int cmd_annotate(int argc, const char **argv, const char *prefix)
+int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
 	symbol__init();
 
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 0f32dc3..2599d86 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -3,6 +3,7 @@
  *
  * Builtin help command
  */
+#include "perf.h"
 #include "util/cache.h"
 #include "builtin.h"
 #include "util/exec_cmd.h"
@@ -277,7 +278,7 @@ static struct cmdnames main_cmds, other_cmds;
 
 void list_common_cmds_help(void)
 {
-	int i, longest = 0;
+	unsigned int i, longest = 0;
 
 	for (i = 0; i < ARRAY_SIZE(common_cmds); i++) {
 		if (longest < strlen(common_cmds[i].name))
@@ -415,9 +416,10 @@ static void show_html_page(const char *perf_cmd)
 	open_html(page_path.buf);
 }
 
-int cmd_help(int argc, const char **argv, const char *prefix)
+int cmd_help(int argc, const char **argv, const char *prefix __used)
 {
 	const char *alias;
+
 	load_command_list("perf-", &main_cmds, &other_cmds);
 
 	perf_config(perf_help_config, NULL);
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index fe60e37..f990fa8 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -13,7 +13,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
-int cmd_list(int argc, const char **argv, const char *prefix)
+int cmd_list(int argc __used, const char **argv __used, const char *prefix __used)
 {
 	print_events();
 	return 0;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d18546f..4ef78a5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -294,7 +294,7 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 	while (1) {
 		char bf[BUFSIZ], *pbf = bf;
 		struct mmap_event mmap_ev = {
-			.header.type = PERF_EVENT_MMAP,
+			.header = { .type = PERF_EVENT_MMAP },
 		};
 		int n;
 		size_t size;
@@ -650,7 +650,7 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-int cmd_record(int argc, const char **argv, const char *prefix)
+int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 135b783..4e5cc26 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -10,9 +10,9 @@
 #include "util/util.h"
 
 #include "util/color.h"
-#include "util/list.h"
+#include <linux/list.h>
 #include "util/cache.h"
-#include "util/rbtree.h"
+#include <linux/rbtree.h>
 #include "util/symbol.h"
 #include "util/string.h"
 #include "util/callchain.h"
@@ -46,6 +46,8 @@ static int		dump_trace = 0;
 static int		verbose;
 #define eprintf(x...)	do { if (verbose) fprintf(stderr, x); } while (0)
 
+static int		modules;
+
 static int		full_paths;
 
 static unsigned long	page_size;
@@ -56,8 +58,17 @@ static char		*parent_pattern = default_parent_pattern;
 static regex_t		parent_regex;
 
 static int		exclude_other = 1;
+
+static char		callchain_default_opt[] = "fractal,0.5";
+
 static int		callchain;
 
+static
+struct callchain_param	callchain_param = {
+	.mode	= CHAIN_GRAPH_ABS,
+	.min_percent = 0.5
+};
+
 static u64		sample_type;
 
 struct ip_event {
@@ -121,6 +132,7 @@ typedef union event_union {
 static LIST_HEAD(dsos);
 static struct dso *kernel_dso;
 static struct dso *vdso;
+static struct dso *hypervisor_dso;
 
 static void dsos__add(struct dso *dso)
 {
@@ -176,7 +188,7 @@ static void dsos__fprintf(FILE *fp)
 
 static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
 {
-	return dso__find_symbol(kernel_dso, ip);
+	return dso__find_symbol(dso, ip);
 }
 
 static int load_kernel(void)
@@ -187,8 +199,8 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose);
-	if (err) {
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
+	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
 	} else
@@ -202,6 +214,11 @@ static int load_kernel(void)
 
 	dsos__add(vdso);
 
+	hypervisor_dso = dso__new("[hypervisor]", 0);
+	if (!hypervisor_dso)
+		return -1;
+	dsos__add(hypervisor_dso);
+
 	return err;
 }
 
@@ -233,7 +250,7 @@ static u64 map__map_ip(struct map *map, u64 ip)
 	return ip - map->start + map->pgoff;
 }
 
-static u64 vdso__map_ip(struct map *map, u64 ip)
+static u64 vdso__map_ip(struct map *map __used, u64 ip)
 {
 	return ip;
 }
@@ -640,7 +657,11 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 
 	if (self->sym) {
 		ret += fprintf(fp, "[%c] %s",
-			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
+			self->dso == kernel_dso ? 'k' :
+			self->dso == hypervisor_dso ? 'h' : '.', self->sym->name);
+
+		if (self->sym->module)
+			ret += fprintf(fp, "\t[%s]", self->sym->module->name);
 	} else {
 		ret += fprintf(fp, "%#016llx", (u64)self->ip);
 	}
@@ -705,7 +726,7 @@ static LIST_HEAD(hist_entry__sort_list);
 
 static int sort_dimension__add(char *tok)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
 		struct sort_dimension *sd = &sort_dimensions[i];
@@ -775,8 +796,109 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 	return cmp;
 }
 
+static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask)
+{
+	int i;
+	size_t ret = 0;
+
+	ret += fprintf(fp, "%s", "                ");
+
+	for (i = 0; i < depth; i++)
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|          ");
+		else
+			ret += fprintf(fp, "           ");
+
+	ret += fprintf(fp, "\n");
+
+	return ret;
+}
+static size_t
+ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
+		       int depth_mask, int count, u64 total_samples,
+		       int hits)
+{
+	int i;
+	size_t ret = 0;
+
+	ret += fprintf(fp, "%s", "                ");
+	for (i = 0; i < depth; i++) {
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|");
+		else
+			ret += fprintf(fp, " ");
+		if (!count && i == depth - 1) {
+			double percent;
+
+			percent = hits * 100.0 / total_samples;
+			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
+		} else
+			ret += fprintf(fp, "%s", "          ");
+	}
+	if (chain->sym)
+		ret += fprintf(fp, "%s\n", chain->sym->name);
+	else
+		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
+
+	return ret;
+}
+
+static size_t
+callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+			u64 total_samples, int depth, int depth_mask)
+{
+	struct rb_node *node, *next;
+	struct callchain_node *child;
+	struct callchain_list *chain;
+	int new_depth_mask = depth_mask;
+	u64 new_total;
+	size_t ret = 0;
+	int i;
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL)
+		new_total = self->cumul_hit;
+	else
+		new_total = total_samples;
+
+	node = rb_first(&self->rb_root);
+	while (node) {
+		child = rb_entry(node, struct callchain_node, rb_node);
+
+		/*
+		 * The depth mask manages the output of pipes that show
+		 * the depth. We don't want to keep the pipes of the current
+		 * level for the last child of this depth
+		 */
+		next = rb_next(node);
+		if (!next)
+			new_depth_mask &= ~(1 << (depth - 1));
+
+		/*
+		 * But we keep the older depth mask for the line seperator
+		 * to keep the level link until we reach the last child
+		 */
+		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask);
+		i = 0;
+		list_for_each_entry(chain, &child->val, list) {
+			if (chain->ip >= PERF_CONTEXT_MAX)
+				continue;
+			ret += ipchain__fprintf_graph(fp, chain, depth,
+						      new_depth_mask, i++,
+						      new_total,
+						      child->cumul_hit);
+		}
+		ret += callchain__fprintf_graph(fp, child, new_total,
+						depth + 1,
+						new_depth_mask | (1 << depth));
+		node = next;
+	}
+
+	return ret;
+}
+
 static size_t
-callchain__fprintf(FILE *fp, struct callchain_node *self, u64 total_samples)
+callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
+			u64 total_samples)
 {
 	struct callchain_list *chain;
 	size_t ret = 0;
@@ -784,11 +906,18 @@ callchain__fprintf(FILE *fp, struct callchain_node *self, u64 total_samples)
 	if (!self)
 		return 0;
 
-	ret += callchain__fprintf(fp, self->parent, total_samples);
+	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
 
 
-	list_for_each_entry(chain, &self->val, list)
-		ret += fprintf(fp, "                %p\n", (void *)chain->ip);
+	list_for_each_entry(chain, &self->val, list) {
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+		if (chain->sym)
+			ret += fprintf(fp, "                %s\n", chain->sym->name);
+		else
+			ret += fprintf(fp, "                %p\n",
+					(void *)(long)chain->ip);
+	}
 
 	return ret;
 }
@@ -807,8 +936,19 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 
 		chain = rb_entry(rb_node, struct callchain_node, rb_node);
 		percent = chain->hit * 100.0 / total_samples;
-		ret += fprintf(fp, "           %6.2f%%\n", percent);
-		ret += callchain__fprintf(fp, chain, total_samples);
+		switch (callchain_param.mode) {
+		case CHAIN_FLAT:
+			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
+						     percent);
+			ret += callchain__fprintf_flat(fp, chain, total_samples);
+			break;
+		case CHAIN_GRAPH_ABS: /* Falldown */
+		case CHAIN_GRAPH_REL:
+			ret += callchain__fprintf_graph(fp, chain,
+							total_samples, 1, 1);
+		default:
+			break;
+		}
 		ret += fprintf(fp, "\n");
 		rb_node = rb_next(rb_node);
 	}
@@ -826,25 +966,10 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 	if (exclude_other && !self->parent)
 		return 0;
 
-	if (total_samples) {
-		double percent = self->count * 100.0 / total_samples;
-		char *color = PERF_COLOR_NORMAL;
-
-		/*
-		 * We color high-overhead entries in red, mid-overhead
-		 * entries in green - and keep the low overhead places
-		 * normal:
-		 */
-		if (percent >= 5.0) {
-			color = PERF_COLOR_RED;
-		} else {
-			if (percent >= 0.5)
-				color = PERF_COLOR_GREEN;
-		}
-
-		ret = color_fprintf(fp, color, "   %6.2f%%",
+	if (total_samples)
+		ret = percent_color_fprintf(fp, "   %6.2f%%",
 				(self->count * 100.0) / total_samples);
-	} else
+	else
 		ret = fprintf(fp, "%12Ld ", self->count);
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
@@ -923,6 +1048,58 @@ static int call__match(struct symbol *sym)
 	return 0;
 }
 
+static struct symbol **
+resolve_callchain(struct thread *thread, struct map *map __used,
+		    struct ip_callchain *chain, struct hist_entry *entry)
+{
+	u64 context = PERF_CONTEXT_MAX;
+	struct symbol **syms = NULL;
+	unsigned int i;
+
+	if (callchain) {
+		syms = calloc(chain->nr, sizeof(*syms));
+		if (!syms) {
+			fprintf(stderr, "Can't allocate memory for symbols\n");
+			exit(-1);
+		}
+	}
+
+	for (i = 0; i < chain->nr; i++) {
+		u64 ip = chain->ips[i];
+		struct dso *dso = NULL;
+		struct symbol *sym;
+
+		if (ip >= PERF_CONTEXT_MAX) {
+			context = ip;
+			continue;
+		}
+
+		switch (context) {
+		case PERF_CONTEXT_HV:
+			dso = hypervisor_dso;
+			break;
+		case PERF_CONTEXT_KERNEL:
+			dso = kernel_dso;
+			break;
+		default:
+			break;
+		}
+
+		sym = resolve_symbol(thread, NULL, &dso, &ip);
+
+		if (sym) {
+			if (sort__has_parent && call__match(sym) &&
+			    !entry->parent)
+				entry->parent = sym;
+			if (!callchain)
+				break;
+			syms[i] = sym;
+		}
+	}
+
+	return syms;
+}
+
 /*
  * collect histogram counts
  */
@@ -935,6 +1112,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
+	struct symbol **syms = NULL;
 	struct hist_entry entry = {
 		.thread	= thread,
 		.map	= map,
@@ -948,36 +1126,8 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	};
 	int cmp;
 
-	if (sort__has_parent && chain) {
-		u64 context = PERF_CONTEXT_MAX;
-		int i;
-
-		for (i = 0; i < chain->nr; i++) {
-			u64 ip = chain->ips[i];
-			struct dso *dso = NULL;
-			struct symbol *sym;
-
-			if (ip >= PERF_CONTEXT_MAX) {
-				context = ip;
-				continue;
-			}
-
-			switch (context) {
-			case PERF_CONTEXT_KERNEL:
-				dso = kernel_dso;
-				break;
-			default:
-				break;
-			}
-
-			sym = resolve_symbol(thread, NULL, &dso, &ip);
-
-			if (sym && call__match(sym)) {
-				entry.parent = sym;
-				break;
-			}
-		}
-	}
+	if ((sort__has_parent || callchain) && chain)
+		syms = resolve_callchain(thread, map, chain, &entry);
 
 	while (*p != NULL) {
 		parent = *p;
@@ -987,8 +1137,10 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 
 		if (!cmp) {
 			he->count += count;
-			if (callchain)
-				append_chain(&he->callchain, chain);
+			if (callchain) {
+				append_chain(&he->callchain, chain, syms);
+				free(syms);
+			}
 			return 0;
 		}
 
@@ -1004,7 +1156,8 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	*he = entry;
 	if (callchain) {
 		callchain_init(&he->callchain);
-		append_chain(&he->callchain, chain);
+		append_chain(&he->callchain, chain, syms);
+		free(syms);
 	}
 	rb_link_node(&he->rb_node, parent, p);
 	rb_insert_color(&he->rb_node, &hist);
@@ -1076,14 +1229,15 @@ static void collapse__resort(void)
 
 static struct rb_root output_hists;
 
-static void output__insert_entry(struct hist_entry *he)
+static void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
 {
 	struct rb_node **p = &output_hists.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
 	if (callchain)
-		sort_chain_to_rbtree(&he->sorted_chain, &he->callchain);
+		callchain_param.sort(&he->sorted_chain, &he->callchain,
+				      min_callchain_hits, &callchain_param);
 
 	while (*p != NULL) {
 		parent = *p;
@@ -1099,11 +1253,14 @@ static void output__insert_entry(struct hist_entry *he)
 	rb_insert_color(&he->rb_node, &output_hists);
 }
 
-static void output__resort(void)
+static void output__resort(u64 total_samples)
 {
 	struct rb_node *next;
 	struct hist_entry *n;
 	struct rb_root *tree = &hist;
+	u64 min_callchain_hits;
+
+	min_callchain_hits = total_samples * (callchain_param.min_percent / 100);
 
 	if (sort__need_collapse)
 		tree = &collapse_hists;
@@ -1115,7 +1272,7 @@ static void output__resort(void)
 		next = rb_next(&n->rb_node);
 
 		rb_erase(&n->rb_node, tree);
-		output__insert_entry(n);
+		output__insert_entry(n, min_callchain_hits);
 	}
 }
 
@@ -1141,7 +1298,7 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 
 	fprintf(fp, "# ........");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int i;
+		unsigned int i;
 
 		if (exclude_other && (se == &sort_parent))
 			continue;
@@ -1213,6 +1370,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
 	struct ip_callchain *chain = NULL;
+	int cpumode;
 
 	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
@@ -1228,7 +1386,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		(long long)period);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		int i;
+		unsigned int i;
 
 		chain = (void *)more_data;
 
@@ -1256,7 +1414,9 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	if (comm_list && !strlist__has_entry(comm_list, thread->comm))
 		return 0;
 
-	if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
+	cpumode = event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_EVENT_MISC_KERNEL) {
 		show = SHOW_KERNEL;
 		level = 'k';
 
@@ -1264,7 +1424,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		dprintf(" ...... dso: %s\n", dso->name);
 
-	} else if (event->header.misc & PERF_EVENT_MISC_USER) {
+	} else if (cpumode == PERF_EVENT_MISC_USER) {
 
 		show = SHOW_USER;
 		level = '.';
@@ -1272,6 +1432,9 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	} else {
 		show = SHOW_HV;
 		level = 'H';
+
+		dso = hypervisor_dso;
+
 		dprintf(" ...... dso: [hypervisor]\n");
 	}
 
@@ -1534,9 +1697,19 @@ static int __cmd_report(void)
 
 	sample_type = perf_header__sample_type();
 
-	if (sort__has_parent && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
-		fprintf(stderr, "selected --sort parent, but no callchain data\n");
-		exit(-1);
+	if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+		if (sort__has_parent) {
+			fprintf(stderr, "selected --sort parent, but no"
+					" callchain data. Did you call"
+					" perf record without -g?\n");
+			exit(-1);
+		}
+		if (callchain) {
+			fprintf(stderr, "selected -c but no callchain data."
+					" Did you call perf record without"
+					" -g?\n");
+			exit(-1);
+		}
 	}
 
 	if (load_kernel() < 0) {
@@ -1619,7 +1792,7 @@ more:
 	if (offset + head >= header->data_offset + header->data_size)
 		goto done;
 
-	if (offset + head < stat.st_size)
+	if (offset + head < (unsigned long)stat.st_size)
 		goto more;
 
 done:
@@ -1643,12 +1816,58 @@ done:
 		dsos__fprintf(stdout);
 
 	collapse__resort();
-	output__resort();
+	output__resort(total);
 	output__fprintf(stdout, total);
 
 	return rc;
 }
 
+static int
+parse_callchain_opt(const struct option *opt __used, const char *arg,
+		    int unset __used)
+{
+	char *tok;
+	char *endptr;
+
+	callchain = 1;
+
+	if (!arg)
+		return 0;
+
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "graph", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_ABS;
+
+	else if (!strncmp(tok, "flat", strlen(arg)))
+		callchain_param.mode = CHAIN_FLAT;
+
+	else if (!strncmp(tok, "fractal", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_REL;
+
+	else
+		return -1;
+
+	/* get the min percentage */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		goto setup;
+
+	callchain_param.min_percent = strtod(tok, &endptr);
+	if (tok == endptr)
+		return -1;
+
+setup:
+	if (register_callchain_param(&callchain_param) < 0) {
+		fprintf(stderr, "Can't register callchain params\n");
+		return -1;
+	}
+	return 0;
+}
+
 static const char * const report_usage[] = {
 	"perf report [<options>] <command>",
 	NULL
@@ -1662,6 +1881,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('m', "modules", &modules,
+		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
@@ -1670,7 +1891,9 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_BOOLEAN('c', "callchain", &callchain, "Display callchains"),
+	OPT_CALLBACK_DEFAULT('c', "callchain", NULL, "output_type,min_percent",
+		     "Display callchains using output_type and min percent threshold. "
+		     "Default: flat,0", &parse_callchain_opt, callchain_default_opt),
 	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
@@ -1708,7 +1931,7 @@ static void setup_list(struct strlist **list, const char *list_str,
 	}
 }
 
-int cmd_report(int argc, const char **argv, const char *prefix)
+int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	symbol__init();
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2e03524..27921a8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -64,7 +64,7 @@ static struct perf_counter_attr default_attrs[] = {
 
 static int			system_wide			=  0;
 static int			verbose				=  0;
-static int			nr_cpus				=  0;
+static unsigned int		nr_cpus				=  0;
 static int			run_idx				=  0;
 
 static int			run_count			=  1;
@@ -96,6 +96,10 @@ static u64			walltime_nsecs_noise;
 static u64			runtime_cycles_avg;
 static u64			runtime_cycles_noise;
 
+#define MATCH_EVENT(t, c, counter)			\
+	(attrs[counter].type == PERF_TYPE_##t &&	\
+	 attrs[counter].config == PERF_COUNT_##c)
+
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
 
@@ -108,7 +112,8 @@ static void create_perf_stat_counter(int counter, int pid)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide) {
-		int cpu;
+		unsigned int cpu;
+
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
 			if (fd[cpu][counter] < 0 && verbose)
@@ -132,13 +137,8 @@ static void create_perf_stat_counter(int counter, int pid)
  */
 static inline int nsec_counter(int counter)
 {
-	if (attrs[counter].type != PERF_TYPE_SOFTWARE)
-		return 0;
-
-	if (attrs[counter].config == PERF_COUNT_SW_CPU_CLOCK)
-		return 1;
-
-	if (attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+	if (MATCH_EVENT(SOFTWARE, SW_CPU_CLOCK, counter) ||
+	    MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
 		return 1;
 
 	return 0;
@@ -150,8 +150,8 @@ static inline int nsec_counter(int counter)
 static void read_counter(int counter)
 {
 	u64 *count, single_count[3];
-	ssize_t res;
-	int cpu, nv;
+	unsigned int cpu;
+	size_t res, nv;
 	int scaled;
 
 	count = event_res[run_idx][counter];
@@ -165,6 +165,7 @@ static void read_counter(int counter)
 
 		res = read(fd[cpu][counter], single_count, nv * sizeof(u64));
 		assert(res == nv * sizeof(u64));
+
 		close(fd[cpu][counter]);
 		fd[cpu][counter] = -1;
 
@@ -192,15 +193,13 @@ static void read_counter(int counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
 		runtime_nsecs[run_idx] = count[0];
-	if (attrs[counter].type == PERF_TYPE_HARDWARE &&
-		attrs[counter].config == PERF_COUNT_HW_CPU_CYCLES)
+	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
 		runtime_cycles[run_idx] = count[0];
 }
 
-static int run_perf_stat(int argc, const char **argv)
+static int run_perf_stat(int argc __used, const char **argv)
 {
 	unsigned long long t0, t1;
 	int status = 0;
@@ -240,7 +239,8 @@ static int run_perf_stat(int argc, const char **argv)
 		/*
 		 * Wait until the parent tells us to go.
 		 */
-		read(go_pipe[0], &buf, 1);
+		if (read(go_pipe[0], &buf, 1) == -1)
+			perror("unable to read pipe");
 
 		execvp(argv[0], (char **)argv);
 
@@ -253,7 +253,8 @@ static int run_perf_stat(int argc, const char **argv)
 	 */
 	close(child_ready_pipe[1]);
 	close(go_pipe[0]);
-	read(child_ready_pipe[0], &buf, 1);
+	if (read(child_ready_pipe[0], &buf, 1) == -1)
+		perror("unable to read pipe");
 	close(child_ready_pipe[0]);
 
 	for (counter = 0; counter < nr_counters; counter++)
@@ -290,9 +291,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
-
+	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		if (walltime_nsecs_avg)
 			fprintf(stderr, " # %10.3f CPUs ",
 				(double)count[0] / (double)walltime_nsecs_avg);
@@ -305,9 +304,7 @@ static void abs_printout(int counter, u64 *count, u64 *noise)
 	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
-		attrs[counter].type == PERF_TYPE_HARDWARE &&
-			attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
-
+	    MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		fprintf(stderr, " # %10.3f IPC  ",
 			(double)count[0] / (double)runtime_cycles_avg);
 	} else {
@@ -390,7 +387,7 @@ static void calc_avg(void)
 				event_res_avg[j]+1, event_res[i][j]+1);
 			update_avg("counter/2", j,
 				event_res_avg[j]+2, event_res[i][j]+2);
-			if (event_scaled[i][j] != -1)
+			if (event_scaled[i][j] != (u64)-1)
 				update_avg("scaled", j,
 					event_scaled_avg + j, event_scaled[i]+j);
 			else
@@ -510,7 +507,7 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-int cmd_stat(int argc, const char **argv, const char *prefix)
+int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
 	int status;
 
@@ -528,7 +525,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
-	assert(nr_cpus >= 0);
+	assert((int)nr_cpus >= 0);
 
 	/*
 	 * We dont want to block the signals - that would cause
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index cf0d21f..95d5c0a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -23,7 +23,7 @@
 #include "util/symbol.h"
 #include "util/color.h"
 #include "util/util.h"
-#include "util/rbtree.h"
+#include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
@@ -66,6 +66,7 @@ static unsigned int		page_size;
 static unsigned int		mmap_pages			= 16;
 static int			freq				=  0;
 static int			verbose				=  0;
+static char			*vmlinux			=  NULL;
 
 static char			*sym_filter;
 static unsigned long		filter_start;
@@ -238,7 +239,6 @@ static void print_sym_table(void)
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
 		struct symbol *sym = (struct symbol *)(syme + 1);
-		char *color = PERF_COLOR_NORMAL;
 		double pcnt;
 
 		if (++printed > print_entries || syme->snap_count < count_filter)
@@ -247,29 +247,20 @@ static void print_sym_table(void)
 		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
 					 sum_ksamples));
 
-		/*
-		 * We color high-overhead entries in red, mid-overhead
-		 * entries in green - and keep the low overhead places
-		 * normal:
-		 */
-		if (pcnt >= 5.0) {
-			color = PERF_COLOR_RED;
-		} else {
-			if (pcnt >= 0.5)
-				color = PERF_COLOR_GREEN;
-		}
-
 		if (nr_counters == 1)
 			printf("%20.2f - ", syme->weight);
 		else
 			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
 
-		color_fprintf(stdout, color, "%4.1f%%", pcnt);
-		printf(" - %016llx : %s\n", sym->start, sym->name);
+		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
+		printf(" - %016llx : %s", sym->start, sym->name);
+		if (sym->module)
+			printf("\t[%s]", sym->module->name);
+		printf("\n");
 	}
 }
 
-static void *display_thread(void *arg)
+static void *display_thread(void *arg __used)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 	int delay_msecs = delay_secs * 1000;
@@ -286,11 +277,31 @@ static void *display_thread(void *arg)
 	return NULL;
 }
 
+/* Tag samples to be skipped. */
+static const char *skip_symbols[] = {
+	"default_idle",
+	"cpu_idle",
+	"enter_idle",
+	"exit_idle",
+	"mwait_idle",
+	"ppc64_runlatch_off",
+	"pseries_dedicated_idle_sleep",
+	NULL
+};
+
 static int symbol_filter(struct dso *self, struct symbol *sym)
 {
 	static int filter_match;
 	struct sym_entry *syme;
 	const char *name = sym->name;
+	int i;
+
+	/*
+	 * ppc64 uses function descriptors and appends a '.' to the
+	 * start of every instruction address. Remove it.
+	 */
+	if (name[0] == '.')
+		name++;
 
 	if (!strcmp(name, "_text") ||
 	    !strcmp(name, "_etext") ||
@@ -302,13 +313,12 @@ static int symbol_filter(struct dso *self, struct symbol *sym)
 		return 1;
 
 	syme = dso__sym_priv(self, sym);
-	/* Tag samples to be skipped. */
-	if (!strcmp("default_idle", name) ||
-	    !strcmp("cpu_idle", name) ||
-	    !strcmp("enter_idle", name) ||
-	    !strcmp("exit_idle", name) ||
-	    !strcmp("mwait_idle", name))
-		syme->skip = 1;
+	for (i = 0; skip_symbols[i]; i++) {
+		if (!strcmp(skip_symbols[i], name)) {
+			syme->skip = 1;
+			break;
+		}
+	}
 
 	if (filter_match == 1) {
 		filter_end = sym->start;
@@ -340,12 +350,13 @@ static int parse_symbols(void)
 {
 	struct rb_node *node;
 	struct symbol  *sym;
+	int modules = vmlinux ? 1 : 0;
 
 	kernel_dso = dso__new("[kernel]", sizeof(struct sym_entry));
 	if (kernel_dso == NULL)
 		return -1;
 
-	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1) != 0)
+	if (dso__load_kernel(kernel_dso, vmlinux, symbol_filter, verbose, modules) <= 0)
 		goto out_delete_dso;
 
 	node = rb_first(&kernel_dso->syms);
@@ -407,7 +418,7 @@ static void process_event(u64 ip, int counter, int user)
 struct mmap_data {
 	int			counter;
 	void			*base;
-	unsigned int		mask;
+	int			mask;
 	unsigned int		prev;
 };
 
@@ -661,6 +672,7 @@ static const struct option options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_INTEGER('C', "CPU", &profile_cpu,
 		    "CPU to profile on"),
+	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
@@ -675,7 +687,7 @@ static const struct option options[] = {
 			    "put the counters into a counter group"),
 	OPT_STRING('s', "sym-filter", &sym_filter, "pattern",
 		    "only display symbols matchig this pattern"),
-	OPT_BOOLEAN('z', "zero", &group,
+	OPT_BOOLEAN('z', "zero", &zero,
 		    "zero history across updates"),
 	OPT_INTEGER('F', "freq", &freq,
 		    "profile at this frequency"),
@@ -686,10 +698,12 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-int cmd_top(int argc, const char **argv, const char *prefix)
+int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
+	symbol__init();
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	argc = parse_options(argc, argv, options, top_usage, 0);
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 4eb7259..c565678 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -229,9 +229,6 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 		use_pager = 1;
 	commit_pager_choice();
 
-	if (p->option & NEED_WORK_TREE)
-		/* setup_work_tree() */;
-
 	status = p->fn(argc, argv, prefix);
 	if (status)
 		return status & 0xff;
@@ -266,7 +263,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
 	};
-	int i;
+	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
 
 	if (sizeof(ext) > 1) {
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ce39419..27887c9 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -52,6 +52,8 @@ static inline unsigned long long rdclock(void)
 #define __user
 #define asmlinkage
 
+#define __used		__attribute__((__unused__))
+
 #define unlikely(x)	__builtin_expect(!!(x), 0)
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index 9b3dd2b..b8144e8 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -3,7 +3,7 @@
 static const char *alias_key;
 static char *alias_val;
 
-static int alias_lookup_cb(const char *k, const char *v, void *cb)
+static int alias_lookup_cb(const char *k, const char *v, void *cb __used)
 {
 	if (!prefixcmp(k, "alias.") && !strcmp(k+6, alias_key)) {
 		if (!v)
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 393d614..161d5f4 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -3,6 +3,7 @@
 
 #include "util.h"
 #include "strbuf.h"
+#include "../perf.h"
 
 #define PERF_DIR_ENVIRONMENT "PERF_DIR"
 #define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index ad3c285..9d3c814 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -4,6 +4,9 @@
  * Handle the callchains from the stream in an ad-hoc radix tree and then
  * sort them in an rbtree.
  *
+ * Using a radix for code path provides a fast retrieval and factorizes
+ * memory use. Also that lets us use the paths in a hierarchical graph view.
+ *
  */
 
 #include <stdlib.h>
@@ -13,8 +16,12 @@
 
 #include "callchain.h"
 
+#define chain_for_each_child(child, parent)	\
+	list_for_each_entry(child, &parent->children, brothers)
 
-static void rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
+static void
+rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
+		    enum chain_mode mode)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -24,32 +31,125 @@ static void rb_insert_callchain(struct rb_root *root, struct callchain_node *cha
 		parent = *p;
 		rnode = rb_entry(parent, struct callchain_node, rb_node);
 
-		if (rnode->hit < chain->hit)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
+		switch (mode) {
+		case CHAIN_FLAT:
+			if (rnode->hit < chain->hit)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+			break;
+		case CHAIN_GRAPH_ABS: /* Falldown */
+		case CHAIN_GRAPH_REL:
+			if (rnode->cumul_hit < chain->cumul_hit)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+			break;
+		default:
+			break;
+		}
 	}
 
 	rb_link_node(&chain->rb_node, parent, p);
 	rb_insert_color(&chain->rb_node, root);
 }
 
+static void
+__sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
+		  u64 min_hit)
+{
+	struct callchain_node *child;
+
+	chain_for_each_child(child, node)
+		__sort_chain_flat(rb_root, child, min_hit);
+
+	if (node->hit && node->hit >= min_hit)
+		rb_insert_callchain(rb_root, node, CHAIN_FLAT);
+}
+
 /*
  * Once we get every callchains from the stream, we can now
  * sort them by hit
  */
-void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node)
+static void
+sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
+		u64 min_hit, struct callchain_param *param __used)
+{
+	__sort_chain_flat(rb_root, node, min_hit);
+}
+
+static void __sort_chain_graph_abs(struct callchain_node *node,
+				   u64 min_hit)
+{
+	struct callchain_node *child;
+
+	node->rb_root = RB_ROOT;
+
+	chain_for_each_child(child, node) {
+		__sort_chain_graph_abs(child, min_hit);
+		if (child->cumul_hit >= min_hit)
+			rb_insert_callchain(&node->rb_root, child,
+					    CHAIN_GRAPH_ABS);
+	}
+}
+
+static void
+sort_chain_graph_abs(struct rb_root *rb_root, struct callchain_node *chain_root,
+		     u64 min_hit, struct callchain_param *param __used)
+{
+	__sort_chain_graph_abs(chain_root, min_hit);
+	rb_root->rb_node = chain_root->rb_root.rb_node;
+}
+
+static void __sort_chain_graph_rel(struct callchain_node *node,
+				   double min_percent)
 {
 	struct callchain_node *child;
+	u64 min_hit;
 
-	list_for_each_entry(child, &node->children, brothers)
-		sort_chain_to_rbtree(rb_root, child);
+	node->rb_root = RB_ROOT;
+	min_hit = node->cumul_hit * min_percent / 100.0;
 
-	if (node->hit)
-		rb_insert_callchain(rb_root, node);
+	chain_for_each_child(child, node) {
+		__sort_chain_graph_rel(child, min_percent);
+		if (child->cumul_hit >= min_hit)
+			rb_insert_callchain(&node->rb_root, child,
+					    CHAIN_GRAPH_REL);
+	}
 }
 
-static struct callchain_node *create_child(struct callchain_node *parent)
+static void
+sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_node *chain_root,
+		     u64 min_hit __used, struct callchain_param *param)
+{
+	__sort_chain_graph_rel(chain_root, param->min_percent);
+	rb_root->rb_node = chain_root->rb_root.rb_node;
+}
+
+int register_callchain_param(struct callchain_param *param)
+{
+	switch (param->mode) {
+	case CHAIN_GRAPH_ABS:
+		param->sort = sort_chain_graph_abs;
+		break;
+	case CHAIN_GRAPH_REL:
+		param->sort = sort_chain_graph_rel;
+		break;
+	case CHAIN_FLAT:
+		param->sort = sort_chain_flat;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Create a child for a parent. If inherit_children, then the new child
+ * will become the new parent of it's parent children
+ */
+static struct callchain_node *
+create_child(struct callchain_node *parent, bool inherit_children)
 {
 	struct callchain_node *new;
 
@@ -61,91 +161,147 @@ static struct callchain_node *create_child(struct callchain_node *parent)
 	new->parent = parent;
 	INIT_LIST_HEAD(&new->children);
 	INIT_LIST_HEAD(&new->val);
+
+	if (inherit_children) {
+		struct callchain_node *next;
+
+		list_splice(&parent->children, &new->children);
+		INIT_LIST_HEAD(&parent->children);
+
+		chain_for_each_child(next, new)
+			next->parent = new;
+	}
 	list_add_tail(&new->brothers, &parent->children);
 
 	return new;
 }
 
+/*
+ * Fill the node with callchain values
+ */
 static void
-fill_node(struct callchain_node *node, struct ip_callchain *chain, int start)
+fill_node(struct callchain_node *node, struct ip_callchain *chain,
+	  int start, struct symbol **syms)
 {
-	int i;
+	unsigned int i;
 
 	for (i = start; i < chain->nr; i++) {
 		struct callchain_list *call;
 
-		call = malloc(sizeof(*chain));
+		call = malloc(sizeof(*call));
 		if (!call) {
 			perror("not enough memory for the code path tree");
 			return;
 		}
 		call->ip = chain->ips[i];
+		call->sym = syms[i];
 		list_add_tail(&call->list, &node->val);
 	}
-	node->val_nr = i - start;
+	node->val_nr = chain->nr - start;
+	if (!node->val_nr)
+		printf("Warning: empty node in callchain tree\n");
 }
 
-static void add_child(struct callchain_node *parent, struct ip_callchain *chain)
+static void
+add_child(struct callchain_node *parent, struct ip_callchain *chain,
+	  int start, struct symbol **syms)
 {
 	struct callchain_node *new;
 
-	new = create_child(parent);
-	fill_node(new, chain, parent->val_nr);
+	new = create_child(parent, false);
+	fill_node(new, chain, start, syms);
 
-	new->hit = 1;
+	new->cumul_hit = new->hit = 1;
 }
 
+/*
+ * Split the parent in two parts (a new child is created) and
+ * give a part of its callchain to the created child.
+ * Then create another child to host the given callchain of new branch
+ */
 static void
 split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
-		struct callchain_list *to_split, int idx)
+		struct callchain_list *to_split, int idx_parents, int idx_local,
+		struct symbol **syms)
 {
 	struct callchain_node *new;
+	struct list_head *old_tail;
+	unsigned int idx_total = idx_parents + idx_local;
 
 	/* split */
-	new = create_child(parent);
-	list_move_tail(&to_split->list, &new->val);
-	new->hit = parent->hit;
-	parent->hit = 0;
-	parent->val_nr = idx;
+	new = create_child(parent, true);
 
-	/* create the new one */
-	add_child(parent, chain);
+	/* split the callchain and move a part to the new child */
+	old_tail = parent->val.prev;
+	list_del_range(&to_split->list, old_tail);
+	new->val.next = &to_split->list;
+	new->val.prev = old_tail;
+	to_split->list.prev = &new->val;
+	old_tail->next = &new->val;
+
+	/* split the hits */
+	new->hit = parent->hit;
+	new->cumul_hit = parent->cumul_hit;
+	new->val_nr = parent->val_nr - idx_local;
+	parent->val_nr = idx_local;
+
+	/* create a new child for the new branch if any */
+	if (idx_total < chain->nr) {
+		parent->hit = 0;
+		add_child(parent, chain, idx_total, syms);
+	} else {
+		parent->hit = 1;
+	}
 }
 
 static int
 __append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		int start);
+	       unsigned int start, struct symbol **syms);
 
-static int
-__append_chain_children(struct callchain_node *root, struct ip_callchain *chain)
+static void
+__append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
+			struct symbol **syms, unsigned int start)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
-	list_for_each_entry(rnode, &root->children, brothers) {
-		int ret = __append_chain(rnode, chain, root->val_nr);
+	chain_for_each_child(rnode, root) {
+		unsigned int ret = __append_chain(rnode, chain, start, syms);
+
 		if (!ret)
-			return 0;
+			goto cumul;
 	}
-	return -1;
+	/* nothing in children, add to the current node */
+	add_child(root, chain, start, syms);
+
+cumul:
+	root->cumul_hit++;
 }
 
 static int
 __append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		int start)
+	       unsigned int start, struct symbol **syms)
 {
 	struct callchain_list *cnode;
-	int i = start;
+	unsigned int i = start;
 	bool found = false;
 
-	/* lookup in the current node */
+	/*
+	 * Lookup in the current node
+	 * If we have a symbol, then compare the start to match
+	 * anywhere inside a function.
+	 */
 	list_for_each_entry(cnode, &root->val, list) {
-		if (cnode->ip != chain->ips[i++])
+		if (i == chain->nr)
+			break;
+		if (cnode->sym && syms[i]) {
+			if (cnode->sym->start != syms[i]->start)
+				break;
+		} else if (cnode->ip != chain->ips[i])
 			break;
 		if (!found)
 			found = true;
-		if (i == chain->nr)
-			break;
+		i++;
 	}
 
 	/* matches not, relay on the parent */
@@ -153,22 +309,27 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		return -1;
 
 	/* we match only a part of the node. Split it and add the new chain */
-	if (i < root->val_nr) {
-		split_add_child(root, chain, cnode, i);
+	if (i - start < root->val_nr) {
+		split_add_child(root, chain, cnode, start, i - start, syms);
 		return 0;
 	}
 
 	/* we match 100% of the path, increment the hit */
-	if (i == root->val_nr) {
+	if (i - start == root->val_nr && i == chain->nr) {
 		root->hit++;
+		root->cumul_hit++;
+
 		return 0;
 	}
 
-	return __append_chain_children(root, chain);
+	/* We match the node and still have a part remaining */
+	__append_chain_children(root, chain, syms, i);
+
+	return 0;
 }
 
-void append_chain(struct callchain_node *root, struct ip_callchain *chain)
+void append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		  struct symbol **syms)
 {
-	if (__append_chain_children(root, chain) == -1)
-		add_child(root, chain);
+	__append_chain_children(root, chain, syms, 0);
 }
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index fa1cd2f..7812122 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -2,22 +2,42 @@
 #define __PERF_CALLCHAIN_H
 
 #include "../perf.h"
-#include "list.h"
-#include "rbtree.h"
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include "symbol.h"
 
+enum chain_mode {
+	CHAIN_FLAT,
+	CHAIN_GRAPH_ABS,
+	CHAIN_GRAPH_REL
+};
 
 struct callchain_node {
 	struct callchain_node	*parent;
 	struct list_head	brothers;
-	struct list_head 	children;
-	struct list_head 	val;
-	struct rb_node		rb_node;
-	int			val_nr;
-	int			hit;
+	struct list_head	children;
+	struct list_head	val;
+	struct rb_node		rb_node; /* to sort nodes in an rbtree */
+	struct rb_root		rb_root; /* sorted tree of children */
+	unsigned int		val_nr;
+	u64			hit;
+	u64			cumul_hit; /* hit + hits of children */
+};
+
+struct callchain_param;
+
+typedef void (*sort_chain_func_t)(struct rb_root *, struct callchain_node *,
+				 u64, struct callchain_param *);
+
+struct callchain_param {
+	enum chain_mode 	mode;
+	double			min_percent;
+	sort_chain_func_t	sort;
 };
 
 struct callchain_list {
-	unsigned long		ip;
+	u64			ip;
+	struct symbol		*sym;
 	struct list_head	list;
 };
 
@@ -28,6 +48,7 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->val);
 }
 
-void append_chain(struct callchain_node *root, struct ip_callchain *chain);
-void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node);
+int register_callchain_param(struct callchain_param *param);
+void append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		  struct symbol **syms);
 #endif
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 9a8c20c..90a044d 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -11,7 +11,8 @@ static int parse_color(const char *name, int len)
 	};
 	char *end;
 	int i;
-	for (i = 0; i < ARRAY_SIZE(color_names); i++) {
+
+	for (i = 0; i < (int)ARRAY_SIZE(color_names); i++) {
 		const char *str = color_names[i];
 		if (!strncasecmp(name, str, len) && !str[len])
 			return i - 1;
@@ -28,7 +29,8 @@ static int parse_attr(const char *name, int len)
 	static const char * const attr_names[] = {
 		"bold", "dim", "ul", "blink", "reverse"
 	};
-	int i;
+	unsigned int i;
+
 	for (i = 0; i < ARRAY_SIZE(attr_names); i++) {
 		const char *str = attr_names[i];
 		if (!strncasecmp(name, str, len) && !str[len])
@@ -222,10 +224,12 @@ int color_fwrite_lines(FILE *fp, const char *color,
 {
 	if (!*color)
 		return fwrite(buf, count, 1, fp) != 1;
+
 	while (count) {
 		char *p = memchr(buf, '\n', count);
+
 		if (p != buf && (fputs(color, fp) < 0 ||
-				fwrite(buf, p ? p - buf : count, 1, fp) != 1 ||
+				fwrite(buf, p ? (size_t)(p - buf) : count, 1, fp) != 1 ||
 				fputs(PERF_COLOR_RESET, fp) < 0))
 			return -1;
 		if (!p)
@@ -238,4 +242,31 @@ int color_fwrite_lines(FILE *fp, const char *color,
 	return 0;
 }
 
+char *get_percent_color(double percent)
+{
+	char *color = PERF_COLOR_NORMAL;
 
+	/*
+	 * We color high-overhead entries in red, mid-overhead
+	 * entries in green - and keep the low overhead places
+	 * normal:
+	 */
+	if (percent >= MIN_RED)
+		color = PERF_COLOR_RED;
+	else {
+		if (percent > MIN_GREEN)
+			color = PERF_COLOR_GREEN;
+	}
+	return color;
+}
+
+int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
+{
+	int r;
+	char *color;
+
+	color = get_percent_color(percent);
+	r = color_fprintf(fp, color, fmt, percent);
+
+	return r;
+}
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index 5abfd37..706cec5 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -15,6 +15,9 @@
 #define PERF_COLOR_CYAN		"\033[36m"
 #define PERF_COLOR_BG_RED	"\033[41m"
 
+#define MIN_GREEN	0.5
+#define MIN_RED		5.0
+
 /*
  * This variable stores the value of color.ui
  */
@@ -32,5 +35,7 @@ void color_parse_mem(const char *value, int len, const char *var, char *dst);
 int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
 int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
 int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
+int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
+char *get_percent_color(double percent);
 
 #endif /* COLOR_H */
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 3dd13fa..780df54 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -47,10 +47,12 @@ static int get_next_char(void)
 static char *parse_value(void)
 {
 	static char value[1024];
-	int quote = 0, comment = 0, len = 0, space = 0;
+	int quote = 0, comment = 0, space = 0;
+	size_t len = 0;
 
 	for (;;) {
 		int c = get_next_char();
+
 		if (len >= sizeof(value) - 1)
 			return NULL;
 		if (c == '\n') {
@@ -353,13 +355,13 @@ int perf_config_string(const char **dest, const char *var, const char *value)
 	return 0;
 }
 
-static int perf_default_core_config(const char *var, const char *value)
+static int perf_default_core_config(const char *var __used, const char *value __used)
 {
 	/* Add other config variables here and to Documentation/config.txt. */
 	return 0;
 }
 
-int perf_default_config(const char *var, const char *value, void *dummy)
+int perf_default_config(const char *var, const char *value, void *dummy __used)
 {
 	if (!prefixcmp(var, "core."))
 		return perf_default_core_config(var, value);
@@ -471,10 +473,10 @@ static int matches(const char* key, const char* value)
 		  !regexec(store.value_regex, value, 0, NULL, 0)));
 }
 
-static int store_aux(const char* key, const char* value, void *cb)
+static int store_aux(const char* key, const char* value, void *cb __used)
 {
+	int section_len;
 	const char *ep;
-	size_t section_len;
 
 	switch (store.state) {
 	case KEY_SEEN:
@@ -551,7 +553,7 @@ static int store_write_section(int fd, const char* key)
 		strbuf_addf(&sb, "[%.*s]\n", store.baselen, key);
 	}
 
-	success = write_in_full(fd, sb.buf, sb.len) == sb.len;
+	success = (write_in_full(fd, sb.buf, sb.len) == (ssize_t)sb.len);
 	strbuf_release(&sb);
 
 	return success;
@@ -599,7 +601,7 @@ static int store_write_pair(int fd, const char* key, const char* value)
 		}
 	strbuf_addf(&sb, "%s\n", quote);
 
-	success = write_in_full(fd, sb.buf, sb.len) == sb.len;
+	success = (write_in_full(fd, sb.buf, sb.len) == (ssize_t)sb.len);
 	strbuf_release(&sb);
 
 	return success;
@@ -741,7 +743,7 @@ int perf_config_set_multivar(const char* key, const char* value,
 	} else {
 		struct stat st;
 		char* contents;
-		size_t contents_sz, copy_begin, copy_end;
+		ssize_t contents_sz, copy_begin, copy_end;
 		int i, new_line = 0;
 
 		if (value_regex == NULL)
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index d392922..34a3528 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -1,6 +1,9 @@
 #include "cache.h"
 #include "exec_cmd.h"
 #include "quote.h"
+
+#include <string.h>
+
 #define MAX_ARGS	32
 
 extern char **environ;
@@ -51,7 +54,7 @@ const char *perf_extract_argv0_path(const char *argv0)
 		slash--;
 
 	if (slash >= argv0) {
-		argv0_path = strndup(argv0, slash - argv0);
+		argv0_path = xstrndup(argv0, slash - argv0);
 		return slash + 1;
 	}
 
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 17a00e0..fbb0097 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -26,7 +26,7 @@ static int term_columns(void)
 	return 80;
 }
 
-void add_cmdname(struct cmdnames *cmds, const char *name, int len)
+void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
 	struct cmdname *ent = malloc(sizeof(*ent) + len + 1);
 
@@ -40,7 +40,8 @@ void add_cmdname(struct cmdnames *cmds, const char *name, int len)
 
 static void clean_cmdnames(struct cmdnames *cmds)
 {
-	int i;
+	unsigned int i;
+
 	for (i = 0; i < cmds->cnt; ++i)
 		free(cmds->names[i]);
 	free(cmds->names);
@@ -57,7 +58,7 @@ static int cmdname_compare(const void *a_, const void *b_)
 
 static void uniq(struct cmdnames *cmds)
 {
-	int i, j;
+	unsigned int i, j;
 
 	if (!cmds->cnt)
 		return;
@@ -71,7 +72,7 @@ static void uniq(struct cmdnames *cmds)
 
 void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes)
 {
-	int ci, cj, ei;
+	size_t ci, cj, ei;
 	int cmp;
 
 	ci = cj = ei = 0;
@@ -106,8 +107,9 @@ static void pretty_print_string_list(struct cmdnames *cmds, int longest)
 		printf("  ");
 
 		for (j = 0; j < cols; j++) {
-			int n = j * rows + i;
-			int size = space;
+			unsigned int n = j * rows + i;
+			unsigned int size = space;
+
 			if (n >= cmds->cnt)
 				break;
 			if (j == cols-1 || n + rows >= cmds->cnt)
@@ -208,7 +210,7 @@ void load_command_list(const char *prefix,
 void list_commands(const char *title, struct cmdnames *main_cmds,
 		   struct cmdnames *other_cmds)
 {
-	int i, longest = 0;
+	unsigned int i, longest = 0;
 
 	for (i = 0; i < main_cmds->cnt; i++)
 		if (longest < main_cmds->names[i]->len)
@@ -239,7 +241,8 @@ void list_commands(const char *title, struct cmdnames *main_cmds,
 
 int is_in_cmdlist(struct cmdnames *c, const char *s)
 {
-	int i;
+	unsigned int i;
+
 	for (i = 0; i < c->cnt; i++)
 		if (!strcmp(s, c->names[i]->name))
 			return 1;
@@ -271,7 +274,8 @@ static int levenshtein_compare(const void *p1, const void *p2)
 
 static void add_cmd_list(struct cmdnames *cmds, struct cmdnames *old)
 {
-	int i;
+	unsigned int i;
+
 	ALLOC_GROW(cmds->names, cmds->cnt + old->cnt, cmds->alloc);
 
 	for (i = 0; i < old->cnt; i++)
@@ -283,7 +287,7 @@ static void add_cmd_list(struct cmdnames *cmds, struct cmdnames *old)
 
 const char *help_unknown_cmd(const char *cmd)
 {
-	int i, n = 0, best_similarity = 0;
+	unsigned int i, n = 0, best_similarity = 0;
 	struct cmdnames main_cmds, other_cmds;
 
 	memset(&main_cmds, 0, sizeof(main_cmds));
@@ -345,7 +349,7 @@ const char *help_unknown_cmd(const char *cmd)
 	exit(1);
 }
 
-int cmd_version(int argc, const char **argv, const char *prefix)
+int cmd_version(int argc __used, const char **argv __used, const char *prefix __used)
 {
 	printf("perf version %s\n", perf_version_string);
 	return 0;
diff --git a/tools/perf/util/help.h b/tools/perf/util/help.h
index 56bc154..7128783 100644
--- a/tools/perf/util/help.h
+++ b/tools/perf/util/help.h
@@ -2,8 +2,8 @@
 #define HELP_H
 
 struct cmdnames {
-	int alloc;
-	int cnt;
+	size_t alloc;
+	size_t cnt;
 	struct cmdname {
 		size_t len; /* also used for similarity index in help.c */
 		char name[FLEX_ARRAY];
@@ -19,7 +19,7 @@ static inline void mput_char(char c, unsigned int num)
 void load_command_list(const char *prefix,
 		struct cmdnames *main_cmds,
 		struct cmdnames *other_cmds);
-void add_cmdname(struct cmdnames *cmds, const char *name, int len);
+void add_cmdname(struct cmdnames *cmds, const char *name, size_t len);
 /* Here we require that excludes is a sorted list. */
 void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes);
 int is_in_cmdlist(struct cmdnames *c, const char *s);
diff --git a/tools/perf/util/include/asm/system.h b/tools/perf/util/include/asm/system.h
new file mode 100644
index 0000000..710cecc
--- /dev/null
+++ b/tools/perf/util/include/asm/system.h
@@ -0,0 +1 @@
+/* Empty */
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
new file mode 100644
index 0000000..99c1b3d
--- /dev/null
+++ b/tools/perf/util/include/linux/kernel.h
@@ -0,0 +1,21 @@
+#ifndef PERF_LINUX_KERNEL_H_
+#define PERF_LINUX_KERNEL_H_
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+#ifndef container_of
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+#endif
+
+#endif
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
new file mode 100644
index 0000000..dbe4b81
--- /dev/null
+++ b/tools/perf/util/include/linux/list.h
@@ -0,0 +1,18 @@
+#include "../../../../include/linux/list.h"
+
+#ifndef PERF_LIST_H
+#define PERF_LIST_H
+/**
+ * list_del_range - deletes range of entries from list.
+ * @begin: first element in the range to delete from the list.
+ * @end: last element in the range to delete from the list.
+ * Note: list_empty on the range of entries does not return true after this,
+ * the entries is in an undefined state.
+ */
+static inline void list_del_range(struct list_head *begin,
+				  struct list_head *end)
+{
+	begin->prev->next = end->next;
+	end->next->prev = begin->prev;
+}
+#endif
diff --git a/tools/perf/util/include/linux/module.h b/tools/perf/util/include/linux/module.h
new file mode 100644
index 0000000..b43e2dc
--- /dev/null
+++ b/tools/perf/util/include/linux/module.h
@@ -0,0 +1,6 @@
+#ifndef PERF_LINUX_MODULE_H
+#define PERF_LINUX_MODULE_H
+
+#define EXPORT_SYMBOL(name)
+
+#endif
diff --git a/tools/perf/util/include/linux/poison.h b/tools/perf/util/include/linux/poison.h
new file mode 100644
index 0000000..fef6dbc
--- /dev/null
+++ b/tools/perf/util/include/linux/poison.h
@@ -0,0 +1 @@
+#include "../../../../include/linux/poison.h"
diff --git a/tools/perf/util/include/linux/prefetch.h b/tools/perf/util/include/linux/prefetch.h
new file mode 100644
index 0000000..7841e48
--- /dev/null
+++ b/tools/perf/util/include/linux/prefetch.h
@@ -0,0 +1,6 @@
+#ifndef PERF_LINUX_PREFETCH_H
+#define PERF_LINUX_PREFETCH_H
+
+static inline void prefetch(void *a __attribute__((unused))) { }
+
+#endif
diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
new file mode 100644
index 0000000..7a243a1
--- /dev/null
+++ b/tools/perf/util/include/linux/rbtree.h
@@ -0,0 +1 @@
+#include "../../../../include/linux/rbtree.h"
diff --git a/tools/perf/util/list.h b/tools/perf/util/list.h
deleted file mode 100644
index e2548e8..0000000
--- a/tools/perf/util/list.h
+++ /dev/null
@@ -1,603 +0,0 @@
-#ifndef _LINUX_LIST_H
-#define _LINUX_LIST_H
-/*
-  Copyright (C) Cast of dozens, comes from the Linux kernel
-
-  This program is free software; you can redistribute it and/or modify it
-  under the terms of version 2 of the GNU General Public License as
-  published by the Free Software Foundation.
-*/
-
-#include <stddef.h>
-
-/*
- * These are non-NULL pointers that will result in page faults
- * under normal circumstances, used to verify that nobody uses
- * non-initialized list entries.
- */
-#define LIST_POISON1 ((void *)0x00100100)
-#define LIST_POISON2 ((void *)0x00200200)
-
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-        const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-        (type *)( (char *)__mptr - offsetof(type,member) );})
-
-/*
- * Simple doubly linked list implementation.
- *
- * Some of the internal functions ("__xxx") are useful when
- * manipulating whole lists rather than single entries, as
- * sometimes we already know the next/prev entries and we can
- * generate better code by using them directly rather than
- * using the generic single-entry routines.
- */
-
-struct list_head {
-	struct list_head *next, *prev;
-};
-
-#define LIST_HEAD_INIT(name) { &(name), &(name) }
-
-#define LIST_HEAD(name) \
-	struct list_head name = LIST_HEAD_INIT(name)
-
-static inline void INIT_LIST_HEAD(struct list_head *list)
-{
-	list->next = list;
-	list->prev = list;
-}
-
-/*
- * Insert a new entry between two known consecutive entries.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next)
-{
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	prev->next = new;
-}
-
-/**
- * list_add - add a new entry
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- */
-static inline void list_add(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head, head->next);
-}
-
-/**
- * list_add_tail - add a new entry
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- */
-static inline void list_add_tail(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head->prev, head);
-}
-
-/*
- * Delete a list entry by making the prev/next entries
- * point to each other.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_del(struct list_head * prev, struct list_head * next)
-{
-	next->prev = prev;
-	prev->next = next;
-}
-
-/**
- * list_del - deletes entry from list.
- * @entry: the element to delete from the list.
- * Note: list_empty on entry does not return true after this, the entry is
- * in an undefined state.
- */
-static inline void list_del(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->next = LIST_POISON1;
-	entry->prev = LIST_POISON2;
-}
-
-/**
- * list_del_range - deletes range of entries from list.
- * @beging: first element in the range to delete from the list.
- * @beging: first element in the range to delete from the list.
- * Note: list_empty on the range of entries does not return true after this,
- * the entries is in an undefined state.
- */
-static inline void list_del_range(struct list_head *begin,
-				  struct list_head *end)
-{
-	begin->prev->next = end->next;
-	end->next->prev = begin->prev;
-}
-
-/**
- * list_replace - replace old entry by new one
- * @old : the element to be replaced
- * @new : the new element to insert
- * Note: if 'old' was empty, it will be overwritten.
- */
-static inline void list_replace(struct list_head *old,
-				struct list_head *new)
-{
-	new->next = old->next;
-	new->next->prev = new;
-	new->prev = old->prev;
-	new->prev->next = new;
-}
-
-static inline void list_replace_init(struct list_head *old,
-					struct list_head *new)
-{
-	list_replace(old, new);
-	INIT_LIST_HEAD(old);
-}
-
-/**
- * list_del_init - deletes entry from list and reinitialize it.
- * @entry: the element to delete from the list.
- */
-static inline void list_del_init(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	INIT_LIST_HEAD(entry);
-}
-
-/**
- * list_move - delete from one list and add as another's head
- * @list: the entry to move
- * @head: the head that will precede our entry
- */
-static inline void list_move(struct list_head *list, struct list_head *head)
-{
-        __list_del(list->prev, list->next);
-        list_add(list, head);
-}
-
-/**
- * list_move_tail - delete from one list and add as another's tail
- * @list: the entry to move
- * @head: the head that will follow our entry
- */
-static inline void list_move_tail(struct list_head *list,
-				  struct list_head *head)
-{
-        __list_del(list->prev, list->next);
-        list_add_tail(list, head);
-}
-
-/**
- * list_is_last - tests whether @list is the last entry in list @head
- * @list: the entry to test
- * @head: the head of the list
- */
-static inline int list_is_last(const struct list_head *list,
-				const struct list_head *head)
-{
-	return list->next == head;
-}
-
-/**
- * list_empty - tests whether a list is empty
- * @head: the list to test.
- */
-static inline int list_empty(const struct list_head *head)
-{
-	return head->next == head;
-}
-
-/**
- * list_empty_careful - tests whether a list is empty and not being modified
- * @head: the list to test
- *
- * Description:
- * tests whether a list is empty _and_ checks that no other CPU might be
- * in the process of modifying either member (next or prev)
- *
- * NOTE: using list_empty_careful() without synchronization
- * can only be safe if the only activity that can happen
- * to the list entry is list_del_init(). Eg. it cannot be used
- * if another CPU could re-list_add() it.
- */
-static inline int list_empty_careful(const struct list_head *head)
-{
-	struct list_head *next = head->next;
-	return (next == head) && (next == head->prev);
-}
-
-static inline void __list_splice(struct list_head *list,
-				 struct list_head *head)
-{
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
-
-	first->prev = head;
-	head->next = first;
-
-	last->next = at;
-	at->prev = last;
-}
-
-/**
- * list_splice - join two lists
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- */
-static inline void list_splice(struct list_head *list, struct list_head *head)
-{
-	if (!list_empty(list))
-		__list_splice(list, head);
-}
-
-/**
- * list_splice_init - join two lists and reinitialise the emptied list.
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- *
- * The list at @list is reinitialised
- */
-static inline void list_splice_init(struct list_head *list,
-				    struct list_head *head)
-{
-	if (!list_empty(list)) {
-		__list_splice(list, head);
-		INIT_LIST_HEAD(list);
-	}
-}
-
-/**
- * list_entry - get the struct for this entry
- * @ptr:	the &struct list_head pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_entry(ptr, type, member) \
-	container_of(ptr, type, member)
-
-/**
- * list_first_entry - get the first element from a list
- * @ptr:       the list head to take the element from.
- * @type:      the type of the struct this is embedded in.
- * @member:    the name of the list_struct within the struct.
- *
- * Note, that list is expected to be not empty.
- */
-#define list_first_entry(ptr, type, member) \
-	list_entry((ptr)->next, type, member)
-
-/**
- * list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- */
-#define list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); \
-        	pos = pos->next)
-
-/**
- * __list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This variant differs from list_for_each() in that it's the
- * simplest possible list iteration code, no prefetching is done.
- * Use this for code that knows the list to be very short (empty
- * or 1 entry) most of the time.
- */
-#define __list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
-
-/**
- * list_for_each_prev	-	iterate over a list backwards
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- */
-#define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev; pos != (head); \
-        	pos = pos->prev)
-
-/**
- * list_for_each_safe - iterate over a list safe against removal of list entry
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- */
-#define list_for_each_safe(pos, n, head) \
-	for (pos = (head)->next, n = pos->next; pos != (head); \
-		pos = n, n = pos->next)
-
-/**
- * list_for_each_entry	-	iterate over list of given type
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry(pos, head, member)				\
-	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     &pos->member != (head); 	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
-
-/**
- * list_for_each_entry_reverse - iterate backwards over list of given type.
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_reverse(pos, head, member)			\
-	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     &pos->member != (head); 	\
-	     pos = list_entry(pos->member.prev, typeof(*pos), member))
-
-/**
- * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue
- * @pos:	the type * to use as a start point
- * @head:	the head of the list
- * @member:	the name of the list_struct within the struct.
- *
- * Prepares a pos entry for use as a start point in list_for_each_entry_continue.
- */
-#define list_prepare_entry(pos, head, member) \
-	((pos) ? : list_entry(head, typeof(*pos), member))
-
-/**
- * list_for_each_entry_continue - continue iteration over list of given type
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Continue to iterate over list of given type, continuing after
- * the current position.
- */
-#define list_for_each_entry_continue(pos, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head);	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
-
-/**
- * list_for_each_entry_from - iterate over list of given type from the current point
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Iterate over list of given type, continuing from current position.
- */
-#define list_for_each_entry_from(pos, head, member) 			\
-	for (; &pos->member != (head);	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
-
-/**
- * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_safe(pos, n, head, member)			\
-	for (pos = list_entry((head)->next, typeof(*pos), member),	\
-		n = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
-
-/**
- * list_for_each_entry_safe_continue
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Iterate over list of given type, continuing after current point,
- * safe against removal of list entry.
- */
-#define list_for_each_entry_safe_continue(pos, n, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member), 		\
-		n = list_entry(pos->member.next, typeof(*pos), member);		\
-	     &pos->member != (head);						\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
-
-/**
- * list_for_each_entry_safe_from
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Iterate over list of given type from current point, safe against
- * removal of list entry.
- */
-#define list_for_each_entry_safe_from(pos, n, head, member) 			\
-	for (n = list_entry(pos->member.next, typeof(*pos), member);		\
-	     &pos->member != (head);						\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
-
-/**
- * list_for_each_entry_safe_reverse
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Iterate backwards over list of given type, safe against removal
- * of list entry.
- */
-#define list_for_each_entry_safe_reverse(pos, n, head, member)		\
-	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
-		n = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
-
-/*
- * Double linked lists with a single pointer list head.
- * Mostly useful for hash tables where the two pointer list head is
- * too wasteful.
- * You lose the ability to access the tail in O(1).
- */
-
-struct hlist_head {
-	struct hlist_node *first;
-};
-
-struct hlist_node {
-	struct hlist_node *next, **pprev;
-};
-
-#define HLIST_HEAD_INIT { .first = NULL }
-#define HLIST_HEAD(name) struct hlist_head name = {  .first = NULL }
-#define INIT_HLIST_HEAD(ptr) ((ptr)->first = NULL)
-static inline void INIT_HLIST_NODE(struct hlist_node *h)
-{
-	h->next = NULL;
-	h->pprev = NULL;
-}
-
-static inline int hlist_unhashed(const struct hlist_node *h)
-{
-	return !h->pprev;
-}
-
-static inline int hlist_empty(const struct hlist_head *h)
-{
-	return !h->first;
-}
-
-static inline void __hlist_del(struct hlist_node *n)
-{
-	struct hlist_node *next = n->next;
-	struct hlist_node **pprev = n->pprev;
-	*pprev = next;
-	if (next)
-		next->pprev = pprev;
-}
-
-static inline void hlist_del(struct hlist_node *n)
-{
-	__hlist_del(n);
-	n->next = LIST_POISON1;
-	n->pprev = LIST_POISON2;
-}
-
-static inline void hlist_del_init(struct hlist_node *n)
-{
-	if (!hlist_unhashed(n)) {
-		__hlist_del(n);
-		INIT_HLIST_NODE(n);
-	}
-}
-
-static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
-{
-	struct hlist_node *first = h->first;
-	n->next = first;
-	if (first)
-		first->pprev = &n->next;
-	h->first = n;
-	n->pprev = &h->first;
-}
-
-/* next must be != NULL */
-static inline void hlist_add_before(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	n->pprev = next->pprev;
-	n->next = next;
-	next->pprev = &n->next;
-	*(n->pprev) = n;
-}
-
-static inline void hlist_add_after(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	next->next = n->next;
-	n->next = next;
-	next->pprev = &n->next;
-
-	if(next->next)
-		next->next->pprev  = &next->next;
-}
-
-#define hlist_entry(ptr, type, member) container_of(ptr,type,member)
-
-#define hlist_for_each(pos, head) \
-	for (pos = (head)->first; pos; \
-	     pos = pos->next)
-
-#define hlist_for_each_safe(pos, n, head) \
-	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
-	     pos = n)
-
-/**
- * hlist_for_each_entry	- iterate over list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry(tpos, pos, head, member)			 \
-	for (pos = (head)->first;					 \
-	     pos && 			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_continue - iterate over a hlist continuing after current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_continue(tpos, pos, member)		 \
-	for (pos = (pos)->next;						 \
-	     pos && 			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_from - iterate over a hlist continuing from current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos && 			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @n:		another &struct hlist_node to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
-	for (pos = (head)->first;					 \
-	     pos && ({ n = pos->next; 1; }) && 				 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = n)
-
-#endif
diff --git a/tools/perf/util/module.c b/tools/perf/util/module.c
new file mode 100644
index 0000000..ddabe92
--- /dev/null
+++ b/tools/perf/util/module.c
@@ -0,0 +1,509 @@
+#include "util.h"
+#include "../perf.h"
+#include "string.h"
+#include "module.h"
+
+#include <libelf.h>
+#include <gelf.h>
+#include <elf.h>
+#include <dirent.h>
+#include <sys/utsname.h>
+
+static unsigned int crc32(const char *p, unsigned int len)
+{
+	int i;
+	unsigned int crc = 0;
+
+	while (len--) {
+		crc ^= *p++;
+		for (i = 0; i < 8; i++)
+			crc = (crc >> 1) ^ ((crc & 1) ? 0xedb88320 : 0);
+	}
+	return crc;
+}
+
+/* module section methods */
+
+struct sec_dso *sec_dso__new_dso(const char *name)
+{
+	struct sec_dso *self = malloc(sizeof(*self) + strlen(name) + 1);
+
+	if (self != NULL) {
+		strcpy(self->name, name);
+		self->secs = RB_ROOT;
+		self->find_section = sec_dso__find_section;
+	}
+
+	return self;
+}
+
+static void sec_dso__delete_section(struct section *self)
+{
+	free(((void *)self));
+}
+
+void sec_dso__delete_sections(struct sec_dso *self)
+{
+	struct section *pos;
+	struct rb_node *next = rb_first(&self->secs);
+
+	while (next) {
+		pos = rb_entry(next, struct section, rb_node);
+		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, &self->secs);
+		sec_dso__delete_section(pos);
+	}
+}
+
+void sec_dso__delete_self(struct sec_dso *self)
+{
+	sec_dso__delete_sections(self);
+	free(self);
+}
+
+static void sec_dso__insert_section(struct sec_dso *self, struct section *sec)
+{
+	struct rb_node **p = &self->secs.rb_node;
+	struct rb_node *parent = NULL;
+	const u64 hash = sec->hash;
+	struct section *s;
+
+	while (*p != NULL) {
+		parent = *p;
+		s = rb_entry(parent, struct section, rb_node);
+		if (hash < s->hash)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&sec->rb_node, parent, p);
+	rb_insert_color(&sec->rb_node, &self->secs);
+}
+
+struct section *sec_dso__find_section(struct sec_dso *self, const char *name)
+{
+	struct rb_node *n;
+	u64 hash;
+	int len;
+
+	if (self == NULL)
+		return NULL;
+
+	len = strlen(name);
+	hash = crc32(name, len);
+
+	n = self->secs.rb_node;
+
+	while (n) {
+		struct section *s = rb_entry(n, struct section, rb_node);
+
+		if (hash < s->hash)
+			n = n->rb_left;
+		else if (hash > s->hash)
+			n = n->rb_right;
+		else {
+			if (!strcmp(name, s->name))
+				return s;
+			else
+				n = rb_next(&s->rb_node);
+		}
+	}
+
+	return NULL;
+}
+
+static size_t sec_dso__fprintf_section(struct section *self, FILE *fp)
+{
+	return fprintf(fp, "name:%s vma:%llx path:%s\n",
+		       self->name, self->vma, self->path);
+}
+
+size_t sec_dso__fprintf(struct sec_dso *self, FILE *fp)
+{
+	size_t ret = fprintf(fp, "dso: %s\n", self->name);
+
+	struct rb_node *nd;
+	for (nd = rb_first(&self->secs); nd; nd = rb_next(nd)) {
+		struct section *pos = rb_entry(nd, struct section, rb_node);
+		ret += sec_dso__fprintf_section(pos, fp);
+	}
+
+	return ret;
+}
+
+static struct section *section__new(const char *name, const char *path)
+{
+	struct section *self = calloc(1, sizeof(*self));
+
+	if (!self)
+		goto out_failure;
+
+	self->name = calloc(1, strlen(name) + 1);
+	if (!self->name)
+		goto out_failure;
+
+	self->path = calloc(1, strlen(path) + 1);
+	if (!self->path)
+		goto out_failure;
+
+	strcpy(self->name, name);
+	strcpy(self->path, path);
+	self->hash = crc32(self->name, strlen(name));
+
+	return self;
+
+out_failure:
+	if (self) {
+		if (self->name)
+			free(self->name);
+		if (self->path)
+			free(self->path);
+		free(self);
+	}
+
+	return NULL;
+}
+
+/* module methods */
+
+struct mod_dso *mod_dso__new_dso(const char *name)
+{
+	struct mod_dso *self = malloc(sizeof(*self) + strlen(name) + 1);
+
+	if (self != NULL) {
+		strcpy(self->name, name);
+		self->mods = RB_ROOT;
+		self->find_module = mod_dso__find_module;
+	}
+
+	return self;
+}
+
+static void mod_dso__delete_module(struct module *self)
+{
+	free(((void *)self));
+}
+
+void mod_dso__delete_modules(struct mod_dso *self)
+{
+	struct module *pos;
+	struct rb_node *next = rb_first(&self->mods);
+
+	while (next) {
+		pos = rb_entry(next, struct module, rb_node);
+		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, &self->mods);
+		mod_dso__delete_module(pos);
+	}
+}
+
+void mod_dso__delete_self(struct mod_dso *self)
+{
+	mod_dso__delete_modules(self);
+	free(self);
+}
+
+static void mod_dso__insert_module(struct mod_dso *self, struct module *mod)
+{
+	struct rb_node **p = &self->mods.rb_node;
+	struct rb_node *parent = NULL;
+	const u64 hash = mod->hash;
+	struct module *m;
+
+	while (*p != NULL) {
+		parent = *p;
+		m = rb_entry(parent, struct module, rb_node);
+		if (hash < m->hash)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&mod->rb_node, parent, p);
+	rb_insert_color(&mod->rb_node, &self->mods);
+}
+
+struct module *mod_dso__find_module(struct mod_dso *self, const char *name)
+{
+	struct rb_node *n;
+	u64 hash;
+	int len;
+
+	if (self == NULL)
+		return NULL;
+
+	len = strlen(name);
+	hash = crc32(name, len);
+
+	n = self->mods.rb_node;
+
+	while (n) {
+		struct module *m = rb_entry(n, struct module, rb_node);
+
+		if (hash < m->hash)
+			n = n->rb_left;
+		else if (hash > m->hash)
+			n = n->rb_right;
+		else {
+			if (!strcmp(name, m->name))
+				return m;
+			else
+				n = rb_next(&m->rb_node);
+		}
+	}
+
+	return NULL;
+}
+
+static size_t mod_dso__fprintf_module(struct module *self, FILE *fp)
+{
+	return fprintf(fp, "name:%s path:%s\n", self->name, self->path);
+}
+
+size_t mod_dso__fprintf(struct mod_dso *self, FILE *fp)
+{
+	struct rb_node *nd;
+	size_t ret;
+
+	ret = fprintf(fp, "dso: %s\n", self->name);
+
+	for (nd = rb_first(&self->mods); nd; nd = rb_next(nd)) {
+		struct module *pos = rb_entry(nd, struct module, rb_node);
+
+		ret += mod_dso__fprintf_module(pos, fp);
+	}
+
+	return ret;
+}
+
+static struct module *module__new(const char *name, const char *path)
+{
+	struct module *self = calloc(1, sizeof(*self));
+
+	if (!self)
+		goto out_failure;
+
+	self->name = calloc(1, strlen(name) + 1);
+	if (!self->name)
+		goto out_failure;
+
+	self->path = calloc(1, strlen(path) + 1);
+	if (!self->path)
+		goto out_failure;
+
+	strcpy(self->name, name);
+	strcpy(self->path, path);
+	self->hash = crc32(self->name, strlen(name));
+
+	return self;
+
+out_failure:
+	if (self) {
+		if (self->name)
+			free(self->name);
+		if (self->path)
+			free(self->path);
+		free(self);
+	}
+
+	return NULL;
+}
+
+static int mod_dso__load_sections(struct module *mod)
+{
+	int count = 0, path_len;
+	struct dirent *entry;
+	char *line = NULL;
+	char *dir_path;
+	DIR *dir;
+	size_t n;
+
+	path_len = strlen("/sys/module/");
+	path_len += strlen(mod->name);
+	path_len += strlen("/sections/");
+
+	dir_path = calloc(1, path_len + 1);
+	if (dir_path == NULL)
+		goto out_failure;
+
+	strcat(dir_path, "/sys/module/");
+	strcat(dir_path, mod->name);
+	strcat(dir_path, "/sections/");
+
+	dir = opendir(dir_path);
+	if (dir == NULL)
+		goto out_free;
+
+	while ((entry = readdir(dir))) {
+		struct section *section;
+		char *path, *vma;
+		int line_len;
+		FILE *file;
+
+		if (!strcmp(".", entry->d_name) || !strcmp("..", entry->d_name))
+			continue;
+
+		path = calloc(1, path_len + strlen(entry->d_name) + 1);
+		if (path == NULL)
+			break;
+		strcat(path, dir_path);
+		strcat(path, entry->d_name);
+
+		file = fopen(path, "r");
+		if (file == NULL) {
+			free(path);
+			break;
+		}
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0) {
+			free(path);
+			fclose(file);
+			break;
+		}
+
+		if (!line) {
+			free(path);
+			fclose(file);
+			break;
+		}
+
+		line[--line_len] = '\0'; /* \n */
+
+		vma = strstr(line, "0x");
+		if (!vma) {
+			free(path);
+			fclose(file);
+			break;
+		}
+		vma += 2;
+
+		section = section__new(entry->d_name, path);
+		if (!section) {
+			fprintf(stderr, "load_sections: allocation error\n");
+			free(path);
+			fclose(file);
+			break;
+		}
+
+		hex2u64(vma, &section->vma);
+		sec_dso__insert_section(mod->sections, section);
+
+		free(path);
+		fclose(file);
+		count++;
+	}
+
+	closedir(dir);
+	free(line);
+	free(dir_path);
+
+	return count;
+
+out_free:
+	free(dir_path);
+
+out_failure:
+	return count;
+}
+
+static int mod_dso__load_module_paths(struct mod_dso *self)
+{
+	struct utsname uts;
+	int count = 0, len;
+	char *line = NULL;
+	FILE *file;
+	char *path;
+	size_t n;
+
+	if (uname(&uts) < 0)
+		goto out_failure;
+
+	len = strlen("/lib/modules/");
+	len += strlen(uts.release);
+	len += strlen("/modules.dep");
+
+	path = calloc(1, len);
+	if (path == NULL)
+		goto out_failure;
+
+	strcat(path, "/lib/modules/");
+	strcat(path, uts.release);
+	strcat(path, "/modules.dep");
+
+	file = fopen(path, "r");
+	free(path);
+	if (file == NULL)
+		goto out_failure;
+
+	while (!feof(file)) {
+		char *path, *name, *tmp;
+		struct module *module;
+		int line_len, len;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0)
+			break;
+
+		if (!line)
+			goto out_failure;
+
+		line[--line_len] = '\0'; /* \n */
+
+		path = strtok(line, ":");
+		if (!path)
+			goto out_failure;
+
+		name = strdup(path);
+		name = strtok(name, "/");
+
+		tmp = name;
+
+		while (tmp) {
+			tmp = strtok(NULL, "/");
+			if (tmp)
+				name = tmp;
+		}
+		name = strsep(&name, ".");
+
+		/* Quirk: replace '-' with '_' in sound modules */
+		for (len = strlen(name); len; len--) {
+			if (*(name+len) == '-')
+				*(name+len) = '_';
+		}
+
+		module = module__new(name, path);
+		if (!module) {
+			fprintf(stderr, "load_module_paths: allocation error\n");
+			goto out_failure;
+		}
+		mod_dso__insert_module(self, module);
+
+		module->sections = sec_dso__new_dso("sections");
+		if (!module->sections) {
+			fprintf(stderr, "load_module_paths: allocation error\n");
+			goto out_failure;
+		}
+
+		module->active = mod_dso__load_sections(module);
+
+		if (module->active > 0)
+			count++;
+	}
+
+	free(line);
+	fclose(file);
+
+	return count;
+
+out_failure:
+	return -1;
+}
+
+int mod_dso__load_modules(struct mod_dso *dso)
+{
+	int err;
+
+	err = mod_dso__load_module_paths(dso);
+
+	return err;
+}
diff --git a/tools/perf/util/module.h b/tools/perf/util/module.h
new file mode 100644
index 0000000..8a592ef
--- /dev/null
+++ b/tools/perf/util/module.h
@@ -0,0 +1,53 @@
+#ifndef _PERF_MODULE_
+#define _PERF_MODULE_ 1
+
+#include <linux/types.h>
+#include "../types.h"
+#include <linux/list.h>
+#include <linux/rbtree.h>
+
+struct section {
+	struct rb_node	rb_node;
+	u64		hash;
+	u64		vma;
+	char		*name;
+	char		*path;
+};
+
+struct sec_dso {
+	struct list_head node;
+	struct rb_root	 secs;
+	struct section    *(*find_section)(struct sec_dso *, const char *name);
+	char		 name[0];
+};
+
+struct module {
+	struct rb_node	rb_node;
+	u64		hash;
+	char		*name;
+	char		*path;
+	struct sec_dso	*sections;
+	int		active;
+};
+
+struct mod_dso {
+	struct list_head node;
+	struct rb_root	 mods;
+	struct module    *(*find_module)(struct mod_dso *, const char *name);
+	char		 name[0];
+};
+
+struct sec_dso *sec_dso__new_dso(const char *name);
+void sec_dso__delete_sections(struct sec_dso *self);
+void sec_dso__delete_self(struct sec_dso *self);
+size_t sec_dso__fprintf(struct sec_dso *self, FILE *fp);
+struct section *sec_dso__find_section(struct sec_dso *self, const char *name);
+
+struct mod_dso *mod_dso__new_dso(const char *name);
+void mod_dso__delete_modules(struct mod_dso *self);
+void mod_dso__delete_self(struct mod_dso *self);
+size_t mod_dso__fprintf(struct mod_dso *self, FILE *fp);
+struct module *mod_dso__find_module(struct mod_dso *self, const char *name);
+int mod_dso__load_modules(struct mod_dso *dso);
+
+#endif /* _PERF_MODULE_ */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4d042f1..5184959 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -184,16 +184,20 @@ char *event_name(int counter)
 	return "unknown";
 }
 
-static int parse_aliases(const char *str, char *names[][MAX_ALIASES], int size)
+static int parse_aliases(const char **str, char *names[][MAX_ALIASES], int size)
 {
 	int i, j;
+	int n, longest = -1;
 
 	for (i = 0; i < size; i++) {
-		for (j = 0; j < MAX_ALIASES; j++) {
-			if (!names[i][j])
-				break;
-			if (strcasestr(str, names[i][j]))
-				return i;
+		for (j = 0; j < MAX_ALIASES && names[i][j]; j++) {
+			n = strlen(names[i][j]);
+			if (n > longest && !strncasecmp(*str, names[i][j], n))
+				longest = n;
+		}
+		if (longest > 0) {
+			*str += longest;
+			return i;
 		}
 	}
 
@@ -201,30 +205,53 @@ static int parse_aliases(const char *str, char *names[][MAX_ALIASES], int size)
 }
 
 static int
-parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
+parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 {
-	int cache_type = -1, cache_op = 0, cache_result = 0;
+	const char *s = *str;
+	int cache_type = -1, cache_op = -1, cache_result = -1;
 
-	cache_type = parse_aliases(str, hw_cache, PERF_COUNT_HW_CACHE_MAX);
+	cache_type = parse_aliases(&s, hw_cache, PERF_COUNT_HW_CACHE_MAX);
 	/*
 	 * No fallback - if we cannot get a clear cache type
 	 * then bail out:
 	 */
 	if (cache_type == -1)
-		return -EINVAL;
+		return 0;
+
+	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
+		++s;
+
+		if (cache_op == -1) {
+			cache_op = parse_aliases(&s, hw_cache_op,
+						PERF_COUNT_HW_CACHE_OP_MAX);
+			if (cache_op >= 0) {
+				if (!is_cache_op_valid(cache_type, cache_op))
+					return 0;
+				continue;
+			}
+		}
+
+		if (cache_result == -1) {
+			cache_result = parse_aliases(&s, hw_cache_result,
+						PERF_COUNT_HW_CACHE_RESULT_MAX);
+			if (cache_result >= 0)
+				continue;
+		}
+
+		/*
+		 * Can't parse this as a cache op or result, so back up
+		 * to the '-'.
+		 */
+		--s;
+		break;
+	}
 
-	cache_op = parse_aliases(str, hw_cache_op, PERF_COUNT_HW_CACHE_OP_MAX);
 	/*
 	 * Fall back to reads:
 	 */
 	if (cache_op == -1)
 		cache_op = PERF_COUNT_HW_CACHE_OP_READ;
 
-	if (!is_cache_op_valid(cache_type, cache_op))
-		return -EINVAL;
-
-	cache_result = parse_aliases(str, hw_cache_result,
-					PERF_COUNT_HW_CACHE_RESULT_MAX);
 	/*
 	 * Fall back to accesses:
 	 */
@@ -234,93 +261,154 @@ parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
 	attr->config = cache_type | (cache_op << 8) | (cache_result << 16);
 	attr->type = PERF_TYPE_HW_CACHE;
 
-	return 0;
+	*str = s;
+	return 1;
 }
 
 static int check_events(const char *str, unsigned int i)
 {
-	if (!strncmp(str, event_symbols[i].symbol,
-		     strlen(event_symbols[i].symbol)))
-		return 1;
+	int n;
 
-	if (strlen(event_symbols[i].alias))
-		if (!strncmp(str, event_symbols[i].alias,
-			     strlen(event_symbols[i].alias)))
-			return 1;
+	n = strlen(event_symbols[i].symbol);
+	if (!strncmp(str, event_symbols[i].symbol, n))
+		return n;
+
+	n = strlen(event_symbols[i].alias);
+	if (n)
+		if (!strncmp(str, event_symbols[i].alias, n))
+			return n;
 	return 0;
 }
 
-/*
- * Each event can have multiple symbolic names.
- * Symbolic names are (almost) exactly matched.
- */
-static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
+static int
+parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 {
-	u64 config, id;
-	int type;
+	const char *str = *strp;
 	unsigned int i;
-	const char *sep, *pstr;
+	int n;
 
-	if (str[0] == 'r' && hex2u64(str + 1, &config) > 0) {
-		attr->type = PERF_TYPE_RAW;
-		attr->config = config;
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
+		n = check_events(str, i);
+		if (n > 0) {
+			attr->type = event_symbols[i].type;
+			attr->config = event_symbols[i].config;
+			*strp = str + n;
+			return 1;
+		}
+	}
+	return 0;
+}
 
+static int parse_raw_event(const char **strp, struct perf_counter_attr *attr)
+{
+	const char *str = *strp;
+	u64 config;
+	int n;
+
+	if (*str != 'r')
 		return 0;
+	n = hex2u64(str + 1, &config);
+	if (n > 0) {
+		*strp = str + n + 1;
+		attr->type = PERF_TYPE_RAW;
+		attr->config = config;
+		return 1;
 	}
+	return 0;
+}
 
-	pstr = str;
-	sep = strchr(pstr, ':');
-	if (sep) {
-		type = atoi(pstr);
-		pstr = sep + 1;
-		id = atoi(pstr);
-		sep = strchr(pstr, ':');
-		if (sep) {
-			pstr = sep + 1;
-			if (strchr(pstr, 'k'))
-				attr->exclude_user = 1;
-			if (strchr(pstr, 'u'))
-				attr->exclude_kernel = 1;
+static int
+parse_numeric_event(const char **strp, struct perf_counter_attr *attr)
+{
+	const char *str = *strp;
+	char *endp;
+	unsigned long type;
+	u64 config;
+
+	type = strtoul(str, &endp, 0);
+	if (endp > str && type < PERF_TYPE_MAX && *endp == ':') {
+		str = endp + 1;
+		config = strtoul(str, &endp, 0);
+		if (endp > str) {
+			attr->type = type;
+			attr->config = config;
+			*strp = endp;
+			return 1;
 		}
-		attr->type = type;
-		attr->config = id;
+	}
+	return 0;
+}
 
+static int
+parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
+{
+	const char *str = *strp;
+	int eu = 1, ek = 1, eh = 1;
+
+	if (*str++ != ':')
 		return 0;
+	while (*str) {
+		if (*str == 'u')
+			eu = 0;
+		else if (*str == 'k')
+			ek = 0;
+		else if (*str == 'h')
+			eh = 0;
+		else
+			break;
+		++str;
 	}
+	if (str >= *strp + 2) {
+		*strp = str;
+		attr->exclude_user   = eu;
+		attr->exclude_kernel = ek;
+		attr->exclude_hv     = eh;
+		return 1;
+	}
+	return 0;
+}
 
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		if (check_events(str, i)) {
-			attr->type = event_symbols[i].type;
-			attr->config = event_symbols[i].config;
+/*
+ * Each event can have multiple symbolic names.
+ * Symbolic names are (almost) exactly matched.
+ */
+static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
+{
+	if (!(parse_raw_event(str, attr) ||
+	      parse_numeric_event(str, attr) ||
+	      parse_symbolic_event(str, attr) ||
+	      parse_generic_hw_event(str, attr)))
+		return 0;
 
-			return 0;
-		}
-	}
+	parse_event_modifier(str, attr);
 
-	return parse_generic_hw_symbols(str, attr);
+	return 1;
 }
 
-int parse_events(const struct option *opt, const char *str, int unset)
+int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_counter_attr attr;
-	int ret;
 
-	memset(&attr, 0, sizeof(attr));
-again:
-	if (nr_counters == MAX_COUNTERS)
-		return -1;
+	for (;;) {
+		if (nr_counters == MAX_COUNTERS)
+			return -1;
+
+		memset(&attr, 0, sizeof(attr));
+		if (!parse_event_symbols(&str, &attr))
+			return -1;
 
-	ret = parse_event_symbols(str, &attr);
-	if (ret < 0)
-		return ret;
+		if (!(*str == 0 || *str == ',' || isspace(*str)))
+			return -1;
 
-	attrs[nr_counters] = attr;
-	nr_counters++;
+		attrs[nr_counters] = attr;
+		nr_counters++;
 
-	str = strstr(str, ",");
-	if (str) {
-		str++;
-		goto again;
+		if (*str == 0)
+			break;
+		if (*str == ',')
+			++str;
+		while (isspace(*str))
+			++str;
 	}
 
 	return 0;
@@ -340,7 +428,7 @@ static const char * const event_type_descriptors[] = {
 void print_events(void)
 {
 	struct event_symbol *syms = event_symbols;
-	unsigned int i, type, prev_type = -1;
+	unsigned int i, type, op, prev_type = -1;
 	char name[40];
 
 	fprintf(stderr, "\n");
@@ -365,6 +453,21 @@ void print_events(void)
 	}
 
 	fprintf(stderr, "\n");
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				fprintf(stderr, "  %-40s [%s]\n",
+					event_cache_name(type, op, i),
+					event_type_descriptors[4]);
+			}
+		}
+	}
+
+	fprintf(stderr, "\n");
 	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index b3affb1..1bf6719 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -20,7 +20,8 @@ static int get_arg(struct parse_opt_ctx_t *p, const struct option *opt,
 	if (p->opt) {
 		*arg = p->opt;
 		p->opt = NULL;
-	} else if (p->argc == 1 && (opt->flags & PARSE_OPT_LASTARG_DEFAULT)) {
+	} else if ((opt->flags & PARSE_OPT_LASTARG_DEFAULT) && (p->argc == 1 ||
+		    **(p->argv + 1) == '-')) {
 		*arg = (const char *)opt->defval;
 	} else if (p->argc > 1) {
 		p->argc--;
@@ -485,7 +486,7 @@ int parse_options_usage(const char * const *usagestr,
 }
 
 
-int parse_opt_verbosity_cb(const struct option *opt, const char *arg,
+int parse_opt_verbosity_cb(const struct option *opt, const char *arg __used,
 			   int unset)
 {
 	int *target = opt->value;
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index a1039a6..8aa3464 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -90,21 +90,22 @@ struct option {
 	intptr_t defval;
 };
 
-#define OPT_END()                   { OPTION_END }
-#define OPT_ARGUMENT(l, h)          { OPTION_ARGUMENT, 0, (l), NULL, NULL, (h) }
-#define OPT_GROUP(h)                { OPTION_GROUP, 0, NULL, NULL, NULL, (h) }
-#define OPT_BIT(s, l, v, h, b)      { OPTION_BIT, (s), (l), (v), NULL, (h), 0, NULL, (b) }
-#define OPT_BOOLEAN(s, l, v, h)     { OPTION_BOOLEAN, (s), (l), (v), NULL, (h) }
-#define OPT_SET_INT(s, l, v, h, i)  { OPTION_SET_INT, (s), (l), (v), NULL, (h), 0, NULL, (i) }
-#define OPT_SET_PTR(s, l, v, h, p)  { OPTION_SET_PTR, (s), (l), (v), NULL, (h), 0, NULL, (p) }
-#define OPT_INTEGER(s, l, v, h)     { OPTION_INTEGER, (s), (l), (v), NULL, (h) }
-#define OPT_LONG(s, l, v, h)        { OPTION_LONG, (s), (l), (v), NULL, (h) }
-#define OPT_STRING(s, l, v, a, h)   { OPTION_STRING,  (s), (l), (v), (a), (h) }
+#define OPT_END()                   { .type = OPTION_END }
+#define OPT_ARGUMENT(l, h)          { .type = OPTION_ARGUMENT, .long_name = (l), .help = (h) }
+#define OPT_GROUP(h)                { .type = OPTION_GROUP, .help = (h) }
+#define OPT_BIT(s, l, v, h, b)      { .type = OPTION_BIT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (b) }
+#define OPT_BOOLEAN(s, l, v, h)     { .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_SET_INT(s, l, v, h, i)  { .type = OPTION_SET_INT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (i) }
+#define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
+#define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h) }
 #define OPT_DATE(s, l, v, h) \
-	{ OPTION_CALLBACK, (s), (l), (v), "time",(h), 0, \
-	  parse_opt_approxidate_cb }
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
-	{ OPTION_CALLBACK, (s), (l), (v), (a), (h), 0, (f) }
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f) }
+#define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
 
 /* parse_options() will filter out the processed options and leave the
  * non-option argments in argv[].
diff --git a/tools/perf/util/quote.c b/tools/perf/util/quote.c
index f18c521..c6e5dc0 100644
--- a/tools/perf/util/quote.c
+++ b/tools/perf/util/quote.c
@@ -162,12 +162,16 @@ static inline int sq_must_quote(char c)
 	return sq_lookup[(unsigned char)c] + quote_path_fully > 0;
 }
 
-/* returns the longest prefix not needing a quote up to maxlen if positive.
-   This stops at the first \0 because it's marked as a character needing an
-   escape */
-static size_t next_quote_pos(const char *s, ssize_t maxlen)
+/*
+ * Returns the longest prefix not needing a quote up to maxlen if
+ * positive.
+ * This stops at the first \0 because it's marked as a character
+ * needing an escape.
+ */
+static ssize_t next_quote_pos(const char *s, ssize_t maxlen)
 {
-	size_t len;
+	ssize_t len;
+
 	if (maxlen < 0) {
 		for (len = 0; !sq_must_quote(s[len]); len++);
 	} else {
@@ -192,22 +196,22 @@ static size_t next_quote_pos(const char *s, ssize_t maxlen)
 static size_t quote_c_style_counted(const char *name, ssize_t maxlen,
                                     struct strbuf *sb, FILE *fp, int no_dq)
 {
-#undef EMIT
-#define EMIT(c)                                 \
-	do {                                        \
-		if (sb) strbuf_addch(sb, (c));          \
-		if (fp) fputc((c), fp);                 \
-		count++;                                \
+#define EMIT(c)							\
+	do {							\
+		if (sb) strbuf_addch(sb, (c));			\
+		if (fp) fputc((c), fp);				\
+		count++;					\
 	} while (0)
-#define EMITBUF(s, l)                           \
-	do {                                        \
-		int __ret;				\
-		if (sb) strbuf_add(sb, (s), (l));       \
-		if (fp) __ret = fwrite((s), (l), 1, fp);        \
-		count += (l);                           \
+
+#define EMITBUF(s, l)						\
+	do {							\
+		int __ret;					\
+		if (sb) strbuf_add(sb, (s), (l));		\
+		if (fp) __ret = fwrite((s), (l), 1, fp);	\
+		count += (l);					\
 	} while (0)
 
-	size_t len, count = 0;
+	ssize_t len, count = 0;
 	const char *p = name;
 
 	for (;;) {
@@ -273,8 +277,8 @@ void write_name_quoted(const char *name, FILE *fp, int terminator)
 	fputc(terminator, fp);
 }
 
-extern void write_name_quotedpfx(const char *pfx, size_t pfxlen,
-                                 const char *name, FILE *fp, int terminator)
+void write_name_quotedpfx(const char *pfx, ssize_t pfxlen,
+			  const char *name, FILE *fp, int terminator)
 {
 	int needquote = 0;
 
@@ -306,7 +310,7 @@ char *quote_path_relative(const char *in, int len,
 		len = strlen(in);
 
 	/* "../" prefix itself does not need quoting, but "in" might. */
-	needquote = next_quote_pos(in, len) < len;
+	needquote = (next_quote_pos(in, len) < len);
 	strbuf_setlen(out, 0);
 	strbuf_grow(out, len);
 
diff --git a/tools/perf/util/quote.h b/tools/perf/util/quote.h
index 5dfad89..a5454a1 100644
--- a/tools/perf/util/quote.h
+++ b/tools/perf/util/quote.h
@@ -53,7 +53,7 @@ extern size_t quote_c_style(const char *name, struct strbuf *, FILE *, int no_dq
 extern void quote_two_c_style(struct strbuf *, const char *, const char *, int);
 
 extern void write_name_quoted(const char *name, FILE *, int terminator);
-extern void write_name_quotedpfx(const char *pfx, size_t pfxlen,
+extern void write_name_quotedpfx(const char *pfx, ssize_t pfxlen,
                                  const char *name, FILE *, int terminator);
 
 /* quote path as relative to the given prefix */
diff --git a/tools/perf/util/rbtree.c b/tools/perf/util/rbtree.c
deleted file mode 100644
index b15ba9c..0000000
--- a/tools/perf/util/rbtree.c
+++ /dev/null
@@ -1,383 +0,0 @@
-/*
-  Red Black Trees
-  (C) 1999  Andrea Arcangeli <andrea@suse.de>
-  (C) 2002  David Woodhouse <dwmw2@infradead.org>
-  
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-
-  linux/lib/rbtree.c
-*/
-
-#include "rbtree.h"
-
-static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *right = node->rb_right;
-	struct rb_node *parent = rb_parent(node);
-
-	if ((node->rb_right = right->rb_left))
-		rb_set_parent(right->rb_left, node);
-	right->rb_left = node;
-
-	rb_set_parent(right, parent);
-
-	if (parent)
-	{
-		if (node == parent->rb_left)
-			parent->rb_left = right;
-		else
-			parent->rb_right = right;
-	}
-	else
-		root->rb_node = right;
-	rb_set_parent(node, right);
-}
-
-static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *left = node->rb_left;
-	struct rb_node *parent = rb_parent(node);
-
-	if ((node->rb_left = left->rb_right))
-		rb_set_parent(left->rb_right, node);
-	left->rb_right = node;
-
-	rb_set_parent(left, parent);
-
-	if (parent)
-	{
-		if (node == parent->rb_right)
-			parent->rb_right = left;
-		else
-			parent->rb_left = left;
-	}
-	else
-		root->rb_node = left;
-	rb_set_parent(node, left);
-}
-
-void rb_insert_color(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *parent, *gparent;
-
-	while ((parent = rb_parent(node)) && rb_is_red(parent))
-	{
-		gparent = rb_parent(parent);
-
-		if (parent == gparent->rb_left)
-		{
-			{
-				register struct rb_node *uncle = gparent->rb_right;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
-			}
-
-			if (parent->rb_right == node)
-			{
-				register struct rb_node *tmp;
-				__rb_rotate_left(parent, root);
-				tmp = parent;
-				parent = node;
-				node = tmp;
-			}
-
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_right(gparent, root);
-		} else {
-			{
-				register struct rb_node *uncle = gparent->rb_left;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
-			}
-
-			if (parent->rb_left == node)
-			{
-				register struct rb_node *tmp;
-				__rb_rotate_right(parent, root);
-				tmp = parent;
-				parent = node;
-				node = tmp;
-			}
-
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_left(gparent, root);
-		}
-	}
-
-	rb_set_black(root->rb_node);
-}
-
-static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
-			     struct rb_root *root)
-{
-	struct rb_node *other;
-
-	while ((!node || rb_is_black(node)) && node != root->rb_node)
-	{
-		if (parent->rb_left == node)
-		{
-			other = parent->rb_right;
-			if (rb_is_red(other))
-			{
-				rb_set_black(other);
-				rb_set_red(parent);
-				__rb_rotate_left(parent, root);
-				other = parent->rb_right;
-			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
-			}
-			else
-			{
-				if (!other->rb_right || rb_is_black(other->rb_right))
-				{
-					rb_set_black(other->rb_left);
-					rb_set_red(other);
-					__rb_rotate_right(other, root);
-					other = parent->rb_right;
-				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				rb_set_black(other->rb_right);
-				__rb_rotate_left(parent, root);
-				node = root->rb_node;
-				break;
-			}
-		}
-		else
-		{
-			other = parent->rb_left;
-			if (rb_is_red(other))
-			{
-				rb_set_black(other);
-				rb_set_red(parent);
-				__rb_rotate_right(parent, root);
-				other = parent->rb_left;
-			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
-			}
-			else
-			{
-				if (!other->rb_left || rb_is_black(other->rb_left))
-				{
-					rb_set_black(other->rb_right);
-					rb_set_red(other);
-					__rb_rotate_left(other, root);
-					other = parent->rb_left;
-				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				rb_set_black(other->rb_left);
-				__rb_rotate_right(parent, root);
-				node = root->rb_node;
-				break;
-			}
-		}
-	}
-	if (node)
-		rb_set_black(node);
-}
-
-void rb_erase(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *child, *parent;
-	int color;
-
-	if (!node->rb_left)
-		child = node->rb_right;
-	else if (!node->rb_right)
-		child = node->rb_left;
-	else
-	{
-		struct rb_node *old = node, *left;
-
-		node = node->rb_right;
-		while ((left = node->rb_left) != NULL)
-			node = left;
-		child = node->rb_right;
-		parent = rb_parent(node);
-		color = rb_color(node);
-
-		if (child)
-			rb_set_parent(child, parent);
-		if (parent == old) {
-			parent->rb_right = child;
-			parent = node;
-		} else
-			parent->rb_left = child;
-
-		node->rb_parent_color = old->rb_parent_color;
-		node->rb_right = old->rb_right;
-		node->rb_left = old->rb_left;
-
-		if (rb_parent(old))
-		{
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
-			else
-				rb_parent(old)->rb_right = node;
-		} else
-			root->rb_node = node;
-
-		rb_set_parent(old->rb_left, node);
-		if (old->rb_right)
-			rb_set_parent(old->rb_right, node);
-		goto color;
-	}
-
-	parent = rb_parent(node);
-	color = rb_color(node);
-
-	if (child)
-		rb_set_parent(child, parent);
-	if (parent)
-	{
-		if (parent->rb_left == node)
-			parent->rb_left = child;
-		else
-			parent->rb_right = child;
-	}
-	else
-		root->rb_node = child;
-
- color:
-	if (color == RB_BLACK)
-		__rb_erase_color(child, parent, root);
-}
-
-/*
- * This function returns the first node (in sort order) of the tree.
- */
-struct rb_node *rb_first(const struct rb_root *root)
-{
-	struct rb_node	*n;
-
-	n = root->rb_node;
-	if (!n)
-		return NULL;
-	while (n->rb_left)
-		n = n->rb_left;
-	return n;
-}
-
-struct rb_node *rb_last(const struct rb_root *root)
-{
-	struct rb_node	*n;
-
-	n = root->rb_node;
-	if (!n)
-		return NULL;
-	while (n->rb_right)
-		n = n->rb_right;
-	return n;
-}
-
-struct rb_node *rb_next(const struct rb_node *node)
-{
-	struct rb_node *parent;
-
-	if (rb_parent(node) == node)
-		return NULL;
-
-	/* If we have a right-hand child, go down and then left as far
-	   as we can. */
-	if (node->rb_right) {
-		node = node->rb_right; 
-		while (node->rb_left)
-			node=node->rb_left;
-		return (struct rb_node *)node;
-	}
-
-	/* No right-hand children.  Everything down and left is
-	   smaller than us, so any 'next' node must be in the general
-	   direction of our parent. Go up the tree; any time the
-	   ancestor is a right-hand child of its parent, keep going
-	   up. First time it's a left-hand child of its parent, said
-	   parent is our 'next' node. */
-	while ((parent = rb_parent(node)) && node == parent->rb_right)
-		node = parent;
-
-	return parent;
-}
-
-struct rb_node *rb_prev(const struct rb_node *node)
-{
-	struct rb_node *parent;
-
-	if (rb_parent(node) == node)
-		return NULL;
-
-	/* If we have a left-hand child, go down and then right as far
-	   as we can. */
-	if (node->rb_left) {
-		node = node->rb_left; 
-		while (node->rb_right)
-			node=node->rb_right;
-		return (struct rb_node *)node;
-	}
-
-	/* No left-hand children. Go up till we find an ancestor which
-	   is a right-hand child of its parent */
-	while ((parent = rb_parent(node)) && node == parent->rb_left)
-		node = parent;
-
-	return parent;
-}
-
-void rb_replace_node(struct rb_node *victim, struct rb_node *new,
-		     struct rb_root *root)
-{
-	struct rb_node *parent = rb_parent(victim);
-
-	/* Set the surrounding nodes to point to the replacement */
-	if (parent) {
-		if (victim == parent->rb_left)
-			parent->rb_left = new;
-		else
-			parent->rb_right = new;
-	} else {
-		root->rb_node = new;
-	}
-	if (victim->rb_left)
-		rb_set_parent(victim->rb_left, new);
-	if (victim->rb_right)
-		rb_set_parent(victim->rb_right, new);
-
-	/* Copy the pointers/colour from the victim to the replacement */
-	*new = *victim;
-}
diff --git a/tools/perf/util/rbtree.h b/tools/perf/util/rbtree.h
deleted file mode 100644
index 6bdc488..0000000
--- a/tools/perf/util/rbtree.h
+++ /dev/null
@@ -1,171 +0,0 @@
-/*
-  Red Black Trees
-  (C) 1999  Andrea Arcangeli <andrea@suse.de>
-  
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-
-  linux/include/linux/rbtree.h
-
-  To use rbtrees you'll have to implement your own insert and search cores.
-  This will avoid us to use callbacks and to drop drammatically performances.
-  I know it's not the cleaner way,  but in C (not in C++) to get
-  performances and genericity...
-
-  Some example of insert and search follows here. The search is a plain
-  normal search over an ordered tree. The insert instead must be implemented
-  int two steps: as first thing the code must insert the element in
-  order as a red leaf in the tree, then the support library function
-  rb_insert_color() must be called. Such function will do the
-  not trivial work to rebalance the rbtree if necessary.
-
------------------------------------------------------------------------
-static inline struct page * rb_search_page_cache(struct inode * inode,
-						 unsigned long offset)
-{
-	struct rb_node * n = inode->i_rb_page_cache.rb_node;
-	struct page * page;
-
-	while (n)
-	{
-		page = rb_entry(n, struct page, rb_page_cache);
-
-		if (offset < page->offset)
-			n = n->rb_left;
-		else if (offset > page->offset)
-			n = n->rb_right;
-		else
-			return page;
-	}
-	return NULL;
-}
-
-static inline struct page * __rb_insert_page_cache(struct inode * inode,
-						   unsigned long offset,
-						   struct rb_node * node)
-{
-	struct rb_node ** p = &inode->i_rb_page_cache.rb_node;
-	struct rb_node * parent = NULL;
-	struct page * page;
-
-	while (*p)
-	{
-		parent = *p;
-		page = rb_entry(parent, struct page, rb_page_cache);
-
-		if (offset < page->offset)
-			p = &(*p)->rb_left;
-		else if (offset > page->offset)
-			p = &(*p)->rb_right;
-		else
-			return page;
-	}
-
-	rb_link_node(node, parent, p);
-
-	return NULL;
-}
-
-static inline struct page * rb_insert_page_cache(struct inode * inode,
-						 unsigned long offset,
-						 struct rb_node * node)
-{
-	struct page * ret;
-	if ((ret = __rb_insert_page_cache(inode, offset, node)))
-		goto out;
-	rb_insert_color(node, &inode->i_rb_page_cache);
- out:
-	return ret;
-}
------------------------------------------------------------------------
-*/
-
-#ifndef	_LINUX_RBTREE_H
-#define	_LINUX_RBTREE_H
-
-#include <stddef.h>
-
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
-
-struct rb_node
-{
-	unsigned long  rb_parent_color;
-#define	RB_RED		0
-#define	RB_BLACK	1
-	struct rb_node *rb_right;
-	struct rb_node *rb_left;
-} __attribute__((aligned(sizeof(long))));
-    /* The alignment might seem pointless, but allegedly CRIS needs it */
-
-struct rb_root
-{
-	struct rb_node *rb_node;
-};
-
-
-#define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
-#define rb_color(r)   ((r)->rb_parent_color & 1)
-#define rb_is_red(r)   (!rb_color(r))
-#define rb_is_black(r) rb_color(r)
-#define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
-#define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
-
-static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & 3) | (unsigned long)p;
-}
-static inline void rb_set_color(struct rb_node *rb, int color)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
-}
-
-#define RB_ROOT	(struct rb_root) { NULL, }
-#define	rb_entry(ptr, type, member) container_of(ptr, type, member)
-
-#define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
-#define RB_EMPTY_NODE(node)	(rb_parent(node) == node)
-#define RB_CLEAR_NODE(node)	(rb_set_parent(node, node))
-
-extern void rb_insert_color(struct rb_node *, struct rb_root *);
-extern void rb_erase(struct rb_node *, struct rb_root *);
-
-/* Find logical next and previous nodes in a tree */
-extern struct rb_node *rb_next(const struct rb_node *);
-extern struct rb_node *rb_prev(const struct rb_node *);
-extern struct rb_node *rb_first(const struct rb_root *);
-extern struct rb_node *rb_last(const struct rb_root *);
-
-/* Fast replacement of a single node without remove/rebalance/add/rebalance */
-extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
-			    struct rb_root *root);
-
-static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
-				struct rb_node ** rb_link)
-{
-	node->rb_parent_color = (unsigned long )parent;
-	node->rb_left = node->rb_right = NULL;
-
-	*rb_link = node;
-}
-
-#endif	/* _LINUX_RBTREE_H */
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 464e7ca..5249d5a 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -16,7 +16,7 @@ int prefixcmp(const char *str, const char *prefix)
  */
 char strbuf_slopbuf[1];
 
-void strbuf_init(struct strbuf *sb, size_t hint)
+void strbuf_init(struct strbuf *sb, ssize_t hint)
 {
 	sb->alloc = sb->len = 0;
 	sb->buf = strbuf_slopbuf;
@@ -92,7 +92,8 @@ void strbuf_ltrim(struct strbuf *sb)
 
 void strbuf_tolower(struct strbuf *sb)
 {
-	int i;
+	unsigned int i;
+
 	for (i = 0; i < sb->len; i++)
 		sb->buf[i] = tolower(sb->buf[i]);
 }
@@ -264,7 +265,7 @@ size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
 	return res;
 }
 
-ssize_t strbuf_read(struct strbuf *sb, int fd, size_t hint)
+ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
 {
 	size_t oldlen = sb->len;
 	size_t oldalloc = sb->alloc;
@@ -293,7 +294,7 @@ ssize_t strbuf_read(struct strbuf *sb, int fd, size_t hint)
 
 #define STRBUF_MAXLINK (2*PATH_MAX)
 
-int strbuf_readlink(struct strbuf *sb, const char *path, size_t hint)
+int strbuf_readlink(struct strbuf *sb, const char *path, ssize_t hint)
 {
 	size_t oldalloc = sb->alloc;
 
@@ -301,7 +302,7 @@ int strbuf_readlink(struct strbuf *sb, const char *path, size_t hint)
 		hint = 32;
 
 	while (hint < STRBUF_MAXLINK) {
-		int len;
+		ssize_t len;
 
 		strbuf_grow(sb, hint);
 		len = readlink(path, sb->buf, hint);
@@ -343,7 +344,7 @@ int strbuf_getline(struct strbuf *sb, FILE *fp, int term)
 	return 0;
 }
 
-int strbuf_read_file(struct strbuf *sb, const char *path, size_t hint)
+int strbuf_read_file(struct strbuf *sb, const char *path, ssize_t hint)
 {
 	int fd, len;
 
diff --git a/tools/perf/util/strbuf.h b/tools/perf/util/strbuf.h
index 9ee908a..d2aa86c 100644
--- a/tools/perf/util/strbuf.h
+++ b/tools/perf/util/strbuf.h
@@ -50,7 +50,7 @@ struct strbuf {
 #define STRBUF_INIT  { 0, 0, strbuf_slopbuf }
 
 /*----- strbuf life cycle -----*/
-extern void strbuf_init(struct strbuf *, size_t);
+extern void strbuf_init(struct strbuf *buf, ssize_t hint);
 extern void strbuf_release(struct strbuf *);
 extern char *strbuf_detach(struct strbuf *, size_t *);
 extern void strbuf_attach(struct strbuf *, void *, size_t, size_t);
@@ -61,7 +61,7 @@ static inline void strbuf_swap(struct strbuf *a, struct strbuf *b) {
 }
 
 /*----- strbuf size related -----*/
-static inline size_t strbuf_avail(const struct strbuf *sb) {
+static inline ssize_t strbuf_avail(const struct strbuf *sb) {
 	return sb->alloc ? sb->alloc - sb->len - 1 : 0;
 }
 
@@ -122,9 +122,9 @@ extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
 
 extern size_t strbuf_fread(struct strbuf *, size_t, FILE *);
 /* XXX: if read fails, any partial read is undone */
-extern ssize_t strbuf_read(struct strbuf *, int fd, size_t hint);
-extern int strbuf_read_file(struct strbuf *sb, const char *path, size_t hint);
-extern int strbuf_readlink(struct strbuf *sb, const char *path, size_t hint);
+extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
+extern int strbuf_read_file(struct strbuf *sb, const char *path, ssize_t hint);
+extern int strbuf_readlink(struct strbuf *sb, const char *path, ssize_t hint);
 
 extern int strbuf_getline(struct strbuf *, FILE *, int);
 
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 2fb117f..2fdcfee 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -1,7 +1,7 @@
 #ifndef STRLIST_H_
 #define STRLIST_H_
 
-#include "rbtree.h"
+#include <linux/rbtree.h>
 #include <stdbool.h>
 
 struct str_node {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 78c2efd..4683b67 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -35,7 +35,7 @@ static struct symbol *symbol__new(u64 start, u64 len,
 		self = ((void *)self) + priv_size;
 	}
 	self->start = start;
-	self->end   = start + len - 1;
+	self->end   = len ? start + len - 1 : start;
 	memcpy(self->name, name, namelen);
 
 	return self;
@@ -48,8 +48,12 @@ static void symbol__delete(struct symbol *self, unsigned int priv_size)
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 {
-	return fprintf(fp, " %llx-%llx %s\n",
+	if (!self->module)
+		return fprintf(fp, " %llx-%llx %s\n",
 		       self->start, self->end, self->name);
+	else
+		return fprintf(fp, " %llx-%llx %s \t[%s]\n",
+		       self->start, self->end, self->name, self->module->name);
 }
 
 struct dso *dso__new(const char *name, unsigned int sym_priv_size)
@@ -146,6 +150,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 	char *line = NULL;
 	size_t n;
 	FILE *file = fopen("/proc/kallsyms", "r");
+	int count = 0;
 
 	if (file == NULL)
 		goto out_failure;
@@ -188,8 +193,10 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 
 		if (filter && filter(self, sym))
 			symbol__delete(sym, self->sym_priv_size);
-		else
+		else {
 			dso__insert_symbol(self, sym);
+			count++;
+		}
 	}
 
 	/*
@@ -212,7 +219,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 	free(line);
 	fclose(file);
 
-	return 0;
+	return count;
 
 out_delete_line:
 	free(line);
@@ -307,6 +314,26 @@ static inline int elf_sym__is_function(const GElf_Sym *sym)
 	       sym->st_size != 0;
 }
 
+static inline int elf_sym__is_label(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_NOTYPE &&
+		sym->st_name != 0 &&
+		sym->st_shndx != SHN_UNDEF &&
+		sym->st_shndx != SHN_ABS;
+}
+
+static inline const char *elf_sec__name(const GElf_Shdr *shdr,
+					const Elf_Data *secstrs)
+{
+	return secstrs->d_buf + shdr->sh_name;
+}
+
+static inline int elf_sec__is_text(const GElf_Shdr *shdr,
+					const Elf_Data *secstrs)
+{
+	return strstr(elf_sec__name(shdr, secstrs), "text") != NULL;
+}
+
 static inline const char *elf_sym__name(const GElf_Sym *sym,
 					const Elf_Data *symstrs)
 {
@@ -448,9 +475,9 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
 }
 
 static int dso__load_sym(struct dso *self, int fd, const char *name,
-			 symbol_filter_t filter, int verbose)
+			 symbol_filter_t filter, int verbose, struct module *mod)
 {
-	Elf_Data *symstrs;
+	Elf_Data *symstrs, *secstrs;
 	uint32_t nr_syms;
 	int err = -1;
 	uint32_t index;
@@ -458,7 +485,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	GElf_Shdr shdr;
 	Elf_Data *syms;
 	GElf_Sym sym;
-	Elf_Scn *sec, *sec_dynsym;
+	Elf_Scn *sec, *sec_dynsym, *sec_strndx;
 	Elf *elf;
 	size_t dynsym_idx;
 	int nr = 0;
@@ -517,17 +544,29 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	if (symstrs == NULL)
 		goto out_elf_end;
 
+	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
+	if (sec_strndx == NULL)
+		goto out_elf_end;
+
+	secstrs = elf_getdata(sec_strndx, NULL);
+	if (symstrs == NULL)
+		goto out_elf_end;
+
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	self->prelinked = elf_section_by_name(elf, &ehdr, &shdr,
-					      ".gnu.prelink_undo",
-					      NULL) != NULL;
+	self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+				elf_section_by_name(elf, &ehdr, &shdr,
+						     ".gnu.prelink_undo",
+						     NULL) != NULL);
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		u64 obj_start;
+		struct section *section = NULL;
+		int is_label = elf_sym__is_label(&sym);
+		const char *section_name;
 
-		if (!elf_sym__is_function(&sym))
+		if (!is_label && !elf_sym__is_function(&sym))
 			continue;
 
 		sec = elf_getscn(elf, sym.st_shndx);
@@ -535,9 +574,14 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 			goto out_elf_end;
 
 		gelf_getshdr(sec, &shdr);
+
+		if (is_label && !elf_sec__is_text(&shdr, secstrs))
+			continue;
+
+		section_name = elf_sec__name(&shdr, secstrs);
 		obj_start = sym.st_value;
 
-		if (self->prelinked) {
+		if (self->adjust_symbols) {
 			if (verbose >= 2)
 				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
 					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
@@ -545,6 +589,17 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 		}
 
+		if (mod) {
+			section = mod->sections->find_section(mod->sections, section_name);
+			if (section)
+				sym.st_value += section->vma;
+			else {
+				fprintf(stderr, "dso__load_sym() module %s lookup of %s failed\n",
+					mod->name, section_name);
+				goto out_elf_end;
+			}
+		}
+
 		f = symbol__new(sym.st_value, sym.st_size,
 				elf_sym__name(&sym, symstrs),
 				self->sym_priv_size, obj_start, verbose);
@@ -554,6 +609,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		if (filter && filter(self, f))
 			symbol__delete(f, self->sym_priv_size);
 		else {
+			f->module = mod;
 			dso__insert_symbol(self, f);
 			nr++;
 		}
@@ -577,7 +633,7 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 	if (!name)
 		return -1;
 
-	self->prelinked = 0;
+	self->adjust_symbols = 0;
 
 	if (strncmp(self->name, "/tmp/perf-", 10) == 0)
 		return dso__load_perf_map(self, filter, verbose);
@@ -603,7 +659,7 @@ more:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
-	ret = dso__load_sym(self, fd, name, filter, verbose);
+	ret = dso__load_sym(self, fd, name, filter, verbose, NULL);
 	close(fd);
 
 	/*
@@ -617,6 +673,86 @@ out:
 	return ret;
 }
 
+static int dso__load_module(struct dso *self, struct mod_dso *mods, const char *name,
+			     symbol_filter_t filter, int verbose)
+{
+	struct module *mod = mod_dso__find_module(mods, name);
+	int err = 0, fd;
+
+	if (mod == NULL || !mod->active)
+		return err;
+
+	fd = open(mod->path, O_RDONLY);
+
+	if (fd < 0)
+		return err;
+
+	err = dso__load_sym(self, fd, name, filter, verbose, mod);
+	close(fd);
+
+	return err;
+}
+
+int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose)
+{
+	struct mod_dso *mods = mod_dso__new_dso("modules");
+	struct module *pos;
+	struct rb_node *next;
+	int err;
+
+	err = mod_dso__load_modules(mods);
+
+	if (err <= 0)
+		return err;
+
+	/*
+	 * Iterate over modules, and load active symbols.
+	 */
+	next = rb_first(&mods->mods);
+	while (next) {
+		pos = rb_entry(next, struct module, rb_node);
+		err = dso__load_module(self, mods, pos->name, filter, verbose);
+
+		if (err < 0)
+			break;
+
+		next = rb_next(&pos->rb_node);
+	}
+
+	if (err < 0) {
+		mod_dso__delete_modules(mods);
+		mod_dso__delete_self(mods);
+	}
+
+	return err;
+}
+
+static inline void dso__fill_symbol_holes(struct dso *self)
+{
+	struct symbol *prev = NULL;
+	struct rb_node *nd;
+
+	for (nd = rb_last(&self->syms); nd; nd = rb_prev(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+
+		if (prev) {
+			u64 hole = 0;
+			int alias = pos->start == prev->start;
+
+			if (!alias)
+				hole = prev->start - pos->end - 1;
+
+			if (hole || alias) {
+				if (alias)
+					pos->end = prev->end;
+				else if (hole)
+					pos->end = prev->start - 1;
+			}
+		}
+		prev = pos;
+	}
+}
+
 static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
 			     symbol_filter_t filter, int verbose)
 {
@@ -625,21 +761,28 @@ static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
 	if (fd < 0)
 		return -1;
 
-	err = dso__load_sym(self, fd, vmlinux, filter, verbose);
+	err = dso__load_sym(self, fd, vmlinux, filter, verbose, NULL);
+
+	if (err > 0)
+		dso__fill_symbol_holes(self);
+
 	close(fd);
 
 	return err;
 }
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
-		     symbol_filter_t filter, int verbose)
+		     symbol_filter_t filter, int verbose, int modules)
 {
 	int err = -1;
 
-	if (vmlinux)
+	if (vmlinux) {
 		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
+		if (err > 0 && modules)
+			err = dso__load_modules(self, filter, verbose);
+	}
 
-	if (err < 0)
+	if (err <= 0)
 		err = dso__load_kallsyms(self, filter, verbose);
 
 	return err;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2c48ace..7918cff 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -3,8 +3,9 @@
 
 #include <linux/types.h>
 #include "types.h"
-#include "list.h"
-#include "rbtree.h"
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include "module.h"
 
 struct symbol {
 	struct rb_node	rb_node;
@@ -13,6 +14,7 @@ struct symbol {
 	u64		obj_start;
 	u64		hist_sum;
 	u64		*hist;
+	struct module	*module;
 	void		*priv;
 	char		name[0];
 };
@@ -22,7 +24,7 @@ struct dso {
 	struct rb_root	 syms;
 	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
 	unsigned int	 sym_priv_size;
-	unsigned char	 prelinked;
+	unsigned char	 adjust_symbols;
 	char		 name[0];
 };
 
@@ -41,7 +43,8 @@ static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
-		     symbol_filter_t filter, int verbose);
+		     symbol_filter_t filter, int verbose, int modules);
+int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose);
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index 6350d65..4574ac2 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -7,7 +7,7 @@
  * There's no pack memory to release - but stay close to the Git
  * version so wrap this away:
  */
-static inline void release_pack_memory(size_t size, int flag)
+static inline void release_pack_memory(size_t size __used, int flag __used)
 {
 }
 
@@ -59,7 +59,8 @@ void *xmemdupz(const void *data, size_t len)
 char *xstrndup(const char *str, size_t len)
 {
 	char *p = memchr(str, '\0', len);
-	return xmemdupz(str, p ? p - str : len);
+
+	return xmemdupz(str, p ? (size_t)(p - str) : len);
 }
 
 void *xrealloc(void *ptr, size_t size)
