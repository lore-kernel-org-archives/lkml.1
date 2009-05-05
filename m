Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZEEIyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZEEIyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZEEIyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:54:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbZEEIx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:53:59 -0400
Message-ID: <49FFFEDC.2040701@cn.fujitsu.com>
Date: Tue, 05 May 2009 16:54:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, fweisbec@gmail.com,
       rostedt@goodmis.org, Li Zefan <lizf@cn.fujitsu.com>,
       zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com
Subject: [PATCH v2] tracepoint: trace_sched_migrate_task(): remove parameter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This patch is modified from Mathieu Desnoyers' patch. The original patch
can be found here: 
	http://marc.info/?l=linux-kernel&m=123791201716239&w=2

The orig_cpu parameter in trace_sched_migrate_task() is not necessary, 
it can be got by using task_cpu(p) in the probe. 

Changelog for v1 -> v2: 
Rebase the patch against latest tip tree. 

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

---
 include/trace/events/sched.h |    6 +++---
 kernel/sched.c               |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index ffa1cab..dd4033c 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -180,9 +180,9 @@ TRACE_EVENT(sched_switch,
  */
 TRACE_EVENT(sched_migrate_task,
 
-	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
+	TP_PROTO(struct task_struct *p, int dest_cpu),
 
-	TP_ARGS(p, orig_cpu, dest_cpu),
+	TP_ARGS(p, dest_cpu),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -196,7 +196,7 @@ TRACE_EVENT(sched_migrate_task,
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
-		__entry->orig_cpu	= orig_cpu;
+		__entry->orig_cpu	= task_cpu(p);
 		__entry->dest_cpu	= dest_cpu;
 	),
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 57125f8..1677f93 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1956,7 +1956,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 	clock_offset = old_rq->clock - new_rq->clock;
 
-	trace_sched_migrate_task(p, task_cpu(p), new_cpu);
+	trace_sched_migrate_task(p, new_cpu);
 
 #ifdef CONFIG_SCHEDSTATS
 	if (p->se.wait_start)
-- 
1.6.1.2

