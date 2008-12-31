Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYLaIhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYLaIhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYLaIgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:36:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58764 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbYLaIgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:36:47 -0500
Message-ID: <495B2EE7.4040406@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 16:35:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] cpuset: remove on stack cpumask_t in cpuset_can_attach()
References: <495B2EA6.7010808@cn.fujitsu.com> <495B2EC2.9090305@cn.fujitsu.com>
In-Reply-To: <495B2EC2.9090305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: redue stack usage

Just use cs->cpus_allowed, and no need to allocate a cpumask_var_t.

Signed-off-by: Li Zefan <lizf@cn.fujistu.com>
---
 kernel/cpuset.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 41c2343..afa29cf 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1311,20 +1311,19 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 			     struct cgroup *cont, struct task_struct *tsk)
 {
 	struct cpuset *cs = cgroup_cs(cont);
+	int ret = 0;
 
 	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
-	if (tsk->flags & PF_THREAD_BOUND) {
-		cpumask_t mask;
 
+	if (tsk->flags & PF_THREAD_BOUND) {
 		mutex_lock(&callback_mutex);
-		mask = cs->cpus_allowed;
+		if (!cpus_equal(tsk->cpus_allowed, cs->cpus_allowed))
+			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
-		if (!cpus_equal(tsk->cpus_allowed, mask))
-			return -EINVAL;
 	}
 
-	return security_task_setscheduler(tsk, 0, NULL);
+	return ret < 0 ? ret : security_task_setscheduler(tsk, 0, NULL);
 }
 
 static void cpuset_attach(struct cgroup_subsys *ss,
-- 
1.5.4.rc3



