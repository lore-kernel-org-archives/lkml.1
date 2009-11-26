Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbZKZHI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbZKZHI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbZKZHI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:08:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60514 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758813AbZKZHIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:08:23 -0500
Message-ID: <4B0E2951.9050800@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:08:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] tracing: Restore original format of sched events
References: <4B0E2807.4060102@cn.fujitsu.com>
In-Reply-To: <4B0E2807.4060102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original format for sched_stat_iowait and sched_stat_sleep:

  $ cat events/sched/sched_stat_iowait/format
  ...
  print fmt: "comm=%s pid=%d delay=%Lu [ns]", ...
  $ cat events/sched/sched_stat_sleep/format
  ...
  print fmt: "comm=%s pid=%d delay=%Lu [ns]", ...

But commit commit 75ec29ab848a7e92a41aaafaeb33d1afbc839be4
("tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT")
broke the format:

  $ cat events/sched/sched_stat_iowait/format
  print fmt: "task: %s:%d iowait: %Lu [ns]", ...
  $ cat events/sched/sched_stat_sleep/format
  print fmt: "task: %s:%d sleep: %Lu [ns]", ...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/sched.h |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 238f74b..7f67d27 100644
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
-- 
1.6.3

