Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYLaIhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYLaIhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbYLaIhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:37:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbYLaIhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:37:07 -0500
Message-ID: <495B2EFB.302@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 16:36:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t
References: <495B2EA6.7010808@cn.fujitsu.com> <495B2EC2.9090305@cn.fujitsu.com> <495B2EE7.4040406@cn.fujitsu.com>
In-Reply-To: <495B2EE7.4040406@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce stack usage

Allocate a cpumask_var_t in cpuset_can_attach() and then use it in
cpuset_attach(), so we won't fail cpuset_attach().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index afa29cf..b4c36d5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1306,6 +1306,14 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
+/*
+ * Since cpuset_attach() can't fail, we allocate a cpumask_var_t in
+ * cpuset_can_attach() and then use it in cpuset_attach().
+ *
+ * Protected by cgroup_lock.
+ */
+static cpumask_var_t cpus_attach;
+
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys *ss,
 			     struct cgroup *cont, struct task_struct *tsk)
@@ -1321,16 +1329,25 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 		if (!cpus_equal(tsk->cpus_allowed, cs->cpus_allowed))
 			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
+
+		if (ret)
+			return ret;
 	}
 
-	return ret < 0 ? ret : security_task_setscheduler(tsk, 0, NULL);
+	ret = security_task_setscheduler(tsk, 0, NULL);
+	if (ret)
+		return ret;
+
+	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
+		return -ENOMEM;
+
+	return 0;
 }
 
 static void cpuset_attach(struct cgroup_subsys *ss,
 			  struct cgroup *cont, struct cgroup *oldcont,
 			  struct task_struct *tsk)
 {
-	cpumask_t cpus;
 	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
@@ -1338,15 +1355,15 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 	int err;
 
 	if (cs == &top_cpuset) {
-		cpus = cpu_possible_map;
+		cpumask_copy(cpus_attach, cpu_possible_mask);
 	} else {
 		mutex_lock(&callback_mutex);
-		guarantee_online_cpus(cs, &cpus);
+		guarantee_online_cpus(cs, cpus_attach);
 		mutex_unlock(&callback_mutex);
 	}
-	err = set_cpus_allowed_ptr(tsk, &cpus);
+	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	if (err)
-		return;
+		goto out;
 
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
@@ -1358,6 +1375,8 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 		mmput(mm);
 	}
 
+out:
+	free_cpumask_var(cpus_attach);
 }
 
 /* The various types of files and directories in a cpuset file system */
-- 
1.5.4.rc3


