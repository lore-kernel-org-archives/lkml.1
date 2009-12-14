Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbZLNWLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbZLNWLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbZLNWJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:09:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbZLNWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:09:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf diff: Introduce tool to show performance difference
Date: Mon, 14 Dec 2009 20:09:31 -0200
Message-Id: <1260828571-3613-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260828571-3613-1-git-send-email-acme@infradead.org>
References: <1260828571-3613-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

I guess it is enough to show some examples:

[root@doppio linux-2.6-tip]# rm -f perf.data*
[root@doppio linux-2.6-tip]# ls -la perf.data*
ls: cannot access perf.data*: No such file or directory
[root@doppio linux-2.6-tip]# perf record -f find / > /dev/null
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.062 MB perf.data (~2699 samples) ]
[root@doppio linux-2.6-tip]# ls -la perf.data*
-rw------- 1 root root 74440 2009-12-14 20:03 perf.data
[root@doppio linux-2.6-tip]# perf record -f find / > /dev/null
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.062 MB perf.data (~2692 samples) ]
[root@doppio linux-2.6-tip]# ls -la perf.data*
-rw------- 1 root root 74280 2009-12-14 20:03 perf.data
-rw------- 1 root root 74440 2009-12-14 20:03 perf.data.old
[root@doppio linux-2.6-tip]# perf diff | head -5
   1        -34994580     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
   2        -15307806         [kernel.kallsyms]   __kmalloc
   3    +1   +3665941     /lib64/libc-2.10.1.so   __GI_memmove
   4    +4  +23508995     /lib64/libc-2.10.1.so   _int_malloc
   5    +7  +38538813         [kernel.kallsyms]   __d_lookup
[root@doppio linux-2.6-tip]# perf diff -p | head -5
   1        +1.00%     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
   2                       [kernel.kallsyms]   __kmalloc
   3    +1             /lib64/libc-2.10.1.so   __GI_memmove
   4    +4             /lib64/libc-2.10.1.so   _int_malloc
   5    +7  -1.00%         [kernel.kallsyms]   __d_lookup
[root@doppio linux-2.6-tip]# perf diff -v | head -5
   1        361449551 326454971 -34994580     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
   2        151009241 135701435 -15307806         [kernel.kallsyms]   __kmalloc
   3    +1  101805328 105471269  +3665941     /lib64/libc-2.10.1.so   __GI_memmove
   4    +4   78041440 101550435 +23508995     /lib64/libc-2.10.1.so   _int_malloc
   5    +7   59536172  98074985 +38538813         [kernel.kallsyms]   __d_lookup
[root@doppio linux-2.6-tip]# perf diff -vp | head -5
   1        9.00% 8.00% +1.00%     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
   2        3.00% 3.00%                [kernel.kallsyms]   __kmalloc
   3    +1  2.00% 2.00%            /lib64/libc-2.10.1.so   __GI_memmove
   4    +4  2.00% 2.00%            /lib64/libc-2.10.1.so   _int_malloc
   5    +7  1.00% 2.00% -1.00%         [kernel.kallsyms]   __d_lookup
[root@doppio linux-2.6-tip]#

This should be enough for diffs where the system is non volatile, i.e. when one
doesn't updates binaries.

For volatile environments, stay tuned for the next perf tool feature: a buildid
cache populated by 'perf record', managed by 'perf buildid-cache' a-la ccache,
and used by all the report tools.

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |   31 ++++
 tools/perf/Makefile                    |    1 +
 tools/perf/builtin-diff.c              |  288 ++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                   |    1 +
 tools/perf/command-list.txt            |    1 +
 tools/perf/perf.c                      |    1 +
 tools/perf/util/sort.h                 |    8 +-
 7 files changed, 329 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-diff.txt
 create mode 100644 tools/perf/builtin-diff.c

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
new file mode 100644
index 0000000..bd1ee55
--- /dev/null
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -0,0 +1,31 @@
+perf-diff(1)
+==============
+
+NAME
+----
+perf-diff - Read perf.data (created by perf record) and display the profile
+
+SYNOPSIS
+--------
+[verse]
+'perf diff' [oldfile] [newfile]
+
+DESCRIPTION
+-----------
+This command displays the performance difference among two perf.data files
+captured via perf record.
+
+If no parameters are passed it will assume perf.data.old and perf.data.
+
+OPTIONS
+-------
+-p::
+--percentage::
+	Show percentages instead of raw counters
+-v::
+--verbose::
+	Be verbose, for instance, show the raw counters in addition to the
+	diff.
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a4cb792..87a424e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -427,6 +427,7 @@ BUILTIN_OBJS += bench/sched-messaging.o
 BUILTIN_OBJS += bench/sched-pipe.o
 BUILTIN_OBJS += bench/mem-memcpy.o
 
+BUILTIN_OBJS += builtin-diff.o
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
 BUILTIN_OBJS += builtin-buildid-list.o
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
new file mode 100644
index 0000000..0d52801
--- /dev/null
+++ b/tools/perf/builtin-diff.c
@@ -0,0 +1,288 @@
+/*
+ * builtin-diff.c
+ *
+ * Builtin diff command: Analyze two perf.data input files, look up and read
+ * DSOs and symbol information, sort them and produce a diff.
+ */
+#include "builtin.h"
+
+#include "util/debug.h"
+#include "util/event.h"
+#include "util/hist.h"
+#include "util/session.h"
+#include "util/sort.h"
+#include "util/symbol.h"
+#include "util/util.h"
+
+#include <stdlib.h>
+
+static char	   const *input_old = "perf.data.old",
+			 *input_new = "perf.data";
+static int	   force;
+static bool 	   show_percent;
+
+struct symbol_conf symbol_conf;
+
+static int perf_session__add_hist_entry(struct perf_session *self,
+					struct addr_location *al, u64 count)
+{
+	bool hit;
+	struct hist_entry *he = __perf_session__add_hist_entry(self, al, NULL,
+							       count, &hit);
+	if (he == NULL)
+		return -ENOMEM;
+
+	if (hit)
+		he->count += count;
+
+	return 0;
+}
+
+static int diff__process_sample_event(event_t *event, struct perf_session *session)
+{
+	struct addr_location al;
+	struct sample_data data = { .period = 1, };
+
+	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
+		    event->ip.pid, (void *)(long)event->ip.ip);
+
+	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
+		pr_warning("problem processing %d event, skipping it.\n",
+			   event->header.type);
+		return -1;
+	}
+
+	event__parse_sample(event, session->sample_type, &data);
+
+	if (al.sym && perf_session__add_hist_entry(session, &al, data.period)) {
+		pr_warning("problem incrementing symbol count, skipping event\n");
+		return -1;
+	}
+
+	session->events_stats.total += data.period;
+	return 0;
+}
+
+static struct perf_event_ops event_ops = {
+	.process_sample_event = diff__process_sample_event,
+	.process_mmap_event   = event__process_mmap,
+	.process_comm_event   = event__process_comm,
+	.process_exit_event   = event__process_task,
+	.process_fork_event   = event__process_task,
+	.process_lost_event   = event__process_lost,
+};
+
+static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
+						    struct hist_entry *he)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+
+	while (*p != NULL) {
+		int cmp;
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = strcmp(he->map->dso->name, iter->map->dso->name);
+		if (cmp > 0)
+			p = &(*p)->rb_left;
+		else if (cmp < 0)
+			p = &(*p)->rb_right;
+		else {
+			cmp = strcmp(he->sym->name, iter->sym->name);
+			if (cmp > 0)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+		}
+	}
+
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, root);
+}
+
+static void perf_session__resort_by_name(struct perf_session *self)
+{
+	unsigned long position = 1;
+	struct rb_root tmp = RB_ROOT;
+	struct rb_node *next = rb_first(&self->hists);
+
+	while (next != NULL) {
+		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
+
+		next = rb_next(&n->rb_node);
+		rb_erase(&n->rb_node, &self->hists);
+		n->position = position++;
+		perf_session__insert_hist_entry_by_name(&tmp, n);
+	}
+
+	self->hists = tmp;
+}
+
+static struct hist_entry *
+perf_session__find_hist_entry_by_name(struct perf_session *self,
+				      struct hist_entry *he)
+{
+	struct rb_node *n = self->hists.rb_node;
+
+	while (n) {
+		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
+		int cmp = strcmp(he->map->dso->name, iter->map->dso->name);
+
+		if (cmp > 0)
+			n = n->rb_left;
+		else if (cmp < 0)
+			n = n->rb_right;
+		else {
+			cmp = strcmp(he->sym->name, iter->sym->name);
+			if (cmp > 0)
+				n = n->rb_left;
+			else if (cmp < 0)
+				n = n->rb_right;
+			else
+				return iter;
+		}
+	}
+
+	return NULL;
+}
+
+static void perf_session__match_hists(struct perf_session *old_session,
+				      struct perf_session *new_session)
+{
+	struct rb_node *nd;
+
+	perf_session__resort_by_name(old_session);
+
+	for (nd = rb_first(&new_session->hists); nd; nd = rb_next(nd)) {
+		struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
+		pos->pair = perf_session__find_hist_entry_by_name(old_session, pos);
+	}
+}
+
+static size_t hist_entry__fprintf_matched(struct hist_entry *self,
+					  unsigned long pos,
+					  struct perf_session *session,
+					  struct perf_session *pair_session,
+					  FILE *fp)
+{
+	u64 old_count = 0;
+	char displacement[16];
+	size_t printed;
+
+	if (self->pair != NULL) {
+		long pdiff = (long)self->pair->position - (long)pos;
+		old_count = self->pair->count;
+		if (pdiff == 0)
+			goto blank;
+		snprintf(displacement, sizeof(displacement), "%+4ld", pdiff);
+	} else {
+blank:		memset(displacement, ' ', sizeof(displacement));
+	}
+
+	printed = fprintf(fp, "%4lu %5.5s ", pos, displacement);
+
+	if (show_percent) {
+		double old_percent = (old_count * 100) / pair_session->events_stats.total,
+		       new_percent = (self->count * 100) / session->events_stats.total;
+		double diff = old_percent - new_percent;
+
+		if (verbose)
+			printed += fprintf(fp, " %3.2f%% %3.2f%%", old_percent, new_percent);
+
+		if ((u64)diff != 0)
+			printed += fprintf(fp, " %+4.2F%%", diff);
+		else
+			printed += fprintf(fp, "       ");
+	} else {
+		if (verbose)
+			printed += fprintf(fp, " %9Lu %9Lu", old_count, self->count);
+		printed += fprintf(fp, " %+9Ld", (s64)self->count - (s64)old_count);
+	}
+
+	return printed + fprintf(fp, " %25.25s   %s\n",
+				 self->map->dso->name, self->sym->name);
+}
+
+static size_t perf_session__fprintf_matched_hists(struct perf_session *self,
+						  struct perf_session *pair,
+						  FILE *fp)
+{
+	struct rb_node *nd;
+	size_t printed = 0;
+	unsigned long pos = 1;
+
+	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
+		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
+		printed += hist_entry__fprintf_matched(he, pos++, self, pair, fp);
+	}
+
+	return printed;
+}
+
+static int __cmd_diff(void)
+{
+	int ret, i;
+	struct perf_session *session[2];
+
+	session[0] = perf_session__new(input_old, O_RDONLY, force, &symbol_conf);
+	session[1] = perf_session__new(input_new, O_RDONLY, force, &symbol_conf);
+	if (session[0] == NULL || session[1] == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < 2; ++i) {
+		ret = perf_session__process_events(session[i], &event_ops);
+		if (ret)
+			goto out_delete;
+		perf_session__output_resort(session[i], session[i]->events_stats.total);
+	}
+
+	perf_session__match_hists(session[0], session[1]);
+	perf_session__fprintf_matched_hists(session[1], session[0], stdout);
+out_delete:
+	for (i = 0; i < 2; ++i)
+		perf_session__delete(session[i]);
+	return ret;
+}
+
+static const char *const diff_usage[] = {
+	"perf diff [<options>] [old_file] [new_file]",
+};
+
+static const struct option options[] = {
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
+		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
+	OPT_BOOLEAN('p', "percentages", &show_percent,
+		    "Don't shorten the pathnames taking into account the cwd"),
+	OPT_BOOLEAN('P', "full-paths", &event_ops.full_paths,
+		    "Don't shorten the pathnames taking into account the cwd"),
+	OPT_END()
+};
+
+int cmd_diff(int argc, const char **argv, const char *prefix __used)
+{
+	if (symbol__init(&symbol_conf) < 0)
+		return -1;
+
+	setup_sorting(diff_usage, options);
+
+	argc = parse_options(argc, argv, options, diff_usage, 0);
+	if (argc) {
+		if (argc > 2)
+			usage_with_options(diff_usage, options);
+		if (argc == 2) {
+			input_old = argv[0];
+			input_new = argv[1];
+		} else
+			input_new = argv[0];
+	}
+
+	setup_pager();
+	return __cmd_diff();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index a3d8bf6..18035b1 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -17,6 +17,7 @@ extern int check_pager_config(const char *cmd);
 extern int cmd_annotate(int argc, const char **argv, const char *prefix);
 extern int cmd_bench(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_list(int argc, const char **argv, const char *prefix);
+extern int cmd_diff(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
 extern int cmd_sched(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 02b09ea..71dc7c3 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -5,6 +5,7 @@
 perf-annotate			mainporcelain common
 perf-bench			mainporcelain common
 perf-buildid-list		mainporcelain common
+perf-diff			mainporcelain common
 perf-list			mainporcelain common
 perf-sched			mainporcelain common
 perf-record			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index cf64049..873e55f 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -286,6 +286,7 @@ static void handle_internal_command(int argc, const char **argv)
 	const char *cmd = argv[0];
 	static struct cmd_struct commands[] = {
 		{ "buildid-list", cmd_buildid_list, 0 },
+		{ "diff",	cmd_diff,	0 },
 		{ "help",	cmd_help,	0 },
 		{ "list",	cmd_list,	0 },
 		{ "record",	cmd_record,	0 },
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index cb6151c..925f083 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,9 +49,13 @@ struct hist_entry {
 	struct symbol		*sym;
 	u64			ip;
 	char			level;
-	struct symbol		*parent;
+	struct symbol	  *parent;
 	struct callchain_node	callchain;
-	struct rb_root		sorted_chain;
+	union {
+		unsigned long	  position;
+		struct hist_entry *pair;
+		struct rb_root	  sorted_chain;
+	};
 };
 
 enum sort_type {
-- 
1.6.2.5

