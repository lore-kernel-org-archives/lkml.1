Return-Path: <linux-kernel-owner+w=401wt.eu-S932071Ab0AESwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0AESwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251Ab0AESwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:52:34 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55678 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0AESwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:52:33 -0500
Date: Wed, 6 Jan 2010 00:22:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH -mm] Shared Page accounting for memory cgroup (v2)
Message-ID: <20100105185226.GG3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

No major changes from v1, except for the use of get_mm_rss().
Kamezawa-San felt that this can be done in user space and I responded
to him with my concerns of doing it in user space. The thread
can be found at http://thread.gmane.org/gmane.linux.kernel.mm/42367.

If there are no major objections, can I ask for a merge into -mm.
Andrew, the patches are against mmotm 10 December 2009, if there
are some merge conflicts, please let me know, I can rebase after
you release the next mmotm.


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
 mm/memcontrol.c                  |   42 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)


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
index 488b644..e49b47a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3052,6 +3052,44 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
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
+		total_rss += get_mm_rss(mm);
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
@@ -3101,6 +3139,10 @@ static struct cftype mem_cgroup_files[] = {
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
