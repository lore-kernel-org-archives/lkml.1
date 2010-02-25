Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab0BYTdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:33:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:34118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933457Ab0BYTdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:33:07 -0500
Date: Thu, 25 Feb 2010 19:31:55 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, ananth@in.ibm.com, roland@redhat.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       efault@gmx.de, dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, ananth@in.ibm.com, roland@redhat.com,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100225133557.6725.20697.stgit@localhost6.localdomain6>
References: <20100225133557.6725.20697.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf probe: Check function address range strictly in line finder
Message-ID: <tip-161a26b0c231b5d2e60e9c132fa360cd9dac4720@git.kernel.org>
Git-Commit-ID: 161a26b0c231b5d2e60e9c132fa360cd9dac4720
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 19:31:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  161a26b0c231b5d2e60e9c132fa360cd9dac4720
Gitweb:     http://git.kernel.org/tip/161a26b0c231b5d2e60e9c132fa360cd9dac4720
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 25 Feb 2010 08:35:57 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 17:49:29 +0100

perf probe: Check function address range strictly in line finder

Check (inlined) function address range strictly for
improving output of probe-able lines of inline functions.

Without this change, perf probe --line <function> sometimes
showed other inline function bodies too, because it didn't
filter out inlined functions.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20100225133557.6725.20697.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |   74 ++++++++++++++++++++++++++++-----------
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
