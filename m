Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbZJQAH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbZJQAH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZJQAH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZJQAHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:07:55 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 6/9] perf: Use die() for error cases in
	perf-probe
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
Date: Fri, 16 Oct 2009 20:08:01 -0400
Message-ID: <20091017000801.16556.46866.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use die() for exiting perf-probe with errors. This replaces
perror_exit(), msg_exit() and fprintf()+exit() with die(), and
uses die() in semantic_error().
This also renames 'die' local variables to 'dw_die' for avoiding
name confliction.

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

 tools/perf/builtin-probe.c     |   47 ++++++++++------------------------
 tools/perf/util/probe-finder.c |   55 +++++++++++++++-------------------------
 2 files changed, 34 insertions(+), 68 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 73c883b..a1467d1 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -49,6 +49,7 @@ const char *default_search_path[NR_SEARCH_PATH] = {
 
 #define MAX_PATH_LEN 256
 #define MAX_PROBES 128
+#define MAX_PROBE_ARGS 128
 
 /* Session management structure */
 static struct {
@@ -60,19 +61,7 @@ static struct {
 	char *events[MAX_PROBES];
 } session;
 
-static void semantic_error(const char *msg)
-{
-	fprintf(stderr, "Semantic error: %s\n", msg);
-	exit(1);
-}
-
-static void perror_exit(const char *msg)
-{
-	perror(msg);
-	exit(1);
-}
-
-#define MAX_PROBE_ARGS 128
+#define semantic_error(msg ...) die("Semantic error :" msg)
 
 static int parse_probepoint(const struct option *opt __used,
 			    const char *str, int unset __used)
@@ -109,7 +98,7 @@ static int parse_probepoint(const struct option *opt __used,
 			/* Duplicate the argument */
 			argv[argc] = strndup(s, str - s);
 			if (argv[argc] == NULL)
-				perror_exit("strndup");
+				die("strndup");
 			if (++argc == MAX_PROBE_ARGS)
 				semantic_error("Too many arguments");
 			debug("argv[%d]=%s\n", argc, argv[argc - 1]);
@@ -171,7 +160,7 @@ static int parse_probepoint(const struct option *opt __used,
 	if (pp->nr_args > 0) {
 		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);
 		if (!pp->args)
-			perror_exit("malloc");
+			die("malloc");
 		memcpy(pp->args, &argv[2], sizeof(char *) * pp->nr_args);
 	}
 
@@ -260,7 +249,7 @@ static int write_new_event(int fd, const char *buf)
 	printf("Adding new event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
 	if (ret <= 0)
-		perror("Error: Failed to create event");
+		die("failed to create event.");
 
 	return ret;
 }
@@ -273,7 +262,7 @@ static int synthesize_probepoint(struct probe_point *pp)
 	int i, len, ret;
 	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));
 	if (!buf)
-		perror_exit("calloc");
+		die("calloc");
 	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
 	if (ret <= 0 || ret >= MAX_CMDLEN)
 		goto error;
@@ -322,10 +311,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		ret = synthesize_probepoint(&session.probes[j]);
 		if (ret == -E2BIG)
 			semantic_error("probe point is too long.");
-		else if (ret < 0) {
-			perror("snprintf");
-			return -1;
-		}
+		else if (ret < 0)
+			die("snprintf");
 	}
 
 #ifndef NO_LIBDWARF
@@ -336,10 +323,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		fd = open(session.vmlinux, O_RDONLY);
 	else
 		fd = open_default_vmlinux();
-	if (fd < 0) {
-		perror("vmlinux/module file open");
-		return -1;
-	}
+	if (fd < 0)
+		die("vmlinux/module file open");
 
 	/* Searching probe points */
 	for (j = 0; j < session.nr_probe; j++) {
@@ -349,10 +334,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 		lseek(fd, SEEK_SET, 0);
 		ret = find_probepoint(fd, pp);
-		if (ret <= 0) {
-			fprintf(stderr, "Error: No probe point found.\n");
-			return -1;
-		}
+		if (ret <= 0)
+			die("No probe point found.\n");
 		debug("probe event %s found\n", session.events[j]);
 	}
 	close(fd);
@@ -363,10 +346,8 @@ setup_probes:
 	/* Settng up probe points */
 	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
 	fd = open(buf, O_WRONLY, O_APPEND);
-	if (fd < 0) {
-		perror("kprobe_events open");
-		return -1;
-	}
+	if (fd < 0)
+		die("kprobe_events open");
 	for (j = 0; j < session.nr_probe; j++) {
 		pp = &session.probes[j];
 		if (pp->found == 1) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index ec6f53f..338fdb9 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -31,6 +31,8 @@
 #include <string.h>
 #include <stdarg.h>
 #include <ctype.h>
+
+#include "util.h"
 #include "probe-finder.h"
 
 
@@ -43,20 +45,6 @@ struct die_link {
 static Dwarf_Debug __dw_debug;
 static Dwarf_Error __dw_error;
 
-static void msg_exit(int ret, const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	fprintf(stderr, "Error:  ");
-	vfprintf(stderr, fmt, ap);
-	va_end(ap);
-
-	fprintf(stderr, "\n");
-	exit(ret);
-}
-
-
 /*
  * Generic dwarf analysis helpers
  */
@@ -151,11 +139,11 @@ static Dwarf_Unsigned die_get_fileno(Dwarf_Die cu_die, const char *fname)
 }
 
 /* Compare diename and tname */
-static int die_compare_name(Dwarf_Die die, const char *tname)
+static int die_compare_name(Dwarf_Die dw_die, const char *tname)
 {
 	char *name;
 	int ret;
-	ret = dwarf_diename(die, &name, &__dw_error);
+	ret = dwarf_diename(dw_die, &name, &__dw_error);
 	ERR_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_OK) {
 		ret = strcmp(tname, name);
@@ -187,25 +175,25 @@ static int die_within_subprogram(Dwarf_Die sp_die, Dwarf_Addr addr,
 }
 
 /* Check the die is inlined function */
-static Dwarf_Bool die_inlined_subprogram(Dwarf_Die die)
+static Dwarf_Bool die_inlined_subprogram(Dwarf_Die dw_die)
 {
 	/* TODO: check strictly */
 	Dwarf_Bool inl;
 	int ret;
 
-	ret = dwarf_hasattr(die, DW_AT_inline, &inl, &__dw_error);
+	ret = dwarf_hasattr(dw_die, DW_AT_inline, &inl, &__dw_error);
 	ERR_IF(ret == DW_DLV_ERROR);
 	return inl;
 }
 
 /* Get the offset of abstruct_origin */
-static Dwarf_Off die_get_abstract_origin(Dwarf_Die die)
+static Dwarf_Off die_get_abstract_origin(Dwarf_Die dw_die)
 {
 	Dwarf_Attribute attr;
 	Dwarf_Off cu_offs;
 	int ret;
 
-	ret = dwarf_attr(die, DW_AT_abstract_origin, &attr, &__dw_error);
+	ret = dwarf_attr(dw_die, DW_AT_abstract_origin, &attr, &__dw_error);
 	ERR_IF(ret != DW_DLV_OK);
 	ret = dwarf_formref(attr, &cu_offs, &__dw_error);
 	ERR_IF(ret != DW_DLV_OK);
@@ -214,7 +202,7 @@ static Dwarf_Off die_get_abstract_origin(Dwarf_Die die)
 }
 
 /* Get entry pc(or low pc, 1st entry of ranges)  of the die */
-static Dwarf_Addr die_get_entrypc(Dwarf_Die die)
+static Dwarf_Addr die_get_entrypc(Dwarf_Die dw_die)
 {
 	Dwarf_Attribute attr;
 	Dwarf_Addr addr;
@@ -224,7 +212,7 @@ static Dwarf_Addr die_get_entrypc(Dwarf_Die die)
 	int ret;
 
 	/* Try to get entry pc */
-	ret = dwarf_attr(die, DW_AT_entry_pc, &attr, &__dw_error);
+	ret = dwarf_attr(dw_die, DW_AT_entry_pc, &attr, &__dw_error);
 	ERR_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_OK) {
 		ret = dwarf_formaddr(attr, &addr, &__dw_error);
@@ -234,13 +222,13 @@ static Dwarf_Addr die_get_entrypc(Dwarf_Die die)
 	}
 
 	/* Try to get low pc */
-	ret = dwarf_lowpc(die, &addr, &__dw_error);
+	ret = dwarf_lowpc(dw_die, &addr, &__dw_error);
 	ERR_IF(ret == DW_DLV_ERROR);
 	if (ret == DW_DLV_OK)
 		return addr;
 
 	/* Try to get ranges */
-	ret = dwarf_attr(die, DW_AT_ranges, &attr, &__dw_error);
+	ret = dwarf_attr(dw_die, DW_AT_ranges, &attr, &__dw_error);
 	ERR_IF(ret != DW_DLV_OK);
 	ret = dwarf_formref(attr, &offs, &__dw_error);
 	ERR_IF(ret != DW_DLV_OK);
@@ -382,11 +370,11 @@ static void show_location(Dwarf_Loc *loc, struct probe_finder *pf)
 	} else if (op == DW_OP_regx) {
 		regn = loc->lr_number;
 	} else
-		msg_exit(-EINVAL, "Dwarf_OP %d is not supported.\n", op);
+		die("Dwarf_OP %d is not supported.\n", op);
 
 	regs = get_arch_regstr(regn);
 	if (!regs)
-		msg_exit(-EINVAL, "%lld exceeds max register number.\n", regn);
+		die("%lld exceeds max register number.\n", regn);
 
 	if (deref)
 		ret = snprintf(pf->buf, pf->len,
@@ -417,8 +405,8 @@ static void show_variable(Dwarf_Die vr_die, struct probe_finder *pf)
 	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
 	return ;
 error:
-	msg_exit(-1, "Failed to find the location of %s at this address.\n"
-		 " Perhaps, it was optimized out.\n", pf->var);
+	die("Failed to find the location of %s at this address.\n"
+	    " Perhaps, it has been optimized out.\n", pf->var);
 }
 
 static int variable_callback(struct die_link *dlink, void *data)
@@ -456,8 +444,7 @@ static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
 	/* Search child die for local variables and parameters. */
 	ret = search_die_from_children(sp_die, variable_callback, pf);
 	if (!ret)
-		msg_exit(-1, "Failed to find '%s' in this function.\n",
-			 pf->var);
+		die("Failed to find '%s' in this function.\n", pf->var);
 }
 
 /* Get a frame base on the address */
@@ -568,8 +555,7 @@ static void find_by_line(Dwarf_Die cu_die, struct probe_finder *pf)
 		/* Search a real subprogram including this line, */
 		ret = search_die_from_children(cu_die, probeaddr_callback, pf);
 		if (ret == 0)
-			msg_exit(-1,
-				 "Probe point is not found in subprograms.\n");
+			die("Probe point is not found in subprograms.\n");
 		/* Continuing, because target line might be inlined. */
 	}
 	dwarf_srclines_dealloc(__dw_debug, lines, cnt);
@@ -621,7 +607,7 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 				    !die_inlined_subprogram(lk->die))
 					goto found;
 			}
-			msg_exit(-1, "Failed to find real subprogram.\n");
+			die("Failed to find real subprogram.\n");
 found:
 			/* Get offset from subprogram */
 			ret = die_within_subprogram(lk->die, pf->addr, &offs);
@@ -649,8 +635,7 @@ int find_probepoint(int fd, struct probe_point *pp)
 
 	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
 	if (ret != DW_DLV_OK)
-		msg_exit(-1, "Failed to call dwarf_init(). "
-			 "Maybe, not a dwarf file?\n");
+		die("Failed to call dwarf_init(). Maybe, not a dwarf file.\n");
 
 	pp->found = 0;
 	while (++cu_number) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
