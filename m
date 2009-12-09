Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbZLIH26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbZLIH26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbZLIH24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:28:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:45834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbZLIH2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:28:55 -0500
Date: Wed, 9 Dec 2009 07:25:18 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091208220254.10142.73767.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220254.10142.73767.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix add-probe command syntax without --add option
Message-ID: <tip-d1bde3f755e8652faad59e264c466c4baab68fa8@git.kernel.org>
Git-Commit-ID: d1bde3f755e8652faad59e264c466c4baab68fa8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1bde3f755e8652faad59e264c466c4baab68fa8
Gitweb:     http://git.kernel.org/tip/d1bde3f755e8652faad59e264c466c4baab68fa8
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Dec 2009 17:02:54 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 07:26:51 +0100

perf probe: Fix add-probe command syntax without --add option

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
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091208220254.10142.73767.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
