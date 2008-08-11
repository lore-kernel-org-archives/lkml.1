Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbYHKKIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbYHKKIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYHKKHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:07:47 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38088 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYHKKHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:07:46 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       Pavel Emelianov <xemul@openvz.org>, hugh@veritas.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 11 Aug 2008 15:37:43 +0530
Message-Id: <20080811100743.26336.6497.sendpatchset@balbir-laptop>
In-Reply-To: <20080811100719.26336.98302.sendpatchset@balbir-laptop>
References: <20080811100719.26336.98302.sendpatchset@balbir-laptop>
Subject: [-mm][PATCH 2/2] Memory rlimit enhance mm_owner_changed callback to deal with exited owner
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



mm_owner_changed callback can also be called with new task set to NULL.
(race between try_to_unuse() and mm->owner exiting). Surprisingly the order
of cgroup arguments being passed was incorrect (proves that we did not
run into mm_owner_changed callback at all).

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memrlimitcgroup.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/memrlimitcgroup.c~memrlimit-handle-mm-owner-notification-with-task-null mm/memrlimitcgroup.c
--- linux-2.6.27-rc1/mm/memrlimitcgroup.c~memrlimit-handle-mm-owner-notification-with-task-null	2008-08-05 10:56:56.000000000 +0530
+++ linux-2.6.27-rc1-balbir/mm/memrlimitcgroup.c	2008-08-05 11:24:04.000000000 +0530
@@ -73,6 +73,12 @@ void memrlimit_cgroup_uncharge_as(struct
 {
 	struct memrlimit_cgroup *memrcg;
 
+	/*
+	 * Uncharge happened as a part of the mm_owner_changed callback
+	 */
+	if (!mm->owner)
+		return;
+
 	memrcg = memrlimit_cgroup_from_task(mm->owner);
 	res_counter_uncharge(&memrcg->as_res, (nr_pages << PAGE_SHIFT));
 }
@@ -235,8 +241,8 @@ out:
  * This callback is called with mmap_sem held
  */
 static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
-						struct cgroup *cgrp,
 						struct cgroup *old_cgrp,
+						struct cgroup *cgrp,
 						struct task_struct *p)
 {
 	struct memrlimit_cgroup *memrcg, *old_memrcg;
@@ -246,7 +252,12 @@ static void memrlimit_cgroup_mm_owner_ch
 	memrcg = memrlimit_cgroup_from_cgrp(cgrp);
 	old_memrcg = memrlimit_cgroup_from_cgrp(old_cgrp);
 
-	if (res_counter_charge(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
+	/*
+	 * If we don't have a new cgroup, we just uncharge from the old one.
+	 * It means that the task is going away
+	 */
+	if (memrcg &&
+	    res_counter_charge(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
 		goto out;
 	res_counter_uncharge(&old_memrcg->as_res, (mm->total_vm << PAGE_SHIFT));
 out:
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
