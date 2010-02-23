Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0BWCGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:06:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab0BWCGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:06:13 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 9/9] perf probe: Add lazy line matching support
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Date: Mon, 22 Feb 2010 21:09:21 -0500
Message-ID: <20100223020921.26668.76075.stgit@localhost6.localdomain6>
In-Reply-To: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
References: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lazy line matching support for specifying new probes.
This also changes the syntax of perf probe a bit. Now
perf probe accepts one of below probe event definitions.

1) Define event based on function name
 [EVENT=]FUNC[@SRC][:RLN|+OFF|%return|;PTN] [ARG ...]

2) Define event based on source file with line number
 [EVENT=]SRC:ALN [ARG ...]

3) Define event based on source file with lazy pattern
 [EVENT=]SRC;PTN [ARG ...]

- New lazy matching pattern(PTN) follows ';' (semicolon). And it
  must be put the end of the definition.
- So, @SRC is no longer the part which must be put at the end
  of the definition.

Note that ';' (semicolon) can be interpreted as the end of
a command by the shell. This means that you need to quote it.
(anyway you will need to quote the lazy pattern itself too,
because it may contains other sensitive characters, like
'[',']' etc.).

Lazy matching
-------------
The lazy line matching is similar to glob matching except
ignoring spaces in both of pattern and target.

e.g.
'a=*' can matches 'a=b', 'a = b', 'a == b' and so on.

This provides some sort of flexibility and robustness to
probe point definitions against minor code changes.
(for example, actual 10th line of schedule() can be changed
 easily by modifying schedule(), but the same line matching
 'rq=cpu_rq*' may still exist.)

Changes in v3:
 - Cast Dwarf_Addr to uintmax_t for printf-formats.

Changes in v2:
 - Cast Dwarf_Addr to unsigned long long for printf-formats.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
---

 tools/perf/Documentation/perf-probe.txt |   30 +++-
 tools/perf/builtin-probe.c              |   12 +
 tools/perf/util/probe-event.c           |   48 ++++--
 tools/perf/util/probe-finder.c          |  249 ++++++++++++++++++++++++-------
 tools/perf/util/probe-finder.h          |    2 
 tools/perf/util/string.c                |   55 +++++--
 tools/perf/util/string.h                |    1 
 7 files changed, 298 insertions(+), 99 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 5fe63c0..34202b1 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -61,11 +61,19 @@ PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
 
- "[EVENT=]FUNC[+OFFS|:RLN|%return][@SRC]|SRC:ALN [ARG ...]"
+    1) Define event based on function name
+     [EVENT=]FUNC[@SRC][:RLN|+OFFS|%return|;PTN] [ARG ...]
+
+    2) Define event based on source file with line number
+     [EVENT=]SRC:ALN [ARG ...]
+
+    3) Define event based on source file with lazy pattern
+     [EVENT=]SRC;PTN [ARG ...]
+
 
 'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe'.
-'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, 'RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. In addition, 'SRC' specifies a source file which has that function.
-It is also possible to specify a probe point by the source line number by using 'SRC:ALN' syntax, where 'SRC' is the source file path and 'ALN' is the line number.
+'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, ':RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. And ';PTN' means lazy matching pattern (see LAZY MATCHING). Note that ';PTN' must be the end of the probe point definition.  In addition, '@SRC' specifies a source file which has that function.
+It is also possible to specify a probe point by the source line number or lazy matching by using 'SRC:ALN' or 'SRC;PTN' syntax, where 'SRC' is the source file path, ':ALN' is the line number and ';PTN' is the lazy matching pattern.
 'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
 
 LINE SYNTAX
@@ -81,6 +89,16 @@ and 'ALN2' is end line number in the file. It is also possible to specify how
 many lines to show by using 'NUM'.
 So, "source.c:100-120" shows lines between 100th to l20th in source.c file. And "func:10+20" shows 20 lines from 10th line of func function.
 
+LAZY MATCHING
+-------------
+ The lazy line matching is similar to glob matching but ignoring spaces in both of pattern and target. So this accepts wildcards('*', '?') and character classes(e.g. [a-z], [!A-Z]).
+
+e.g.
+ 'a=*' can matches 'a=b', 'a = b', 'a == b' and so on.
+
+This provides some sort of flexibility and robustness to probe point definitions against minor code changes. For example, actual 10th line of schedule() can be moved easily by modifying schedule(), but the same line matching 'rq=cpu_rq*' may still exist in the function.)
+
+
 EXAMPLES
 --------
 Display which lines in schedule() can be probed:
@@ -95,6 +113,12 @@ Add a probe on schedule() function 12th line with recording cpu local variable:
 
  this will add one or more probes which has the name start with "schedule".
 
+ Add probes on lines in schedule() function which calls update_rq_clock().
+
+ ./perf probe 'schedule;update_rq_clock*'
+ or
+ ./perf probe --add='schedule;update_rq_clock*'
+
 Delete all probes on schedule().
 
  ./perf probe --del='schedule*'
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index d8d3f05..e3dfd0d 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -175,22 +175,24 @@ static const struct option options[] = {
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
 #ifdef NO_DWARF_SUPPORT
-		"[EVENT=]FUNC[+OFFS|%return] [ARG ...]",
+		"[EVENT=]FUNC[+OFF|%return] [ARG ...]",
 #else
-		"[EVENT=]FUNC[+OFFS|%return|:RLN][@SRC]|SRC:ALN [ARG ...]",
+		"[EVENT=]FUNC[+OFF|%return|:RL|;PT][@SRC]|SRC:AL|SRC;PT"
+		" [ARG ...]",
 #endif
 		"probe point definition, where\n"
 		"\t\tGROUP:\tGroup name (optional)\n"
 		"\t\tEVENT:\tEvent name\n"
 		"\t\tFUNC:\tFunction name\n"
-		"\t\tOFFS:\tOffset from function entry (in byte)\n"
+		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
 #ifdef NO_DWARF_SUPPORT
 		"\t\tARG:\tProbe argument (only \n"
 #else
 		"\t\tSRC:\tSource code path\n"
-		"\t\tRLN:\tRelative line number from function entry.\n"
-		"\t\tALN:\tAbsolute line number in file.\n"
+		"\t\tRL:\tRelative line number from function entry.\n"
+		"\t\tAL:\tAbsolute line number in file.\n"
+		"\t\tPT:\tLazy expression of line code.\n"
 		"\t\tARG:\tProbe argument (local variable name or\n"
 #endif
 		"\t\t\tkprobe-tracer argument format.)\n",
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e7918e2..9e5e906 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -119,14 +119,14 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	char c, nc = 0;
 	/*
 	 * <Syntax>
-	 * perf probe [EVENT=]SRC:LN
-	 * perf probe [EVENT=]FUNC[+OFFS|%return][@SRC]
+	 * perf probe [EVENT=]SRC[:LN|;PTN]
+	 * perf probe [EVENT=]FUNC[@SRC][+OFFS|%return|:LN|;PAT]
 	 *
 	 * TODO:Group name support
 	 */
 
-	ptr = strchr(arg, '=');
-	if (ptr) {	/* Event name */
+	ptr = strpbrk(arg, ";=@+%");
+	if (ptr && *ptr == '=') {	/* Event name */
 		*ptr = '\0';
 		tmp = ptr + 1;
 		ptr = strchr(arg, ':');
@@ -139,7 +139,7 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		arg = tmp;
 	}
 
-	ptr = strpbrk(arg, ":+@%");
+	ptr = strpbrk(arg, ";:+@%");
 	if (ptr) {
 		nc = *ptr;
 		*ptr++ = '\0';
@@ -156,7 +156,11 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	while (ptr) {
 		arg = ptr;
 		c = nc;
-		ptr = strpbrk(arg, ":+@%");
+		if (c == ';') {	/* Lazy pattern must be the last part */
+			pp->lazy_line = strdup(arg);
+			break;
+		}
+		ptr = strpbrk(arg, ";:+@%");
 		if (ptr) {
 			nc = *ptr;
 			*ptr++ = '\0';
@@ -165,13 +169,13 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		case ':':	/* Line number */
 			pp->line = strtoul(arg, &tmp, 0);
 			if (*tmp != '\0')
-				semantic_error("There is non-digit charactor"
-						" in line number.");
+				semantic_error("There is non-digit char"
+					       " in line number.");
 			break;
 		case '+':	/* Byte offset from a symbol */
 			pp->offset = strtoul(arg, &tmp, 0);
 			if (*tmp != '\0')
-				semantic_error("There is non-digit charactor"
+				semantic_error("There is non-digit character"
 						" in offset.");
 			break;
 		case '@':	/* File name */
@@ -179,9 +183,6 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 				semantic_error("SRC@SRC is not allowed.");
 			pp->file = strdup(arg);
 			DIE_IF(pp->file == NULL);
-			if (ptr)
-				semantic_error("@SRC must be the last "
-					       "option.");
 			break;
 		case '%':	/* Probe places */
 			if (strcmp(arg, "return") == 0) {
@@ -196,11 +197,18 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	}
 
 	/* Exclusion check */
+	if (pp->lazy_line && pp->line)
+		semantic_error("Lazy pattern can't be used with line number.");
+
+	if (pp->lazy_line && pp->offset)
+		semantic_error("Lazy pattern can't be used with offset.");
+
 	if (pp->line && pp->offset)
 		semantic_error("Offset can't be used with line number.");
 
-	if (!pp->line && pp->file && !pp->function)
-		semantic_error("File always requires line number.");
+	if (!pp->line && !pp->lazy_line && pp->file && !pp->function)
+		semantic_error("File always requires line number or "
+			       "lazy pattern.");
 
 	if (pp->offset && !pp->function)
 		semantic_error("Offset requires an entry function.");
@@ -208,11 +216,13 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	if (pp->retprobe && !pp->function)
 		semantic_error("Return probe requires an entry function.");
 
-	if ((pp->offset || pp->line) && pp->retprobe)
-		semantic_error("Offset/Line can't be used with return probe.");
+	if ((pp->offset || pp->line || pp->lazy_line) && pp->retprobe)
+		semantic_error("Offset/Line/Lazy pattern can't be used with "
+			       "return probe.");
 
-	pr_debug("symbol:%s file:%s line:%d offset:%d, return:%d\n",
-		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe);
+	pr_debug("symbol:%s file:%s line:%d offset:%d return:%d lazy:%s\n",
+		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe,
+		 pp->lazy_line);
 }
 
 /* Parse perf-probe event definition */
@@ -458,6 +468,8 @@ static void clear_probe_point(struct probe_point *pp)
 		free(pp->function);
 	if (pp->file)
 		free(pp->file);
+	if (pp->lazy_line)
+		free(pp->lazy_line);
 	for (i = 0; i < pp->nr_args; i++)
 		free(pp->args[i]);
 	if (pp->args)
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a410356..e77dc88 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -32,6 +32,7 @@
 #include <stdarg.h>
 #include <ctype.h>
 
+#include "string.h"
 #include "event.h"
 #include "debug.h"
 #include "util.h"
@@ -104,8 +105,67 @@ static int strtailcmp(const char *s1, const char *s2)
 	return 0;
 }
 
-/* Find the fileno of the target file. */
-static int cu_find_fileno(Dwarf_Die *cu_die, const char *fname)
+/* Line number list operations */
+
+/* Add a line to line number list */
+static void line_list__add_line(struct list_head *head, unsigned int line)
+{
+	struct line_node *ln;
+	struct list_head *p;
+
+	/* Reverse search, because new line will be the last one */
+	list_for_each_entry_reverse(ln, head, list) {
+		if (ln->line < line) {
+			p = &ln->list;
+			goto found;
+		} else if (ln->line == line)	/* Already exist */
+			return ;
+	}
+	/* List is empty, or the smallest entry */
+	p = head;
+found:
+	pr_debug("line list: add a line %u\n", line);
+	ln = zalloc(sizeof(struct line_node));
+	DIE_IF(ln == NULL);
+	ln->line = line;
+	INIT_LIST_HEAD(&ln->list);
+	list_add(&ln->list, p);
+}
+
+/* Check if the line in line number list */
+static int line_list__has_line(struct list_head *head, unsigned int line)
+{
+	struct line_node *ln;
+
+	/* Reverse search, because new line will be the last one */
+	list_for_each_entry(ln, head, list)
+		if (ln->line == line)
+			return 1;
+
+	return 0;
+}
+
+/* Init line number list */
+static void line_list__init(struct list_head *head)
+{
+	INIT_LIST_HEAD(head);
+}
+
+/* Free line number list */
+static void line_list__free(struct list_head *head)
+{
+	struct line_node *ln;
+	while (!list_empty(head)) {
+		ln = list_first_entry(head, struct line_node, list);
+		list_del(&ln->list);
+		free(ln);
+	}
+}
+
+/* Dwarf wrappers */
+
+/* Find the realpath of the target file. */
+static const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
 {
 	Dwarf_Files *files;
 	size_t nfiles, i;
@@ -113,21 +173,18 @@ static int cu_find_fileno(Dwarf_Die *cu_die, const char *fname)
 	int ret;
 
 	if (!fname)
-		return -EINVAL;
+		return NULL;
 
 	ret = dwarf_getsrcfiles(cu_die, &files, &nfiles);
-	if (ret == 0) {
-		for (i = 0; i < nfiles; i++) {
-			src = dwarf_filesrc(files, i, NULL, NULL);
-			if (strtailcmp(src, fname) == 0) {
-				ret = (int)i;	/*???: +1 or not?*/
-				break;
-			}
-		}
-		if (ret)
-			pr_debug("found fno: %d\n", ret);
+	if (ret != 0)
+		return NULL;
+
+	for (i = 0; i < nfiles; i++) {
+		src = dwarf_filesrc(files, i, NULL, NULL);
+		if (strtailcmp(src, fname) == 0)
+			break;
 	}
-	return ret;
+	return src;
 }
 
 struct __addr_die_search_param {
@@ -436,17 +493,109 @@ static void find_probe_point_by_line(struct probe_finder *pf)
 	}
 }
 
+/* Find lines which match lazy pattern */
+static int find_lazy_match_lines(struct list_head *head,
+				 const char *fname, const char *pat)
+{
+	char *fbuf, *p1, *p2;
+	int fd, line, nlines = 0;
+	struct stat st;
+
+	fd = open(fname, O_RDONLY);
+	if (fd < 0)
+		die("failed to open %s", fname);
+	DIE_IF(fstat(fd, &st) < 0);
+	fbuf = malloc(st.st_size + 2);
+	DIE_IF(fbuf == NULL);
+	DIE_IF(read(fd, fbuf, st.st_size) < 0);
+	close(fd);
+	fbuf[st.st_size] = '\n';	/* Dummy line */
+	fbuf[st.st_size + 1] = '\0';
+	p1 = fbuf;
+	line = 1;
+	while ((p2 = strchr(p1, '\n')) != NULL) {
+		*p2 = '\0';
+		if (strlazymatch(p1, pat)) {
+			line_list__add_line(head, line);
+			nlines++;
+		}
+		line++;
+		p1 = p2 + 1;
+	}
+	free(fbuf);
+	return nlines;
+}
+
+/* Find probe points from lazy pattern  */
+static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
+{
+	Dwarf_Lines *lines;
+	Dwarf_Line *line;
+	size_t nlines, i;
+	Dwarf_Addr addr;
+	Dwarf_Die die_mem;
+	int lineno;
+	int ret;
+
+	if (list_empty(&pf->lcache)) {
+		/* Matching lazy line pattern */
+		ret = find_lazy_match_lines(&pf->lcache, pf->fname,
+					    pf->pp->lazy_line);
+		if (ret <= 0)
+			die("No matched lines found in %s.", pf->fname);
+	}
+
+	ret = dwarf_getsrclines(&pf->cu_die, &lines, &nlines);
+	DIE_IF(ret != 0);
+	for (i = 0; i < nlines; i++) {
+		line = dwarf_onesrcline(lines, i);
+
+		dwarf_lineno(line, &lineno);
+		if (!line_list__has_line(&pf->lcache, lineno))
+			continue;
+
+		/* TODO: Get fileno from line, but how? */
+		if (strtailcmp(dwarf_linesrc(line, NULL, NULL), pf->fname) != 0)
+			continue;
+
+		ret = dwarf_lineaddr(line, &addr);
+		DIE_IF(ret != 0);
+		if (sp_die) {
+			/* Address filtering 1: does sp_die include addr? */
+			if (!dwarf_haspc(sp_die, addr))
+				continue;
+			/* Address filtering 2: No child include addr? */
+			if (die_get_inlinefunc(sp_die, addr, &die_mem))
+				continue;
+		}
+
+		pr_debug("Probe line found: line[%d]:%d addr:0x%llx\n",
+			 (int)i, lineno, (unsigned long long)addr);
+		pf->addr = addr;
+
+		show_probe_point(sp_die, pf);
+		/* Continuing, because target line might be inlined. */
+	}
+	/* TODO: deallocate lines, but how? */
+}
+
 static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 {
 	struct probe_finder *pf = (struct probe_finder *)data;
 	struct probe_point *pp = pf->pp;
 
-	/* Get probe address */
-	pf->addr = die_get_entrypc(in_die);
-	pf->addr += pp->offset;
-	pr_debug("found inline addr: 0x%jx\n", (uintmax_t)pf->addr);
+	if (pp->lazy_line)
+		find_probe_point_lazy(in_die, pf);
+	else {
+		/* Get probe address */
+		pf->addr = die_get_entrypc(in_die);
+		pf->addr += pp->offset;
+		pr_debug("found inline addr: 0x%jx\n",
+			 (uintmax_t)pf->addr);
+
+		show_probe_point(in_die, pf);
+	}
 
-	show_probe_point(in_die, pf);
 	return DWARF_CB_OK;
 }
 
@@ -461,17 +610,21 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	    die_compare_name(sp_die, pp->function) != 0)
 		return 0;
 
+	pf->fname = dwarf_decl_file(sp_die);
 	if (pp->line) { /* Function relative line */
-		pf->fname = dwarf_decl_file(sp_die);
 		dwarf_decl_line(sp_die, &pf->lno);
 		pf->lno += pp->line;
 		find_probe_point_by_line(pf);
 	} else if (!dwarf_func_inline(sp_die)) {
 		/* Real function */
-		pf->addr = die_get_entrypc(sp_die);
-		pf->addr += pp->offset;
-		/* TODO: Check the address in this function */
-		show_probe_point(sp_die, pf);
+		if (pp->lazy_line)
+			find_probe_point_lazy(sp_die, pf);
+		else {
+			pf->addr = die_get_entrypc(sp_die);
+			pf->addr += pp->offset;
+			/* TODO: Check the address in this function */
+			show_probe_point(sp_die, pf);
+		}
 	} else
 		/* Inlined function: search instances */
 		dwarf_func_inline_instances(sp_die, probe_point_inline_cb, pf);
@@ -493,7 +646,6 @@ int find_probe_point(int fd, struct probe_point *pp)
 	size_t cuhl;
 	Dwarf_Die *diep;
 	Dwarf *dbg;
-	int fno = 0;
 
 	dbg = dwarf_begin(fd, DWARF_C_READ);
 	if (!dbg)
@@ -501,6 +653,7 @@ int find_probe_point(int fd, struct probe_point *pp)
 
 	pp->found = 0;
 	off = 0;
+	line_list__init(&pf.lcache);
 	/* Loop on CUs (Compilation Unit) */
 	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
@@ -510,17 +663,19 @@ int find_probe_point(int fd, struct probe_point *pp)
 
 		/* Check if target file is included. */
 		if (pp->file)
-			fno = cu_find_fileno(&pf.cu_die, pp->file);
+			pf.fname = cu_find_realpath(&pf.cu_die, pp->file);
 		else
-			fno = 0;
+			pf.fname = NULL;
 
-		if (!pp->file || fno) {
+		if (!pp->file || pf.fname) {
 			/* Save CU base address (for frame_base) */
 			ret = dwarf_lowpc(&pf.cu_die, &pf.cu_base);
 			if (ret != 0)
 				pf.cu_base = 0;
 			if (pp->function)
 				find_probe_point_by_func(&pf);
+			else if (pp->lazy_line)
+				find_probe_point_lazy(NULL, &pf);
 			else {
 				pf.lno = pp->line;
 				find_probe_point_by_line(&pf);
@@ -528,36 +683,12 @@ int find_probe_point(int fd, struct probe_point *pp)
 		}
 		off = noff;
 	}
+	line_list__free(&pf.lcache);
 	dwarf_end(dbg);
 
 	return pp->found;
 }
 
-
-static void line_range_add_line(struct line_range *lr, unsigned int line)
-{
-	struct line_node *ln;
-	struct list_head *p;
-
-	/* Reverse search, because new line will be the last one */
-	list_for_each_entry_reverse(ln, &lr->line_list, list) {
-		if (ln->line < line) {
-			p = &ln->list;
-			goto found;
-		} else if (ln->line == line)	/* Already exist */
-			return ;
-	}
-	/* List is empty, or the smallest entry */
-	p = &lr->line_list;
-found:
-	pr_debug("Debug: add a line %u\n", line);
-	ln = zalloc(sizeof(struct line_node));
-	DIE_IF(ln == NULL);
-	ln->line = line;
-	INIT_LIST_HEAD(&ln->list);
-	list_add(&ln->list, p);
-}
-
 /* Find line range from its line number */
 static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 {
@@ -570,7 +701,7 @@ static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 	const char *src;
 	Dwarf_Die die_mem;
 
-	INIT_LIST_HEAD(&lf->lr->line_list);
+	line_list__init(&lf->lr->line_list);
 	ret = dwarf_getsrclines(&lf->cu_die, &lines, &nlines);
 	DIE_IF(ret != 0);
 
@@ -601,7 +732,7 @@ static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 		/* Copy real path */
 		if (!lf->lr->path)
 			lf->lr->path = strdup(src);
-		line_range_add_line(lf->lr, (unsigned int)lineno);
+		line_list__add_line(&lf->lr->line_list, (unsigned int)lineno);
 	}
 	/* Update status */
 	if (!list_empty(&lf->lr->line_list))
@@ -659,7 +790,6 @@ int find_line_range(int fd, struct line_range *lr)
 	size_t cuhl;
 	Dwarf_Die *diep;
 	Dwarf *dbg;
-	int fno;
 
 	dbg = dwarf_begin(fd, DWARF_C_READ);
 	if (!dbg)
@@ -678,15 +808,14 @@ int find_line_range(int fd, struct line_range *lr)
 
 		/* Check if target file is included. */
 		if (lr->file)
-			fno = cu_find_fileno(&lf.cu_die, lr->file);
+			lf.fname = cu_find_realpath(&lf.cu_die, lr->file);
 		else
-			fno = 0;
+			lf.fname = 0;
 
-		if (!lr->file || fno) {
+		if (!lr->file || lf.fname) {
 			if (lr->function)
 				find_line_range_by_func(&lf);
 			else {
-				lf.fname = lr->file;
 				lf.lno_s = lr->start;
 				if (!lr->end)
 					lf.lno_e = INT_MAX;
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 75a660d..d1a6517 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -21,6 +21,7 @@ struct probe_point {
 	/* Inputs */
 	char			*file;			/* File name */
 	int			line;			/* Line number */
+	char			*lazy_line;		/* Lazy line pattern */
 
 	char			*function;		/* Function name */
 	int			offset;			/* Offset bytes */
@@ -74,6 +75,7 @@ struct probe_finder {
 	const char		*var;		/* Current variable name */
 	char			*buf;		/* Current output buffer */
 	int			len;		/* Length of output buffer */
+	struct list_head	lcache;		/* Line cache for lazy match */
 };
 
 struct line_finder {
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index c397d4f..a175949 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -265,21 +265,21 @@ error:
 	return false;
 }
 
-/**
- * strglobmatch - glob expression pattern matching
- * @str: the target string to match
- * @pat: the pattern string to match
- *
- * This returns true if the @str matches @pat. @pat can includes wildcards
- * ('*','?') and character classes ([CHARS], complementation and ranges are
- * also supported). Also, this supports escape character ('\') to use special
- * characters as normal character.
- *
- * Note: if @pat syntax is broken, this always returns false.
- */
-bool strglobmatch(const char *str, const char *pat)
+/* Glob/lazy pattern matching */
+static bool __match_glob(const char *str, const char *pat, bool ignore_space)
 {
 	while (*str && *pat && *pat != '*') {
+		if (ignore_space) {
+			/* Ignore spaces for lazy matching */
+			if (isspace(*str)) {
+				str++;
+				continue;
+			}
+			if (isspace(*pat)) {
+				pat++;
+				continue;
+			}
+		}
 		if (*pat == '?') {	/* Matches any single character */
 			str++;
 			pat++;
@@ -308,3 +308,32 @@ bool strglobmatch(const char *str, const char *pat)
 	return !*str && !*pat;
 }
 
+/**
+ * strglobmatch - glob expression pattern matching
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This returns true if the @str matches @pat. @pat can includes wildcards
+ * ('*','?') and character classes ([CHARS], complementation and ranges are
+ * also supported). Also, this supports escape character ('\') to use special
+ * characters as normal character.
+ *
+ * Note: if @pat syntax is broken, this always returns false.
+ */
+bool strglobmatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, false);
+}
+
+/**
+ * strlazymatch - matching pattern strings lazily with glob pattern
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This is similar to strglobmatch, except this ignores spaces in
+ * the target string.
+ */
+bool strlazymatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, true);
+}
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 02ede58..542e44d 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -10,6 +10,7 @@ s64 perf_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
+bool strlazymatch(const char *str, const char *pat);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
