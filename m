Return-Path: <linux-kernel-owner+w=401wt.eu-S936204AbZAPC01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936204AbZAPC01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 21:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761727AbZAPC0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 21:26:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60614 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762151AbZAPC0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 21:26:15 -0500
Message-ID: <496FEFCA.9050908@cn.fujitsu.com>
Date: Fri, 16 Jan 2009 10:24:10 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: fix possible deadlock in async_rebuild_sched_domains
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep reported some possible circular locking info when we tested cpuset on
NUMA/fake NUMA box.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc1-00224-ga652504 #111
-------------------------------------------------------
bash/2968 is trying to acquire lock:
 (events){--..}, at: [<ffffffff8024c8cd>] flush_work+0x24/0xd8

but task is already holding lock:
 (cgroup_mutex){--..}, at: [<ffffffff8026ad1e>] cgroup_lock_live_group+0x12/0x29

which lock already depends on the new lock.
......
-------------------------------------------------------

Steps to reproduce:
# mkdir /dev/cpuset
# mount -t cpuset xxx /dev/cpuset
# mkdir /dev/cpuset/0
# echo 0 > /dev/cpuset/0/cpus
# echo 0 > /dev/cpuset/0/mems
# echo 1 > /dev/cpuset/0/memory_migrate
# cat /dev/zero > /dev/null &
# echo $! > /dev/cpuset/0/tasks

This is because async_rebuild_sched_domains has the following lock sequence:
run_workqueue(async_rebuild_sched_domains)
	-> do_rebuild_sched_domains -> cgroup_lock

But, attaching tasks when memory_migrate is set has following:
cgroup_lock_live_group(cgroup_tasks_write)
	-> do_migrate_pages -> flush_work

This patch fixes it by using a separate workqueue thread.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/cpuset.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a856788..f76db9d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -61,6 +61,14 @@
 #include <linux/cgroup.h>
 
 /*
+ * Workqueue for cpuset related tasks.
+ *
+ * Using kevent workqueue may cause deadlock when memory_migrate
+ * is set. So we create a separate workqueue thread for cpuset.
+ */
+static struct workqueue_struct *cpuset_wq;
+
+/*
  * Tracks how many cpusets are currently defined in system.
  * When there is only one cpuset (the root cpuset) we can
  * short circuit some hooks.
@@ -831,7 +839,7 @@ static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
  */
 static void async_rebuild_sched_domains(void)
 {
-	schedule_work(&rebuild_sched_domains_work);
+	queue_work(cpuset_wq, &rebuild_sched_domains_work);
 }
 
 /*
@@ -2111,6 +2119,9 @@ void __init cpuset_init_smp(void)
 
 	hotcpu_notifier(cpuset_track_online_cpus, 0);
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
+
+	cpuset_wq = create_singlethread_workqueue("cpuset");
+	BUG_ON(!cpuset_wq);
 }
 
 /**
-- 
1.6.0.3


