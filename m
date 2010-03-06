Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0CFCW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 21:22:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42247 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0CFCWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 21:22:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=b-VHvY0dO5QA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=2TICIzPm5_ciRUbzbvsA:9 a=6INQw1EiPWwhx82SDD8A:7 a=rtyK1BE1nbiiJJtIs9utrd2L6v8A:4 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100306022215.977283932@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Mar 2010 21:21:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] tracing: Update the comm field in the right variable in update_max_tr
References: <20100306022140.320536991@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Update-the-comm-field-in-the-right-variable-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The latency output showed:

 #    | task: -3 (uid:0 nice:0 policy:1 rt_prio:99)

The comm is missing in the "task:" and it looks like a minus 3 is
the output. The correct display should be:

 #    | task: migration/0-3 (uid:0 nice:0 policy:1 rt_prio:99)

The problem is that the comm is being stored in the wrong data
structure. The max_tr.data[cpu] is what stores the comm, not the
tr->data[cpu].

Before this patch the max_tr.data[cpu]->comm was zeroed and the /debug/trace
ended up showing just the '-' sign followed by the pid.

Also remove a needless initialization of max_data.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1267824230-23861-1-git-send-email-acme@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 032c57c..6efd5cb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -592,7 +592,7 @@ static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	struct trace_array_cpu *data = tr->data[cpu];
-	struct trace_array_cpu *max_data = tr->data[cpu];
+	struct trace_array_cpu *max_data;
 
 	max_tr.cpu = cpu;
 	max_tr.time_start = data->preempt_timestamp;
@@ -602,7 +602,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	max_data->critical_start = data->critical_start;
 	max_data->critical_end = data->critical_end;
 
-	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
+	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
 	max_data->pid = tsk->pid;
 	max_data->uid = task_uid(tsk);
 	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
-- 
1.7.0


