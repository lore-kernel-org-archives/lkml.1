Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZJQKB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZJQKB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZJQKBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:01:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:36396 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbZJQKBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:01:19 -0400
Date: Sat, 17 Oct 2009 10:00:31 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <20090910235353.22412.15149.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235353.22412.15149.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Support custom subsystem for each kprobe event
Message-ID: <tip-f52487e9c0041842eeb77c6c48774414b1cede08@git.kernel.org>
Git-Commit-ID: f52487e9c0041842eeb77c6c48774414b1cede08
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:00:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f52487e9c0041842eeb77c6c48774414b1cede08
Gitweb:     http://git.kernel.org/tip/f52487e9c0041842eeb77c6c48774414b1cede08
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 10 Sep 2009 19:53:53 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 17 Sep 2009 04:03:24 +0200

tracing/kprobes: Support custom subsystem for each kprobe event

Support specifying a custom subsystem(group) for each kprobe event.
This allows users to create new group to control several probes
at once, or add events to existing groups as additional tracepoints.

New synopsis:
 p[:[subsys/]event-name] KADDR|KSYM[+offs] [ARGS]

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090910235353.22412.15149.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |    5 +++--
 kernel/trace/trace_kprobe.c         |   33 +++++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index a849889..6521681 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -25,9 +25,10 @@ probe events via /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.
 
 Synopsis of kprobe_events
 -------------------------
-  p[:EVENT] SYMBOL[+offs]|MEMADDR [FETCHARGS]	: Set a probe
-  r[:EVENT] SYMBOL[+0] [FETCHARGS]		: Set a return probe
+  p[:[GRP/]EVENT] SYMBOL[+offs]|MEMADDR [FETCHARGS]	: Set a probe
+  r[:[GRP/]EVENT] SYMBOL[+0] [FETCHARGS]		: Set a return probe
 
+ GRP		: Group name. If omitted, use "kprobes" for it.
  EVENT		: Event name. If omitted, the event name is generated
 		  based on SYMBOL+offs or MEMADDR.
  SYMBOL[+offs]	: Symbol+offset where the probe is inserted.
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1746afe..cbc0870 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -36,6 +36,7 @@
 #define MAX_TRACE_ARGS 128
 #define MAX_ARGSTR_LEN 63
 #define MAX_EVENT_NAME_LEN 64
+#define KPROBE_EVENT_SYSTEM "kprobes"
 
 /* currently, trace_kprobe only supports X86. */
 
@@ -265,7 +266,8 @@ static LIST_HEAD(probe_list);
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
-static struct trace_probe *alloc_trace_probe(const char *event,
+static struct trace_probe *alloc_trace_probe(const char *group,
+					     const char *event,
 					     void *addr,
 					     const char *symbol,
 					     unsigned long offs,
@@ -298,9 +300,16 @@ static struct trace_probe *alloc_trace_probe(const char *event,
 	if (!tp->call.name)
 		goto error;
 
+	if (!group)
+		goto error;
+	tp->call.system = kstrdup(group, GFP_KERNEL);
+	if (!tp->call.system)
+		goto error;
+
 	INIT_LIST_HEAD(&tp->list);
 	return tp;
 error:
+	kfree(tp->call.name);
 	kfree(tp->symbol);
 	kfree(tp);
 	return ERR_PTR(-ENOMEM);
@@ -322,6 +331,7 @@ static void free_trace_probe(struct trace_probe *tp)
 	for (i = 0; i < tp->nr_args; i++)
 		free_probe_arg(&tp->args[i]);
 
+	kfree(tp->call.system);
 	kfree(tp->call.name);
 	kfree(tp->symbol);
 	kfree(tp);
@@ -530,8 +540,8 @@ static int create_trace_probe(int argc, char **argv)
 {
 	/*
 	 * Argument syntax:
-	 *  - Add kprobe: p[:EVENT] SYMBOL[+OFFS]|ADDRESS [FETCHARGS]
-	 *  - Add kretprobe: r[:EVENT] SYMBOL[+0] [FETCHARGS]
+	 *  - Add kprobe: p[:[GRP/]EVENT] KSYM[+OFFS]|KADDR [FETCHARGS]
+	 *  - Add kretprobe: r[:[GRP/]EVENT] KSYM[+0] [FETCHARGS]
 	 * Fetch args:
 	 *  aN	: fetch Nth of function argument. (N:0-)
 	 *  rv	: fetch return value
@@ -549,7 +559,7 @@ static int create_trace_probe(int argc, char **argv)
 	struct trace_probe *tp;
 	int i, ret = 0;
 	int is_return = 0;
-	char *symbol = NULL, *event = NULL, *arg = NULL;
+	char *symbol = NULL, *event = NULL, *arg = NULL, *group = NULL;
 	unsigned long offset = 0;
 	void *addr = NULL;
 	char buf[MAX_EVENT_NAME_LEN];
@@ -566,6 +576,15 @@ static int create_trace_probe(int argc, char **argv)
 
 	if (argv[0][1] == ':') {
 		event = &argv[0][2];
+		if (strchr(event, '/')) {
+			group = event;
+			event = strchr(group, '/') + 1;
+			event[-1] = '\0';
+			if (strlen(group) == 0) {
+				pr_info("Group name is not specifiled\n");
+				return -EINVAL;
+			}
+		}
 		if (strlen(event) == 0) {
 			pr_info("Event name is not specifiled\n");
 			return -EINVAL;
@@ -592,6 +611,8 @@ static int create_trace_probe(int argc, char **argv)
 	argc -= 2; argv += 2;
 
 	/* setup a probe */
+	if (!group)
+		group = KPROBE_EVENT_SYSTEM;
 	if (!event) {
 		/* Make a new event name */
 		if (symbol)
@@ -602,7 +623,8 @@ static int create_trace_probe(int argc, char **argv)
 				 is_return ? 'r' : 'p', addr);
 		event = buf;
 	}
-	tp = alloc_trace_probe(event, addr, symbol, offset, argc, is_return);
+	tp = alloc_trace_probe(group, event, addr, symbol, offset, argc,
+			       is_return);
 	if (IS_ERR(tp))
 		return PTR_ERR(tp);
 
@@ -1217,7 +1239,6 @@ static int register_probe_event(struct trace_probe *tp)
 	int ret;
 
 	/* Initialize ftrace_event_call */
-	call->system = "kprobes";
 	if (probe_is_return(tp)) {
 		tp->event.trace = print_kretprobe_event;
 		call->raw_init = probe_event_raw_init;
