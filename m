Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZKZIpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZKZIpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbZKZIpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:45:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:58798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955AbZKZIpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:45:00 -0500
Date: Thu, 26 Nov 2009 08:44:28 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0E2951.9050800@cn.fujitsu.com>
References: <4B0E2951.9050800@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Restore original format of sched events
Message-ID: <tip-470dda7417f284b9cfc96560b2acd98df63798a2@git.kernel.org>
Git-Commit-ID: 470dda7417f284b9cfc96560b2acd98df63798a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  470dda7417f284b9cfc96560b2acd98df63798a2
Gitweb:     http://git.kernel.org/tip/470dda7417f284b9cfc96560b2acd98df63798a2
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:08:01 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:05 +0100

tracing: Restore original format of sched events

The original format for sched_stat_iowait and sched_stat_sleep:

  $ cat events/sched/sched_stat_iowait/format
  ...
  print fmt: "comm=%s pid=%d delay=%Lu [ns]", ...
  $ cat events/sched/sched_stat_sleep/format
  ...
  print fmt: "comm=%s pid=%d delay=%Lu [ns]", ...

But commit commit 75ec29ab848a7e92a41aaafaeb33d1afbc839be4
("tracing: Convert some sched trace events to DEFINE_EVENT and
_PRINT") broke the format:

  $ cat events/sched/sched_stat_iowait/format
  print fmt: "task: %s:%d iowait: %Lu [ns]", ...
  $ cat events/sched/sched_stat_sleep/format
  print fmt: "task: %s:%d sleep: %Lu [ns]", ...

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0E2951.9050800@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/sched.h |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 5ce7950..9d316b2 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -355,23 +355,17 @@ DEFINE_EVENT(sched_stat_template, sched_stat_wait,
  * Tracepoint for accounting sleep time (time the task is not runnable,
  * including iowait, see below).
  */
-DEFINE_EVENT_PRINT(sched_stat_template, sched_stat_sleep,
-		   TP_PROTO(struct task_struct *tsk, u64 delay),
-		   TP_ARGS(tsk, delay),
-		   TP_printk("task: %s:%d sleep: %Lu [ns]",
-			     __entry->comm, __entry->pid,
-			     (unsigned long long)__entry->delay));
+DEFINE_EVENT(sched_stat_template, sched_stat_sleep,
+	     TP_PROTO(struct task_struct *tsk, u64 delay),
+	     TP_ARGS(tsk, delay));
 
 /*
  * Tracepoint for accounting iowait time (time the task is not runnable
  * due to waiting on IO to complete).
  */
-DEFINE_EVENT_PRINT(sched_stat_template, sched_stat_iowait,
-		   TP_PROTO(struct task_struct *tsk, u64 delay),
-		   TP_ARGS(tsk, delay),
-		   TP_printk("task: %s:%d iowait: %Lu [ns]",
-			     __entry->comm, __entry->pid,
-			     (unsigned long long)__entry->delay));
+DEFINE_EVENT(sched_stat_template, sched_stat_iowait,
+	     TP_PROTO(struct task_struct *tsk, u64 delay),
+	     TP_ARGS(tsk, delay));
 
 /*
  * Tracepoint for accounting runtime (time the task is executing
