Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYLPHAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYLPHAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYLPHAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:00:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50026 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYLPHAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:00:37 -0500
Message-ID: <494751C4.6050709@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 14:59:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com>	<20081212100044.GB18152@elte.hu>	<4944754F.8050503@cn.fujitsu.com>	<1229258890.17130.9.camel@lappy.programming.kicks-ass.net>	<4945B200.7020207@cn.fujitsu.com>	<1229328783.14605.11.camel@twins>	<49462890.1040002@cn.fujitsu.com>	<1229337829.14605.41.camel@twins> <20081215200849.94b1b8de.kamezawa.hiroyu@jp.fujitsu.com> <4947413B.5090400@cn.fujitsu.com>
In-Reply-To: <4947413B.5090400@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this :

====================

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

We fix the former issue by checking if the cgroup is being created, and
fix the latter issue by synchronize free cgroup with rcu.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |   12 +++++++++++-
 kernel/cgroup.c        |   14 ++++++++------
 kernel/sched_debug.c   |   18 ++++++++++++++----
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1164963..23854ec 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -91,6 +91,8 @@ static inline void css_put(struct cgroup_subsys_state *css)
 
 /* bits in struct cgroup flags field */
 enum {
+	/* Control Group is completely created */
+	CGRP_CREATED,
 	/* Control Group is dead */
 	CGRP_REMOVED,
 	/* Control Group has previously had a child cgroup or a task,
@@ -303,7 +305,15 @@ int cgroup_add_files(struct cgroup *cgrp,
 			const struct cftype cft[],
 			int count);
 
-int cgroup_is_removed(const struct cgroup *cgrp);
+static inline int cgroup_is_removed(const struct cgroup *cgrp)
+{
+	return test_bit(CGRP_REMOVED, &cgrp->flags);
+}
+
+static inline int cgroup_is_created(const struct cgroup *cgrp)
+{
+	return test_bit(CGRP_CREATED, &cgrp->flags);
+}
 
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index fe00b3b..364e8a3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -118,12 +118,6 @@ static int root_count;
 static int need_forkexit_callback __read_mostly;
 static int need_mm_owner_callback __read_mostly;
 
-/* convenient tests for these bits */
-inline int cgroup_is_removed(const struct cgroup *cgrp)
-{
-	return test_bit(CGRP_REMOVED, &cgrp->flags);
-}
-
 /* bits in struct cgroupfs_root flags field */
 enum {
 	ROOT_NOPREFIX, /* mounted subsystems have no named prefix */
@@ -624,6 +618,12 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 * created the cgroup */
 		deactivate_super(cgrp->root->sb);
 
+		/*
+		 * Some subsystems (cpu cgroup) might still be able to
+		 * accessing the cgroup in rcu section.
+		 */
+		synchronize_rcu();
+
 		kfree(cgrp);
 	}
 	iput(inode);
@@ -2391,6 +2391,8 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	err = cgroup_populate_dir(cgrp);
 	/* If err < 0, we have a half-filled directory - oh well  ;)  */
 
+	set_bit(CGRP_CREATED, &cgrp->flags);
+
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 26ed8e3..ae35d1a 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -127,8 +127,13 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	if (tg)
 		cgroup = tg->css.cgroup;
 
-	if (cgroup)
-		cgroup_path(cgroup, path, sizeof(path));
+	/*
+	 * The task_group is dead or we race with cgroup creating.
+	 */
+	if (!cgroup || !cgroup_is_created(cgroup) || !cgroup_is_removed(cgroup))
+		return;
+
+	cgroup_path(cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
 #else
@@ -181,8 +186,13 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 	if (tg)
 		cgroup = tg->css.cgroup;
 
-	if (cgroup)
-		cgroup_path(cgroup, path, sizeof(path));
+	/*
+	 * The task_group is dead or we race with cgroup creating.
+	 */
+	if (!cgroup || !cgroup_is_created(cgroup) || !cgroup_is_removed(cgroup))
+		return;
+
+	cgroup_path(cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
 #else

