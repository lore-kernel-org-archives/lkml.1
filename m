Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZGXUDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZGXUDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZGXUDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:03:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55334 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbZGXUDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:03:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip -v13 09/11] tracing: Kprobe-tracer supports more than 6
	arguments
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Date: Fri, 24 Jul 2009 16:06:22 -0400
Message-ID: <20090724200621.25904.36836.stgit@localhost.localdomain>
In-Reply-To: <20090724200527.25904.2562.stgit@localhost.localdomain>
References: <20090724200527.25904.2562.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support up to 128 arguments for each kprobes event.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---

 Documentation/trace/kprobetrace.txt |    2 +-
 kernel/trace/trace_kprobe.c         |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 9ad907c..b29a54b 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -32,7 +32,7 @@ Synopsis of kprobe_events
  SYMBOL[+offs|-offs]	: Symbol+offset where the probe is inserted.
  MEMADDR		: Address where the probe is inserted.
 
- FETCHARGS		: Arguments.
+ FETCHARGS		: Arguments. Each probe can have up to 128 args.
   %REG	: Fetch register REG
   sN	: Fetch Nth entry of stack (N >= 0)
   @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 39491f0..e78c4ea 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -32,7 +32,7 @@
 #include "trace.h"
 #include "trace_output.h"
 
-#define TRACE_KPROBE_ARGS 6
+#define MAX_TRACE_ARGS 128
 #define MAX_ARGSTR_LEN 63
 
 /* currently, trace_kprobe only supports X86. */
@@ -178,11 +178,15 @@ struct trace_probe {
 		struct kretprobe	rp;
 	};
 	const char		*symbol;	/* symbol name */
-	unsigned int		nr_args;
-	struct fetch_func	args[TRACE_KPROBE_ARGS];
 	struct ftrace_event_call	call;
+	unsigned int		nr_args;
+	struct fetch_func	args[];
 };
 
+#define SIZEOF_TRACE_PROBE(n)			\
+	(offsetof(struct trace_probe, args) +	\
+	(sizeof(struct fetch_func) * (n)))
+
 static int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_trace_func(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
@@ -255,11 +259,11 @@ static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
 
 static struct trace_probe *alloc_trace_probe(const char *symbol,
-					     const char *event)
+					     const char *event, int nargs)
 {
 	struct trace_probe *tp;
 
-	tp = kzalloc(sizeof(struct trace_probe), GFP_KERNEL);
+	tp = kzalloc(SIZEOF_TRACE_PROBE(nargs), GFP_KERNEL);
 	if (!tp)
 		return ERR_PTR(-ENOMEM);
 
@@ -559,9 +563,10 @@ static int create_trace_probe(int argc, char **argv)
 		if (offset && is_return)
 			return -EINVAL;
 	}
+	argc -= 2; argv += 2;
 
 	/* setup a probe */
-	tp = alloc_trace_probe(symbol, event);
+	tp = alloc_trace_probe(symbol, event, argc);
 	if (IS_ERR(tp))
 		return PTR_ERR(tp);
 
@@ -580,8 +585,8 @@ static int create_trace_probe(int argc, char **argv)
 		kp->addr = addr;
 
 	/* parse arguments */
-	argc -= 2; argv += 2; ret = 0;
-	for (i = 0; i < argc && i < TRACE_KPROBE_ARGS; i++) {
+	ret = 0;
+	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
 		if (strlen(argv[i]) > MAX_ARGSTR_LEN) {
 			pr_info("Argument%d(%s) is too long.\n", i, argv[i]);
 			ret = -ENOSPC;


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
