Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYKUIzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYKUIzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYKUIwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59355 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbYKUIwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:46 -0500
Message-ID: <49267621.2070706@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cpuset: rcu_read_lock() to protect task_cs()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


task_cs() calls cgroup_subsys_state().

we must use rcu_read_lock() to protect cgroup_subsys_state().

it's correct that top_cpuset is never freed, but cgroup_subsys_state()
accesses css_set, this css_set maybe freed when task_cs() called.

we use use rcu_read_lock() to protect it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e00526..e0e087e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -363,14 +363,9 @@ void cpuset_update_task_memory_state(void)
 	struct task_struct *tsk = current;
 	struct cpuset *cs;
 
-	if (task_cs(tsk) == &top_cpuset) {
-		/* Don't need rcu for top_cpuset.  It's never freed. */
-		my_cpusets_mem_gen = top_cpuset.mems_generation;
-	} else {
-		rcu_read_lock();
-		my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
-		rcu_read_unlock();
-	}
+	rcu_read_lock();
+	my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
+	rcu_read_unlock();
 
 	if (my_cpusets_mem_gen != tsk->cpuset_mems_generation) {
 		mutex_lock(&callback_mutex);

