Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYKUI5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYKUI5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYKUIxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:53:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51335 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbYKUIxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:53:07 -0500
Message-ID: <49267637.1020404@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: call find_css_set() safely in cgroup_attach_task()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in cgroup_attach_task(), tsk maybe exit when we call find_css_set().
and find_css_set() will access to invalid css_set.

this patch increase the count before get_css_set(), and decrease it
after find_css_set().

NOTICE:
css_set's refcount is also taskcount, after this patch applied, taskcount
may be off-by-one WHEN cgroup_lock() is not held.
but I reviewed other code which use taskcount, they are still correct.
No regression found by reviewing and simply testing.

So I do not use two counters in css_set.
(one counter for taskcount, the other for refcount. like struct mm_struct)
If this fix cause regression, we will use two counters in css_set.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..ddc10ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1217,7 +1222,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	int retval = 0;
 	struct cgroup_subsys *ss;
 	struct cgroup *oldcgrp;
-	struct css_set *cg = tsk->cgroups;
+	struct css_set *cg;
 	struct css_set *newcg;
 	struct cgroupfs_root *root = cgrp->root;
 	int subsys_id;
@@ -1237,11 +1242,16 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		}
 	}
 
+	task_lock(tsk);
+	cg = tsk->cgroups;
+	get_css_set(cg);
+	task_unlock(tsk);
 	/*
 	 * Locate or allocate a new css_set for this task,
 	 * based on its final set of cgroups
 	 */
 	newcg = find_css_set(cg, cgrp);
+	put_css_set(cg);
 	if (!newcg)
 		return -ENOMEM;
 



