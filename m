Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYKKMfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYKKMfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbYKKMfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:35:14 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53756 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625AbYKKMfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:35:12 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 11 Nov 2008 18:04:48 +0530
Message-Id: <20081111123448.6566.55973.sendpatchset@balbir-laptop>
In-Reply-To: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
Subject: [RFC][mm] [PATCH 4/4] Memory cgroup hierarchy feature selector (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't enable multiple hierarchy support by default. This patch introduces
a features element that can be set to enable the nested depth hierarchy
feature. This feature can only be enabled when the cgroup for which the
feature this is enabled, has no children.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-add-hierarchy-selector mm/memcontrol.c
--- linux-2.6.28-rc2/mm/memcontrol.c~memcg-add-hierarchy-selector	2008-11-11 17:51:57.000000000 +0530
+++ linux-2.6.28-rc2-balbir/mm/memcontrol.c	2008-11-11 17:51:57.000000000 +0530
@@ -137,6 +137,11 @@ struct mem_cgroup {
 	 * reclaimed from. Protected by cgroup_lock()
 	 */
 	struct mem_cgroup *last_scanned_child;
+	/*
+	 * Should the accounting and control be hierarchical, per subtree?
+	 */
+	unsigned long use_hierarchy;
+
 };
 static struct mem_cgroup init_mem_cgroup;
 
@@ -1093,6 +1098,42 @@ out:
 	return ret;
 }
 
+static u64 mem_cgroup_hierarchy_read(struct cgroup *cont, struct cftype *cft)
+{
+	return mem_cgroup_from_cont(cont)->use_hierarchy;
+}
+
+static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
+					u64 val)
+{
+	int retval = 0;
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+	struct cgroup *parent = cont->parent;
+	struct mem_cgroup *parent_mem = NULL;
+
+	if (parent)
+		parent_mem = mem_cgroup_from_cont(parent);
+
+	/*
+	 * If parent's use_hiearchy is set, we can't make any modifications
+	 * in the child subtrees. If it is unset, then the change can
+	 * occur, provided the current cgroup has no children.
+	 *
+	 * For the root cgroup, parent_mem is NULL, we allow value to be
+	 * set if there are no children.
+	 */
+	if (!parent_mem || (!parent_mem->use_hierarchy &&
+				(val == 1 || val == 0))) {
+		if (list_empty(&cont->children))
+			mem->use_hierarchy = val;
+		else
+			retval = -EBUSY;
+	} else
+		retval = -EINVAL;
+
+	return retval;
+}
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
@@ -1227,6 +1268,11 @@ static struct cftype mem_cgroup_files[] 
 		.name = "stat",
 		.read_map = mem_control_stat_show,
 	},
+	{
+		.name = "use_hierarchy",
+		.write_u64 = mem_cgroup_hierarchy_write,
+		.read_u64 = mem_cgroup_hierarchy_read,
+	},
 };
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
@@ -1303,9 +1349,13 @@ mem_cgroup_create(struct cgroup_subsys *
 		parent = mem_cgroup_from_cont(cont->parent);
 		if (!mem)
 			return ERR_PTR(-ENOMEM);
+		mem->use_hierarchy = parent->use_hierarchy;
 	}
 
-	res_counter_init(&mem->res, parent ? &parent->res : NULL);
+	if (parent && parent->use_hierarchy)
+		res_counter_init(&mem->res, &parent->res);
+	else
+		res_counter_init(&mem->res, NULL);
 
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
_

-- 
	Balbir
