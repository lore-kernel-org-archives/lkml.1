Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZLQA7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZLQA7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763219AbZLQA6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:58:48 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37095 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763507AbZLQA6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:58:40 -0500
Date: Thu, 17 Dec 2009 09:47:24 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: stable <stable@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [BUGFIX][PATCH v2 -stable] memcg: avoid oom-killing innocent task
 in case of use_hierarchy
Message-Id: <20091217094724.15ec3b27.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20091125143218.96156a5f.nishimura@mxp.nes.nec.co.jp>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
	<20091124162854.fb31e81e.nishimura@mxp.nes.nec.co.jp>
	<20091125090050.e366dca5.kamezawa.hiroyu@jp.fujitsu.com>
	<20091125143218.96156a5f.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stable team.

Cay you pick this up for 2.6.32.y(and 2.6.31.y if it will be released) ?

This is a for-stable version of a bugfix patch that corresponds to the
upstream commmit d31f56dbf8bafaacb0c617f9a6f137498d5c7aed.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

task_in_mem_cgroup(), which is called by select_bad_process() to check whether
a task can be a candidate for being oom-killed from memcg's limit, checks
"curr->use_hierarchy"("curr" is the mem_cgroup the task belongs to).

But this check return true(it's false positive) when:

	<some path>/00		use_hierarchy == 0	<- hitting limit
	  <some path>/00/aa	use_hierarchy == 1	<- "curr"

This leads to killing an innocent task in 00/aa. This patch is a fix for this
bug. And this patch also fixes the arg for mem_cgroup_print_oom_info(). We
should print information of mem_cgroup which the task being killed, not current,
belongs to.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 mm/memcontrol.c |    8 +++++++-
 mm/oom_kill.c   |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fd4529d..566925e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -496,7 +496,13 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
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
index a7b2460..ed452e9 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -400,7 +400,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		cpuset_print_task_mems_allowed(current);
 		task_unlock(current);
 		dump_stack();
-		mem_cgroup_print_oom_info(mem, current);
+		mem_cgroup_print_oom_info(mem, p);
 		show_mem();
 		if (sysctl_oom_dump_tasks)
 			dump_tasks(mem);
-- 
1.5.6.1
