Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbZINUsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbZINUsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933670AbZINUsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933651AbZINUsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:48:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 6/6] tracing/kprobes: Disable kprobe events by
	default
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
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
Date: Mon, 14 Sep 2009 16:49:37 -0400
Message-ID: <20090914204937.18779.59422.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable newly created kprobe events by default, not to disturb
another user using ftrace. "Disturb" means when someone using
ftrace and another user tries to use perf-tools, (in near
future) if he defines new kprobe event via perf-tools, then new
events will mess up the frace buffer. I think that's ugly.


Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
c: Jim Keniston <jkenisto@us.ibm.com>
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

 Documentation/trace/kprobetrace.txt |   11 +++++++++--
 kernel/trace/trace_kprobe.c         |    4 ++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 6521681..9b8f7c6 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -122,8 +122,15 @@ print fmt: "(%lx) dfd=%lx filename=%lx flags=%lx mode=%lx", REC->ip, REC->dfd, R
 
   echo > /sys/kernel/debug/tracing/kprobe_events
 
- This clears all probe points. and you can see the traced information via
-/sys/kernel/debug/tracing/trace.
+ This clears all probe points.
+
+ Right after definition, each event is disabled by default. For tracing these
+events, you need to enable it.
+
+  echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe/enable
+  echo 1 > /sys/kernel/debug/tracing/events/kprobes/myretprobe/enable
+
+ And you can see the traced information via /sys/kernel/debug/tracing/trace.
 
   cat /sys/kernel/debug/tracing/trace
 # tracer: nop
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d8db935..f6821f1 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -383,7 +383,7 @@ static int register_trace_probe(struct trace_probe *tp)
 		goto end;
 	}
 
-	tp->flags = TP_FLAG_TRACE;
+	tp->rp.kp.flags |= KPROBE_FLAG_DISABLED;
 	if (probe_is_return(tp))
 		ret = register_kretprobe(&tp->rp);
 	else
@@ -1298,7 +1298,7 @@ static int register_probe_event(struct trace_probe *tp)
 	call->id = register_ftrace_event(&tp->event);
 	if (!call->id)
 		return -ENODEV;
-	call->enabled = 1;
+	call->enabled = 0;
 	call->regfunc = probe_event_enable;
 	call->unregfunc = probe_event_disable;
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
