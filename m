Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYHKKHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYHKKHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYHKKHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:07:38 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39327 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbYHKKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:07:37 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       Pavel Emelianov <xemul@openvz.org>, hugh@veritas.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 11 Aug 2008 15:37:33 +0530
Message-Id: <20080811100733.26336.31346.sendpatchset@balbir-laptop>
In-Reply-To: <20080811100719.26336.98302.sendpatchset@balbir-laptop>
References: <20080811100719.26336.98302.sendpatchset@balbir-laptop>
Subject: [-mm][PATCH 1/2] mm owner fix race between swap and exit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Reported-by: Hugh Dickins <hugh@veritas.com>

There's a race between mm->owner assignment and try_to_unuse(). The condition
occurs when try_to_unuse() runs in parallel with an exiting task.

The race can be visualized below. To quote Hugh
"I don't think your careful alternation of CPU0/1 events at the end matters:
the swapoff CPU simply dereferences mm->owner after that task has gone"

But the alteration does help understand the race better (at-least for me :))

CPU0					CPU1
					try_to_unuse
task 1 stars exiting			look at mm = task1->mm
..					increment mm_users
task 1 exits
mm->owner needs to be updated, but
no new owner is found
(mm_users > 1, but no other task
has task->mm = task1->mm)
mm_update_next_owner() leaves

grace period
					user count drops, call mmput(mm)
task 1 freed
					dereferencing mm->owner fails

The fix is to notify the subsystem (via mm_owner_changed callback), if
no new owner is found by specifying the new task as NULL.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/cgroup.c |    5 +++--
 kernel/exit.c   |   10 ++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~mm-owner-fix-race-with-swap kernel/exit.c
--- linux-2.6.27-rc1/kernel/exit.c~mm-owner-fix-race-with-swap	2008-08-05 10:46:19.000000000 +0530
+++ linux-2.6.27-rc1-balbir/kernel/exit.c	2008-08-05 10:46:19.000000000 +0530
@@ -625,6 +625,16 @@ retry:
 	} while_each_thread(g, c);
 
 	read_unlock(&tasklist_lock);
+	/*
+	 * We found no owner and mm_users > 1, this implies that
+	 * we are most likely racing with swap (try_to_unuse())
+	 * Mark owner as NULL, so that subsystems can understand
+	 * the callback and take action
+	 */
+	down_write(&mm->mmap_sem);
+	mm->owner = NULL;
+	cgroup_mm_owner_callbacks(mm->owner, NULL);
+	up_write(&mm->mmap_sem);
 	return;
 
 assign_new_owner:
diff -L kernel/cgroup/.c -puN /dev/null /dev/null
diff -puN kernel/cgroup.c~mm-owner-fix-race-with-swap kernel/cgroup.c
--- linux-2.6.27-rc1/kernel/cgroup.c~mm-owner-fix-race-with-swap	2008-08-05 10:47:20.000000000 +0530
+++ linux-2.6.27-rc1-balbir/kernel/cgroup.c	2008-08-05 10:47:55.000000000 +0530
@@ -2740,14 +2740,15 @@ void cgroup_fork_callbacks(struct task_s
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
-	struct cgroup *oldcgrp, *newcgrp;
+	struct cgroup *oldcgrp, *newcgrp = NULL;
 
 	if (need_mm_owner_callback) {
 		int i;
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 			oldcgrp = task_cgroup(old, ss->subsys_id);
-			newcgrp = task_cgroup(new, ss->subsys_id);
+			if (new)
+				newcgrp = task_cgroup(new, ss->subsys_id);
 			if (oldcgrp == newcgrp)
 				continue;
 			if (ss->mm_owner_changed)
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
