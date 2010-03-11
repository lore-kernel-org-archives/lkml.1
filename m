Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab0CKOh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:37:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:36278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab0CKOh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:37:26 -0500
Date: Thu, 11 Mar 2010 14:37:11 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1267824230-23861-1-git-send-email-acme@infradead.org>
References: <1267824230-23861-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Update the comm field in the right variable in update_max_tr
Message-ID: <tip-1acaa1b2d9b5904c9cce06122990a2d71046ce16@git.kernel.org>
Git-Commit-ID: 1acaa1b2d9b5904c9cce06122990a2d71046ce16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:37:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1acaa1b2d9b5904c9cce06122990a2d71046ce16
Gitweb:     http://git.kernel.org/tip/1acaa1b2d9b5904c9cce06122990a2d71046ce16
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 5 Mar 2010 18:23:50 -0300
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 5 Mar 2010 21:12:08 -0500

tracing: Update the comm field in the right variable in update_max_tr

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
