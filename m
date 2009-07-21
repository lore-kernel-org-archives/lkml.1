Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZGUK2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZGUK2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZGUK2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:37037 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbZGUK17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:59 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/20] percpu: use group information to allocate vmap areas sparsely
Date: Tue, 21 Jul 2009 19:26:14 +0900
Message-Id: <1248171979-29166-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:27:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ai->groups[] contains which units need to be put consecutively and at
what offset from the chunk base address.  Compile this information
into pcpu_group_offsets[] and pcpu_group_sizes[] in
pcpu_setup_first_chunk() and use them to allocate sparse vm areas
using pcpu_get_vm_areas().

This will be used to allow directly using sparse NUMA memories as
percpu areas.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
---
 mm/percpu.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 7b5e194..cc9c4c6 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -98,7 +98,7 @@ struct pcpu_chunk {
 	int			map_used;	/* # of map entries used */
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
-	struct vm_struct	*vm;		/* mapped vmalloc region */
+	struct vm_struct	**vms;		/* mapped vmalloc regions */
 	bool			immutable;	/* no [de]population allowed */
 	unsigned long		populated[];	/* populated bitmap */
 };
@@ -106,7 +106,7 @@ struct pcpu_chunk {
 static int pcpu_unit_pages __read_mostly;
 static int pcpu_unit_size __read_mostly;
 static int pcpu_nr_units __read_mostly;
-static int pcpu_chunk_size __read_mostly;
+static int pcpu_atom_size __read_mostly;
 static int pcpu_nr_slots __read_mostly;
 static size_t pcpu_chunk_struct_size __read_mostly;
 
@@ -121,6 +121,11 @@ EXPORT_SYMBOL_GPL(pcpu_base_addr);
 static const int *pcpu_unit_map __read_mostly;		/* cpu -> unit */
 const unsigned long *pcpu_unit_offsets __read_mostly;	/* cpu -> unit offset */
 
+/* group information, used for vm allocation */
+static int pcpu_nr_groups __read_mostly;
+static const unsigned long *pcpu_group_offsets __read_mostly;
+static const size_t *pcpu_group_sizes __read_mostly;
+
 /*
  * The first chunk which always exists.  Note that unlike other
  * chunks, this one can be allocated and mapped in several different
@@ -988,8 +993,8 @@ static void free_pcpu_chunk(struct pcpu_chunk *chunk)
 {
 	if (!chunk)
 		return;
-	if (chunk->vm)
-		free_vm_area(chunk->vm);
+	if (chunk->vms)
+		pcpu_free_vm_areas(chunk->vms, pcpu_nr_groups);
 	pcpu_mem_free(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]));
 	kfree(chunk);
 }
@@ -1006,8 +1011,10 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
 	chunk->map[chunk->map_used++] = pcpu_unit_size;
 
-	chunk->vm = get_vm_area(pcpu_chunk_size, GFP_KERNEL);
-	if (!chunk->vm) {
+	chunk->vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
+				       pcpu_nr_groups, pcpu_atom_size,
+				       GFP_KERNEL);
+	if (!chunk->vms) {
 		free_pcpu_chunk(chunk);
 		return NULL;
 	}
@@ -1015,7 +1022,7 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 	INIT_LIST_HEAD(&chunk->list);
 	chunk->free_size = pcpu_unit_size;
 	chunk->contig_hint = pcpu_unit_size;
-	chunk->base_addr = chunk->vm->addr;
+	chunk->base_addr = chunk->vms[0]->addr - pcpu_group_offsets[0];
 
 	return chunk;
 }
@@ -1571,6 +1578,8 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	size_t dyn_size = ai->dyn_size;
 	size_t size_sum = ai->static_size + ai->reserved_size + dyn_size;
 	struct pcpu_chunk *schunk, *dchunk = NULL;
+	unsigned long *group_offsets;
+	size_t *group_sizes;
 	unsigned long *unit_off;
 	unsigned int cpu;
 	int *unit_map;
@@ -1588,7 +1597,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 	pcpu_dump_alloc_info(KERN_DEBUG, ai);
 
-	/* determine number of units and initialize unit_map and base */
+	/* process group information and build config tables accordingly */
+	group_offsets = alloc_bootmem(ai->nr_groups * sizeof(group_offsets[0]));
+	group_sizes = alloc_bootmem(ai->nr_groups * sizeof(group_sizes[0]));
 	unit_map = alloc_bootmem(nr_cpu_ids * sizeof(unit_map[0]));
 	unit_off = alloc_bootmem(nr_cpu_ids * sizeof(unit_off[0]));
 
@@ -1599,6 +1610,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	for (group = 0, unit = 0; group < ai->nr_groups; group++, unit += i) {
 		const struct pcpu_group_info *gi = &ai->groups[group];
 
+		group_offsets[group] = gi->base_offset;
+		group_sizes[group] = gi->nr_units * ai->unit_size;
+
 		for (i = 0; i < gi->nr_units; i++) {
 			cpu = gi->cpu_map[i];
 			if (cpu == NR_CPUS)
@@ -1620,13 +1634,16 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	for_each_possible_cpu(cpu)
 		BUG_ON(unit_map[cpu] == NR_CPUS);
 
+	pcpu_nr_groups = ai->nr_groups;
+	pcpu_group_offsets = group_offsets;
+	pcpu_group_sizes = group_sizes;
 	pcpu_unit_map = unit_map;
 	pcpu_unit_offsets = unit_off;
 
 	/* determine basic parameters */
 	pcpu_unit_pages = ai->unit_size >> PAGE_SHIFT;
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
-	pcpu_chunk_size = pcpu_nr_units * pcpu_unit_size;
+	pcpu_atom_size = ai->atom_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
 		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);
 
-- 
1.6.0.2

