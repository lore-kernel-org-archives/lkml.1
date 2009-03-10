Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZCJMUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZCJMUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZCJMUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:20:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:56642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZCJMUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:20:02 -0400
Date: Tue, 10 Mar 2009 12:18:24 GMT
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <20090310104437.A480.A69D9226@jp.fujitsu.com>
References: <20090310104437.A480.A69D9226@jp.fujitsu.com>
Subject: [tip:tracing/ftrace] tracing: Don't assume possible cpu list have continuous numbers
Message-ID: <tip-bbcd3063597a3824357cd83c501c2a2aa21ef37b@git.kernel.org>
Git-Commit-ID: bbcd3063597a3824357cd83c501c2a2aa21ef37b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 12:18:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbcd3063597a3824357cd83c501c2a2aa21ef37b
Gitweb:     http://git.kernel.org/tip/bbcd3063597a3824357cd83c501c2a2aa21ef37b
Author:     "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Tue, 10 Mar 2009 10:49:53 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Mar 2009 10:20:30 +0100

tracing: Don't assume possible cpu list have continuous numbers

"for (++cpu ; cpu < num_possible_cpus(); cpu++)" statement assumes
possible cpus have continuous number - but that's a wrong assumption.

Insted, cpumask_next() should be used.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090310104437.A480.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_workqueue.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 46c8dc8..739fdac 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -91,7 +91,7 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 	struct cpu_workqueue_stats *cws;
 	unsigned long flags;
 
-	WARN_ON(cpu < 0 || cpu >= num_possible_cpus());
+	WARN_ON(cpu < 0);
 
 	/* Workqueues are sometimes created in atomic context */
 	cws = kzalloc(sizeof(struct cpu_workqueue_stats), GFP_ATOMIC);
@@ -175,12 +175,12 @@ static void *workqueue_stat_next(void *prev, int idx)
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
 		spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
-		for (++cpu ; cpu < num_possible_cpus(); cpu++) {
-			ret = workqueue_stat_start_cpu(cpu);
-			if (ret)
-				return ret;
-		}
-		return NULL;
+		do {
+			cpu = cpumask_next(cpu, cpu_possible_mask);
+			if (cpu >= nr_cpu_ids)
+				return NULL;
+		} while (!(ret = workqueue_stat_start_cpu(cpu)));
+		return ret;
 	}
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
