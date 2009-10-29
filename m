Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZJ2LEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZJ2LEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 07:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZJ2LEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 07:04:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:54117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbZJ2LEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 07:04:53 -0400
Message-ID: <4AE9770A.90208@kernel.org>
Date: Thu, 29 Oct 2009 12:05:46 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] percpu fixes for 2.6.32-rc5
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following percpu fix branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

It makes sched size and allocate update_shares_data percpu array
dynamically instead of defining it as static array containing NR_CPUS
elements.  On large NR_CPUS configurations, NR_CPUS sized percpu array
wastes considerable amount of memory and also ended up breaking ia64
build because ia64 currently has limit on static percpu size (64k, can
be easily increased tho).

Thanks.
---
Jiri Kosina (2):
      percpu: allow pcpu_alloc() to be called with IRQs off
      sched: move rq_weight data array out of .percpu

 kernel/sched.c |   22 +++++++++++-----------
 mm/percpu.c    |   30 +++++++++++++++++-------------
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ee61f45..526d237 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1563,11 +1563,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-struct update_shares_data {
-	unsigned long rq_weight[NR_CPUS];
-};
-
-static DEFINE_PER_CPU(struct update_shares_data, update_shares_data);
+static __read_mostly unsigned long *update_shares_data;
 
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
 
@@ -1577,12 +1573,12 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares);
 static void update_group_shares_cpu(struct task_group *tg, int cpu,
 				    unsigned long sd_shares,
 				    unsigned long sd_rq_weight,
-				    struct update_shares_data *usd)
+				    unsigned long *usd_rq_weight)
 {
 	unsigned long shares, rq_weight;
 	int boost = 0;
 
-	rq_weight = usd->rq_weight[cpu];
+	rq_weight = usd_rq_weight[cpu];
 	if (!rq_weight) {
 		boost = 1;
 		rq_weight = NICE_0_LOAD;
@@ -1617,7 +1613,7 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
 static int tg_shares_up(struct task_group *tg, void *data)
 {
 	unsigned long weight, rq_weight = 0, shares = 0;
-	struct update_shares_data *usd;
+	unsigned long *usd_rq_weight;
 	struct sched_domain *sd = data;
 	unsigned long flags;
 	int i;
@@ -1626,11 +1622,11 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		return 0;
 
 	local_irq_save(flags);
-	usd = &__get_cpu_var(update_shares_data);
+	usd_rq_weight = per_cpu_ptr(update_shares_data, smp_processor_id());
 
 	for_each_cpu(i, sched_domain_span(sd)) {
 		weight = tg->cfs_rq[i]->load.weight;
-		usd->rq_weight[i] = weight;
+		usd_rq_weight[i] = weight;
 
 		/*
 		 * If there are currently no tasks on the cpu pretend there
@@ -1651,7 +1647,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		shares = tg->shares;
 
 	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight, usd);
+		update_group_shares_cpu(tg, i, shares, rq_weight, usd_rq_weight);
 
 	local_irq_restore(flags);
 
@@ -9406,6 +9402,10 @@ void __init sched_init(void)
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_GROUP_SCHED */
 
+#if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
+	update_shares_data = __alloc_percpu(nr_cpu_ids * sizeof(unsigned long),
+					    __alignof__(unsigned long));
+#endif
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
diff --git a/mm/percpu.c b/mm/percpu.c
index 6af78c1..d907971 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -153,7 +153,10 @@ static int pcpu_reserved_chunk_limit;
  *
  * During allocation, pcpu_alloc_mutex is kept locked all the time and
  * pcpu_lock is grabbed and released as necessary.  All actual memory
- * allocations are done using GFP_KERNEL with pcpu_lock released.
+ * allocations are done using GFP_KERNEL with pcpu_lock released.  In
+ * general, percpu memory can't be allocated with irq off but
+ * irqsave/restore are still used in alloc path so that it can be used
+ * from early init path - sched_init() specifically.
  *
  * Free path accesses and alters only the index data structures, so it
  * can be safely called from atomic context.  When memory needs to be
@@ -366,7 +369,7 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
  * RETURNS:
  * 0 if noop, 1 if successfully extended, -errno on failure.
  */
-static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
+static int pcpu_extend_area_map(struct pcpu_chunk *chunk, unsigned long *flags)
 {
 	int new_alloc;
 	int *new;
@@ -376,7 +379,7 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
 	if (chunk->map_alloc >= chunk->map_used + 2)
 		return 0;
 
-	spin_unlock_irq(&pcpu_lock);
+	spin_unlock_irqrestore(&pcpu_lock, *flags);
 
 	new_alloc = PCPU_DFL_MAP_ALLOC;
 	while (new_alloc < chunk->map_used + 2)
@@ -384,7 +387,7 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
 
 	new = pcpu_mem_alloc(new_alloc * sizeof(new[0]));
 	if (!new) {
-		spin_lock_irq(&pcpu_lock);
+		spin_lock_irqsave(&pcpu_lock, *flags);
 		return -ENOMEM;
 	}
 
@@ -393,7 +396,7 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
 	 * could have happened inbetween, so map_used couldn't have
 	 * grown.
 	 */
-	spin_lock_irq(&pcpu_lock);
+	spin_lock_irqsave(&pcpu_lock, *flags);
 	BUG_ON(new_alloc < chunk->map_used + 2);
 
 	size = chunk->map_alloc * sizeof(chunk->map[0]);
@@ -1047,6 +1050,7 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 	struct pcpu_chunk *chunk;
 	const char *err;
 	int slot, off;
+	unsigned long flags;
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
@@ -1055,13 +1059,13 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 	}
 
 	mutex_lock(&pcpu_alloc_mutex);
-	spin_lock_irq(&pcpu_lock);
+	spin_lock_irqsave(&pcpu_lock, flags);
 
 	/* serve reserved allocations from the reserved chunk if available */
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
 		if (size > chunk->contig_hint ||
-		    pcpu_extend_area_map(chunk) < 0) {
+		    pcpu_extend_area_map(chunk, &flags) < 0) {
 			err = "failed to extend area map of reserved chunk";
 			goto fail_unlock;
 		}
@@ -1079,7 +1083,7 @@ restart:
 			if (size > chunk->contig_hint)
 				continue;
 
-			switch (pcpu_extend_area_map(chunk)) {
+			switch (pcpu_extend_area_map(chunk, &flags)) {
 			case 0:
 				break;
 			case 1:
@@ -1096,7 +1100,7 @@ restart:
 	}
 
 	/* hmmm... no space left, create a new chunk */
-	spin_unlock_irq(&pcpu_lock);
+	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	chunk = alloc_pcpu_chunk();
 	if (!chunk) {
@@ -1104,16 +1108,16 @@ restart:
 		goto fail_unlock_mutex;
 	}
 
-	spin_lock_irq(&pcpu_lock);
+	spin_lock_irqsave(&pcpu_lock, flags);
 	pcpu_chunk_relocate(chunk, -1);
 	goto restart;
 
 area_found:
-	spin_unlock_irq(&pcpu_lock);
+	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	/* populate, map and clear the area */
 	if (pcpu_populate_chunk(chunk, off, size)) {
-		spin_lock_irq(&pcpu_lock);
+		spin_lock_irqsave(&pcpu_lock, flags);
 		pcpu_free_area(chunk, off);
 		err = "failed to populate";
 		goto fail_unlock;
@@ -1125,7 +1129,7 @@ area_found:
 	return __addr_to_pcpu_ptr(chunk->base_addr + off);
 
 fail_unlock:
-	spin_unlock_irq(&pcpu_lock);
+	spin_unlock_irqrestore(&pcpu_lock, flags);
 fail_unlock_mutex:
 	mutex_unlock(&pcpu_alloc_mutex);
 	if (warn_limit) {
