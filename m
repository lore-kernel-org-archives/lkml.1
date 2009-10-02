Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZJBVrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZJBVrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZJBVrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326AbZJBVri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:47:38 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes v2 5/5] perf: kprobe command supports without
	libdwarf
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
Date: Fri, 02 Oct 2009 17:49:12 -0400
Message-ID: <20091002214912.30906.9817.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables perf-kprobe even if libdwarf is installed. If libdwarf is not found,
perf-kprobe just disables dwarf support. Users can use perf-kprobe to set
up new events by using kprobe_events format.

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

 tools/perf/Makefile            |    6 +++---
 tools/perf/builtin-probe.c     |   42 +++++++++++++++++++++++++++++++++-------
 tools/perf/perf.c              |    2 --
 tools/perf/util/probe-finder.h |    2 ++
 4 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6dabcf1..52b1f43 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -385,6 +385,7 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-timechart.o
 BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
+BUILTIN_OBJS += builtin-probe.o
 
 PERFLIBS = $(LIB_FILE)
 
@@ -420,13 +421,12 @@ ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf *
 endif
 
 ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
-	msg := $(warning No libdwarf.h found, disables probe subcommand. Please install libdwarf-dev/libdwarf-devel);
+	msg := $(warning No libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel);
+	BASIC_CFLAGS += -DNO_LIBDWARF
 else
 	EXTLIBS += -lelf -ldwarf
 	LIB_H += util/probe-finder.h
 	LIB_OBJS += util/probe-finder.o
-	BUILTIN_OBJS += builtin-probe.o
-	BASIC_CFLAGS += -DSUPPORT_DWARF
 endif
 
 ifdef NO_DEMANGLE
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 47c5fb8..0c39b07 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -53,6 +53,7 @@ const char *default_search_path[NR_SEARCH_PATH] = {
 static struct {
 	char *vmlinux;
 	char *release;
+	int need_dwarf;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	char *events[MAX_PROBES];
@@ -161,6 +162,8 @@ static int parse_probepoint(const struct option *opt __used,
 		      pp->function, pp->file, pp->offset);
 	}
 	free(argv[1]);
+	if (pp->file)
+		session.need_dwarf = 1;
 
 	/* Copy arguments */
 	pp->nr_args = argc - 2;
@@ -170,15 +173,19 @@ static int parse_probepoint(const struct option *opt __used,
 	}
 
 	/* Ensure return probe has no C argument */
-	if (retp)
-		for (i = 0; i < pp->nr_args; i++)
-			if (is_c_varname(pp->args[i]))
+	for (i = 0; i < pp->nr_args; i++)
+		if (is_c_varname(pp->args[i])) {
+			if (retp)
 				semantic_error("You can't specify local"
 						" variable for kretprobe");
+			session.need_dwarf = 1;
+		}
+
 	debug("%d arguments\n", pp->nr_args);
 	return 0;
 }
 
+#ifndef NO_LIBDWARF
 static int open_default_vmlinux(void)
 {
 	struct utsname uts;
@@ -208,6 +215,7 @@ static int open_default_vmlinux(void)
 	}
 	return fd;
 }
+#endif
 
 static const char * const probe_usage[] = {
 	"perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]",
@@ -215,11 +223,17 @@ static const char * const probe_usage[] = {
 };
 
 static const struct option options[] = {
+#ifndef NO_LIBDWARF
 	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
 		"vmlinux/module pathname"),
 	OPT_STRING('r', "release", &session.release, "rel", "kernel release"),
+#endif
 	OPT_CALLBACK('P', "probe", NULL,
+#ifdef NO_LIBDWARF
+		"p|r:[GRP/]NAME FUNC[+OFFS] [ARG ...]",
+#else
 		"p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]",
+#endif
 		"probe point definition, where\n"
 		"\t\tp:\tkprobe probe\n"
 		"\t\tr:\tkretprobe probe\n"
@@ -227,9 +241,13 @@ static const struct option options[] = {
 		"\t\tNAME:\tEvent name\n"
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFFS:\tOffset from function entry (in byte)\n"
+#ifdef NO_LIBDWARF
+		"\t\tARG:\tProbe argument (only \n"
+#else
 		"\t\tSRC:\tSource code path\n"
 		"\t\tLINE:\tLine number\n"
 		"\t\tARG:\tProbe argument (local variable name or\n"
+#endif
 		"\t\t\tkprobe-tracer argument format is supported.)\n",
 		parse_probepoint),
 	OPT_END()
@@ -277,7 +295,7 @@ error:
 
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
-	int i, j, fd, ret, need_dwarf = 0;
+	int i, j, fd, ret;
 	struct probe_point *pp;
 	char buf[MAX_CMDLEN];
 
@@ -286,12 +304,19 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	if (argc || session.nr_probe == 0)
 		usage_with_options(probe_usage, options);
 
-	/* Synthesize return probes */
+#ifdef NO_LIBDWARF
+	if (session.need_dwarf)
+		semantic_error("Dwarf-analysis is not supported");
+#endif
+
+	/* Synthesize probes without dwarf */
 	for (j = 0; j < session.nr_probe; j++) {
+#ifndef NO_LIBDWARF
 		if (session.events[j][0] != 'r') {
-			need_dwarf = 1;
+			session.need_dwarf = 1;
 			continue;
 		}
+#endif
 		ret = synthesize_probepoint(&session.probes[j]);
 		if (ret == -E2BIG)
 			semantic_error("probe point is too long.");
@@ -301,7 +326,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		}
 	}
 
-	if (!need_dwarf)
+#ifndef NO_LIBDWARF
+	if (!session.need_dwarf)
 		goto setup_probes;
 
 	if (session.vmlinux)
@@ -330,6 +356,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	close(fd);
 
 setup_probes:
+#endif /* !NO_LIBDWARF */
+
 	/* Settng up probe points */
 	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
 	fd = open(buf, O_WRONLY, O_APPEND);
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index f598120..c570d17 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -295,9 +295,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "version", cmd_version, 0 },
 		{ "trace", cmd_trace, 0 },
 		{ "sched", cmd_sched, 0 },
-#ifdef SUPPORT_DWARF
 		{ "probe", cmd_probe, 0 },
-#endif
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index af920de..306810c 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -44,6 +44,7 @@ struct probe_point {
 	char	*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
 };
 
+#ifndef NO_LIBDWARF
 extern int find_probepoint(int fd, struct probe_point *pp);
 
 #include <libdwarf/dwarf.h>
@@ -64,5 +65,6 @@ struct probe_finder {
 	char		*buf;		/* Current output buffer */
 	int		len;		/* Length of output buffer */
 };
+#endif /* NO_LIBDWARF */
 
 #endif /*_PROBE_FINDER_H */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
