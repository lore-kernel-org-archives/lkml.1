Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZIJXwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZIJXwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZIJXwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZIJXw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:52:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 6/7] tracing/kprobes: Show event name in trace
	output
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
Date: Thu, 10 Sep 2009 19:53:45 -0400
Message-ID: <20090910235345.22412.76527.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show event name in tracing/trace output. This also fixes kprobes events format
as same as other tracepoint events.

Before patching:
<...>-1447  [001] 1038282.286875: do_sys_open+0x0/0xd6: ...
<...>-1447  [001] 1038282.286878: sys_openat+0xc/0xe <- do_sys_open: ...

After patching:
<...>-1447  [001] 1038282.286875: myprobe: (do_sys_open+0x0/0xd6) ...
<...>-1447  [001] 1038282.286878: myretprobe: (sys_openat+0xc/0xe <- do_sys_open) ...


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

 Documentation/trace/kprobetrace.txt |   16 ++++++++--------
 kernel/trace/trace_kprobe.c         |   16 +++++++++++-----
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 55a8034..ed152a1 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -114,7 +114,7 @@ format:
 	field: unsigned long flags;	offset:48;tsize:8;
 	field: unsigned long mode;	offset:56;tsize:8;
 
-print fmt: "%lx: dfd=%lx filename=%lx flags=%lx mode=%lx", ip, REC->dfd, REC->filename, REC->flags, REC->mode
+print fmt: "(%lx) dfd=%lx filename=%lx flags=%lx mode=%lx", REC->ip, REC->dfd, REC->filename, REC->flags, REC->mode
 
 
  You can see that the event has 4 arguments as expressions you specified.
@@ -129,15 +129,15 @@ print fmt: "%lx: dfd=%lx filename=%lx flags=%lx mode=%lx", ip, REC->dfd, REC->fi
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
-           <...>-1447  [001] 1038282.286875: do_sys_open+0x0/0xd6: dfd=3 filename=7fffd1ec4440 flags=8000 mode=0
-           <...>-1447  [001] 1038282.286878: sys_openat+0xc/0xe <- do_sys_open: rv=fffffffffffffffe ra=ffffffff81367a3a
-           <...>-1447  [001] 1038282.286885: do_sys_open+0x0/0xd6: dfd=ffffff9c filename=40413c flags=8000 mode=1b6
-           <...>-1447  [001] 1038282.286915: sys_open+0x1b/0x1d <- do_sys_open: rv=3 ra=ffffffff81367a3a
-           <...>-1447  [001] 1038282.286969: do_sys_open+0x0/0xd6: dfd=ffffff9c filename=4041c6 flags=98800 mode=10
-           <...>-1447  [001] 1038282.286976: sys_open+0x1b/0x1d <- do_sys_open: rv=3 ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286875: myprobe: (do_sys_open+0x0/0xd6) dfd=3 filename=7fffd1ec4440 flags=8000 mode=0
+           <...>-1447  [001] 1038282.286878: myretprobe: (sys_openat+0xc/0xe <- do_sys_open) rv=fffffffffffffffe ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286885: myprobe: (do_sys_open+0x0/0xd6) dfd=ffffff9c filename=40413c flags=8000 mode=1b6
+           <...>-1447  [001] 1038282.286915: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) rv=3 ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286969: myprobe: (do_sys_open+0x0/0xd6) dfd=ffffff9c filename=4041c6 flags=98800 mode=10
+           <...>-1447  [001] 1038282.286976: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) rv=3 ra=ffffffff81367a3a
 
 
- Each line shows when the kernel hits a probe, and <- SYMBOL means kernel
+ Each line shows when the kernel hits an event, and <- SYMBOL means kernel
 returns from SYMBOL(e.g. "sys_open+0x1b/0x1d <- do_sys_open" means kernel
 returns from do_sys_open to sys_open+0x1b).
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 6b88acd..486c229 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -900,10 +900,13 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
 	event = ftrace_find_event(field->ent.type);
 	tp = container_of(event, struct trace_probe, event);
 
+	if (!trace_seq_printf(s, "%s: (", tp->call.name))
+		goto partial;
+
 	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
 		goto partial;
 
-	if (!trace_seq_puts(s, ":"))
+	if (!trace_seq_puts(s, ")"))
 		goto partial;
 
 	for (i = 0; i < field->nargs; i++)
@@ -932,6 +935,9 @@ print_kretprobe_event(struct trace_iterator *iter, int flags)
 	event = ftrace_find_event(field->ent.type);
 	tp = container_of(event, struct trace_probe, event);
 
+	if (!trace_seq_printf(s, "%s: (", tp->call.name))
+		goto partial;
+
 	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
 		goto partial;
 
@@ -941,7 +947,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags)
 	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
 		goto partial;
 
-	if (!trace_seq_puts(s, ":"))
+	if (!trace_seq_puts(s, ")"))
 		goto partial;
 
 	for (i = 0; i < field->nargs; i++)
@@ -1085,7 +1091,7 @@ static int kprobe_event_show_format(struct ftrace_event_call *call,
 		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
 	trace_seq_puts(s, "\n");
 
-	return __probe_event_show_format(s, tp, "%lx:", "ip");
+	return __probe_event_show_format(s, tp, "(%lx)", "REC->ip");
 }
 
 static int kretprobe_event_show_format(struct ftrace_event_call *call,
@@ -1104,8 +1110,8 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
 	trace_seq_puts(s, "\n");
 
-	return __probe_event_show_format(s, tp, "%lx <- %lx:",
-					  "func, ret_ip");
+	return __probe_event_show_format(s, tp, "(%lx <- %lx)",
+					  "REC->func, REC->ret_ip");
 }
 
 #ifdef CONFIG_EVENT_PROFILE


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
