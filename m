Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbZEFMWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbZEFMWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760061AbZEFMWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:22:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:36054 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760073AbZEFMV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:21:59 -0400
Date: Wed, 6 May 2009 12:19:54 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, tglx@linutronix.de,
       xiaoguangrong@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49FFFDB7.1050402@cn.fujitsu.com>
References: <49FFFDB7.1050402@cn.fujitsu.com>
Subject: [tip:tracing/core] tracepoint: trace_sched_migrate_task(): remove parameter
Message-ID: <tip-de1d7286060430e79a1d50ad6e5fee8fe863c5f6@git.kernel.org>
Git-Commit-ID: de1d7286060430e79a1d50ad6e5fee8fe863c5f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:20:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de1d7286060430e79a1d50ad6e5fee8fe863c5f6
Gitweb:     http://git.kernel.org/tip/de1d7286060430e79a1d50ad6e5fee8fe863c5f6
Author:     Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
AuthorDate: Tue, 5 May 2009 16:49:59 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 12:15:51 +0200

tracepoint: trace_sched_migrate_task(): remove parameter

The orig_cpu parameter in trace_sched_migrate_task() is not necessary,
it can be got by using task_cpu(p) in the probe.

[ Impact: micro-optimization ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
[ modified from Mathieu's patch. The original patch is at:
  http://marc.info/?l=linux-kernel&m=123791201716239&w=2 ]
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: zhaolei@cn.fujitsu.com
Cc: laijs@cn.fujitsu.com
LKML-Reference: <49FFFDB7.1050402@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 9f7ffd0..9cdedbd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1954,7 +1954,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 	clock_offset = old_rq->clock - new_rq->clock;
 
-	trace_sched_migrate_task(p, task_cpu(p), new_cpu);
+	trace_sched_migrate_task(p, new_cpu);
 
 #ifdef CONFIG_SCHEDSTATS
 	if (p->se.wait_start)
