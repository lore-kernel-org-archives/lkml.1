Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZJBVrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZJBVrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZJBVrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbZJBVrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:47:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
	variables syntax
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 02 Oct 2009 17:48:42 -0400
Message-ID: <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add $ prefix to the special variables(e.g. sa, rv) of kprobe-tracer.
This resolves consistency issue between kprobe_events and perf-kprobe.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---

 Documentation/trace/kprobetrace.txt |   10 +++---
 kernel/trace/trace_kprobe.c         |   60 ++++++++++++++++++++++-------------
 2 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 9b8f7c6..40caef0 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -36,13 +36,13 @@ Synopsis of kprobe_events
 
  FETCHARGS	: Arguments. Each probe can have up to 128 args.
   %REG	: Fetch register REG
-  sN	: Fetch Nth entry of stack (N >= 0)
-  sa	: Fetch stack address.
   @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
   @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
-  aN	: Fetch function argument. (N >= 0)(*)
-  rv	: Fetch return value.(**)
-  ra	: Fetch return address.(**)
+  $sN	: Fetch Nth entry of stack (N >= 0)
+  $sa	: Fetch stack address.
+  $aN	: Fetch function argument. (N >= 0)(*)
+  $rv	: Fetch return value.(**)
+  $ra	: Fetch return address.(**)
   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(***)
   NAME=FETCHARG: Set NAME as the argument name of FETCHARG.
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 97309d4..f63ead0 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -220,24 +220,24 @@ static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
 	int ret = -EINVAL;
 
 	if (ff->func == fetch_argument)
-		ret = snprintf(buf, n, "a%lu", (unsigned long)ff->data);
+		ret = snprintf(buf, n, "$a%lu", (unsigned long)ff->data);
 	else if (ff->func == fetch_register) {
 		const char *name;
 		name = regs_query_register_name((unsigned int)((long)ff->data));
 		ret = snprintf(buf, n, "%%%s", name);
 	} else if (ff->func == fetch_stack)
-		ret = snprintf(buf, n, "s%lu", (unsigned long)ff->data);
+		ret = snprintf(buf, n, "$s%lu", (unsigned long)ff->data);
 	else if (ff->func == fetch_memory)
 		ret = snprintf(buf, n, "@0x%p", ff->data);
 	else if (ff->func == fetch_symbol) {
 		struct symbol_cache *sc = ff->data;
 		ret = snprintf(buf, n, "@%s%+ld", sc->symbol, sc->offset);
 	} else if (ff->func == fetch_retvalue)
-		ret = snprintf(buf, n, "rv");
+		ret = snprintf(buf, n, "$rv");
 	else if (ff->func == fetch_ip)
-		ret = snprintf(buf, n, "ra");
+		ret = snprintf(buf, n, "$ra");
 	else if (ff->func == fetch_stack_address)
-		ret = snprintf(buf, n, "sa");
+		ret = snprintf(buf, n, "$sa");
 	else if (ff->func == fetch_indirect) {
 		struct indirect_fetch_data *id = ff->data;
 		size_t l = 0;
@@ -429,12 +429,10 @@ static int split_symbol_offset(char *symbol, unsigned long *offset)
 #define PARAM_MAX_ARGS 16
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
-static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
+static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
 {
 	int ret = 0;
 	unsigned long param;
-	long offset;
-	char *tmp;
 
 	switch (arg[0]) {
 	case 'a':	/* argument */
@@ -456,14 +454,6 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 		} else
 			ret = -EINVAL;
 		break;
-	case '%':	/* named register */
-		ret = regs_query_register_offset(arg + 1);
-		if (ret >= 0) {
-			ff->func = fetch_register;
-			ff->data = (void *)(unsigned long)ret;
-			ret = 0;
-		}
-		break;
 	case 's':	/* stack */
 		if (arg[1] == 'a') {
 			ff->func = fetch_stack_address;
@@ -478,6 +468,31 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 			}
 		}
 		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
+{
+	int ret = 0;
+	unsigned long param;
+	long offset;
+	char *tmp;
+
+	switch (arg[0]) {
+	case '$':
+		ret = parse_probe_vars(arg + 1, ff, is_return);
+		break;
+	case '%':	/* named register */
+		ret = regs_query_register_offset(arg + 1);
+		if (ret >= 0) {
+			ff->func = fetch_register;
+			ff->data = (void *)(unsigned long)ret;
+			ret = 0;
+		}
+		break;
 	case '@':	/* memory or symbol */
 		if (isdigit(arg[1])) {
 			ret = strict_strtoul(arg + 1, 0, &param);
@@ -489,8 +504,7 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 			ret = split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
-			ff->data = alloc_symbol_cache(arg + 1,
-							      offset);
+			ff->data = alloc_symbol_cache(arg + 1, offset);
 			if (ff->data)
 				ff->func = fetch_symbol;
 			else
@@ -544,11 +558,11 @@ static int create_trace_probe(int argc, char **argv)
 	 *  - Add kprobe: p[:[GRP/]EVENT] KSYM[+OFFS]|KADDR [FETCHARGS]
 	 *  - Add kretprobe: r[:[GRP/]EVENT] KSYM[+0] [FETCHARGS]
 	 * Fetch args:
-	 *  aN	: fetch Nth of function argument. (N:0-)
-	 *  rv	: fetch return value
-	 *  ra	: fetch return address
-	 *  sa	: fetch stack address
-	 *  sN	: fetch Nth of stack (N:0-)
+	 *  $aN	: fetch Nth of function argument. (N:0-)
+	 *  $rv	: fetch return value
+	 *  $ra	: fetch return address
+	 *  $sa	: fetch stack address
+	 *  $sN	: fetch Nth of stack (N:0-)
 	 *  @ADDR	: fetch memory at ADDR (ADDR should be in kernel)
 	 *  @SYM[+|-offs] : fetch memory at SYM +|- offs (SYM is a data symbol)
 	 *  %REG	: fetch register REG


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
