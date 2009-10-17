Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZJQKB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZJQKB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZJQKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbZJQKBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:01:24 -0400
Date: Sat, 17 Oct 2009 10:00:45 GMT
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
In-Reply-To: <20090914204856.18779.52961.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204856.18779.52961.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Fix trace_probe registration order
Message-ID: <tip-2d5e067edc4635ff7515bfa9ab3edb38bc344cab@git.kernel.org>
Git-Commit-ID: 2d5e067edc4635ff7515bfa9ab3edb38bc344cab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:00:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d5e067edc4635ff7515bfa9ab3edb38bc344cab
Gitweb:     http://git.kernel.org/tip/2d5e067edc4635ff7515bfa9ab3edb38bc344cab
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 14 Sep 2009 16:48:56 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 17 Sep 2009 04:03:40 +0200

tracing/kprobes: Fix trace_probe registration order

Fix trace_probe registration order. ftrace_event_call and ftrace_event
must be registered before kprobe/kretprobe, because tracing/profiling
handlers dereference the event-id.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090914204856.18779.52961.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
