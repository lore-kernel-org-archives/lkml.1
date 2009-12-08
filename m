Return-Path: <linux-kernel-owner+w=401wt.eu-S966594AbZLHV7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966594AbZLHV7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966575AbZLHV7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:59:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966472AbZLHV7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:59:09 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/8] perf probe: Fix add-probe command syntax without
	--add option
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 08 Dec 2009 17:02:54 -0500
Message-ID: <20091208220254.10142.73767.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix add-probe command syntax without --add option.
perf-probe supports add-probe command without --add
option. But it treats each argument as an event definition.
e.g.

perf probe func arg1 arg2

 is interpreted as

perf probe --add func --add arg1 --add arg2

But it may be useless in many cases.

This patch fixes this syntax to fold those arguments into
one event definition if there is no --add option. With this
change, above command is interpreted as below;

perf probe --add "func arg1 arg2"

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 tools/perf/builtin-probe.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 8993a1f..1347fdf 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -79,6 +79,25 @@ static void parse_probe_event(const char *str)
 	pr_debug("%d arguments\n", pp->nr_args);
 }
 
+static void parse_probe_event_argv(int argc, const char **argv)
+{
+	int i, len;
+	char *buf;
+
+	/* Bind up rest arguments */
+	len = 0;
+	for (i = 0; i < argc; i++)
+		len += strlen(argv[i]) + 1;
+	buf = zalloc(len + 1);
+	if (!buf)
+		die("Failed to allocate memory for binding arguments.");
+	len = 0;
+	for (i = 0; i < argc; i++)
+		len += sprintf(&buf[len], "%s ", argv[i]);
+	parse_probe_event(buf);
+	free(buf);
+}
+
 static int opt_add_probe_event(const struct option *opt __used,
 			      const char *str, int unset __used)
 {
@@ -160,7 +179,7 @@ static const struct option options[] = {
 
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
-	int i, j, ret;
+	int i, ret;
 #ifndef NO_LIBDWARF
 	int fd;
 #endif
@@ -168,8 +187,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
-	for (i = 0; i < argc; i++)
-		parse_probe_event(argv[i]);
+	if (argc > 0)
+		parse_probe_event_argv(argc, argv);
 
 	if ((session.nr_probe == 0 && !listing) ||
 	    (session.nr_probe != 0 && listing))
@@ -200,8 +219,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	}
 
 	/* Searching probe points */
-	for (j = 0; j < session.nr_probe; j++) {
-		pp = &session.probes[j];
+	for (i = 0; i < session.nr_probe; i++) {
+		pp = &session.probes[i];
 		if (pp->found)
 			continue;
 
@@ -223,8 +242,8 @@ end_dwarf:
 #endif /* !NO_LIBDWARF */
 
 	/* Synthesize probes without dwarf */
-	for (j = 0; j < session.nr_probe; j++) {
-		pp = &session.probes[j];
+	for (i = 0; i < session.nr_probe; i++) {
+		pp = &session.probes[i];
 		if (pp->found)	/* This probe is already found. */
 			continue;
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
