Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYHAFKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYHAFKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYHAFIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:08:31 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49448 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYHAFIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:08:25 -0400
Message-Id: <20080801050701.336765729@us.ibm.com>
References: <20080801050659.924495279@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 22:07:04 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 5/6] Container Freezer: Prevent frozen tasks or cgroups from changing
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
@@ -90,26 +90,44 @@ static void freezer_destroy(struct cgrou
 			    struct cgroup *cgroup)
 {
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
 
 static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 {
@@ -140,16 +158,11 @@ static void check_if_frozen(struct cgrou
 	unsigned int nfrozen = 0, ntotal = 0;
 
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
 
 	/*
 	 * Transition to FROZEN when no new tasks can be added ensures
@@ -196,15 +209,11 @@ static int try_to_freeze_cgroup(struct c
 	freezer->state = STATE_FREEZING;
 	cgroup_iter_start(cgroup, &it);
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
 	}
 	cgroup_iter_end(cgroup, &it);

-- 
