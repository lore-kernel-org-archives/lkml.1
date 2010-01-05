Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326Ab0AEAo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0AEAo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860Ab0AEAoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:44:15 -0500
Received: from kroah.org ([198.145.64.141]:34478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab0AEAfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 64/97] memcg: avoid oom-killing innocent task in case of use_hierarchy
Date: Mon,  4 Jan 2010 16:33:17 -0800
Message-Id: <1262651630-7354-64-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

commit d31f56dbf8bafaacb0c617f9a6f137498d5c7aed upstream.

task_in_mem_cgroup(), which is called by select_bad_process() to check
whether a task can be a candidate for being oom-killed from memcg's limit,
checks "curr->use_hierarchy"("curr" is the mem_cgroup the task belongs
to).

But this check return true(it's false positive) when:

	<some path>/aa		use_hierarchy == 0	<- hitting limit
	  <some path>/aa/00	use_hierarchy == 1	<- the task belongs to

This leads to killing an innocent task in aa/00.  This patch is a fix for
this bug.  And this patch also fixes the arg for
mem_cgroup_print_oom_info().  We should print information of mem_cgroup
which the task being killed, not current, belongs to.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/memcontrol.c |    8 +++++++-
 mm/oom_kill.c   |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6314015..5dc1037 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -758,7 +758,13 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 	task_unlock(task);
 	if (!curr)
 		return 0;
-	if (curr->use_hierarchy)
+	/*
+	 * We should check use_hierarchy of "mem" not "curr". Because checking
+	 * use_hierarchy of "curr" here make this function true if hierarchy is
+	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
+	 * hierarchy(even if use_hierarchy is disabled in "mem").
+	 */
+	if (mem->use_hierarchy)
 		ret = css_is_ancestor(&curr->css, &mem->css);
 	else
 		ret = (curr == mem);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ea2147d..9092b43 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -404,7 +404,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		cpuset_print_task_mems_allowed(current);
 		task_unlock(current);
 		dump_stack();
-		mem_cgroup_print_oom_info(mem, current);
+		mem_cgroup_print_oom_info(mem, p);
 		show_mem();
 		if (sysctl_oom_dump_tasks)
 			dump_tasks(mem);
-- 
1.6.6

