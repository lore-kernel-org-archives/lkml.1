Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYE3Bkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYE3Bkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYE3Bko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:40:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54628 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYE3Bkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:40:43 -0400
Date: Fri, 30 May 2008 10:46:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "menage@google.com" <menage@google.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [RFC][PATCH 2/2] memcg: memcg hierarchy
Message-Id: <20080530104600.63a6065a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080530104312.4b20cc60.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080530104312.4b20cc60.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hierarchy support for memcg.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

Index: hie-2.6.26-rc2-mm1/mm/memcontrol.c
===================================================================
--- hie-2.6.26-rc2-mm1.orig/mm/memcontrol.c
+++ hie-2.6.26-rc2-mm1/mm/memcontrol.c
@@ -792,6 +792,78 @@ int mem_cgroup_shrink_usage(struct mm_st
 }
 
 /*
+ * Memory Controller hierarchy support.
+ */
+
+int memcg_shrink_callback(struct res_counter *cnt, unsigned long long val)
+{
+	struct mem_cgroup *memcg = container_of(cnt, struct mem_cgroup, res);
+	unsigned long flags;
+	int ret = 1;
+	int progress = 1;
+
+retry:
+	spin_lock_irqsave(&cnt->lock, flags);
+	/* Need to shrink ? */
+	if (cnt->usage + val <= cnt->limit)
+		ret = 0;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+
+	if (!ret)
+		return 0;
+
+	if (!progress)
+		return 1;
+	progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL);
+
+	goto retry;
+}
+
+
+int mem_cgroup_resize_callback(struct res_counter *cnt, unsigned long long val)
+{
+	struct mem_cgroup *child = container_of(cnt, struct mem_cgroup, res);
+	struct mem_cgroup *parent;
+	struct cgroup *my_cg;
+	unsigned long flags, borrow;
+	unsigned long long diffs;
+	int ret = 0;
+
+	my_cg = child->css.cgroup;
+	/* Is this root group ? */
+	if (!my_cg->parent) {
+		spin_lock_irqsave(&cnt->lock, flags);
+		cnt->limit = val;
+		spin_unlock_irqrestore(&cnt->lock, flags);
+		return 0;
+	}
+	spin_lock_irqsave(&cnt->lock, flags);
+	if (val > cnt->limit) {
+		diffs = val - cnt->limit;
+		borrow = 1;
+	} else {
+		diffs = cnt->limit - val;
+		borrow = 0;
+	}
+	spin_unlock_irqrestore(&cnt->lock, flags);
+
+	parent = mem_cgroup_from_cont(my_cg->parent);
+	/* When we increase resource, call borrow. When decrease, call repay*/
+	if (borrow)
+		ret = res_counter_borrow_resource(cnt, &parent->res, diffs,
+					memcg_shrink_callback, 5);
+	else
+		ret = res_counter_repay_resource(cnt, &parent->res, diffs,
+					memcg_shrink_callback, 5);
+	return ret;
+}
+
+
+
+
+
+
+/*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
  */
@@ -898,7 +970,8 @@ static ssize_t mem_cgroup_write(struct c
 {
 	return res_counter_write(&mem_cgroup_from_cont(cont)->res,
 				cft->private, userbuf, nbytes, ppos,
-				mem_cgroup_write_strategy);
+				mem_cgroup_write_strategy,
+				mem_cgroup_resize_callback);
 }
 
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
@@ -992,6 +1065,11 @@ static struct cftype mem_cgroup_files[] 
 		.name = "stat",
 		.read_map = mem_control_stat_show,
 	},
+	{
+		.name = "assigned_to_child",
+		.private = RES_FOR_CHILDREN,
+		.read_u64 = mem_cgroup_read,
+	},
 };
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
@@ -1069,6 +1147,8 @@ mem_cgroup_create(struct cgroup_subsys *
 	}
 
 	res_counter_init(&mem->res);
+	if (cont->parent)
+		res_counter_zero_limit(&mem->res);
 
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
@@ -1095,6 +1175,14 @@ static void mem_cgroup_destroy(struct cg
 {
 	int node;
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+	struct mem_cgroup *parent;
+
+	if (cont->parent) {
+		parent = mem_cgroup_from_cont(cont->parent);
+		/* we did what we can...just returns what we borrow */
+		res_counter_repay_resource(&mem->res,
+				&parent->res, -1, NULL, 0);
+	}
 
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);

