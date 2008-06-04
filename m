Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYFDCMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYFDCMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYFDCMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:12:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55769 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYFDCMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:12:38 -0400
Message-ID: <4845F864.8060102@cn.fujitsu.com>
Date: Wed, 04 Jun 2008 10:05:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>
Subject: [PATCH 2/2] cpusets: update tasks' cpus_allowed and mems_allowed
 after CPU/NODE offline/online
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug is, a task may run on the cpu/node which is not in its cpuset.cpus/
cpuset.mems.

It can be reproduced by the following commands:
-----------------------------------
# mkdir /dev/cpuset
# mount -t cpuset xxx /dev/cpuset
# mkdir /dev/cpuset/0
# echo 0-1 > /dev/cpuset/0/cpus
# echo 0 > /dev/cpuset/0/mems
# echo $$ > /dev/cpuset/0/tasks
# echo 0 > /sys/devices/system/cpu/cpu1/online
# echo 1 > /sys/devices/system/cpu/cpu1/online
-----------------------------------

There is only CPU0 in cpuset.cpus, but the task in this cpuset runs on
both CPU0 and CPU1.

It is because the task's cpu_allowed didn't get updated after we did
CPU offline/online manipulation. Similar for mem_allowed.

This patch fixes this bug expect for root cpuset. Because there is a
problem about root cpuset, in that whether it is necessary to update all
the tasks in root cpuset or not after cpu/node offline/online.

If updating, some kernel threads which is bound into a specified cpu will
be unbound.

If not updating, there is a bug in root cpuset. This bug is also caused
by offline/online manipulation. For example, there is a dual-cpu
machine. we create a sub cpuset in root cpuset and assign 1 to its cpus.
And then we attach some tasks into this sub cpuset. After this, we
offline CPU1. Now, the tasks in this new cpuset are moved into root
cpuset automatically because there is no cpu in sub cpuset. Then we
online CPU1, we find all the tasks which doesn't belong to root cpuset
originally just run on CPU0.

Maybe we need to add a flag in the task_struct to mark which task can't be
unbound?

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>

---
 kernel/cpuset.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index aa955ee..ea7fdb9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1876,6 +1876,7 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct list_head queue;
 	struct cgroup *cont;
+	nodemask_t oldmems;
 
 	INIT_LIST_HEAD(&queue);
 
@@ -1895,6 +1896,8 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
+		oldmems = cp->mems_allowed;
+
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
@@ -1906,6 +1909,10 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 		if (cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
+		else {
+			update_tasks_cpumask(cp);
+			update_tasks_nodemask(cp, &oldmems);
+		}
 	}
 }
 
-- 
1.5.4.rc3


