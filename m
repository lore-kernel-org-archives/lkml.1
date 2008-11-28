Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYK1KCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYK1KCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYK1KCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:02:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62111 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbYK1KCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:02:13 -0500
Message-ID: <492FC1BD.4010705@cn.fujitsu.com>
Date: Fri, 28 Nov 2008 18:02:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 2/3] cgroups: add inactive subsystems to rootnode.root_list
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though for an inactive hierarchy, we have subsys->root == &rootnode,
but rootnode's root_list is always empty.

This conflicts with the code in find_css_set():

	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
		...
		if (ss->root->subsys_list.next == &ss->sibling) {
			...
		}
	}
	if (list_empty(&rootnode.subsys_list)) {
		...
	}

The above code assumes rootnode.subsys_list links all inactive
hierarchies.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 33ba756..4e50e97 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -716,7 +716,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
-			list_add(&ss->sibling, &root->subsys_list);
+			list_move(&ss->sibling, &root->subsys_list);
 			rcu_assign_pointer(ss->root, root);
 			if (ss->bind)
 				ss->bind(ss, cgrp);
@@ -730,7 +730,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
 			rcu_assign_pointer(subsys[i]->root, &rootnode);
-			list_del(&ss->sibling);
+			list_move(&ss->sibling, &rootnode.subsys_list);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */
 			BUG_ON(!cgrp->subsys[i]);
@@ -2522,6 +2522,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
 	/* Create the top cgroup state for this subsystem */
+	list_add(&ss->sibling, &rootnode.root_list);
 	ss->root = &rootnode;
 	css = ss->create(ss, dummytop);
 	/* We don't handle early failures gracefully */
-- 
1.5.4.rc3
