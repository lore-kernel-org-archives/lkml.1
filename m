Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZD1KzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZD1KzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbZD1KzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:55:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63178 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbZD1KzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:55:04 -0400
Message-ID: <49F6E062.7040401@cn.fujitsu.com>
Date: Tue, 28 Apr 2009 18:54:26 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tracing/workqueue: Use list_for_each_entry instrad of
 list_for_each_entry_safe in probe_workqueue_destruction()
References: <49F6DFB5.2040901@cn.fujitsu.com>
In-Reply-To: <49F6DFB5.2040901@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to use list_for_each_entry_safe() because we just remove one list node
which is first found in list iteration.
(we don't continue list iteration after remove list node)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
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
1.5.5.3


