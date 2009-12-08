Return-Path: <linux-kernel-owner+w=401wt.eu-S966605AbZLHV7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966605AbZLHV7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966575AbZLHV70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:59:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966593AbZLHV7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:59:19 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 6/8] trace-kprobe: Support delete probe syntax
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
Date: Tue, 08 Dec 2009 17:03:16 -0500
Message-ID: <20091208220316.10142.39192.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support delete probe syntax. The syntax is "-:[group/]event".

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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
