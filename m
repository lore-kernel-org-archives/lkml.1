Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZJQKFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZJQKFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZJQKFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:05:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:33066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZJQKFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:05:39 -0400
Date: Sat, 17 Oct 2009 10:04:43 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, fche@redhat.com, paulus@samba.org,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       fche@redhat.com, linux-kernel@vger.kernel.org, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091007222830.1684.25665.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091007222830.1684.25665.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf probe: Add perf probe command support without libdwarf
Message-ID: <tip-23e8ec0d1c410f2f1d81050ee155db229abb1707@git.kernel.org>
Git-Commit-ID: 23e8ec0d1c410f2f1d81050ee155db229abb1707
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:04:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23e8ec0d1c410f2f1d81050ee155db229abb1707
Gitweb:     http://git.kernel.org/tip/23e8ec0d1c410f2f1d81050ee155db229abb1707
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 7 Oct 2009 18:28:30 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 12 Oct 2009 23:31:53 +0200

perf probe: Add perf probe command support without libdwarf

Enables 'perf probe' even if libdwarf is not installed. If libdwarf is
not found, 'perf probe' just disables dwarf support. Users can use
'perf probe' to set up new events by using kprobe_events format.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
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
LKML-Reference: <20091007222830.1684.25665.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile            |    6 ++--
 tools/perf/builtin-probe.c     |   42 +++++++++++++++++++++++++++++++++------
 tools/perf/perf.c              |    2 -
 tools/perf/util/probe-finder.h |    2 +
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
index 24b64b5..73c883b 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -54,6 +54,7 @@ const char *default_search_path[NR_SEARCH_PATH] = {
 static struct {
 	char *vmlinux;
 	char *release;
+	int need_dwarf;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	char *events[MAX_PROBES];
@@ -162,6 +163,8 @@ static int parse_probepoint(const struct option *opt __used,
 		      pp->function, pp->file, pp->offset);
 	}
 	free(argv[1]);
+	if (pp->file)
+		session.need_dwarf = 1;
 
 	/* Copy arguments */
 	pp->nr_args = argc - 2;
@@ -173,15 +176,19 @@ static int parse_probepoint(const struct option *opt __used,
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
@@ -209,6 +216,7 @@ static int open_default_vmlinux(void)
 	}
 	return fd;
 }
+#endif
 
 static const char * const probe_usage[] = {
 	"perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]",
@@ -216,10 +224,16 @@ static const char * const probe_usage[] = {
 };
 
 static const struct option options[] = {
+#ifndef NO_LIBDWARF
 	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
 		"vmlinux/module pathname"),
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
@@ -279,7 +297,7 @@ error:
 
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
-	int i, j, fd, ret, need_dwarf = 0;
+	int i, j, fd, ret;
 	struct probe_point *pp;
 	char buf[MAX_CMDLEN];
 
@@ -288,12 +306,19 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
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
@@ -303,7 +328,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		}
 	}
 
-	if (!need_dwarf)
+#ifndef NO_LIBDWARF
+	if (!session.need_dwarf)
 		goto setup_probes;
 
 	if (session.vmlinux)
@@ -332,6 +358,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
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
