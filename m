Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYIKO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYIKO0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYIKO0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:26:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYIKO0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:26:12 -0400
Message-ID: <48C929D9.6070706@cn.fujitsu.com>
Date: Thu, 11 Sep 2008 22:23:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH -mm 1/2] cgroup: introduce hierarchy_id
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


every struct cgroupfs_root represent a hierarchy.
and this patch introduces hierarchy_id for every hierarchy,
just like pid for every struct task_struct.

hierarchy_id is very useful for fold struct cg_cgroup_link
into struct css_set.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c8f9c70..4bd5560 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -84,6 +84,9 @@ struct cgroupfs_root {
 	/* Tracks how many cgroups are currently defined in hierarchy.*/
 	int number_of_cgroups;
 
+	/* Unique id for every hierarchy. */
+	int hierarchy_id;
+
 	/* A list running through the mounted hierarchies */
 	struct list_head root_list;
 
@@ -191,6 +194,20 @@ void cgroup_huge_mem_free(void *ptr, cgroup_huge_mem_t *huge)
 		kfree(ptr);
 }
 
+static unsigned long hierarchy_id_bits;
+
+static int get_hierarchy_id(void)
+{
+	int id = find_first_zero_bit(&hierarchy_id_bits, CGROUP_SUBSYS_COUNT);
+	__set_bit(id, &hierarchy_id_bits);
+	return id;
+}
+
+static void put_hierarchy_id(int id)
+{
+	__clear_bit(id, &hierarchy_id_bits);
+}
+
 /*
  * for_each_subsys() allows you to iterate on each subsystem attached to
  * an active hierarchy
@@ -1080,6 +1097,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		BUG_ON(ret);
 
 		list_add(&root->root_list, &roots);
+		root->hierarchy_id = get_hierarchy_id();
 		root_count++;
 
 		sb->s_root->d_fsdata = &root->top_cgroup;
@@ -1165,6 +1183,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 
 	if (!list_empty(&root->root_list)) {
 		list_del(&root->root_list);
+		put_hierarchy_id(root->hierarchy_id);
 		root_count--;
 	}
 	mutex_unlock(&cgroup_mutex);
@@ -2627,6 +2646,7 @@ int __init cgroup_init_early(void)
 	css_set_count = 1;
 	init_cgroup_root(&rootnode);
 	list_add(&rootnode.root_list, &roots);
+	rootnode.hierarchy_id = get_hierarchy_id();
 	root_count = 1;
 	init_task.cgroups = &init_css_set;
 


