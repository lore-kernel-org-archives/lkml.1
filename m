Return-Path: <linux-kernel-owner+w=401wt.eu-S1751125AbZJQAIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbZJQAIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZJQAIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:08:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZJQAIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:08:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 8/9] perf: Add DIE_IF() macro for error
	checking
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 16 Oct 2009 20:08:18 -0400
Message-ID: <20091017000818.16556.82452.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DIE_IF() macro and replace ERR_IF() with it, and use
linux/stringify.h.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---

 tools/perf/Makefile            |    1 
 tools/perf/util/probe-finder.c |   82 ++++++++++++++++++++--------------------
 tools/perf/util/probe-finder.h |   10 -----
 tools/perf/util/util.h         |    9 ++++
 4 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 03c27b9..1abbf9a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -321,6 +321,7 @@ LIB_FILE=libperf.a
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
+LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/list.h
 LIB_H += perf.h
 LIB_H += util/types.h
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index db24c91..be997ab 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -146,7 +146,7 @@ static int die_compare_name(Dwarf_Die dw_die, const char *tname)
 	char *name;
 	int ret;
 	ret = dwarf_diename(dw_die, &name, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_OK) {
 		ret = strcmp(tname, name);
 		dwarf_dealloc(__dw_debug, name, DW_DLA_STRING);
@@ -164,11 +164,11 @@ static int die_within_subprogram(Dwarf_Die sp_die, Dwarf_Addr addr,
 
 	/* TODO: check ranges */
 	ret = dwarf_lowpc(sp_die, &lopc, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_NO_ENTRY)
 		return 0;
 	ret = dwarf_highpc(sp_die, &hipc, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	if (lopc <= addr && addr < hipc) {
 		*offs = addr - lopc;
 		return 1;
@@ -184,7 +184,7 @@ static Dwarf_Bool die_inlined_subprogram(Dwarf_Die dw_die)
 	int ret;
 
 	ret = dwarf_hasattr(dw_die, DW_AT_inline, &inl, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	return inl;
 }
 
@@ -196,9 +196,9 @@ static Dwarf_Off die_get_abstract_origin(Dwarf_Die dw_die)
 	int ret;
 
 	ret = dwarf_attr(dw_die, DW_AT_abstract_origin, &attr, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	ret = dwarf_formref(attr, &cu_offs, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
 	return cu_offs;
 }
@@ -215,28 +215,28 @@ static Dwarf_Addr die_get_entrypc(Dwarf_Die dw_die)
 
 	/* Try to get entry pc */
 	ret = dwarf_attr(dw_die, DW_AT_entry_pc, &attr, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_OK) {
 		ret = dwarf_formaddr(attr, &addr, &__dw_error);
-		ERR_IF(ret != DW_DLV_OK);
+		DIE_IF(ret != DW_DLV_OK);
 		dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
 		return addr;
 	}
 
 	/* Try to get low pc */
 	ret = dwarf_lowpc(dw_die, &addr, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_OK)
 		return addr;
 
 	/* Try to get ranges */
 	ret = dwarf_attr(dw_die, DW_AT_ranges, &attr, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	ret = dwarf_formref(attr, &offs, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	ret = dwarf_get_ranges(__dw_debug, offs, &ranges, &cnt, NULL,
 				&__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	addr = ranges[0].dwr_addr1;
 	dwarf_ranges_dealloc(__dw_debug, ranges, cnt);
 	return addr;
@@ -261,7 +261,7 @@ static int __search_die_tree(struct die_link *cur_link,
 	while (!(ret = die_cb(cur_link, data))) {
 		/* Check child die */
 		ret = dwarf_child(cur_link->die, &new_die, &__dw_error);
-		ERR_IF(ret == DW_DLV_ERROR);
+		DIE_IF(ret == DW_DLV_ERROR);
 		if (ret == DW_DLV_OK) {
 			new_link.parent = cur_link;
 			new_link.die = new_die;
@@ -273,7 +273,7 @@ static int __search_die_tree(struct die_link *cur_link,
 		/* Move to next sibling */
 		ret = dwarf_siblingof(__dw_debug, cur_link->die, &new_die,
 				      &__dw_error);
-		ERR_IF(ret == DW_DLV_ERROR);
+		DIE_IF(ret == DW_DLV_ERROR);
 		dwarf_dealloc(__dw_debug, cur_link->die, DW_DLA_DIE);
 		cur_link->die = new_die;
 		if (ret == DW_DLV_NO_ENTRY)
@@ -293,7 +293,7 @@ static int search_die_from_children(Dwarf_Die parent_die,
 
 	new_link.parent = NULL;
 	ret = dwarf_child(parent_die, &new_link.die, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_OK)
 		return __search_die_tree(&new_link, die_cb, data);
 	else
@@ -309,7 +309,7 @@ static int attr_get_locdesc(Dwarf_Attribute attr, Dwarf_Locdesc *desc,
 	int ret, i;
 
 	ret = dwarf_loclist_n(attr, &llbuf, &lcnt, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	ret = DW_DLV_NO_ENTRY;
 	for (i = 0; i < lcnt; ++i) {
 		if (llbuf[i]->ld_lopc <= addr &&
@@ -317,7 +317,7 @@ static int attr_get_locdesc(Dwarf_Attribute attr, Dwarf_Locdesc *desc,
 			memcpy(desc, llbuf[i], sizeof(Dwarf_Locdesc));
 			desc->ld_s =
 				malloc(sizeof(Dwarf_Loc) * llbuf[i]->ld_cents);
-			ERR_IF(desc->ld_s == NULL);
+			DIE_IF(desc->ld_s == NULL);
 			memcpy(desc->ld_s, llbuf[i]->ld_s,
 				sizeof(Dwarf_Loc) * llbuf[i]->ld_cents);
 			ret = DW_DLV_OK;
@@ -383,8 +383,8 @@ static void show_location(Dwarf_Loc *loc, struct probe_finder *pf)
 				 " %s=%+lld(%s)", pf->var, offs, regs);
 	else
 		ret = snprintf(pf->buf, pf->len, " %s=%s", pf->var, regs);
-	ERR_IF(ret < 0);
-	ERR_IF(ret >= pf->len);
+	DIE_IF(ret < 0);
+	DIE_IF(ret >= pf->len);
 }
 
 /* Show a variables in kprobe event format */
@@ -401,7 +401,7 @@ static void show_variable(Dwarf_Die vr_die, struct probe_finder *pf)
 	if (ret != DW_DLV_OK)
 		goto error;
 	/* TODO? */
-	ERR_IF(ld.ld_cents != 1);
+	DIE_IF(ld.ld_cents != 1);
 	show_location(&ld.ld_s[0], pf);
 	free(ld.ld_s);
 	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
@@ -418,7 +418,7 @@ static int variable_callback(struct die_link *dlink, void *data)
 	int ret;
 
 	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	if ((tag == DW_TAG_formal_parameter ||
 	     tag == DW_TAG_variable) &&
 	    (die_compare_name(dlink->die, pf->var) == 0)) {
@@ -437,8 +437,8 @@ static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
 	if (!is_c_varname(pf->var)) {
 		/* Output raw parameters */
 		ret = snprintf(pf->buf, pf->len, " %s", pf->var);
-		ERR_IF(ret < 0);
-		ERR_IF(ret >= pf->len);
+		DIE_IF(ret < 0);
+		DIE_IF(ret >= pf->len);
 		return ;
 	}
 
@@ -456,9 +456,9 @@ static void get_current_frame_base(Dwarf_Die sp_die, struct probe_finder *pf)
 	int ret;
 
 	ret = dwarf_attr(sp_die, DW_AT_frame_base, &attr, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	ret = attr_get_locdesc(attr, &pf->fbloc, (pf->addr - pf->cu_base));
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
 }
 
@@ -479,7 +479,7 @@ static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
 
 	/* Output name of probe point */
 	ret = dwarf_diename(sp_die, &name, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_OK) {
 		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%u", name,
 				(unsigned int)offs);
@@ -488,8 +488,8 @@ static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
 		/* This function has no name. */
 		ret = snprintf(tmp, MAX_PROBE_BUFFER, "0x%llx", pf->addr);
 	}
-	ERR_IF(ret < 0);
-	ERR_IF(ret >= MAX_PROBE_BUFFER);
+	DIE_IF(ret < 0);
+	DIE_IF(ret >= MAX_PROBE_BUFFER);
 	len = ret;
 
 	/* Find each argument */
@@ -515,7 +515,7 @@ static int probeaddr_callback(struct die_link *dlink, void *data)
 	int ret;
 
 	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	/* Check the address is in this subprogram */
 	if (tag == DW_TAG_subprogram &&
 	    die_within_subprogram(dlink->die, pf->addr, &offs)) {
@@ -537,21 +537,21 @@ static void find_by_line(Dwarf_Die cu_die, struct probe_finder *pf)
 	int ret;
 
 	ret = dwarf_srclines(cu_die, &lines, &cnt, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 
 	for (i = 0; i < cnt; i++) {
 		ret = dwarf_line_srcfileno(lines[i], &fno, &__dw_error);
-		ERR_IF(ret != DW_DLV_OK);
+		DIE_IF(ret != DW_DLV_OK);
 		if (fno != pf->fno)
 			continue;
 
 		ret = dwarf_lineno(lines[i], &lineno, &__dw_error);
-		ERR_IF(ret != DW_DLV_OK);
+		DIE_IF(ret != DW_DLV_OK);
 		if (lineno != (Dwarf_Unsigned)pp->line)
 			continue;
 
 		ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
-		ERR_IF(ret != DW_DLV_OK);
+		DIE_IF(ret != DW_DLV_OK);
 		eprintf("Probe point found: 0x%llx\n", addr);
 		pf->addr = addr;
 		/* Search a real subprogram including this line, */
@@ -574,7 +574,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 	int ret;
 
 	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	ERR_IF(ret == DW_DLV_ERROR);
+	DIE_IF(ret == DW_DLV_ERROR);
 	if (tag == DW_TAG_subprogram) {
 		if (die_compare_name(dlink->die, pp->function) == 0) {
 			if (die_inlined_subprogram(dlink->die)) {
@@ -582,7 +582,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 				ret = dwarf_die_CU_offset(dlink->die,
 							  &pf->inl_offs,
 							  &__dw_error);
-				ERR_IF(ret != DW_DLV_OK);
+				DIE_IF(ret != DW_DLV_OK);
 				eprintf("inline definition offset %lld\n",
 					pf->inl_offs);
 				return 0;
@@ -604,7 +604,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 			for (lk = dlink->parent; lk != NULL; lk = lk->parent) {
 				tag = 0;
 				dwarf_tag(lk->die, &tag, &__dw_error);
-				ERR_IF(ret == DW_DLV_ERROR);
+				DIE_IF(ret == DW_DLV_ERROR);
 				if (tag == DW_TAG_subprogram &&
 				    !die_inlined_subprogram(lk->die))
 					goto found;
@@ -613,7 +613,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 found:
 			/* Get offset from subprogram */
 			ret = die_within_subprogram(lk->die, pf->addr, &offs);
-			ERR_IF(!ret);
+			DIE_IF(!ret);
 			show_probepoint(lk->die, offs, pf);
 			/* Continue to search */
 		}
@@ -644,13 +644,13 @@ int find_probepoint(int fd, struct probe_point *pp)
 		/* Search CU (Compilation Unit) */
 		ret = dwarf_next_cu_header(__dw_debug, NULL, NULL, NULL,
 			&addr_size, &next_cuh, &__dw_error);
-		ERR_IF(ret == DW_DLV_ERROR);
+		DIE_IF(ret == DW_DLV_ERROR);
 		if (ret == DW_DLV_NO_ENTRY)
 			break;
 
 		/* Get the DIE(Debugging Information Entry) of this CU */
 		ret = dwarf_siblingof(__dw_debug, 0, &cu_die, &__dw_error);
-		ERR_IF(ret != DW_DLV_OK);
+		DIE_IF(ret != DW_DLV_OK);
 
 		/* Check if target file is included. */
 		if (pp->file)
@@ -659,7 +659,7 @@ int find_probepoint(int fd, struct probe_point *pp)
 		if (!pp->file || pf.fno) {
 			/* Save CU base address (for frame_base) */
 			ret = dwarf_lowpc(cu_die, &pf.cu_base, &__dw_error);
-			ERR_IF(ret == DW_DLV_ERROR);
+			DIE_IF(ret == DW_DLV_ERROR);
 			if (ret == DW_DLV_NO_ENTRY)
 				pf.cu_base = 0;
 			if (pp->line)
@@ -670,7 +670,7 @@ int find_probepoint(int fd, struct probe_point *pp)
 		dwarf_dealloc(__dw_debug, cu_die, DW_DLA_DIE);
 	}
 	ret = dwarf_finish(__dw_debug, &__dw_error);
-	ERR_IF(ret != DW_DLV_OK);
+	DIE_IF(ret != DW_DLV_OK);
 
 	return pp->found;
 }
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 6a7cb0c..d17fafc 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -1,16 +1,6 @@
 #ifndef _PROBE_FINDER_H
 #define _PROBE_FINDER_H
 
-#define _stringify(n)	#n
-#define stringify(n)	_stringify(n)
-
-#define ERR_IF(cnd)	\
-	do { if (cnd) {	\
-		fprintf(stderr, "Error (" __FILE__ ":" stringify(__LINE__) \
-			"): " stringify(cnd) "\n");			\
-		exit(1);						\
-	} } while (0)
-
 #define MAX_PATH_LEN 256
 #define MAX_PROBE_BUFFER 1024
 #define MAX_PROBES 128
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 9de2329..0daa341 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -134,6 +134,15 @@ extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1,
 extern int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
 extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
 
+#include "../../../include/linux/stringify.h"
+
+#define DIE_IF(cnd)	\
+	do { if (cnd)	\
+		die(" at (" __FILE__ ":" __stringify(__LINE__) "): "	\
+		    __stringify(cnd) "\n");				\
+	} while (0)
+
+
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
 extern int prefixcmp(const char *str, const char *prefix);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
