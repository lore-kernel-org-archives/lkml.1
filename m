Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab0CKOik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:38:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:35254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab0CKOii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:38:38 -0500
Date: Thu, 11 Mar 2010 14:38:02 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       acme@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       linux-kernel@vger.kernel.org, acme@infradead.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100310093609.GA3959@brick.ozlabs.ibm.com>
References: <20100310093609.GA3959@brick.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix sparse CPU numbering related bugs
Message-ID: <tip-a12b51c478899fe0b7e874a559b05ba35f1128ee@git.kernel.org>
Git-Commit-ID: a12b51c478899fe0b7e874a559b05ba35f1128ee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:38:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a12b51c478899fe0b7e874a559b05ba35f1128ee
Gitweb:     http://git.kernel.org/tip/a12b51c478899fe0b7e874a559b05ba35f1128ee
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 10 Mar 2010 20:36:09 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 13:36:53 +0100

perf tools: Fix sparse CPU numbering related bugs

At present, the perf subcommands that do system-wide monitoring
(perf stat, perf record and perf top) don't work properly unless
the online cpus are numbered 0, 1, ..., N-1.  These tools ask
for the number of online cpus with sysconf(_SC_NPROCESSORS_ONLN)
and then try to create events for cpus 0, 1, ..., N-1.

This creates problems for systems where the online cpus are
numbered sparsely.  For example, a POWER6 system in
single-threaded mode (i.e. only running 1 hardware thread per
core) will have only even-numbered cpus online.

This fixes the problem by reading the /sys/devices/system/cpu/online
file to find out which cpus are online.  The code that does that is in
tools/perf/util/cpumap.[ch], and consists of a read_cpu_map()
function that sets up a cpumap[] array and returns the number of
online cpus.  If /sys/devices/system/cpu/online can't be read or
can't be parsed successfully, it falls back to using sysconf to
ask how many cpus are online and sets up an identity map in cpumap[].

The perf record, perf stat and perf top code then calls
read_cpu_map() in the system-wide monitoring case (instead of
sysconf) and uses cpumap[] to get the cpu numbers to pass to
perf_event_open.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
LKML-Reference: <20100310093609.GA3959@brick.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile         |    2 +
 tools/perf/builtin-record.c |    7 ++---
 tools/perf/builtin-stat.c   |   10 ++++---
 tools/perf/builtin-top.c    |    9 +++---
 tools/perf/util/cpumap.c    |   59 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h    |    7 +++++
 6 files changed, 81 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2d53738..5840499 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -387,6 +387,7 @@ LIB_H += util/thread.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
+LIB_H += util/cpumap.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -433,6 +434,7 @@ LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
 LIB_OBJS += util/probe-event.o
 LIB_OBJS += util/util.o
+LIB_OBJS += util/cpumap.o
 
 BUILTIN_OBJS += builtin-annotate.o
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f573bbb..b09d3b2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -22,6 +22,7 @@
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/symbol.h"
+#include "util/cpumap.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -421,9 +422,6 @@ static int __cmd_record(int argc, const char **argv)
 	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert(nr_cpus >= 0);
 
 	atexit(sig_atexit);
 	signal(SIGCHLD, sig_handler);
@@ -547,8 +545,9 @@ static int __cmd_record(int argc, const char **argv)
 	if ((!system_wide && !inherit) || profile_cpu != -1) {
 		open_counters(profile_cpu, target_pid);
 	} else {
+		nr_cpus = read_cpu_map();
 		for (i = 0; i < nr_cpus; i++)
-			open_counters(i, target_pid);
+			open_counters(cpumap[i], target_pid);
 	}
 
 	if (file_new) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e8c85d5..95db31c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -45,6 +45,7 @@
 #include "util/event.h"
 #include "util/debug.h"
 #include "util/header.h"
+#include "util/cpumap.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -151,7 +152,7 @@ static void create_perf_stat_counter(int counter, int pid)
 		unsigned int cpu;
 
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			fd[cpu][counter] = sys_perf_event_open(attr, -1, cpu, -1, 0);
+			fd[cpu][counter] = sys_perf_event_open(attr, -1, cpumap[cpu], -1, 0);
 			if (fd[cpu][counter] < 0 && verbose)
 				fprintf(stderr, ERR_PERF_OPEN, counter,
 					fd[cpu][counter], strerror(errno));
@@ -519,9 +520,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		nr_counters = ARRAY_SIZE(default_attrs);
 	}
 
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert((int)nr_cpus >= 0);
+	if (system_wide)
+		nr_cpus = read_cpu_map();
+	else
+		nr_cpus = 1;
 
 	/*
 	 * We dont want to block the signals - that would cause
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31f2e59..0b719e3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -28,6 +28,7 @@
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/cpumap.h"
 
 #include "util/debug.h"
 
@@ -1123,7 +1124,7 @@ static void start_counter(int i, int counter)
 
 	cpu = profile_cpu;
 	if (target_pid == -1 && profile_cpu == -1)
-		cpu = i;
+		cpu = cpumap[i];
 
 	attr = attrs + counter;
 
@@ -1347,12 +1348,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		attrs[counter].sample_period = default_interval;
 	}
 
-	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-	assert(nr_cpus <= MAX_NR_CPUS);
-	assert(nr_cpus >= 0);
-
 	if (target_pid != -1 || profile_cpu != -1)
 		nr_cpus = 1;
+	else
+		nr_cpus = read_cpu_map();
 
 	get_term_dimensions(&winsize);
 	if (print_entries == 0) {
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
new file mode 100644
index 0000000..4e01490
--- /dev/null
+++ b/tools/perf/util/cpumap.c
@@ -0,0 +1,59 @@
+#include "util.h"
+#include "../perf.h"
+#include "cpumap.h"
+#include <assert.h>
+#include <stdio.h>
+
+int cpumap[MAX_NR_CPUS];
+
+static int default_cpu_map(void)
+{
+	int nr_cpus, i;
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	assert(nr_cpus <= MAX_NR_CPUS);
+	assert((int)nr_cpus >= 0);
+
+	for (i = 0; i < nr_cpus; ++i)
+		cpumap[i] = i;
+
+	return nr_cpus;
+}
+
+int read_cpu_map(void)
+{
+	FILE *onlnf;
+	int nr_cpus = 0;
+	int n, cpu, prev;
+	char sep;
+
+	onlnf = fopen("/sys/devices/system/cpu/online", "r");
+	if (!onlnf)
+		return default_cpu_map();
+
+	sep = 0;
+	prev = -1;
+	for (;;) {
+		n = fscanf(onlnf, "%u%c", &cpu, &sep);
+		if (n <= 0)
+			break;
+		if (prev >= 0) {
+			assert(nr_cpus + cpu - prev - 1 < MAX_NR_CPUS);
+			while (++prev < cpu)
+				cpumap[nr_cpus++] = prev;
+		}
+		assert (nr_cpus < MAX_NR_CPUS);
+		cpumap[nr_cpus++] = cpu;
+		if (n == 2 && sep == '-')
+			prev = cpu;
+		else
+			prev = -1;
+		if (n == 1 || sep == '\n')
+			break;
+	}
+	fclose(onlnf);
+	if (nr_cpus > 0)
+		return nr_cpus;
+
+	return default_cpu_map();
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
new file mode 100644
index 0000000..86c78bb
--- /dev/null
+++ b/tools/perf/util/cpumap.h
@@ -0,0 +1,7 @@
+#ifndef __PERF_CPUMAP_H
+#define __PERF_CPUMAP_H
+
+extern int read_cpu_map(void);
+extern int cpumap[];
+
+#endif /* __PERF_CPUMAP_H */
