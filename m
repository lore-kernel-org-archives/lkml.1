Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbZJ0UoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbZJ0UoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376AbZJ0UoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbZJ0Un4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:43:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 09/10] perf/probes: Change probepoint syntax
	of perf-probe
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 27 Oct 2009 16:43:10 -0400
Message-ID: <20091027204310.30545.84984.stgit@harusame>
In-Reply-To: <20091027204156.30545.96425.stgit@harusame>
References: <20091027204156.30545.96425.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes probe point syntax of perf-probe as below

 <SRC>[:ABS_LN] [ARGS]
 or
 <FUNC>[+OFFS|%return][@SRC] [ARGS]

And event name and event group name are automatically
generated based on probe-symbol and offset as below.

 perfprobes/SYMBOL_OFFSET[_NUM]

Where SYMBOL is the probing symbol and OFFSET is
the byte offset from the symbol.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/builtin-probe.c     |  181 +++++++++++++++++++++++++---------------
 tools/perf/util/probe-finder.c |   10 ++
 tools/perf/util/probe-finder.h |    2 
 3 files changed, 123 insertions(+), 70 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 3370dab..92b4c49 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -52,6 +52,7 @@ const char *default_search_path[NR_SEARCH_PATH] = {
 #define MAX_PATH_LEN 256
 #define MAX_PROBES 128
 #define MAX_PROBE_ARGS 128
+#define PERFPROBE_GROUP "perfprobe"
 
 /* Session management structure */
 static struct {
@@ -60,20 +61,100 @@ static struct {
 	int need_dwarf;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
-	char *events[MAX_PROBES];
 } session;
 
 #define semantic_error(msg ...) die("Semantic error :" msg)
 
-/* Parse a probe point. Note that any error must die. */
-static void parse_probepoint(const char *str)
+/* Parse probe point. Return 1 if return probe */
+static void parse_probe_point(char *arg, struct probe_point *pp)
+{
+	char *ptr, *tmp;
+	char c, nc;
+	/*
+	 * <Syntax>
+	 * perf probe SRC:LN
+	 * perf probe FUNC[+OFFS|%return][@SRC]
+	 */
+
+	ptr = strpbrk(arg, ":+@%");
+	if (ptr) {
+		nc = *ptr;
+		*ptr++ = '\0';
+	}
+
+	/* Check arg is function or file and copy it */
+	if (strchr(arg, '.'))	/* File */
+		pp->file = strdup(arg);
+	else			/* Function */
+		pp->function = strdup(arg);
+	DIE_IF(pp->file == NULL && pp->function == NULL);
+
+	/* Parse other options */
+	while (ptr) {
+		arg = ptr;
+		c = nc;
+		ptr = strpbrk(arg, ":+@%");
+		if (ptr) {
+			nc = *ptr;
+			*ptr++ = '\0';
+		}
+		switch (c) {
+		case ':':	/* Line number */
+			pp->line = strtoul(arg, &tmp, 0);
+			if (*tmp != '\0')
+				semantic_error("There is non-digit charactor"
+						" in line number.");
+			break;
+		case '+':	/* Byte offset from a symbol */
+			pp->offset = strtoul(arg, &tmp, 0);
+			if (*tmp != '\0')
+				semantic_error("There is non-digit charactor"
+						" in offset.");
+			break;
+		case '@':	/* File name */
+			if (pp->file)
+				semantic_error("SRC@SRC is not allowed.");
+			pp->file = strdup(arg);
+			DIE_IF(pp->file == NULL);
+			if (ptr)
+				semantic_error("@SRC must be the last "
+					       "option.");
+			break;
+		case '%':	/* Probe places */
+			if (strcmp(arg, "return") == 0) {
+				pp->retprobe = 1;
+			} else	/* Others not supported yet */
+				semantic_error("%%%s is not supported.", arg);
+			break;
+		default:
+			DIE_IF("Program has a bug.");
+			break;
+		}
+	}
+
+	/* Exclusion check */
+	if (pp->line && pp->function)
+		semantic_error("Function-relative line number is not"
+				" supported yet.");
+	if (!pp->line && pp->file && !pp->function)
+		semantic_error("File always requires line number.");
+	if (pp->offset && !pp->function)
+		semantic_error("Offset requires an entry function.");
+	if (pp->retprobe && !pp->function)
+		semantic_error("Return probe requires an entry function.");
+	if (pp->offset && pp->retprobe)
+		semantic_error("Offset can't be used with return probe.");
+
+	pr_debug("symbol:%s file:%s line:%d offset:%d, return:%d\n",
+		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe);
+}
+
+/* Parse an event definition. Note that any error must die. */
+static void parse_probe_event(const char *str)
 {
 	char *argv[MAX_PROBE_ARGS + 2];	/* Event + probe + args */
 	int argc, i;
-	char *arg, *ptr;
 	struct probe_point *pp = &session.probes[session.nr_probe];
-	char **event = &session.events[session.nr_probe];
-	int retp = 0;
 
 	pr_debug("probe-definition(%d): %s\n", session.nr_probe, str);
 	if (++session.nr_probe == MAX_PROBES)
@@ -103,70 +184,28 @@ static void parse_probepoint(const char *str)
 			pr_debug("argv[%d]=%s\n", argc, argv[argc - 1]);
 		}
 	} while (*str != '\0');
-	if (argc < 2)
-		semantic_error("Need event-name and probe-point at least.");
-
-	/* Parse the event name */
-	if (argv[0][0] == 'r')
-		retp = 1;
-	else if (argv[0][0] != 'p')
-		semantic_error("You must specify 'p'(kprobe) or"
-				" 'r'(kretprobe) first.");
-	/* TODO: check event name */
-	*event = argv[0];
+	if (!argc)
+		semantic_error("An empty argument.");
 
 	/* Parse probe point */
-	arg = argv[1];
-	if (arg[0] == '@') {
-		/* Source Line */
-		arg++;
-		ptr = strchr(arg, ':');
-		if (!ptr || !isdigit(ptr[1]))
-			semantic_error("Line number is required.");
-		*ptr++ = '\0';
-		if (strlen(arg) == 0)
-			semantic_error("No file name.");
-		pp->file = strdup(arg);
-		pp->line = atoi(ptr);
-		if (!pp->file || !pp->line)
-			semantic_error("Failed to parse line.");
-		pr_debug("file:%s line:%d\n", pp->file, pp->line);
-	} else {
-		/* Function name */
-		ptr = strchr(arg, '+');
-		if (ptr) {
-			if (!isdigit(ptr[1]))
-				semantic_error("Offset is required.");
-			*ptr++ = '\0';
-			pp->offset = atoi(ptr);
-		} else
-			ptr = arg;
-		ptr = strchr(ptr, '@');
-		if (ptr) {
-			*ptr++ = '\0';
-			pp->file = strdup(ptr);
-		}
-		pp->function = strdup(arg);
-		pr_debug("symbol:%s file:%s offset:%d\n",
-			 pp->function, pp->file, pp->offset);
-	}
-	free(argv[1]);
+	parse_probe_point(argv[0], pp);
+	free(argv[0]);
 	if (pp->file)
 		session.need_dwarf = 1;
 
 	/* Copy arguments */
-	pp->nr_args = argc - 2;
+	pp->nr_args = argc - 1;
 	if (pp->nr_args > 0) {
 		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);
 		if (!pp->args)
 			die("malloc");
-		memcpy(pp->args, &argv[2], sizeof(char *) * pp->nr_args);
+		memcpy(pp->args, &argv[1], sizeof(char *) * pp->nr_args);
 	}
 
 	/* Ensure return probe has no C argument */
 	for (i = 0; i < pp->nr_args; i++)
 		if (is_c_varname(pp->args[i])) {
-			if (retp)
+			if (pp->retprobe)
 				semantic_error("You can't specify local"
 						" variable for kretprobe");
 			session.need_dwarf = 1;
@@ -175,11 +214,11 @@ static void parse_probepoint(const char *str)
 	pr_debug("%d arguments\n", pp->nr_args);
 }
 
-static int opt_add_probepoint(const struct option *opt __used,
+static int opt_add_probe_event(const struct option *opt __used,
 			      const char *str, int unset __used)
 {
 	if (str)
-		parse_probepoint(str);
+		parse_probe_event(str);
 	return 0;
 }
 
@@ -229,17 +268,16 @@ static const struct option options[] = {
 #endif
 	OPT_CALLBACK('a', "add", NULL,
 #ifdef NO_LIBDWARF
-		"p|r:[GRP/]NAME FUNC[+OFFS] [ARG ...]",
+		"FUNC[+OFFS|%return] [ARG ...]",
 #else
-		"p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]",
+		"FUNC[+OFFS|%return][@SRC]|SRC:LINE [ARG ...]",
 #endif
 		"probe point definition, where\n"
-		"\t\tp:\tkprobe probe\n"
-		"\t\tr:\tkretprobe probe\n"
 		"\t\tGRP:\tGroup name (optional)\n"
 		"\t\tNAME:\tEvent name\n"
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFFS:\tOffset from function entry (in byte)\n"
+		"\t\t%return:\tPut the probe at function return\n"
 #ifdef NO_LIBDWARF
 		"\t\tARG:\tProbe argument (only \n"
 #else
@@ -248,7 +286,7 @@ static const struct option options[] = {
 		"\t\tARG:\tProbe argument (local variable name or\n"
 #endif
 		"\t\t\tkprobe-tracer argument format is supported.)\n",
-		opt_add_probepoint),
+		opt_add_probe_event),
 	OPT_END()
 };
 
@@ -266,7 +304,7 @@ static int write_new_event(int fd, const char *buf)
 
 #define MAX_CMDLEN 256
 
-static int synthesize_probepoint(struct probe_point *pp)
+static int synthesize_probe_event(struct probe_point *pp)
 {
 	char *buf;
 	int i, len, ret;
@@ -316,12 +354,12 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	/* Synthesize probes without dwarf */
 	for (j = 0; j < session.nr_probe; j++) {
 #ifndef NO_LIBDWARF
-		if (session.events[j][0] != 'r') {
+		if (!session.probes[j].retprobe) {
 			session.need_dwarf = 1;
 			continue;
 		}
 #endif
-		ret = synthesize_probepoint(&session.probes[j]);
+		ret = synthesize_probe_event(&session.probes[j]);
 		if (ret == -E2BIG)
 			semantic_error("probe point is too long.");
 		else if (ret < 0)
@@ -349,7 +387,6 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		ret = find_probepoint(fd, pp);
 		if (ret <= 0)
 			die("No probe point found.\n");
-		pr_debug("probe event %s found\n", session.events[j]);
 	}
 	close(fd);
 
@@ -364,13 +401,17 @@ setup_probes:
 	for (j = 0; j < session.nr_probe; j++) {
 		pp = &session.probes[j];
 		if (pp->found == 1) {
-			snprintf(buf, MAX_CMDLEN, "%s %s\n",
-				session.events[j], pp->probes[0]);
+			snprintf(buf, MAX_CMDLEN, "%c:%s/%s_%x %s\n",
+				pp->retprobe ? 'r' : 'p', PERFPROBE_GROUP,
+				pp->function, pp->offset, pp->probes[0]);
 			write_new_event(fd, buf);
 		} else
 			for (i = 0; i < pp->found; i++) {
-				snprintf(buf, MAX_CMDLEN, "%s%d %s\n",
-					session.events[j], i, pp->probes[i]);
+				snprintf(buf, MAX_CMDLEN, "%c:%s/%s_%x_%d %s\n",
+					pp->retprobe ? 'r' : 'p',
+					PERFPROBE_GROUP,
+					pp->function, pp->offset, i,
+					pp->probes[0]);
 				write_new_event(fd, buf);
 			}
 	}
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index b98d35e..6d3bac9 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -483,10 +483,20 @@ static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
 	if (ret == DW_DLV_OK) {
 		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%u", name,
 				(unsigned int)offs);
+		/* Copy the function name if possible */
+		if (!pp->function) {
+			pp->function = strdup(name);
+			pp->offset = offs;
+		}
 		dwarf_dealloc(__dw_debug, name, DW_DLA_STRING);
 	} else {
 		/* This function has no name. */
 		ret = snprintf(tmp, MAX_PROBE_BUFFER, "0x%llx", pf->addr);
+		if (!pp->function) {
+			/* TODO: Use _stext */
+			pp->function = strdup("");
+			pp->offset = (int)pf->addr;
+		}
 	}
 	DIE_IF(ret < 0);
 	DIE_IF(ret >= MAX_PROBE_BUFFER);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index d17fafc..240d6cb 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -22,6 +22,8 @@ struct probe_point {
 	int	nr_args;	/* Number of arguments */
 	char	**args;		/* Arguments */
 
+	int	retprobe;	/* Return probe */
+
 	/* Output */
 	int	found;		/* Number of found probe points */
 	char	*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
