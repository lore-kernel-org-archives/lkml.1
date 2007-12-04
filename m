Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbXLDVHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbXLDVHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXLDVGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:06:34 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53412
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751081AbXLDVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:06:31 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 01/23] Subject: SCHED - Add rt_nr_running accounting
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:44:31 -0500
Message-ID: <20071204204431.3567.28305.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds accounting to keep track of the number of RT tasks running
on a runqueue. This information will be used in later patches.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |    1 +
 kernel/sched_rt.c |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b062856..4751c2f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -266,6 +266,7 @@ struct rt_rq {
 	struct rt_prio_array active;
 	int rt_load_balance_idx;
 	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
+	unsigned long rt_nr_running;
 };
 
 /*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index ee9c8b6..a6271f4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -26,12 +26,27 @@ static void update_curr_rt(struct rq *rq)
 	cpuacct_charge(curr, delta_exec);
 }
 
+static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
+{
+	WARN_ON(!rt_task(p));
+	rq->rt.rt_nr_running++;
+}
+
+static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
+{
+	WARN_ON(!rt_task(p));
+	WARN_ON(!rq->rt.rt_nr_running);
+	rq->rt.rt_nr_running--;
+}
+
 static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct rt_prio_array *array = &rq->rt.active;
 
 	list_add_tail(&p->run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
+
+	inc_rt_tasks(p, rq);
 }
 
 /*
@@ -46,6 +61,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
+
+	dec_rt_tasks(p, rq);
 }
 
 /*

