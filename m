Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZIXAxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZIXAxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZIXAxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:53:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:54012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZIXAxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:53:48 -0400
Message-ID: <4ABAC2F1.3020302@kernel.org>
Date: Thu, 24 Sep 2009 09:53:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tony Vroon <tony@linx.net>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] percpu: make pcpu_setup_first_chunk() failures more verbose
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 00:53:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameters to pcpu_setup_first_chunk() come from different sources
depending on architecture and can be quite complex.  The function runs
various sanity checks on the parameters and triggers BUG() if
something isn't right.  However, this is very early during the boot
and not reporting exactly what the problem is makes debugging even
harder.

Add PCPU_SETUP_BUG() macro which prints out enough information about
the parameters.  As the macro still puts separate BUG() for each
check, it won't lose any information even on the situations where only
the program counter can be retrieved.

While at it, also bump pcpu_dump_alloc_info() message to KERN_INFO so
that it's visible on the console if boot fails to complete.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Here's more complete version to make pcpu init failure more verbose.
Tony, you can also use this version but the original one should work
fine for your specific case.

If there's no objection, I'll push to Linus with other percpu fixes in
a week or so.

Thanks.

 mm/percpu.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 43d8cac..bb2ca3c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1574,6 +1574,7 @@ static void pcpu_dump_alloc_info(const char *lvl,
 int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 				  void *base_addr)
 {
+	static char cpus_buf[4096] __initdata;
 	static int smap[2], dmap[2];
 	size_t dyn_size = ai->dyn_size;
 	size_t size_sum = ai->static_size + ai->reserved_size + dyn_size;
@@ -1585,17 +1586,26 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	int *unit_map;
 	int group, unit, i;

+	cpumask_scnprintf(cpus_buf, sizeof(cpus_buf), cpu_possible_mask);
+
+#define PCPU_SETUP_BUG_ON(cond)	do {					\
+	if (unlikely(cond)) {						\
+		printk(KERN_CRIT "PERCPU: failed to initialize, %s", #cond); \
+		printk(KERN_CRIT "PERCPU: cpu_possible_mask=%s\n", cpus_buf); \
+		pcpu_dump_alloc_info(KERN_CRIT, ai);			\
+		BUG();							\
+	}								\
+} while (0)
+
 	/* sanity checks */
 	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC ||
 		     ARRAY_SIZE(dmap) >= PCPU_DFL_MAP_ALLOC);
-	BUG_ON(ai->nr_groups <= 0);
-	BUG_ON(!ai->static_size);
-	BUG_ON(!base_addr);
-	BUG_ON(ai->unit_size < size_sum);
-	BUG_ON(ai->unit_size & ~PAGE_MASK);
-	BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);
-
-	pcpu_dump_alloc_info(KERN_DEBUG, ai);
+	PCPU_SETUP_BUG_ON(ai->nr_groups <= 0);
+	PCPU_SETUP_BUG_ON(!ai->static_size);
+	PCPU_SETUP_BUG_ON(!base_addr);
+	PCPU_SETUP_BUG_ON(ai->unit_size < size_sum);
+	PCPU_SETUP_BUG_ON(ai->unit_size & ~PAGE_MASK);
+	PCPU_SETUP_BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);

 	/* process group information and build config tables accordingly */
 	group_offsets = alloc_bootmem(ai->nr_groups * sizeof(group_offsets[0]));
@@ -1618,8 +1628,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 			if (cpu == NR_CPUS)
 				continue;

-			BUG_ON(cpu > nr_cpu_ids || !cpu_possible(cpu));
-			BUG_ON(unit_map[cpu] != NR_CPUS);
+			PCPU_SETUP_BUG_ON(cpu > nr_cpu_ids);
+			PCPU_SETUP_BUG_ON(!cpu_possible(cpu));
+			PCPU_SETUP_BUG_ON(unit_map[cpu] != NR_CPUS);

 			unit_map[cpu] = unit + i;
 			unit_off[cpu] = gi->base_offset + i * ai->unit_size;
@@ -1632,7 +1643,11 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_nr_units = unit;

 	for_each_possible_cpu(cpu)
-		BUG_ON(unit_map[cpu] == NR_CPUS);
+		PCPU_SETUP_BUG_ON(unit_map[cpu] == NR_CPUS);
+
+	/* we're done parsing the input, undefine BUG macro and dump config */
+#undef PCPU_SETUP_BUG_ON
+	pcpu_dump_alloc_info(KERN_INFO, ai);

 	pcpu_nr_groups = ai->nr_groups;
 	pcpu_group_offsets = group_offsets;
-- 
1.6.4.2

