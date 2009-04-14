Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZDNXXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZDNXXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 19:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZDNXXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 19:23:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57043 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZDNXXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 19:23:34 -0400
Subject: [RFC][PATCH] alloc_percpu() UP optimization
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, akpm@osdl.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 14 Apr 2009 16:23:30 -0700
Message-Id: <20090414232330.BEF73372@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin's read-only bind mount optimization patches gave me
an idea.  For those patches we have an int counter allocated
with alloc_percpu().  But, to optimize the UP case, we needed a
bunch of #ifdefs to store a plain 'int' instead of a percpu
pointer to one.

That seems like a common enough problem that I figured we
should just solve it generically.  What this patch does is
detect when the percpu data can fit into the pointer that we
already have for it.  If it can, we just use the pointer to
store the data intead of dynamically allocating and pointing
to it.

This requires an interface change, namely replacing
alloc_percpu() with fill_percpu() which takes the address
to the pointer instead of returning the newly-allocated
structure and assigning it to the pointer.

I'm not super-happy with how this looks with all of the void**
and so forth, but it is ugly on a pretty small scale at least.
It somehow makes SMP text a wee bit smaller, but bloats UP
text by ~140 bytes.  (gcc 4.2.4)

This boots for me on i386 UP and SMP.

SMP before/after:
text	   data	    bss	    dec	
4188372	1963544	5447680	11599596
4188356	1963544	5447680	11599580

UP before/after:
text	   data	    bss	    dec
3059610	 254340	4460544	7774494
3059748	 254340	4460544	7774632


---

 linux-2.6.git-dave/arch/x86/kernel/acpi/cstate.c              |    2 
 linux-2.6.git-dave/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 
 linux-2.6.git-dave/crypto/cryptd.c                            |    2 
 linux-2.6.git-dave/drivers/dma/dmaengine.c                    |    4 -
 linux-2.6.git-dave/drivers/infiniband/hw/ehca/ehca_irq.c      |    2 
 linux-2.6.git-dave/drivers/net/chelsio/sge.c                  |    2 
 linux-2.6.git-dave/drivers/net/loopback.c                     |    2 
 linux-2.6.git-dave/drivers/net/veth.c                         |    2 
 linux-2.6.git-dave/fs/ext4/mballoc.c                          |    2 
 linux-2.6.git-dave/fs/nfs/client.c                            |    3 
 linux-2.6.git-dave/fs/nfs/iostat.h                            |    5 -
 linux-2.6.git-dave/fs/xfs/xfs_mount.c                         |    2 
 linux-2.6.git-dave/include/linux/genhd.h                      |    2 
 linux-2.6.git-dave/include/linux/percpu.h                     |   32 +++++++---
 linux-2.6.git-dave/include/scsi/libfc.h                       |    2 
 linux-2.6.git-dave/kernel/kexec.c                             |    2 
 linux-2.6.git-dave/kernel/sched.c                             |    2 
 linux-2.6.git-dave/kernel/srcu.c                              |    2 
 linux-2.6.git-dave/kernel/stop_machine.c                      |    2 
 linux-2.6.git-dave/kernel/trace/blktrace.c                    |    6 -
 linux-2.6.git-dave/kernel/trace/trace_functions_graph.c       |    3 
 linux-2.6.git-dave/kernel/workqueue.c                         |    4 -
 linux-2.6.git-dave/lib/percpu_counter.c                       |    2 
 linux-2.6.git-dave/net/core/neighbour.c                       |    2 
 linux-2.6.git-dave/net/core/sock.c                            |    2 
 linux-2.6.git-dave/net/ipv4/af_inet.c                         |    4 -
 linux-2.6.git-dave/net/ipv4/route.c                           |    2 
 linux-2.6.git-dave/net/ipv4/tcp.c                             |    2 
 linux-2.6.git-dave/net/netfilter/nf_conntrack_core.c          |    2 
 linux-2.6.git-dave/net/netfilter/nf_conntrack_ecache.c        |    2 
 linux-2.6.git-dave/net/xfrm/xfrm_ipcomp.c                     |    5 -
 31 files changed, 62 insertions(+), 48 deletions(-)

diff -puN include/linux/percpu.h~alloc-percpu-UP include/linux/percpu.h
--- linux-2.6.git/include/linux/percpu.h~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/include/linux/percpu.h	2009-04-14 16:16:39.000000000 -0700
@@ -143,29 +143,45 @@ struct percpu_data {
 extern void *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void *__pdata);
 
+#define __fill_percpu(pptr, size, align) do {	\
+	*(pptr) = __alloc_percpu(size, align);	\
+} while(0)
+
 #else /* CONFIG_SMP */
 
-#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
+static inline void *__per_cpu_ptr(void *ptr, int cpu, int size)
+{
+	void **pptr = ptr;
+	if (size <= sizeof(void *))
+		return pptr;
+	return *pptr;
+}
+#define per_cpu_ptr(ptr, cpu) ((__typeof__(ptr))__per_cpu_ptr(&ptr, cpu, sizeof(*ptr)))
 
-static inline void *__alloc_percpu(size_t size, size_t align)
+static inline void __fill_percpu(void *ptr, size_t size, size_t align)
 {
+	void **pptr = (void **)ptr;
+	if (sizeof(ptr) >= size) {
+		memset(*pptr, 0, size);
+		return;
+	}
 	/*
 	 * Can't easily make larger alignment work with kmalloc.  WARN
 	 * on it.  Larger alignment should only be used for module
 	 * percpu sections on SMP for which this path isn't used.
 	 */
 	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
-	return kzalloc(size, GFP_KERNEL);
+	*pptr = kzalloc(size, GFP_KERNEL);
 }
 
-static inline void free_percpu(void *p)
-{
-	kfree(p);
-}
+#define free_percpu(ptr) do {			\
+	if (sizeof(*ptr) > sizeof(ptr))		\
+		kfree(ptr);			\
+} while(0)
 
 #endif /* CONFIG_SMP */
 
-#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
+#define fill_percpu(pptr, type)	__fill_percpu(pptr, sizeof(type), \
 						       __alignof__(type))
 
 /*
diff -puN arch/x86/kernel/acpi/cstate.c~alloc-percpu-UP arch/x86/kernel/acpi/cstate.c
--- linux-2.6.git/arch/x86/kernel/acpi/cstate.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kernel/acpi/cstate.c	2009-04-14 16:16:39.000000000 -0700
@@ -156,7 +156,7 @@ static int __init ffh_cstate_init(void)
 	if (c->x86_vendor != X86_VENDOR_INTEL)
 		return -1;
 
-	cpu_cstate_entry = alloc_percpu(struct cstate_entry);
+	fill_percpu(&cpu_cstate_entry, struct cstate_entry);
 	return 0;
 }
 
diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~alloc-percpu-UP arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- linux-2.6.git/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2009-04-14 16:16:39.000000000 -0700
@@ -534,7 +534,7 @@ static int __init acpi_cpufreq_early_ini
 	unsigned int i;
 	dprintk("acpi_cpufreq_early_init\n");
 
-	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
+	fill_percpu(&acpi_perf_data, struct acpi_processor_performance);
 	if (!acpi_perf_data) {
 		dprintk("Memory allocation error for acpi_perf_data.\n");
 		return -ENOMEM;
diff -puN crypto/cryptd.c~alloc-percpu-UP crypto/cryptd.c
--- linux-2.6.git/crypto/cryptd.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/crypto/cryptd.c	2009-04-14 16:16:39.000000000 -0700
@@ -63,7 +63,7 @@ static int cryptd_init_queue(struct cryp
 	int cpu;
 	struct cryptd_cpu_queue *cpu_queue;
 
-	queue->cpu_queue = alloc_percpu(struct cryptd_cpu_queue);
+	fill_percpu(&queue->cpu_queue, struct cryptd_cpu_queue);
 	if (!queue->cpu_queue)
 		return -ENOMEM;
 	for_each_possible_cpu(cpu) {
diff -puN drivers/dma/dmaengine.c~alloc-percpu-UP drivers/dma/dmaengine.c
--- linux-2.6.git/drivers/dma/dmaengine.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/drivers/dma/dmaengine.c	2009-04-14 16:16:39.000000000 -0700
@@ -302,7 +302,7 @@ static int __init dma_channel_table_init
 	clear_bit(DMA_SLAVE, dma_cap_mask_all.bits);
 
 	for_each_dma_cap_mask(cap, dma_cap_mask_all) {
-		channel_table[cap] = alloc_percpu(struct dma_chan_tbl_ent);
+		fill_percpu(&channel_table[cap], struct dma_chan_tbl_ent);
 		if (!channel_table[cap]) {
 			err = -ENOMEM;
 			break;
@@ -675,7 +675,7 @@ int dma_async_device_register(struct dma
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {
 		rc = -ENOMEM;
-		chan->local = alloc_percpu(typeof(*chan->local));
+		fill_percpu(&chan->local, typeof(*chan->local));
 		if (chan->local == NULL)
 			goto err_out;
 		chan->dev = kzalloc(sizeof(*chan->dev), GFP_KERNEL);
diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~alloc-percpu-UP drivers/infiniband/hw/ehca/ehca_irq.c
--- linux-2.6.git/drivers/infiniband/hw/ehca/ehca_irq.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/drivers/infiniband/hw/ehca/ehca_irq.c	2009-04-14 16:16:39.000000000 -0700
@@ -904,7 +904,7 @@ int ehca_create_comp_pool(void)
 	spin_lock_init(&pool->last_cpu_lock);
 	pool->last_cpu = cpumask_any(cpu_online_mask);
 
-	pool->cpu_comp_tasks = alloc_percpu(struct ehca_cpu_comp_task);
+	fill_percpu(&pool->cpu_comp_tasks, struct ehca_cpu_comp_task);
 	if (pool->cpu_comp_tasks == NULL) {
 		kfree(pool);
 		return -EINVAL;
diff -puN drivers/net/chelsio/sge.c~alloc-percpu-UP drivers/net/chelsio/sge.c
--- linux-2.6.git/drivers/net/chelsio/sge.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/drivers/net/chelsio/sge.c	2009-04-14 16:16:39.000000000 -0700
@@ -2090,7 +2090,7 @@ struct sge * __devinit t1_sge_create(str
 	sge->jumbo_fl = t1_is_T1B(adapter) ? 1 : 0;
 
 	for_each_port(adapter, i) {
-		sge->port_stats[i] = alloc_percpu(struct sge_port_stats);
+		fill_percpu(&sge->port_stats[i], struct sge_port_stats);
 		if (!sge->port_stats[i])
 			goto nomem_port;
 	}
diff -puN drivers/net/loopback.c~alloc-percpu-UP drivers/net/loopback.c
--- linux-2.6.git/drivers/net/loopback.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/drivers/net/loopback.c	2009-04-14 16:16:39.000000000 -0700
@@ -127,7 +127,7 @@ static int loopback_dev_init(struct net_
 {
 	struct pcpu_lstats *lstats;
 
-	lstats = alloc_percpu(struct pcpu_lstats);
+	fill_percpu(&lstats, struct pcpu_lstats);
 	if (!lstats)
 		return -ENOMEM;
 
diff -puN drivers/net/veth.c~alloc-percpu-UP drivers/net/veth.c
--- linux-2.6.git/drivers/net/veth.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/drivers/net/veth.c	2009-04-14 16:16:39.000000000 -0700
@@ -282,7 +282,7 @@ static int veth_dev_init(struct net_devi
 	struct veth_net_stats *stats;
 	struct veth_priv *priv;
 
-	stats = alloc_percpu(struct veth_net_stats);
+	fill_percpu(&stats, struct veth_net_stats);
 	if (stats == NULL)
 		return -ENOMEM;
 
diff -puN fs/ext4/mballoc.c~alloc-percpu-UP fs/ext4/mballoc.c
--- linux-2.6.git/fs/ext4/mballoc.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/fs/ext4/mballoc.c	2009-04-14 16:16:39.000000000 -0700
@@ -2737,7 +2737,7 @@ int ext4_mb_init(struct super_block *sb,
 	sbi->s_mb_history_filter = EXT4_MB_HISTORY_DEFAULT;
 	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
 
-	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
+	fill_percpu(&sbi->s_locality_groups, struct ext4_locality_group);
 	if (sbi->s_locality_groups == NULL) {
 		kfree(sbi->s_mb_offsets);
 		kfree(sbi->s_mb_maxs);
diff -puN fs/nfs/client.c~alloc-percpu-UP fs/nfs/client.c
--- linux-2.6.git/fs/nfs/client.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/fs/nfs/client.c	2009-04-14 16:16:39.000000000 -0700
@@ -942,7 +942,8 @@ static struct nfs_server *nfs_alloc_serv
 
 	atomic_set(&server->active, 0);
 
-	server->io_stats = nfs_alloc_iostats();
+	fill_percpu(&server->io_stats, struct nfs_iostats);
+
 	if (!server->io_stats) {
 		kfree(server);
 		return NULL;
diff -puN fs/nfs/iostat.h~alloc-percpu-UP fs/nfs/iostat.h
--- linux-2.6.git/fs/nfs/iostat.h~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/fs/nfs/iostat.h	2009-04-14 16:16:39.000000000 -0700
@@ -75,11 +75,6 @@ static inline void nfs_add_fscache_stats
 }
 #endif
 
-static inline struct nfs_iostats *nfs_alloc_iostats(void)
-{
-	return alloc_percpu(struct nfs_iostats);
-}
-
 static inline void nfs_free_iostats(struct nfs_iostats *stats)
 {
 	if (stats != NULL)
diff -puN fs/xfs/xfs_mount.c~alloc-percpu-UP fs/xfs/xfs_mount.c
--- linux-2.6.git/fs/xfs/xfs_mount.c~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/fs/xfs/xfs_mount.c	2009-04-14 16:16:39.000000000 -0700
@@ -1999,7 +1999,7 @@ xfs_icsb_init_counters(
 	xfs_icsb_cnts_t *cntp;
 	int		i;
 
-	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
+	fill_percpu(&mp->m_sb_cnts, xfs_icsb_cnts_t);
 	if (mp->m_sb_cnts == NULL)
 		return -ENOMEM;
 
diff -puN include/linux/genhd.h~alloc-percpu-UP include/linux/genhd.h
--- linux-2.6.git/include/linux/genhd.h~alloc-percpu-UP	2009-04-14 16:16:38.000000000 -0700
+++ linux-2.6.git-dave/include/linux/genhd.h	2009-04-14 16:16:39.000000000 -0700
@@ -269,7 +269,7 @@ static inline void part_stat_set_all(str
 
 static inline int init_part_stats(struct hd_struct *part)
 {
-	part->dkstats = alloc_percpu(struct disk_stats);
+	fill_percpu(&part->dkstats, struct disk_stats);
 	if (!part->dkstats)
 		return 0;
 	return 1;
diff -puN include/scsi/libfc.h~alloc-percpu-UP include/scsi/libfc.h
--- linux-2.6.git/include/scsi/libfc.h~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/include/scsi/libfc.h	2009-04-14 16:16:39.000000000 -0700
@@ -722,7 +722,7 @@ static inline void fc_lport_state_enter(
 static inline int fc_lport_init_stats(struct fc_lport *lp)
 {
 	/* allocate per cpu stats block */
-	lp->dev_stats = alloc_percpu(struct fcoe_dev_stats);
+	fill_percpu(&lp->dev_stats, struct fcoe_dev_stats);
 	if (!lp->dev_stats)
 		return -ENOMEM;
 	return 0;
diff -puN kernel/kexec.c~alloc-percpu-UP kernel/kexec.c
--- linux-2.6.git/kernel/kexec.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/kernel/kexec.c	2009-04-14 16:16:39.000000000 -0700
@@ -1139,7 +1139,7 @@ void crash_save_cpu(struct pt_regs *regs
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = alloc_percpu(note_buf_t);
+	fill_percpu(&crash_notes, note_buf_t);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");
diff -puN kernel/sched.c~alloc-percpu-UP kernel/sched.c
--- linux-2.6.git/kernel/sched.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/kernel/sched.c	2009-04-14 16:16:39.000000000 -0700
@@ -10021,7 +10021,7 @@ static struct cgroup_subsys_state *cpuac
 	if (!ca)
 		goto out;
 
-	ca->cpuusage = alloc_percpu(u64);
+	fill_percpu(&ca->cpuusage, u64);
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
diff -puN kernel/srcu.c~alloc-percpu-UP kernel/srcu.c
--- linux-2.6.git/kernel/srcu.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/kernel/srcu.c	2009-04-14 16:16:39.000000000 -0700
@@ -46,7 +46,7 @@ int init_srcu_struct(struct srcu_struct 
 {
 	sp->completed = 0;
 	mutex_init(&sp->mutex);
-	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
+	fill_percpu(&sp->per_cpu_ref, struct srcu_struct_array);
 	return (sp->per_cpu_ref ? 0 : -ENOMEM);
 }
 
diff -puN kernel/stop_machine.c~alloc-percpu-UP kernel/stop_machine.c
--- linux-2.6.git/kernel/stop_machine.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/kernel/stop_machine.c	2009-04-14 16:16:39.000000000 -0700
@@ -120,7 +120,7 @@ int stop_machine_create(void)
 	stop_machine_wq = create_rt_workqueue("kstop");
 	if (!stop_machine_wq)
 		goto err_out;
-	stop_machine_work = alloc_percpu(struct work_struct);
+	fill_percpu(&stop_machine_work, struct work_struct);
 	if (!stop_machine_work)
 		goto err_out;
 done:
diff -puN kernel/trace/blktrace.c~alloc-percpu-UP kernel/trace/blktrace.c
--- linux-2.6.git/kernel/trace/blktrace.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/kernel/trace/blktrace.c	2009-04-14 16:16:39.000000000 -0700
@@ -432,11 +432,11 @@ int do_blk_trace_setup(struct request_qu
 		return -ENOMEM;
 
 	ret = -ENOMEM;
-	bt->sequence = alloc_percpu(unsigned long);
+	fill_percpu(&bt->sequence, unsigned long);
 	if (!bt->sequence)
 		goto err;
 
-	bt->msg_data = __alloc_percpu(BLK_TN_MAX_MSG, __alignof__(char));
+	__fill_percpu(&bt->msg_data, BLK_TN_MAX_MSG, __alignof__(char));
 	if (!bt->msg_data)
 		goto err;
 
@@ -1294,7 +1294,7 @@ static int blk_trace_setup_queue(struct 
 	if (!bt)
 		return -ENOMEM;
 
-	bt->msg_data = __alloc_percpu(BLK_TN_MAX_MSG, __alignof__(char));
+	__fill_percpu(&bt->msg_data, BLK_TN_MAX_MSG, __alignof__(char));
 	if (!bt->msg_data)
 		goto free_bt;
 
diff -puN kernel/trace/trace_functions_graph.c~alloc-percpu-UP kernel/trace/trace_functions_graph.c
--- linux-2.6.git/kernel/trace/trace_functions_graph.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/kernel/trace/trace_functions_graph.c	2009-04-14 16:16:39.000000000 -0700
@@ -844,9 +844,10 @@ static void print_graph_headers(struct s
 static void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
-	struct fgraph_data *data = alloc_percpu(struct fgraph_data);
+	struct fgraph_data *data;
 	int cpu;
 
+	fill_percpu(&data, struct fgraph_data);
 	if (!data)
 		pr_warning("function graph tracer: not enough memory\n");
 	else
diff -puN kernel/workqueue.c~alloc-percpu-UP kernel/workqueue.c
--- linux-2.6.git/kernel/workqueue.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/kernel/workqueue.c	2009-04-14 16:16:39.000000000 -0700
@@ -669,7 +669,7 @@ int schedule_on_each_cpu(work_func_t fun
 	int cpu;
 	struct work_struct *works;
 
-	works = alloc_percpu(struct work_struct);
+	fill_percpu(&works, struct work_struct);
 	if (!works)
 		return -ENOMEM;
 
@@ -808,7 +808,7 @@ struct workqueue_struct *__create_workqu
 	if (!wq)
 		return NULL;
 
-	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	fill_percpu(&wq->cpu_wq, struct cpu_workqueue_struct);
 	if (!wq->cpu_wq) {
 		kfree(wq);
 		return NULL;
diff -puN lib/percpu_counter.c~alloc-percpu-UP lib/percpu_counter.c
--- linux-2.6.git/lib/percpu_counter.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/lib/percpu_counter.c	2009-04-14 16:16:39.000000000 -0700
@@ -72,7 +72,7 @@ int __percpu_counter_init(struct percpu_
 	spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
+	fill_percpu(&fbc->counters, s32);
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
diff -puN net/core/neighbour.c~alloc-percpu-UP net/core/neighbour.c
--- linux-2.6.git/net/core/neighbour.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/net/core/neighbour.c	2009-04-14 16:16:39.000000000 -0700
@@ -1411,7 +1411,7 @@ void neigh_table_init_no_netlink(struct 
 			kmem_cache_create(tbl->id, tbl->entry_size, 0,
 					  SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 					  NULL);
-	tbl->stats = alloc_percpu(struct neigh_statistics);
+	fill_percpu(&tbl->stats, struct neigh_statistics);
 	if (!tbl->stats)
 		panic("cannot create neighbour cache statistics");
 
diff -puN net/core/sock.c~alloc-percpu-UP net/core/sock.c
--- linux-2.6.git/net/core/sock.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/net/core/sock.c	2009-04-14 16:16:39.000000000 -0700
@@ -2025,7 +2025,7 @@ EXPORT_SYMBOL_GPL(sock_prot_inuse_get);
 
 static int sock_inuse_init_net(struct net *net)
 {
-	net->core.inuse = alloc_percpu(struct prot_inuse);
+	fill_percpu(&net->core.inuse, struct prot_inuse);
 	return net->core.inuse ? 0 : -ENOMEM;
 }
 
diff -puN net/ipv4/af_inet.c~alloc-percpu-UP net/ipv4/af_inet.c
--- linux-2.6.git/net/ipv4/af_inet.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/net/ipv4/af_inet.c	2009-04-14 16:16:39.000000000 -0700
@@ -1375,10 +1375,10 @@ EXPORT_SYMBOL_GPL(snmp_fold_field);
 int snmp_mib_init(void *ptr[2], size_t mibsize)
 {
 	BUG_ON(ptr == NULL);
-	ptr[0] = __alloc_percpu(mibsize, __alignof__(unsigned long long));
+	__fill_percpu(&ptr[0], mibsize, __alignof__(unsigned long long));
 	if (!ptr[0])
 		goto err0;
-	ptr[1] = __alloc_percpu(mibsize, __alignof__(unsigned long long));
+	__fill_percpu(&ptr[1], mibsize, __alignof__(unsigned long long));
 	if (!ptr[1])
 		goto err1;
 	return 0;
diff -puN net/ipv4/route.c~alloc-percpu-UP net/ipv4/route.c
--- linux-2.6.git/net/ipv4/route.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/net/ipv4/route.c	2009-04-14 16:16:39.000000000 -0700
@@ -3377,7 +3377,7 @@ int __init ip_rt_init(void)
 	int rc = 0;
 
 #ifdef CONFIG_NET_CLS_ROUTE
-	ip_rt_acct = __alloc_percpu(256 * sizeof(struct ip_rt_acct), __alignof__(struct ip_rt_acct));
+	__fill_percpu(&ip_rt_acct, 256 * sizeof(struct ip_rt_acct), __alignof__(struct ip_rt_acct));
 	if (!ip_rt_acct)
 		panic("IP: failed to allocate ip_rt_acct\n");
 #endif
diff -puN net/ipv4/tcp.c~alloc-percpu-UP net/ipv4/tcp.c
--- linux-2.6.git/net/ipv4/tcp.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/net/ipv4/tcp.c	2009-04-14 16:16:39.000000000 -0700
@@ -2646,7 +2646,7 @@ static struct tcp_md5sig_pool **__tcp_al
 	int cpu;
 	struct tcp_md5sig_pool **pool;
 
-	pool = alloc_percpu(struct tcp_md5sig_pool *);
+	fill_percpu(&pool, struct tcp_md5sig_pool *);
 	if (!pool)
 		return NULL;
 
diff -puN net/netfilter/nf_conntrack_core.c~alloc-percpu-UP net/netfilter/nf_conntrack_core.c
--- linux-2.6.git/net/netfilter/nf_conntrack_core.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/net/netfilter/nf_conntrack_core.c	2009-04-14 16:16:39.000000000 -0700
@@ -1226,7 +1226,7 @@ static int nf_conntrack_init_net(struct 
 
 	atomic_set(&net->ct.count, 0);
 	INIT_HLIST_NULLS_HEAD(&net->ct.unconfirmed, 0);
-	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
+	fill_percpu(&net->ct.stat, struct ip_conntrack_stat);
 	if (!net->ct.stat) {
 		ret = -ENOMEM;
 		goto err_stat;
diff -puN net/netfilter/nf_conntrack_ecache.c~alloc-percpu-UP net/netfilter/nf_conntrack_ecache.c
--- linux-2.6.git/net/netfilter/nf_conntrack_ecache.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/net/netfilter/nf_conntrack_ecache.c	2009-04-14 16:16:39.000000000 -0700
@@ -100,7 +100,7 @@ void nf_ct_event_cache_flush(struct net 
 
 int nf_conntrack_ecache_init(struct net *net)
 {
-	net->ct.ecache = alloc_percpu(struct nf_conntrack_ecache);
+	fill_percpu(&net->ct.ecache, struct nf_conntrack_ecache);
 	if (!net->ct.ecache)
 		return -ENOMEM;
 	return 0;
diff -puN net/xfrm/xfrm_ipcomp.c~alloc-percpu-UP net/xfrm/xfrm_ipcomp.c
--- linux-2.6.git/net/xfrm/xfrm_ipcomp.c~alloc-percpu-UP	2009-04-14 16:16:39.000000000 -0700
+++ linux-2.6.git-dave/net/xfrm/xfrm_ipcomp.c	2009-04-14 16:16:39.000000000 -0700
@@ -223,7 +223,7 @@ static void **ipcomp_alloc_scratches(voi
 	if (ipcomp_scratch_users++)
 		return ipcomp_scratches;
 
-	scratches = alloc_percpu(void *);
+	fill_percpu(&scratches, void *);
 	if (!scratches)
 		return NULL;
 
@@ -296,9 +296,10 @@ static struct crypto_comp **ipcomp_alloc
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
+	fill_percpu(&tfms, struct crypto_comp *);
 	if (!tfms)
 		goto error;
+	pos->tfms = tfms;
 
 	for_each_possible_cpu(cpu) {
 		struct crypto_comp *tfm = crypto_alloc_comp(alg_name, 0,
_
