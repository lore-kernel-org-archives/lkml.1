Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbYKMQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbYKMQmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYKMQmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:42:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:34233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbYKMQmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:42:04 -0500
Date: Thu, 13 Nov 2008 17:42:01 +0100
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: [PATCH] Dynamically allocate struct mem_cgroup_stat_cpu memory
Message-ID: <20081113164201.GV29067@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When increasing NR_CPUS to 4096 the size of struct mem_cgroup is growing to
507904 bytes per instance on x86_64. This patch changes the allocation of
struct mem_cgroup_stat_cpu to be based on the number of configured CPUs during
boot time. The init_mem_cgroup still is that huge since it stays statically
allocated and therefore uses the compile-time maximum.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 mm/memcontrol.c |   52 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)

Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -59,7 +59,7 @@ struct mem_cgroup_stat_cpu {
 } ____cacheline_aligned_in_smp;
 
 struct mem_cgroup_stat {
-	struct mem_cgroup_stat_cpu cpustat[NR_CPUS];
+	struct mem_cgroup_stat_cpu *cpustat;
 };
 
 /*
@@ -142,7 +142,10 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_stat stat;
 };
-static struct mem_cgroup init_mem_cgroup;
+static struct mem_cgroup_stat_cpu init_mem_cgroup_stat_cpu[NR_CPUS];
+static struct mem_cgroup init_mem_cgroup = {
+	.stat = { .cpustat = init_mem_cgroup_stat_cpu },
+};
 
 /*
  * We use the lower bit of the page->page_cgroup pointer as a bit spin
@@ -1097,23 +1100,54 @@ static void free_mem_cgroup_per_zone_inf
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *mem;
+	struct mem_cgroup_stat_cpu *cpustat;
+	size_t statsize = nr_cpu_ids * sizeof(*cpustat);
 
-	if (sizeof(*mem) < PAGE_SIZE)
-		mem = kmalloc(sizeof(*mem), GFP_KERNEL);
-	else
+	if (sizeof(*mem) > PAGE_SIZE) {
 		mem = vmalloc(sizeof(*mem));
-
-	if (mem)
+		if (!mem)
+			goto out;
 		memset(mem, 0, sizeof(*mem));
+	} else
+		mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+
+	if (!mem)
+		goto out;
+
+	if (statsize > PAGE_SIZE) {
+		cpustat = vmalloc(statsize);
+		if (!cpustat)
+			goto out_mem;
+		memset(cpustat, 0, statsize);
+	} else
+		cpustat = kzalloc(statsize, GFP_KERNEL);
+
+	if (!cpustat)
+		goto out_mem;
+
+	mem->stat.cpustat = cpustat;
 	return mem;
+
+out_mem:
+	if (is_vmalloc_addr(mem))
+		vfree(mem);
+	else
+		kfree(mem);
+out:
+	return NULL;
 }
 
 static void mem_cgroup_free(struct mem_cgroup *mem)
 {
-	if (sizeof(*mem) < PAGE_SIZE)
-		kfree(mem);
+	if (is_vmalloc_addr(mem->stat.cpustat))
+		vfree(mem->stat.cpustat);
 	else
+		kfree(mem->stat.cpustat);
+
+	if (is_vmalloc_addr(mem))
 		vfree(mem);
+	else
+		kfree(mem);
 }
 
 
