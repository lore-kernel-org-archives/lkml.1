Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZJQKC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZJQKC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZJQKCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:02:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:36528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZJQKCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:02:54 -0400
Date: Sat, 17 Oct 2009 10:01:55 GMT
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
In-Reply-To: <20090914204937.18779.59422.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204937.18779.59422.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Disable kprobe events by default after creation
Message-ID: <tip-5a0d9050db4d1147722b42afef9011251b2651ee@git.kernel.org>
Git-Commit-ID: 5a0d9050db4d1147722b42afef9011251b2651ee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:01:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a0d9050db4d1147722b42afef9011251b2651ee
Gitweb:     http://git.kernel.org/tip/5a0d9050db4d1147722b42afef9011251b2651ee
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 14 Sep 2009 16:49:37 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 17 Sep 2009 04:04:01 +0200

tracing/kprobes: Disable kprobe events by default after creation

Disable newly created kprobe events by default, not to disturb
another user using ftrace. "Disturb" means when someone is using
ftrace and another user tries to use perf-tools, (in near
future) if he defines new kprobe event via perf-tools, then new
events will mess up the frace buffer. Fix this to allow proper
and transparent kprobes events concurrent usage between ftrace
users and perf users.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
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
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090914204937.18779.59422.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
 
