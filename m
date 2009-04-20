Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZDTG7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZDTG7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZDTG7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:59:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50029 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZDTG7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:59:03 -0400
Message-ID: <49EC1D12.7060207@cn.fujitsu.com>
Date: Mon, 20 Apr 2009 14:58:26 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] trace_workqueue: use list_for_each_entry() instead of
 list_for_each_entry_safe()
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49EC1943.8080606@cn.fujitsu.com>
In-Reply-To: <49EC1943.8080606@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to use list_for_each_entry_safe() in iteration without delete node,
we use list_for_each_entry() instead.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 984b917..934b27c 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -47,12 +47,11 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
-	struct cpu_workqueue_stats *node, *next;
+	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
-							list) {
+	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
 			atomic_inc(&node->inserted);
 			goto found;
@@ -69,12 +68,11 @@ probe_workqueue_execution(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
-	struct cpu_workqueue_stats *node, *next;
+	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
-							list) {
+	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
 			node->executed++;
 			goto found;
-- 
1.5.5.3



