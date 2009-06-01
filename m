Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZFARSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZFARSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZFARR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:17:27 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61974 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451AbZFARR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=R7eFyUMFC5HR78e8NR4eMoSvnlR6AQPYOkaiVdRqxdeCZLZT1ogEo/kS8/0gywflYV
         5PGh1e8HDxhesAtokOVlY3f1X5ZrZ5vYeIBcyMHGWEPT5Kv7Hb1BG54SG02eHo+fkuYg
         FQ9GcBnsqF/PSWuqrNokTJC2m37WgsxESvP6o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
       Oleg Nesterov <oleg@redhat.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] tracing/events: rename worklet_execute to worklet_entry and worklet_complete to worklet_exit
Date: Mon,  1 Jun 2009 19:17:15 +0200
Message-Id: <1243876637-6616-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
References: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

Keep a common naming convention for tracing the latency of events such as
softirq_entry/softirq_exit.

[ Impact: standardize workqueue tracepoint names ]

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/workqueue.txt |    8 ++++----
 kernel/trace/trace_workqueue.c    |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/trace/workqueue.txt b/Documentation/trace/workqueue.txt
index c446b28..b380a76 100644
--- a/Documentation/trace/workqueue.txt
+++ b/Documentation/trace/workqueue.txt
@@ -98,8 +98,8 @@ For a simple capture of all workqueues events:
 # mount -t debugfs debug /sys/kernel/debug/
 # cd /sys/kernel/debug/tracing/events/workqueue
 # ls
-filter          worklet_complete  worklet_enqueue_delayed  workqueue_creation     workqueue_flush
-worklet_cancel  worklet_enqueue   worklet_execute          workqueue_destruction
+filter          worklet_exit  worklet_enqueue_delayed  workqueue_creation     workqueue_flush
+worklet_cancel  worklet_enqueue   worklet_entry          workqueue_destruction
 # for e in $(ls); do echo 1 > $e/enable; done
 # cat /sys/kernel/debug/tracing/trace
 
@@ -108,7 +108,7 @@ worklet_cancel  worklet_enqueue   worklet_execute          workqueue_destruction
  #   | |       |          |         |
 
 <...>-5627  [000]  4597.858645: worklet_enqueue: thread=ata/0:508 func=ata_pio_task cpu=0
-<...>-508   [000]  4597.858660: worklet_execute: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task
-<...>-508   [000]  4597.858684: worklet_complete: thread=ata/0:508 work=ffff88007e9e67b8
+<...>-508   [000]  4597.858660: worklet_entry: thread=ata/0:508 work=ffff88007e9e67b8 func=ata_pio_task
+<...>-508   [000]  4597.858684: worklet_exit: thread=ata/0:508 work=ffff88007e9e67b8
 <...>-2437  [000]  4597.861259: worklet_cancel: func=ata_pio_task
 [...]
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 740de3b..fa70ea2 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -141,7 +141,7 @@ probe_worklet_enqueue_delayed(struct task_struct *wq_thread,
 
 /* Execution of a work */
 static void
-probe_worklet_execute(struct task_struct *wq_thread, struct work_struct *work)
+probe_worklet_entry(struct task_struct *wq_thread, struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
@@ -177,7 +177,7 @@ end:
 
 /* Complete of a work */
 static void
-probe_worklet_complete(struct task_struct *wq_thread, void *work)
+probe_worklet_exit(struct task_struct *wq_thread, void *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
@@ -497,17 +497,17 @@ int __init trace_workqueue_early_init(void)
 	if (ret)
 		goto out_worklet_enqueue;
 
-	ret = register_trace_worklet_execute(probe_worklet_execute);
+	ret = register_trace_worklet_entry(probe_worklet_entry);
 	if (ret)
 		goto out_worklet_enqueue_delayed;
 
-	ret = register_trace_worklet_complete(probe_worklet_complete);
+	ret = register_trace_worklet_exit(probe_worklet_exit);
 	if (ret)
-		goto out_worklet_execute;
+		goto out_worklet_entry;
 
 	ret = register_trace_workqueue_creation(probe_workqueue_creation);
 	if (ret)
-		goto out_worklet_complete;
+		goto out_worklet_exit;
 
 	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
 	if (ret)
@@ -522,10 +522,10 @@ int __init trace_workqueue_early_init(void)
 
 out_workqueue_creation:
 	unregister_trace_workqueue_creation(probe_workqueue_creation);
-out_worklet_complete:
-	unregister_trace_worklet_complete(probe_worklet_complete);
-out_worklet_execute:
-	unregister_trace_worklet_execute(probe_worklet_execute);
+out_worklet_exit:
+	unregister_trace_worklet_exit(probe_worklet_exit);
+out_worklet_entry:
+	unregister_trace_worklet_entry(probe_worklet_entry);
 out_worklet_enqueue_delayed:
 	unregister_trace_worklet_enqueue_delayed(probe_worklet_enqueue_delayed);
 out_worklet_enqueue:
-- 
1.6.2.3

