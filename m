Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZJ2IML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZJ2IML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZJ2IMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:12:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:41844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZJ2IMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:12:06 -0400
Date: Thu, 29 Oct 2009 08:09:26 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091027204319.30545.30678.stgit@harusame>
References: <20091027204319.30545.30678.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf/probes: Support function entry relative line number
Message-ID: <tip-b0ef07324310d66f660a311d4a8d669eda74f801@git.kernel.org>
Git-Commit-ID: b0ef07324310d66f660a311d4a8d669eda74f801
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0ef07324310d66f660a311d4a8d669eda74f801
Gitweb:     http://git.kernel.org/tip/b0ef07324310d66f660a311d4a8d669eda74f801
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Oct 2009 16:43:19 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:47:49 +0100

perf/probes: Support function entry relative line number

Add function-entry relative line number specifying support to
perf-probe. This allows users to define probes by line number
from entry of the function.

 e.g.

  perf probe schedule:16

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091027204319.30545.30678.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c     |   14 ++++----
 tools/perf/util/probe-finder.c |   79 +++++++++++++++++++++++++++++++---------
 tools/perf/util/probe-finder.h |    2 +
 3 files changed, 70 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 92b4c49..a99a366 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -133,17 +133,16 @@ static void parse_probe_point(char *arg, struct probe_point *pp)
 	}
 
 	/* Exclusion check */
-	if (pp->line && pp->function)
-		semantic_error("Function-relative line number is not"
-				" supported yet.");
+	if (pp->line && pp->offset)
+		semantic_error("Offset can't be used with line number.");
 	if (!pp->line && pp->file && !pp->function)
 		semantic_error("File always requires line number.");
 	if (pp->offset && !pp->function)
 		semantic_error("Offset requires an entry function.");
 	if (pp->retprobe && !pp->function)
 		semantic_error("Return probe requires an entry function.");
-	if (pp->offset && pp->retprobe)
-		semantic_error("Offset can't be used with return probe.");
+	if ((pp->offset || pp->line) && pp->retprobe)
+		semantic_error("Offset/Line can't be used with return probe.");
 
 	pr_debug("symbol:%s file:%s line:%d offset:%d, return:%d\n",
 		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe);
@@ -270,7 +269,7 @@ static const struct option options[] = {
 #ifdef NO_LIBDWARF
 		"FUNC[+OFFS|%return] [ARG ...]",
 #else
-		"FUNC[+OFFS|%return][@SRC]|SRC:LINE [ARG ...]",
+		"FUNC[+OFFS|%return|:RLN][@SRC]|SRC:ALN [ARG ...]",
 #endif
 		"probe point definition, where\n"
 		"\t\tGRP:\tGroup name (optional)\n"
@@ -282,7 +281,8 @@ static const struct option options[] = {
 		"\t\tARG:\tProbe argument (only \n"
 #else
 		"\t\tSRC:\tSource code path\n"
-		"\t\tLINE:\tLine number\n"
+		"\t\tRLN:\tRelative line number from function entry.\n"
+		"\t\tALN:\tAbsolute line number in file.\n"
 		"\t\tARG:\tProbe argument (local variable name or\n"
 #endif
 		"\t\t\tkprobe-tracer argument format is supported.)\n",
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 6d3bac9..db96186 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -114,7 +114,7 @@ static int strtailcmp(const char *s1, const char *s2)
 }
 
 /* Find the fileno of the target file. */
-static Dwarf_Unsigned die_get_fileno(Dwarf_Die cu_die, const char *fname)
+static Dwarf_Unsigned cu_find_fileno(Dwarf_Die cu_die, const char *fname)
 {
 	Dwarf_Signed cnt, i;
 	Dwarf_Unsigned found = 0;
@@ -335,6 +335,36 @@ static int attr_get_locdesc(Dwarf_Attribute attr, Dwarf_Locdesc *desc,
 	return ret;
 }
 
+/* Get decl_file attribute value (file number) */
+static Dwarf_Unsigned die_get_decl_file(Dwarf_Die sp_die)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Unsigned fno;
+	int ret;
+
+	ret = dwarf_attr(sp_die, DW_AT_decl_file, &attr, &__dw_error);
+	DIE_IF(ret != DW_DLV_OK);
+	dwarf_formudata(attr, &fno, &__dw_error);
+	DIE_IF(ret != DW_DLV_OK);
+	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
+	return fno;
+}
+
+/* Get decl_line attribute value (line number) */
+static Dwarf_Unsigned die_get_decl_line(Dwarf_Die sp_die)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Unsigned lno;
+	int ret;
+
+	ret = dwarf_attr(sp_die, DW_AT_decl_line, &attr, &__dw_error);
+	DIE_IF(ret != DW_DLV_OK);
+	dwarf_formudata(attr, &lno, &__dw_error);
+	DIE_IF(ret != DW_DLV_OK);
+	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
+	return lno;
+}
+
 /*
  * Probe finder related functions
  */
@@ -501,6 +531,7 @@ static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
 	DIE_IF(ret < 0);
 	DIE_IF(ret >= MAX_PROBE_BUFFER);
 	len = ret;
+	pr_debug("Probe point found: %s\n", tmp);
 
 	/* Find each argument */
 	get_current_frame_base(sp_die, pf);
@@ -536,17 +567,16 @@ static int probeaddr_callback(struct die_link *dlink, void *data)
 }
 
 /* Find probe point from its line number */
-static void find_by_line(Dwarf_Die cu_die, struct probe_finder *pf)
+static void find_by_line(struct probe_finder *pf)
 {
-	struct probe_point *pp = pf->pp;
-	Dwarf_Signed cnt, i;
+	Dwarf_Signed cnt, i, clm;
 	Dwarf_Line *lines;
 	Dwarf_Unsigned lineno = 0;
 	Dwarf_Addr addr;
 	Dwarf_Unsigned fno;
 	int ret;
 
-	ret = dwarf_srclines(cu_die, &lines, &cnt, &__dw_error);
+	ret = dwarf_srclines(pf->cu_die, &lines, &cnt, &__dw_error);
 	DIE_IF(ret != DW_DLV_OK);
 
 	for (i = 0; i < cnt; i++) {
@@ -557,15 +587,20 @@ static void find_by_line(Dwarf_Die cu_die, struct probe_finder *pf)
 
 		ret = dwarf_lineno(lines[i], &lineno, &__dw_error);
 		DIE_IF(ret != DW_DLV_OK);
-		if (lineno != (Dwarf_Unsigned)pp->line)
+		if (lineno != pf->lno)
 			continue;
 
+		ret = dwarf_lineoff(lines[i], &clm, &__dw_error);
+		DIE_IF(ret != DW_DLV_OK);
+
 		ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
 		DIE_IF(ret != DW_DLV_OK);
-		pr_debug("Probe point found: 0x%llx\n", addr);
+		pr_debug("Probe line found: line[%d]:%u,%d addr:0x%llx\n",
+			 (int)i, (unsigned)lineno, (int)clm, addr);
 		pf->addr = addr;
 		/* Search a real subprogram including this line, */
-		ret = search_die_from_children(cu_die, probeaddr_callback, pf);
+		ret = search_die_from_children(pf->cu_die,
+					       probeaddr_callback, pf);
 		if (ret == 0)
 			die("Probe point is not found in subprograms.\n");
 		/* Continuing, because target line might be inlined. */
@@ -587,6 +622,13 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 	DIE_IF(ret == DW_DLV_ERROR);
 	if (tag == DW_TAG_subprogram) {
 		if (die_compare_name(dlink->die, pp->function) == 0) {
+			if (pp->line) {	/* Function relative line */
+				pf->fno = die_get_decl_file(dlink->die);
+				pf->lno = die_get_decl_line(dlink->die)
+					 + pp->line;
+				find_by_line(pf);
+				return 1;
+			}
 			if (die_inlined_subprogram(dlink->die)) {
 				/* Inlined function, save it. */
 				ret = dwarf_die_CU_offset(dlink->die,
@@ -631,9 +673,9 @@ found:
 	return 0;
 }
 
-static void find_by_func(Dwarf_Die cu_die, struct probe_finder *pf)
+static void find_by_func(struct probe_finder *pf)
 {
-	search_die_from_children(cu_die, probefunc_callback, pf);
+	search_die_from_children(pf->cu_die, probefunc_callback, pf);
 }
 
 /* Find a probe point */
@@ -641,7 +683,6 @@ int find_probepoint(int fd, struct probe_point *pp)
 {
 	Dwarf_Half addr_size = 0;
 	Dwarf_Unsigned next_cuh = 0;
-	Dwarf_Die cu_die = 0;
 	int cu_number = 0, ret;
 	struct probe_finder pf = {.pp = pp};
 
@@ -659,25 +700,27 @@ int find_probepoint(int fd, struct probe_point *pp)
 			break;
 
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		ret = dwarf_siblingof(__dw_debug, 0, &cu_die, &__dw_error);
+		ret = dwarf_siblingof(__dw_debug, 0, &pf.cu_die, &__dw_error);
 		DIE_IF(ret != DW_DLV_OK);
 
 		/* Check if target file is included. */
 		if (pp->file)
-			pf.fno = die_get_fileno(cu_die, pp->file);
+			pf.fno = cu_find_fileno(pf.cu_die, pp->file);
 
 		if (!pp->file || pf.fno) {
 			/* Save CU base address (for frame_base) */
-			ret = dwarf_lowpc(cu_die, &pf.cu_base, &__dw_error);
+			ret = dwarf_lowpc(pf.cu_die, &pf.cu_base, &__dw_error);
 			DIE_IF(ret == DW_DLV_ERROR);
 			if (ret == DW_DLV_NO_ENTRY)
 				pf.cu_base = 0;
-			if (pp->line)
-				find_by_line(cu_die, &pf);
 			if (pp->function)
-				find_by_func(cu_die, &pf);
+				find_by_func(&pf);
+			else {
+				pf.lno = pp->line;
+				find_by_line(&pf);
+			}
 		}
-		dwarf_dealloc(__dw_debug, cu_die, DW_DLA_DIE);
+		dwarf_dealloc(__dw_debug, pf.cu_die, DW_DLA_DIE);
 	}
 	ret = dwarf_finish(__dw_debug, &__dw_error);
 	DIE_IF(ret != DW_DLV_OK);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 240d6cb..bdebca6 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -41,7 +41,9 @@ struct probe_finder {
 	/* For function searching */
 	Dwarf_Addr	addr;		/* Address */
 	Dwarf_Unsigned	fno;		/* File number */
+	Dwarf_Unsigned	lno;		/* Line number */
 	Dwarf_Off	inl_offs;	/* Inline offset */
+	Dwarf_Die	cu_die;		/* Current CU */
 
 	/* For variable searching */
 	Dwarf_Addr	cu_base;	/* Current CU base address */
