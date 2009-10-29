Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZJ2IJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZJ2IJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZJ2IJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:09:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:53064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbZJ2IJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:09:49 -0400
Date: Thu, 29 Oct 2009 08:08:53 GMT
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
In-Reply-To: <20091027204301.30545.48600.stgit@harusame>
References: <20091027204301.30545.48600.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf/probes: Improve command-line option of perf-probe
Message-ID: <tip-46ab49267d338eb5056d0077e16346509b9e9284@git.kernel.org>
Git-Commit-ID: 46ab49267d338eb5056d0077e16346509b9e9284
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46ab49267d338eb5056d0077e16346509b9e9284
Gitweb:     http://git.kernel.org/tip/46ab49267d338eb5056d0077e16346509b9e9284
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Oct 2009 16:43:02 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:47:48 +0100

perf/probes: Improve command-line option of perf-probe

Change command-line option from -P to --add, and accepting
probes without --add too.

  perf probe --add "probe-define"

or, just:

  perf probe "probe-define"

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
LKML-Reference: <20091027204301.30545.48600.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index dcb406c..3370dab 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -65,8 +65,8 @@ static struct {
 
 #define semantic_error(msg ...) die("Semantic error :" msg)
 
-static int parse_probepoint(const struct option *opt __used,
-			    const char *str, int unset __used)
+/* Parse a probe point. Note that any error must die. */
+static void parse_probepoint(const char *str)
 {
 	char *argv[MAX_PROBE_ARGS + 2];	/* Event + probe + args */
 	int argc, i;
@@ -75,9 +75,6 @@ static int parse_probepoint(const struct option *opt __used,
 	char **event = &session.events[session.nr_probe];
 	int retp = 0;
 
-	if (!str)	/* The end of probe points */
-		return 0;
-
 	pr_debug("probe-definition(%d): %s\n", session.nr_probe, str);
 	if (++session.nr_probe == MAX_PROBES)
 		semantic_error("Too many probes");
@@ -176,6 +173,13 @@ static int parse_probepoint(const struct option *opt __used,
 		}
 
 	pr_debug("%d arguments\n", pp->nr_args);
+}
+
+static int opt_add_probepoint(const struct option *opt __used,
+			      const char *str, int unset __used)
+{
+	if (str)
+		parse_probepoint(str);
 	return 0;
 }
 
@@ -211,7 +215,8 @@ static int open_default_vmlinux(void)
 #endif
 
 static const char * const probe_usage[] = {
-	"perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]",
+	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
+	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 	NULL
 };
 
@@ -222,7 +227,7 @@ static const struct option options[] = {
 	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
 		"vmlinux/module pathname"),
 #endif
-	OPT_CALLBACK('P', "probe", NULL,
+	OPT_CALLBACK('a', "add", NULL,
 #ifdef NO_LIBDWARF
 		"p|r:[GRP/]NAME FUNC[+OFFS] [ARG ...]",
 #else
@@ -243,7 +248,7 @@ static const struct option options[] = {
 		"\t\tARG:\tProbe argument (local variable name or\n"
 #endif
 		"\t\t\tkprobe-tracer argument format is supported.)\n",
-		parse_probepoint),
+		opt_add_probepoint),
 	OPT_END()
 };
 
@@ -296,8 +301,11 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	char buf[MAX_CMDLEN];
 
 	argc = parse_options(argc, argv, options, probe_usage,
-		PARSE_OPT_STOP_AT_NON_OPTION);
-	if (argc || session.nr_probe == 0)
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	for (i = 0; i < argc; i++)
+		parse_probe_event(argv[i]);
+
+	if (session.nr_probe == 0)
 		usage_with_options(probe_usage, options);
 
 #ifdef NO_LIBDWARF
