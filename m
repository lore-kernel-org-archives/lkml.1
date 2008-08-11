Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYHKXzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYHKXzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbYHKXxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:53:50 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44522 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869AbYHKXxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:53:49 -0400
Message-Id: <20080811235325.917183517@us.ibm.com>
References: <20080811235323.872291138@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 16:53:28 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 5/5] Container Freezer: Prevent frozen tasks or cgroups from changing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't let frozen tasks or cgroups change. This means frozen tasks can't
leave their current cgroup for another cgroup. It also means that tasks
cannot be added to or removed from a cgroup in the FROZEN state. We
enforce these rules by checking for frozen tasks and cgroups in the
can_attach() function.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
---
Changes since v4:
v5:
	Checked use of task alloc lock for races with swsusp freeze/thaw --
		looks safe because there are explicit barriers to handle
		freeze/thaw races for individual tasks, we explicitly
		handle partial group freezing, and partial group thawing
		should be resolved without changing swsusp's loop. This should
		answer Li Zefan's last comment re: races between freeze and
		thaw.

 kernel/cgroup_freezer.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

Index: linux-2.6.27-rc1-mm1/kernel/cgroup_freezer.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/cgroup_freezer.c
+++ linux-2.6.27-rc1-mm1/kernel/cgroup_freezer.c
@@ -145,22 +145,40 @@ static void freezer_destroy(struct cgrou
 	kfree(cgroup_freezer(cgroup));
 }
 
+/* Task is frozen or will freeze immediately when next it gets woken */
+static bool is_task_frozen_enough(struct task_struct *task)
+{
+	return frozen(task) ||
+		(task_is_stopped_or_traced(task) && freezing(task));
+}
 
+/*
+ * The call to cgroup_lock() in the freezer.state write method prevents
+ * a write to that file racing against an attach, and hence the
+ * can_attach() result will remain valid until the attach completes.
+ */
 static int freezer_can_attach(struct cgroup_subsys *ss,
 			      struct cgroup *new_cgroup,
 			      struct task_struct *task)
 {
 	struct freezer *freezer;
-	int retval = 0;
+	int retval;
+
+	/* Anything frozen can't move or be moved to/from */
+
+	if (is_task_frozen_enough(task))
+		return -EBUSY;
 
-	/*
-	 * The call to cgroup_lock() in the freezer.state write method prevents
-	 * a write to that file racing against an attach, and hence the
-	 * can_attach() result will remain valid until the attach completes.
-	 */
 	freezer = cgroup_freezer(new_cgroup);
 	if (freezer->state == STATE_FROZEN)
+		return -EBUSY;
+
+	retval = 0;
+	task_lock(task);
+	freezer = task_freezer(task);
+	if (freezer->state == STATE_FROZEN)
 		retval = -EBUSY;
+	task_unlock(task);
 	return retval;
 }
 
@@ -193,12 +211,7 @@ static void check_if_frozen(struct cgrou
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		/*
-		 * Task is frozen or will freeze immediately when next it gets
-		 * woken
-		 */
-		if (frozen(task) ||
-		    (task_is_stopped_or_traced(task) && freezing(task)))
+		if (is_task_frozen_enough(task))
 			nfrozen++;
 	}
 
@@ -249,11 +262,7 @@ static int try_to_freeze_cgroup(struct c
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
 			continue;
-		if (task_is_stopped_or_traced(task) && freezing(task))
-			/*
-			 * The freeze flag is set so these tasks will
-			 * immediately go into the fridge upon waking.
-			 */
+		if (is_task_frozen_enough(task))
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;

-- 
