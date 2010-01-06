Return-Path: <linux-kernel-owner+w=401wt.eu-S932254Ab0AFOjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0AFOjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 09:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235Ab0AFOja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 09:39:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab0AFOj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 09:39:29 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip] perf probe: Support --line option to show probable
	source-code lines
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Date: Wed, 06 Jan 2010 09:45:34 -0500
Message-ID: <20100106144534.27218.77939.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <4B449F38.8020803@redhat.com>
References: <4B449F38.8020803@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --line option to support showing probable source-code lines.

perf probe --line SRC:LN[-LN|+NUM]
 or
perf probe --line FUNC[:LN[-LN|+NUM]]

This option shows source-code with line number if the line can be
probed. Lines without line number (and blue color) means that the
line can not be probed, because debuginfo doesn't have the
information of those lines.

The argument specifies the range of lines, "source.c:100-120" shows
lines between 100th to l20th in source.c file. And "func:10+20"
shows 20 lines from 10th line of func function.

e.g.
 # ./perf probe --line kernel/sched.c:1080
 <kernel/sched.c:1080>
          *
          * called with rq->lock held and irqs disabled
          */
         static void hrtick_start(struct rq *rq, u64 delay)
         {
                struct hrtimer *timer = &rq->hrtick_timer;
   1086         ktime_t time = ktime_add_ns(timer->base->get_time(), delay);

                hrtimer_set_expires(timer, time);

   1090         if (rq == this_rq()) {
   1091                 hrtimer_restart(timer);
   1092         } else if (!rq->hrtick_csd_pending) {
   1093                 __smp_call_function_single(cpu_of(rq), &rq->hrtick_csd,
   1094                 rq->hrtick_csd_pending = 1;

If you specifying function name, this shows function-relative line number.
 # ./perf probe --line schedule
 <schedule:0>
         asmlinkage void __sched schedule(void)
      1  {
                struct task_struct *prev, *next;
                unsigned long *switch_count;
                struct rq *rq;
                int cpu;

         need_resched:
                preempt_disable();
      9         cpu = smp_processor_id();
     10         rq = cpu_rq(cpu);
     11         rcu_sched_qs(cpu);
     12         prev = rq->curr;
     13         switch_count = &prev->nivcsw;

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---

 tools/perf/Documentation/perf-probe.txt |   20 +++
 tools/perf/builtin-probe.c              |   76 ++++++++++--
 tools/perf/util/probe-event.c           |  100 ++++++++++++++++
 tools/perf/util/probe-event.h           |    2 
 tools/perf/util/probe-finder.c          |  191 ++++++++++++++++++++++++++++++-
 tools/perf/util/probe-finder.h          |   31 +++++
 6 files changed, 402 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 250e391..2de3407 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -15,6 +15,8 @@ or
 'perf probe' [options] --del='[GROUP:]EVENT' [...]
 or
 'perf probe' --list
+or
+'perf probe' --line='FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]'
 
 DESCRIPTION
 -----------
@@ -45,6 +47,11 @@ OPTIONS
 --list::
 	List up current probe events.
 
+-L::
+--line=::
+	Show source code lines which can be probed. This needs an argument
+	which specifies a range of the source code.
+
 PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
@@ -56,6 +63,19 @@ Probe points are defined by following syntax.
 It is also possible to specify a probe point by the source line number by using 'SRC:ALN' syntax, where 'SRC' is the source file path and 'ALN' is the line number.
 'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
 
+LINE SYNTAX
+-----------
+Line range is descripted by following syntax.
+
+ "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]"
+
+FUNC specifies the function name of showing lines. 'RLN' is the start line
+number from function entry line, and 'RLN2' is the end line number. As same as
+probe syntax, 'SRC' means the source file path, 'ALN' is start line number,
+and 'ALN2' is end line number in the file. It is also possible to specify how
+many lines to show by using 'NUM'.
+So, "source.c:100-120" shows lines between 100th to l20th in source.c file. And "func:10+20" shows 20 lines from 10th line of func function.
+
 SEE ALSO
 --------
 linkperf:perf-trace[1], linkperf:perf-record[1]
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index ffdd3fe..1d3a99e 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -55,11 +55,13 @@ static struct {
 	bool need_dwarf;
 	bool list_events;
 	bool force_add;
+	bool show_lines;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
 	struct perf_session *psession;
 	struct map *kmap;
+	struct line_range line_range;
 } session;
 
 
@@ -116,6 +118,15 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
+static int opt_show_lines(const struct option *opt __used,
+			  const char *str, int unset __used)
+{
+	if (str)
+		parse_line_range_desc(str, &session.line_range);
+	INIT_LIST_HEAD(&session.line_range.line_list);
+	session.show_lines = true;
+	return 0;
+}
 /* Currently just checking function name from symbol map */
 static void evaluate_probe_point(struct probe_point *pp)
 {
@@ -144,6 +155,7 @@ static const char * const probe_usage[] = {
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 	"perf probe --list",
+	"perf probe --line 'LINEDESC'",
 	NULL
 };
 
@@ -182,9 +194,32 @@ static const struct option options[] = {
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &session.force_add, "forcibly add events"
 		    " with existing name"),
+#ifndef NO_LIBDWARF
+	OPT_CALLBACK('L', "line", NULL,
+		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
+		     "Show source code lines.", opt_show_lines),
+#endif
 	OPT_END()
 };
 
+/* Initialize symbol maps for vmlinux */
+static void init_vmlinux(void)
+{
+	symbol_conf.sort_by_name = true;
+	if (symbol_conf.vmlinux_name == NULL)
+		symbol_conf.try_vmlinux_path = true;
+	else
+		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
+	if (symbol__init() < 0)
+		die("Failed to init symbol map.");
+	session.psession = perf_session__new(NULL, O_WRONLY, false);
+	if (session.psession == NULL)
+		die("Failed to init perf_session.");
+	session.kmap = session.psession->vmlinux_maps[MAP__FUNCTION];
+	if (!session.kmap)
+		die("Could not find kernel map.\n");
+}
+
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
 	int i, ret;
@@ -203,7 +238,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		parse_probe_event_argv(argc, argv);
 	}
 
-	if ((!session.nr_probe && !session.dellist && !session.list_events))
+	if ((!session.nr_probe && !session.dellist && !session.list_events &&
+	     !session.show_lines))
 		usage_with_options(probe_usage, options);
 
 	if (debugfs_valid_mountpoint(debugfs_path) < 0)
@@ -215,10 +251,34 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 				   " --add/--del.\n");
 			usage_with_options(probe_usage, options);
 		}
+		if (session.show_lines) {
+			pr_warning("  Error: Don't use --list with --line.\n");
+			usage_with_options(probe_usage, options);
+		}
 		show_perf_probe_events();
 		return 0;
 	}
 
+#ifndef NO_LIBDWARF
+	if (session.show_lines) {
+		if (session.nr_probe != 0 || session.dellist) {
+			pr_warning("  Error: Don't use --line with"
+				   " --add/--del.\n");
+			usage_with_options(probe_usage, options);
+		}
+		init_vmlinux();
+		fd = open_vmlinux();
+		if (fd < 0)
+			die("Could not open debuginfo file.");
+		ret = find_line_range(fd, &session.line_range);
+		if (ret <= 0)
+			die("Source line is not found.\n");
+		close(fd);
+		show_line_range(&session.line_range);
+		return 0;
+	}
+#endif
+
 	if (session.dellist) {
 		del_trace_kprobe_events(session.dellist);
 		strlist__delete(session.dellist);
@@ -226,18 +286,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			return 0;
 	}
 
-	/* Initialize symbol maps for vmlinux */
-	symbol_conf.sort_by_name = true;
-	if (symbol_conf.vmlinux_name == NULL)
-		symbol_conf.try_vmlinux_path = true;
-	if (symbol__init() < 0)
-		die("Failed to init symbol map.");
-	session.psession = perf_session__new(NULL, O_WRONLY, false);
-	if (session.psession == NULL)
-		die("Failed to init perf_session.");
-	session.kmap = session.psession->vmlinux_maps[MAP__FUNCTION];
-	if (!session.kmap)
-		die("Could not find kernel map.\n");
+	/* Add probes */
+	init_vmlinux();
 
 	if (session.need_dwarf)
 #ifdef NO_LIBDWARF
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a22141a..71b0dd5 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -38,6 +38,7 @@
 #include "strlist.h"
 #include "debug.h"
 #include "cache.h"
+#include "color.h"
 #include "parse-events.h"  /* For debugfs_path */
 #include "probe-event.h"
 
@@ -63,6 +64,42 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 	return ret;
 }
 
+void parse_line_range_desc(const char *arg, struct line_range *lr)
+{
+	const char *ptr;
+	char *tmp;
+	/*
+	 * <Syntax>
+	 * SRC:SLN[+NUM|-ELN]
+	 * FUNC[:SLN[+NUM|-ELN]]
+	 */
+	ptr = strchr(arg, ':');
+	if (ptr) {
+		lr->start = (unsigned int)strtoul(ptr + 1, &tmp, 0);
+		if (*tmp == '+')
+			lr->end = lr->start + (unsigned int)strtoul(tmp + 1,
+								    &tmp, 0);
+		else if (*tmp == '-')
+			lr->end = (unsigned int)strtoul(tmp + 1, &tmp, 0);
+		else
+			lr->end = 0;
+		pr_debug("Line range is %u to %u\n", lr->start, lr->end);
+		if (lr->end && lr->start > lr->end)
+			semantic_error("Start line must be smaller"
+				       " than end line.");
+		if (*tmp != '\0')
+			semantic_error("Tailing with invalid character '%d'.",
+				       *tmp);
+		tmp = strndup(arg, (ptr - arg));
+	} else
+		tmp = strdup(arg);
+
+	if (strchr(tmp, '.'))
+		lr->file = tmp;
+	else
+		lr->function = tmp;
+}
+
 /* Check the name is good for event/group */
 static bool check_event_name(const char *name)
 {
@@ -678,3 +715,66 @@ void del_trace_kprobe_events(struct strlist *dellist)
 	close(fd);
 }
 
+#define LINEBUF_SIZE 256
+
+static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
+{
+	char buf[LINEBUF_SIZE];
+	const char *color = PERF_COLOR_BLUE;
+
+	if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
+		goto error;
+	if (!skip) {
+		if (show_num)
+			fprintf(stdout, "%7u  %s", l, buf);
+		else
+			color_fprintf(stdout, color, "         %s", buf);
+	}
+
+	while (strlen(buf) == LINEBUF_SIZE - 1 &&
+	       buf[LINEBUF_SIZE - 2] != '\n') {
+		if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
+			goto error;
+		if (!skip) {
+			if (show_num)
+				fprintf(stdout, "%s", buf);
+			else
+				color_fprintf(stdout, color, "%s", buf);
+		}
+	}
+	return;
+error:
+	if (feof(fp))
+		die("Source file is shorter than expected.");
+	else
+		die("File read error: %s", strerror(errno));
+}
+
+void show_line_range(struct line_range *lr)
+{
+	unsigned int l = 1;
+	struct line_node *ln;
+	FILE *fp;
+
+	setup_pager();
+
+	if (lr->function)
+		fprintf(stdout, "<%s:%d>\n", lr->function,
+			lr->start - lr->offset);
+	else
+		fprintf(stdout, "<%s:%d>\n", lr->file, lr->start);
+
+	fp = fopen(lr->path, "r");
+	if (fp == NULL)
+		die("Failed to open %s: %s", lr->path, strerror(errno));
+	/* Skip to starting line number */
+	while (l < lr->start)
+		show_one_line(fp, l++, true, false);
+
+	list_for_each_entry(ln, &lr->line_list, list) {
+		while (ln->line > l)
+			show_one_line(fp, (l++) - lr->offset, false, false);
+		show_one_line(fp, (l++) - lr->offset, false, true);
+	}
+	fclose(fp);
+}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 7f1d499..711287d 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -5,6 +5,7 @@
 #include "probe-finder.h"
 #include "strlist.h"
 
+extern void parse_line_range_desc(const char *arg, struct line_range *lr);
 extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
 				   bool *need_dwarf);
 extern int synthesize_perf_probe_point(struct probe_point *pp);
@@ -15,6 +16,7 @@ extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
 				    bool force_add);
 extern void del_trace_kprobe_events(struct strlist *dellist);
 extern void show_perf_probe_events(void);
+extern void show_line_range(struct line_range *lr);
 
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 6402798..1b2124d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -140,6 +140,31 @@ static Dwarf_Unsigned cu_find_fileno(Dwarf_Die cu_die, const char *fname)
 	return found;
 }
 
+static int cu_get_filename(Dwarf_Die cu_die, Dwarf_Unsigned fno, char **buf)
+{
+	Dwarf_Signed cnt, i;
+	char **srcs;
+	int ret = 0;
+
+	if (!buf || !fno)
+		return -EINVAL;
+
+	ret = dwarf_srcfiles(cu_die, &srcs, &cnt, &__dw_error);
+	if (ret == DW_DLV_OK) {
+		if ((Dwarf_Unsigned)cnt > fno - 1) {
+			*buf = strdup(srcs[fno - 1]);
+			ret = 0;
+			pr_debug("found filename: %s\n", *buf);
+		} else
+			ret = -ENOENT;
+		for (i = 0; i < cnt; i++)
+			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
+		dwarf_dealloc(__dw_debug, srcs, DW_DLA_LIST);
+	} else
+		ret = -EINVAL;
+	return ret;
+}
+
 /* Compare diename and tname */
 static int die_compare_name(Dwarf_Die dw_die, const char *tname)
 {
@@ -567,7 +592,7 @@ static int probeaddr_callback(struct die_link *dlink, void *data)
 }
 
 /* Find probe point from its line number */
-static void find_by_line(struct probe_finder *pf)
+static void find_probe_point_by_line(struct probe_finder *pf)
 {
 	Dwarf_Signed cnt, i, clm;
 	Dwarf_Line *lines;
@@ -626,7 +651,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 				pf->fno = die_get_decl_file(dlink->die);
 				pf->lno = die_get_decl_line(dlink->die)
 					 + pp->line;
-				find_by_line(pf);
+				find_probe_point_by_line(pf);
 				return 1;
 			}
 			if (die_inlined_subprogram(dlink->die)) {
@@ -673,7 +698,7 @@ found:
 	return 0;
 }
 
-static void find_by_func(struct probe_finder *pf)
+static void find_probe_point_by_func(struct probe_finder *pf)
 {
 	search_die_from_children(pf->cu_die, probefunc_callback, pf);
 }
@@ -714,10 +739,10 @@ int find_probepoint(int fd, struct probe_point *pp)
 			if (ret == DW_DLV_NO_ENTRY)
 				pf.cu_base = 0;
 			if (pp->function)
-				find_by_func(&pf);
+				find_probe_point_by_func(&pf);
 			else {
 				pf.lno = pp->line;
-				find_by_line(&pf);
+				find_probe_point_by_line(&pf);
 			}
 		}
 		dwarf_dealloc(__dw_debug, pf.cu_die, DW_DLA_DIE);
@@ -728,3 +753,159 @@ int find_probepoint(int fd, struct probe_point *pp)
 	return pp->found;
 }
 
+
+static void line_range_add_line(struct line_range *lr, unsigned int line)
+{
+	struct line_node *ln;
+	struct list_head *p;
+
+	/* Reverse search, because new line will be the last one */
+	list_for_each_entry_reverse(ln, &lr->line_list, list) {
+		if (ln->line < line) {
+			p = &ln->list;
+			goto found;
+		} else if (ln->line == line)	/* Already exist */
+			return ;
+	}
+	/* List is empty, or the smallest entry */
+	p = &lr->line_list;
+found:
+	pr_debug("Debug: add a line %u\n", line);
+	ln = zalloc(sizeof(struct line_node));
+	DIE_IF(ln == NULL);
+	ln->line = line;
+	INIT_LIST_HEAD(&ln->list);
+	list_add(&ln->list, p);
+}
+
+/* Find line range from its line number */
+static void find_line_range_by_line(struct line_finder *lf)
+{
+	Dwarf_Signed cnt, i;
+	Dwarf_Line *lines;
+	Dwarf_Unsigned lineno = 0;
+	Dwarf_Unsigned fno;
+	Dwarf_Addr addr;
+	int ret;
+
+	ret = dwarf_srclines(lf->cu_die, &lines, &cnt, &__dw_error);
+	DIE_IF(ret != DW_DLV_OK);
+
+	for (i = 0; i < cnt; i++) {
+		ret = dwarf_line_srcfileno(lines[i], &fno, &__dw_error);
+		DIE_IF(ret != DW_DLV_OK);
+		if (fno != lf->fno)
+			continue;
+
+		ret = dwarf_lineno(lines[i], &lineno, &__dw_error);
+		DIE_IF(ret != DW_DLV_OK);
+		if (lf->lno_s > lineno || lf->lno_e < lineno)
+			continue;
+
+		/* Filter line in the function address range */
+		if (lf->addr_s && lf->addr_e) {
+			ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
+			DIE_IF(ret != DW_DLV_OK);
+			if (lf->addr_s > addr || lf->addr_e <= addr)
+				continue;
+		}
+		line_range_add_line(lf->lr, (unsigned int)lineno);
+	}
+	dwarf_srclines_dealloc(__dw_debug, lines, cnt);
+	if (!list_empty(&lf->lr->line_list))
+		lf->found = 1;
+}
+
+/* Search function from function name */
+static int linefunc_callback(struct die_link *dlink, void *data)
+{
+	struct line_finder *lf = (struct line_finder *)data;
+	struct line_range *lr = lf->lr;
+	Dwarf_Half tag;
+	int ret;
+
+	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
+	DIE_IF(ret == DW_DLV_ERROR);
+	if (tag == DW_TAG_subprogram &&
+	    die_compare_name(dlink->die, lr->function) == 0) {
+		/* Get the address range of this function */
+		ret = dwarf_highpc(dlink->die, &lf->addr_e, &__dw_error);
+		if (ret == DW_DLV_OK)
+			ret = dwarf_lowpc(dlink->die, &lf->addr_s, &__dw_error);
+		DIE_IF(ret == DW_DLV_ERROR);
+		if (ret == DW_DLV_NO_ENTRY) {
+			lf->addr_s = 0;
+			lf->addr_e = 0;
+		}
+
+		lf->fno = die_get_decl_file(dlink->die);
+		lr->offset = die_get_decl_line(dlink->die);;
+		lf->lno_s = lr->offset + lr->start;
+		if (!lr->end)
+			lf->lno_e = (Dwarf_Unsigned)-1;
+		else
+			lf->lno_e = lr->offset + lr->end;
+		lr->start = lf->lno_s;
+		lr->end = lf->lno_e;
+		find_line_range_by_line(lf);
+		/* If we find a target function, this should be end. */
+		lf->found = 1;
+		return 1;
+	}
+	return 0;
+}
+
+static void find_line_range_by_func(struct line_finder *lf)
+{
+	search_die_from_children(lf->cu_die, linefunc_callback, lf);
+}
+
+int find_line_range(int fd, struct line_range *lr)
+{
+	Dwarf_Half addr_size = 0;
+	Dwarf_Unsigned next_cuh = 0;
+	int ret;
+	struct line_finder lf = {.lr = lr};
+
+	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
+	if (ret != DW_DLV_OK)
+		return -ENOENT;
+
+	while (!lf.found) {
+		/* Search CU (Compilation Unit) */
+		ret = dwarf_next_cu_header(__dw_debug, NULL, NULL, NULL,
+			&addr_size, &next_cuh, &__dw_error);
+		DIE_IF(ret == DW_DLV_ERROR);
+		if (ret == DW_DLV_NO_ENTRY)
+			break;
+
+		/* Get the DIE(Debugging Information Entry) of this CU */
+		ret = dwarf_siblingof(__dw_debug, 0, &lf.cu_die, &__dw_error);
+		DIE_IF(ret != DW_DLV_OK);
+
+		/* Check if target file is included. */
+		if (lr->file)
+			lf.fno = cu_find_fileno(lf.cu_die, lr->file);
+
+		if (!lr->file || lf.fno) {
+			if (lr->function)
+				find_line_range_by_func(&lf);
+			else {
+				lf.lno_s = lr->start;
+				if (!lr->end)
+					lf.lno_e = (Dwarf_Unsigned)-1;
+				else
+					lf.lno_e = lr->end;
+				find_line_range_by_line(&lf);
+			}
+			/* Get the real file path */
+			if (lf.found)
+				cu_get_filename(lf.cu_die, lf.fno, &lr->path);
+		}
+		dwarf_dealloc(__dw_debug, lf.cu_die, DW_DLA_DIE);
+	}
+	ret = dwarf_finish(__dw_debug, &__dw_error);
+	DIE_IF(ret != DW_DLV_OK);
+	return lf.found;
+}
+
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index e3f3968..972b386 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -34,8 +34,26 @@ struct probe_point {
 	char			*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
 };
 
+/* Line number container */
+struct line_node {
+	struct list_head	list;
+	unsigned int		line;
+};
+
+/* Line range */
+struct line_range {
+	char			*file;			/* File name */
+	char			*function;		/* Function name */
+	unsigned int		start;			/* Start line number */
+	unsigned int		end;			/* End line number */
+	unsigned int		offset;			/* Start line offset */
+	char			*path;			/* Real path name */
+	struct list_head	line_list;		/* Visible lines */
+};
+
 #ifndef NO_LIBDWARF
 extern int find_probepoint(int fd, struct probe_point *pp);
+extern int find_line_range(int fd, struct line_range *lr);
 
 /* Workaround for undefined _MIPS_SZLONG bug in libdwarf.h: */
 #ifndef _MIPS_SZLONG
@@ -62,6 +80,19 @@ struct probe_finder {
 	char			*buf;			/* Current output buffer */
 	int			len;			/* Length of output buffer */
 };
+
+struct line_finder {
+	struct line_range	*lr;			/* Target line range */
+
+	Dwarf_Unsigned		fno;			/* File number */
+	Dwarf_Unsigned		lno_s;			/* Start line number */
+	Dwarf_Unsigned		lno_e;			/* End line number */
+	Dwarf_Addr		addr_s;			/* Start address */
+	Dwarf_Addr		addr_e;			/* End address */
+	Dwarf_Die		cu_die;			/* Current CU */
+	int			found;
+};
+
 #endif /* NO_LIBDWARF */
 
 #endif /*_PROBE_FINDER_H */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
