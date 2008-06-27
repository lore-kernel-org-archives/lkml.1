Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYF0H7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYF0H7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 03:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYF0H72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 03:59:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYF0H71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 03:59:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:to:subject:cc:message-id:date:from;
	b=cJM+xHu07DPoe2MFxHmtxBLOx9dIU8tzbSEIOkidkoBIL6+OaqRchkRTyknzEG3ui
	zTA88olY0wTrFDt+5zAFg==
To: a.p.zijlstra@chello.nl, maxk@qualcomm.com, pj@sgi.com,
       vegard.nossum@gmail.com
Subject: [RFC][PATCH] CGroups: Add a per-subsystem hierarchy lock
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080627075912.92AE43D6907@localhost>
Date: Fri, 27 Jun 2008 00:59:12 -0700 (PDT)
From: menage@google.com (Paul Menage)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds a hierarchy_mutex to the cgroup_subsys object that
protects changes to the hierarchy observed by that subsystem. It is
taken by the cgroup subsystem for the following operations:

- linking a cgroup into that subsystem's cgroup tree
- unlinking a cgroup from that subsystem's cgroup tree
- moving the subsystem to/from a hierarchy (including across the
  bind() callback)

Thus if the subsystem holds its own hierarchy_mutex, it can safely
traverse its ts own hierarchy.

This patch also changes the cpuset hotplug code to take
cpuset_subsys.hierarchy_mutex rather than cgroup_mutex, removing a
cyclical locking dependancy between cpu_hotplug.lock and cgroup_mutex.

---

This is just a first cut - a full version of this patch would also
make use of the hierarchy_mutex at other places in cpuset.c that use
the cgroup hierarchy, but I wanted to see what people thought of the
concept. It appears to keep lockdep quiet.

 include/linux/cgroup.h |   10 ++++++++--
 kernel/cgroup.c        |   35 ++++++++++++++++++++++++++++++++++-
 kernel/cpuset.c        |    4 ++--
 3 files changed, 44 insertions(+), 5 deletions(-)

Index: lockfix-2.6.26-rc5-mm3/include/linux/cgroup.h
===================================================================
--- lockfix-2.6.26-rc5-mm3.orig/include/linux/cgroup.h
+++ lockfix-2.6.26-rc5-mm3/include/linux/cgroup.h
@@ -319,9 +319,15 @@ struct cgroup_subsys {
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
 
-	/* Protected by RCU */
-	struct cgroupfs_root *root;
+	/*
+	 * Protects sibling/children links of cgroups in this
+	 * hierarchy, plus protects which hierarchy (or none) the
+	 * subsystem is a part of (i.e. root/sibling)
+	 */
+	struct mutex hierarchy_mutex;
 
+	/* Protected by RCU, this->hierarchy_mutex and cgroup_lock() */
+	struct cgroupfs_root *root;
 	struct list_head sibling;
 
 	void *private;
Index: lockfix-2.6.26-rc5-mm3/kernel/cgroup.c
===================================================================
--- lockfix-2.6.26-rc5-mm3.orig/kernel/cgroup.c
+++ lockfix-2.6.26-rc5-mm3/kernel/cgroup.c
@@ -728,23 +728,26 @@ static int rebind_subsystems(struct cgro
 			BUG_ON(cgrp->subsys[i]);
 			BUG_ON(!dummytop->subsys[i]);
 			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
+			mutex_lock(&ss->hierarchy_mutex);
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
 			list_add(&ss->sibling, &root->subsys_list);
 			rcu_assign_pointer(ss->root, root);
 			if (ss->bind)
 				ss->bind(ss, cgrp);
-
+			mutex_unlock(&ss->hierarchy_mutex);
 		} else if (bit & removed_bits) {
 			/* We're removing this subsystem */
 			BUG_ON(cgrp->subsys[i] != dummytop->subsys[i]);
 			BUG_ON(cgrp->subsys[i]->cgroup != cgrp);
+			mutex_lock(&ss->hierarchy_mutex);
 			if (ss->bind)
 				ss->bind(ss, dummytop);
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
 			rcu_assign_pointer(subsys[i]->root, &rootnode);
 			list_del(&ss->sibling);
+			mutex_unlock(&ss->hierarchy_mutex);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */
 			BUG_ON(!cgrp->subsys[i]);
@@ -2291,6 +2294,29 @@ static void init_cgroup_css(struct cgrou
 	cgrp->subsys[ss->subsys_id] = css;
 }
 
+static void cgroup_lock_hierarchy(struct cgroupfs_root *root)
+{
+	/* We need to take each hierarchy_mutex in a consistent order */
+	int i;
+
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		struct cgroup_subsys *ss = subsys[i];
+		if (ss->root == root)
+			mutex_lock_nested(&ss->hierarchy_mutex, i);
+	}
+}
+
+static void cgroup_unlock_hierarchy(struct cgroupfs_root *root)
+{
+	int i;
+
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		struct cgroup_subsys *ss = subsys[i];
+		if (ss->root == root)
+			mutex_unlock(&ss->hierarchy_mutex);
+	}
+}
+
 /*
  * cgroup_create - create a cgroup
  * @parent: cgroup that will be parent of the new cgroup
@@ -2342,8 +2368,10 @@ static long cgroup_create(struct cgroup 
 		init_cgroup_css(css, ss, cgrp);
 	}
 
+	cgroup_lock_hierarchy(root);
 	list_add(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
+	cgroup_unlock_hierarchy(root);
 
 	err = cgroup_create_dir(cgrp, dentry, mode);
 	if (err < 0)
@@ -2460,8 +2488,12 @@ static int cgroup_rmdir(struct inode *un
 	if (!list_empty(&cgrp->release_list))
 		list_del(&cgrp->release_list);
 	spin_unlock(&release_list_lock);
+
+	cgroup_lock_hierarchy(root);
 	/* delete my sibling from parent->children */
 	list_del(&cgrp->sibling);
+	cgroup_unlock_hierarchy(root);
+
 	spin_lock(&cgrp->dentry->d_lock);
 	d = dget(cgrp->dentry);
 	cgrp->dentry = NULL;
@@ -2504,6 +2536,7 @@ static void __init cgroup_init_subsys(st
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
+	mutex_init(&ss->hierarchy_mutex);
 	ss->active = 1;
 }
 
Index: lockfix-2.6.26-rc5-mm3/kernel/cpuset.c
===================================================================
--- lockfix-2.6.26-rc5-mm3.orig/kernel/cpuset.c
+++ lockfix-2.6.26-rc5-mm3/kernel/cpuset.c
@@ -1929,7 +1929,7 @@ static void scan_for_empty_cpusets(const
 
 static void common_cpu_mem_hotplug_unplug(void)
 {
-	cgroup_lock();
+	mutex_lock(&cpuset_subsys.hierarchy_mutex);
 
 	top_cpuset.cpus_allowed = cpu_online_map;
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
@@ -1941,7 +1941,7 @@ static void common_cpu_mem_hotplug_unplu
 	 */
 	rebuild_sched_domains();
 
-	cgroup_unlock();
+	mutex_unlock(&cpuset_subsys.hierarchy_mutex);
 }
 
 /*
