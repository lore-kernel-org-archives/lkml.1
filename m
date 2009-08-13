Return-Path: <linux-kernel-owner+w=401wt.eu-S932554AbZHMUed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbZHMUed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbZHMUe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:34:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33164 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212AbZHMUda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:33:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v14 09/12] tracing: Kprobe-tracer supports more than 6
	arguments
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 13 Aug 2009 16:35:18 -0400
Message-ID: <20090813203518.31965.96979.stgit@localhost.localdomain>
In-Reply-To: <20090813203403.31965.20973.stgit@localhost.localdomain>
References: <20090813203403.31965.20973.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support up to 128 arguments for each kprobes event.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
---

 Documentation/trace/kprobetrace.txt |    2 +-
 kernel/trace/trace_kprobe.c         |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index efff6eb..c9c09b4 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -32,7 +32,7 @@ Synopsis of kprobe_events
  SYMBOL[+offs|-offs]	: Symbol+offset where the probe is inserted.
  MEMADDR		: Address where the probe is inserted.
 
- FETCHARGS		: Arguments.
+ FETCHARGS		: Arguments. Each probe can have up to 128 args.
   %REG	: Fetch register REG
   sN	: Fetch Nth entry of stack (N >= 0)
   sa	: Fetch stack address.
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d92877a..4704e40 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -32,7 +32,7 @@
 #include "trace.h"
 #include "trace_output.h"
 
-#define TRACE_KPROBE_ARGS 6
+#define MAX_TRACE_ARGS 128
 #define MAX_ARGSTR_LEN 63
 
 /* currently, trace_kprobe only supports X86. */
@@ -184,11 +184,15 @@ struct trace_probe {
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
@@ -263,11 +267,11 @@ static DEFINE_MUTEX(probe_lock);
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
 
@@ -573,9 +577,10 @@ static int create_trace_probe(int argc, char **argv)
 		if (offset && is_return)
 			return -EINVAL;
 	}
+	argc -= 2; argv += 2;
 
 	/* setup a probe */
-	tp = alloc_trace_probe(symbol, event);
+	tp = alloc_trace_probe(symbol, event, argc);
 	if (IS_ERR(tp))
 		return PTR_ERR(tp);
 
@@ -594,8 +599,8 @@ static int create_trace_probe(int argc, char **argv)
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
