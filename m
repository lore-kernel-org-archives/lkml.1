Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZDGK5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZDGK5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZDGK4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:56:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52961 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbZDGK4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:56:12 -0400
Message-ID: <49DB306E.5070701@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 18:52:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC][PATCH 1/3] cpusets: restructure the function cpuset_update_task_memory_state()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extract a function from cpuset_update_task_memory_state(). It will be used
later for update tasks' page/slab spread flags after its cpuset's flag is set

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 kernel/cpuset.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6ede068..c8b3c64 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -331,6 +331,24 @@ static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
 	BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
 }
 
+/*
+ * update task's spread flag if cpuset's page/slab spread flag is set
+ *
+ * Called with callback_mutex/cgroup_mutex held
+ */
+static void cpuset_update_task_spread_flag(struct cpuset *cs,
+					struct task_struct *tsk)
+{
+	if (is_spread_page(cs))
+		tsk->flags |= PF_SPREAD_PAGE;
+	else
+		tsk->flags &= ~PF_SPREAD_PAGE;
+	if (is_spread_slab(cs))
+		tsk->flags |= PF_SPREAD_SLAB;
+	else
+		tsk->flags &= ~PF_SPREAD_SLAB;
+}
+
 /**
  * cpuset_update_task_memory_state - update task memory placement
  *
@@ -388,14 +406,7 @@ void cpuset_update_task_memory_state(void)
 		cs = task_cs(tsk); /* Maybe changed when task not locked */
 		guarantee_online_mems(cs, &tsk->mems_allowed);
 		tsk->cpuset_mems_generation = cs->mems_generation;
-		if (is_spread_page(cs))
-			tsk->flags |= PF_SPREAD_PAGE;
-		else
-			tsk->flags &= ~PF_SPREAD_PAGE;
-		if (is_spread_slab(cs))
-			tsk->flags |= PF_SPREAD_SLAB;
-		else
-			tsk->flags &= ~PF_SPREAD_SLAB;
+		cpuset_update_task_spread_flag(cs, tsk);
 		task_unlock(tsk);
 		mutex_unlock(&callback_mutex);
 		mpol_rebind_task(tsk, &tsk->mems_allowed);
-- 
1.6.0.3


