Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZATGor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZATGor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 01:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZATGoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 01:44:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64508 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZATGoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 01:44:37 -0500
Message-ID: <497572AA.8020101@cn.fujitsu.com>
Date: Tue, 20 Jan 2009 14:43:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: fix lock inconsistency in cgroup_clone()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed a bug in cgroup_clone() in Linus' tree (commit 7b574b7), without
noticing there was a cleanup patch in -mm tree that should be rebased
(now commit 104cbd5), thus resulted in lock inconsistency.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

for 2.6.29

---
 kernel/cgroup.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c298310..a5826f3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2991,20 +2991,21 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}
-	task_lock(tsk);
-	cg = tsk->cgroups;
-	parent = task_cgroup(tsk, subsys->subsys_id);
 
 	/* Pin the hierarchy */
-	if (!atomic_inc_not_zero(&parent->root->sb->s_active)) {
+	if (!atomic_inc_not_zero(&root->sb->s_active)) {
 		/* We race with the final deactivate_super() */
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}
 
 	/* Keep the cgroup alive */
+	task_lock(tsk);
+	parent = task_cgroup(tsk, subsys->subsys_id);
+	cg = tsk->cgroups;
 	get_css_set(cg);
 	task_unlock(tsk);
+
 	mutex_unlock(&cgroup_mutex);
 
 	/* Now do the VFS work to create a cgroup */
@@ -3043,7 +3044,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 		mutex_unlock(&inode->i_mutex);
 		put_css_set(cg);
 
-		deactivate_super(parent->root->sb);
+		deactivate_super(root->sb);
 		/* The cgroup is still accessible in the VFS, but
 		 * we're not going to try to rmdir() it at this
 		 * point. */
@@ -3069,7 +3070,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 	mutex_lock(&cgroup_mutex);
 	put_css_set(cg);
 	mutex_unlock(&cgroup_mutex);
-	deactivate_super(parent->root->sb);
+	deactivate_super(root->sb);
 	return ret;
 }
 
-- 
1.5.4.rc3


