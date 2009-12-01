Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZLAHeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZLAHeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZLAHeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:34:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:37409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbZLAHeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:34:19 -0500
Date: Tue, 1 Dec 2009 07:32:02 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091201001943.10235.80367.stgit@harusame>
References: <20091201001943.10235.80367.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix argv array size in probe parser
Message-ID: <tip-74ca4c0ece52a2d19dae1bcbfc24fcfc5facfeb4@git.kernel.org>
Git-Commit-ID: 74ca4c0ece52a2d19dae1bcbfc24fcfc5facfeb4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74ca4c0ece52a2d19dae1bcbfc24fcfc5facfeb4
Gitweb:     http://git.kernel.org/tip/74ca4c0ece52a2d19dae1bcbfc24fcfc5facfeb4
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 30 Nov 2009 19:19:43 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 08:20:01 +0100

perf probe: Fix argv array size in probe parser

Since the syntax has been changed, probe definition needs
parameters less than MAX_PROBE_ARGS + 1 (probe-point +
arguments).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091201001943.10235.80367.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 4e418af..510fdd4 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -151,7 +151,7 @@ static void parse_probe_point(char *arg, struct probe_point *pp)
 /* Parse an event definition. Note that any error must die. */
 static void parse_probe_event(const char *str)
 {
-	char *argv[MAX_PROBE_ARGS + 2];	/* Event + probe + args */
+	char *argv[MAX_PROBE_ARGS + 1];	/* probe + args */
 	int argc, i;
 	struct probe_point *pp = &session.probes[session.nr_probe];
 
@@ -169,6 +169,9 @@ static void parse_probe_event(const char *str)
 		/* Add an argument */
 		if (*str != '\0') {
 			const char *s = str;
+			/* Check the limit number of arguments */
+			if (argc == MAX_PROBE_ARGS + 1)
+				semantic_error("Too many arguments");
 
 			/* Skip the argument */
 			while (!isspace(*str) && *str != '\0')
@@ -178,9 +181,9 @@ static void parse_probe_event(const char *str)
 			argv[argc] = strndup(s, str - s);
 			if (argv[argc] == NULL)
 				die("strndup");
-			if (++argc == MAX_PROBE_ARGS)
-				semantic_error("Too many arguments");
-			pr_debug("argv[%d]=%s\n", argc, argv[argc - 1]);
+			pr_debug("argv[%d]=%s\n", argc, argv[argc]);
+			argc++;
+
 		}
 	} while (*str != '\0');
 	if (!argc)
