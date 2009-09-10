Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZIJXwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZIJXwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZIJXwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:52:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZIJXwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:52:31 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 7/7] tracing/kprobes: Support custom subsystem
	for each kprobe event
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>
Date: Thu, 10 Sep 2009 19:53:53 -0400
Message-ID: <20090910235353.22412.15149.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support specifying a custom subsystem(group) for each kprobe event.
This allows users to create new group for controlling several probes
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
---

 Documentation/trace/kprobetrace.txt |    5 +++--
 kernel/trace/trace_kprobe.c         |   33 +++++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index ed152a1..af9ae49 100644
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
index 486c229..cb3627b 100644
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
 
@@ -1215,7 +1237,6 @@ static int register_probe_event(struct trace_probe *tp)
 	int ret;
 
 	/* Initialize ftrace_event_call */
-	call->system = "kprobes";
 	if (probe_is_return(tp)) {
 		tp->event.trace = print_kretprobe_event;
 		call->raw_init = probe_event_raw_init;


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
