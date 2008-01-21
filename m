Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYAUTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYAUTJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 14:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYAUTJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 14:09:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60801 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYAUTJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 14:09:09 -0500
Date: Mon, 21 Jan 2008 11:08:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [patch] sched: Keep total / count stats in addition to the max for
 wait time
Message-ID: <20080121110809.1b584998@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: sched: Keep total / count stats in addition to the max for wait time

Right now, the linux kernel (with scheduler statistics enabled) keeps track
of the maximum time a process is waiting to be scheduled. While the maximum
is a very useful metric, tracking average and total is equally useful
(at least for latencytop) to figure out the accumulated effect of scheduler
delays. The accumulated effect is important to judge the performance impact
of scheduler tuning/behavior.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 include/linux/sched.h |    2 ++
 kernel/sched_debug.c  |    4 ++++
 kernel/sched_fair.c   |    3 +++
 3 files changed, 9 insertions(+)

Index: linux-2.6.24-rc8/include/linux/sched.h
===================================================================
--- linux-2.6.24-rc8.orig/include/linux/sched.h
+++ linux-2.6.24-rc8/include/linux/sched.h
@@ -877,6 +877,8 @@ struct sched_entity {
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
+	u64			wait_count;
+	u64			wait_sum;
 
 	u64			sleep_start;
 	u64			sleep_max;
Index: linux-2.6.24-rc8/kernel/sched_debug.c
===================================================================
--- linux-2.6.24-rc8.orig/kernel/sched_debug.c
+++ linux-2.6.24-rc8/kernel/sched_debug.c
@@ -299,6 +299,8 @@ void proc_sched_show_task(struct task_st
 	PN(se.exec_max);
 	PN(se.slice_max);
 	PN(se.wait_max);
+	PN(se.wait_sum);
+	P(se.wait_count);
 	P(sched_info.bkl_count);
 	P(se.nr_migrations);
 	P(se.nr_migrations_cold);
@@ -366,6 +368,8 @@ void proc_sched_set_task(struct task_str
 {
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_max				= 0;
+	p->se.wait_sum				= 0;
+	p->se.wait_count			= 0;
 	p->se.sleep_max				= 0;
 	p->se.sum_sleep_runtime			= 0;
 	p->se.block_max				= 0;
Index: linux-2.6.24-rc8/kernel/sched_fair.c
===================================================================
--- linux-2.6.24-rc8.orig/kernel/sched_fair.c
+++ linux-2.6.24-rc8/kernel/sched_fair.c
@@ -385,6 +385,9 @@ update_stats_wait_end(struct cfs_rq *cfs
 {
 	schedstat_set(se->wait_max, max(se->wait_max,
 			rq_of(cfs_rq)->clock - se->wait_start));
+	schedstat_set(se->wait_count, se->wait_count + 1);
+	schedstat_set(se->wait_sum, se->wait_sum +
+			rq_of(cfs_rq)->clock - se->wait_start);
 	schedstat_set(se->wait_start, 0);
 }
 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
