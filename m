Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYK1KCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYK1KCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYK1KCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:02:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYK1KCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:02:13 -0500
Message-ID: <492FC1B9.1040403@cn.fujitsu.com>
Date: Fri, 28 Nov 2008 18:02:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 1/3] cgroups: make root_list contains active hierarchies only
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't link rootnode to the root list, so root_list contains active
hierarchies only as the comment indicates. And rename for_each_root()
to for_each_active_root().

Also remove redundant check in cgroup_kill_sb().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index fe00b3b..33ba756 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -84,7 +84,7 @@ struct cgroupfs_root {
 	/* Tracks how many cgroups are currently defined in hierarchy.*/
 	int number_of_cgroups;
 
-	/* A list running through the mounted hierarchies */
+	/* A list running through the active hierarchies */
 	struct list_head root_list;
 
 	/* Hierarchy-specific flags */
@@ -149,8 +149,8 @@ static int notify_on_release(const struct cgroup *cgrp)
 #define for_each_subsys(_root, _ss) \
 list_for_each_entry(_ss, &_root->subsys_list, sibling)
 
-/* for_each_root() allows you to iterate across the active hierarchies */
-#define for_each_root(_root) \
+/* for_each_active_root() allows you to iterate across the active hierarchies */
+#define for_each_active_root(_root) \
 list_for_each_entry(_root, &roots, root_list)
 
 /* the list of cgroups eligible for automatic release. Protected by
@@ -1114,10 +1114,9 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	}
 	write_unlock(&css_set_lock);
 
-	if (!list_empty(&root->root_list)) {
-		list_del(&root->root_list);
-		root_count--;
-	}
+	list_del(&root->root_list);
+	root_count--;
+
 	mutex_unlock(&cgroup_mutex);
 
 	kfree(root);
@@ -2561,7 +2560,6 @@ int __init cgroup_init_early(void)
 	INIT_HLIST_NODE(&init_css_set.hlist);
 	css_set_count = 1;
 	init_cgroup_root(&rootnode);
-	list_add(&rootnode.root_list, &roots);
 	root_count = 1;
 	init_task.cgroups = &init_css_set;
 
@@ -2668,15 +2666,12 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 
 	mutex_lock(&cgroup_mutex);
 
-	for_each_root(root) {
+	for_each_active_root(root) {
 		struct cgroup_subsys *ss;
 		struct cgroup *cgrp;
 		int subsys_id;
 		int count = 0;
 
-		/* Skip this hierarchy if it has no active subsystems */
-		if (!root->actual_subsys_bits)
-			continue;
 		seq_printf(m, "%lu:", root->subsys_bits);
 		for_each_subsys(root, ss)
 			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
-- 
1.5.4.rc3

