Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZIVTjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZIVTjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZIVTjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:39:17 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39120 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbZIVTjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Mlk/75EzzdZOAPBgE/4jo85A0P4u1RAJiJDtsfosCRnkgPnCxHts/PDLBZ5Qr/OV94
         VvhGivHazwA4h/5TO+GccggkuzM+lDRSTHFAs+QG0p/aNTfpImjgbIP0HFdaUVjg1Cd2
         dUOkXPhU88hxyLR9W60p3RDMyokBP8tv/zSzA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 18/24] tracing/kprobes: Fix trace_probe registration order
Date: Tue, 22 Sep 2009 21:38:16 +0200
Message-Id: <1253648302-5771-19-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
-- 
1.6.2.3

