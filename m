Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZINUr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZINUr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZINUrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:47:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801AbZINUrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:47:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 1/6] tracing/kprobes: Fix trace_probe
	registration order
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
Date: Mon, 14 Sep 2009 16:48:56 -0400
Message-ID: <20090914204856.18779.52961.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trace_probe registration order. ftrace_event_call and ftrace_event
must be registered before kprobe/kretprobe, because tracing/profiling
handlers use event-id.

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

 kernel/trace/trace_kprobe.c |   42 +++++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index cbc0870..ea0db8e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -347,20 +347,15 @@ static struct trace_probe *find_probe_event(const char *event)
 	return NULL;
 }
 
-static void __unregister_trace_probe(struct trace_probe *tp)
+/* Unregister a trace_probe and probe_event: call with locking probe_lock */
+static void unregister_trace_probe(struct trace_probe *tp)
 {
 	if (probe_is_return(tp))
 		unregister_kretprobe(&tp->rp);
 	else
 		unregister_kprobe(&tp->rp.kp);
-}
-
-/* Unregister a trace_probe and probe_event: call with locking probe_lock */
-static void unregister_trace_probe(struct trace_probe *tp)
-{
-	unregister_probe_event(tp);
-	__unregister_trace_probe(tp);
 	list_del(&tp->list);
+	unregister_probe_event(tp);
 }
 
 /* Register a trace_probe and probe_event */
@@ -371,6 +366,19 @@ static int register_trace_probe(struct trace_probe *tp)
 
 	mutex_lock(&probe_lock);
 
+	/* register as an event */
+	old_tp = find_probe_event(tp->call.name);
+	if (old_tp) {
+		/* delete old event */
+		unregister_trace_probe(old_tp);
+		free_trace_probe(old_tp);
+	}
+	ret = register_probe_event(tp);
+	if (ret) {
+		pr_warning("Faild to register probe event(%d)\n", ret);
+		goto end;
+	}
+
 	if (probe_is_return(tp))
 		ret = register_kretprobe(&tp->rp);
 	else
@@ -384,21 +392,9 @@ static int register_trace_probe(struct trace_probe *tp)
 				   tp->rp.kp.addr);
 			ret = -EINVAL;
 		}
-		goto end;
-	}
-	/* register as an event */
-	old_tp = find_probe_event(tp->call.name);
-	if (old_tp) {
-		/* delete old event */
-		unregister_trace_probe(old_tp);
-		free_trace_probe(old_tp);
-	}
-	ret = register_probe_event(tp);
-	if (ret) {
-		pr_warning("Faild to register probe event(%d)\n", ret);
-		__unregister_trace_probe(tp);
-	}
-	list_add_tail(&tp->list, &probe_list);
+		unregister_probe_event(tp);
+	} else
+		list_add_tail(&tp->list, &probe_list);
 end:
 	mutex_unlock(&probe_lock);
 	return ret;


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
