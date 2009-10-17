Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZJQKET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZJQKET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZJQKES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:04:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:36781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbZJQKEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:04:16 -0400
Date: Sat, 17 Oct 2009 10:03:10 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, fche@redhat.com, paulus@samba.org,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       fche@redhat.com, linux-kernel@vger.kernel.org, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091007222740.1684.91170.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091007222740.1684.91170.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Add $ prefix to special variables
Message-ID: <tip-405b2651e4bedf8d3932b64cad649b4d26b067f5@git.kernel.org>
Git-Commit-ID: 405b2651e4bedf8d3932b64cad649b4d26b067f5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:03:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  405b2651e4bedf8d3932b64cad649b4d26b067f5
Gitweb:     http://git.kernel.org/tip/405b2651e4bedf8d3932b64cad649b4d26b067f5
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 7 Oct 2009 18:27:40 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 12 Oct 2009 19:21:35 +0200

tracing/kprobes: Add $ prefix to special variables

Add $ prefix to the special variables(e.g. sa, rv) of kprobe-tracer.
This resolves consistency issues between kprobe_events and perf-kprobe.

The main goal is to avoid conflicts between local variable names of
probed functions, used by perf probe, and special variables used
in the kprobe event creation interface (stack values, etc...) and
also available from perf probe.

ie: we don't want rv (return value) to conflict with a local variable
named rv in a probed function.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
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
LKML-Reference: <20091007222740.1684.91170.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |   20 ++++++------
 kernel/trace/trace_kprobe.c         |   60 +++++++++++++++++++++-------------
 2 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 9b8f7c6..33f5318 100644
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
 
@@ -85,13 +85,13 @@ Usage examples
 To add a probe as a new event, write a new definition to kprobe_events
 as below.
 
-  echo p:myprobe do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 > /sys/kernel/debug/tracing/kprobe_events
+  echo p:myprobe do_sys_open dfd=$a0 filename=$a1 flags=$a2 mode=$a3 > /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kprobe on the top of do_sys_open() function with recording
 1st to 4th arguments as "myprobe" event. As this example shows, users can
 choose more familiar names for each arguments.
 
-  echo r:myretprobe do_sys_open rv ra >> /sys/kernel/debug/tracing/kprobe_events
+  echo r:myretprobe do_sys_open $rv $ra >> /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kretprobe on the return point of do_sys_open() function with
 recording return value and return address as "myretprobe" event.
@@ -138,11 +138,11 @@ events, you need to enable it.
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
            <...>-1447  [001] 1038282.286875: myprobe: (do_sys_open+0x0/0xd6) dfd=3 filename=7fffd1ec4440 flags=8000 mode=0
-           <...>-1447  [001] 1038282.286878: myretprobe: (sys_openat+0xc/0xe <- do_sys_open) rv=fffffffffffffffe ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286878: myretprobe: (sys_openat+0xc/0xe <- do_sys_open) $rv=fffffffffffffffe $ra=ffffffff81367a3a
            <...>-1447  [001] 1038282.286885: myprobe: (do_sys_open+0x0/0xd6) dfd=ffffff9c filename=40413c flags=8000 mode=1b6
-           <...>-1447  [001] 1038282.286915: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) rv=3 ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286915: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $rv=3 $ra=ffffffff81367a3a
            <...>-1447  [001] 1038282.286969: myprobe: (do_sys_open+0x0/0xd6) dfd=ffffff9c filename=4041c6 flags=98800 mode=10
-           <...>-1447  [001] 1038282.286976: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) rv=3 ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286976: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $rv=3 $ra=ffffffff81367a3a
 
 
  Each line shows when the kernel hits an event, and <- SYMBOL means kernel
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
