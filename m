Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0BWCFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:05:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab0BWCFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:05:30 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 6/9] perf probe: Use libdw callback routines
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
Date: Mon, 22 Feb 2010 21:09:00 -0500
Message-ID: <20100223020900.26668.5170.stgit@localhost6.localdomain6>
In-Reply-To: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
References: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use libdw callback functions aggressively, and remove
local tree-search API. This change simplifies the code.

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
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---

 tools/perf/util/probe-finder.c |  262 +++++++++++++---------------------------
 tools/perf/util/probe-finder.h |    1 
 2 files changed, 86 insertions(+), 177 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c422472..6305f34 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -38,13 +38,6 @@
 #include "probe-finder.h"
 
 
-/* Dwarf_Die Linkage to parent Die */
-struct die_link {
-	struct die_link *parent;	/* Parent die */
-	Dwarf_Die die;			/* Current die */
-};
-
-
 /*
  * Generic dwarf analysis helpers
  */
@@ -177,26 +170,6 @@ static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 	return strcmp(tname, name);
 }
 
-/* Check the address is in the subprogram(function). */
-static bool die_within_subprogram(Dwarf_Die *sp_die, Dwarf_Addr addr,
-				 size_t *offs)
-{
-	Dwarf_Addr epc;
-	int ret;
-
-	ret = dwarf_haspc(sp_die, addr);
-	if (ret <= 0)
-		return false;
-
-	if (offs) {
-		ret = dwarf_entrypc(sp_die, &epc);
-		DIE_IF(ret == -1);
-		*offs = addr - epc;
-	}
-
-	return true;
-}
-
 /* Get entry pc(or low pc, 1st entry of ranges)  of the die */
 static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
 {
@@ -208,70 +181,34 @@ static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
 	return epc;
 }
 
-/* Check if the abstract origin's address or not */
-static bool die_compare_abstract_origin(Dwarf_Die *in_die, void *origin_addr)
-{
-	Dwarf_Attribute attr;
-	Dwarf_Die origin;
-
-	if (!dwarf_attr(in_die, DW_AT_abstract_origin, &attr))
-		return false;
-	if (!dwarf_formref_die(&attr, &origin))
-		return false;
-
-	return origin.addr == origin_addr;
-}
-
-/*
- * Search a Die from Die tree.
- * Note: cur_link->die should be deallocated in this function.
- */
-static int __search_die_tree(struct die_link *cur_link,
-			     int (*die_cb)(struct die_link *, void *),
-			     void *data)
+/* Get a variable die */
+static Dwarf_Die *die_find_variable(Dwarf_Die *sp_die, const char *name,
+				    Dwarf_Die *die_mem)
 {
-	struct die_link new_link;
+	Dwarf_Die child_die;
+	int tag;
 	int ret;
 
-	if (!die_cb)
-		return 0;
-
-	/* Check current die */
-	while (!(ret = die_cb(cur_link, data))) {
-		/* Check child die */
-		ret = dwarf_child(&cur_link->die, &new_link.die);
-		if (ret == 0) {
-			new_link.parent = cur_link;
-			ret = __search_die_tree(&new_link, die_cb, data);
-			if (ret)
-				break;
-		}
+	ret = dwarf_child(sp_die, die_mem);
+	if (ret != 0)
+		return NULL;
 
-		/* Move to next sibling */
-		ret = dwarf_siblingof(&cur_link->die, &cur_link->die);
-		if (ret != 0)
-			return 0;
-	}
-	return ret;
-}
+	do {
+		tag = dwarf_tag(die_mem);
+		if ((tag == DW_TAG_formal_parameter ||
+		     tag == DW_TAG_variable) &&
+		    (die_compare_name(die_mem, name) == 0))
+			return die_mem;
 
-/* Search a die in its children's die tree */
-static int search_die_from_children(Dwarf_Die *parent_die,
-				    int (*die_cb)(struct die_link *, void *),
-				    void *data)
-{
-	struct die_link new_link;
-	int ret;
+		if (die_find_variable(die_mem, name, &child_die)) {
+			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
+			return die_mem;
+		}
+	} while (dwarf_siblingof(die_mem, die_mem) == 0);
 
-	new_link.parent = NULL;
-	ret = dwarf_child(parent_die, &new_link.die);
-	if (ret == 0)
-		return __search_die_tree(&new_link, die_cb, data);
-	else
-		return 0;
+	return NULL;
 }
 
-
 /*
  * Probe finder related functions
  */
@@ -347,28 +284,13 @@ error:
 	    " Perhaps, it has been optimized out.", pf->var);
 }
 
-static int variable_search_cb(struct die_link *dlink, void *data)
-{
-	struct probe_finder *pf = (struct probe_finder *)data;
-	int tag;
-
-	tag = dwarf_tag(&dlink->die);
-	DIE_IF(tag < 0);
-	if ((tag == DW_TAG_formal_parameter ||
-	     tag == DW_TAG_variable) &&
-	    (die_compare_name(&dlink->die, pf->var) == 0)) {
-		show_variable(&dlink->die, pf);
-		return 1;
-	}
-	/* TODO: Support struct members and arrays */
-	return 0;
-}
-
 /* Find a variable in a subprogram die */
 static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	int ret;
+	Dwarf_Die vr_die;
 
+	/* TODO: Support struct members and arrays */
 	if (!is_c_varname(pf->var)) {
 		/* Output raw parameters */
 		ret = snprintf(pf->buf, pf->len, " %s", pf->var);
@@ -379,31 +301,42 @@ static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	pr_debug("Searching '%s' variable in context.\n", pf->var);
 	/* Search child die for local variables and parameters. */
-	ret = search_die_from_children(sp_die, variable_search_cb, pf);
-	if (!ret)
+	if (!die_find_variable(sp_die, pf->var, &vr_die))
 		die("Failed to find '%s' in this function.", pf->var);
+
+	show_variable(&vr_die, pf);
 }
 
 /* Show a probe point to output buffer */
-static void show_probe_point(Dwarf_Die *sp_die, size_t offs,
-			     struct probe_finder *pf)
+static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	struct probe_point *pp = pf->pp;
+	Dwarf_Addr eaddr;
+	Dwarf_Die die_mem;
 	const char *name;
 	char tmp[MAX_PROBE_BUFFER];
 	int ret, i, len;
 	Dwarf_Attribute fb_attr;
 	size_t nops;
 
+	/* If no real subprogram, find a real one */
+	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
+		sp_die = die_get_real_subprogram(&pf->cu_die,
+						 pf->addr, &die_mem);
+		if (!sp_die)
+			die("Probe point is not found in subprograms.");
+	}
+
 	/* Output name of probe point */
 	name = dwarf_diename(sp_die);
 	if (name) {
-		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%u", name,
-				(unsigned int)offs);
+		dwarf_entrypc(sp_die, &eaddr);
+		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%lu", name,
+				(unsigned long)(pf->addr - eaddr));
 		/* Copy the function name if possible */
 		if (!pp->function) {
 			pp->function = strdup(name);
-			pp->offset = offs;
+			pp->offset = (size_t)(pf->addr - eaddr);
 		}
 	} else {
 		/* This function has no name. */
@@ -450,10 +383,9 @@ static void find_probe_point_by_line(struct probe_finder *pf)
 	Dwarf_Lines *lines;
 	Dwarf_Line *line;
 	size_t nlines, i;
-	Dwarf_Addr addr, epc;
+	Dwarf_Addr addr;
 	int lineno;
 	int ret;
-	Dwarf_Die *sp_die, die_mem;
 
 	ret = dwarf_getsrclines(&pf->cu_die, &lines, &nlines);
 	DIE_IF(ret != 0);
@@ -474,77 +406,57 @@ static void find_probe_point_by_line(struct probe_finder *pf)
 			 (int)i, lineno, (uintmax_t)addr);
 		pf->addr = addr;
 
-		sp_die = die_get_real_subprogram(&pf->cu_die, addr, &die_mem);
-		if (!sp_die)
-			die("Probe point is not found in subprograms.");
-		dwarf_entrypc(sp_die, &epc);
-		show_probe_point(sp_die, (size_t)(addr - epc), pf);
+		show_probe_point(NULL, pf);
 		/* Continuing, because target line might be inlined. */
 	}
 }
 
+static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
+{
+	struct probe_finder *pf = (struct probe_finder *)data;
+	struct probe_point *pp = pf->pp;
+
+	/* Get probe address */
+	pf->addr = die_get_entrypc(in_die);
+	pf->addr += pp->offset;
+	pr_debug("found inline addr: 0x%jx\n", (uintmax_t)pf->addr);
+
+	show_probe_point(in_die, pf);
+	return DWARF_CB_OK;
+}
 
 /* Search function from function name */
-static int probe_point_search_cb(struct die_link *dlink, void *data)
+static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct probe_finder *pf = (struct probe_finder *)data;
 	struct probe_point *pp = pf->pp;
-	struct die_link *lk;
-	size_t offs;
-	int tag;
-	int ret;
 
-	tag = dwarf_tag(&dlink->die);
-	if (tag == DW_TAG_subprogram) {
-		if (die_compare_name(&dlink->die, pp->function) == 0) {
-			if (pp->line) {	/* Function relative line */
-				pf->fname = dwarf_decl_file(&dlink->die);
-				dwarf_decl_line(&dlink->die, &pf->lno);
-				pf->lno += pp->line;
-				find_probe_point_by_line(pf);
-				return 1;
-			}
-			if (dwarf_func_inline(&dlink->die)) {
-				/* Inlined function, save it. */
-				pf->origin = dlink->die.addr;
-				return 0;	/* Continue to search */
-			}
-			/* Get probe address */
-			pf->addr = die_get_entrypc(&dlink->die);
-			pf->addr += pp->offset;
-			/* TODO: Check the address in this function */
-			show_probe_point(&dlink->die, pp->offset, pf);
-			return 1; /* Exit; no same symbol in this CU. */
-		}
-	} else if (tag == DW_TAG_inlined_subroutine && pf->origin) {
-		if (die_compare_abstract_origin(&dlink->die, pf->origin)) {
-			/* Get probe address */
-			pf->addr = die_get_entrypc(&dlink->die);
-			pf->addr += pp->offset;
-			pr_debug("found inline addr: 0x%jx\n",
-				 (uintmax_t)pf->addr);
-			/* Inlined function. Get a real subprogram */
-			for (lk = dlink->parent; lk != NULL; lk = lk->parent) {
-				tag = dwarf_tag(&lk->die);
-				if (tag == DW_TAG_subprogram &&
-				    !dwarf_func_inline(&lk->die))
-					goto found;
-			}
-			die("Failed to find real subprogram.");
-found:
-			/* Get offset from subprogram */
-			ret = die_within_subprogram(&lk->die, pf->addr, &offs);
-			DIE_IF(!ret);
-			show_probe_point(&lk->die, offs, pf);
-			/* Continue to search */
-		}
-	}
-	return 0;
+	/* Check tag and diename */
+	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
+	    die_compare_name(sp_die, pp->function) != 0)
+		return 0;
+
+	if (pp->line) { /* Function relative line */
+		pf->fname = dwarf_decl_file(sp_die);
+		dwarf_decl_line(sp_die, &pf->lno);
+		pf->lno += pp->line;
+		find_probe_point_by_line(pf);
+	} else if (!dwarf_func_inline(sp_die)) {
+		/* Real function */
+		pf->addr = die_get_entrypc(sp_die);
+		pf->addr += pp->offset;
+		/* TODO: Check the address in this function */
+		show_probe_point(sp_die, pf);
+	} else
+		/* Inlined function: search instances */
+		dwarf_func_inline_instances(sp_die, probe_point_inline_cb, pf);
+
+	return 1; /* Exit; no same symbol in this CU. */
 }
 
 static void find_probe_point_by_func(struct probe_finder *pf)
 {
-	search_die_from_children(&pf->cu_die, probe_point_search_cb, pf);
+	dwarf_getfuncs(&pf->cu_die, probe_point_search_cb, pf, 0);
 }
 
 /* Find a probe point */
@@ -669,27 +581,25 @@ static void find_line_range_by_line(struct line_finder *lf)
 }
 
 /* Search function from function name */
-static int line_range_search_cb(struct die_link *dlink, void *data)
+static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct line_finder *lf = (struct line_finder *)data;
 	struct line_range *lr = lf->lr;
-	int tag;
 	int ret;
 
-	tag = dwarf_tag(&dlink->die);
-	if (tag == DW_TAG_subprogram &&
-	    die_compare_name(&dlink->die, lr->function) == 0) {
+	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
+	    die_compare_name(sp_die, lr->function) == 0) {
 		/* Get the address range of this function */
-		ret = dwarf_highpc(&dlink->die, &lf->addr_e);
+		ret = dwarf_highpc(sp_die, &lf->addr_e);
 		if (ret == 0)
-			ret = dwarf_lowpc(&dlink->die, &lf->addr_s);
+			ret = dwarf_lowpc(sp_die, &lf->addr_s);
 		if (ret != 0) {
 			lf->addr_s = 0;
 			lf->addr_e = 0;
 		}
 
-		lf->fname = dwarf_decl_file(&dlink->die);
-		dwarf_decl_line(&dlink->die, &lr->offset);
+		lf->fname = dwarf_decl_file(sp_die);
+		dwarf_decl_line(sp_die, &lr->offset);
 		pr_debug("fname: %s, lineno:%d\n", lf->fname, lr->offset);
 		lf->lno_s = lr->offset + lr->start;
 		if (!lr->end)
@@ -706,7 +616,7 @@ static int line_range_search_cb(struct die_link *dlink, void *data)
 
 static void find_line_range_by_func(struct line_finder *lf)
 {
-	search_die_from_children(&lf->cu_die, line_range_search_cb, lf);
+	dwarf_getfuncs(&lf->cu_die, line_range_search_cb, lf, 0);
 }
 
 int find_line_range(int fd, struct line_range *lr)
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 9dd4a88..74525ae 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -66,7 +66,6 @@ struct probe_finder {
 	Dwarf_Addr		addr;		/* Address */
 	const char		*fname;		/* File name */
 	int			lno;		/* Line number */
-	void			*origin;	/* Inline origin addr */
 	Dwarf_Die		cu_die;		/* Current CU */
 
 	/* For variable searching */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
