Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbZKZRLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbZKZRLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760644AbZKZRLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:11:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36193 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbZKZRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:11:38 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH RFC v0 3/3] memcg: implement memory thresholds
Date: Thu, 26 Nov 2009 19:11:17 +0200
Message-Id: <d977350fcc9bc3e1fe484440c1fc3a7470a4e26b.1259255307.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <8524ba285f6dd59cda939c28da523f344cdab3da.1259255307.git.kirill@shutemov.name>
References: <cover.1259255307.git.kirill@shutemov.name>
 <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259255307.git.kirill@shutemov.name>
 <8524ba285f6dd59cda939c28da523f344cdab3da.1259255307.git.kirill@shutemov.name>
In-Reply-To: <cover.1259255307.git.kirill@shutemov.name>
References: <cover.1259255307.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows to register multiple memory thresholds and gets notifications
when it crosses.

To register a threshold application need:
- create an eventfd;
- open file memory.usage_in_bytes of a cgroup
- write string "<event_fd> <memory.usage_in_bytes> <threshold>" to
  cgroup.event_control.

Application will be notified through eventfd when memory usage crosses
threshold in any direction.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 149 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f99f599..af1af0b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6,6 +6,10 @@
  * Copyright 2007 OpenVZ SWsoft Inc
  * Author: Pavel Emelianov <xemul@openvz.org>
  *
+ * Memory thresholds
+ * Copyright (C) 2009 Nokia Corporation
+ * Author: Kirill A. Shutemov
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -38,6 +42,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
+#include <linux/eventfd.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -174,6 +179,12 @@ struct mem_cgroup_tree {
 
 static struct mem_cgroup_tree soft_limit_tree __read_mostly;
 
+struct mem_cgroup_threshold {
+	struct list_head list;
+	struct eventfd_ctx *eventfd;
+	u64 threshold;
+};
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -225,6 +236,9 @@ struct mem_cgroup {
 	/* set when res.limit == memsw.limit */
 	bool		memsw_is_minimum;
 
+	struct list_head thresholds;
+	struct mem_cgroup_threshold *current_threshold;
+
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -2839,12 +2853,119 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static inline void mem_cgroup_set_thresholds(struct res_counter *counter,
+		u64 above, u64 below)
+{
+	BUG_ON(res_counter_set_thresholds(counter, above, below));
+}
+
+static void mem_cgroup_threshold(struct res_counter *counter, u64 usage,
+		u64 threshold)
+{
+	struct mem_cgroup *memcg = container_of(counter,
+			struct mem_cgroup,res);
+	struct mem_cgroup_threshold *above, *below;
+
+	above = below = memcg->current_threshold;
+
+	if (threshold <= usage) {
+		list_for_each_entry_continue(above, &memcg->thresholds,
+				list) {
+			if (above->threshold > usage)
+				break;
+			below = above;
+			eventfd_signal(below->eventfd, 1);
+		}
+	} else {
+		list_for_each_entry_continue_reverse(below,
+				&memcg->thresholds, list) {
+			eventfd_signal(above->eventfd, 1);
+			if (below->threshold <= usage)
+				break;
+			above = below;
+		}
+	}
+
+	mem_cgroup_set_thresholds(&memcg->res, above->threshold,
+			below->threshold);
+	memcg->current_threshold = below;
+}
+
+static void mem_cgroup_invalidate_thresholds(struct cgroup *cgrp)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	struct mem_cgroup_threshold *tmp, *prev = NULL;
+	u64 usage = memcg->res.usage;
+
+	list_for_each_entry(tmp, &memcg->thresholds, list) {
+		if (tmp->threshold > usage) {
+			BUG_ON(!prev);
+			memcg->current_threshold = prev;
+			break;
+		}
+		prev = tmp;
+	}
+
+	mem_cgroup_set_thresholds(&memcg->res, tmp->threshold,
+			prev->threshold);
+}
+
+static int mem_cgroup_register_event(struct cgroup *cgrp, struct cftype *cft,
+		struct eventfd_ctx *eventfd, const char *args)
+{
+	u64 threshold;
+	struct mem_cgroup_threshold *new, *tmp;
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	int ret;
+
+	/* TODO: Root cgroup is a special case */
+	if (mem_cgroup_is_root(memcg))
+		return -ENOSYS;
+
+	ret = res_counter_memparse_write_strategy(args, &threshold);
+	if (ret)
+		return ret;
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&new->list);
+	new->eventfd = eventfd;
+	new->threshold = threshold;
+
+	list_for_each_entry(tmp, &memcg->thresholds, list)
+		if (new->threshold < tmp->threshold) {
+			list_add_tail(&new->list, &tmp->list);
+			break;
+		}
+	mem_cgroup_invalidate_thresholds(cgrp);
+
+	return 0;
+}
+
+static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
+		struct eventfd_ctx *eventfd)
+{
+	struct mem_cgroup_threshold *threshold, *tmp;
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+
+	list_for_each_entry_safe(threshold, tmp, &memcg->thresholds, list)
+		if (threshold->eventfd == eventfd) {
+			list_del(&threshold->list);
+			kfree(threshold);
+		}
+	mem_cgroup_invalidate_thresholds(cgrp);
+
+	return 0;
+}
 
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read,
+		.register_event = mem_cgroup_register_event,
+		.unregister_event = mem_cgroup_unregister_event,
 	},
 	{
 		.name = "max_usage_in_bytes",
@@ -3080,6 +3201,32 @@ static int mem_cgroup_soft_limit_tree_init(void)
 	return 0;
 }
 
+static int mem_cgroup_thresholds_init(struct mem_cgroup *mem)
+{
+	struct mem_cgroup_threshold *new;
+
+	mem->res.threshold_notifier = mem_cgroup_threshold;
+	INIT_LIST_HEAD(&mem->thresholds);
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&new->list);
+	new->threshold = 0ULL;
+	list_add(&new->list, &mem->thresholds);
+
+	mem->current_threshold = new;
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&new->list);
+	new->threshold = RESOURCE_MAX;
+	list_add_tail(&new->list, &mem->thresholds);
+
+	return 0;
+}
+
 static struct cgroup_subsys_state * __ref
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
@@ -3125,6 +3272,8 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 	mem->last_scanned_child = 0;
 	spin_lock_init(&mem->reclaim_param_lock);
 
+	mem_cgroup_thresholds_init(mem);
+
 	if (parent)
 		mem->swappiness = get_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
-- 
1.6.5.3

