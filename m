Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab0CHH31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:29:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54020 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0CHH3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:29:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 8 Mar 2010 16:25:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/2]  memcg: oom notifier
Message-Id: <20100308162544.e7372b38.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100308162414.faaa9c5f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100308162414.faaa9c5f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Considering containers or other resource management softwares in userland,
event notification of OOM in memcg should be implemented.
Now, memcg has "threshold" notifier which uses eventfd, we can make
use of it for oom notification.

This patch adds oom notification eventfd callback for memcg. The usage
is very similar to threshold notifier, but control file is
memory.oom_control and no arguments other than eventfd is required.

	% cgroup_event_notifier /cgroup/A/memory.oom_control dummy
	(About cgroup_event_notifier, see Documentation/cgroup/)

TODO:
 - add a knob to disable oom-kill under a memcg.
 - add read/write function to oom_control

Changelog: 20100304
 - renewed implemnation.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/memory.txt |   20 ++++-
 mm/memcontrol.c                  |  155 ++++++++++++++++++++++++++++-----------
 2 files changed, 131 insertions(+), 44 deletions(-)

Index: mmotm-2.6.33-Mar5/mm/memcontrol.c
===================================================================
--- mmotm-2.6.33-Mar5.orig/mm/memcontrol.c
+++ mmotm-2.6.33-Mar5/mm/memcontrol.c
@@ -159,6 +159,7 @@ struct mem_cgroup_threshold_ary {
 };
 
 static void mem_cgroup_threshold(struct mem_cgroup *mem);
+static void mem_cgroup_oom_notify(struct mem_cgroup *mem);
 
 /*
  * The memory controller data structure. The memory controller controls both
@@ -220,6 +221,9 @@ struct mem_cgroup {
 	/* thresholds for mem+swap usage. RCU-protected */
 	struct mem_cgroup_threshold_ary *memsw_thresholds;
 
+	/* For oom notifier event fd */
+	struct mem_cgroup_threshold_ary *oom_notify;
+
 	/*
 	 * Should we move charges of a task when a task is moved into this
 	 * mem_cgroup ? And what type of charges should we move ?
@@ -282,9 +286,12 @@ enum charge_type {
 /* for encoding cft->private value on file */
 #define _MEM			(0)
 #define _MEMSWAP		(1)
+#define _OOM_TYPE		(2)
 #define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
 #define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
+/* Used for OOM nofiier */
+#define OOM_CONTROL		(0)
 
 /*
  * Reclaim flags for mem_cgroup_hierarchical_reclaim
@@ -1313,9 +1320,10 @@ bool mem_cgroup_handle_oom(struct mem_cg
 		prepare_to_wait(&memcg_oom_waitq, &wait, TASK_KILLABLE);
 	mutex_unlock(&memcg_oom_mutex);
 
-	if (locked)
+	if (locked) {
+		mem_cgroup_oom_notify(mem);
 		mem_cgroup_out_of_memory(mem, mask);
-	else {
+	} else {
 		schedule();
 		finish_wait(&memcg_oom_waitq, &wait);
 	}
@@ -3363,33 +3371,65 @@ static int compare_thresholds(const void
 	return _a->threshold - _b->threshold;
 }
 
+static int mem_cgroup_oom_notify_cb(struct mem_cgroup *mem, void *data)
+{
+	struct mem_cgroup_threshold_ary *x;
+	int i;
+
+	rcu_read_lock();
+	x = rcu_dereference(mem->oom_notify);
+	for (i = 0; x && i < x->size; i++)
+		eventfd_signal(x->entries[i].eventfd, 1);
+	rcu_read_unlock();
+	return 0;
+}
+
+static void mem_cgroup_oom_notify(struct mem_cgroup *mem)
+{
+	mem_cgroup_walk_tree(mem, NULL, mem_cgroup_oom_notify_cb);
+}
+
 static int mem_cgroup_register_event(struct cgroup *cgrp, struct cftype *cft,
 		struct eventfd_ctx *eventfd, const char *args)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_threshold_ary *thresholds, *thresholds_new;
 	int type = MEMFILE_TYPE(cft->private);
-	u64 threshold, usage;
+	u64 threshold;
+	u64 usage = 0;
 	int size;
 	int i, ret;
 
-	ret = res_counter_memparse_write_strategy(args, &threshold);
-	if (ret)
-		return ret;
+	if (type != _OOM_TYPE) {
+		ret = res_counter_memparse_write_strategy(args, &threshold);
+		if (ret)
+			return ret;
+	} else if (mem_cgroup_is_root(memcg)) /* root cgroup ? */
+		return -ENOTSUPP;
 
 	mutex_lock(&memcg->thresholds_lock);
-	if (type == _MEM)
+	/* For waiting OOM notify, "-1" is passed */
+
+	switch (type) {
+	case _MEM:
 		thresholds = memcg->thresholds;
-	else if (type == _MEMSWAP)
+		break;
+	case _MEMSWAP:
 		thresholds = memcg->memsw_thresholds;
-	else
+		break;
+	case _OOM_TYPE:
+		thresholds = memcg->oom_notify;
+		break;
+	default:
 		BUG();
+	}
 
-	usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
-
-	/* Check if a threshold crossed before adding a new one */
-	if (thresholds)
-		__mem_cgroup_threshold(memcg, type == _MEMSWAP);
+	if (type != _OOM_TYPE) {
+		usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
+		/* Check if a threshold crossed before adding a new one */
+		if (thresholds)
+			__mem_cgroup_threshold(memcg, type == _MEMSWAP);
+	}
 
 	if (thresholds)
 		size = thresholds->size + 1;
@@ -3416,27 +3456,34 @@ static int mem_cgroup_register_event(str
 	thresholds_new->entries[size - 1].threshold = threshold;
 
 	/* Sort thresholds. Registering of new threshold isn't time-critical */
-	sort(thresholds_new->entries, size,
+	if (type != _OOM_TYPE) {
+		sort(thresholds_new->entries, size,
 			sizeof(struct mem_cgroup_threshold),
 			compare_thresholds, NULL);
-
-	/* Find current threshold */
-	atomic_set(&thresholds_new->current_threshold, -1);
-	for (i = 0; i < size; i++) {
-		if (thresholds_new->entries[i].threshold < usage) {
-			/*
-			 * thresholds_new->current_threshold will not be used
-			 * until rcu_assign_pointer(), so it's safe to increment
-			 * it here.
-			 */
-			atomic_inc(&thresholds_new->current_threshold);
+		/* Find current threshold */
+		atomic_set(&thresholds_new->current_threshold, -1);
+		for (i = 0; i < size; i++) {
+			if (thresholds_new->entries[i].threshold < usage) {
+				/*
+				 * thresholds_new->current_threshold will not
+				 * be used until rcu_assign_pointer(), so it's
+				 * safe to increment it here.
+				 */
+				atomic_inc(&thresholds_new->current_threshold);
+			}
 		}
 	}
-
-	if (type == _MEM)
+	switch (type) {
+	case _MEM:
 		rcu_assign_pointer(memcg->thresholds, thresholds_new);
-	else
+		break;
+	case _MEMSWAP:
 		rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
+		break;
+	case _OOM_TYPE:
+		rcu_assign_pointer(memcg->oom_notify, thresholds_new);
+		break;
+	}
 
 	/* To be sure that nobody uses thresholds before freeing it */
 	synchronize_rcu();
@@ -3454,17 +3501,25 @@ static int mem_cgroup_unregister_event(s
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_threshold_ary *thresholds, *thresholds_new;
 	int type = MEMFILE_TYPE(cft->private);
-	u64 usage;
+	u64 usage = 0;
 	int size = 0;
 	int i, j, ret;
 
 	mutex_lock(&memcg->thresholds_lock);
-	if (type == _MEM)
+	/* check eventfd is for OOM check or not */
+	switch (type) {
+	case _MEM:
 		thresholds = memcg->thresholds;
-	else if (type == _MEMSWAP)
+		break;
+	case _MEMSWAP:
 		thresholds = memcg->memsw_thresholds;
-	else
+		break;
+	case _OOM_TYPE:
+		thresholds = memcg->oom_notify;
+		break;
+	default:
 		BUG();
+	}
 
 	/*
 	 * Something went wrong if we trying to unregister a threshold
@@ -3472,11 +3527,11 @@ static int mem_cgroup_unregister_event(s
 	 */
 	BUG_ON(!thresholds);
 
-	usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
-
-	/* Check if a threshold crossed before removing */
-	__mem_cgroup_threshold(memcg, type == _MEMSWAP);
-
+	if (type != _OOM_TYPE) {
+		usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
+		/* Check if a threshold crossed before removing */
+		__mem_cgroup_threshold(memcg, type == _MEMSWAP);
+	}
 	/* Calculate new number of threshold */
 	for (i = 0; i < thresholds->size; i++) {
 		if (thresholds->entries[i].eventfd != eventfd)
@@ -3500,13 +3555,15 @@ static int mem_cgroup_unregister_event(s
 	thresholds_new->size = size;
 
 	/* Copy thresholds and find current threshold */
-	atomic_set(&thresholds_new->current_threshold, -1);
+	if (type != _OOM_TYPE)
+		atomic_set(&thresholds_new->current_threshold, -1);
 	for (i = 0, j = 0; i < thresholds->size; i++) {
 		if (thresholds->entries[i].eventfd == eventfd)
 			continue;
 
 		thresholds_new->entries[j] = thresholds->entries[i];
-		if (thresholds_new->entries[j].threshold < usage) {
+		if (type != _OOM_TYPE &&
+			thresholds_new->entries[j].threshold < usage) {
 			/*
 			 * thresholds_new->current_threshold will not be used
 			 * until rcu_assign_pointer(), so it's safe to increment
@@ -3518,11 +3575,17 @@ static int mem_cgroup_unregister_event(s
 	}
 
 assign:
-	if (type == _MEM)
+	switch (type) {
+	case _MEM:
 		rcu_assign_pointer(memcg->thresholds, thresholds_new);
-	else
+		break;
+	case _MEMSWAP:
 		rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
-
+		break;
+	case _OOM_TYPE:
+		rcu_assign_pointer(memcg->oom_notify, thresholds_new);
+		break;
+	}
 	/* To be sure that nobody uses thresholds before freeing it */
 	synchronize_rcu();
 
@@ -3588,6 +3651,12 @@ static struct cftype mem_cgroup_files[] 
 		.read_u64 = mem_cgroup_move_charge_read,
 		.write_u64 = mem_cgroup_move_charge_write,
 	},
+	{
+		.name = "oom_control",
+		.register_event = mem_cgroup_register_event,
+		.unregister_event = mem_cgroup_unregister_event,
+		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
+	},
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
Index: mmotm-2.6.33-Mar5/Documentation/cgroups/memory.txt
===================================================================
--- mmotm-2.6.33-Mar5.orig/Documentation/cgroups/memory.txt
+++ mmotm-2.6.33-Mar5/Documentation/cgroups/memory.txt
@@ -184,6 +184,9 @@ limits on the root cgroup.
 
 Note2: When panic_on_oom is set to "2", the whole system will panic.
 
+When oom event notifier is registered, event will be delivered.
+(See oom_control section)
+
 2. Locking
 
 The memory controller uses the following hierarchy
@@ -486,7 +489,22 @@ threshold in any direction.
 
 It's applicable for root and non-root cgroup.
 
-10. TODO
+10. OOM Control
+
+Memory controler implements oom notifier using cgroup notification
+API (See cgroups.txt). It allows to register multiple oom notification
+delivery and gets notification when oom happens.
+
+To register a notifier, application need:
+ - create an eventfd using eventfd(2)
+ - open memory.oom_control file
+ - write string like "<event_fd> <memory.oom_control>" to cgroup.event_control
+
+Application will be notifier through eventfd when oom happens.
+OOM notification doesn't work for root cgroup.
+
+
+11. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first

