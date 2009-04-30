Return-Path: <linux-kernel-owner+w=401wt.eu-S1762249AbZD3Ads@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762249AbZD3Ads (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761570AbZD3A2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:28:03 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:49710 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761448AbZD3A17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gSPHzli33TuKcI/eC9TfE63ouUvFhRrNhHHyJqNNKlVP042mfprtauVxWawpBukOR9
         1ffFI6O5mAC84z9T5RcmalF1onhqHdkQL97fdyI5pquz4yJhCf7Ufgh0e4EokMDVYOyK
         zDLbakBKE+xlxbSBcIOWCrfTHZfMVXTfozL4U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 17/19] tracing/workqueue: defer workqueue stat release if needed
Date: Thu, 30 Apr 2009 02:27:18 +0200
Message-Id: <1241051240-4280-18-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The workqueue tracer might free its entries in atomic context.
But if a reader is already present in the stat file, it is
not safe to free any entry, otherwise a pointer to a freed entry
could be passed to stat_show/stat_next callbacks.

What we do here is listening to the file events open() and release()
and keep track of the number of readers in our file.

So once an entry has to be freed, if there is a reader, we store the
entry to a temporary list and we defer the actual freeing until
all readers go away.
Otherwise we can free it safely without the need to defer.

[ Impact: fix possible freed pointer dereference ]

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/trace/trace_workqueue.c |   85 +++++++++++++++++++++++++++++++++------
 1 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 1c6555d..f39c5d3 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -70,6 +70,13 @@ struct workqueue_global_stats {
 static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
 #define workqueue_cpu_stat(cpu) (&per_cpu(all_workqueue_stat, cpu))
 
+/* To defer any workqueue freeing, we place them in this temporary list */
+static LIST_HEAD(free_wq_list);
+static DEFINE_SPINLOCK(free_wq_lock);
+
+/* Number of readers in our stat file */
+static int wq_file_ref;
+
 /*
  * Update record when insert a work into workqueue
  * Caller need to hold cpu_workqueue_stats spin_lock
@@ -253,6 +260,17 @@ err_alloc_cws:
 	return;
 }
 
+static void free_workqueue_stats(struct cpu_workqueue_stats *stat)
+{
+	struct workfunc_stats *wfstat, *next;
+
+	list_for_each_entry_safe(wfstat, next, &stat->workfunclist, list) {
+			list_del(&wfstat->list);
+			kfree(wfstat);
+	}
+	kfree(stat);
+}
+
 /* Destruction of a cpu workqueue thread */
 static void probe_workqueue_destruction(struct task_struct *wq_thread)
 {
@@ -263,19 +281,25 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
-		struct workfunc_stats *wfstat, *wfstatnext;
 
 		if (node->task != wq_thread)
 			continue;
 
-		list_for_each_entry_safe(wfstat, wfstatnext,
-					 &node->workfunclist, list) {
-			list_del(&wfstat->list);
-			kfree(wfstat);
-		}
-
 		list_del(&node->list);
-		kfree(node);
+
+		/*
+		 * We actually defer this workqueue freeing and
+		 * its worklets until no more readers are present on our
+		 * stat file. We are in atomic context here and can't wait
+		 * for the file and the previous copied entries that point
+		 * to this workqueue to be released.
+		 */
+		spin_lock(&free_wq_lock);
+		if (!wq_file_ref)
+			free_workqueue_stats(node);
+		else
+			list_add_tail(&node->list, &free_wq_list);
+		spin_unlock(&free_wq_lock);
 
 		goto found;
 	}
@@ -391,6 +415,39 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+/*
+ * Here we are sure that we have no more readers on our stat file
+ * and that further readers will block until we return from this function.
+ * We can then safely free these pending entries
+ */
+static void workqueue_stat_file_release(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&free_wq_lock, flags);
+
+	if (!--wq_file_ref) {
+		struct cpu_workqueue_stats *node, *next;
+
+		list_for_each_entry_safe(node, next, &free_wq_list, list) {
+			list_del(&node->list);
+			free_workqueue_stats(node);
+		}
+	}
+
+	spin_unlock_irqrestore(&free_wq_lock, flags);
+};
+
+static void workqueue_stat_file_open(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&free_wq_lock, flags);
+	wq_file_ref++;
+	spin_unlock_irqrestore(&free_wq_lock, flags);
+}
+
+		/**/
 static int workqueue_stat_headers(struct seq_file *s)
 {
 	seq_printf(s, "# CPU INSERTED EXECUTED    MAX us   AVG us"
@@ -402,11 +459,13 @@ static int workqueue_stat_headers(struct seq_file *s)
 }
 
 struct tracer_stat workqueue_stats __read_mostly = {
-	.name = "workqueues",
-	.stat_start = workqueue_stat_start,
-	.stat_next = workqueue_stat_next,
-	.stat_show = workqueue_stat_show,
-	.stat_headers = workqueue_stat_headers
+	.name		 = "workqueues",
+	.stat_start	 = workqueue_stat_start,
+	.stat_next	 = workqueue_stat_next,
+	.stat_show	 = workqueue_stat_show,
+	.stat_headers	 = workqueue_stat_headers,
+	.file_open	 = workqueue_stat_file_open,
+	.file_open	 = workqueue_stat_file_release,
 };
 
 
-- 
1.6.2.3

