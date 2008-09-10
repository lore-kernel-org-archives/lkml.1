Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYIJW0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYIJW0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYIJW0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:26:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59271 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751731AbYIJW0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:26:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	content-type:content-transfer-encoding;
	b=UX3mWvO/ZtP37s05RFMFuLu+/sy75ubdqncc+2T+lpEeNvPYSIKFZW1T0+2m/sjo5
	FHtdt03Tm1z3ZdI96rRlg==
Message-ID: <48C8496F.4070408@google.com>
Date: Wed, 10 Sep 2008 15:25:51 -0700
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Eliminate race in css_set refcounting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate race in css_set refcounting

This patch replaces the use of krefs in struct css_set with a plain
atomic_t, and ensures that the reference count of a css_set never hits
zero outside of a write_lock(&css_set_lock) critical section

This prevents a race between find_css_set() and put_css_set*() where
the reference count can hit zero when the css_set object is still
accessible to readers of the hash table.

Signed-off-by: Paul Menage <menage@google.com>

---

This patch applies to mmotm-2008-09-08 on top of Lai Jiangshan's
previous patch. The previous patch narrowed the race, but still left a
hole whereby a new reader could take a reference on a to-be-deleted
css_set and then drop the reference immediately, leading to two
threads both seeing the refcount drop to zero (and hence wanting to
delete it).

The code sequence in __put_css_set() could be extracted into a
atomic_dec_and_write_lock() function if considered appropriate.

 include/linux/cgroup.h |    3 --
 kernel/cgroup.c        |   51 ++++++++++++++-----------------------------------
 kernel/cgroup_debug.c  |    4 +--
 3 files changed, 18 insertions(+), 40 deletions(-)

Index: css-mmotm-20080908/include/linux/cgroup.h
===================================================================
--- css-mmotm-20080908.orig/include/linux/cgroup.h
+++ css-mmotm-20080908/include/linux/cgroup.h
@@ -9,7 +9,6 @@
  */
 
 #include <linux/sched.h>
-#include <linux/kref.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/rcupdate.h>
@@ -159,7 +158,7 @@ struct cgroup {
 struct css_set {
 
 	/* Reference count */
-	struct kref ref;
+	atomic_t refcount;
 
 	/*
 	 * List running through all cgroup groups in the same hash
Index: css-mmotm-20080908/kernel/cgroup.c
===================================================================
--- css-mmotm-20080908.orig/kernel/cgroup.c
+++ css-mmotm-20080908/kernel/cgroup.c
@@ -252,14 +252,18 @@ static void unlink_css_set(struct css_se
 	}
 }
 
-static void __release_css_set(struct kref *k, int taskexit)
+static void __put_css_set(struct css_set *cg, int taskexit)
 {
 	int i;
-	struct css_set *cg = container_of(k, struct css_set, ref);
-
+	/*
+	 * Ensure that the refcount doesn't hit zero while any readers
+	 * can see it. Similar to atomic_dec_and_lock(), but for an
+	 * rwlock
+	 */
+	if (atomic_add_unless(&cg->refcount, -1, 1))
+		return;
 	write_lock(&css_set_lock);
-	if (atomic_read(&k->refcount) > 0) {
-		/* See find_css_set()'s read_lock()ed section */
+	if (!atomic_dec_and_test(&cg->refcount)) {
 		write_unlock(&css_set_lock);
 		return;
 	}
@@ -280,32 +284,22 @@ static void __release_css_set(struct kre
 	kfree(cg);
 }
 
-static void release_css_set(struct kref *k)
-{
-	__release_css_set(k, 0);
-}
-
-static void release_css_set_taskexit(struct kref *k)
-{
-	__release_css_set(k, 1);
-}
-
 /*
  * refcounted get/put for css_set objects
  */
 static inline void get_css_set(struct css_set *cg)
 {
-	kref_get(&cg->ref);
+	atomic_inc(&cg->refcount);
 }
 
 static inline void put_css_set(struct css_set *cg)
 {
-	kref_put(&cg->ref, release_css_set);
+	__put_css_set(cg, 0);
 }
 
 static inline void put_css_set_taskexit(struct css_set *cg)
 {
-	kref_put(&cg->ref, release_css_set_taskexit);
+	__put_css_set(cg, 1);
 }
 
 /*
@@ -414,20 +408,6 @@ static struct css_set *find_css_set(
 	 * the desired set */
 	read_lock(&css_set_lock);
 	res = find_existing_css_set(oldcg, cgrp, template);
-	/*
-	 * put_css_set[_taskexit]() may race with find_css_set(), in that
-	 * find_css_set() got the css_set after put_css_set() had released it.
-	 *
-	 * We should put the whole put_css_set[_taskexit]() into css_set_lock's
-	 * write_lock critical setion to avoid this race. But it will increase
-	 * overhead for do_exit().
-	 *
-	 * So we do not avoid this race but put it under control:
-	 * __release_css_set() will re-check the refcount
-	 * with css_set_lock held.
-	 *
-	 * This race may trigger the warning in kref_get().
-	 */
 	if (res)
 		get_css_set(res);
 	read_unlock(&css_set_lock);
@@ -445,7 +425,7 @@ static struct css_set *find_css_set(
 		return NULL;
 	}
 
-	kref_init(&res->ref);
+	atomic_set(&res->refcount, 1);
 	INIT_LIST_HEAD(&res->cg_links);
 	INIT_LIST_HEAD(&res->tasks);
 	INIT_HLIST_NODE(&res->hlist);
@@ -1754,7 +1734,7 @@ int cgroup_task_count(const struct cgrou
 
 	read_lock(&css_set_lock);
 	list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
-		count += atomic_read(&link->cg->ref.refcount);
+		count += atomic_read(&link->cg->refcount);
 	}
 	read_unlock(&css_set_lock);
 	return count;
@@ -2572,8 +2552,7 @@ static void __init cgroup_init_subsys(st
 int __init cgroup_init_early(void)
 {
 	int i;
-	kref_init(&init_css_set.ref);
-	kref_get(&init_css_set.ref);
+	atomic_set(&init_css_set.refcount, 1);
 	INIT_LIST_HEAD(&init_css_set.cg_links);
 	INIT_LIST_HEAD(&init_css_set.tasks);
 	INIT_HLIST_NODE(&init_css_set.hlist);
Index: css-mmotm-20080908/kernel/cgroup_debug.c
===================================================================
--- css-mmotm-20080908.orig/kernel/cgroup_debug.c
+++ css-mmotm-20080908/kernel/cgroup_debug.c
@@ -57,7 +57,7 @@ static u64 current_css_set_refcount_read
 	u64 count;
 
 	rcu_read_lock();
-	count = atomic_read(&current->cgroups->ref.refcount);
+	count = atomic_read(&current->cgroups->refcount);
 	rcu_read_unlock();
 	return count;
 }
@@ -90,7 +90,7 @@ static struct cftype files[] =  {
 	{
 		.name = "releasable",
 		.read_u64 = releasable_read,
-	}
+	},
 };
 
 static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
