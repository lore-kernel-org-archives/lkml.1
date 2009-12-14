Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbZLNQZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbZLNQZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbZLNQZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:25:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52195 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757801AbZLNQZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:25:01 -0500
Date: Mon, 14 Dec 2009 17:24:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates
Message-ID: <20091214162435.GA16291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (8):
      perf symbols: Rename kthreads to kmaps, using another abstraction for it
      perf symbols: Introduce symbol_type__is_a
      perf symbols: Introduce ELF counterparts to symbol_type__is_a
      perf symbols: Add support for 'variable' symtabs
      perf symbols: Add missing "Variables" entry to map_type__name
      perf symbols: Allow lookups by symbol name too
      perf symbols: Ditch dso->find_symbol
      perf tools: Introduce perf_session class

David Miller (1):
      perf sched: Fix build failure on sparc

Frederic Weisbecker (1):
      hw-breakpoints: Handle bad modify_user_hw_breakpoint off-case return value

Hitoshi Mitake (1):
      perf bench: Add "all" pseudo subsystem and "all" pseudo suite

Jamie Iles (2):
      perf tools: Allow cross compiling
      perf tools: Allow building for ARM

Li Zefan (2):
      tracing, slab: Define kmem_cache_alloc_notrace ifdef CONFIG_TRACING
      tracing, slab: Fix no callsite ifndef CONFIG_KMEMTRACE


 include/linux/hw_breakpoint.h      |    2 +-
 include/linux/slab_def.h           |    4 +-
 include/linux/slub_def.h           |    4 +-
 mm/slab.c                          |   12 +-
 mm/slub.c                          |    4 +-
 tools/perf/Makefile                |    9 +-
 tools/perf/bench/sched-messaging.c |    8 +-
 tools/perf/bench/sched-pipe.c      |   11 +-
 tools/perf/builtin-annotate.c      |   15 ++-
 tools/perf/builtin-bench.c         |   57 +++++++-
 tools/perf/builtin-buildid-list.c  |   55 +-------
 tools/perf/builtin-kmem.c          |   15 ++-
 tools/perf/builtin-record.c        |   25 ++--
 tools/perf/builtin-report.c        |   20 ++-
 tools/perf/builtin-sched.c         |   13 ++-
 tools/perf/builtin-timechart.c     |   15 ++-
 tools/perf/builtin-trace.c         |   20 ++-
 tools/perf/perf.h                  |   12 ++
 tools/perf/util/data_map.c         |   71 ++--------
 tools/perf/util/data_map.h         |    9 +-
 tools/perf/util/event.c            |   11 +-
 tools/perf/util/event.h            |    7 +-
 tools/perf/util/header.c           |   28 +---
 tools/perf/util/header.h           |    4 +-
 tools/perf/util/map.c              |   87 +++++++-----
 tools/perf/util/session.c          |   80 +++++++++++
 tools/perf/util/session.h          |   16 ++
 tools/perf/util/symbol.c           |  268 ++++++++++++++++++++++++++++--------
 tools/perf/util/symbol.h           |   17 ++-
 tools/perf/util/thread.c           |   63 +++++----
 tools/perf/util/thread.h           |   42 ++++--
 31 files changed, 651 insertions(+), 353 deletions(-)
 create mode 100644 tools/perf/util/session.c
 create mode 100644 tools/perf/util/session.h

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 69f07a9..41235c9 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -93,7 +93,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    struct task_struct *tsk)	{ return NULL; }
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr)	{ return NULL; }
+			  struct perf_event_attr *attr)	{ return -ENOSYS; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 850d057..ca6b2b3 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -110,7 +110,7 @@ extern struct cache_sizes malloc_sizes[];
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags);
 extern size_t slab_buffer_size(struct kmem_cache *cachep);
 #else
@@ -166,7 +166,7 @@ found:
 extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
 					   gfp_t flags,
 					   int nodeid);
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 5ad70a6..1e14beb 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -217,7 +217,7 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags);
 #else
 static __always_inline void *
@@ -266,7 +266,7 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
 					   gfp_t gfpflags,
 					   int node);
diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..c3d092d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -490,7 +490,7 @@ static void **dbg_userword(struct kmem_cache *cachep, void *objp)
 
 #endif
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 size_t slab_buffer_size(struct kmem_cache *cachep)
 {
 	return cachep->buffer_size;
@@ -3558,7 +3558,7 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags)
 {
 	return __cache_alloc(cachep, flags, __builtin_return_address(0));
@@ -3621,7 +3621,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
 				    gfp_t flags,
 				    int nodeid)
@@ -3649,7 +3649,7 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 	return ret;
 }
 
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_KMEMTRACE)
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __do_kmalloc_node(size, flags, node,
@@ -3669,7 +3669,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	return __do_kmalloc_node(size, flags, node, NULL);
 }
 EXPORT_SYMBOL(__kmalloc_node);
-#endif /* CONFIG_DEBUG_SLAB */
+#endif /* CONFIG_DEBUG_SLAB || CONFIG_TRACING */
 #endif /* CONFIG_NUMA */
 
 /**
@@ -3701,7 +3701,7 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 }
 
 
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_KMEMTRACE)
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	return __do_kmalloc(size, flags, __builtin_return_address(0));
diff --git a/mm/slub.c b/mm/slub.c
index 4996fc7..4a89c3d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1754,7 +1754,7 @@ void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags)
 {
 	return slab_alloc(s, gfpflags, -1, _RET_IP_);
@@ -1775,7 +1775,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
 
-#ifdef CONFIG_KMEMTRACE
+#ifdef CONFIG_TRACING
 void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
 				    gfp_t gfpflags,
 				    int node)
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 23ec660..4069996 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -237,8 +237,8 @@ lib = lib
 
 export prefix bindir sharedir sysconfdir
 
-CC = gcc
-AR = ar
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
 RM = rm -f
 TAR = tar
 FIND = find
@@ -356,7 +356,9 @@ LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
 LIB_H += util/util.h
+LIB_H += util/header.h
 LIB_H += util/help.h
+LIB_H += util/session.h
 LIB_H += util/strbuf.h
 LIB_H += util/string.h
 LIB_H += util/strlist.h
@@ -405,6 +407,7 @@ LIB_OBJS += util/callchain.o
 LIB_OBJS += util/values.o
 LIB_OBJS += util/debug.o
 LIB_OBJS += util/map.o
+LIB_OBJS += util/session.o
 LIB_OBJS += util/thread.o
 LIB_OBJS += util/trace-event-parse.o
 LIB_OBJS += util/trace-event-read.o
@@ -492,8 +495,10 @@ else
 	LIB_OBJS += util/probe-finder.o
 endif
 
+ifndef NO_LIBPERL
 PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
 PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+endif
 
 ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; echo 'int main(void) { perl_alloc(); return 0; }') | $(CC) -x c - $(PERL_EMBED_CCOPTS) -o /dev/null $(PERL_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
 	BASIC_CFLAGS += -DNO_LIBPERL
diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 605a2a9..81cee78 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -1,6 +1,6 @@
 /*
  *
- * builtin-bench-messaging.c
+ * sched-messaging.c
  *
  * messaging: Benchmark for scheduler and IPC mechanisms
  *
@@ -320,10 +320,12 @@ int bench_sched_messaging(int argc, const char **argv,
 		       num_groups, num_groups * 2 * num_fds,
 		       thread_mode ? "threads" : "processes");
 		printf(" %14s: %lu.%03lu [sec]\n", "Total time",
-		       diff.tv_sec, diff.tv_usec/1000);
+		       diff.tv_sec,
+		       (unsigned long) (diff.tv_usec/1000));
 		break;
 	case BENCH_FORMAT_SIMPLE:
-		printf("%lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
+		printf("%lu.%03lu\n", diff.tv_sec,
+		       (unsigned long) (diff.tv_usec/1000));
 		break;
 	default:
 		/* reaching here is something disaster */
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 238185f..4f77c7c 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -1,6 +1,6 @@
 /*
  *
- * builtin-bench-pipe.c
+ * sched-pipe.c
  *
  * pipe: Benchmark for pipe()
  *
@@ -87,7 +87,8 @@ int bench_sched_pipe(int argc, const char **argv,
 	if (pid) {
 		retpid = waitpid(pid, &wait_stat, 0);
 		assert((retpid == pid) && WIFEXITED(wait_stat));
-		return 0;
+	} else {
+		exit(0);
 	}
 
 	switch (bench_format) {
@@ -99,7 +100,8 @@ int bench_sched_pipe(int argc, const char **argv,
 		result_usec += diff.tv_usec;
 
 		printf(" %14s: %lu.%03lu [sec]\n\n", "Total time",
-		       diff.tv_sec, diff.tv_usec/1000);
+		       diff.tv_sec,
+		       (unsigned long) (diff.tv_usec/1000));
 
 		printf(" %14lf usecs/op\n",
 		       (double)result_usec / (double)loops);
@@ -110,7 +112,8 @@ int bench_sched_pipe(int argc, const char **argv,
 
 	case BENCH_FORMAT_SIMPLE:
 		printf("%lu.%03lu\n",
-		       diff.tv_sec, diff.tv_usec / 1000);
+		       diff.tv_sec,
+		       (unsigned long) (diff.tv_usec / 1000));
 		break;
 
 	default:
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0bf2e8f..21a78d3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -25,6 +25,7 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
+#include "util/session.h"
 #include "util/data_map.h"
 
 static char		const *input_name = "perf.data";
@@ -462,21 +463,23 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_annotate(void)
 {
-	struct perf_header *header;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, force);
 	struct thread *idle;
 	int ret;
 
+	if (session == NULL)
+		return -ENOMEM;
+
 	idle = register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	ret = mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				      &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
 	if (ret)
-		return ret;
+		goto out_delete;
 
 	if (dump_trace) {
 		event__print_totals();
-		return 0;
+		goto out_delete;
 	}
 
 	if (verbose > 3)
@@ -489,6 +492,8 @@ static int __cmd_annotate(void)
 	output__resort(event__total[0]);
 
 	find_annotations();
+out_delete:
+	perf_session__delete(session);
 
 	return ret;
 }
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e043eb8..4699677 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -31,6 +31,9 @@ struct bench_suite {
 	const char *summary;
 	int (*fn)(int, const char **, const char *);
 };
+						\
+/* sentinel: easy for help */
+#define suite_all { "all", "test all suite (pseudo suite)", NULL }
 
 static struct bench_suite sched_suites[] = {
 	{ "messaging",
@@ -39,6 +42,7 @@ static struct bench_suite sched_suites[] = {
 	{ "pipe",
 	  "Flood of communication over pipe() between two processes",
 	  bench_sched_pipe      },
+	suite_all,
 	{ NULL,
 	  NULL,
 	  NULL                  }
@@ -48,6 +52,7 @@ static struct bench_suite mem_suites[] = {
 	{ "memcpy",
 	  "Simple memory copy in various ways",
 	  bench_mem_memcpy },
+	suite_all,
 	{ NULL,
 	  NULL,
 	  NULL             }
@@ -66,6 +71,9 @@ static struct bench_subsys subsystems[] = {
 	{ "mem",
 	  "memory access performance",
 	  mem_suites },
+	{ "all",		/* sentinel: easy for help */
+	  "test all subsystem (pseudo subsystem)",
+	  NULL },
 	{ NULL,
 	  NULL,
 	  NULL       }
@@ -75,11 +83,11 @@ static void dump_suites(int subsys_index)
 {
 	int i;
 
-	printf("List of available suites for %s...\n\n",
+	printf("# List of available suites for %s...\n\n",
 	       subsystems[subsys_index].name);
 
 	for (i = 0; subsystems[subsys_index].suites[i].name; i++)
-		printf("\t%s: %s\n",
+		printf("%14s: %s\n",
 		       subsystems[subsys_index].suites[i].name,
 		       subsystems[subsys_index].suites[i].summary);
 
@@ -110,10 +118,10 @@ static void print_usage(void)
 		printf("\t%s\n", bench_usage[i]);
 	printf("\n");
 
-	printf("List of available subsystems...\n\n");
+	printf("# List of available subsystems...\n\n");
 
 	for (i = 0; subsystems[i].name; i++)
-		printf("\t%s: %s\n",
+		printf("%14s: %s\n",
 		       subsystems[i].name, subsystems[i].summary);
 	printf("\n");
 }
@@ -131,6 +139,37 @@ static int bench_str2int(char *str)
 	return BENCH_FORMAT_UNKNOWN;
 }
 
+static void all_suite(struct bench_subsys *subsys)	  /* FROM HERE */
+{
+	int i;
+	const char *argv[2];
+	struct bench_suite *suites = subsys->suites;
+
+	argv[1] = NULL;
+	/*
+	 * TODO:
+	 * preparing preset parameters for
+	 * embedded, ordinary PC, HPC, etc...
+	 * will be helpful
+	 */
+	for (i = 0; suites[i].fn; i++) {
+		printf("# Running %s/%s benchmark...\n",
+		       subsys->name,
+		       suites[i].name);
+
+		argv[1] = suites[i].name;
+		suites[i].fn(1, argv, NULL);
+		printf("\n");
+	}
+}
+
+static void all_subsystem(void)
+{
+	int i;
+	for (i = 0; subsystems[i].suites; i++)
+		all_suite(&subsystems[i]);
+}
+
 int cmd_bench(int argc, const char **argv, const char *prefix __used)
 {
 	int i, j, status = 0;
@@ -155,6 +194,11 @@ int cmd_bench(int argc, const char **argv, const char *prefix __used)
 		goto end;
 	}
 
+	if (!strcmp(argv[0], "all")) {
+		all_subsystem();
+		goto end;
+	}
+
 	for (i = 0; subsystems[i].name; i++) {
 		if (strcmp(subsystems[i].name, argv[0]))
 			continue;
@@ -165,6 +209,11 @@ int cmd_bench(int argc, const char **argv, const char *prefix __used)
 			goto end;
 		}
 
+		if (!strcmp(argv[1], "all")) {
+			all_suite(&subsystems[i]);
+			goto end;
+		}
+
 		for (j = 0; subsystems[i].suites[j].name; j++) {
 			if (strcmp(subsystems[i].suites[j].name, argv[1]))
 				continue;
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index dcb6143..bfd16a1 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -11,8 +11,8 @@
 #include "util/cache.h"
 #include "util/data_map.h"
 #include "util/debug.h"
-#include "util/header.h"
 #include "util/parse-options.h"
+#include "util/session.h"
 #include "util/symbol.h"
 
 static char const *input_name = "perf.data";
@@ -55,56 +55,17 @@ static int perf_file_section__process_buildids(struct perf_file_section *self,
 static int __cmd_buildid_list(void)
 {
 	int err = -1;
-	struct perf_header *header;
-	struct perf_file_header f_header;
-	struct stat input_stat;
-	int input = open(input_name, O_RDONLY);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, force);
 
-	if (input < 0) {
-		pr_err("failed to open file: %s", input_name);
-		if (!strcmp(input_name, "perf.data"))
-			pr_err("  (try 'perf record' first)");
-		pr_err("\n");
-		goto out;
-	}
-
-	err = fstat(input, &input_stat);
-	if (err < 0) {
-		perror("failed to stat file");
-		goto out_close;
-	}
-
-	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		pr_err("file %s not owned by current user or root\n",
-		       input_name);
-		goto out_close;
-	}
-
-	if (!input_stat.st_size) {
-		pr_info("zero-sized file, nothing to do!\n");
-		goto out_close;
-	}
-
-	err = -1;
-	header = perf_header__new();
-	if (header == NULL)
-		goto out_close;
-
-	if (perf_file_header__read(&f_header, header, input) < 0) {
-		pr_warning("incompatible file format");
-		goto out_close;
-	}
+	if (session == NULL)
+		return -1;
 
-	err = perf_header__process_sections(header, input,
+	err = perf_header__process_sections(&session->header, session->fd,
 				         perf_file_section__process_buildids);
+	if (err >= 0)
+		dsos__fprintf_buildid(stdout);
 
-	if (err < 0)
-		goto out_close;
-
-	dsos__fprintf_buildid(stdout);
-out_close:
-	close(input);
-out:
+	perf_session__delete(session);
 	return err;
 }
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 5f20951..2071d24 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -6,6 +6,7 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/header.h"
+#include "util/session.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -20,7 +21,6 @@ typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
 
 static char const		*input_name = "perf.data";
 
-static struct perf_header	*header;
 static u64			sample_type;
 
 static int			alloc_flag;
@@ -367,11 +367,18 @@ static struct perf_file_handler file_handler = {
 
 static int read_events(void)
 {
+	int err;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+
+	if (session == NULL)
+		return -ENOMEM;
+
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				       &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	perf_session__delete(session);
+	return err;
 }
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
@@ -403,7 +410,7 @@ static void __print_result(struct rb_root *root, int n_lines, int is_caller)
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = thread__find_function(kthread, addr, NULL);
+				sym = map_groups__find_function(kmaps, addr, NULL);
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0e519c6..4decbd1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -17,6 +17,7 @@
 #include "util/header.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/session.h"
 #include "util/symbol.h"
 
 #include <unistd.h>
@@ -62,7 +63,7 @@ static int			nr_cpu				=      0;
 
 static int			file_new			=      1;
 
-struct perf_header		*header				=   NULL;
+static struct perf_session	*session;
 
 struct mmap_data {
 	int			counter;
@@ -216,12 +217,12 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 {
 	struct perf_header_attr *h_attr;
 
-	if (nr < header->attrs) {
-		h_attr = header->attr[nr];
+	if (nr < session->header.attrs) {
+		h_attr = session->header.attr[nr];
 	} else {
 		h_attr = perf_header_attr__new(a);
 		if (h_attr != NULL)
-			if (perf_header__add_attr(header, h_attr) < 0) {
+			if (perf_header__add_attr(&session->header, h_attr) < 0) {
 				perf_header_attr__delete(h_attr);
 				h_attr = NULL;
 			}
@@ -395,9 +396,9 @@ static void open_counters(int cpu, pid_t pid)
 
 static void atexit_header(void)
 {
-	header->data_size += bytes_written;
+	session->header.data_size += bytes_written;
 
-	perf_header__write(header, output, true);
+	perf_header__write(&session->header, output, true);
 }
 
 static int __cmd_record(int argc, const char **argv)
@@ -440,24 +441,24 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	header = perf_header__new();
-	if (header == NULL) {
+	session = perf_session__new(output_name, O_WRONLY, force);
+	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
 	}
 
 	if (!file_new) {
-		err = perf_header__read(header, output);
+		err = perf_header__read(&session->header, output);
 		if (err < 0)
 			return err;
 	}
 
 	if (raw_samples) {
-		perf_header__set_feat(header, HEADER_TRACE_INFO);
+		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 	} else {
 		for (i = 0; i < nr_counters; i++) {
 			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
-				perf_header__set_feat(header, HEADER_TRACE_INFO);
+				perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 				break;
 			}
 		}
@@ -481,7 +482,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (file_new) {
-		err = perf_header__write(header, output, false);
+		err = perf_header__write(&session->header, output, false);
 		if (err < 0)
 			return err;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2b9eb3a..e2ec49a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -22,6 +22,7 @@
 #include "perf.h"
 #include "util/debug.h"
 #include "util/header.h"
+#include "util/session.h"
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -52,7 +53,7 @@ static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static struct perf_header *header;
+static struct perf_session *session;
 
 static u64		sample_type;
 
@@ -701,7 +702,7 @@ static int process_read_event(event_t *event)
 {
 	struct perf_event_attr *attr;
 
-	attr = perf_header__find_attr(event->read.id, header);
+	attr = perf_header__find_attr(event->read.id, &session->header);
 
 	if (show_threads) {
 		const char *name = attr ? __event_name(attr->type, attr->config)
@@ -766,6 +767,10 @@ static int __cmd_report(void)
 	struct thread *idle;
 	int ret;
 
+	session = perf_session__new(input_name, O_RDONLY, force);
+	if (session == NULL)
+		return -ENOMEM;
+
 	idle = register_idle_thread();
 	thread__comm_adjust(idle);
 
@@ -774,14 +779,14 @@ static int __cmd_report(void)
 
 	register_perf_file_handler(&file_handler);
 
-	ret = mmap_dispatch_perf_file(&header, input_name, force,
-				      full_paths, &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, full_paths,
+					   &event__cwdlen, &event__cwd);
 	if (ret)
-		return ret;
+		goto out_delete;
 
 	if (dump_trace) {
 		event__print_totals();
-		return 0;
+		goto out_delete;
 	}
 
 	if (verbose > 3)
@@ -796,7 +801,8 @@ static int __cmd_report(void)
 
 	if (show_threads)
 		perf_read_values_destroy(&show_threads_values);
-
+out_delete:
+	perf_session__delete(session);
 	return ret;
 }
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7cca7c1..65021fe 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -6,6 +6,7 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/header.h"
+#include "util/session.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -21,7 +22,6 @@
 
 static char			const *input_name = "perf.data";
 
-static struct perf_header	*header;
 static u64			sample_type;
 
 static char			default_sort_order[] = "avg, max, switch, runtime";
@@ -1663,11 +1663,18 @@ static struct perf_file_handler file_handler = {
 
 static int read_events(void)
 {
+	int err;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+
+	if (session == NULL)
+		return -ENOMEM;
+
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				       &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	perf_session__delete(session);
+	return err;
 }
 
 static void print_bad_events(void)
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index f472df9..759dd2b 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1059,15 +1059,17 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_timechart(void)
 {
-	struct perf_header *header;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
 	int ret;
 
+	if (session == NULL)
+		return -ENOMEM;
+
 	register_perf_file_handler(&file_handler);
 
-	ret = mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				      &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
 	if (ret)
-		return EXIT_FAILURE;
+		goto out_delete;
 
 	process_samples();
 
@@ -1079,8 +1081,9 @@ static int __cmd_timechart(void)
 
 	pr_info("Written %2.1f seconds of trace to %s.\n",
 		(last_time - first_time) / 1000000000.0, output_name);
-
-	return EXIT_SUCCESS;
+out_delete:
+	perf_session__delete(session);
+	return ret;
 }
 
 static const char * const timechart_usage[] = {
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c2fcc34..0756664 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -7,6 +7,7 @@
 #include "util/header.h"
 #include "util/exec_cmd.h"
 #include "util/trace-event.h"
+#include "util/session.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -61,7 +62,7 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static struct perf_header	*header;
+static struct perf_session 	*session;
 static u64			sample_type;
 
 static int process_sample_event(event_t *event)
@@ -126,11 +127,18 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_trace(void)
 {
+	int err;
+
+	session = perf_session__new(input_name, O_RDONLY, 0);
+	if (session == NULL)
+		return -ENOMEM;
+
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name,
-				       0, 0, &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	perf_session__delete(session);
+	return err;
 }
 
 struct script_spec {
@@ -348,11 +356,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			return -1;
 		}
 
-		header = perf_header__new();
-		if (header == NULL)
-			return -1;
-
-		perf_header__read(header, input);
+		perf_header__read(&session->header, input);
 		err = scripting_ops->generate_script("perf-trace");
 		goto out;
 	}
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 454d5d5..75f941b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -59,6 +59,18 @@
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #endif
 
+#ifdef __arm__
+#include "../../arch/arm/include/asm/unistd.h"
+/*
+ * Use the __kuser_memory_barrier helper in the CPU helper page. See
+ * arch/arm/kernel/entry-armv.S in the kernel source for details.
+ */
+#define rmb()		asm volatile("mov r0, #0xffff0fff; mov lr, pc;" \
+				     "sub pc, r0, #95" ::: "r0", "lr", "cc", \
+				     "memory")
+#define cpu_relax()	asm volatile("":::"memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 59b65d0..6d46dda 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -129,23 +129,16 @@ out:
 	return err;
 }
 
-int mmap_dispatch_perf_file(struct perf_header **pheader,
-			    const char *input_name,
-			    int force,
-			    int full_paths,
-			    int *cwdlen,
-			    char **cwd)
+int perf_session__process_events(struct perf_session *self,
+				 int full_paths, int *cwdlen, char **cwd)
 {
 	int err;
-	struct perf_header *header;
 	unsigned long head, shift;
 	unsigned long offset = 0;
-	struct stat input_stat;
 	size_t	page_size;
 	u64 sample_type;
 	event_t *event;
 	uint32_t size;
-	int input;
 	char *buf;
 
 	if (curr_handler == NULL) {
@@ -155,56 +148,19 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 
 	page_size = getpagesize();
 
-	input = open(input_name, O_RDONLY);
-	if (input < 0) {
-		pr_err("Failed to open file: %s", input_name);
-		if (!strcmp(input_name, "perf.data"))
-			pr_err("  (try 'perf record' first)");
-		pr_err("\n");
-		return -errno;
-	}
-
-	if (fstat(input, &input_stat) < 0) {
-		pr_err("failed to stat file");
-		err = -errno;
-		goto out_close;
-	}
-
-	err = -EACCES;
-	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		pr_err("file: %s not owned by current user or root\n",
-			input_name);
-		goto out_close;
-	}
-
-	if (input_stat.st_size == 0) {
-		pr_info("zero-sized file, nothing to do!\n");
-		goto done;
-	}
-
-	err = -ENOMEM;
-	header = perf_header__new();
-	if (header == NULL)
-		goto out_close;
-
-	err = perf_header__read(header, input);
-	if (err < 0)
-		goto out_delete;
-	*pheader = header;
-	head = header->data_offset;
-
-	sample_type = perf_header__sample_type(header);
+	head = self->header.data_offset;
+	sample_type = perf_header__sample_type(&self->header);
 
 	err = -EINVAL;
 	if (curr_handler->sample_type_check &&
 	    curr_handler->sample_type_check(sample_type) < 0)
-		goto out_delete;
+		goto out_err;
 
 	if (!full_paths) {
 		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
 			pr_err("failed to get the current directory\n");
 			err = -errno;
-			goto out_delete;
+			goto out_err;
 		}
 		*cwd = __cwd;
 		*cwdlen = strlen(*cwd);
@@ -219,11 +175,11 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 
 remap:
 	buf = mmap(NULL, page_size * mmap_window, PROT_READ,
-		   MAP_SHARED, input, offset);
+		   MAP_SHARED, self->fd, offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
 		err = -errno;
-		goto out_delete;
+		goto out_err;
 	}
 
 more:
@@ -273,19 +229,14 @@ more:
 
 	head += size;
 
-	if (offset + head >= header->data_offset + header->data_size)
+	if (offset + head >= self->header.data_offset + self->header.data_size)
 		goto done;
 
-	if (offset + head < (unsigned long)input_stat.st_size)
+	if (offset + head < self->size)
 		goto more;
 
 done:
 	err = 0;
-out_close:
-	close(input);
-
+out_err:
 	return err;
-out_delete:
-	perf_header__delete(header);
-	goto out_close;
 }
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index 258a87b..98c5b82 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -3,6 +3,7 @@
 
 #include "event.h"
 #include "header.h"
+#include "session.h"
 
 typedef int (*event_type_handler_t)(event_t *);
 
@@ -21,12 +22,8 @@ struct perf_file_handler {
 };
 
 void register_perf_file_handler(struct perf_file_handler *handler);
-int mmap_dispatch_perf_file(struct perf_header **pheader,
-			    const char *input_name,
-			    int force,
-			    int full_paths,
-			    int *cwdlen,
-			    char **cwd);
+int perf_session__process_events(struct perf_session *self,
+				 int full_paths, int *cwdlen, char **cwd);
 int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
 #endif
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 4dcecaf..ba0de90 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -254,13 +254,14 @@ void thread__find_addr_location(struct thread *self, u8 cpumode,
 				struct addr_location *al,
 				symbol_filter_t filter)
 {
-	struct thread *thread = al->thread = self;
+	struct map_groups *mg = &self->mg;
 
+	al->thread = self;
 	al->addr = addr;
 
 	if (cpumode & PERF_RECORD_MISC_KERNEL) {
 		al->level = 'k';
-		thread = kthread;
+		mg = kmaps;
 	} else if (cpumode & PERF_RECORD_MISC_USER)
 		al->level = '.';
 	else {
@@ -270,7 +271,7 @@ void thread__find_addr_location(struct thread *self, u8 cpumode,
 		return;
 	}
 try_again:
-	al->map = thread__find_map(thread, type, al->addr);
+	al->map = map_groups__find(mg, type, al->addr);
 	if (al->map == NULL) {
 		/*
 		 * If this is outside of all known maps, and is a negative
@@ -281,8 +282,8 @@ try_again:
 		 * "[vdso]" dso, but for now lets use the old trick of looking
 		 * in the whole kernel symbol list.
 		 */
-		if ((long long)al->addr < 0 && thread != kthread) {
-			thread = kthread;
+		if ((long long)al->addr < 0 && mg != kmaps) {
+			mg = kmaps;
 			goto try_again;
 		}
 		al->sym = NULL;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index c7a78ee..51a96c2 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -103,10 +103,11 @@ void event__print_totals(void);
 
 enum map_type {
 	MAP__FUNCTION = 0,
-
-	MAP__NR_TYPES,
+	MAP__VARIABLE,
 };
 
+#define MAP__NR_TYPES (MAP__VARIABLE + 1)
+
 struct map {
 	union {
 		struct rb_node	rb_node;
@@ -150,6 +151,8 @@ int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
 struct symbol *map__find_symbol(struct map *self, u64 addr,
 				symbol_filter_t filter);
+struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					symbol_filter_t filter);
 void map__fixup_start(struct map *self);
 void map__fixup_end(struct map *self);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 59a9c0b..f2e8d87 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -58,35 +58,19 @@ int perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
 	return 0;
 }
 
-/*
- * Create new perf.data header:
- */
-struct perf_header *perf_header__new(void)
+int perf_header__init(struct perf_header *self)
 {
-	struct perf_header *self = zalloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->size = 1;
-		self->attr = malloc(sizeof(void *));
-
-		if (self->attr == NULL) {
-			free(self);
-			self = NULL;
-		}
-	}
-
-	return self;
+	self->size = 1;
+	self->attr = malloc(sizeof(void *));
+	return self->attr == NULL ? -ENOMEM : 0;
 }
 
-void perf_header__delete(struct perf_header *self)
+void perf_header__exit(struct perf_header *self)
 {
 	int i;
-
 	for (i = 0; i < self->attrs; ++i)
-		perf_header_attr__delete(self->attr[i]);
-
+                perf_header_attr__delete(self->attr[i]);
 	free(self->attr);
-	free(self);
 }
 
 int perf_header__add_attr(struct perf_header *self,
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index d1dbe2b..d118d05 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -55,8 +55,8 @@ struct perf_header {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
-struct perf_header *perf_header__new(void);
-void perf_header__delete(struct perf_header *self);
+int perf_header__init(struct perf_header *self);
+void perf_header__exit(struct perf_header *self);
 
 int perf_header__read(struct perf_header *self, int fd);
 int perf_header__write(struct perf_header *self, int fd, bool at_exit);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 69f94fe..76bdca6 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -104,43 +104,64 @@ void map__fixup_end(struct map *self)
 
 #define DSO__DELETED "(deleted)"
 
-struct symbol *map__find_symbol(struct map *self, u64 addr,
-				symbol_filter_t filter)
+static int map__load(struct map *self, symbol_filter_t filter)
 {
-	if (!dso__loaded(self->dso, self->type)) {
-		int nr = dso__load(self->dso, self, filter);
-
-		if (nr < 0) {
-			if (self->dso->has_build_id) {
-				char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-				build_id__sprintf(self->dso->build_id,
-						  sizeof(self->dso->build_id),
-						  sbuild_id);
-				pr_warning("%s with build id %s not found",
-					   self->dso->long_name, sbuild_id);
-			} else
-				pr_warning("Failed to open %s",
-					   self->dso->long_name);
-			pr_warning(", continuing without symbols\n");
-			return NULL;
-		} else if (nr == 0) {
-			const char *name = self->dso->long_name;
-			const size_t len = strlen(name);
-			const size_t real_len = len - sizeof(DSO__DELETED);
-
-			if (len > sizeof(DSO__DELETED) &&
-			    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
-				pr_warning("%.*s was updated, restart the long running apps that use it!\n",
-					   (int)real_len, name);
-			} else {
-				pr_warning("no symbols found in %s, maybe install a debug package?\n", name);
-			}
-			return NULL;
+	const char *name = self->dso->long_name;
+	int nr = dso__load(self->dso, self, filter);
+
+	if (nr < 0) {
+		if (self->dso->has_build_id) {
+			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+			build_id__sprintf(self->dso->build_id,
+					  sizeof(self->dso->build_id),
+					  sbuild_id);
+			pr_warning("%s with build id %s not found",
+				   name, sbuild_id);
+		} else
+			pr_warning("Failed to open %s", name);
+
+		pr_warning(", continuing without symbols\n");
+		return -1;
+	} else if (nr == 0) {
+		const size_t len = strlen(name);
+		const size_t real_len = len - sizeof(DSO__DELETED);
+
+		if (len > sizeof(DSO__DELETED) &&
+		    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
+			pr_warning("%.*s was updated, restart the long "
+				   "running apps that use it!\n",
+				   (int)real_len, name);
+		} else {
+			pr_warning("no symbols found in %s, maybe install "
+				   "a debug package?\n", name);
 		}
+
+		return -1;
 	}
 
-	return self->dso->find_symbol(self->dso, self->type, addr);
+	return 0;
+}
+
+struct symbol *map__find_symbol(struct map *self, u64 addr,
+				symbol_filter_t filter)
+{
+	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
+		return NULL;
+
+	return dso__find_symbol(self->dso, self->type, addr);
+}
+
+struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					symbol_filter_t filter)
+{
+	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
+		return NULL;
+
+	if (!dso__sorted_by_name(self->dso, self->type))
+		dso__sort_by_name(self->dso, self->type);
+
+	return dso__find_symbol_by_name(self->dso, self->type, name);
 }
 
 struct map *map__clone(struct map *self)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
new file mode 100644
index 0000000..707ce1c
--- /dev/null
+++ b/tools/perf/util/session.c
@@ -0,0 +1,80 @@
+#include <linux/kernel.h>
+
+#include <unistd.h>
+#include <sys/types.h>
+
+#include "session.h"
+#include "util.h"
+
+static int perf_session__open(struct perf_session *self, bool force)
+{
+	struct stat input_stat;
+
+	self->fd = open(self->filename, O_RDONLY);
+	if (self->fd < 0) {
+		pr_err("failed to open file: %s", self->filename);
+		if (!strcmp(self->filename, "perf.data"))
+			pr_err("  (try 'perf record' first)");
+		pr_err("\n");
+		return -errno;
+	}
+
+	if (fstat(self->fd, &input_stat) < 0)
+		goto out_close;
+
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		pr_err("file %s not owned by current user or root\n",
+		       self->filename);
+		goto out_close;
+	}
+
+	if (!input_stat.st_size) {
+		pr_info("zero-sized file (%s), nothing to do!\n",
+			self->filename);
+		goto out_close;
+	}
+
+	if (perf_header__read(&self->header, self->fd) < 0) {
+		pr_err("incompatible file format");
+		goto out_close;
+	}
+
+	self->size = input_stat.st_size;
+	return 0;
+
+out_close:
+	close(self->fd);
+	self->fd = -1;
+	return -1;
+}
+
+struct perf_session *perf_session__new(const char *filename, int mode, bool force)
+{
+	size_t len = strlen(filename) + 1;
+	struct perf_session *self = zalloc(sizeof(*self) + len);
+
+	if (self == NULL)
+		goto out;
+
+	if (perf_header__init(&self->header) < 0)
+		goto out_delete;
+
+	memcpy(self->filename, filename, len);
+
+	if (mode == O_RDONLY && perf_session__open(self, force) < 0) {
+		perf_session__delete(self);
+		self = NULL;
+	}
+out:
+	return self;
+out_delete:
+	free(self);
+	return NULL;
+}
+
+void perf_session__delete(struct perf_session *self)
+{
+	perf_header__exit(&self->header);
+	close(self->fd);
+	free(self);
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
new file mode 100644
index 0000000..f3699c8
--- /dev/null
+++ b/tools/perf/util/session.h
@@ -0,0 +1,16 @@
+#ifndef __PERF_SESSION_H
+#define __PERF_SESSION_H
+
+#include "header.h"
+
+struct perf_session {
+	struct perf_header	header;
+	unsigned long		size;
+	int			fd;
+	char filename[0];
+};
+
+struct perf_session *perf_session__new(const char *filename, int mode, bool force);
+void perf_session__delete(struct perf_session *self);
+
+#endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e7508ad..d3d9fed 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -29,11 +29,9 @@ enum dso_origin {
 };
 
 static void dsos__add(struct list_head *head, struct dso *dso);
-static struct map *thread__find_map_by_name(struct thread *self, char *name);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
-struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct thread *thread, symbol_filter_t filter);
+				struct map_groups *mg, symbol_filter_t filter);
 unsigned int symbol__priv_size;
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
@@ -43,19 +41,41 @@ static struct symbol_conf symbol_conf__defaults = {
 	.try_vmlinux_path = true,
 };
 
-static struct thread kthread_mem;
-struct thread *kthread = &kthread_mem;
+static struct map_groups kmaps_mem;
+struct map_groups *kmaps = &kmaps_mem;
 
 bool dso__loaded(const struct dso *self, enum map_type type)
 {
 	return self->loaded & (1 << type);
 }
 
+bool dso__sorted_by_name(const struct dso *self, enum map_type type)
+{
+	return self->sorted_by_name & (1 << type);
+}
+
 static void dso__set_loaded(struct dso *self, enum map_type type)
 {
 	self->loaded |= (1 << type);
 }
 
+static void dso__set_sorted_by_name(struct dso *self, enum map_type type)
+{
+	self->sorted_by_name |= (1 << type);
+}
+
+static bool symbol_type__is_a(char symbol_type, enum map_type map_type)
+{
+	switch (map_type) {
+	case MAP__FUNCTION:
+		return symbol_type == 'T' || symbol_type == 'W';
+	case MAP__VARIABLE:
+		return symbol_type == 'D' || symbol_type == 'd';
+	default:
+		return false;
+	}
+}
+
 static void symbols__fixup_end(struct rb_root *self)
 {
 	struct rb_node *nd, *prevnd = rb_first(self);
@@ -79,7 +99,7 @@ static void symbols__fixup_end(struct rb_root *self)
 		curr->end = roundup(curr->start, 4096);
 }
 
-static void __thread__fixup_maps_end(struct thread *self, enum map_type type)
+static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
 {
 	struct map *prev, *curr;
 	struct rb_node *nd, *prevnd = rb_first(&self->maps[type]);
@@ -102,11 +122,11 @@ static void __thread__fixup_maps_end(struct thread *self, enum map_type type)
 	curr->end = ~0UL;
 }
 
-static void thread__fixup_maps_end(struct thread *self)
+static void map_groups__fixup_end(struct map_groups *self)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		__thread__fixup_maps_end(self, i);
+		__map_groups__fixup_end(self, i);
 }
 
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
@@ -164,11 +184,11 @@ struct dso *dso__new(const char *name)
 		dso__set_long_name(self, self->name);
 		self->short_name = self->name;
 		for (i = 0; i < MAP__NR_TYPES; ++i)
-			self->symbols[i] = RB_ROOT;
-		self->find_symbol = dso__find_symbol;
+			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
 		self->loaded = 0;
+		self->sorted_by_name = 0;
 		self->has_build_id = 0;
 	}
 
@@ -246,11 +266,85 @@ static struct symbol *symbols__find(struct rb_root *self, u64 ip)
 	return NULL;
 }
 
-struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr)
+struct symbol_name_rb_node {
+	struct rb_node	rb_node;
+	struct symbol	sym;
+};
+
+static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
+{
+	struct rb_node **p = &self->rb_node;
+	struct rb_node *parent = NULL;
+	struct symbol_name_rb_node *symn = ((void *)sym) - sizeof(*parent), *s;
+
+	while (*p != NULL) {
+		parent = *p;
+		s = rb_entry(parent, struct symbol_name_rb_node, rb_node);
+		if (strcmp(sym->name, s->sym.name) < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&symn->rb_node, parent, p);
+	rb_insert_color(&symn->rb_node, self);
+}
+
+static void symbols__sort_by_name(struct rb_root *self, struct rb_root *source)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(source); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+		symbols__insert_by_name(self, pos);
+	}
+}
+
+static struct symbol *symbols__find_by_name(struct rb_root *self, const char *name)
+{
+	struct rb_node *n;
+
+	if (self == NULL)
+		return NULL;
+
+	n = self->rb_node;
+
+	while (n) {
+		struct symbol_name_rb_node *s;
+		int cmp;
+
+		s = rb_entry(n, struct symbol_name_rb_node, rb_node);
+		cmp = strcmp(name, s->sym.name);
+
+		if (cmp < 0)
+			n = n->rb_left;
+		else if (cmp > 0)
+			n = n->rb_right;
+		else
+			return &s->sym;
+	}
+
+	return NULL;
+}
+
+struct symbol *dso__find_symbol(struct dso *self,
+				enum map_type type, u64 addr)
 {
 	return symbols__find(&self->symbols[type], addr);
 }
 
+struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+					const char *name)
+{
+	return symbols__find_by_name(&self->symbol_names[type], name);
+}
+
+void dso__sort_by_name(struct dso *self, enum map_type type)
+{
+	dso__set_sorted_by_name(self, type);
+	return symbols__sort_by_name(&self->symbol_names[type],
+				     &self->symbols[type]);
+}
+
 int build_id__sprintf(u8 *self, int len, char *bf)
 {
 	char *bid = bf;
@@ -327,10 +421,7 @@ static int dso__load_all_kallsyms(struct dso *self, struct map *map)
 			continue;
 
 		symbol_type = toupper(line[len]);
-		/*
-		 * We're interested only in code ('T'ext)
-		 */
-		if (symbol_type != 'T' && symbol_type != 'W')
+		if (!symbol_type__is_a(symbol_type, map->type))
 			continue;
 
 		symbol_name = line + len + 2;
@@ -364,8 +455,8 @@ out_failure:
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int dso__split_kallsyms(struct dso *self, struct map *map, struct thread *thread,
-			       symbol_filter_t filter)
+static int dso__split_kallsyms(struct dso *self, struct map *map,
+			       struct map_groups *mg, symbol_filter_t filter)
 {
 	struct map *curr_map = map;
 	struct symbol *pos;
@@ -382,13 +473,13 @@ static int dso__split_kallsyms(struct dso *self, struct map *map, struct thread
 
 		module = strchr(pos->name, '\t');
 		if (module) {
-			if (!thread->use_modules)
+			if (!mg->use_modules)
 				goto discard_symbol;
 
 			*module++ = '\0';
 
 			if (strcmp(self->name, module)) {
-				curr_map = thread__find_map_by_name(thread, module);
+				curr_map = map_groups__find_by_name(mg, map->type, module);
 				if (curr_map == NULL) {
 					pr_debug("/proc/{kallsyms,modules} "
 					         "inconsistency!\n");
@@ -419,7 +510,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map, struct thread
 			}
 
 			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
-			__thread__insert_map(thread, curr_map);
+			map_groups__insert(mg, curr_map);
 			++kernel_range;
 		}
 
@@ -440,7 +531,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 
 
 static int dso__load_kallsyms(struct dso *self, struct map *map,
-			      struct thread *thread, symbol_filter_t filter)
+			      struct map_groups *mg, symbol_filter_t filter)
 {
 	if (dso__load_all_kallsyms(self, map) < 0)
 		return -1;
@@ -448,13 +539,13 @@ static int dso__load_kallsyms(struct dso *self, struct map *map,
 	symbols__fixup_end(&self->symbols[map->type]);
 	self->origin = DSO__ORIG_KERNEL;
 
-	return dso__split_kallsyms(self, map, thread, filter);
+	return dso__split_kallsyms(self, map, mg, filter);
 }
 
 size_t kernel_maps__fprintf(FILE *fp)
 {
 	size_t printed = fprintf(fp, "Kernel maps:\n");
-	printed += thread__fprintf_maps(kthread, fp);
+	printed += map_groups__fprintf_maps(kmaps, fp);
 	return printed + fprintf(fp, "END kernel maps\n");
 }
 
@@ -544,6 +635,13 @@ static inline int elf_sym__is_function(const GElf_Sym *sym)
 	       sym->st_shndx != SHN_UNDEF;
 }
 
+static inline bool elf_sym__is_object(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_OBJECT &&
+		sym->st_name != 0 &&
+		sym->st_shndx != SHN_UNDEF;
+}
+
 static inline int elf_sym__is_label(const GElf_Sym *sym)
 {
 	return elf_sym__type(sym) == STT_NOTYPE &&
@@ -564,6 +662,12 @@ static inline int elf_sec__is_text(const GElf_Shdr *shdr,
 	return strstr(elf_sec__name(shdr, secstrs), "text") != NULL;
 }
 
+static inline bool elf_sec__is_data(const GElf_Shdr *shdr,
+				    const Elf_Data *secstrs)
+{
+	return strstr(elf_sec__name(shdr, secstrs), "data") != NULL;
+}
+
 static inline const char *elf_sym__name(const GElf_Sym *sym,
 					const Elf_Data *symstrs)
 {
@@ -744,8 +848,32 @@ out:
 	return 0;
 }
 
+static bool elf_sym__is_a(GElf_Sym *self, enum map_type type)
+{
+	switch (type) {
+	case MAP__FUNCTION:
+		return elf_sym__is_function(self);
+	case MAP__VARIABLE:
+		return elf_sym__is_object(self);
+	default:
+		return false;
+	}
+}
+
+static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type)
+{
+	switch (type) {
+	case MAP__FUNCTION:
+		return elf_sec__is_text(self, secstrs);
+	case MAP__VARIABLE:
+		return elf_sec__is_data(self, secstrs);
+	default:
+		return false;
+	}
+}
+
 static int dso__load_sym(struct dso *self, struct map *map,
-			 struct thread *thread, const char *name, int fd,
+			 struct map_groups *mg, const char *name, int fd,
 			 symbol_filter_t filter, int kernel, int kmodule)
 {
 	struct map *curr_map = map;
@@ -818,7 +946,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 		int is_label = elf_sym__is_label(&sym);
 		const char *section_name;
 
-		if (!is_label && !elf_sym__is_function(&sym))
+		if (!is_label && !elf_sym__is_a(&sym, map->type))
 			continue;
 
 		sec = elf_getscn(elf, sym.st_shndx);
@@ -827,7 +955,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 
 		gelf_getshdr(sec, &shdr);
 
-		if (is_label && !elf_sec__is_text(&shdr, secstrs))
+		if (is_label && !elf_sec__is_a(&shdr, secstrs, map->type))
 			continue;
 
 		elf_name = elf_sym__name(&sym, symstrs);
@@ -849,7 +977,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 			snprintf(dso_name, sizeof(dso_name),
 				 "%s%s", self->short_name, section_name);
 
-			curr_map = thread__find_map_by_name(thread, dso_name);
+			curr_map = map_groups__find_by_name(mg, map->type, dso_name);
 			if (curr_map == NULL) {
 				u64 start = sym.st_value;
 
@@ -868,7 +996,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
 				curr_dso->origin = DSO__ORIG_KERNEL;
-				__thread__insert_map(kthread, curr_map);
+				map_groups__insert(kmaps, curr_map);
 				dsos__add(&dsos__kernel, curr_dso);
 			} else
 				curr_dso = curr_map->dso;
@@ -1094,7 +1222,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	dso__set_loaded(self, map->type);
 
 	if (self->kernel)
-		return dso__load_kernel_sym(self, map, kthread, filter);
+		return dso__load_kernel_sym(self, map, kmaps, filter);
 
 	name = malloc(size);
 	if (!name)
@@ -1180,11 +1308,12 @@ out:
 	return ret;
 }
 
-static struct map *thread__find_map_by_name(struct thread *self, char *name)
+struct map *map_groups__find_by_name(struct map_groups *self,
+				     enum map_type type, const char *name)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->maps[MAP__FUNCTION]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *map = rb_entry(nd, struct map, rb_node);
 
 		if (map->dso && strcmp(map->dso->name, name) == 0)
@@ -1228,7 +1357,7 @@ static int dsos__set_modules_path_dir(char *dirname)
 				 (int)(dot - dent->d_name), dent->d_name);
 
 			strxfrchar(dso_name, '-', '_');
-			map = thread__find_map_by_name(kthread, dso_name);
+			map = map_groups__find_by_name(kmaps, MAP__FUNCTION, dso_name);
 			if (map == NULL)
 				continue;
 
@@ -1281,7 +1410,7 @@ static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 	return self;
 }
 
-static int thread__create_module_maps(struct thread *self)
+static int map_groups__create_module_maps(struct map_groups *self)
 {
 	char *line = NULL;
 	size_t n;
@@ -1338,7 +1467,7 @@ static int thread__create_module_maps(struct thread *self)
 			dso->has_build_id = true;
 
 		dso->origin = DSO__ORIG_KMODULE;
-		__thread__insert_map(self, map);
+		map_groups__insert(self, map);
 		dsos__add(&dsos__kernel, dso);
 	}
 
@@ -1353,7 +1482,8 @@ out_failure:
 	return -1;
 }
 
-static int dso__load_vmlinux(struct dso *self, struct map *map, struct thread *thread,
+static int dso__load_vmlinux(struct dso *self, struct map *map,
+			     struct map_groups *mg,
 			     const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
@@ -1387,14 +1517,14 @@ static int dso__load_vmlinux(struct dso *self, struct map *map, struct thread *t
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, thread, self->long_name, fd, filter, 1, 0);
+	err = dso__load_sym(self, map, mg, self->long_name, fd, filter, 1, 0);
 	close(fd);
 
 	return err;
 }
 
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct thread *thread, symbol_filter_t filter)
+				struct map_groups *mg, symbol_filter_t filter)
 {
 	int err;
 	bool is_kallsyms;
@@ -1404,7 +1534,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 		pr_debug("Looking at the vmlinux_path (%d entries long)\n",
 			 vmlinux_path__nr_entries);
 		for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-			err = dso__load_vmlinux(self, map, thread,
+			err = dso__load_vmlinux(self, map, mg,
 						vmlinux_path[i], filter);
 			if (err > 0) {
 				pr_debug("Using %s for symbols\n",
@@ -1420,12 +1550,12 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	if (is_kallsyms)
 		goto do_kallsyms;
 
-	err = dso__load_vmlinux(self, map, thread, self->long_name, filter);
+	err = dso__load_vmlinux(self, map, mg, self->long_name, filter);
 	if (err <= 0) {
 		pr_info("The file %s cannot be used, "
 			"trying to use /proc/kallsyms...", self->long_name);
 do_kallsyms:
-		err = dso__load_kallsyms(self, map, thread, filter);
+		err = dso__load_kallsyms(self, map, mg, filter);
 		if (err > 0 && !is_kallsyms)
                         dso__set_long_name(self, strdup("[kernel.kallsyms]"));
 	}
@@ -1508,42 +1638,59 @@ size_t dsos__fprintf_buildid(FILE *fp)
 		__dsos__fprintf_buildid(&dsos__user, fp));
 }
 
-static int thread__create_kernel_map(struct thread *self, const char *vmlinux)
+static struct dso *dsos__create_kernel( const char *vmlinux)
 {
-	struct map *kmap;
 	struct dso *kernel = dso__new(vmlinux ?: "[kernel.kallsyms]");
 
 	if (kernel == NULL)
-		return -1;
-
-	kmap = map__new2(0, kernel, MAP__FUNCTION);
-	if (kmap == NULL)
-		goto out_delete_kernel_dso;
+		return NULL;
 
-	kmap->map_ip	   = kmap->unmap_ip = identity__map_ip;
 	kernel->short_name = "[kernel]";
 	kernel->kernel	   = 1;
 
 	vdso = dso__new("[vdso]");
 	if (vdso == NULL)
-		goto out_delete_kernel_map;
+		goto out_delete_kernel_dso;
 	dso__set_loaded(vdso, MAP__FUNCTION);
 
 	if (sysfs__read_build_id("/sys/kernel/notes", kernel->build_id,
 				 sizeof(kernel->build_id)) == 0)
 		kernel->has_build_id = true;
 
-	__thread__insert_map(self, kmap);
 	dsos__add(&dsos__kernel, kernel);
 	dsos__add(&dsos__user, vdso);
 
-	return 0;
+	return kernel;
 
-out_delete_kernel_map:
-	map__delete(kmap);
 out_delete_kernel_dso:
 	dso__delete(kernel);
-	return -1;
+	return NULL;
+}
+
+static int map_groups__create_kernel_maps(struct map_groups *self, const char *vmlinux)
+{
+	struct map *functions, *variables;
+	struct dso *kernel = dsos__create_kernel(vmlinux);
+
+	if (kernel == NULL)
+		return -1;
+
+	functions = map__new2(0, kernel, MAP__FUNCTION);
+	if (functions == NULL)
+		return -1;
+
+	variables = map__new2(0, kernel, MAP__VARIABLE);
+	if (variables == NULL) {
+		map__delete(functions);
+		return -1;
+	}
+
+	functions->map_ip = functions->unmap_ip =
+		variables->map_ip = variables->unmap_ip = identity__map_ip;
+	map_groups__insert(self, functions);
+	map_groups__insert(self, variables);
+
+	return 0;
 }
 
 static void vmlinux_path__exit(void)
@@ -1607,23 +1754,26 @@ int symbol__init(struct symbol_conf *conf)
 
 	elf_version(EV_CURRENT);
 	symbol__priv_size = pconf->priv_size;
-	thread__init(kthread, 0);
+	if (pconf->sort_by_name)
+		symbol__priv_size += (sizeof(struct symbol_name_rb_node) -
+				      sizeof(struct symbol));
+	map_groups__init(kmaps);
 
 	if (pconf->try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
-	if (thread__create_kernel_map(kthread, pconf->vmlinux_name) < 0) {
+	if (map_groups__create_kernel_maps(kmaps, pconf->vmlinux_name) < 0) {
 		vmlinux_path__exit();
 		return -1;
 	}
 
-	kthread->use_modules = pconf->use_modules;
-	if (pconf->use_modules && thread__create_module_maps(kthread) < 0)
+	kmaps->use_modules = pconf->use_modules;
+	if (pconf->use_modules && map_groups__create_module_maps(kmaps) < 0)
 		pr_debug("Failed to load list of modules in use, "
 			 "continuing...\n");
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-	thread__fixup_maps_end(kthread);
+	map_groups__fixup_end(kmaps);
 	return 0;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 17003ef..cf99f88 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -52,7 +52,8 @@ struct symbol {
 struct symbol_conf {
 	unsigned short	priv_size;
 	bool		try_vmlinux_path,
-			use_modules;
+			use_modules,
+			sort_by_name;
 	const char	*vmlinux_name;
 };
 
@@ -74,13 +75,13 @@ struct addr_location {
 struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
-	struct symbol    *(*find_symbol)(struct dso *self,
-					 enum map_type type, u64 addr);
+	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	u8		 adjust_symbols:1;
 	u8		 slen_calculated:1;
 	u8		 has_build_id:1;
 	u8		 kernel:1;
 	unsigned char	 origin;
+	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 build_id[BUILD_ID_SIZE];
 	u16		 long_name_len;
@@ -93,6 +94,9 @@ struct dso *dso__new(const char *name);
 void dso__delete(struct dso *self);
 
 bool dso__loaded(const struct dso *self, enum map_type type);
+bool dso__sorted_by_name(const struct dso *self, enum map_type type);
+
+void dso__sort_by_name(struct dso *self, enum map_type type);
 
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
@@ -103,6 +107,9 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 void dso__set_build_id(struct dso *self, void *build_id);
+struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
+struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+					const char *name);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
@@ -113,8 +120,8 @@ size_t kernel_maps__fprintf(FILE *fp);
 
 int symbol__init(struct symbol_conf *conf);
 
-struct thread;
-struct thread *kthread;
+struct map_groups;
+struct map_groups *kmaps;
 extern struct list_head dsos__user, dsos__kernel;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 603f561..b68a00e 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -9,11 +9,9 @@
 static struct rb_root threads;
 static struct thread *last_match;
 
-void thread__init(struct thread *self, pid_t pid)
+void map_groups__init(struct map_groups *self)
 {
 	int i;
-	self->pid = pid;
-	self->comm = NULL;
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
 		self->maps[i] = RB_ROOT;
 		INIT_LIST_HEAD(&self->removed_maps[i]);
@@ -25,7 +23,8 @@ static struct thread *thread__new(pid_t pid)
 	struct thread *self = zalloc(sizeof(*self));
 
 	if (self != NULL) {
-		thread__init(self, pid);
+		map_groups__init(&self->mg);
+		self->pid = pid;
 		self->comm = malloc(32);
 		if (self->comm)
 			snprintf(self->comm, 32, ":%d", self->pid);
@@ -55,10 +54,11 @@ int thread__comm_len(struct thread *self)
 
 static const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
+	[MAP__VARIABLE] = "Variables",
 };
 
-static size_t __thread__fprintf_maps(struct thread *self,
-				     enum map_type type, FILE *fp)
+static size_t __map_groups__fprintf_maps(struct map_groups *self,
+					 enum map_type type, FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
@@ -76,16 +76,16 @@ static size_t __thread__fprintf_maps(struct thread *self,
 	return printed;
 }
 
-size_t thread__fprintf_maps(struct thread *self, FILE *fp)
+size_t map_groups__fprintf_maps(struct map_groups *self, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __thread__fprintf_maps(self, i, fp);
+		printed += __map_groups__fprintf_maps(self, i, fp);
 	return printed;
 }
 
-static size_t __thread__fprintf_removed_maps(struct thread *self,
-					     enum map_type type, FILE *fp)
+static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
+						 enum map_type type, FILE *fp)
 {
 	struct map *pos;
 	size_t printed = 0;
@@ -101,20 +101,25 @@ static size_t __thread__fprintf_removed_maps(struct thread *self,
 	return printed;
 }
 
-static size_t thread__fprintf_removed_maps(struct thread *self, FILE *fp)
+static size_t map_groups__fprintf_removed_maps(struct map_groups *self, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __thread__fprintf_removed_maps(self, i, fp);
+		printed += __map_groups__fprintf_removed_maps(self, i, fp);
 	return printed;
 }
 
-static size_t thread__fprintf(struct thread *self, FILE *fp)
+static size_t map_groups__fprintf(struct map_groups *self, FILE *fp)
 {
-	size_t printed = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
-	printed += thread__fprintf_removed_maps(self, fp);
+	size_t printed = map_groups__fprintf_maps(self, fp);
 	printed += fprintf(fp, "Removed maps:\n");
-	return printed + thread__fprintf_removed_maps(self, fp);
+	return printed + map_groups__fprintf_removed_maps(self, fp);
+}
+
+static size_t thread__fprintf(struct thread *self, FILE *fp)
+{
+	return fprintf(fp, "Thread %d %s\n", self->pid, self->comm) +
+	       map_groups__fprintf(&self->mg, fp);
 }
 
 struct thread *threads__findnew(pid_t pid)
@@ -168,7 +173,8 @@ struct thread *register_idle_thread(void)
 	return thread;
 }
 
-static void thread__remove_overlappings(struct thread *self, struct map *map)
+static void map_groups__remove_overlappings(struct map_groups *self,
+					    struct map *map)
 {
 	struct rb_root *root = &self->maps[map->type];
 	struct rb_node *next = rb_first(root);
@@ -238,12 +244,15 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 
 void thread__insert_map(struct thread *self, struct map *map)
 {
-	thread__remove_overlappings(self, map);
-	maps__insert(&self->maps[map->type], map);
+	map_groups__remove_overlappings(&self->mg, map);
+	map_groups__insert(&self->mg, map);
 }
 
-static int thread__clone_maps(struct thread *self, struct thread *parent,
-			      enum map_type type)
+/*
+ * XXX This should not really _copy_ te maps, but refcount them.
+ */
+static int map_groups__clone(struct map_groups *self,
+			     struct map_groups *parent, enum map_type type)
 {
 	struct rb_node *nd;
 	for (nd = rb_first(&parent->maps[type]); nd; nd = rb_next(nd)) {
@@ -251,7 +260,7 @@ static int thread__clone_maps(struct thread *self, struct thread *parent,
 		struct map *new = map__clone(map);
 		if (new == NULL)
 			return -ENOMEM;
-		thread__insert_map(self, new);
+		map_groups__insert(self, new);
 	}
 	return 0;
 }
@@ -267,7 +276,7 @@ int thread__fork(struct thread *self, struct thread *parent)
 		return -ENOMEM;
 
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		if (thread__clone_maps(self, parent, i) < 0)
+		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
 			return -ENOMEM;
 	return 0;
 }
@@ -286,11 +295,11 @@ size_t threads__fprintf(FILE *fp)
 	return ret;
 }
 
-struct symbol *thread__find_symbol(struct thread *self,
-				   enum map_type type, u64 addr,
-				   symbol_filter_t filter)
+struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       enum map_type type, u64 addr,
+				       symbol_filter_t filter)
 {
-	struct map *map = thread__find_map(self, type, addr);
+	struct map *map = map_groups__find(self, type, addr);
 
 	if (map != NULL)
 		return map__find_symbol(map, map->map_ip(map, addr), filter);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 686d6e9..1751802 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -5,52 +5,66 @@
 #include <unistd.h>
 #include "symbol.h"
 
-struct thread {
-	struct rb_node		rb_node;
+struct map_groups {
 	struct rb_root		maps[MAP__NR_TYPES];
 	struct list_head	removed_maps[MAP__NR_TYPES];
-	pid_t			pid;
 	bool			use_modules;
+};
+
+struct thread {
+	struct rb_node		rb_node;
+	struct map_groups	mg;
+	pid_t			pid;
 	char			shortname[3];
 	char			*comm;
 	int			comm_len;
 };
 
-void thread__init(struct thread *self, pid_t pid);
+void map_groups__init(struct map_groups *self);
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
 struct thread *threads__findnew(pid_t pid);
 struct thread *register_idle_thread(void);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-size_t thread__fprintf_maps(struct thread *self, FILE *fp);
+size_t map_groups__fprintf_maps(struct map_groups *self, FILE *fp);
 size_t threads__fprintf(FILE *fp);
 
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
 
-static inline struct map *thread__find_map(struct thread *self,
+static inline void map_groups__insert(struct map_groups *self, struct map *map)
+{
+	 maps__insert(&self->maps[map->type], map);
+}
+
+static inline struct map *map_groups__find(struct map_groups *self,
 					   enum map_type type, u64 addr)
 {
-	return self ? maps__find(&self->maps[type], addr) : NULL;
+	return maps__find(&self->maps[type], addr);
 }
 
-static inline void __thread__insert_map(struct thread *self, struct map *map)
+static inline struct map *thread__find_map(struct thread *self,
+					   enum map_type type, u64 addr)
 {
-	 maps__insert(&self->maps[map->type], map);
+	return self ? map_groups__find(&self->mg, type, addr) : NULL;
 }
 
 void thread__find_addr_location(struct thread *self, u8 cpumode,
 				enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter);
-struct symbol *thread__find_symbol(struct thread *self,
-				   enum map_type type, u64 addr,
-				   symbol_filter_t filter);
+struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       enum map_type type, u64 addr,
+				       symbol_filter_t filter);
 
 static inline struct symbol *
-thread__find_function(struct thread *self, u64 addr, symbol_filter_t filter)
+map_groups__find_function(struct map_groups *self, u64 addr,
+			  symbol_filter_t filter)
 {
-	return thread__find_symbol(self, MAP__FUNCTION, addr, filter);
+	return map_groups__find_symbol(self, MAP__FUNCTION, addr, filter);
 }
+
+struct map *map_groups__find_by_name(struct map_groups *self,
+				     enum map_type type, const char *name);
 #endif	/* __PERF_THREAD_H */
