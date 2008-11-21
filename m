Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYKUIx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYKUIx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYKUIwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56570 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYKUIwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:36 -0500
Message-ID: <49267618.6080802@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:28 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: don't put struct cgroupfs_root protected by RCU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we don't access struct cgroupfs_root in fast path,
so we should not put struct cgroupfs_root protected by RCU

but the comment in struct cgroup_subsys.root confuse us.

struct cgroup_subsys.root is used in these places:

1 find_css_set(): if (ss->root->subsys_list.next == &ss->sibling)
2 rebind_subsystems(): if (ss->root != &rootnode)
                       rcu_assign_pointer(ss->root, root);
                       rcu_assign_pointer(subsys[i]->root, &rootnode);
3 cgroup_has_css_refs(): if (ss->root != cgrp->root)
4 cgroup_init_subsys(): ss->root = &rootnode;
5 proc_cgroupstats_show(): ss->name, ss->root->subsys_bits,
                           ss->root->number_of_cgroups, !ss->disabled);
6 cgroup_clone(): root = subsys->root;
                  if ((root != subsys->root) ||

all these place we have held cgroup_lock() or we don't dereference to
struct cgroupfs_root. It's means wo don't need RCU when use
struct cgroup_subsys.root, and we should not put struct cgroupfs_root
protected by RCU.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1164963..22901ff 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -343,7 +345,6 @@ struct cgroup_subsys {
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
 
-	/* Protected by RCU */
 	struct cgroupfs_root *root;
 
 	struct list_head sibling;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..ddc10ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -717,7 +722,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
 			list_add(&ss->sibling, &root->subsys_list);
-			rcu_assign_pointer(ss->root, root);
+			ss->root = root;
 			if (ss->bind)
 				ss->bind(ss, cgrp);
 
@@ -729,7 +734,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 				ss->bind(ss, dummytop);
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
-			rcu_assign_pointer(subsys[i]->root, &rootnode);
+			subsys[i]->root = &rootnode;
 			list_del(&ss->sibling);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */


