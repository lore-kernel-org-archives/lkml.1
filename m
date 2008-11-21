Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbYKUIxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbYKUIxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYKUIwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbYKUIwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:34 -0500
Message-ID: <4926760C.3040005@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: add lock for child->cgroups in cgroup_post_fork()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when cgroup_post_fork() called, child is seen by find_task_by_vpid(),
so child->cgroups maybe be changed, It'll incorrect.

child->cgroups<old>'s refcnt is decreased
child->cgroups<new>'s refcnt is increased
but child->cg_list is added to child->cgroups<old>'s list.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..ddc10ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2823,8 +2831,10 @@ void cgroup_post_fork(struct task_struct *child)
 {
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
+		task_lock(child);
 		if (list_empty(&child->cg_list))
 			list_add(&child->cg_list, &child->cgroups->tasks);
+		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
 }


