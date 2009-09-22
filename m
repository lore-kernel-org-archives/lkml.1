Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbZIVTjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbZIVTjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZIVTji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:39:38 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZIVTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TIx0K54jeNZIQzEbS8/ksF+BDKnzdpxnafK8EBWqkKAdmQ26oK6mDAl9zqFBNz4kt7
         9IZmHag3kyjVJvC0YSgTM3/5qGVHL65DjoB36OTbWOwScaRf38w02z+Xe4EEZ8G5Na7P
         ADaeE027xZNvBVrHY34+a9RI+9pmBRImwt09Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 23/24] tracing/kprobes: Disable kprobe events by default after creation
Date: Tue, 22 Sep 2009 21:38:21 +0200
Message-Id: <1253648302-5771-24-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
 
-- 
1.6.2.3

