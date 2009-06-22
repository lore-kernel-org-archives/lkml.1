Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbZFVT5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbZFVT5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZFVT5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:57:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:35319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZFVT5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:57:43 -0400
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
 member in event_symbol
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090622141009.GB6486@elte.hu>
References: <1245669194.17153.6.camel@localhost.localdomain>
	 <1245669268.17153.8.camel@localhost.localdomain>
	 <20090622113256.GA22479@elte.hu>
	 <1245675657.7537.3.camel@localhost.localdomain>
	 <20090622141009.GB6486@elte.hu>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 01:25:51 +0530
Message-Id: <1245700551.6167.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 16:10 +0200, Ingo Molnar wrote:
> yeah, somethig like that. I'd suggest to print out the actual 
> measured events:
> 
>     cache-references      10123 events
>     cache-misses             15 events
> 
> and if something does not appear to be ticking then do something 
> like:
> 
>     cache-misses          <inactive>
> 
> I.e. 'perf test' could be a quick way both to users and to 
> developers to see all possible hw and sw events.
> 
> Perhaps builtin-test.c should also do specific testcases for certain 
> counters - say intentionally migrate to a CPU and back to see the 
> CPU-migration count.
> 
> Also, you seem to have copied builtin-stat.c, right? Try to 
> librarize as much of the functionality (into util/*) to make the 
> resulting linecount increase as small as possible.
> 

perf test also need some command to execute otherwise it will also show
long list of <inactive>

I think better I should support all events in perf stat so user can get
better information from it and we can all add some other testing option
to it.

Anyway currently it looks like this :

[RFC][PATCH] perf_counter tools: introduce perf test to test event for ticks

perf test to Test performance counter events, its output on AMD box :

./perf test -a -- ls -lR > /dev/null

 Performance counter stats for 'ls' -lR:

 cycles                                             1226819954
 instructions                                        283680441
 cache-references                                    144893559
 cache-misses                                          3268438
 branches                                             37488241
 branch-misses                                         2464027
 bus-cycles                                         <inactive>
 cpu-clock-msecs                                   17175506056
 task-clock-msecs                                  17175086665
 page-faults                                               488
 minor-faults                                              488
 major-faults                                       <inactive>
 context-switches                                         7956
 CPU-migrations                                              7
 L1-data-Cache-Load-Referencees                      398303881
 L1-data-Cache-Load-Misses                             3552374
 L1-data-Cache-Store-Referencees                        270178
 L1-data-Cache-Store-Misses                         <inactive>
 L1-data-Cache-Prefetch-Referencees                     611622
 L1-data-Cache-Prefetch-Misses                          399730
 L1-instruction-Cache-Load-Referencees               124696447
 L1-instruction-Cache-Load-Misses                      2912802
 L1-instruction-Cache-Store-Referencees             <inactive>
 L1-instruction-Cache-Store-Misses                  <inactive>
 L1-instruction-Cache-Prefetch-Referencees              156576
 L1-instruction-Cache-Prefetch-Misses               <inactive>
 L2-Cache-Load-Referencees                             4312353
 L2-Cache-Load-Misses                                   470382
 L2-Cache-Store-Referencees                            4392945
 L2-Cache-Store-Misses                              <inactive>
 L2-Cache-Prefetch-Referencees                      <inactive>
 L2-Cache-Prefetch-Misses                           <inactive>
 Data-TLB-Cache-Load-Referencees                     127076487
 Data-TLB-Cache-Load-Misses                            1930048
 Data-TLB-Cache-Store-Referencees                   <inactive>
 Data-TLB-Cache-Store-Misses                        <inactive>
 Data-TLB-Cache-Prefetch-Referencees                <inactive>
 Data-TLB-Cache-Prefetch-Misses                     <inactive>
 Instruction-TLB-Cache-Load-Referencees              132768077
 Instruction-TLB-Cache-Load-Misses                        6406
 Instruction-TLB-Cache-Store-Referencees            <inactive>
 Instruction-TLB-Cache-Store-Misses                 <inactive>
 Instruction-TLB-Cache-Prefetch-Referencees         <inactive>
 Instruction-TLB-Cache-Prefetch-Misses              <inactive>
 Branch-Cache-Load-Referencees                        58030210
 Branch-Cache-Load-Misses                              3257804
 Branch-Cache-Store-Referencees                     <inactive>
 Branch-Cache-Store-Misses                          <inactive>
 Branch-Cache-Prefetch-Referencees                  <inactive>
 Branch-Cache-Prefetch-Misses                       <inactive>

    8.681671511  seconds time elapsed.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/Documentation/perf-test.txt |   44 ++++
 tools/perf/Makefile                    |    1 +
 tools/perf/builtin-test.c              |  436 ++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                   |    1 +
 tools/perf/command-list.txt            |    1 +
 tools/perf/perf.c                      |    1 +
 6 files changed, 484 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-test.txt
 create mode 100644 tools/perf/builtin-test.c

diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
new file mode 100644
index 0000000..6233769
--- /dev/null
+++ b/tools/perf/Documentation/perf-test.txt
@@ -0,0 +1,44 @@
+perf-test(1)
+============
+
+NAME
+----
+perf-test - Run a command and gather performance counter event count if any
+
+SYNOPSIS
+--------
+[verse]
+'perf test' [-e <EVENT> | --event=EVENT] [-a] <command>
+'perf test' [-e <EVENT> | --event=EVENT] [-a] -- <command> [<options>]
+
+DESCRIPTION
+-----------
+This command runs a command and gathers performance counter event count
+from it.
+
+
+OPTIONS
+-------
+<command>...::
+	Any command you can specify in a shell.
+
+
+-e::
+--event=::
+	Select the PMU event. Selection can be a symbolic event name
+	(use 'perf list' to list all events) or a raw PMU
+	event (eventsel+umask) in the form of rNNN where NNN is a
+	 hexadecimal event descriptor.
+
+-a::
+        system-wide collection
+
+EXAMPLES
+--------
+
+$ perf test -- make -j
+
+
+SEE ALSO
+--------
+linkperf:perf-stat[1], perf-top[1], linkperf:perf-list[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 36d7eef..f5ac83f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -335,6 +335,7 @@ BUILTIN_OBJS += builtin-list.o
 BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
 BUILTIN_OBJS += builtin-stat.o
+BUILTIN_OBJS += builtin-test.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
new file mode 100644
index 0000000..4ae1efe
--- /dev/null
+++ b/tools/perf/builtin-test.c
@@ -0,0 +1,436 @@
+/*
+ * builtin-test.c
+ *
+ * Builtin test command: Test performace counter events
+ *
+ * Sample output on AMD box:
+
+ $ perf test -a -- ls -lR > /dev/null 
+
+ Performance counter stats for 'ls' -lR:
+
+ cycles                                             1226819954
+ instructions                                        283680441
+ cache-references                                    144893559
+ cache-misses                                          3268438
+ branches                                             37488241
+ branch-misses                                         2464027
+ bus-cycles                                         <inactive>
+ cpu-clock-msecs                                   17175506056
+ task-clock-msecs                                  17175086665
+ page-faults                                               488
+ minor-faults                                              488
+ major-faults                                       <inactive>
+ context-switches                                         7956
+ CPU-migrations                                              7
+ L1-data-Cache-Load-Referencees                      398303881
+ L1-data-Cache-Load-Misses                             3552374
+ L1-data-Cache-Store-Referencees                        270178
+ L1-data-Cache-Store-Misses                         <inactive>
+ L1-data-Cache-Prefetch-Referencees                     611622
+ L1-data-Cache-Prefetch-Misses                          399730
+ L1-instruction-Cache-Load-Referencees               124696447
+ L1-instruction-Cache-Load-Misses                      2912802
+ L1-instruction-Cache-Store-Referencees             <inactive>
+ L1-instruction-Cache-Store-Misses                  <inactive>
+ L1-instruction-Cache-Prefetch-Referencees              156576
+ L1-instruction-Cache-Prefetch-Misses               <inactive>
+ L2-Cache-Load-Referencees                             4312353
+ L2-Cache-Load-Misses                                   470382
+ L2-Cache-Store-Referencees                            4392945
+ L2-Cache-Store-Misses                              <inactive>
+ L2-Cache-Prefetch-Referencees                      <inactive>
+ L2-Cache-Prefetch-Misses                           <inactive>
+ Data-TLB-Cache-Load-Referencees                     127076487
+ Data-TLB-Cache-Load-Misses                            1930048
+ Data-TLB-Cache-Store-Referencees                   <inactive>
+ Data-TLB-Cache-Store-Misses                        <inactive>
+ Data-TLB-Cache-Prefetch-Referencees                <inactive>
+ Data-TLB-Cache-Prefetch-Misses                     <inactive>
+ Instruction-TLB-Cache-Load-Referencees              132768077
+ Instruction-TLB-Cache-Load-Misses                        6406
+ Instruction-TLB-Cache-Store-Referencees            <inactive>
+ Instruction-TLB-Cache-Store-Misses                 <inactive>
+ Instruction-TLB-Cache-Prefetch-Referencees         <inactive>
+ Instruction-TLB-Cache-Prefetch-Misses              <inactive>
+ Branch-Cache-Load-Referencees                        58030210
+ Branch-Cache-Load-Misses                              3257804
+ Branch-Cache-Store-Referencees                     <inactive>
+ Branch-Cache-Store-Misses                          <inactive>
+ Branch-Cache-Prefetch-Referencees                  <inactive>
+ Branch-Cache-Prefetch-Misses                       <inactive>
+
+    8.681671511  seconds time elapsed.
+
+ * (based on builtin-stat.c)
+ *
+ * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
+ * Copyright (C) 2009, Jaswinder Singh Rajput <jaswinder@kernel.org>
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
+ */
+
+#include "perf.h"
+#include "builtin.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"
+
+#include <sys/prctl.h>
+#include <math.h>
+
+#define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
+#define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
+#define CHCACHE(x, y, z)						\
+.type = PERF_TYPE_HW_CACHE,						\
+.config = (PERF_COUNT_HW_CACHE_##x | (PERF_COUNT_HW_CACHE_OP_##y << 8) |\
+	   (PERF_COUNT_HW_CACHE_RESULT_##z << 16))					
+
+static struct perf_counter_attr default_attrs[] = {
+/* Generalized Hardware events				*/
+  { CHW(CPU_CYCLES)					},
+  { CHW(INSTRUCTIONS)					},
+  { CHW(CACHE_REFERENCES)				},
+  { CHW(CACHE_MISSES)					},
+  { CHW(BRANCH_INSTRUCTIONS)				},
+  { CHW(BRANCH_MISSES)					},
+  { CHW(BUS_CYCLES)					},
+
+/* Generalized Software events				*/
+  { CSW(CPU_CLOCK)					},
+  { CSW(TASK_CLOCK)					},
+  { CSW(PAGE_FAULTS)					},
+  { CSW(PAGE_FAULTS_MIN)				},
+  { CSW(PAGE_FAULTS_MAJ)				},
+  { CSW(CONTEXT_SWITCHES)				},
+  { CSW(CPU_MIGRATIONS)					},
+
+/* Generalized Hardware cache counters events		*/
+  { CHCACHE(L1D,	READ,		ACCESS)		},
+  { CHCACHE(L1D,	READ,		MISS)		},
+  { CHCACHE(L1D,	WRITE,		ACCESS)		},
+  { CHCACHE(L1D,	WRITE,		MISS)		},
+  { CHCACHE(L1D,	PREFETCH,	ACCESS)		},
+  { CHCACHE(L1D,	PREFETCH,	MISS)		},
+
+  { CHCACHE(L1I,	READ,		ACCESS)		},
+  { CHCACHE(L1I,	READ,		MISS)		},
+  { CHCACHE(L1I,	WRITE,		ACCESS)		},
+  { CHCACHE(L1I,	WRITE,		MISS)		},
+  { CHCACHE(L1I,	PREFETCH,	ACCESS)		},
+  { CHCACHE(L1I,	PREFETCH,	MISS)		},
+
+  { CHCACHE(LL,		READ,		ACCESS)		},
+  { CHCACHE(LL,		READ,		MISS)		},
+  { CHCACHE(LL,		WRITE,		ACCESS)		},
+  { CHCACHE(LL,		WRITE,		MISS)		},
+  { CHCACHE(LL,		PREFETCH,	ACCESS)		},
+  { CHCACHE(LL,		PREFETCH,	MISS)		},
+
+  { CHCACHE(DTLB,	READ,		ACCESS)		},
+  { CHCACHE(DTLB,	READ,		MISS)		},
+  { CHCACHE(DTLB,	WRITE,		ACCESS)		},
+  { CHCACHE(DTLB,	WRITE,		MISS)		},
+  { CHCACHE(DTLB,	PREFETCH,	ACCESS)		},
+  { CHCACHE(DTLB,	PREFETCH,	MISS)		},
+
+  { CHCACHE(ITLB,	READ,		ACCESS)		},
+  { CHCACHE(ITLB,	READ,		MISS)		},
+  { CHCACHE(ITLB,	WRITE,		ACCESS)		},
+  { CHCACHE(ITLB,	WRITE,		MISS)		},
+  { CHCACHE(ITLB,	PREFETCH,	ACCESS)		},
+  { CHCACHE(ITLB,	PREFETCH,	MISS)		},
+
+  { CHCACHE(BPU,	READ,		ACCESS)		},
+  { CHCACHE(BPU,	READ,		MISS)		},
+  { CHCACHE(BPU,	WRITE,		ACCESS)		},
+  { CHCACHE(BPU,	WRITE,		MISS)		},
+  { CHCACHE(BPU,	PREFETCH,	ACCESS)		},
+  { CHCACHE(BPU,	PREFETCH,	MISS)		},
+
+};
+
+#define MAX_RUN 100
+
+static int			system_wide		=  0;
+static int			verbose			=  0;
+
+static int			nr_cpus			=  0;
+
+static int			run_count		=  1;
+static int			run_idx			=  0;
+
+static unsigned int		page_size;
+
+static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+
+static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
+
+static u64			walltime_nsecs[MAX_RUN];
+static u64			runtime_cycles[MAX_RUN];
+
+static u64			event_res_avg[MAX_COUNTERS][3];
+
+static u64			walltime_nsecs_avg;
+
+static u64			runtime_cycles_avg;
+
+static void create_perf_stat_counter(int counter)
+{
+	struct perf_counter_attr *attr = attrs + counter;
+
+	if (system_wide) {
+		int cpu;
+		for (cpu = 0; cpu < nr_cpus; cpu ++) {
+			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
+			if (fd[cpu][counter] < 0 && verbose) {
+				printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[cpu][counter], strerror(errno));
+			}
+		}
+	} else {
+		attr->disabled	= 1;
+
+		fd[0][counter] = sys_perf_counter_open(attr, 0, -1, -1, 0);
+		if (fd[0][counter] < 0 && verbose) {
+			printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[0][counter], strerror(errno));
+		}
+	}
+}
+
+/*
+ * Read out the results of a single counter:
+ */
+static void read_counter(int counter)
+{
+	u64 *count, single_count[3];
+	ssize_t res;
+	int cpu, nv;
+
+	count = event_res[run_idx][counter];
+
+	count[0] = count[1] = count[2] = 0;
+
+	nv = 1;
+	for (cpu = 0; cpu < nr_cpus; cpu ++) {
+		if (fd[cpu][counter] < 0)
+			continue;
+
+		res = read(fd[cpu][counter], single_count, nv * sizeof(u64));
+		assert(res == nv * sizeof(u64));
+		close(fd[cpu][counter]);
+		fd[cpu][counter] = -1;
+
+		count[0] += single_count[0];
+	}
+
+	/*
+	 * Save the full runtime - to allow normalization during printout:
+	 */
+	runtime_cycles[run_idx] = count[0];
+}
+
+static int run_perf_test(int argc, const char **argv)
+{
+	unsigned long long t0, t1;
+	int status = 0;
+	int counter;
+	int pid;
+
+	if (!system_wide)
+		nr_cpus = 1;
+
+	for (counter = 0; counter < nr_counters; counter++)
+		create_perf_stat_counter(counter);
+
+	/*
+	 * Enable counters and exec the command:
+	 */
+	t0 = rdclock();
+	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
+
+	if ((pid = fork()) < 0)
+		perror("failed to fork");
+
+	if (!pid) {
+		if (execvp(argv[0], (char **)argv)) {
+			perror(argv[0]);
+			exit(-1);
+		}
+	}
+
+	wait(&status);
+
+	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
+	t1 = rdclock();
+
+	walltime_nsecs[run_idx] = t1 - t0;
+
+	for (counter = 0; counter < nr_counters; counter++)
+		read_counter(counter);
+
+	return WEXITSTATUS(status);
+}
+
+static void test_printout(int counter, u64 *count)
+{
+	fprintf(stderr, " %-45s", event_name(counter));
+
+	if (count[0])
+		fprintf(stderr, "  %14Ld", count[0]);
+	else
+		fprintf(stderr, "      <inactive>");
+}
+
+/*
+ * Print out the results of a single counter:
+ */
+static void print_counter(int counter)
+{
+	u64 *count;
+
+	count = event_res_avg[counter];
+
+	test_printout(counter, count);
+
+	fprintf(stderr, "\n");
+}
+
+static void update_avg(const char *name, int idx, u64 *avg, u64 *val)
+{
+	*avg += *val;
+
+	if (verbose > 1)
+		fprintf(stderr, "debug: %20s[%d]: %Ld\n", name, idx, *val);
+}
+/*
+ * Calculate the averages:
+ */
+static void calc_avg(void)
+{
+	int i, j;
+
+	if (verbose > 1)
+		fprintf(stderr, "\n");
+
+	for (i = 0; i < run_count; i++) {
+		update_avg("walltime", 0, &walltime_nsecs_avg, walltime_nsecs + i);
+		update_avg("runtime_cycles", 0, &runtime_cycles_avg, runtime_cycles + i);
+		for (j = 0; j < nr_counters; j++) {
+			update_avg("counter/0", j,
+				event_res_avg[j]+0, event_res[i][j]+0);
+			update_avg("counter/1", j,
+				event_res_avg[j]+1, event_res[i][j]+1);
+			update_avg("counter/2", j,
+				event_res_avg[j]+2, event_res[i][j]+2);
+		}
+	}
+	walltime_nsecs_avg /= run_count;
+	runtime_cycles_avg /= run_count;
+
+	for (j = 0; j < nr_counters; j++) {
+		event_res_avg[j][0] /= run_count;
+		event_res_avg[j][1] /= run_count;
+		event_res_avg[j][2] /= run_count;
+	}
+}
+
+static void print_test(int argc, const char **argv)
+{
+	int i, counter;
+
+	calc_avg();
+
+	fflush(stdout);
+
+	fprintf(stderr, "\n");
+	fprintf(stderr, " Performance counter stats for \'%s\'", argv[0]);
+
+	for (i = 1; i < argc; i++)
+		fprintf(stderr, " %s", argv[i]);
+
+	fprintf(stderr, ":\n\n");
+
+	for (counter = 0; counter < nr_counters; counter++)
+		print_counter(counter);
+
+	fprintf(stderr, "\n");
+	fprintf(stderr, " %14.9f  seconds time elapsed.\n",
+			(double)walltime_nsecs_avg/1e9);
+	fprintf(stderr, "\n");
+}
+
+static volatile int signr = -1;
+
+static void skip_signal(int signo)
+{
+	signr = signo;
+}
+
+static const char * const test_usage[] = {
+	"perf test [<options>] <command>",
+	NULL
+};
+
+static void sig_atexit(void)
+{
+	if (signr == -1)
+		return;
+
+	signal(signr, SIG_DFL);
+	kill(getpid(), signr);
+}
+
+static const struct option options[] = {
+	OPT_CALLBACK('e', "event", NULL, "event",
+		     "event selector. use 'perf list' to list available events",
+		     parse_events),
+        OPT_BOOLEAN('a', "all-cpus", &system_wide,
+                            "system-wide collection from all CPUs"),
+        OPT_BOOLEAN('v', "verbose", &verbose,
+                    "be more verbose (show counter open errors, etc)"),
+        OPT_END()
+};
+
+int cmd_test(int argc, const char **argv, const char *prefix)
+{
+	int status;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	memcpy(attrs, default_attrs, sizeof(attrs));
+
+	argc = parse_options(argc, argv, options, test_usage, 0);
+	if (!argc)
+		usage_with_options(test_usage, options);
+	if (run_count <= 0 || run_count > MAX_RUN)
+		usage_with_options(test_usage, options);
+
+	if (!nr_counters)
+		nr_counters = ARRAY_SIZE(default_attrs);
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	assert(nr_cpus <= MAX_NR_CPUS);
+	assert(nr_cpus >= 0);
+
+	/*
+	 * We dont want to block the signals - that would cause
+	 * child tasks to inherit that and Ctrl-C would not work.
+	 * What we want is for Ctrl-C to work in the exec()-ed
+	 * task, but being ignored by perf test itself:
+	 */
+	atexit(sig_atexit);
+	signal(SIGINT,  skip_signal);
+	signal(SIGALRM, skip_signal);
+	signal(SIGABRT, skip_signal);
+
+	status = 0;
+	for (run_idx = 0; run_idx < run_count; run_idx++) {
+		if (run_count != 1 && verbose)
+			fprintf(stderr, "[ perf test: executing run #%d ... ]\n", run_idx+1);
+		status = run_perf_test(argc, argv);
+	}
+
+	print_test(argc, argv);
+
+	return status;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 51d1682..3ed0362 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -22,5 +22,6 @@ extern int cmd_stat(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
+extern int cmd_test(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index eebce30..f53544c 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -7,4 +7,5 @@ perf-list			mainporcelain common
 perf-record			mainporcelain common
 perf-report			mainporcelain common
 perf-stat			mainporcelain common
+perf-test			mainporcelain common
 perf-top			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 4eb7259..9f98f5e 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -262,6 +262,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "record", cmd_record, 0 },
 		{ "report", cmd_report, 0 },
 		{ "stat", cmd_stat, 0 },
+		{ "test", cmd_test, 0 },
 		{ "top", cmd_top, 0 },
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
-- 
1.6.0.6



