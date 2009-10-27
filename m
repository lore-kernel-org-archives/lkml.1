Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbZJ0Ung@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbZJ0Ung (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932252AbZJ0Unf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbZJ0Und (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:43:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 08/10] perf/probes: Change command-line
	option of perf-probe
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
Date: Tue, 27 Oct 2009 16:43:02 -0400
Message-ID: <20091027204301.30545.48600.stgit@harusame>
In-Reply-To: <20091027204156.30545.96425.stgit@harusame>
References: <20091027204156.30545.96425.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change command-line option from -P to --add, and accepting probes
without --add too.

  perf probe --add "probe-define"

or, just

  perf probe "probe-define"

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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
