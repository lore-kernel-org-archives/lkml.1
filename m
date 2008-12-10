Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYLJXqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYLJXqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbYLJXpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:45:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21352 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbYLJXpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:45:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=F0j1JMUUdX0wUGFfCO7omCCgoPtTKlxScBV6MhjlVcgMpmHghxY9XjDBVgnXQCtHQ
	nA3l9fD/ERMUa25zfo/kw==
Message-Id: <20081210234432.065445000@menage.corp.google.com>
References: <20081210233654.563182000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Wed, 10 Dec 2008 15:36:55 -0800
From: menage@google.com
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [RFC][PATCH 1/3] CGroups: Add a per-subsystem hierarchy_mutex
Content-Disposition: inline; filename=cgroup_hierarchy_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a hierarchy_mutex to the cgroup_subsys object that
protects changes to the hierarchy observed by that subsystem. It is
taken by the cgroup subsystem (in addition to cgroup_mutex) for the
following operations:

- linking a cgroup into that subsystem's cgroup tree
- unlinking a cgroup from that subsystem's cgroup tree
- moving the subsystem to/from a hierarchy (including across the
  bind() callback)

Thus if the subsystem holds its own hierarchy_mutex, it can safely
traverse its own hierarchy.

Signed-off-by: Paul Menage <menage@google.com>

---

 Documentation/cgroups/cgroups.txt |    2 +-
 include/linux/cgroup.h            |    9 ++++++++-
 kernel/cgroup.c                   |   37 +++++++++++++++++++++++++++++++++++--
 3 files changed, 44 insertions(+), 4 deletions(-)

Index: hierarchy_lock-mmotm-2008-12-09/include/linux/cgroup.h
===================================================================
--- hierarchy_lock-mmotm-2008-12-09.orig/include/linux/cgroup.h
+++ hierarchy_lock-mmotm-2008-12-09/include/linux/cgroup.h
@@ -337,8 +337,15 @@ struct cgroup_subsys {
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
 
-	struct cgroupfs_root *root;
+	/*
+	 * Protects sibling/children links of cgroups in this
+	 * hierarchy, plus protects which hierarchy (or none) the
+	 * subsystem is a part of (i.e. root/sibling)
+	 */
+	struct mutex hierarchy_mutex;
 
+	/* Protected by this->hierarchy_mutex and cgroup_lock() */
+	struct cgroupfs_root *root;
 	struct list_head sibling;
 };
 
Index: hierarchy_lock-mmotm-2008-12-09/kernel/cgroup.c
===================================================================
--- hierarchy_lock-mmotm-2008-12-09.orig/kernel/cgroup.c
+++ hierarchy_lock-mmotm-2008-12-09/kernel/cgroup.c
@@ -714,23 +714,26 @@ static int rebind_subsystems(struct cgro
 			BUG_ON(cgrp->subsys[i]);
 			BUG_ON(!dummytop->subsys[i]);
 			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
+			mutex_lock(&ss->hierarchy_mutex);
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
 			list_move(&ss->sibling, &root->subsys_list);
 			ss->root = root;
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
 			subsys[i]->root = &rootnode;
 			list_move(&ss->sibling, &rootnode.subsys_list);
+			mutex_unlock(&ss->hierarchy_mutex);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */
 			BUG_ON(!cgrp->subsys[i]);
@@ -2326,6 +2329,29 @@ static void init_cgroup_css(struct cgrou
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
@@ -2374,7 +2400,9 @@ static long cgroup_create(struct cgroup 
 		init_cgroup_css(css, ss, cgrp);
 	}
 
+	cgroup_lock_hierarchy(root);
 	list_add(&cgrp->sibling, &cgrp->parent->children);
+	cgroup_unlock_hierarchy(root);
 	root->number_of_cgroups++;
 
 	err = cgroup_create_dir(cgrp, dentry, mode);
@@ -2492,8 +2520,12 @@ static int cgroup_rmdir(struct inode *un
 	if (!list_empty(&cgrp->release_list))
 		list_del(&cgrp->release_list);
 	spin_unlock(&release_list_lock);
-	/* delete my sibling from parent->children */
+
+	cgroup_lock_hierarchy(cgrp->root);
+	/* delete this cgroup from parent->children */
 	list_del(&cgrp->sibling);
+	cgroup_unlock_hierarchy(cgrp->root);
+
 	spin_lock(&cgrp->dentry->d_lock);
 	d = dget(cgrp->dentry);
 	spin_unlock(&d->d_lock);
@@ -2535,6 +2567,7 @@ static void __init cgroup_init_subsys(st
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
+	mutex_init(&ss->hierarchy_mutex);
 	ss->active = 1;
 }
 
Index: hierarchy_lock-mmotm-2008-12-09/Documentation/cgroups/cgroups.txt
===================================================================
--- hierarchy_lock-mmotm-2008-12-09.orig/Documentation/cgroups/cgroups.txt
+++ hierarchy_lock-mmotm-2008-12-09/Documentation/cgroups/cgroups.txt
@@ -528,7 +528,7 @@ example in cpusets, no task may attach b
 up.
 
 void bind(struct cgroup_subsys *ss, struct cgroup *root)
-(cgroup_mutex held by caller)
+(cgroup_mutex and ss->hierarchy_mutex held by caller)
 
 Called when a cgroup subsystem is rebound to a different hierarchy
 and root cgroup. Currently this will only involve movement between

--
