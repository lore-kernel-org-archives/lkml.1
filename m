Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYLNCzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYLNCzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 21:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYLNCz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 21:55:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64600 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYLNCz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 21:55:28 -0500
Message-ID: <4944754F.8050503@cn.fujitsu.com>
Date: Sun, 14 Dec 2008 10:54:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>
In-Reply-To: <20081212100044.GB18152@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> i merged it up in tip/master, could you please check whether it's ok?
> 

Sorry, though this patch avoids accessing a half-created cgroup, but I found
current code may access a cgroup which has been destroyed.

The simplest fix is to take cgroup_lock() before for_each_leaf_cfs_rq.

Could you revert this patch and apply the following new one? My box has
survived for 16 hours with it applied.

==========

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Sun, 14 Dec 2008 09:53:28 +0800
Subject: [PATCH] sched: fix another race when reading /proc/sched_debug

I fixed an oops with the following commit:

| commit 24eb089950ce44603b30a3145a2c8520e2b55bb1
| Author: Li Zefan <lizf@cn.fujitsu.com>
| Date:   Thu Nov 6 12:53:32 2008 -0800
|
|    cgroups: fix invalid cgrp->dentry before cgroup has been completely removed
|
|    This fixes an oops when reading /proc/sched_debug.

The above commit fixed a race that reading /proc/sched_debug may access
NULL cgrp->dentry if a cgroup is being removed (via cgroup_rmdir), but
hasn't been destroyed (via cgroup_diput).

But I found there's another different race, in that reading sched_debug
may access a cgroup which is being created or has been destroyed, and thus
dereference NULL cgrp->dentry!

task_group is added to the global list while the cgroup is being created,
and is removed from the global list while the cgroup is under destruction.
So running through the list should be protected by cgroup_lock(), if
cgroup data will be accessed (here by calling cgroup_path).

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched_fair.c |    6 ++++++
 kernel/sched_rt.c   |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 98345e4..8b2965b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1737,9 +1737,15 @@ static void print_cfs_stats(struct seq_file *m, int cpu)
 {
 	struct cfs_rq *cfs_rq;
 
+	/*
+	 * Hold cgroup_lock() to avoid calling cgroup_path() with
+	 * invalid cgroup.
+	 */
+	cgroup_lock();
 	rcu_read_lock();
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
 	rcu_read_unlock();
+	cgroup_unlock();
 }
 #endif
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d9ba9d5..e84480d 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1538,9 +1538,15 @@ static void print_rt_stats(struct seq_file *m, int cpu)
 {
 	struct rt_rq *rt_rq;
 
+	/*
+	 * Hold cgroup_lock() to avoid calling cgroup_path() with
+	 * invalid cgroup.
+	 */
+	cgroup_lock();
 	rcu_read_lock();
 	for_each_leaf_rt_rq(rt_rq, cpu_rq(cpu))
 		print_rt_rq(m, cpu, rt_rq);
 	rcu_read_unlock();
+	cgroup_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-- 
1.5.4.rc3

