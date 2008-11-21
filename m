Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYKUIy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYKUIy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYKUIwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbYKUIwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:38 -0500
Message-ID: <49267610.6090003@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: fix cgroup_iter_next() bug.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we access to res->cgroups without the task_lock(),
so res->cgroups may be changed. it's unreliable,
and "if (l == &res->cgroups->tasks)" may be false forever.

we don't need add any lock for fixing this bug. we just access to
struct css_set by struct cg_cgroup_link, not by struct task_struct.

since we hold css_set_lock, struct cg_cgroup_link is reliable.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..ddc10ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1810,6 +1819,7 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 {
 	struct task_struct *res;
 	struct list_head *l = it->task;
+	struct cg_cgroup_link *link;
 
 	/* If the iterator cg is NULL, we have no tasks */
 	if (!it->cg_link)
@@ -1817,7 +1827,8 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 	res = list_entry(l, struct task_struct, cg_list);
 	/* Advance iterator to find next entry */
 	l = l->next;
-	if (l == &res->cgroups->tasks) {
+	link = list_entry(it->cg_link, struct cg_cgroup_link, cgrp_link_list);
+	if (l == &link->cg->tasks) {
 		/* We reached the end of this task list - move on to
 		 * the next cg_cgroup_link */
 		cgroup_advance_iter(cgrp, it);


