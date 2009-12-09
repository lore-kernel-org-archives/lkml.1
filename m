Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbZLIH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbZLIH1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZLIH1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:27:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:45774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbZLIH1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:27:42 -0500
Date: Wed, 9 Dec 2009 07:26:01 GMT
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
In-Reply-To: <20091208220316.10142.39192.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220316.10142.39192.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] trace-kprobe: Support delete probe syntax
Message-ID: <tip-a7c312bed772c11138409c3a98531e85d690302e@git.kernel.org>
Git-Commit-ID: a7c312bed772c11138409c3a98531e85d690302e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7c312bed772c11138409c3a98531e85d690302e
Gitweb:     http://git.kernel.org/tip/a7c312bed772c11138409c3a98531e85d690302e
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Dec 2009 17:03:16 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 07:26:53 +0100

trace-kprobe: Support delete probe syntax

Support delete probe syntax. The syntax is "-:[group/]event".

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
LKML-Reference: <20091208220316.10142.39192.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 kernel/trace/trace_kprobe.c |   37 ++++++++++++++++++++++++++++---------
 1 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index aff5f80..bf05fb4 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -606,23 +606,22 @@ static int create_trace_probe(int argc, char **argv)
 	 */
 	struct trace_probe *tp;
 	int i, ret = 0;
-	int is_return = 0;
+	int is_return = 0, is_delete = 0;
 	char *symbol = NULL, *event = NULL, *arg = NULL, *group = NULL;
 	unsigned long offset = 0;
 	void *addr = NULL;
 	char buf[MAX_EVENT_NAME_LEN];
 
-	if (argc < 2) {
-		pr_info("Probe point is not specified.\n");
-		return -EINVAL;
-	}
-
+	/* argc must be >= 1 */
 	if (argv[0][0] == 'p')
 		is_return = 0;
 	else if (argv[0][0] == 'r')
 		is_return = 1;
+	else if (argv[0][0] == '-')
+		is_delete = 1;
 	else {
-		pr_info("Probe definition must be started with 'p' or 'r'.\n");
+		pr_info("Probe definition must be started with 'p', 'r' or"
+			" '-'.\n");
 		return -EINVAL;
 	}
 
@@ -642,7 +641,29 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 	}
+	if (!group)
+		group = KPROBE_EVENT_SYSTEM;
 
+	if (is_delete) {
+		if (!event) {
+			pr_info("Delete command needs an event name.\n");
+			return -EINVAL;
+		}
+		tp = find_probe_event(event, group);
+		if (!tp) {
+			pr_info("Event %s/%s doesn't exist.\n", group, event);
+			return -ENOENT;
+		}
+		/* delete an event */
+		unregister_trace_probe(tp);
+		free_trace_probe(tp);
+		return 0;
+	}
+
+	if (argc < 2) {
+		pr_info("Probe point is not specified.\n");
+		return -EINVAL;
+	}
 	if (isdigit(argv[1][0])) {
 		if (is_return) {
 			pr_info("Return probe point must be a symbol.\n");
@@ -671,8 +692,6 @@ static int create_trace_probe(int argc, char **argv)
 	argc -= 2; argv += 2;
 
 	/* setup a probe */
-	if (!group)
-		group = KPROBE_EVENT_SYSTEM;
 	if (!event) {
 		/* Make a new event name */
 		if (symbol)
