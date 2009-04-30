Return-Path: <linux-kernel-owner+w=401wt.eu-S1761873AbZD3AcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761873AbZD3AcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbZD3A1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:50 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47689 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761448AbZD3A1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T+R2eV1LX+dMDeXR7JoycI4dryMxBPRJMmhlWifd2u8Fg8n9GtgUBPj7UwWizg2/fg
         i4K8o1xyGAPY57WoX5O7utZg5DrJYoNlELsdG0rllwHxtWXxZj46fJfX0vSREF1UH2G3
         NsAX7iuvcpWQPbOnU8Ko6v/TxTIiQ2/1Ojzbg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 13/19] tracing/workqueue: use list_for_each_entry instead of list_for_each_entry_safe in probe_workqueue_destruction()
Date: Thu, 30 Apr 2009 02:27:14 +0200
Message-Id: <1241051240-4280-14-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

No need to use list_for_each_entry_safe() because we just remove one list node
which is first found in list iteration.
(we don't continue list iteration after remove list node)

[ Impact: cleanup ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/trace/trace_workqueue.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 51ed57e..b995bc0 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -206,12 +206,11 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
 {
 	/* Workqueue only execute on one cpu */
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
-	struct cpu_workqueue_stats *node, *next;
+	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
-				 list) {
+	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		struct workfunc_stats *wfstat, *wfstatnext;
 
 		if (node->task != wq_thread)
-- 
1.6.2.3

