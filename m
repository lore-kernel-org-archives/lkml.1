Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZJ2IJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZJ2IJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZJ2IJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:09:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:53043 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZJ2IJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:09:24 -0400
Date: Thu, 29 Oct 2009 08:08:20 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091027204244.30545.27516.stgit@harusame>
References: <20091027204244.30545.27516.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobe-tracer: Compare both of event-name and event-group to find probe
Message-ID: <tip-dd004c475cd15a5749b04b0283d41ffdfa57d658@git.kernel.org>
Git-Commit-ID: dd004c475cd15a5749b04b0283d41ffdfa57d658
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd004c475cd15a5749b04b0283d41ffdfa57d658
Gitweb:     http://git.kernel.org/tip/dd004c475cd15a5749b04b0283d41ffdfa57d658
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Oct 2009 16:42:44 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:47:47 +0100

kprobe-tracer: Compare both of event-name and event-group to find probe

Fix find_probe_event() to compare both of event-name and
event-group. Without this fix, kprobe-tracer overwrites existing
same event-name probe even if its group-name is different.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091027204244.30545.27516.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
