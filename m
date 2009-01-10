Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZAJHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZAJHoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 02:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZAJHoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 02:44:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62260 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZAJHoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 02:44:09 -0500
Message-ID: <49685193.6010302@cn.fujitsu.com>
Date: Sat, 10 Jan 2009 15:43:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: partly revert "sched debug: remove NULL checking in
 print_cfs_rt_rq()"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: avoid accessing NULL tg.css->cgroup

In commit 0a0db8f5c9d4bbb9bbfcc2b6cb6bce2d0ef4d73d, I removed checking
NULL tg.css->cgroup, but I realized I was wrong when I found reading
/proc/sched_debug can race with cgroup_create().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched_debug.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 4293cfa..16eeba4 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -145,6 +145,19 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
+#if defined(CONFIG_CGROUP_SCHED) && \
+	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
+static void task_group_path(struct task_group *tg, char *buf, int buflen)
+{
+	/* may be NULL if the underlying cgroup isn't fully-created yet */
+	if (!tg->css.cgroup) {
+		buf[0] = '\0';
+		return;
+	}
+	cgroup_path(tg->css.cgroup, buf, buflen);
+}
+#endif
+
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
@@ -154,10 +167,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	unsigned long flags;
 
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
-	char path[128] = "";
+	char path[128];
 	struct task_group *tg = cfs_rq->tg;
 
-	cgroup_path(tg->css.cgroup, path, sizeof(path));
+	task_group_path(tg, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
 #elif defined(CONFIG_USER_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
@@ -208,10 +221,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
-	char path[128] = "";
+	char path[128];
 	struct task_group *tg = rt_rq->tg;
 
-	cgroup_path(tg->css.cgroup, path, sizeof(path));
+	task_group_path(tg, path, sizeof(path));
 
 	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
 #else
-- 
1.5.4.rc3
