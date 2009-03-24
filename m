Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZCXFxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZCXFxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZCXFwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:52:51 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40700 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZCXFwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:52:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
Date: Tue, 24 Mar 2009 16:52:34 +1100
From: Paul Mackerras <paulus@samba.org>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       fengguang.wu@intel.com, hpa@zytor.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter tools: remove glib dependency and fix
   bugs in kerneltop.c
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The glib dependency in kerneltop.c is only for a little bit of list
manipulation, and I find it inconvenient.  This adds a 'next' field to
struct source_line, which lets us link them together into a list.  The
code to do the linking ourselves turns out to be no longer or more
difficult than using glib.

This also fixes a few other problems:

- We need to #include <limits.h> to get PATH_MAX on powerpc.

- We need to #include <linux/types.h> rather than have our own
  definitions of __u64 and __s64; on powerpc the installed headers
  define them to be unsigned long and long respectively, and if we
  have our own, different definition here that causes a compile error.

- This takes out the x86 setting of errno from -ret in
  sys_perf_counter_open.  My experiments on x86 indicate that the
  glibc syscall() does this for us already.

- We had two CPU migration counters in the default set, which seems
  unnecessary; I changed one of them to a context switch counter.

- In perfstat mode we were printing CPU cycles and instructions as
  milliseconds, and the cpu clock and task clock counters as events.
  This fixes that.

- In perfstat mode we were still printing a blank line after the first
  counter, which was a holdover from when a task clock counter was
  automatically included as the first counter.  This removes the blank
  line.

- On a test machine here, parse_symbols() and parse_vmlinux() were
  taking long enough (almost 0.5 seconds) for the mmap buffer to
  overflow before we got to the first mmap_read() call, so this moves
  them before we open all the counters.

- The error message if sys_perf_counter_open fails needs to use errno,
  not -fd[i][counter].

Signed-off-by: Paul Mackerras <paulus@samba.org>

---
 Documentation/perf_counter/Makefile    |    2 +-
 Documentation/perf_counter/kerneltop.c |  112 +++++++++++++-------------------
 2 files changed, 46 insertions(+), 68 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 666da95..194b662 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -3,7 +3,7 @@ BINS = kerneltop perfstat
 all: $(BINS)
 
 kerneltop: kerneltop.c ../../include/linux/perf_counter.h
-	cc -O6 -Wall -lrt `pkg-config --cflags --libs glib-2.0` -o $@ $<
+	cc -O6 -Wall -lrt -o $@ $<
 
 perfstat: kerneltop
 	ln -sf kerneltop perfstat
diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index 2ab29b5..ea13e4e 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -3,7 +3,7 @@
 
    Build with:
 
-     cc -O6 -Wall -lrt `pkg-config --cflags --libs glib-2.0` -o kerneltop kerneltop.c
+     cc -O6 -Wall -c -o kerneltop.o kerneltop.c -lrt
 
    Sample output:
 
@@ -56,6 +56,7 @@
   *   Yanmin Zhang <yanmin.zhang@intel.com>
   *   Wu Fengguang <fengguang.wu@intel.com>
   *   Mike Galbraith <efault@gmx.de>
+  *   Paul Mackerras <paulus@samba.org>
   *
   * Released under the GPL v2. (and only v2, not any later version)
   */
@@ -68,6 +69,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include <getopt.h>
 #include <assert.h>
 #include <fcntl.h>
@@ -76,8 +78,6 @@
 #include <ctype.h>
 #include <time.h>
 
-#include <glib.h>
-
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
 #include <sys/poll.h>
@@ -87,6 +87,7 @@
 #include <sys/mman.h>
 
 #include <linux/unistd.h>
+#include <linux/types.h>
 
 #include "../../include/linux/perf_counter.h"
 
@@ -114,11 +115,6 @@
 #define __user
 #define asmlinkage
 
-typedef unsigned int            __u32;
-typedef unsigned long long      __u64;
-typedef long long               __s64;
-
-
 #ifdef __x86_64__
 #define __NR_perf_counter_open 295
 #define rmb()		asm volatile("lfence" ::: "memory")
@@ -146,17 +142,8 @@ asmlinkage int sys_perf_counter_open(
         int                             group_fd,
         unsigned long                   flags)
 {
-        int ret;
-
-        ret = syscall(
+        return syscall(
                 __NR_perf_counter_open, hw_event_uptr, pid, cpu, group_fd, flags);
-#if defined(__x86_64__) || defined(__i386__)
-        if (ret < 0 && ret > -4096) {
-                errno = -ret;
-                ret = -1;
-        }
-#endif
-        return ret;
 }
 
 #define MAX_COUNTERS			64
@@ -170,7 +157,7 @@ static int			system_wide			=  0;
 static int			nr_counters			=  0;
 static __u64			event_id[MAX_COUNTERS]		= {
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),
-	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),
+	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),
 
@@ -202,14 +189,15 @@ static int			delay_secs			=  2;
 static int			zero;
 static int			dump_symtab;
 
-static GList			*lines;
-
 struct source_line {
 	uint64_t		EIP;
 	unsigned long		count;
 	char			*line;
+	struct source_line	*next;
 };
 
+static struct source_line	*lines;
+static struct source_line	**lines_tail;
 
 const unsigned int default_count[] = {
 	1000000,
@@ -519,9 +507,8 @@ int do_perfstat(int argc, char *argv[])
 			count += single_count;
 		}
 
-		if (!PERF_COUNTER_RAW(event_id[counter]) &&
-		    (event_id[counter] == PERF_COUNT_CPU_CLOCK ||
-		     event_id[counter] == PERF_COUNT_TASK_CLOCK)) {
+		if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK) ||
+		    event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK)) {
 
 			double msecs = (double)count / 1000000;
 
@@ -531,8 +518,6 @@ int do_perfstat(int argc, char *argv[])
 			fprintf(stderr, " %14Ld  %-20s (events)\n",
 				count, event_name(counter));
 		}
-		if (!counter)
-			fprintf(stderr, "\n");
 	}
 	fprintf(stderr, "\n");
 	fprintf(stderr, " Wall-clock time elapsed: %12.6f msecs\n",
@@ -554,7 +539,7 @@ struct sym_entry {
 	char			*sym;
 	unsigned long		count[MAX_COUNTERS];
 	int			skip;
-	GList			*source;
+	struct source_line	*source;
 };
 
 #define MAX_SYMS		100000
@@ -855,6 +840,7 @@ static void parse_vmlinux(char *filename)
 	if (!file)
 		return;
 
+	lines_tail = &lines;
 	while (!feof(file)) {
 		struct source_line *src;
 		size_t dummy = 0;
@@ -873,7 +859,9 @@ static void parse_vmlinux(char *filename)
 		if (c)
 			*c = 0;
 
-		lines = g_list_prepend(lines, src);
+		src->next = NULL;
+		*lines_tail = src;
+		lines_tail = &src->next;
 
 		if (strlen(src->line)>8 && src->line[8] == ':')
 			src->EIP = strtoull(src->line, NULL, 16);
@@ -881,52 +869,43 @@ static void parse_vmlinux(char *filename)
 			src->EIP = strtoull(src->line, NULL, 16);
 	}
 	pclose(file);
-	lines = g_list_reverse(lines);
 }
 
 static void record_precise_ip(uint64_t ip)
 {
 	struct source_line *line;
-	GList *item;
 
-	item = g_list_first(lines);
-	while (item) {
-		line = item->data;
+	for (line = lines; line; line = line->next) {
 		if (line->EIP == ip)
 			line->count++;
 		if (line->EIP > ip)
 			break;
-		item = g_list_next(item);
 	}
 }
 
 static void lookup_sym_in_vmlinux(struct sym_entry *sym)
 {
 	struct source_line *line;
-	GList *item;
 	char pattern[PATH_MAX];
 	sprintf(pattern, "<%s>:", sym->sym);
 
-	item = g_list_first(lines);
-	while (item) {
-		line = item->data;
+	for (line = lines; line; line = line->next) {
 		if (strstr(line->line, pattern)) {
-			sym->source = item;
+			sym->source = line;
 			break;
 		}
-		item = g_list_next(item);
 	}
 }
 
-void show_lines(GList *item_queue, int item_queue_count)
+static void show_lines(struct source_line *line_queue, int line_queue_count)
 {
 	int i;
 	struct source_line *line;
 
-	for (i = 0; i < item_queue_count; i++) {
-		line = item_queue->data;
+	line = line_queue;
+	for (i = 0; i < line_queue_count; i++) {
 		printf("%8li\t%s\n", line->count, line->line);
-		item_queue = g_list_next(item_queue);
+		line = line->next;
 	}
 }
 
@@ -935,10 +914,9 @@ void show_lines(GList *item_queue, int item_queue_count)
 static void show_details(struct sym_entry *sym)
 {
 	struct source_line *line;
-	GList *item;
+	struct source_line *line_queue = NULL;
 	int displayed = 0;
-	GList *item_queue = NULL;
-	int item_queue_count = 0;
+	int line_queue_count = 0;
 
 	if (!sym->source)
 		lookup_sym_in_vmlinux(sym);
@@ -947,30 +925,29 @@ static void show_details(struct sym_entry *sym)
 
 	printf("Showing details for %s\n", sym->sym);
 
-	item = sym->source;
-	while (item) {
-		line = item->data;
+	line = sym->source;
+	while (line) {
 		if (displayed && strstr(line->line, ">:"))
 			break;
 
-		if (!item_queue_count)
-			item_queue = item;
-		item_queue_count ++;
+		if (!line_queue_count)
+			line_queue = line;
+		line_queue_count ++;
 
 		if (line->count >= count_filter) {
-			show_lines(item_queue, item_queue_count);
-			item_queue_count = 0;
-			item_queue = NULL;
-		} else if (item_queue_count > TRACE_COUNT) {
-			item_queue = g_list_next(item_queue);
-			item_queue_count --;
+			show_lines(line_queue, line_queue_count);
+			line_queue_count = 0;
+			line_queue = NULL;
+		} else if (line_queue_count > TRACE_COUNT) {
+			line_queue = line_queue->next;
+			line_queue_count --;
 		}
 
 		line->count = 0;
 		displayed++;
 		if (displayed > 300)
 			break;
-		item = g_list_next(item);
+		line = line->next;
 	}
 }
 
@@ -1201,6 +1178,10 @@ int main(int argc, char *argv[])
 	if (tid != -1 || profile_cpu != -1)
 		nr_cpus = 1;
 
+	parse_symbols();
+	if (vmlinux && sym_filter_entry)
+		parse_vmlinux(vmlinux);
+
 	for (i = 0; i < nr_cpus; i++) {
 		group_fd = -1;
 		for (counter = 0; counter < nr_counters; counter++) {
@@ -1216,15 +1197,16 @@ int main(int argc, char *argv[])
 			hw_event.nmi		= nmi;
 
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
-			fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
 			if (fd[i][counter] < 0) {
+				int err = errno;
 				printf("kerneltop error: syscall returned with %d (%s)\n",
-					fd[i][counter], strerror(-fd[i][counter]));
-				if (fd[i][counter] == -1)
+					fd[i][counter], strerror(err));
+				if (err == EPERM)
 					printf("Are you root?\n");
 				exit(-1);
 			}
 			assert(fd[i][counter] >= 0);
+			fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
 
 			/*
 			 * First counter acts as the group leader:
@@ -1248,10 +1230,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	parse_symbols();
-	if (vmlinux && sym_filter_entry)
-		parse_vmlinux(vmlinux);
-
 	printf("KernelTop refresh period: %d seconds\n", delay_secs);
 	last_refresh = time(NULL);
 
