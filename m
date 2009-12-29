Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbZL2S1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbZL2S1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZL2S1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:27:51 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:59412 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZL2S1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:27:50 -0500
Date: Tue, 29 Dec 2009 23:57:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC] Shared page accounting for memory cgroup
Message-ID: <20091229182743.GB12533@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Everyone,

I've been working on heuristics for shared page accounting for the
memory cgroup. I've tested the patches by creating multiple cgroups
and running programs that share memory and observed the output.

Comments?


Add shared accounting to memcg

From: Balbir Singh <balbir@linux.vnet.ibm.com>

Currently there is no accurate way of estimating how many pages are
shared in a memory cgroup. The accurate way of accounting shared memory
is to

1. Either follow every page rmap and track number of users
2. Iterate through the pages and use _mapcount

We take an intermediate approach (suggested by Kamezawa), we sum up
the file and anon rss of the mm's belonging to the cgroup and then
subtract the values of anon rss and file mapped. This should give
us a good estimate of the pages being shared.

The shared statistic is called memory.shared_usage_in_bytes and
does not support hierarchical information, just the information
for the current cgroup.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/cgroups/memory.txt |    6 +++++
 mm/memcontrol.c                  |   43 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)


diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index b871f25..c2c70c9 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -341,6 +341,12 @@ Note:
   - a cgroup which uses hierarchy and it has child cgroup.
   - a cgroup which uses hierarchy and not the root of hierarchy.
 
+5.4 shared_usage_in_bytes
+  This data lists the number of shared bytes. The data provided
+  provides an approximation based on the anon and file rss counts
+  of all the mm's belonging to the cgroup. The sum above is subtracted
+  from the count of rss and file mapped count maintained within the
+  memory cgroup statistics (see section 5.2).
 
 6. Hierarchy support
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 488b644..8e296be 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3052,6 +3052,45 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static u64 mem_cgroup_shared_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	struct cgroup_iter it;
+	struct task_struct *tsk;
+	u64 total_rss = 0, shared;
+	struct mm_struct *mm;
+	s64 val;
+
+	cgroup_iter_start(cgrp, &it);
+	val = mem_cgroup_read_stat(&memcg->stat, MEM_CGROUP_STAT_RSS);
+	val += mem_cgroup_read_stat(&memcg->stat, MEM_CGROUP_STAT_FILE_MAPPED);
+	while ((tsk = cgroup_iter_next(cgrp, &it))) {
+		if (!thread_group_leader(tsk))
+			continue;
+		mm = tsk->mm;
+		/*
+		 * We can't use get_task_mm(), since mmput() its counterpart
+		 * can sleep. We know that mm can't become invalid since
+		 * we hold the css_set_lock (see cgroup_iter_start()).
+		 */
+		if (tsk->flags & PF_KTHREAD || !mm)
+			continue;
+		total_rss += get_mm_counter(mm, file_rss) +
+				get_mm_counter(mm, anon_rss);
+	}
+	cgroup_iter_end(cgrp, &it);
+
+	/*
+	 * We need to tolerate negative values due to the difference in
+	 * time of calculating total_rss and val, but the shared value
+	 * converges to the correct value quite soon depending on the changing
+	 * memory usage of the workload running in the memory cgroup.
+	 */
+	shared = total_rss - val;
+	shared = max_t(s64, 0, shared);
+	shared <<= PAGE_SHIFT;
+	return shared;
+}
 
 static struct cftype mem_cgroup_files[] = {
 	{
@@ -3101,6 +3140,10 @@ static struct cftype mem_cgroup_files[] = {
 		.read_u64 = mem_cgroup_swappiness_read,
 		.write_u64 = mem_cgroup_swappiness_write,
 	},
+	{
+		.name = "shared_usage_in_bytes",
+		.read_u64 = mem_cgroup_shared_read,
+	},
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP

-- 
	Balbir
