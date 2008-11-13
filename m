Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbYKMFxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbYKMFxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 00:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYKMFxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 00:53:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60666 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYKMFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 00:53:29 -0500
Date: Thu, 13 Nov 2008 14:52:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH] memcg: add  force_empty again in reasonable style.
Message-Id: <20081113145250.3eecdc37.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested on x86-64 box + mmotm-Nov10.
after this, force_empty is not only for debug but for usual use.

Thanks,
-Kame
=
By memcg-move-all-accounts-to-parent-at-rmdir.patch, there is no leak
of memory usage and force_empty is removed. force_empty allows users to leak
account. 

This patch adds "force_empty" again, in reasonable style.

memory.force_empty file works when

  #echo 0 (or some) > memory.force_empty
  and have following function.

  1. only works when there are no task in this cgroup.
  2. free all page under this cgroup as much as possible.
  3. page which cannot be freed will be moved up to parent. (locked pages etc.)
  4. Then, memcg will be empty after echo returns.

This is much better behavior than old "force_empty" which just forget
all accounts. This patch also check signal_pending() and above "echo"
can be stopped by "Ctrl-C".

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 Documentation/controllers/memory.txt |   27 +++++++++++++++++++++++----
 mm/memcontrol.c                      |   34 ++++++++++++++++++++++++++++++----
 2 files changed, 53 insertions(+), 8 deletions(-)

Index: mmotm-2.6.28-Nov10/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Nov10.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Nov10/mm/memcontrol.c
@@ -1062,7 +1062,7 @@ static int mem_cgroup_force_empty_list(s
  * make mem_cgroup's charge to be 0 if there is no task.
  * This enables deleting this mem_cgroup.
  */
-static int mem_cgroup_force_empty(struct mem_cgroup *mem)
+static int mem_cgroup_force_empty(struct mem_cgroup *mem, bool free_all)
 {
 	int ret;
 	int node, zid, shrink;
@@ -1071,12 +1071,17 @@ static int mem_cgroup_force_empty(struct
 	css_get(&mem->css);
 
 	shrink = 0;
+	/* should free all ? */
+	if (free_all)
+		goto try_to_free;
 move_account:
 	while (mem->res.usage > 0) {
 		ret = -EBUSY;
 		if (atomic_read(&mem->css.cgroup->count) > 0)
 			goto out;
-
+		ret = -EINTR;
+		if (signal_pending(current))
+			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		ret = 0;
@@ -1111,14 +1116,24 @@ try_to_free:
 		ret = -EBUSY;
 		goto out;
 	}
+	/* we call try-to-free pages for make this cgroup empty */
+	lru_add_drain_all();
 	/* try to free all pages in this cgroup */
 	shrink = 1;
 	while (nr_retries && mem->res.usage > 0) {
 		int progress;
+
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
 		progress = try_to_free_mem_cgroup_pages(mem,
 						  GFP_HIGHUSER_MOVABLE);
-		if (!progress)
+		if (!progress) {
 			nr_retries--;
+			/* maybe some writeback is necessary */
+			congestion_wait(WRITE, HZ/10);
+		}
 
 	}
 	/* try move_account...there may be some *locked* pages. */
@@ -1128,6 +1143,12 @@ try_to_free:
 	goto out;
 }
 
+int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
+{
+	return mem_cgroup_force_empty(mem_cgroup_from_cont(cont), true);
+}
+
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
@@ -1225,6 +1246,7 @@ static int mem_control_stat_show(struct 
 	return 0;
 }
 
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -1253,6 +1275,10 @@ static struct cftype mem_cgroup_files[] 
 		.name = "stat",
 		.read_map = mem_control_stat_show,
 	},
+	{
+		.name = "force_empty",
+		.trigger = mem_cgroup_force_empty_write,
+	},
 };
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
@@ -1348,7 +1374,7 @@ static void mem_cgroup_pre_destroy(struc
 					struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	mem_cgroup_force_empty(mem);
+	mem_cgroup_force_empty(mem, false);
 }
 
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
Index: mmotm-2.6.28-Nov10/Documentation/controllers/memory.txt
===================================================================
--- mmotm-2.6.28-Nov10.orig/Documentation/controllers/memory.txt
+++ mmotm-2.6.28-Nov10/Documentation/controllers/memory.txt
@@ -237,11 +237,30 @@ reclaimed.
 A cgroup can be removed by rmdir, but as discussed in sections 4.1 and 4.2, a
 cgroup might have some charge associated with it, even though all
 tasks have migrated away from it.
-Such charges are moved to its parent as much as possible and freed if parent
-is full. Both of RSS and CACHES are moved to parent.
-If both of them are busy, rmdir() returns -EBUSY.
+Such charges are freed(at default) or moved to its parent. When moved,
+both of RSS and CACHES are moved to parent.
+If both of them are busy, rmdir() returns -EBUSY. See 5.1 Also.
 
-5. TODO
+5. Misc. interfaces.
+
+5.1 force_empty
+  memory.force_empty interface is provided to make cgroup's memory usage empty.
+  You can use this interface only when the cgroup has no tasks.
+  When writing anything to this
+
+  # echo 0 > memory.force_empty
+
+  Almost all pages tracked by this memcg will be unmapped and freed. Some of
+  pages cannot be freed because it's locked or in-use. Such pages are moved
+  to parent and this cgroup will be empty. But this may return -EBUSY in
+  some too busy case.
+
+  Typical usage of this interface is calling this before rmdir().
+  Because rmdir() moves all pages to parent, some out-of-use page caches can be
+  moved to the parent. If you want to avoid that, force_empty will be useful.
+
+
+6. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first

