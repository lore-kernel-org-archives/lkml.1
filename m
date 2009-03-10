Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZCJPqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZCJPqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZCJPqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:46:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:51924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZCJPqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:46:04 -0400
Date: Tue, 10 Mar 2009 15:45:27 GMT
From: Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236603381.8389.455.camel@laptop>
References: <1236603381.8389.455.camel@laptop>
Subject: [tip:sched/core] sched: optimize ttwu vs group scheduling
Message-ID: <tip-57310a98a354e84279d7c8af2f48805a62372e53@git.kernel.org>
Git-Commit-ID: 57310a98a354e84279d7c8af2f48805a62372e53
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 15:45:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57310a98a354e84279d7c8af2f48805a62372e53
Gitweb:     http://git.kernel.org/tip/57310a98a354e84279d7c8af2f48805a62372e53
Author:     "Peter Zijlstra" <peterz@infradead.org>
AuthorDate: Mon, 9 Mar 2009 13:56:21 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Mar 2009 16:43:36 +0100

sched: optimize ttwu vs group scheduling

Impact: micro-optimization

We can avoid the sched domain walk on try_to_wake_up() when we know
there are no groups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1236603381.8389.455.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e0fa739..af5cd1b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -331,6 +331,13 @@ static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
+#ifdef CONFIG_SMP
+static int root_task_group_empty(void)
+{
+	return list_empty(&root_task_group.children);
+}
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
@@ -391,6 +398,13 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 
 #else
 
+#ifdef CONFIG_SMP
+static int root_task_group_empty(void)
+{
+	return 1;
+}
+#endif
+
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
 static inline struct task_group *task_group(struct task_struct *p)
 {
@@ -2318,7 +2332,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 		sync = 0;
 
 #ifdef CONFIG_SMP
-	if (sched_feat(LB_WAKEUP_UPDATE)) {
+	if (sched_feat(LB_WAKEUP_UPDATE) && !root_task_group_empty()) {
 		struct sched_domain *sd;
 
 		this_cpu = raw_smp_processor_id();
