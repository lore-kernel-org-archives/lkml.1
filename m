Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbYLLJzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbYLLJzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYLLJz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:55:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52497 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756486AbYLLJzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:55:25 -0500
Message-ID: <494234B0.5@cn.fujitsu.com>
Date: Fri, 12 Dec 2008 17:53:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix another race when reading /proc/sched_debug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed an oops with the following commit:

| commit 24eb089950ce44603b30a3145a2c8520e2b55bb1
| Author: Li Zefan <lizf@cn.fujitsu.com>
| Date:   Thu Nov 6 12:53:32 2008 -0800
|
|    cgroups: fix invalid cgrp->dentry before cgroup has been completely removed
|
|    This fixes an oops when reading /proc/sched_debug.

The above commit fixed a race that reading /proc/sched_debug may access
NULL cgrp->dentry if a cgroup is being removed.

But I found there's another different race, in that reading sched_debug
may access a cgroup which hasn't been completed created, and thus
dereference NULL cgrp->dentry!

cgroup_create()
  cpu_cgroup_create()
    register_fair_sched_group()
      list_add_rcu(...)
				print_cfs_stats()
				  for_each_leaf_cfs_rq()
				    print_cfs_rq()
				      cgroup_path()
  cgroup->dentry = dentry;

task_group is added to the global list before the cgroup has been created
completely, if at this time print_cfs_stats() is called, it will access
the half-created cgroup.

This patch fixes the bug by holding cgroup_lock() to wait the cgroup to
be created completely before calling cgroup_path().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

The patch is based on linus's git tree, and should go into 2.6.28,
but it conflicts with the cleanup patch in sched/core:
	0a0db8f5c9d4bbb9bbfcc2b6cb6bce2d0ef4d73d

---
 kernel/sched_debug.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 26ed8e3..01abf5b 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -127,8 +127,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	if (tg)
 		cgroup = tg->css.cgroup;
 
-	if (cgroup)
+	if (cgroup) {
+		cgroup_lock();
 		cgroup_path(cgroup, path, sizeof(path));
+		cgroup_unlock();
+	}
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
 #else
@@ -181,8 +184,11 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 	if (tg)
 		cgroup = tg->css.cgroup;
 
-	if (cgroup)
+	if (cgroup) {
+		cgroup_lock();
 		cgroup_path(cgroup, path, sizeof(path));
+		cgroup_unlock();
+	}
 
 	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
 #else
-- 
1.5.4.rc3
