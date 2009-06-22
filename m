Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbZFVNBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbZFVNBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZFVNBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:01:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:48902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbZFVNBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:01:31 -0400
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
 member in event_symbol
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090622113256.GA22479@elte.hu>
References: <1245669194.17153.6.camel@localhost.localdomain>
	 <1245669268.17153.8.camel@localhost.localdomain>
	 <20090622113256.GA22479@elte.hu>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 18:30:57 +0530
Message-Id: <1245675657.7537.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 13:32 +0200, Ingo Molnar wrote:

> Another nice thing would be for 'perf list' to actually start each 
> counter and stop it - and see whether it ticks. Perhaps that could 
> be a new sub-command: 'perf test' ?
> 
> New 'perf' subcommands are added easily:
> 
> create a new tools/perf/builtin-foo.c file, add it to 
> command-list.txt and to the Makefile - add it to perf.c's array of 
> built-in commands and add a Documentation/perf-foo.txt file to 
> generate manpages and usage strings for it.
> 

Ok this is just a ugly quick hack to get the idea what actually you are
looking for :

[RFC] perf_counter tools: introduce perf test to test each event for ticks

perf test to Test all events for whether it ticks

  $ perf test

  Performance counter stats for 'test':

  task-clock-msecs      Tick
  context-switches      Tick
  CPU-migrations        Tick
  page-faults           Tick
  cycles                Tick
  instructions          Tick
  cache-references      Tick
  cache-misses          Tick

     0.007693869  seconds time elapsed.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/Documentation/perf-test.txt |   24 ++
 tools/perf/Makefile                    |    1 +
 tools/perf/builtin-test.c              |  399 ++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                   |    1 +
 tools/perf/command-list.txt            |    1 +
 tools/perf/perf.c                      |    1 +
 6 files changed, 427 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-test.txt
 create mode 100644 tools/perf/builtin-test.c

diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
new file mode 100644
index 0000000..44cf495
--- /dev/null
+++ b/tools/perf/Documentation/perf-test.txt
@@ -0,0 +1,24 @@
+perf-test(1)
+============
+
+NAME
+----
+perf-test - Test all events for whether it ticks
+
+SYNOPSIS
+--------
+[verse]
+'perf test'
+
+DESCRIPTION
+-----------
+This command test all events whether it ticks.
+
+OPTIONS
+-------
+None
+
+SEE ALSO
+--------
+linkperf:perf-stat[1], linkperf:perf-top[1],
+linkperf:perf-record[1]
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
index 0000000..0b8b25a
--- /dev/null
+++ b/tools/perf/builtin-test.c
@@ -0,0 +1,399 @@
+/*
+ * builtin-test.c
+ *
+ * Builtin test command: Tests each event and see whether it ticks
+ *
+ * Sample output:
+
+   $ perf test
+
+  Performance counter stats for 'test':
+
+  task-clock-msecs      Tick
+  context-switches      Tick
+  CPU-migrations        Tick
+  page-faults           Tick
+  cycles                Tick
+  instructions          Tick
+  cache-references      Tick
+  cache-misses          Tick
+
+     0.007693869  seconds time elapsed.
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
+static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
+
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS	},
+
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES	},
+
+};
+
+static int			system_wide			=  0;
+static int			inherit				=  1;
+static int			verbose				=  0;
+
+static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+
+static int			nr_cpus				=  0;
+static unsigned int		page_size;
+
+static int			scale				=  1;
+
+#define MAX_RUN 100
+
+static int			run_count		=  1;
+static int			run_idx			=  0;
+
+static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
+static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
+
+static u64			runtime_nsecs[MAX_RUN];
+static u64			walltime_nsecs[MAX_RUN];
+static u64			runtime_cycles[MAX_RUN];
+
+static u64			event_res_avg[MAX_COUNTERS][3];
+static u64			event_res_noise[MAX_COUNTERS][3];
+
+static u64			event_scaled_avg[MAX_COUNTERS];
+
+static u64			runtime_nsecs_avg;
+static u64			runtime_nsecs_noise;
+
+static u64			walltime_nsecs_avg;
+static u64			walltime_nsecs_noise;
+
+static u64			runtime_cycles_avg;
+static u64			runtime_cycles_noise;
+
+static void create_perf_stat_counter(int counter)
+{
+	struct perf_counter_attr *attr = attrs + counter;
+
+	if (scale)
+		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
+				    PERF_FORMAT_TOTAL_TIME_RUNNING;
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
+		attr->inherit	= inherit;
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
+ * Does the counter have nsecs as a unit?
+ */
+static inline int nsec_counter(int counter)
+{
+	if (attrs[counter].type != PERF_TYPE_SOFTWARE)
+		return 0;
+
+	if (attrs[counter].config == PERF_COUNT_SW_CPU_CLOCK)
+		return 1;
+
+	if (attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+		return 1;
+
+	return 0;
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
+	int scaled;
+
+	count = event_res[run_idx][counter];
+
+	count[0] = count[1] = count[2] = 0;
+
+	nv = scale ? 3 : 1;
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
+		if (scale) {
+			count[1] += single_count[1];
+			count[2] += single_count[2];
+		}
+	}
+
+	scaled = 0;
+	if (scale) {
+		if (count[2] == 0) {
+			event_scaled[run_idx][counter] = -1;
+			count[0] = 0;
+			return;
+		}
+
+		if (count[2] < count[1]) {
+			event_scaled[run_idx][counter] = 1;
+			count[0] = (unsigned long long)
+				((double)count[0] * count[1] / count[2] + 0.5);
+		}
+	}
+	/*
+	 * Save the full runtime - to allow normalization during printout:
+	 */
+	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
+		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+		runtime_nsecs[run_idx] = count[0];
+	if (attrs[counter].type == PERF_TYPE_HARDWARE &&
+		attrs[counter].config == PERF_COUNT_HW_CPU_CYCLES)
+		runtime_cycles[run_idx] = count[0];
+}
+
+static int run_perf_stat(int argc, const char **argv)
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
+	fprintf(stderr, " %-20s", event_name(counter));
+
+	if (count[0])
+		fprintf(stderr, "  Tick");
+	else
+		fprintf(stderr, "  No Tick");
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
+ * Calculate the averages and noises:
+ */
+static void calc_avg(void)
+{
+	int i, j;
+
+	if (verbose > 1)
+		fprintf(stderr, "\n");
+
+	for (i = 0; i < run_count; i++) {
+		update_avg("runtime", 0, &runtime_nsecs_avg, runtime_nsecs + i);
+		update_avg("walltime", 0, &walltime_nsecs_avg, walltime_nsecs + i);
+		update_avg("runtime_cycles", 0, &runtime_cycles_avg, runtime_cycles + i);
+		for (j = 0; j < nr_counters; j++) {
+			update_avg("counter/0", j,
+				event_res_avg[j]+0, event_res[i][j]+0);
+			update_avg("counter/1", j,
+				event_res_avg[j]+1, event_res[i][j]+1);
+			update_avg("counter/2", j,
+				event_res_avg[j]+2, event_res[i][j]+2);
+			update_avg("scaled", j,
+				event_scaled_avg + j, event_scaled[i]+j);
+		}
+	}
+	runtime_nsecs_avg /= run_count;
+	walltime_nsecs_avg /= run_count;
+	runtime_cycles_avg /= run_count;
+
+	for (j = 0; j < nr_counters; j++) {
+		event_res_avg[j][0] /= run_count;
+		event_res_avg[j][1] /= run_count;
+		event_res_avg[j][2] /= run_count;
+	}
+
+	for (i = 0; i < run_count; i++) {
+		runtime_nsecs_noise +=
+			abs((s64)(runtime_nsecs[i] - runtime_nsecs_avg));
+		walltime_nsecs_noise +=
+			abs((s64)(walltime_nsecs[i] - walltime_nsecs_avg));
+		runtime_cycles_noise +=
+			abs((s64)(runtime_cycles[i] - runtime_cycles_avg));
+
+		for (j = 0; j < nr_counters; j++) {
+			event_res_noise[j][0] +=
+				abs((s64)(event_res[i][j][0] - event_res_avg[j][0]));
+			event_res_noise[j][1] +=
+				abs((s64)(event_res[i][j][1] - event_res_avg[j][1]));
+			event_res_noise[j][2] +=
+				abs((s64)(event_res[i][j][2] - event_res_avg[j][2]));
+		}
+	}
+}
+
+static void print_stat(int argc, const char **argv)
+{
+	int i, counter;
+
+	calc_avg();
+
+	fflush(stdout);
+
+	fprintf(stderr, "\n");
+	fprintf(stderr, " Performance counter stats for \'%s", argv[0]);
+
+	for (i = 1; i < argc; i++)
+		fprintf(stderr, " %s", argv[i]);
+
+	fprintf(stderr, "\'");
+	if (run_count > 1)
+		fprintf(stderr, " (%d runs)", run_count);
+	fprintf(stderr, ":\n\n");
+
+	for (counter = 0; counter < nr_counters; counter++)
+		print_counter(counter);
+
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
+static void sig_atexit(void)
+{
+	if (signr == -1)
+		return;
+
+	signal(signr, SIG_DFL);
+	kill(getpid(), signr);
+}
+
+int cmd_test(int argc, const char **argv, const char *prefix)
+{
+	int status;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	memcpy(attrs, default_attrs, sizeof(attrs));
+
+	if (!nr_counters)
+		nr_counters = 8;
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	assert(nr_cpus <= MAX_NR_CPUS);
+	assert(nr_cpus >= 0);
+
+	/*
+	 * We dont want to block the signals - that would cause
+	 * child tasks to inherit that and Ctrl-C would not work.
+	 * What we want is for Ctrl-C to work in the exec()-ed
+	 * task, but being ignored by perf stat itself:
+	 */
+	atexit(sig_atexit);
+	signal(SIGINT,  skip_signal);
+	signal(SIGALRM, skip_signal);
+	signal(SIGABRT, skip_signal);
+
+	status = 0;
+	for (run_idx = 0; run_idx < run_count; run_idx++) {
+		if (run_count != 1 && verbose)
+			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx+1);
+		status = run_perf_stat(argc, argv);
+	}
+
+	print_stat(argc, argv);
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



