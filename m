Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab0CKWNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:13:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab0CKWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:13:50 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/6] perf report: Initial TUI using newt
Date: Thu, 11 Mar 2010 19:13:35 -0300
Message-Id: <1268345617-31863-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268345617-31863-1-git-send-email-acme@infradead.org>
References: <1268345617-31863-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Newt has widespread availability and provides a rather simple API as can be
seen by the size of this patch.

The work needed to support it will benefit other frontends too.

In this initial patch it just checks if the output is a tty, if not it falls
back to the previous behaviour, also if newt-devel/libnewt-dev is not installed
the previous behaviour is maintaned.

Pressing enter on a symbol will annotate it, enter again and the report is
back on the screen.

Cc: Avi Kivity <avi@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile         |    8 ++
 tools/perf/builtin-report.c |   47 +++++++-----
 tools/perf/perf.c           |    2 +
 tools/perf/util/cache.h     |   14 ++++
 tools/perf/util/color.c     |    5 +-
 tools/perf/util/debug.c     |    6 +-
 tools/perf/util/debug.h     |    1 +
 tools/perf/util/hist.c      |   10 +-
 tools/perf/util/hist.h      |    5 +
 tools/perf/util/newt.c      |  170 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h   |    9 ++
 11 files changed, 251 insertions(+), 26 deletions(-)
 create mode 100644 tools/perf/util/newt.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8a8f52d..0abd25e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -513,6 +513,14 @@ else
 	LIB_OBJS += util/probe-finder.o
 endif
 
+ifneq ($(shell sh -c "(echo '\#include <newt.h>'; echo 'int main(void) { newtInit(); newtCls(); return newtFinished(); }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -lnewt -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+	msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
+	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
+else
+	EXTLIBS += -lnewt
+	LIB_OBJS += util/newt.o
+endif
+
 ifndef NO_LIBPERL
 PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
 PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f815de2..1f9f869 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -267,6 +267,7 @@ static int __cmd_report(void)
 	int ret = -EINVAL;
 	struct perf_session *session;
 	struct rb_node *next;
+	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
 	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
@@ -301,30 +302,38 @@ static int __cmd_report(void)
 		stats = rb_entry(next, struct event_stat_id, rb_node);
 		perf_session__collapse_resort(&stats->hists);
 		perf_session__output_resort(&stats->hists, stats->stats.total);
-		if (rb_first(&session->stats_by_id) ==
-		    rb_last(&session->stats_by_id))
-			fprintf(stdout, "# Samples: %Ld\n#\n",
-				stats->stats.total);
-		else
-			fprintf(stdout, "# Samples: %Ld %s\n#\n",
-				stats->stats.total,
-				__event_name(stats->type, stats->config));
 
-		perf_session__fprintf_hists(&stats->hists, NULL, false, stdout,
+		if (use_browser)
+			perf_session__browse_hists(&stats->hists,
+						   stats->stats.total, help);
+		else {
+			if (rb_first(&session->stats_by_id) ==
+			    rb_last(&session->stats_by_id))
+				fprintf(stdout, "# Samples: %Ld\n#\n",
+					stats->stats.total);
+			else
+				fprintf(stdout, "# Samples: %Ld %s\n#\n",
+					stats->stats.total,
+					__event_name(stats->type, stats->config));
+
+			perf_session__fprintf_hists(&stats->hists, NULL, false, stdout,
 					    stats->stats.total);
-		fprintf(stdout, "\n\n");
+			fprintf(stdout, "\n\n");
+		}
+
 		next = rb_next(&stats->rb_node);
 	}
 
-	if (sort_order == default_sort_order &&
-	    parent_pattern == default_parent_pattern)
-		fprintf(stdout, "#\n# (For a higher level overview, try: perf report --sort comm,dso)\n#\n");
+	if (!use_browser && sort_order == default_sort_order &&
+	    parent_pattern == default_parent_pattern) {
+		fprintf(stdout, "#\n# (%s)\n#\n", help);
 
-	if (show_threads) {
-		bool raw_printing_style = !strcmp(pretty_printing_style, "raw");
-		perf_read_values_display(stdout, &show_threads_values,
-					 raw_printing_style);
-		perf_read_values_destroy(&show_threads_values);
+		if (show_threads) {
+			bool style = !strcmp(pretty_printing_style, "raw");
+			perf_read_values_display(stdout, &show_threads_values,
+						 style);
+			perf_read_values_destroy(&show_threads_values);
+		}
 	}
 out_delete:
 	perf_session__delete(session);
@@ -447,7 +456,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	setup_pager();
+	setup_browser();
 
 	if (symbol__init() < 0)
 		return -1;
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 57cb107..9ff186b 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -265,6 +265,8 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	if (status)
 		return status & 0xff;
 
+	exit_browser();
+
 	/* Somebody closed stdout? */
 	if (fstat(fileno(stdout), &st))
 		return 0;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 918eb37..47b12a3 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_CACHE_H
 #define __PERF_CACHE_H
 
+#include <stdbool.h>
 #include "util.h"
 #include "strbuf.h"
 #include "../perf.h"
@@ -69,6 +70,19 @@ extern const char *pager_program;
 extern int pager_in_use(void);
 extern int pager_use_color;
 
+extern bool use_browser;
+
+#ifdef NO_NEWT_SUPPORT
+static inline void setup_browser(void)
+{
+	setup_pager();
+}
+static inline void exit_browser(void) {}
+#else
+void setup_browser(void);
+void exit_browser(void);
+#endif
+
 extern const char *editor_program;
 extern const char *excludes_file;
 
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index e88bca5..9da0191 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -203,7 +203,10 @@ int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
 	int r;
 
 	va_start(args, fmt);
-	r = color_vfprintf(fp, color, fmt, args);
+	if (use_browser)
+		r = vfprintf(fp, fmt, args);
+	else
+		r = color_vfprintf(fp, color, fmt, args);
 	va_end(args);
 	return r;
 }
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 0905600..033d66d 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -6,6 +6,7 @@
 #include <stdarg.h>
 #include <stdio.h>
 
+#include "cache.h"
 #include "color.h"
 #include "event.h"
 #include "debug.h"
@@ -21,7 +22,10 @@ int eprintf(int level, const char *fmt, ...)
 
 	if (verbose >= level) {
 		va_start(args, fmt);
-		ret = vfprintf(stderr, fmt, args);
+		if (use_browser)
+			ret = browser__show_help(fmt, args);
+		else
+			ret = vfprintf(stderr, fmt, args);
 		va_end(args);
 	}
 
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 58720a1..03accb8 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -9,5 +9,6 @@ extern int dump_trace;
 
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
+int browser__show_help(const char *format, va_list ap);
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index bdcfd61..9a5be25 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -455,11 +455,11 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-static size_t hist_entry__fprintf(struct hist_entry *self,
-				  struct perf_session *pair_session,
-				  bool show_displacement,
-				  long displacement, FILE *fp,
-				  u64 session_total)
+size_t hist_entry__fprintf(struct hist_entry *self,
+			   struct perf_session *pair_session,
+			   bool show_displacement,
+			   long displacement, FILE *fp,
+			   u64 session_total)
 {
 	struct sort_entry *se;
 	u64 count, total;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 16f360c..fe366ce 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -18,6 +18,11 @@ struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 						  u64 count, bool *hit);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
+size_t hist_entry__fprintf(struct hist_entry *self,
+			   struct perf_session *pair_session,
+			   bool show_displacement,
+			   long displacement, FILE *fp,
+			   u64 session_total);
 void hist_entry__free(struct hist_entry *);
 
 void perf_session__output_resort(struct rb_root *hists, u64 total_samples);
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
new file mode 100644
index 0000000..36244dc
--- /dev/null
+++ b/tools/perf/util/newt.c
@@ -0,0 +1,170 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#undef _GNU_SOURCE
+
+#include <stdlib.h>
+#include <newt.h>
+
+#include "cache.h"
+#include "hist.h"
+#include "session.h"
+#include "sort.h"
+#include "symbol.h"
+
+static void hist_entry__append_browser(struct hist_entry *self,
+				       newtComponent listbox, u64 total)
+{
+	char bf[1024];
+	FILE *fp;
+
+	if (symbol_conf.exclude_other && !self->parent)
+		return;
+
+	fp = fmemopen(bf, sizeof(bf), "w");
+	if (fp == NULL)
+		return;
+
+	hist_entry__fprintf(self, NULL, false, 0, fp, total);
+
+	fclose(fp);
+	newtListboxAppendEntry(listbox, bf, self);
+}
+
+static void hist_entry__annotate_browser(struct hist_entry *self)
+{
+	FILE *fp;
+	struct winsize ws;
+	newtComponent form, listbox;
+	struct newtExitStruct es;
+	char *str;
+	size_t line_len;
+	char *line = NULL;
+
+	if (self->sym == NULL)
+		return;
+
+	if (asprintf(&str, "perf annotate %s", self->sym->name) < 0)
+		return;
+
+	fp = popen(str, "r");
+	if (fp == NULL)
+		goto out_free_str;
+
+	get_term_dimensions(&ws);
+	newtCenteredWindow(ws.ws_col, ws.ws_row, self->sym->name);
+	form = newtForm(NULL, NULL, 0);
+	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
+	listbox = newtListbox(10, 1, ws.ws_row - 2, NEWT_FLAG_SCROLL | NEWT_FLAG_RETURNEXIT);
+	newtFormAddComponents(form, listbox, NULL);
+	while (!feof(fp)) {
+		if (getline(&line, &line_len, fp) < 0 || !line_len)
+			break;
+		newtListboxAppendEntry(listbox, line, NULL);
+		line = NULL;
+	}
+
+	fclose(fp);
+	newtFormRun(form, &es);
+	newtPopWindow();
+	newtFormDestroy(form);
+out_free_str:
+	free(str);
+}
+
+void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
+				const char *helpline)
+{
+	struct sort_entry *se;
+	struct rb_node *nd;
+	unsigned int width;
+	char *col_width = symbol_conf.col_width_list_str;
+	struct winsize ws;
+	char str[1024];
+	newtComponent form, listbox;
+	struct newtExitStruct es;
+
+	snprintf(str, sizeof(str), "Samples: %Ld", session_total);
+	newtDrawRootText(0, 0, str);
+	newtPushHelpLine(helpline);
+
+	get_term_dimensions(&ws);
+
+	form = newtForm(NULL, NULL, 0);
+	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
+
+	listbox = newtListbox(1, 1, ws.ws_row - 2, NEWT_FLAG_SCROLL | NEWT_FLAG_BORDER | NEWT_FLAG_RETURNEXIT);
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+		width = strlen(se->header);
+		if (se->width) {
+			if (symbol_conf.col_width_list_str) {
+				if (col_width) {
+					*se->width = atoi(col_width);
+					col_width = strchr(col_width, ',');
+					if (col_width)
+						++col_width;
+				}
+			}
+			*se->width = max(*se->width, width);
+		}
+	}
+
+	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		hist_entry__append_browser(h, listbox, session_total);
+	}
+
+	newtFormAddComponents(form, listbox, NULL);
+
+	while (1) {
+		struct hist_entry *selection;
+
+		newtFormRun(form, &es);
+		if (es.reason == NEWT_EXIT_HOTKEY)
+			break;
+		selection = newtListboxGetCurrent(listbox);
+		hist_entry__annotate_browser(selection);
+	}
+
+	newtFormDestroy(form);
+}
+
+int browser__show_help(const char *format, va_list ap)
+{
+	int ret;
+	static int backlog;
+	static char msg[1024];
+
+        ret = vsnprintf(msg + backlog, sizeof(msg) - backlog, format, ap);
+	backlog += ret;
+
+	if (msg[backlog - 1] == '\n') {
+		newtPopHelpLine();
+		newtPushHelpLine(msg);
+		newtRefresh();
+		backlog = 0;
+	}
+
+	return ret;
+}
+
+bool use_browser;
+
+void setup_browser(void)
+{
+	if (!isatty(1))
+		return;
+
+	use_browser = true;
+	newtInit();
+	newtCls();
+	newtPushHelpLine(" ");
+}
+
+void exit_browser(void)
+{
+	if (use_browser)
+		newtFinished();
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 5c33417..34d7339 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -86,4 +86,13 @@ static inline struct map *
 {
 	return map_groups__new_module(&self->kmaps, start, filename);
 }
+
+#ifdef NO_NEWT_SUPPORT
+static inline void perf_session__browse_hists(struct rb_root *hists __used,
+					      u64 session_total __used,
+					      const char *helpline __used) {}
+#else
+void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
+				const char *helpline);
+#endif
 #endif /* __PERF_SESSION_H */
-- 
1.5.5.1

