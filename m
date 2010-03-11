Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab0CKWOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:14:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:57078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab0CKWNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:13:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/6] perf report: Initial TUI using newt
Date: Thu, 11 Mar 2010 19:13:37 -0300
Message-Id: <1268345617-31863-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268345617-31863-1-git-send-email-acme@infradead.org>
References: <1268345617-31863-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
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

Pressing enter on a symbol will annotate it, ESC in the annotation window will
return to the report symbol list.

More work will be done to remove the special casing in color_fprintf, stop
using fmemopen/FILE in the printing of hist_entries, etc.

The pr_{warning,debug,info,etc} messages go to the help line, i.e. the bottom
line, more work is needed to get them in a linked list that can then be seen by
using a hotkey or menu entry.

Also the annotation doesn't need to be done via spawning "perf annotate" and
then browsing its output, we can do better by calling directly the
builtin-annotate.c functions, that would then be moved to
tools/perf/util/annotate.c and shared with perf top, etc

But lets go by baby steps, this patch already improves perf usability by
allowing to quickly do annotations on symbols from the report screen and
provides a first experimentation with libnewt/TUI integration of tools.

Tested on RHEL5 and Fedora12 X86_64 and on Debian PARISC64 to browse a
perf.data file collected on a Fedora12 x86_64 box.

Cc: Avi Kivity <avi@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   41 ++++++++++++++++++++++++++++-------------
 1 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 36244dc..7c9a779 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -11,23 +11,25 @@
 #include "sort.h"
 #include "symbol.h"
 
-static void hist_entry__append_browser(struct hist_entry *self,
-				       newtComponent listbox, u64 total)
+static size_t hist_entry__append_browser(struct hist_entry *self,
+					 newtComponent listbox, u64 total)
 {
 	char bf[1024];
+	size_t len;
 	FILE *fp;
 
 	if (symbol_conf.exclude_other && !self->parent)
-		return;
+		return 0;
 
 	fp = fmemopen(bf, sizeof(bf), "w");
 	if (fp == NULL)
-		return;
+		return 0;
 
-	hist_entry__fprintf(self, NULL, false, 0, fp, total);
+	len = hist_entry__fprintf(self, NULL, false, 0, fp, total);
 
 	fclose(fp);
 	newtListboxAppendEntry(listbox, bf, self);
+	return len;
 }
 
 static void hist_entry__annotate_browser(struct hist_entry *self)
@@ -37,7 +39,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	newtComponent form, listbox;
 	struct newtExitStruct es;
 	char *str;
-	size_t line_len;
+	size_t line_len, max_line_len = 0;
 	char *line = NULL;
 
 	if (self->sym == NULL)
@@ -50,23 +52,30 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	if (fp == NULL)
 		goto out_free_str;
 
+	newtPushHelpLine("Press ESC to exit");
 	get_term_dimensions(&ws);
-	newtCenteredWindow(ws.ws_col, ws.ws_row, self->sym->name);
 	form = newtForm(NULL, NULL, 0);
 	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
-	listbox = newtListbox(10, 1, ws.ws_row - 2, NEWT_FLAG_SCROLL | NEWT_FLAG_RETURNEXIT);
-	newtFormAddComponents(form, listbox, NULL);
+	listbox = newtListbox(20, 2, ws.ws_row - 3, (NEWT_FLAG_SCROLL |
+						     NEWT_FLAG_BORDER));
 	while (!feof(fp)) {
 		if (getline(&line, &line_len, fp) < 0 || !line_len)
 			break;
+		while (line_len != 0 && isspace(line[line_len - 1]))
+			line[--line_len] = '\0';
+		if (line_len > max_line_len)
+			max_line_len = line_len;
 		newtListboxAppendEntry(listbox, line, NULL);
 		line = NULL;
 	}
-
 	fclose(fp);
+
+	newtListboxSetWidth(listbox, max_line_len);
+	newtFormAddComponents(form, listbox, NULL);
+
 	newtFormRun(form, &es);
-	newtPopWindow();
 	newtFormDestroy(form);
+	newtPopHelpLine();
 out_free_str:
 	free(str);
 }
@@ -79,6 +88,7 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	unsigned int width;
 	char *col_width = symbol_conf.col_width_list_str;
 	struct winsize ws;
+	size_t max_len = 0;
 	char str[1024];
 	newtComponent form, listbox;
 	struct newtExitStruct es;
@@ -92,7 +102,9 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	form = newtForm(NULL, NULL, 0);
 	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
 
-	listbox = newtListbox(1, 1, ws.ws_row - 2, NEWT_FLAG_SCROLL | NEWT_FLAG_BORDER | NEWT_FLAG_RETURNEXIT);
+	listbox = newtListbox(1, 1, ws.ws_row - 2, (NEWT_FLAG_SCROLL |
+						    NEWT_FLAG_BORDER |
+						    NEWT_FLAG_RETURNEXIT));
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
@@ -113,9 +125,12 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 
 	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		hist_entry__append_browser(h, listbox, session_total);
+		size_t len = hist_entry__append_browser(h, listbox, session_total);
+		if (len > max_len)
+			max_len = len;
 	}
 
+	newtListboxSetWidth(listbox, max_len);
 	newtFormAddComponents(form, listbox, NULL);
 
 	while (1) {
-- 
1.5.5.1

