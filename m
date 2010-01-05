Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417Ab0AED1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0AED1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030Ab0AED1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:27:49 -0500
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.66]:53072 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0AED1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:27:49 -0500
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Tue, 5 Jan 2010 12:26:33 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: Greg KH <greg@kroah.com>
Cc: stable <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [stable][BUGFIX][PATCH v3] memcg: avoid oom-killing innocent task
 in case of use_hierarchy
Message-Id: <20100105122633.28738255.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20100104222818.GA20708@kroah.com>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
	<20091124162854.fb31e81e.nishimura@mxp.nes.nec.co.jp>
	<20091125090050.e366dca5.kamezawa.hiroyu@jp.fujitsu.com>
	<20091125143218.96156a5f.nishimura@mxp.nes.nec.co.jp>
	<20091217094724.15ec3b27.nishimura@mxp.nes.nec.co.jp>
	<20100104222818.GA20708@kroah.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 14:28:19 -0800
Greg KH <greg@kroah.com> wrote:

> On Thu, Dec 17, 2009 at 09:47:24AM +0900, Daisuke Nishimura wrote:
> > Stable team.
> > 
> > Cay you pick this up for 2.6.32.y(and 2.6.31.y if it will be released) ?
> > 
> > This is a for-stable version of a bugfix patch that corresponds to the
> > upstream commmit d31f56dbf8bafaacb0c617f9a6f137498d5c7aed.
> 
> I've applied it to the .32-stable tree, but it does not apply to .31.
> Care to provide a version of the patch for that kernel if you want it
> applied there?
> 
hmm, strange. I can apply it onto 2.6.31.9. It might conflict with other patches
in 2.6.31.y queue ?
Anyway, I've attached the patch that is rebased on 2.6.31.9. Please tell me if you
have any problem with it.

v3: rebased on 2.6.31.9
===
>From 14cd608eef94c851460d3d56e0c676d17ecc64f2 Mon Sep 17 00:00:00 2001
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Date: Tue, 5 Jan 2010 12:15:42 +0900
Subject: [PATCH] memcg: avoid oom-killing innocent task in case of use_hierarchy

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
1.6.3.3

