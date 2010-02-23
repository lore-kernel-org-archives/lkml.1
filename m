Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0BWCFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:05:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab0BWCFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:05:47 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 7/9] perf probe: Check function address range strictly
	in line finder
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>
Date: Mon, 22 Feb 2010 21:09:07 -0500
Message-ID: <20100223020907.26668.3223.stgit@localhost6.localdomain6>
In-Reply-To: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
References: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check (inlined) function address range strictly for
improving output of probe-able lines of inline functions.

Without this change, perf probe --line <function> sometimes
showed other inline function bodies too, because it didn't
filter out inlined functions.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---

 tools/perf/util/probe-finder.c |   74 +++++++++++++++++++++++++++++-----------
 tools/perf/util/probe-finder.h |    2 -
 2 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 6305f34..a410356 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -161,6 +161,31 @@ static Dwarf_Die *die_get_real_subprogram(Dwarf_Die *cu_die, Dwarf_Addr addr,
 		return die_mem;
 }
 
+/* Similar to dwarf_getfuncs, but returns inlined_subroutine if exists. */
+static Dwarf_Die *die_get_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				     Dwarf_Die *die_mem)
+{
+	Dwarf_Die child_die;
+	int ret;
+
+	ret = dwarf_child(sp_die, die_mem);
+	if (ret != 0)
+		return NULL;
+
+	do {
+		if (dwarf_tag(die_mem) == DW_TAG_inlined_subroutine &&
+		    dwarf_haspc(die_mem, addr))
+			return die_mem;
+
+		if (die_get_inlinefunc(die_mem, addr, &child_die)) {
+			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
+			return die_mem;
+		}
+	} while (dwarf_siblingof(die_mem, die_mem) == 0);
+
+	return NULL;
+}
+
 /* Compare diename and tname */
 static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 {
@@ -534,7 +559,7 @@ found:
 }
 
 /* Find line range from its line number */
-static void find_line_range_by_line(struct line_finder *lf)
+static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 {
 	Dwarf_Lines *lines;
 	Dwarf_Line *line;
@@ -543,6 +568,7 @@ static void find_line_range_by_line(struct line_finder *lf)
 	int lineno;
 	int ret;
 	const char *src;
+	Dwarf_Die die_mem;
 
 	INIT_LIST_HEAD(&lf->lr->line_list);
 	ret = dwarf_getsrclines(&lf->cu_die, &lines, &nlines);
@@ -550,22 +576,28 @@ static void find_line_range_by_line(struct line_finder *lf)
 
 	for (i = 0; i < nlines; i++) {
 		line = dwarf_onesrcline(lines, i);
-		dwarf_lineno(line, &lineno);
+		ret = dwarf_lineno(line, &lineno);
+		DIE_IF(ret != 0);
 		if (lf->lno_s > lineno || lf->lno_e < lineno)
 			continue;
 
+		if (sp_die) {
+			/* Address filtering 1: does sp_die include addr? */
+			ret = dwarf_lineaddr(line, &addr);
+			DIE_IF(ret != 0);
+			if (!dwarf_haspc(sp_die, addr))
+				continue;
+
+			/* Address filtering 2: No child include addr? */
+			if (die_get_inlinefunc(sp_die, addr, &die_mem))
+				continue;
+		}
+
 		/* TODO: Get fileno from line, but how? */
 		src = dwarf_linesrc(line, NULL, NULL);
 		if (strtailcmp(src, lf->fname) != 0)
 			continue;
 
-		/* Filter line in the function address range */
-		if (lf->addr_s && lf->addr_e) {
-			ret = dwarf_lineaddr(line, &addr);
-			DIE_IF(ret != 0);
-			if (lf->addr_s > addr || lf->addr_e <= addr)
-				continue;
-		}
 		/* Copy real path */
 		if (!lf->lr->path)
 			lf->lr->path = strdup(src);
@@ -580,24 +612,20 @@ static void find_line_range_by_line(struct line_finder *lf)
 	}
 }
 
+static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
+{
+	find_line_range_by_line(in_die, (struct line_finder *)data);
+	return DWARF_CB_ABORT;	/* No need to find other instances */
+}
+
 /* Search function from function name */
 static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct line_finder *lf = (struct line_finder *)data;
 	struct line_range *lr = lf->lr;
-	int ret;
 
 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
 	    die_compare_name(sp_die, lr->function) == 0) {
-		/* Get the address range of this function */
-		ret = dwarf_highpc(sp_die, &lf->addr_e);
-		if (ret == 0)
-			ret = dwarf_lowpc(sp_die, &lf->addr_s);
-		if (ret != 0) {
-			lf->addr_s = 0;
-			lf->addr_e = 0;
-		}
-
 		lf->fname = dwarf_decl_file(sp_die);
 		dwarf_decl_line(sp_die, &lr->offset);
 		pr_debug("fname: %s, lineno:%d\n", lf->fname, lr->offset);
@@ -608,7 +636,11 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 			lf->lno_e = lr->offset + lr->end;
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
-		find_line_range_by_line(lf);
+		if (dwarf_func_inline(sp_die))
+			dwarf_func_inline_instances(sp_die,
+						    line_range_inline_cb, lf);
+		else
+			find_line_range_by_line(sp_die, lf);
 		return 1;
 	}
 	return 0;
@@ -660,7 +692,7 @@ int find_line_range(int fd, struct line_range *lr)
 					lf.lno_e = INT_MAX;
 				else
 					lf.lno_e = lr->end;
-				find_line_range_by_line(&lf);
+				find_line_range_by_line(NULL, &lf);
 			}
 		}
 		off = noff;
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 74525ae..75a660d 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -82,8 +82,6 @@ struct line_finder {
 	const char		*fname;		/* File name */
 	int			lno_s;		/* Start line number */
 	int			lno_e;		/* End line number */
-	Dwarf_Addr		addr_s;		/* Start address */
-	Dwarf_Addr		addr_e;		/* End address */
 	Dwarf_Die		cu_die;		/* Current CU */
 	int			found;
 };


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
