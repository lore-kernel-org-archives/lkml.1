Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbZJ0Unc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbZJ0Unc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbZJ0Un3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:43:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196AbZJ0Un1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:43:27 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 06/10] kprobe-tracer: Compare both of
	event-name and event-group to find probe
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 27 Oct 2009 16:42:44 -0400
Message-ID: <20091027204244.30545.27516.stgit@harusame>
In-Reply-To: <20091027204156.30545.96425.stgit@harusame>
References: <20091027204156.30545.96425.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix find_probe_event() to compare both of event-name and event-group.
Without this fix, kprobe-tracer overwrites existing same event-name probe
even if its group-name is different.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 kernel/trace/trace_kprobe.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b8ef707..a86c3ac 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -353,12 +353,14 @@ static void free_trace_probe(struct trace_probe *tp)
 	kfree(tp);
 }
 
-static struct trace_probe *find_probe_event(const char *event)
+static struct trace_probe *find_probe_event(const char *event,
+					    const char *group)
 {
 	struct trace_probe *tp;
 
 	list_for_each_entry(tp, &probe_list, list)
-		if (!strcmp(tp->call.name, event))
+		if (strcmp(tp->call.name, event) == 0 &&
+		    strcmp(tp->call.system, group) == 0)
 			return tp;
 	return NULL;
 }
@@ -383,7 +385,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	mutex_lock(&probe_lock);
 
 	/* register as an event */
-	old_tp = find_probe_event(tp->call.name);
+	old_tp = find_probe_event(tp->call.name, tp->call.system);
 	if (old_tp) {
 		/* delete old event */
 		unregister_trace_probe(old_tp);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
