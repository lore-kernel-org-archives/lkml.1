Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZLAAXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZLAAXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZLAAXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:23:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbZLAAXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:23:40 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 4/9] perf probe: Fix argv array size in probe parser
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
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 30 Nov 2009 19:19:43 -0500
Message-ID: <20091201001943.10235.80367.stgit@harusame>
In-Reply-To: <20091201001912.10235.79411.stgit@harusame>
References: <20091201001912.10235.79411.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the syntax had been changed, probe definition needs parameters
less than MAX_PROBE_ARGS + 1 (probe-point + arguments).

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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
