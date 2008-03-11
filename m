Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYCKOef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYCKOef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYCKOeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:34:20 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:36979 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYCKOeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:34:15 -0400
Message-ID: <47D6984B.5040108@mandic.com.br>
Date: Tue, 11 Mar 2008 11:33:47 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       linux-kernel@vger.kernel.org, alan-jenkins@tuffmail.co.uk,
       devzero@web.de, mingo@elte.hu
Subject: Re: Kernel Linux 2.6.23.16 hangs when run updatedb
References: <47D54A8B.2020303@mandic.com.br> <alpine.LFD.1.00.0803110803280.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803110803280.3781@apollo.tec.linutronix.de>
Content-Type: multipart/mixed;
 boundary="------------020402080701000302020407"
X-Mandic-no-Celular-to: renatoyamane@mandic.com.br
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020402080701000302020407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Thomas,


Thomas Gleixner wrote:
> Renato, some questions:
> 1) is this fully reproducible with updatedb ?

Yes, this crash is fully reproducible.
All time wich I turn-on my laptopt I need kill find daemon in my Debian 
Etch. If I don't do that, my laptop hangs.

> 2) are you sure that this is the first stacktrace you captured, there
> might be some BUG before that which scrolled out of sight. Any chance
> to use a serial console?

I can't use scroll, because none key/mouse work after crash.
And, sorry I can't use a serial console. Any other idea?

> 3) Can you please recompile the kernel with CONFIF_DEBUG_INFO set
> and then run the following addresses from the backtrace through
> addr2line with the new vmlinux:
> # addr2line -e vmlinux 0xc013dad9 0xc0107c3b

Yes, I try compile 2.6.24.3 without any patch.

> 4) Looking at your .config it seems you have some more patches applied
> aside of the .16 stable. Can you please upload a full patch queue
> somewhere ?

I attached all patchs used in my 2.6.23.16.

Regards,
Renato S. Yamane


================

--------------020402080701000302020407
Content-Type: text/x-diff;
 name="enable-4k-stacks-default-2.6.23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="enable-4k-stacks-default-2.6.23.patch"

--- linux-2.6.20.orig/arch/i386/Kconfig.debug 
+++ linux-2.6.20/arch/i386/Kconfig.debug 
@@ -59,6 +59,7 @@
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
+	default y
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates

--------------020402080701000302020407
Content-Type: text/x-diff;
 name="genetic-cfq-sched-2.6.23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="genetic-cfq-sched-2.6.23.patch"

Genetic I/O CFQ scheduler support.

Signed-off-by: Miguel Boton <mboton@gmail.com>

Index: linux.2.6.23/block/cfq-iosched.c
===================================================================
--- linux.2.6.23.orig/block/cfq-iosched.c
+++ linux.2.6.23/block/cfq-iosched.c
@@ -11,25 +11,45 @@
 #include <linux/elevator.h>
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
+#include <linux/genetic.h>
+#include <linux/random.h>
+#include <linux/debugfs.h>
 
 /*
  * tunables
  */
-static const int cfq_quantum = 4;		/* max queue in one round of service */
-static const int cfq_fifo_expire[2] = { HZ / 4, HZ / 8 };
-static const int cfq_back_max = 16 * 1024;	/* maximum backwards seek, in KiB */
-static const int cfq_back_penalty = 2;		/* penalty of a backwards seek */
-
-static const int cfq_slice_sync = HZ / 10;
-static int cfq_slice_async = HZ / 25;
-static const int cfq_slice_async_rq = 2;
-static int cfq_slice_idle = HZ / 125;
+#define CFQ_QUANTUM		4
+#define CFQ_FIFO_EXPIRE_ASYNC	HZ / 4
+#define CFQ_FIFO_EXPIRE_SYNC	HZ / 8
+#define CFQ_BACK_MAX		16 * 1024
+#define CFQ_BACK_PENALTY	2
+
+#define CFQ_SLICE_SYNC		HZ / 10
+#define CFQ_SLICE_ASYNC		HZ / 25
+#define CFQ_SLICE_ASYNC_RQ	2
+#define CFQ_SLICE_IDLE		HZ / 125
+
+/* max queue in one round of service */
+static int cfq_quantum		= CFQ_QUANTUM;
+static int cfq_fifo_expire[2]	=
+		{ CFQ_FIFO_EXPIRE_ASYNC, CFQ_FIFO_EXPIRE_SYNC };
+/* maximum backwards seek, in KiB */
+static int cfq_back_max		= CFQ_BACK_MAX;
+/* penalty of a backwards seek */
+static int cfq_back_penalty	= CFQ_BACK_PENALTY;
+
+static int cfq_slice_sync	= CFQ_SLICE_SYNC;
+static int cfq_slice_async	= CFQ_SLICE_ASYNC;
+static int cfq_slice_async_rq	= CFQ_SLICE_ASYNC_RQ;
+static int cfq_slice_idle	= CFQ_SLICE_IDLE;
 
 /*
  * grace period before allowing idle class to get disk access
  */
 #define CFQ_IDLE_GRACE		(HZ / 10)
 
+static int cfq_idle_grace	= CFQ_IDLE_GRACE;
+
 /*
  * below this threshold, we consider thinktime immediate
  */
@@ -115,6 +131,10 @@
 	unsigned int cfq_slice_idle;
 
 	struct list_head cic_list;
+
+#ifdef CONFIG_GENETIC_IOSCHED_CFQ
+	struct list_head data_list;
+#endif
 };
 
 /*
@@ -197,6 +217,126 @@
 CFQ_CFQQ_FNS(sync);
 #undef CFQ_CFQQ_FNS
 
+#ifdef CONFIG_GENETIC_IOSCHED_CFQ
+
+struct disk_stats_snapshot *cfq_stats_snapshot;
+
+extern void disk_stats_snapshot(phenotype_t *pt);
+#ifdef CONFIG_FINGERPRINTING
+extern void disk_get_fingerprint(phenotype_t *pt);
+extern void disk_update_fingerprint(phenotype_t *pt);
+extern void *cfq_create_genes(phenotype_t *pt);
+#endif
+
+static void cfq_num_ops_create_child(genetic_child_t *child);
+static void cfq_throughput_create_child(genetic_child_t *child);
+static void cfq_latency_create_child(genetic_child_t *child);
+static void cfq_general_create_child(genetic_child_t *child);
+
+static void cfq_general_set_child_genes(void *in_genes);
+
+static void cfq_num_ops_calc_fitness(genetic_child_t *child);
+static void cfq_throughput_calc_fitness(genetic_child_t *child);
+static void cfq_latency_calc_fitness(genetic_child_t *child);
+
+static void cfq_general_calc_post_fitness(phenotype_t *in_pt);
+
+static void cfq_shift_mutation_rate(phenotype_t *in_pt);
+
+struct genetic_ops cfq_num_ops_genetic_ops = {
+	.create_child = cfq_num_ops_create_child,
+	.calc_fitness = cfq_num_ops_calc_fitness,
+};
+
+struct genetic_ops cfq_throughput_genetic_ops = {
+	.create_child = cfq_throughput_create_child,
+	.calc_fitness = cfq_throughput_calc_fitness,
+};
+
+struct genetic_ops cfq_latency_genetic_ops = {
+	.create_child = cfq_latency_create_child,
+	.calc_fitness = cfq_latency_calc_fitness,
+};
+
+struct genetic_ops cfq_general_genetic_ops = {
+	.create_child = cfq_general_create_child,
+	.set_child_genes = cfq_general_set_child_genes,
+	.combine_genes = genetic_generic_combine_genes,
+	.mutate_child = genetic_generic_mutate_child,
+	.calc_post_fitness = cfq_general_calc_post_fitness,
+	.take_snapshot = disk_stats_snapshot,
+	.shift_mutation_rate = cfq_shift_mutation_rate,
+	.gene_show = genetic_generic_gene_show,
+#ifdef CONFIG_FINGERPRINTING
+	.get_fingerprint = disk_get_fingerprint,
+	.update_fingerprint = disk_update_fingerprint,
+	.create_top_genes = cfq_create_genes,
+	.top_fitness_show = fingerprint_top_fitness_show,
+	.snapshot_show = fingerprint_snapshot_show,
+	.state_show = fingerprint_state_show,
+#endif
+};
+
+#define CFQ_NUM_CHILDREN		8
+
+#define CFQ_NUM_OPS_UID			1
+#define CFQ_NUM_OPS_NUM_GENES		0
+
+#define CFQ_THROUGHPUT_UID		2
+#define CFQ_THROUGHPUT_NUM_GENES	0
+
+#define CFQ_LATENCY_UID			4
+#define CFQ_LATENCY_NUM_GENES		0
+
+#define CFQ_GENERAL_UID (CFQ_NUM_OPS_UID | CFQ_THROUGHPUT_UID | CFQ_LATENCY_UID)
+#define CFQ_GENERAL_NUM_GENES		11
+
+struct cfq_genes {
+	int cfq_quantum;
+	int cfq_fifo_expire_async;
+	int cfq_fifo_expire_sync;
+	int cfq_back_max;
+	int cfq_back_penalty;
+	int cfq_slice_sync;
+	int cfq_slice_async;
+	int cfq_slice_async_rq;
+	int cfq_slice_idle;
+	int cfq_idle_grace;
+	unsigned long nr_requests;
+};
+
+gene_param_t cfq_gene_param[CFQ_GENERAL_NUM_GENES] = {
+	{ "cfq_quantum",
+		CFQ_QUANTUM / 2, 3 * CFQ_QUANTUM / 2, CFQ_QUANTUM, 0 },
+	{ "cfq_fifo_expire_async",
+		CFQ_FIFO_EXPIRE_ASYNC / 2, 3 * CFQ_FIFO_EXPIRE_ASYNC / 2, CFQ_FIFO_EXPIRE_ASYNC, 0 },
+	{ "cfq_fifo_expire_sync",
+		CFQ_FIFO_EXPIRE_SYNC / 2, 3 * CFQ_FIFO_EXPIRE_SYNC / 2, CFQ_FIFO_EXPIRE_SYNC, 0 },
+	{ "cfq_back_max",
+		CFQ_BACK_MAX / 2, 3 * CFQ_BACK_MAX / 2, CFQ_BACK_MAX, 0 },
+	{ "cfq_back_penalty",
+		CFQ_BACK_PENALTY / 2, 3 * CFQ_BACK_PENALTY / 2, CFQ_BACK_PENALTY, 0 },
+	{ "cfq_slice_sync",
+		CFQ_SLICE_SYNC / 2, 3 * CFQ_SLICE_SYNC / 2, CFQ_SLICE_SYNC, 0 },
+	{ "cfq_slice_async",
+		CFQ_SLICE_ASYNC / 2, 3 * CFQ_SLICE_ASYNC / 2, CFQ_SLICE_ASYNC, 0 },
+	{ "cfq_slice_async_rq",
+		CFQ_SLICE_ASYNC_RQ / 2, 3 * CFQ_SLICE_ASYNC_RQ / 2, CFQ_SLICE_ASYNC_RQ, 0 },
+	{ "cfq_slice_idle",
+		CFQ_SLICE_IDLE / 2, 3 * CFQ_SLICE_IDLE / 2, CFQ_SLICE_IDLE, 0 },
+	{ "cfq_idle_grace",
+		CFQ_IDLE_GRACE / 2, 3 * CFQ_IDLE_GRACE / 2, CFQ_IDLE_GRACE, 0 },
+	{ "nr_requests",
+		BLKDEV_MIN_RQ, BLKDEV_MAX_RQ * 30, BLKDEV_MAX_RQ, genetic_generic_iterative_mutate_gene }
+};
+
+extern long long disk_num_ops_calc_fitness(genetic_child_t *child);
+extern long long disk_throughput_calc_fitness(genetic_child_t *child);
+extern long long disk_latency_calc_fitness(genetic_child_t *child);
+
+LIST_HEAD(cfq_data_list);
+#endif
+
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, int,
 				       struct task_struct *, gfp_t);
@@ -813,7 +942,7 @@
 		 * the grace period has passed or arm the idle grace
 		 * timer
 		 */
-		end = cfqd->last_end_request + CFQ_IDLE_GRACE;
+		end = cfqd->last_end_request + cfq_idle_grace;
 		if (time_before(jiffies, end)) {
 			mod_timer(&cfqd->idle_class_timer, end);
 			cfqq = NULL;
@@ -2045,7 +2174,7 @@
 	/*
 	 * race with a non-idle queue, reset timer
 	 */
-	end = cfqd->last_end_request + CFQ_IDLE_GRACE;
+	end = cfqd->last_end_request + cfq_idle_grace;
 	if (!time_after_eq(jiffies, end))
 		mod_timer(&cfqd->idle_class_timer, end);
 	else
@@ -2101,6 +2230,10 @@
 
 	cfq_shutdown_timer_wq(cfqd);
 
+#ifdef CONFIG_GENETIC_IOSCHED_CFQ
+	list_del(&cfqd->data_list);
+#endif
+
 	kfree(cfqd);
 }
 
@@ -2137,6 +2270,10 @@
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 
+#ifdef CONFIG_GENETIC_IOSCHED_CFQ
+	list_add_tail(&cfqd->data_list, &cfq_data_list);
+#endif
+
 	return cfqd;
 }
 
@@ -2275,6 +2412,46 @@
 {
 	int ret;
 
+#ifdef CONFIG_GENETIC_IOSCHED_CFQ
+	genetic_t *genetic = NULL;
+
+	cfq_stats_snapshot = (struct disk_stats_snapshot *)
+		kmalloc(sizeof(struct disk_stats_snapshot), GFP_KERNEL);
+	if (!cfq_stats_snapshot)
+		panic("cfq: failed to malloc enough space");
+
+	ret = genetic_init(&genetic, CFQ_NUM_CHILDREN, 2 * HZ,
+			    1, "cfq-ioscheduler");
+	if (ret)
+		panic("cfq: failed to init genetic lib");
+
+	if (genetic_register_phenotype(genetic, &cfq_num_ops_genetic_ops,
+				       CFQ_NUM_CHILDREN, "num_ops",
+				       CFQ_NUM_OPS_NUM_GENES,
+				       CFQ_NUM_OPS_UID))
+		panic("cfq: failed to register num_ops phenotype");
+
+	if (genetic_register_phenotype(genetic, &cfq_throughput_genetic_ops,
+				       CFQ_NUM_CHILDREN, "throughput",
+				       CFQ_THROUGHPUT_NUM_GENES,
+				       CFQ_THROUGHPUT_UID))
+		panic("cfq: failed to register throughput phenotype");
+
+	if (genetic_register_phenotype(genetic, &cfq_latency_genetic_ops,
+				       CFQ_NUM_CHILDREN, "latency",
+				       CFQ_LATENCY_NUM_GENES,
+				       CFQ_LATENCY_UID))
+		panic("cfq: failed to register latency phenotype");
+
+	if (genetic_register_phenotype(genetic, &cfq_general_genetic_ops,
+				       CFQ_NUM_CHILDREN, "general",
+				       CFQ_GENERAL_NUM_GENES,
+				       CFQ_GENERAL_UID))
+	panic("cfq: failed to register general phenotype");
+
+	genetic_start(genetic);
+#endif
+
 	/*
 	 * could be 0 on HZ < 1000 setups
 	 */
@@ -2306,6 +2473,201 @@
 	cfq_slab_kill();
 }
 
+#ifdef CONFIG_GENETIC_IOSCHED_CFQ
+
+static void cfq_num_ops_create_child(genetic_child_t *child)
+{
+	BUG_ON(!child);
+
+	child->genes = 0;
+	child->gene_param = 0;
+	child->num_genes = CFQ_NUM_OPS_NUM_GENES;
+	child->stats_snapshot = cfq_stats_snapshot;
+}
+
+static void cfq_throughput_create_child(genetic_child_t *child)
+{
+	BUG_ON(!child);
+
+	child->genes = 0;
+	child->gene_param = 0;
+	child->num_genes = CFQ_THROUGHPUT_NUM_GENES;
+	child->stats_snapshot = cfq_stats_snapshot;
+}
+
+static void cfq_latency_create_child(genetic_child_t *child)
+{
+	BUG_ON(!child);
+
+	child->genes = 0;
+	child->gene_param = 0;
+	child->num_genes = CFQ_LATENCY_NUM_GENES;
+	child->stats_snapshot = cfq_stats_snapshot;
+}
+
+/* need to create the genes for the child */
+static void cfq_general_create_child(genetic_child_t *child)
+{
+	BUG_ON(!child);
+
+	child->genes = kmalloc(sizeof(struct cfq_genes), GFP_KERNEL);
+	if (!child->genes)
+	panic("cfq_general_create_child: error mallocing space");
+
+	child->gene_param = cfq_gene_param;
+	child->num_genes = CFQ_GENERAL_NUM_GENES;
+	child->stats_snapshot = cfq_stats_snapshot;
+
+	genetic_create_child_spread(child, CFQ_NUM_CHILDREN-1);
+
+	((struct cfq_genes *)child->genes)->nr_requests = BLKDEV_MAX_RQ;
+}
+
+static void cfq_shift_mutation_rate(phenotype_t *in_pt)
+{
+	struct list_head *p;
+	phenotype_t *pt;
+	int count = 0;
+	long rate = 0;
+
+	list_for_each(p, &in_pt->genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+
+		/* Look at everyone else that contributes to this
+		   phenotype */
+		if (pt->uid & CFQ_GENERAL_UID && pt->uid != CFQ_GENERAL_UID) {
+
+			switch (pt->uid) {
+			case CFQ_NUM_OPS_UID:
+			case CFQ_THROUGHPUT_UID:
+			case CFQ_LATENCY_UID:
+				rate += pt->mutation_rate;
+				count++;
+				break;
+			default:
+				BUG();
+			}
+		}
+	}
+
+	/* If we are a general phenotype that is made up of other
+	   phenotypes then we take the average */
+	if (count)
+		in_pt->mutation_rate = (rate / count);
+	else
+		BUG();
+}
+
+static void cfq_general_set_child_genes(void *in_genes)
+{
+	struct cfq_genes *genes = (struct cfq_genes *)in_genes;
+	struct list_head *d;
+	struct cfq_data *cfqd;
+
+	list_for_each(d, &cfq_data_list) {
+		cfqd = list_entry(d, struct cfq_data, data_list);
+
+		cfqd->cfq_quantum = genes->cfq_quantum;
+		cfqd->cfq_fifo_expire[0] = genes->cfq_fifo_expire_async;
+		cfqd->cfq_fifo_expire[1] = genes->cfq_fifo_expire_sync;
+		cfqd->cfq_back_max = genes->cfq_back_max;
+		cfqd->cfq_back_penalty = genes->cfq_back_penalty;
+		cfqd->cfq_slice[0] = genes->cfq_slice_async;
+		cfqd->cfq_slice[1] = genes->cfq_slice_sync;
+		cfqd->cfq_slice_async_rq = genes->cfq_slice_async_rq;
+		cfqd->cfq_slice_idle = genes->cfq_slice_idle;
+		cfqd->queue->nr_requests = genes->nr_requests;
+	}
+}
+
+static void cfq_num_ops_calc_fitness(genetic_child_t *child)
+{
+	child->fitness = disk_num_ops_calc_fitness(child);
+}
+
+static void cfq_throughput_calc_fitness(genetic_child_t *child)
+{
+	child->fitness = disk_throughput_calc_fitness(child);
+}
+
+static void cfq_latency_calc_fitness(genetic_child_t *child)
+{
+	child->fitness = disk_latency_calc_fitness(child);
+}
+
+/* Make the general the one that takes into account all the fitness
+ * routines, since these are the common genes that effect everything.
+ */
+static void cfq_general_calc_post_fitness(phenotype_t *in_pt)
+{
+	struct list_head *p;
+	phenotype_t *pt;
+	genetic_t *genetic = in_pt->genetic;
+	int ranking[CFQ_NUM_CHILDREN];
+	int weight = 1;
+	int i;
+
+	memset(ranking, 0, sizeof(ranking));
+
+	list_for_each(p, &genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+
+		/* Look at everyone else that contributes to this
+		   phenotype */
+		if (pt->uid & CFQ_GENERAL_UID && pt->uid != CFQ_GENERAL_UID) {
+
+			switch (pt->uid) {
+			case CFQ_NUM_OPS_UID:
+				weight = 2;
+				break;
+			case CFQ_THROUGHPUT_UID:
+				weight = 2;
+				break;
+			case CFQ_LATENCY_UID:
+				weight = 1;
+				break;
+			default:
+				BUG();
+			}
+
+			for (i = 0; i < pt->num_children; i++)
+				ranking[pt->child_ranking[i]->id] += (i * weight);
+		}
+	}
+
+	for (i = 0; i < in_pt->num_children; i++)
+		in_pt->child_ranking[i]->fitness = ranking[i];
+
+}
+
+#ifdef CONFIG_FINGERPRINTING
+void *cfq_create_genes(phenotype_t *pt)
+{
+	struct cfq_genes *genes = kmalloc(sizeof(struct cfq_genes), GFP_KERNEL);
+
+	if (!genes) {
+		printk(KERN_ERR "cfq_create_genes: unable to alloc space\n");
+		return 0;
+	}
+
+	/* at some point...make these intelligent depending on what
+	 * the workload is
+	 */
+	genes->cfq_quantum = CFQ_QUANTUM;
+	genes->cfq_back_max = CFQ_BACK_MAX;
+	genes->cfq_back_penalty = CFQ_BACK_PENALTY;
+	genes->cfq_slice_sync = CFQ_SLICE_SYNC;
+	genes->cfq_slice_async = CFQ_SLICE_ASYNC;
+	genes->cfq_slice_async_rq = CFQ_SLICE_ASYNC_RQ;
+	genes->cfq_idle_grace = CFQ_IDLE_GRACE;
+	genes->nr_requests = BLKDEV_MAX_RQ;
+
+	return (void *)genes;
+}
+#endif /* CONFIG_FINGERPRINTING */
+
+#endif
+
 module_init(cfq_init);
 module_exit(cfq_exit);
 
Index: linux.2.6.23/block/Kconfig.iosched
===================================================================
--- linux.2.6.23.orig/block/Kconfig.iosched
+++ linux.2.6.23/block/Kconfig.iosched
@@ -77,6 +77,15 @@
         anticipatory scheduler autonomically and will adapt tunables
         depending on the present workload.
 
+config GENETIC_IOSCHED_CFQ
+        bool "Genetic CFQ I/O scheduler (EXPERIMENTAL)"
+        depends on IOSCHED_CFQ && GENETIC_LIB && EXPERIMENTAL
+        default n
+        ---help---
+        This will use a genetic algorithm to tweak the tunables of the
+        CFQ scheduler autonomically and will adapt tunables
+        depending on the present workload.
+
 endmenu
 
 endif

--------------020402080701000302020407
Content-Type: text/x-diff;
 name="genetic-io-sched-2.6.23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="genetic-io-sched-2.6.23.patch"

Index: linux/block/genhd.c
===================================================================
--- linux.orig/block/genhd.c
+++ linux/block/genhd.c
@@ -30,6 +30,8 @@ static struct blk_major_name {
 	char name[16];
 } *major_names[BLKDEV_MAJOR_HASH_SIZE];
 
+LIST_HEAD(gendisks);
+
 /* index in the above - for now: assume no multimajor ranges */
 static inline int major_to_index(int major)
 {
@@ -395,19 +397,22 @@ static ssize_t disk_stats_read(struct ge
 		jiffies_to_msecs(disk_stat_read(disk, io_ticks)),
 		jiffies_to_msecs(disk_stat_read(disk, time_in_queue)));
 }
+
+#ifdef CONFIG_FINGERPRINTING
 static ssize_t disk_fp_read(struct gendisk * disk, char *page)
 {
-	return sprintf(page, "reads: %llx\n"
-		       "writes: %llx\n"
-		       "head_pos: %llx\n"
-		       "avg_dist: %llx\n"
-		       "avg_size: %llx\n",
+	return sprintf(page, "reads: %lld\n"
+		       "writes: %lld\n"
+		       "head_pos: %lld\n"
+		       "avg_dist: %lld\n"
+		       "avg_size: %lld\n",
 		       (unsigned long long)disk->fp_ss->reads,
 		       (unsigned long long)disk->fp_ss->writes,
 		       (unsigned long long)disk->fp_ss->head_pos,
 		       (unsigned long long)disk->fp_ss->avg_dist,
 		       (unsigned long long)disk->fp_ss->avg_size);
 }
+#endif
 
 static struct disk_attribute disk_attr_uevent = {
 	.attr = {.name = "uevent", .mode = S_IWUSR },
@@ -433,10 +438,13 @@ static struct disk_attribute disk_attr_s
 	.attr = {.name = "stat", .mode = S_IRUGO },
 	.show	= disk_stats_read
 };
+
+#ifdef CONFIG_FINGERPRINTING
 static struct disk_attribute disk_attr_fp = {
 	.attr = {.name = "fp", .mode = S_IRUGO },
 	.show	= disk_fp_read
 };
+#endif
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 
@@ -476,7 +484,9 @@ static struct attribute * default_attrs[
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&disk_attr_fail.attr,
 #endif
-	&disk_attr_fp.attr,
+#ifdef CONFIG_FINGERPRINTING
+        &disk_attr_fp.attr,
+#endif
 	NULL,
 };
 
@@ -485,6 +495,7 @@ static void disk_release(struct kobject 
 	struct gendisk *disk = to_disk(kobj);
 	kfree(disk->random);
 	kfree(disk->part);
+	list_del(&disk->gendisks);
 	free_disk_stats(disk);
 	kfree(disk);
 }
@@ -685,8 +696,9 @@ struct gendisk *alloc_disk_node(int mino
 		kobj_set_kset_s(disk,block_subsys);
 		kobject_init(&disk->kobj);
 		rand_initialize_disk(disk);
+		list_add_tail(&disk->gendisks, &gendisks);
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
 	}
 
 	disk->fp_ss = kmalloc(sizeof(struct fp_snapshot), GFP_KERNEL);
Index: linux/block/ll_rw_blk.c
===================================================================
--- linux.orig/block/ll_rw_blk.c
+++ linux/block/ll_rw_blk.c
@@ -21,6 +21,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
+#include <linux/genetic.h>
 #include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
@@ -2694,6 +2695,143 @@ static inline void add_request(request_q
 	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
 }
  
+#if defined(CONFIG_GENETIC_IOSCHED_AS) || \
+    defined(CONFIG_GENETIC_IOSCHED_DEADLINE) || \
+    defined(CONFIG_GENETIC_IOSCHED_CFQ)
+extern struct list_head gendisks;
+
+void disk_stats_snapshot(phenotype_t * pt)
+{
+	struct list_head * d;
+	struct gendisk *disk;
+	struct disk_stats_snapshot * ss = (struct disk_stats_snapshot *)pt->child_ranking[0]->stats_snapshot;
+
+	memset(ss, 0, sizeof(struct disk_stats_snapshot));
+
+	list_for_each(d, &gendisks) {
+	    disk = list_entry(d, struct gendisk, gendisks);
+
+	    disk_round_stats(disk);
+
+	    ss->reads += disk_stat_read(disk, ios[READ]);
+	    ss->writes += disk_stat_read(disk, ios[WRITE]);
+	    ss->read_sectors += disk_stat_read(disk, sectors[READ]);
+	    ss->write_sectors += disk_stat_read(disk, sectors[WRITE]);
+	    ss->time_in_queue += disk_stat_read(disk, time_in_queue);
+	}
+}
+
+long long disk_num_ops_calc_fitness(genetic_child_t * child)
+{
+	struct list_head * d;
+	struct gendisk *disk;
+	struct disk_stats_snapshot * ss = (struct disk_stats_snapshot *)child->stats_snapshot;
+	long long reads = 0;
+	long long writes = 0;
+
+	list_for_each(d, &gendisks) {
+	    disk = list_entry(d, struct gendisk, gendisks);
+
+	    disk_round_stats(disk);
+
+	    reads += disk_stat_read(disk, ios[READ]);
+	    writes += disk_stat_read(disk, ios[WRITE]);
+	}
+
+	reads -= ss->reads;
+	writes -= ss->writes;
+
+	return reads + writes;
+}
+
+long long disk_throughput_calc_fitness(genetic_child_t * child)
+{
+	struct list_head * d;
+	struct gendisk *disk;
+	struct disk_stats_snapshot * ss = (struct disk_stats_snapshot *)child->stats_snapshot;
+	long long read_sectors = 0;
+	long long write_sectors = 0;
+
+	list_for_each(d, &gendisks) {
+	    disk = list_entry(d, struct gendisk, gendisks);
+
+	    disk_round_stats(disk);
+
+	    read_sectors += disk_stat_read(disk, sectors[READ]);
+	    write_sectors += disk_stat_read(disk, sectors[WRITE]);
+	}
+
+	read_sectors -= ss->read_sectors;
+	write_sectors -= ss->write_sectors;
+
+	return read_sectors + write_sectors;
+}
+
+long long disk_latency_calc_fitness(genetic_child_t * child)
+{
+	struct list_head * d;
+	struct gendisk *disk;
+	struct disk_stats_snapshot * ss = (struct disk_stats_snapshot *)child->stats_snapshot;
+	long long time_in_queue = 0;
+
+	list_for_each(d, &gendisks) {
+	    disk = list_entry(d, struct gendisk, gendisks);
+
+	    disk_round_stats(disk);
+
+	    time_in_queue += disk_stat_read(disk, time_in_queue);
+	}
+
+	time_in_queue = -(time_in_queue - ss->time_in_queue);
+
+	return time_in_queue;
+}
+
+#ifdef CONFIG_FINGERPRINTING
+
+void disk_update_fingerprint(phenotype_t * pt)
+{
+	struct list_head * d;
+	struct gendisk *disk;
+
+	BUG_ON(!pt->fp_ss);
+
+	/* tally up all the other disk snapshots */
+	list_for_each(d, &gendisks) {
+	    disk = list_entry(d, struct gendisk, gendisks);
+
+	    consolidate_fp_snapshot(pt->fp_ss, disk->fp_ss);
+
+	    /* reset it for the next generation */
+	    reset_fp_snapshot(disk->fp_ss);
+	}
+
+}
+
+void disk_get_fingerprint(phenotype_t * pt)
+{
+	struct list_head * d;
+	struct gendisk *disk;
+
+	BUG_ON(!pt->fp_ss);
+
+	/* tally up all the other disk snapshots */
+	list_for_each(d, &gendisks) {
+	    disk = list_entry(d, struct gendisk, gendisks);
+
+	    consolidate_fp_snapshot(pt->fp_ss, disk->fp_ss);
+
+	    /* reset it for the next generation */
+	    reset_fp_snapshot(disk->fp_ss);
+	}
+
+	calc_fp(pt->fp, pt->fp_ss);
+}
+
+#endif /* CONFIG_FINGERPRINTING */
+
+#endif
+
 /*
  * disk_round_stats()	- Round off the performance stats on a struct
  * disk_stats.
Index: linux/include/linux/genhd.h
===================================================================
--- linux.orig/include/linux/genhd.h
+++ linux/include/linux/genhd.h
@@ -134,6 +134,7 @@ struct gendisk {
 	atomic_t sync_io;		/* RAID */
 	unsigned long stamp;
 	int in_flight;
+	struct list_head gendisks;
 #ifdef	CONFIG_SMP
 	struct disk_stats *dkstats;
 #else
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -861,6 +861,20 @@ void kblockd_flush_work(struct work_stru
 	MODULE_ALIAS("block-major-" __stringify(major) "-*")
 
 
+#if defined(CONFIG_GENETIC_IOSCHED_AS) || \
+    defined(CONFIG_GENETIC_IOSCHED_DEADLINE) || \
+    defined(CONFIG_GENETIC_IOSCHED_CFQ)
+
+struct disk_stats_snapshot
+{
+        unsigned long reads;
+        unsigned long writes;
+        unsigned long read_sectors;
+        unsigned long write_sectors;
+        unsigned long time_in_queue;
+};
+#endif /* CONFIG_GENETIC_IOSCHED_AS || CONFIG_GENETIC_IOSCHED_CFQ */
+
 #else /* CONFIG_BLOCK */
 /*
  * stubs for when the block layer is configured out


--------------020402080701000302020407
Content-Type: text/x-diff;
 name="genetic-lib-2.6.23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="genetic-lib-2.6.23.patch"

Index: linux-2.6.23/include/linux/genetic.h
===================================================================
--- /dev/null
+++ linux-2.6.23/include/linux/genetic.h
@@ -0,0 +1,285 @@
+#ifndef __LINUX_GENETIC_H
+#define __LINUX_GENETIC_H
+/*
+ * include/linux/genetic.h
+ *
+ * Jake Moilanen <moilanen@austin.ibm.com>
+ * Copyright (C) 2004 IBM
+ *
+ * Genetic algorithm library
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation. 
+ */
+
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/seq_file.h>
+
+
+#define GENETIC_HISTORY_SIZE		0x8
+#define GENETIC_HISTORY_MASK		(GENETIC_HISTORY_SIZE - 1)
+
+/* percentage of total number genes to mutate */
+#define GENETIC_DEFAULT_MUTATION_RATE	15
+
+/* XXX TODO Make this an adjustable runtime variable */
+/* Percentage that an iteration can jump within the range */
+#define GENETIC_ITERATIVE_MUTATION_RANGE 20
+
+/* the rate that GENETIC_DEFAULT_MUTATION_RATE itself can change */
+#define GENETIC_DEFAULT_MUTATION_RATE_CHANGE 4
+#define GENETIC_MAX_MUTATION_RATE	45
+#define GENETIC_MIN_MUTATION_RATE	10
+
+#define GENETIC_DEBUG			0
+
+#ifdef CONFIG_FINGERPRINTING
+#define FP_DECAY			90
+#define GENETIC_NUM_DEBUG_POINTS	5
+#else
+#define GENETIC_NUM_DEBUG_POINTS	4
+#endif
+
+#define GENETIC_PRINT_DEBUG		0
+#define gen_dbg(format, arg...) do { if (GENETIC_PRINT_DEBUG) printk(KERN_EMERG __FILE__ ": " format "\n" , ## arg); } while (0)
+#define gen_trc(format, arg...) do { if (GENETIC_PRINT_DEBUG) printk(KERN_EMERG __FILE__ ":%s:%d\n" , __FUNCTION__, __LINE__); } while (0)
+
+struct gene_param_s;
+struct genetic_s;
+struct phenotype_s;
+
+struct genetic_child_s {
+	struct list_head	list;
+	long long		fitness;
+	unsigned long		num_genes;
+	void			*genes;
+	struct gene_param_s	*gene_param;
+	void			*stats_snapshot;
+	int			id;
+};
+
+typedef struct genetic_child_s genetic_child_t;
+
+/* Here's a generic idea of what it the genes could look like */
+struct gene_param_s {
+	char 		*name;
+	unsigned long	min;
+	unsigned long	max;
+	unsigned long	initial;
+	void		(*mutate_gene)(genetic_child_t *, unsigned long);
+};
+
+typedef struct gene_param_s gene_param_t;
+
+struct phenotype_s {
+	struct list_head	phenotype;
+
+	struct list_head	children_queue[2];
+	struct list_head	*run_queue;
+	struct list_head	*finished_queue;
+	struct genetic_ops	*ops;
+
+	char			*name;
+
+	struct genetic_s	*genetic;		/* point back
+							 * to genetic
+							 * struct
+							 */
+
+	unsigned long		num_children;		  /* Must be power of 2 */
+	unsigned long		natural_selection_cutoff; /* How many children
+							   * will survive
+							   */
+	void			*stats_snapshot;
+	unsigned long		child_number;
+
+	/* percentage of total number of genes to mutate */
+	long			mutation_rate;
+	unsigned long		num_mutations;
+	unsigned long		num_genes;
+
+	genetic_child_t		**child_ranking;
+
+	void			(*natural_selection)(struct phenotype_s *);
+
+	/* This UID is bitmap comprised of other phenotypes that contribute
+	   to the genes */
+	unsigned long		uid;
+
+	/* performance metrics */
+	long long		avg_fitness;
+	long long		last_gen_avg_fitness;
+
+	unsigned long		fitness_history_index;
+	long long		fitness_history[GENETIC_HISTORY_SIZE];
+
+#if GENETIC_DEBUG
+	unsigned long		debug_size;	/* number of longs in
+						   debug history */
+	unsigned long		debug_index;
+	long long		*debug_history;
+#endif
+#ifdef CONFIG_FINGERPRINTING
+	struct dentry 		*fp_dir;
+	struct fingerprint	*fp;
+	struct fp_snapshot	*fp_ss;
+	unsigned long		***top_child;
+	long long		***top_fitness;
+	int			last_fingerprint;
+#else
+	long long		top_fitness;
+#endif
+
+	long long		from_top;
+
+};
+
+typedef struct phenotype_s phenotype_t;
+
+/**
+ * struct genetic_s - contains all data structures for a genetic plugin
+ * @name: string that will identify this genetic alg. in debugfs and printk
+ * @phenotype: list of all registered phenotypes
+ * @child_number: the running child index (< @num_children)
+ * @child_life_time: time in ms each child is ran before being swapped
+ * @num_children: number of children in each generation (must be a power of 2)
+ * @generation_number: increased once every child in a generation is ran
+ * @defaults: when 1 the genetic library will hold all genes at defaults
+ * @fingerprinting: when 1 the genetic library wil use gene fingerprinting if CONFIG_FINGERPRINTING
+ */
+struct genetic_s {
+	char			*name;
+	struct timer_list	timer;
+
+	struct list_head	phenotype;
+
+	unsigned long		child_number;
+	unsigned long		child_life_time;
+	unsigned long		num_children;
+
+	unsigned long		generation_number;
+	int 			defaults;
+
+	/* private */
+	struct dentry		*dir;
+	struct dentry 		*phenotypes_dir;
+	struct dentry 		*fingerprinting_dir;
+#ifdef CONFIG_FINGERPRINTING
+	int			fingerprinting;
+#endif
+};
+
+typedef struct genetic_s genetic_t;
+
+struct genetic_ops {
+	void			(*create_child)(genetic_child_t *);
+	void			(*set_child_genes)(void *);
+	void			(*calc_fitness)(genetic_child_t *);
+	void			(*combine_genes)(genetic_child_t *, genetic_child_t *,
+						 genetic_child_t *);
+	void			(*mutate_child)(genetic_child_t *);
+	void			(*calc_post_fitness)(phenotype_t *); /* Fitness routine used when
+								      * need to take into account
+								      * other phenotype fitness
+								      * results after they ran
+								      */
+	void			(*take_snapshot)(phenotype_t *);
+	void			(*shift_mutation_rate)(phenotype_t *);
+	int			(*gene_show)(struct seq_file *, void *);
+#ifdef CONFIG_FINGERPRINTING
+	void			(*get_fingerprint)(phenotype_t *);
+	void			(*update_fingerprint)(phenotype_t *);
+	void *			(*create_top_genes)(phenotype_t *);
+	int			(*top_fitness_show)(struct seq_file *, void *);
+	int			(*snapshot_show)(struct seq_file *, void *);
+	int			(*state_show)(struct seq_file *, void *);
+#endif
+};
+
+/* Setup routines */
+int __init genetic_init(genetic_t ** in_genetic, unsigned long num_children,
+			unsigned long child_life_time, int fingerprinting,
+			char * name);
+int __init genetic_register_phenotype(genetic_t * genetic, struct genetic_ops * ops,
+				      unsigned long num_children, char * name,
+				      unsigned long num_genes, unsigned long uid);
+void __init genetic_start(genetic_t * genetic);
+
+/* Generic helper functions */
+void genetic_generic_mutate_child(genetic_child_t * child);
+void genetic_generic_iterative_mutate_gene(genetic_child_t * child, unsigned long gene_num);
+void genetic_generic_combine_genes(genetic_child_t * parent_a,
+				   genetic_child_t * parent_b,
+				   genetic_child_t * child);
+void genetic_create_child_spread(genetic_child_t * child, unsigned long num_children);
+void genetic_create_child_defaults(genetic_child_t * child);
+void genetic_general_shift_mutation_rate(phenotype_t * in_pt);
+int genetic_generic_gene_show(struct seq_file *s, void *unused);
+
+
+/* XXX do this more intelligently */
+#ifndef DIVLL_OP
+#define DIVLL_OP
+#if BITS_PER_LONG >= 64
+
+static inline void divll(long long *n, long div, long *rem)
+{
+        *rem = *n % div;
+        *n /= div;
+}
+
+#else
+
+static inline void divl(int32_t high, int32_t low,
+                        int32_t div,
+                        int32_t *q, int32_t *r)
+{
+        int64_t n = (u_int64_t)high << 32 | low;
+        int64_t d = (u_int64_t)div << 31;
+        int32_t q1 = 0;
+        int c = 32;
+        while (n > 0xffffffff) {
+                q1 <<= 1;
+                if (n >= d) {
+                        n -= d;
+                        q1 |= 1;
+                }
+                d >>= 1;
+                c--;
+        }
+        q1 <<= c;
+        if (n) {
+                low = n;
+                *q = q1 | (low / div);
+                *r = low % div;
+        } else {
+                *r = 0;
+                *q = q1;
+        }
+        return;
+}
+
+static inline void divll(long long *n, long div, long *rem)
+{
+        int32_t low, high;
+        low = *n & 0xffffffff;
+        high = *n >> 32;
+        if (high) {
+                int32_t high1 = high % div;
+                int32_t low1 = low;
+                high /= div;
+                divl(high1, low1, div, &low, (int32_t *)rem);
+                *n = (int64_t)high << 32 | low;
+        } else {
+                *n = low / div;
+                *rem = low % div;
+        }
+}
+#endif
+
+#endif /* #ifndef divll */
+
+#endif
Index: linux-2.6.23/lib/Kconfig
===================================================================
--- linux-2.6.23.orig/lib/Kconfig
+++ linux-2.6.23/lib/Kconfig
@@ -63,6 +63,12 @@ config AUDIT_GENERIC
 	depends on AUDIT && !AUDIT_ARCH
 	default y
 
+config GENETIC_LIB
+	bool "Genetic Library"
+	help
+	  This option will build in a genetic library that will tweak
+	  kernel parameters autonomically to improve performance.
+
 #
 # compression support is select'ed if needed
 #
Index: linux-2.6.23/lib/Makefile
===================================================================
--- linux-2.6.23.orig/lib/Makefile
+++ linux-2.6.23/lib/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_CRC32)	+= crc32.o
 obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
+obj-$(CONFIG_GENETIC_LIB) += genetic.o
 
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
 obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
Index: linux-2.6.23/lib/genetic.c
===================================================================
--- /dev/null
+++ linux-2.6.23/lib/genetic.c
@@ -0,0 +1,892 @@
+/*
+ * Genetic Algorithm Library
+ *
+ * Jake Moilanen <moilanen@austin.ibm.com>
+ * Copyright (C) 2004-2005 IBM
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation. 
+ */
+
+/*
+ * Life cycle
+ *
+ * 1.) Create random children
+ * 2.) Run tests
+ * 3.) Calculate fitness
+ * 4.) Take top preformers
+ * 5.) Make children
+ * 6.) Mutate
+ * 7.) Goto step 2
+ */
+
+/*
+ * TODO:
+ *
+ * - Check to make sure DEF_DESKTOP_TIMESLICE is operating correctly
+ * - fix fixup_timeslice
+ */
+
+#include <linux/genetic.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+#include <linux/debugfs.h>
+#include <linux/init.h>
+#include <linux/random.h>
+#include <linux/log2.h>
+#include <asm/uaccess.h>
+#include <asm/string.h>
+#include <asm/bug.h>
+
+#include "genetic-debug.c"
+
+#ifdef CONFIG_FINGERPRINTING
+#include <linux/fingerprinting.h>
+#include "fingerprinting.c"
+#endif
+
+char genetic_lib_version[] = "0.3.1";
+
+int mutation_rate_change = GENETIC_DEFAULT_MUTATION_RATE_CHANGE;
+int genetic_lib_enabled = 1;
+
+static void genetic_ns_top_parents(phenotype_t *);
+static void genetic_ns_award_top_parents(phenotype_t *);
+static int  genetic_create_children(phenotype_t *);
+static void genetic_split_performers(phenotype_t *);
+static void genetic_mutate(phenotype_t *);
+static void genetic_run_child(genetic_t * genetic);
+static void genetic_new_generation(genetic_t * genetic);
+
+void genetic_switch_child(unsigned long data);
+
+
+int __init genetic_init(genetic_t ** in_genetic, unsigned long num_children,
+			unsigned long child_life_time, int fingerprinting,
+			char * name)
+{
+	genetic_t * genetic;
+
+	if (!genetic_lib_enabled)
+		return 0;
+
+	printk(KERN_INFO "Initializing Genetic Library - version %s\n",
+			genetic_lib_version);
+
+	genetic = (genetic_t *)kmalloc(sizeof(genetic_t), GFP_KERNEL);
+	if (!genetic) {
+		printk(KERN_ERR "genetic_init: not enough memory\n");
+		return -ENOMEM;
+	}
+
+	*in_genetic = genetic;
+
+	genetic->name = (char *)kmalloc(strlen(name), GFP_KERNEL);
+	if (!genetic->name) {
+		printk(KERN_ERR "genetic_init: not enough memory\n");
+		kfree(genetic);
+		return -ENOMEM;
+	}
+
+	/* Init some of our values */
+	strcpy(genetic->name, name);
+
+	genetic->num_children = num_children;
+	genetic->child_life_time = child_life_time;
+
+	genetic->generation_number = 1;
+	genetic->child_number = 0;
+	genetic->defaults = 0;
+#ifdef CONFIG_FINGERPRINTING
+	genetic->fingerprinting = fingerprinting;
+#endif
+
+	/* Setup how long each child has to live */
+	init_timer(&genetic->timer);
+	genetic->timer.function = genetic_switch_child;
+	genetic->timer.data = (unsigned long)genetic;
+
+	INIT_LIST_HEAD(&genetic->phenotype);
+
+	/* Setup debugfs */
+	genetic->dir = genetic_create_tree(name, NULL);
+	genetic->phenotypes_dir = genetic_create_tree("phenotypes", genetic->dir);
+
+#ifdef CONFIG_FINGERPRINTING
+	if (fingerprinting)
+		genetic->fingerprinting_dir = genetic_create_tree("fingerprinting", genetic->dir);
+#endif
+
+	/* TODO add stack to the genetic track dentries for deallocation */
+	debugfs_create_file("stats", S_IFREG|S_IRUGO, genetic->dir,
+			genetic, &genetic_stat_operations);
+
+	debugfs_create_file("phenotype_average", S_IFREG|S_IRUGO, genetic->dir,
+			genetic, &genetic_phenotype_average_operations);
+
+	debugfs_create_bool("defaults", S_IWUSR|S_IFREG|S_IRUGO, genetic->dir,
+				&genetic->defaults);
+
+	return 0;
+}
+
+int __init genetic_register_phenotype(genetic_t * genetic,
+		struct genetic_ops * ops, unsigned long num_children,
+		char * name, unsigned long num_genes, unsigned long uid)
+{
+	phenotype_t * pt;
+	int rc;
+
+	if (!genetic_lib_enabled)
+		return 0;
+
+	printk(KERN_INFO "Initializing %s's phenotype %s\n", genetic->name,
+			name);
+
+	pt = (phenotype_t *)kmalloc(sizeof(phenotype_t), GFP_KERNEL);
+	if (!genetic) {
+		printk(KERN_ERR "genetic_register_phenotype: not enough\
+				memory\n");
+		return -ENOMEM;
+	}
+
+	pt->name = (char *)kmalloc(strlen(name), GFP_KERNEL);
+	if (!pt->name) {
+		printk(KERN_ERR "genetic_register_phenotype: not enough\
+				memory\n");
+		kfree(pt);
+		return -ENOMEM;
+	}
+
+	pt->child_ranking = (genetic_child_t **)kmalloc(num_children * sizeof(genetic_child_t *), GFP_KERNEL);
+	if (!pt->child_ranking) {
+		printk(KERN_ERR "genetic_register_phenotype: not enough\
+				memory\n");
+		kfree(pt->name);
+		kfree(pt);
+		return -ENOMEM;
+	}
+
+
+	strcpy(pt->name, name);
+
+	INIT_LIST_HEAD(&pt->children_queue[0]);
+	INIT_LIST_HEAD(&pt->children_queue[1]);
+
+	pt->run_queue = &pt->children_queue[0];
+	pt->finished_queue = &pt->children_queue[1];
+
+	pt->ops = ops;
+	pt->num_children = num_children;
+
+	pt->mutation_rate = GENETIC_DEFAULT_MUTATION_RATE;
+	pt->natural_selection = genetic_ns_top_parents;
+	pt->natural_selection_cutoff = num_children / 2;
+	pt->avg_fitness = 0;
+	pt->last_gen_avg_fitness = 0;
+	pt->child_number = 0;
+
+	pt->genetic = genetic;
+	pt->uid = uid;
+	pt->num_genes = num_genes;
+
+	pt->top_fitness = 0;
+
+#ifdef CONFIG_FINGERPRINTING
+	if (genetic->fingerprinting) {
+		if ((rc = genetic_init_fingerprinting(pt)) < 0)
+			return rc;
+	}
+#endif
+
+	/* Create some children */
+	rc = genetic_create_children(pt);
+	if (rc)
+		return rc;
+
+	list_add_tail(&pt->phenotype, &genetic->phenotype);
+
+	if (ops->gene_show) {
+		debugfs_create_file(name, S_IFREG|S_IRUGO,
+			genetic->phenotypes_dir, pt, &genetic_gene_operations);
+	}
+
+	return 0;
+}
+
+
+
+void __init genetic_start(genetic_t * genetic)
+{
+	if (!genetic_lib_enabled)
+		return;
+
+	genetic_run_child(genetic);
+	printk(KERN_INFO "%ld children started in %s genetic library\n",
+			genetic->num_children, genetic->name);
+}
+
+
+
+/* create some children, it is up to the lib user to come up w/ a good
+   distro of genes for it's children */
+static int genetic_create_children(phenotype_t * pt)
+{
+	unsigned long i;
+	genetic_child_t * child;
+
+	for (i = 0; i < pt->num_children; i++) {
+		pt->child_ranking[i] = (genetic_child_t *)kmalloc(
+				sizeof(genetic_child_t), GFP_KERNEL);
+
+		if (!pt->child_ranking[i]) {
+			printk(KERN_ERR "genetic_create_child: not enough\
+					 memory\n");
+
+			for (i = i - 1; i >= 0; i--)
+				kfree(pt->child_ranking[i]);
+
+			return -ENOMEM;
+		}
+
+		child = pt->child_ranking[i];
+
+		child->id = i;
+
+		pt->ops->create_child(child);
+
+		list_add_tail(&child->list, pt->run_queue);
+	}
+
+	return 0;
+}
+
+
+/* See how well child did and run the next one */
+void genetic_switch_child(unsigned long data)
+{
+	genetic_t * genetic = (genetic_t *)data;
+	genetic_child_t * child;
+
+	struct list_head * p;
+	phenotype_t * pt;
+
+	int new_generation = 0;
+#ifdef GENETIC_DEBUG_VERBOSE
+	printk(KERN_INFO "genetic_switch_child() for %s\n", genetic->name);
+#endif
+	list_for_each(p, &genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+
+		child = list_entry(pt->run_queue->next, genetic_child_t, list);
+
+#ifdef GENETIC_DEBUG_VERBOSE
+		printk(KERN_INFO "  phenotype %s\n", pt->name);
+#endif
+
+		list_del(&child->list);
+
+		list_add_tail(&child->list, pt->finished_queue);
+
+		if (pt->ops->calc_fitness)
+			pt->ops->calc_fitness(child);
+
+#ifdef GENETIC_DEBUG_VERBOSE
+		printk(KERN_INFO "  finished calc_fitness\n");
+#endif
+
+		pt->child_ranking[pt->child_number++] = child;
+
+		/* See if need more children */
+		if (list_empty(pt->run_queue))
+			new_generation = 1;
+
+	}
+
+	genetic->child_number++;
+
+	if (new_generation)
+		genetic_new_generation(genetic);
+
+	genetic_run_child(genetic);
+
+#ifdef GENETIC_DEBUG_VERBOSE
+	printk("exiting genetic_switch_child()\n");
+#endif
+}
+
+/* Set the childs genes for run */
+void genetic_run_child(genetic_t * genetic)
+{
+	struct list_head * p;
+	phenotype_t * pt;
+
+	genetic_child_t * child;
+	void * genes;
+
+	list_for_each(p, &genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+
+		child = list_entry(pt->run_queue->next, genetic_child_t, list);
+
+		/* genetic alg. disabled, only use default genes */
+		if (genetic->defaults)
+			genetic_create_child_defaults(child);
+
+		genes = child->genes;
+
+		if (pt->ops->set_child_genes)
+			pt->ops->set_child_genes(genes);
+
+		if (pt->ops->take_snapshot)
+			pt->ops->take_snapshot(pt);
+
+	}
+
+	/* set a timer interrupt */
+	genetic->timer.expires = jiffies + genetic->child_life_time;
+	add_timer(&genetic->timer);
+
+}
+
+/* This natural selection routine will take the top
+ * natural_select_cutoff and use them to make children for the next
+ * generation and keep the top half perfomers
+ *
+ * This assumes natural_select_cutoff is exactly half of num_children
+ * and num_children is a multable of 4.
+ */
+static void genetic_ns_top_parents(phenotype_t * pt)
+{
+	unsigned long i,j,k = 0;
+	unsigned long num_children = pt->num_children;
+	unsigned long cutoff = num_children - pt->natural_selection_cutoff;
+
+	for (i = cutoff, j = num_children - 1; i < j; i++, j--, k += 2) {
+	/* create child A */
+	pt->ops->combine_genes(pt->child_ranking[i],
+					pt->child_ranking[j],
+					pt->child_ranking[k]);
+
+	/* create child B */
+	pt->ops->combine_genes(pt->child_ranking[i],
+					pt->child_ranking[j],
+					pt->child_ranking[k+1]);
+	}
+}
+
+
+/* This natural selection routine just has top parents populating
+   bottom performers. */
+static void genetic_ns_award_top_parents(phenotype_t * pt)
+{
+	unsigned long i;
+	unsigned long num_children = pt->num_children;
+	unsigned long cutoff = num_children - pt->natural_selection_cutoff;
+
+	for (i = 0; i < cutoff; i += 2) {
+		pt->ops->combine_genes(pt->child_ranking[num_children - 1],
+					pt->child_ranking[num_children - 2],
+					pt->child_ranking[i]);
+
+		pt->ops->combine_genes(pt->child_ranking[num_children - 1],
+					pt->child_ranking[num_children - 2],
+					pt->child_ranking[i+1]);
+	}
+}
+
+static inline void genetic_swap(genetic_child_t ** a, genetic_child_t ** b)
+{
+	genetic_child_t * tmp = *a;
+
+	*a = *b;
+	*b = tmp;
+}
+
+/* bubble sort */
+/* XXX change this to quick sort */
+static void genetic_split_performers(phenotype_t * pt)
+{
+	int i, j;
+
+	for (i = pt->num_children; i > 1; i--)
+	for (j = 0; j < i - 1; j++)
+		if (pt->child_ranking[j]->fitness > pt->child_ranking[j+1]->fitness)
+		genetic_swap(&pt->child_ranking[j], &pt->child_ranking[j+1]);
+}
+
+static void genetic_mutate(phenotype_t * pt)
+{
+	long child_entry = -1;
+	int i;
+
+	if (!pt->num_genes)
+		return;
+
+	for (i = 0; i < pt->num_mutations; i++) {
+	get_random_bytes(&child_entry, sizeof(child_entry));
+	child_entry = child_entry % pt->num_children;
+
+	pt->ops->mutate_child(pt->child_ranking[child_entry]);
+	}
+}
+
+/* XXX This will either aid in handling new workloads, or send us on a
+   downward spiral */
+static void genetic_shift_mutation_rate(phenotype_t * pt, long long prev_gen_avg_fitness, long long avg_fitness)
+{
+
+	long long low_bound;
+	long long high_bound;
+	long dummy;
+
+	if (mutation_rate_change && pt->genetic->generation_number > 1) {
+
+		if (pt->ops->shift_mutation_rate) {
+			pt->ops->shift_mutation_rate(pt);
+		} else {
+
+			low_bound = avg_fitness * 90;
+			divll(&low_bound, 100, &dummy);
+
+			high_bound = avg_fitness * 110;
+			divll(&high_bound, 100, &dummy);
+
+			if (high_bound > prev_gen_avg_fitness)
+				pt->mutation_rate -= mutation_rate_change;
+			else if (low_bound < prev_gen_avg_fitness)
+				pt->mutation_rate += mutation_rate_change;
+
+			if (pt->mutation_rate > GENETIC_MAX_MUTATION_RATE)
+				pt->mutation_rate = GENETIC_MAX_MUTATION_RATE;
+			else if (pt->mutation_rate < GENETIC_MIN_MUTATION_RATE)
+				pt->mutation_rate = GENETIC_MIN_MUTATION_RATE;
+		}
+	}
+}
+
+void genetic_general_shift_mutation_rate(phenotype_t * in_pt)
+{
+	struct list_head * p;
+	phenotype_t * pt;
+	int count = 0;
+	long rate = 0;
+
+	list_for_each(p, &in_pt->genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+
+		if (in_pt->uid & pt->uid && in_pt->uid != pt->uid) {
+			rate += pt->mutation_rate;
+			count++;
+		}
+	}
+
+	/* If we are a general phenotype that is made up of other
+	   phenotypes then we take the average */
+	if (count)
+		in_pt->mutation_rate = (rate / count);
+	else
+		in_pt->mutation_rate = mutation_rate_change;
+}
+
+static void genetic_calc_stats(phenotype_t * in_pt)
+{
+	struct list_head * p;
+	phenotype_t * pt;
+	long long total_fitness = 0;
+	long long prev_gen_avg_fitness = in_pt->last_gen_avg_fitness;
+	long long tmp_fitness;
+	long dummy;
+	int i = 0;
+#ifdef CONFIG_FINGERPRINTING
+	int fp = in_pt->genetic->fingerprinting;
+	int numerical_fp;
+#endif
+
+	/* On a general phenotype, need to look at other metrics since
+	 * the fitness is normalized.  It always average the same.  It
+	 * assumes that this phenotype is registered last.
+	 */
+	if (in_pt->ops->calc_post_fitness) {
+
+#ifdef CONFIG_FINGERPRINTING
+		if (fp)
+			numerical_fp = create_fingerprint(in_pt->fp);
+
+		/* do we want this???? */
+		if ((fp && (in_pt->last_fingerprint == numerical_fp)) || !fp) {
+#else
+		if (1) {
+#endif
+
+#ifdef GENETIC_DEBUG_VERBOSE
+			printk(KERN_INFO "genetic_calc_stats() for %s\n", in_pt->name);
+#endif
+			list_for_each(p, &in_pt->genetic->phenotype) {
+				pt = list_entry(p, phenotype_t, phenotype);
+
+				/* for each child */
+				if (in_pt->uid & pt->uid && in_pt->uid != pt->uid) {
+					if (pt->avg_fitness) {
+						/* measure how far percentage-wise that we are from the top */
+						pt->from_top = (pt->last_gen_avg_fitness - pt->avg_fitness) * 100;
+#ifdef GENETIC_DEBUG_VERBOSE
+						printk("  name: %s from_top: %lld avg_fitness: %lld\n", pt->name, pt->from_top, pt->avg_fitness);
+#endif
+						divll(&pt->from_top, (pt->avg_fitness > 0) ? pt->avg_fitness : -pt->avg_fitness, &dummy);
+
+						total_fitness += pt->from_top;
+#ifdef GENETIC_DEBUG_VERBOSE
+						printk("  total_fitness: %lld\n", total_fitness);
+#endif
+					}
+				}
+
+				i++;
+
+			}
+
+		} else {
+				/* XXX horrible horrible hack...but
+				 * testing viability */
+				total_fitness = 0;
+				i = 1;
+		}
+
+		BUG_ON(!i);
+
+		in_pt->last_gen_avg_fitness = total_fitness;
+		divll(&in_pt->last_gen_avg_fitness, i, &dummy);
+
+#ifdef GENETIC_DEBUG_VERBOSE
+		printk("  in_pt->last_gent_avg_fitness: %lld\n", in_pt->last_gen_avg_fitness);
+#endif
+	} else {
+		/* calculate the avg fitness for this generation and avg fitness
+		 * so far */
+		for (i = 0; i < in_pt->num_children; i++)
+			total_fitness += in_pt->child_ranking[i]->fitness;
+
+		in_pt->last_gen_avg_fitness = total_fitness >> ilog2(in_pt->num_children);
+	}
+
+	/* Mutation rate calibration */
+	genetic_shift_mutation_rate(in_pt, prev_gen_avg_fitness,
+			in_pt->last_gen_avg_fitness);
+
+	in_pt->num_mutations = ((in_pt->num_children * in_pt->num_genes) * in_pt->mutation_rate) / 100;
+
+	/* calc new avg fitness */
+	tmp_fitness = in_pt->last_gen_avg_fitness - in_pt->avg_fitness;
+	divll(&tmp_fitness, in_pt->genetic->generation_number, &dummy);
+	in_pt->avg_fitness += tmp_fitness;
+
+	in_pt->fitness_history[in_pt->fitness_history_index++ & GENETIC_HISTORY_MASK] =
+		in_pt->last_gen_avg_fitness;
+
+#ifdef GENETIC_DEBUG_VERBOSE
+	printk("finished genetic_calc_stats()\n");
+#endif
+}
+
+
+void genetic_new_generation(genetic_t * genetic)
+{
+	struct list_head * tmp;
+
+	struct list_head * p;
+	phenotype_t * pt;
+
+	list_for_each(p, &genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+
+		/* Check to see if need to recalibrate fitness to take
+		   other phenotypes' rankings into account.  This
+		   should be ran after all phenotypes that have input
+		   have been ran. */
+		if (pt->ops->calc_post_fitness)
+			pt->ops->calc_post_fitness(pt);
+
+		dump_children(pt);
+
+		/* figure out top performers */
+		genetic_split_performers(pt);
+
+		/* calc stats */
+		genetic_calc_stats(pt);
+
+		dump_children(pt);
+
+		/* make some new children */
+		if (pt->num_genes)
+			pt->natural_selection(pt);
+
+		dump_children(pt);
+
+#ifdef CONFIG_FINGERPRINTING
+		if (pt->ops->get_fingerprint) {
+
+			pt->ops->get_fingerprint(pt);
+			reset_fp_snapshot(pt->fp_ss);
+
+			/* See if this generation was a top performer
+			 * for the current workload.
+			 * Do this after natural selection to get rid
+			 * of the bad apples
+			 */
+			update_top_performers(pt);
+
+			/* We know the workload, lets put some known
+			   good genes back in */
+			reintroduce_genes(pt);
+
+			pt->last_fingerprint = create_fingerprint(pt->fp);
+		}
+
+		dump_children(pt);
+#endif
+
+		/* mutate a couple of the next generation */
+		genetic_mutate(pt);
+
+		dump_children(pt);
+
+		/* Move the new children still sitting in the finished queue to
+		   the run queue */
+		tmp = pt->run_queue;
+		pt->run_queue = pt->finished_queue;
+		pt->finished_queue = tmp;
+
+		pt->child_number = 0;
+#if GENETIC_DEBUG
+		pt->debug_index = 0;
+#endif
+
+	}
+
+	genetic->child_number = 0;
+	genetic->generation_number++;
+
+}
+
+/**
+ * genetic_generic_random_mutate_gene - mutate child's gene to value in range
+ * @child: child whose gene we are mutating
+ * @gene_num: gene index from gene_param to mutate; gene must be unsigned long
+ *
+ * Mutate a gene picking a random value within the gene range that was
+ * specified in @child->gene_param.
+ */
+void genetic_generic_random_mutate_gene(genetic_child_t * child,
+		unsigned long gene_num)
+{
+	unsigned long *genes = (unsigned long *)child->genes;
+	unsigned long min = child->gene_param[gene_num].min;
+	unsigned long max = child->gene_param[gene_num].max;
+	unsigned long gene_value;
+	unsigned long range = max - min + 1;
+
+	/* create a mutation value */
+	get_random_bytes(&gene_value, sizeof(gene_value));
+
+	gene_value = gene_value % range;
+
+	genes[gene_num] = min + gene_value;
+}
+
+/**
+ * genetic_generic_iterative_mutate_gene
+ * @child: child whose gene we are mutating
+ * @gene_num: gene index from gene_param to mutate; gene must be unsigned long
+ */
+void genetic_generic_iterative_mutate_gene(genetic_child_t * child,
+		unsigned long gene_num)
+{
+	unsigned long *genes = (unsigned long *)child->genes;
+	unsigned long min = child->gene_param[gene_num].min;
+	unsigned long max = child->gene_param[gene_num].max;
+	long change;
+	unsigned long old_value = genes[gene_num];
+	unsigned long new_value;
+	unsigned long range = max - min + 1;
+
+	/* If under 5, random might work better */
+	if (range < 5)
+		return genetic_generic_random_mutate_gene(child, gene_num);
+
+	/* get the % of change */
+	get_random_bytes(&change, sizeof(change));
+
+	change = change % GENETIC_ITERATIVE_MUTATION_RANGE;
+
+	new_value = ((long)(change * range) / (long)100) + old_value;
+
+	if (new_value > max)
+		new_value = max;
+	else if (new_value < min)
+		new_value = min;
+
+	genes[gene_num] = new_value;
+}
+
+/**
+ * genetic_generic_mutate_child - mutate random gene in child
+ * @child: child whose gene we are mutating.
+ *
+ * Select a random gene and mutate it either using either the mutate_gene
+ * callback specified in '&struct gene_param' OR if that is NULL then use
+ * 'genetic_generic_random_mutate_gene()'
+ */
+void genetic_generic_mutate_child(genetic_child_t * child)
+{
+	long gene_num = -1;
+
+	/* pick a random gene */
+	get_random_bytes(&gene_num, sizeof(gene_num));
+
+	if (gene_num < 0)
+		gene_num = -gene_num;
+
+	gene_num = gene_num % child->num_genes;
+
+	if (child->gene_param[gene_num].mutate_gene)
+		child->gene_param[gene_num].mutate_gene(child, gene_num);
+	else
+		genetic_generic_random_mutate_gene(child, gene_num);
+}
+
+/**
+ * genetic_generic_mutate_child - set all genes to their initial value
+ */
+void genetic_create_child_defaults(genetic_child_t * child)
+{
+	int i;
+	unsigned long * genes = child->genes;
+
+	for (i = 0; i < child->num_genes; i++) {
+		genes[i] = child->gene_param[i].initial;
+	}
+}
+
+void genetic_create_child_spread(genetic_child_t * child,
+		unsigned long num_children)
+{
+	int i;
+	unsigned long range;
+	int range_incr;
+	int child_num = child->id;
+	long num_genes = child->num_genes;
+	unsigned long * genes = child->genes;
+
+	for (i = 0; i < num_genes; i++) {
+		range = child->gene_param[i].max - child->gene_param[i].min + 1;
+		range_incr = range / num_children;
+		if (range_incr)
+			genes[i] = child->gene_param[i].min +
+				(range_incr * child_num);
+		else
+			genes[i] = child->gene_param[i].min +
+				(child_num / (num_children / range));
+	}
+
+}
+
+#if 0
+/* Randomly pick which parent to use for each gene to create a child */
+void genetic_generic_combine_genes(genetic_child_t * parent_a,
+				   genetic_child_t * parent_b,
+				   genetic_child_t * child)
+{
+	unsigned long * genes_a = (unsigned long *)parent_a->genes;
+	unsigned long * genes_b = (unsigned long *)parent_b->genes;
+	unsigned long * child_genes = (unsigned long *)child->genes;
+
+	/* Assume parent_a and parent_b have same num_genes */
+	unsigned long num_genes = parent_a->num_genes;
+	int parent_selector;
+	int i;
+
+	get_random_bytes(&parent_selector, sizeof(parent_selector));
+
+	if ((sizeof(parent_selector) * 8) < num_genes)
+		BUG();
+
+	for (i = 0; i < num_genes; i++) {
+		/* Look at each bit to determine which parent to use */
+		if (parent_selector & 1) {
+			child_genes[i] = genes_a[i];
+		} else {
+			child_genes[i] = genes_b[i];
+		}
+		parent_selector >>= 1;
+	}
+}
+#else
+
+/**
+ * genetic_generic_combine_genes - create child using comb. of parent's genes
+ * @parent_a: gene doner
+ * @parent_b: gene doner
+ * @child: genes will be modified using a combination of a and b
+ */
+void genetic_generic_combine_genes(genetic_child_t * parent_a,
+				   genetic_child_t * parent_b,
+				   genetic_child_t * child)
+{
+	unsigned long * genes_a = (unsigned long *)parent_a->genes;
+	unsigned long * genes_b = (unsigned long *)parent_b->genes;
+	unsigned long * child_genes = (unsigned long *)child->genes;
+
+	/* Assume parent_a and parent_b have same num_genes */
+	unsigned long num_genes = parent_a->num_genes;
+	int percentage;
+	int i;
+
+	for (i = 0; i < num_genes; i++) {
+		get_random_bytes(&percentage, sizeof(percentage));
+
+		/* Get percentage */
+		percentage = percentage % 100;
+
+		if (percentage < 0)
+			percentage = -percentage;
+
+		/* Give child x% of parent A's genes value, plus
+		   100-x% of parent B's genes value */
+		child_genes[i] = (((genes_a[i]+1) * percentage) +
+			(genes_b[i] * (100 - percentage))) / 100;
+	}
+}
+#endif
+
+static int __init genetic_boot_setup(char *str)
+{
+	if (strcmp(str, "on") == 0)
+		genetic_lib_enabled = 1;
+	else if (strcmp(str, "off") == 0)
+		genetic_lib_enabled = 0;
+
+	return 1;
+}
+
+
+static int __init genetic_mutation_rate_change_setup(char *str)
+{
+	int i;
+
+	if (get_option(&str,&i)) {
+
+		if (i > GENETIC_MAX_MUTATION_RATE)
+			i = GENETIC_MAX_MUTATION_RATE;
+		else if (i < 0)
+			i = 0;
+
+		mutation_rate_change = i;
+	}
+
+	return 1;
+
+}
+__setup("genetic=", genetic_boot_setup);
+__setup("genetic_mutate_rate=", genetic_mutation_rate_change_setup);
Index: linux-2.6.23/lib/genetic-debug.c
===================================================================
--- /dev/null
+++ linux-2.6.23/lib/genetic-debug.c
@@ -0,0 +1,153 @@
+/*
+ * Genetic Algorithm Library Debugging Routines
+ *
+ * (C) Copyright 2006 IBM
+ * (C) Copyright 2006 Brandon Philips <brandon@ifup.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/genetic.h>
+#include <linux/seq_file.h>
+
+struct dentry * genetic_tree_root = NULL;
+
+/**
+ * genetic_stat_show - generates /debug/genetic/<name>/stats
+ */
+static int genetic_stat_show(struct seq_file *s, void *unused)
+{
+	genetic_t * genetic = (genetic_t *)s->private;
+
+	seq_printf(s, "name: %s\n", genetic->name);
+	seq_printf(s, "generation_number: %ld\n", genetic->generation_number);
+	seq_printf(s, "num_children: %ld\n", genetic->num_children);
+	seq_printf(s, "child_life_time: %ld\n", genetic->child_life_time);
+	seq_printf(s, "child_number: %ld\n", genetic->child_number);
+
+	return 0;
+}
+
+static int genetic_stat_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genetic_stat_show, inode->i_private);
+}
+
+static struct file_operations genetic_stat_operations = {
+	.open		= genetic_stat_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/**
+ * genetic_phenotype_average_show - /debug/genetic/<name>/phenotype_average
+ */
+static int genetic_phenotype_average_show(struct seq_file *s, void *unused)
+{
+	genetic_t * genetic = (genetic_t *)s->private;
+	struct list_head * p;
+	phenotype_t * pt;
+
+	list_for_each(p, &genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+		seq_printf(s, "%s: %lld\n", pt->name, pt->avg_fitness);
+	}
+
+	return 0;
+}
+
+static int genetic_phenotype_average_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genetic_phenotype_average_show, inode->i_private);
+}
+
+static struct file_operations genetic_phenotype_average_operations = {
+	.open		= genetic_phenotype_average_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+
+/**
+ * genetic_genes_show - /debug/genetic/<name>/gene
+ */
+int genetic_generic_gene_show(struct seq_file *s, void *unused)
+{
+	int i;
+	phenotype_t * pt = (phenotype_t *)s->private;
+
+	genetic_child_t * child = list_entry(pt->run_queue->next,
+						genetic_child_t, list);
+
+	unsigned long * genes = (unsigned long *)child->genes;
+
+	for (i = 0; i < pt->num_genes; i++)
+		seq_printf(s, "%s: %lu\n", child->gene_param[i].name, genes[i]);
+
+	return 0;
+}
+
+static int genetic_generic_gene_open(struct inode *inode, struct file *file)
+{
+	phenotype_t * pt = (phenotype_t *)inode->i_private;
+
+	return single_open(file, pt->ops->gene_show, inode->i_private);
+}
+
+static struct file_operations genetic_gene_operations = {
+	.open		= genetic_generic_gene_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+
+static struct dentry *genetic_create_tree(const char *name, struct dentry *parent)
+{
+	struct dentry *dir = NULL;
+
+	if (!genetic_tree_root) {
+		genetic_tree_root = debugfs_create_dir("genetic", NULL);
+		if (!genetic_tree_root)
+			goto err;
+	}
+
+	if (!parent) parent = genetic_tree_root;
+
+	dir = debugfs_create_dir(name, parent);
+
+err:
+	return dir;
+}
+
+#if GENETIC_DEBUG
+/* Stores attributes into an array in the following format
+ * child_num fitness gene[0] gene[1] .... gene[num_genes-1]
+ * Add +1 to GENETIC_NUM_DEBUG_POINTS if add another dump_children
+ * call
+ */
+void dump_children(phenotype_t * pt)
+{
+	int i, j;
+	long * genes;
+	unsigned long debug_size = pt->debug_size;
+
+	for (i = 0; i < pt->num_children; i++) {
+		pt->debug_history[pt->debug_index++ % debug_size] = pt->child_ranking[i]->id;
+		pt->debug_history[pt->debug_index++ % debug_size] = pt->child_ranking[i]->fitness;
+
+		genes = (long *)pt->child_ranking[i]->genes;
+
+		for (j = 0; j < pt->child_ranking[i]->num_genes; j++) {
+			pt->debug_history[pt->debug_index++ % debug_size] = genes[j];
+		}
+	}
+}
+#else
+void dump_children(phenotype_t * pt) {}
+#endif /* GENETIC_DEBUG */
Index: linux-2.6.23/lib/fingerprinting.c
===================================================================
--- /dev/null
+++ linux-2.6.23/lib/fingerprinting.c
@@ -0,0 +1,291 @@
+static int create_fingerprint(struct fingerprint * fp)
+{
+	int numerical_fp = 0;
+
+	numerical_fp |= fp->type;
+	numerical_fp <<= 1;
+
+	numerical_fp |= fp->pattern;
+	numerical_fp <<= 1;
+
+	numerical_fp |= fp->size;
+
+	return numerical_fp;
+}
+
+static long long get_top_fitness(phenotype_t * pt, struct fingerprint * fp)
+{
+	return pt->top_fitness[fp->type][fp->pattern][fp->size];
+}
+
+
+static int top_fitness_open(struct inode *inode, struct file *file)
+{
+	phenotype_t * pt = (phenotype_t *)inode->i_private;
+
+	return single_open(file, pt->ops->top_fitness_show, inode->i_private);
+}
+
+static struct file_operations top_fitness_ops = {
+	.open		= top_fitness_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int snapshot_open(struct inode *inode, struct file *file)
+{
+	phenotype_t * pt = (phenotype_t *)inode->i_private;
+
+	return single_open(file, pt->ops->snapshot_show, inode->i_private);
+}
+
+static struct file_operations snapshot_ops = {
+	.open		= snapshot_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int state_open(struct inode *inode, struct file *file)
+{
+	phenotype_t * pt = (phenotype_t *)inode->i_private;
+
+	return single_open(file, pt->ops->state_show, inode->i_private);
+}
+
+static struct file_operations state_ops = {
+	.open		= state_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+
+int genetic_init_fingerprinting(phenotype_t * pt)
+{
+	int i, j, k;
+	struct genetic_ops * ops = pt->ops;
+	int num_genes = pt->num_genes;
+
+	if (num_genes) {
+
+		pt->fp = (struct fingerprint *)kmalloc(
+				sizeof(struct fingerprint), GFP_KERNEL);
+
+		if (!pt->fp) {
+			printk(KERN_ERR "genetic_register_phenotype: not enough"
+				       	"memory\n");
+			return -ENOMEM;
+		}
+
+		reset_fp(pt->fp);
+
+		pt->fp_ss = (struct fp_snapshot *)kmalloc(
+				sizeof(struct fp_snapshot), GFP_KERNEL);
+
+		if (!pt->fp_ss) {
+			printk(KERN_ERR "genetic_register_phenotype: not enough"
+				       	"memory\n");
+			return -ENOMEM;
+		}
+
+		reset_fp_snapshot(pt->fp_ss);
+
+		pt->top_child = (unsigned long ***)kmalloc(
+				sizeof(unsigned long ***) * 2, GFP_KERNEL);
+
+		if (!pt->top_child) {
+			printk(KERN_ERR "genetic_register_phenotype: not enough"
+				       	"memory\n");
+			return -ENOMEM;
+		}
+
+		for (i = 0; i < 2; i++) {
+			pt->top_child[i] = (unsigned long **)kmalloc(
+					sizeof(unsigned long **) * 2,
+					GFP_KERNEL);
+
+			if (!pt->top_child[i]) {
+				printk(KERN_ERR "genetic_register_phenotype:\
+						 not enough memory\n");
+				return -ENOMEM;
+			}
+
+			for (j = 0; j < 2; j++) {
+				pt->top_child[i][j] = (unsigned long *)kmalloc(
+						sizeof(unsigned long *) * 2,
+						GFP_KERNEL);
+
+				if (!pt->top_child[i][j]) {
+					printk(KERN_ERR "genetic_register_phenotype: not enough memory\n");
+					return -ENOMEM;
+				}
+
+				for (k = 0; k < 2; k++) {
+					pt->top_child[i][j][k] = (unsigned long)ops->create_top_genes(pt);
+					if (!pt->top_child[i][j][k])
+						return -ENOMEM;
+				}
+			}
+		}
+	} /* if (num_genes) */
+
+	pt->top_fitness = (long long ***)kmalloc(sizeof(long long ***) * 2, GFP_KERNEL);
+	if (!pt->top_fitness) {
+		printk(KERN_ERR "genetic_register_phenotype: not enough"
+				"memory\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < 2; i++) {
+		pt->top_fitness[i] = (long long **)kmalloc(sizeof(long long **) * 2, GFP_KERNEL);
+		if (!pt->top_fitness[i]) {
+			printk(KERN_ERR "genetic_register_phenotype: not"
+					"enough memory\n");
+			return -ENOMEM;
+		}
+
+		for (j = 0; j < 2; j++) {
+			pt->top_fitness[i][j] = (long long *)kmalloc(
+					sizeof(long long *) * 2,
+					GFP_KERNEL);
+
+			if (!pt->top_fitness[i][j]) {
+				printk(KERN_ERR "genetic_register_phenotype: "
+						"not enough memory\n");
+				return -ENOMEM;
+			}
+
+			for (k = 0; k < 2; k++) {
+				pt->top_fitness[i][j][k] = 0;
+			}
+		}
+	}
+
+	pt->last_fingerprint = 0;
+
+	if (pt->genetic->fingerprinting_dir) {
+		pt->fp_dir = genetic_create_tree(pt->name,
+						 pt->genetic->fingerprinting_dir);
+
+		if (ops->top_fitness_show)
+			debugfs_create_file("top_fitness", S_IFREG|S_IRUGO,
+				pt->fp_dir, pt, &top_fitness_ops);
+
+		if (ops->snapshot_show)
+			debugfs_create_file("snapshot", S_IFREG|S_IRUGO,
+				pt->fp_dir, pt, &snapshot_ops);
+
+		if (ops->state_show)
+			debugfs_create_file("state", S_IFREG|S_IRUGO,
+				pt->fp_dir, pt, &state_ops);
+	}
+
+	return 0;
+}
+
+static void decay_fitness(phenotype_t * pt, struct fingerprint * fp)
+{
+	long long fitness;
+	long dummy;
+
+	fitness = get_top_fitness(pt, fp);
+
+	/* reduce the fitness to eventually get new genes in */
+	fitness *= FP_DECAY;
+	divll(&fitness, 100, &dummy);
+
+	pt->top_fitness[fp->type][fp->pattern][fp->size] = fitness;
+}
+
+static void update_phenotype_top_performer(phenotype_t * pt, struct fingerprint * fp)
+{
+	long long top_fitness;
+	unsigned long * genes;
+	long long * avg_genes;
+	long dummy;
+	int i, j;
+
+
+	/* Decay the top fitness so not to have a fluke and have a
+	 * high set which are less than optimal.  So decay the top
+	 * fitness so eventually these genes are phased out.
+	 */
+	decay_fitness(pt, fp);
+
+	top_fitness = get_top_fitness(pt, fp);
+
+	if (pt->last_gen_avg_fitness >= top_fitness) {
+
+		pt->top_fitness[fp->type][fp->pattern][fp->size] = pt->last_gen_avg_fitness;
+
+		/* We don't need to track this if there's no genes! */
+		if (!pt->num_genes)
+			return;
+
+		avg_genes = (long long *)kmalloc(sizeof(long long) * pt->num_genes, GFP_KERNEL);
+		if (!avg_genes) {
+			printk(KERN_ERR "update_top_performers: unable to alloc space\n");
+			return;
+		}
+
+		memset(avg_genes, 0, sizeof(long long) * pt->num_genes);
+
+		for (i = 0; i < pt->num_genes; i++) {
+			for (j = 0; j < pt->num_children; j++) {
+				genes = pt->child_ranking[j]->genes;
+				avg_genes[i] += genes[i];
+			}
+		}
+
+		for (j = 0; j < pt->num_genes; j++)
+			divll(&avg_genes[j], pt->num_children, &dummy);
+
+		genes = (unsigned long *)pt->top_child[fp->type][fp->pattern][fp->size];
+		for (j = 0; j < pt->num_genes; j++)
+			genes[j] = avg_genes[j];
+
+		kfree(avg_genes);
+	}
+}
+
+static void update_top_performers(phenotype_t * master)
+{
+	phenotype_t * pt;
+	struct list_head * p;
+
+	list_for_each(p, &master->genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+
+		if (master->uid & pt->uid && master->uid != pt->uid) {
+			update_phenotype_top_performer(pt, master->fp);
+		}
+	}
+	update_phenotype_top_performer(master, master->fp);
+}
+
+static void reintroduce_genes(phenotype_t * master)
+{
+	struct fingerprint * fp = master->fp;
+	phenotype_t * pt;
+	unsigned long * top_genes;
+	unsigned long * genes;
+	struct list_head * p;
+	int i;
+
+	list_for_each(p, &master->genetic->phenotype) {
+		pt = list_entry(p, phenotype_t, phenotype);
+
+		if (pt->num_genes) {
+
+			/* Do this more intelligently, so can have n-points on
+			   the fingerprint */
+			/* just take the first one */
+			top_genes = (unsigned long *)pt->top_child[fp->type][fp->pattern][fp->size];
+			genes = pt->child_ranking[0]->genes;
+			for (i = 0; i < pt->num_children; i++)
+				genes[i] = top_genes[i];
+		}
+	}
+}
Index: linux-2.6.23/include/linux/fingerprinting.h
===================================================================
--- /dev/null
+++ linux-2.6.23/include/linux/fingerprinting.h
@@ -0,0 +1,125 @@
+#ifndef __LINUX_FINGERPRINTING_H
+#define __LINUX_FINGERPRINTING_H
+
+/*
+ * include/linux/fingerprinting.h
+ *
+ * Jake Moilanen <moilanen@austin.ibm.com>
+ * Copyright (C) 2006 IBM
+ *
+ * I/O Workload Fingerprinting
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+*/
+
+#include <linux/types.h>
+#include <linux/bio.h>
+
+#define FP_TYPE_READ	0
+#define FP_TYPE_WRITE	1
+#define FP_PATTERN_SEQ	0
+#define FP_PATTERN_RAND	1
+#define FP_SIZE_SMALL	0
+#define FP_SIZE_LARGE	1
+#define FP_NUM_POINTS	(2 * 2 * 2)
+
+struct fingerprint {
+	__u8 type;
+	__u8 pattern;
+	__u8 size;
+};
+
+struct fp_snapshot {
+	/* type */
+	unsigned long reads;
+	unsigned long writes;
+	/* pattern */
+	unsigned long head_pos;
+	unsigned long avg_dist;
+	/* size */
+	unsigned long avg_size;
+};
+
+/* Number of reads/writes before classified as read */
+#define FP_CLASS_READ_WRITE_RATIO	2
+
+/* Number of sectors before pattern is random */
+#define FP_CLASS_PATTERN_RAND		25
+
+/* Number of sectors before size is large */
+#define FP_CLASS_SIZE_LARGE		8
+
+extern void update_fp_snapshot(struct bio * bio);
+extern void calc_fp(struct fingerprint * fp, struct fp_snapshot * fp_ss);
+extern void reset_fp_snapshot(struct fp_snapshot * ss);
+extern void reset_fp(struct fingerprint * fp);
+extern void consolidate_fp_snapshot(struct fp_snapshot * master, struct fp_snapshot * instance);
+extern int fingerprint_state_show(struct seq_file *s, void *unused);
+extern int fingerprint_snapshot_show(struct seq_file *s, void *unused);
+extern int fingerprint_top_fitness_show(struct seq_file *s, void *unused);
+
+/* XXX do this more intelligently */
+#ifndef DIVLL_OP
+#define DIVLL_OP
+#if BITS_PER_LONG >= 64
+
+static inline void divll(long long *n, long div, long *rem)
+{
+        *rem = *n % div;
+        *n /= div;
+}
+
+#else
+
+static inline void divl(int32_t high, int32_t low,
+                        int32_t div,
+                        int32_t *q, int32_t *r)
+{
+        int64_t n = (u_int64_t)high << 32 | low;
+        int64_t d = (u_int64_t)div << 31;
+        int32_t q1 = 0;
+        int c = 32;
+        while (n > 0xffffffff) {
+                q1 <<= 1;
+                if (n >= d) {
+                        n -= d;
+                        q1 |= 1;
+                }
+                d >>= 1;
+                c--;
+        }
+        q1 <<= c;
+        if (n) {
+                low = n;
+                *q = q1 | (low / div);
+                *r = low % div;
+        } else {
+                *r = 0;
+                *q = q1;
+        }
+        return;
+}
+
+static inline void divll(long long *n, long div, long *rem)
+{
+        int32_t low, high;
+        low = *n & 0xffffffff;
+        high = *n >> 32;
+        if (high) {
+                int32_t high1 = high % div;
+                int32_t low1 = low;
+                high /= div;
+                divl(high1, low1, div, &low, (int32_t *)rem);
+                *n = (int64_t)high << 32 | low;
+        } else {
+                *n = low / div;
+                *rem = low % div;
+        }
+}
+#endif
+
+#endif /* #ifndef divll */
+
+#endif /* __LINUX_FINGERPRINTINT_H */
Index: linux-2.6.23/block/fingerprinting.c
===================================================================
--- /dev/null
+++ linux-2.6.23/block/fingerprinting.c
@@ -0,0 +1,205 @@
+/*
+ * block/fingerprinting.c
+ *
+ * Jake Moilanen <moilanen@austin.ibm.com>
+ * Copyright (C) 2006 IBM
+ *
+ * I/O Workload Fingerprinting
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation. 
+*/
+/* TODOS:
+ * - Abstract so no so IO specific
+ * - Abstract types
+ */
+
+#include <linux/genhd.h>
+#include <linux/blkdev.h>
+#include <linux/fingerprinting.h>
+#include <linux/genetic.h>
+
+int fingerprint_state_show(struct seq_file *s, void *unused)
+{
+	phenotype_t * pt = (phenotype_t *)s->private;
+	struct fingerprint * fp = pt->fp;
+
+	if (fp->type == FP_TYPE_READ)
+		seq_printf(s,    "read\t(%d)\n", FP_TYPE_READ);
+	else
+		seq_printf(s,    "write\t(%d)\n", FP_TYPE_WRITE);
+
+	if (fp->pattern == FP_PATTERN_SEQ)
+		seq_printf(s,    "sequential\t(%d)\n", FP_PATTERN_SEQ);
+	else
+		seq_printf(s,    "random\t(%d)\n", FP_PATTERN_RAND);
+
+	if (fp->size == FP_SIZE_SMALL)
+		seq_printf(s,    "small\t(%d)\n", FP_SIZE_SMALL);
+	else
+		seq_printf(s,    "large\t(%d)\n", FP_SIZE_LARGE);
+
+	return 0;
+}
+
+int fingerprint_snapshot_show(struct seq_file *s, void *unused)
+{
+	phenotype_t * pt = (phenotype_t *)s->private;
+	struct fp_snapshot * ss = pt->fp_ss;
+
+	seq_printf(s,    "read: %ld\n", ss->reads);
+	seq_printf(s,    "write: %ld\n", ss->writes);
+
+	seq_printf(s,    "avg_dist: %ld\n", ss->avg_dist);
+	seq_printf(s,    "avg_size: %ld\n", ss->avg_size);
+
+	return 0;
+}
+
+
+int fingerprint_top_fitness_show(struct seq_file *s, void *unused)
+{
+	int i, j, k;
+	phenotype_t * pt = (phenotype_t *)s->private;
+
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < 2; j++)
+			for (k = 0; k < 2; k++)
+				seq_printf(s, "top_fitness[%d][%d][%d]: %lld\n",
+					     i, j, k, pt->top_fitness[i][j][k]);
+
+	return 0;
+}
+
+
+/* This assumes that address matches up w/ head_pos */
+static void update_avg_dist(struct fp_snapshot * ss, long head_pos)
+{
+	long long tmp_dist;
+	unsigned long total_ops = ss->reads + ss->writes;
+	long dummy;
+
+	/* set it the first time through */
+	if (!ss->head_pos) {
+		ss->head_pos = head_pos;
+		return;
+	}
+	tmp_dist = ss->head_pos - head_pos;
+	if (tmp_dist < 0)
+		tmp_dist = -tmp_dist;
+
+	tmp_dist = tmp_dist - ss->avg_dist;
+
+	divll(&tmp_dist, total_ops, &dummy);
+	ss->avg_dist += tmp_dist;
+
+	ss->head_pos = head_pos;
+
+}
+
+static void update_avg_size(struct fp_snapshot * ss, unsigned long size)
+{
+	unsigned long total_ops = ss->reads + ss->writes;
+	long long tmp_size;
+	long dummy;
+
+	tmp_size = size - ss->avg_size;
+	divll(&tmp_size, total_ops, &dummy);
+	ss->avg_size += tmp_size;
+//	ss->avg_size += (size - ss->avg_size) / total_ops;
+}
+
+void update_fp_snapshot(struct bio * bio)
+{
+	struct fp_snapshot * ss = bio->bi_bdev->bd_disk->fp_ss;
+
+	/* update type */
+	if (bio_data_dir(bio) == READ)
+		ss->reads++;
+	else
+		ss->writes++;
+
+	/* update pattern */
+//	update_avg_dist(ss, bio_to_phys(bio));
+	update_avg_dist(ss, bio->bi_sector);
+
+	/* update size */
+//	update_avg_size(ss, bio_iovec(bio)->bv_len);
+	update_avg_size(ss, bio_sectors(bio));
+
+}
+
+/* Use this when there's multiple disks, and need to consolidate to a
+ * system wide fingerprint
+ */
+void consolidate_fp_snapshot(struct fp_snapshot * master, struct fp_snapshot * instance)
+{
+	unsigned long total_ops;
+	long dummy;
+	long long total_dist;
+	long long total_size;
+
+	BUG_ON(!master);
+	BUG_ON(!instance);
+
+	total_dist = master->avg_dist * (master->reads + master->writes);
+	total_size = master->avg_size * (master->reads + master->writes);
+
+	/* update operations */
+	master->reads += instance->reads;
+	master->writes += instance->writes;
+	total_ops = master->reads + master->writes;
+
+	/* update distance */
+	total_dist += (instance->avg_dist * (instance->reads + instance->writes));
+	if (total_ops) {
+		divll(&total_dist, total_ops, &dummy);
+		master->avg_dist = total_dist;
+	} else
+		master->avg_dist = 0;
+
+	/* update size */
+	total_size += (instance->avg_size * (instance->reads + instance->writes));
+	if (total_ops) {
+		divll(&total_size, total_ops, &dummy);
+		master->avg_size = total_size;
+	} else
+		master->avg_size = 0;
+}
+
+void reset_fp_snapshot(struct fp_snapshot * ss)
+{
+	memset(ss, 0, sizeof(struct fp_snapshot));
+}
+
+void reset_fp(struct fingerprint * fp)
+{
+	memset(fp, 0, sizeof(struct fingerprint));
+}
+
+//void calc_fp(struct fingerprint * fp, struct fp_snapshot * fp_ss, struct block_device * dev)
+void calc_fp(struct fingerprint * fp, struct fp_snapshot * fp_ss)
+{
+	/* type */
+	if (fp_ss->reads > (fp_ss->writes * FP_CLASS_READ_WRITE_RATIO))
+		fp->type = FP_TYPE_READ;
+	else
+		fp->type = FP_TYPE_WRITE;
+
+	/* pattern */
+//	if (fp_ss->avg_dist >= (block_size(dev) * FP_CLASS_PATTERN_RAND))
+	if (fp_ss->avg_dist >= (512 * FP_CLASS_PATTERN_RAND))
+		fp->pattern = FP_PATTERN_RAND;
+	else
+		fp->pattern = FP_PATTERN_SEQ;
+
+	/* size */
+	if (fp_ss->avg_size > FP_CLASS_SIZE_LARGE)
+		fp->size = FP_SIZE_LARGE;
+	else
+		fp->size = FP_SIZE_SMALL;
+}
+
+
+
Index: linux-2.6.23/block/ll_rw_blk.c
===================================================================
--- linux-2.6.23.orig/block/ll_rw_blk.c
+++ linux-2.6.23/block/ll_rw_blk.c
@@ -30,6 +30,7 @@
 #include <linux/cpu.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
+#include <linux/fingerprinting.h>
 
 /*
  * for max sense size
@@ -2893,6 +2894,9 @@ static void init_request_from_bio(struct
 {
 	req->cmd_type = REQ_TYPE_FS;
 
+#ifdef CONFIG_FINGERPRINTING
+	update_fp_snapshot(bio);
+#endif
 	/*
 	 * inherit FAILFAST from bio (for read-ahead, and explicit FAILFAST)
 	 */
Index: linux-2.6.23/include/linux/genhd.h
===================================================================
--- linux-2.6.23.orig/include/linux/genhd.h
+++ linux-2.6.23/include/linux/genhd.h
@@ -67,6 +67,7 @@ struct partition {
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/fingerprinting.h>
 
 struct partition {
 	unsigned char boot_ind;		/* 0x80 - active */
@@ -91,6 +92,7 @@ struct gendisk {
 	struct disk_stats dkstats;
 #endif
 	struct work_struct async_notify;
+	struct fp_snapshot * fp_ss;
 };
 
 /* Structure for sysfs attributes on block devices */
Index: linux-2.6.23/block/genhd.c
===================================================================
--- linux-2.6.23.orig/block/genhd.c
+++ linux-2.6.23/block/genhd.c
@@ -445,6 +445,20 @@ static ssize_t disk_stats_read(struct ge
 		jiffies_to_msecs(disk_stat_read(disk, io_ticks)),
 		jiffies_to_msecs(disk_stat_read(disk, time_in_queue)));
 }
+static ssize_t disk_fp_read(struct gendisk * disk, char *page)
+{
+	return sprintf(page, "reads: %llx\n"
+		       "writes: %llx\n"
+		       "head_pos: %llx\n"
+		       "avg_dist: %llx\n"
+		       "avg_size: %llx\n",
+		       (unsigned long long)disk->fp_ss->reads,
+		       (unsigned long long)disk->fp_ss->writes,
+		       (unsigned long long)disk->fp_ss->head_pos,
+		       (unsigned long long)disk->fp_ss->avg_dist,
+		       (unsigned long long)disk->fp_ss->avg_size);
+}
+
 static struct disk_attribute disk_attr_uevent = {
 	.attr = {.name = "uevent", .mode = S_IWUSR },
 	.store	= disk_uevent_store
@@ -473,6 +487,10 @@ static struct disk_attribute disk_attr_s
 	.attr = {.name = "stat", .mode = S_IRUGO },
 	.show	= disk_stats_read
 };
+static struct disk_attribute disk_attr_fp = {
+	.attr = {.name = "fp", .mode = S_IRUGO },
+	.show	= disk_fp_read
+};
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 
@@ -513,6 +531,7 @@ static struct attribute * default_attrs[
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&disk_attr_fail.attr,
 #endif
+	&disk_attr_fp.attr,
 	NULL,
 };
 
@@ -745,6 +764,10 @@ struct gendisk *alloc_disk_node(int mino
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
 	}
+
+	disk->fp_ss = kmalloc(sizeof(struct fp_snapshot), GFP_KERNEL);
+	memset(disk->fp_ss, 0, sizeof(struct fp_snapshot));
+
 	return disk;
 }
 
Index: linux-2.6.23/block/Kconfig
===================================================================
--- linux-2.6.23.orig/block/Kconfig
+++ linux-2.6.23/block/Kconfig
@@ -65,3 +65,9 @@ config BLK_DEV_BSG
 endif # BLOCK
 
 source block/Kconfig.iosched
+
+config FINGERPRINTING
+       bool "I/O Workload Fingerprinting"
+       help
+         Say Y here if you want workload data to be classified and
+         used to tune the I/O schedulers.  Otherwise say N.
\ No newline at end of file
Index: linux-2.6.23/block/Makefile
===================================================================
--- linux-2.6.23.orig/block/Makefile
+++ linux-2.6.23/block/Makefile
@@ -11,3 +11,6 @@ obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadli
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
+
+
+obj-$(CONFIG_FINGERPRINTING)	+= fingerprinting.o

--------------020402080701000302020407
Content-Type: text/x-diff;
 name="improve-relatime-2.6.23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="improve-relatime-2.6.23.patch"

Subject: [patch] [patch] implement smarter atime updates support
From: Ingo Molnar <mingo@elte.hu>

change relatime updates to be performed once per day. This makes
relatime a compatible solution for HSM, mailer-notification and
tmpwatch applications too.

also add the CONFIG_DEFAULT_RELATIME kernel option, which makes
"norelatime" the default for all mounts without an extra kernel
boot option.

add the "default_relatime=0" boot option to turn this off.

also add the /proc/sys/fs/default_relatime flag which can be changed
runtime to modify the behavior of subsequent new mounts.

tested by moving the date forward:

   # date
   Sun Aug  5 22:55:14 CEST 2007
   # date -s "Tue Aug  7 22:55:14 CEST 2007"
   Tue Aug  7 22:55:14 CEST 2007

access to a file did not generate disk IO before the date was set, and
it generated exactly one IO after the date was set.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    8 +++++
 fs/Kconfig                          |   22 ++++++++++++++
 fs/inode.c                          |   53 +++++++++++++++++++++++++++---------
 fs/namespace.c                      |   24 ++++++++++++++++
 include/linux/mount.h               |    3 ++
 kernel/sysctl.c                     |   17 +++++++++++
 6 files changed, 114 insertions(+), 13 deletions(-)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -525,6 +525,10 @@ and is between 256 and 4096 characters. 
 			This is a 16-member array composed of values
 			ranging from 0-255.
 
+	default_relatime=
+			[FS] mount all filesystems with relative atime
+			updates by default.
+
 	default_utf8=   [VT]
 			Format=<0|1>
 			Set system-wide default UTF-8 mode for all tty's.
@@ -1468,6 +1472,10 @@ and is between 256 and 4096 characters. 
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
 			See arch/*/kernel/reboot.c or arch/*/kernel/process.c			
 
+	relatime_interval=
+			[FS] relative atime update frequency, in seconds.
+			(default: 1 day: 86400 seconds)
+
 	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
 
 	reservetop=	[X86-32]
Index: linux/fs/Kconfig
===================================================================
--- linux.orig/fs/Kconfig
+++ linux/fs/Kconfig
@@ -2060,6 +2060,28 @@ config 9P_FS
 
 endmenu
 
+config DEFAULT_RELATIME
+	bool "Mount all filesystems with relatime by default"
+	default y
+	help
+	  If you say Y here, all your filesystems will be mounted
+	  with the "relatime" mount option. This eliminates many atime
+	  ('file last accessed' timestamp) updates (which otherwise
+	  is performed on every file access and generates a write
+	  IO to the inode) and thus speeds up IO. Atime is still updated,
+	  but only once per day.
+
+	  The mtime ('file last modified') and ctime ('file created')
+	  timestamp are unaffected by this change.
+
+	  Use the "norelatime" kernel boot option to turn off this
+	  feature.
+
+config DEFAULT_RELATIME_VAL
+	int
+	default "1" if DEFAULT_RELATIME
+	default "0"
+
 if BLOCK
 menu "Partition Types"
 
Index: linux/fs/inode.c
===================================================================
--- linux.orig/fs/inode.c
+++ linux/fs/inode.c
@@ -1162,6 +1162,41 @@ sector_t bmap(struct inode * inode, sect
 }
 EXPORT_SYMBOL(bmap);
 
+/*
+ * Relative atime updates frequency (default: 1 day):
+ */
+int relatime_interval __read_mostly = 24*60*60;
+
+/*
+ * With relative atime, only update atime if the
+ * previous atime is earlier than either the ctime or
+ * mtime.
+ */
+static int relatime_need_update(struct inode *inode, struct timespec now)
+{
+	/*
+	 * Is mtime younger than atime? If yes, update atime:
+	 */
+	if (timespec_compare(&inode->i_mtime, &inode->i_atime) >= 0)
+		return 1;
+	/*
+	 * Is ctime younger than atime? If yes, update atime:
+	 */
+	if (timespec_compare(&inode->i_ctime, &inode->i_atime) >= 0)
+		return 1;
+
+	/*
+	 * Is the previous atime value older than a day? If yes,
+	 * update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= relatime_interval)
+		return 1;
+	/*
+	 * Good, we can skip the atime update:
+	 */
+	return 0;
+}
+
 /**
  *	touch_atime	-	update the access time
  *	@mnt: mount the inode is accessed on
@@ -1191,22 +1226,14 @@ void touch_atime(struct vfsmount *mnt, s
 			return;
 		if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
 			return;
-
-		if (mnt->mnt_flags & MNT_RELATIME) {
-			/*
-			 * With relative atime, only update atime if the
-			 * previous atime is earlier than either the ctime or
-			 * mtime.
-			 */
-			if (timespec_compare(&inode->i_mtime,
-						&inode->i_atime) < 0 &&
-			    timespec_compare(&inode->i_ctime,
-						&inode->i_atime) < 0)
+	}
+	now = current_fs_time(inode->i_sb);
+	if (mnt) {
+		if (mnt->mnt_flags & MNT_RELATIME)
+			if (!relatime_need_update(inode, now))
 				return;
-		}
 	}
 
-	now = current_fs_time(inode->i_sb);
 	if (timespec_equal(&inode->i_atime, &now))
 		return;
 
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c
+++ linux/fs/namespace.c
@@ -1107,6 +1107,7 @@ int do_add_mount(struct vfsmount *newmnt
 		goto unlock;
 
 	newmnt->mnt_flags = mnt_flags;
+
 	if ((err = graft_tree(newmnt, nd)))
 		goto unlock;
 
@@ -1362,6 +1363,24 @@ int copy_mount_options(const void __user
 }
 
 /*
+ * Allow users to disable (or enable) atime updates via a .config
+ * option or via the boot line, or via /proc/sys/fs/default_relatime:
+ */
+int default_relatime __read_mostly = CONFIG_DEFAULT_RELATIME_VAL;
+
+static int __init set_default_relatime(char *str)
+{
+	get_option(&str, &default_relatime);
+
+	printk(KERN_INFO "Mount all filesystems with"
+		"default relative atime updates: %s.\n",
+		default_relatime ? "enabled" : "disabled");
+
+	return 1;
+}
+__setup("default_relatime=", set_default_relatime);
+
+/*
  * Flags is a 32-bit value that allows up to 31 non-fs dependent flags to
  * be given to the mount() call (ie: read-only, no-dev, no-suid etc).
  *
@@ -1409,6 +1428,11 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	else if (default_relatime &&
+				!(flags & (MNT_NOATIME | MNT_NODIRATIME))) {
+		mnt_flags |= MNT_RELATIME;
+		flags |= MS_RELATIME;
+	}
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME);
Index: linux/include/linux/mount.h
===================================================================
--- linux.orig/include/linux/mount.h
+++ linux/include/linux/mount.h
@@ -103,5 +103,8 @@ extern void shrink_submounts(struct vfsm
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
 
+extern int default_relatime;
+extern int relatime_interval;
+
 #endif
 #endif /* _LINUX_MOUNT_H */
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -30,6 +30,7 @@
 #include <linux/capability.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/kobject.h>
@@ -1206,6 +1207,22 @@ static ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "default_relatime",
+		.data		= &default_relatime,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "relatime_interval",
+		.data		= &relatime_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
 		.ctl_name	= CTL_UNNUMBERED,

--------------020402080701000302020407
Content-Type: text/x-diff;
 name="sched-cfs-boost-2.6.23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched-cfs-boost-2.6.23.patch"

---
 arch/i386/kernel/ioport.c   |   17 ++++++++++++++---
 arch/x86_64/kernel/ioport.c |   12 ++++++++++--
 drivers/block/loop.c        |    5 ++++-
 include/linux/sched.h       |    7 +++++++
 kernel/Kconfig.preempt      |   17 +++++++++++++++++
 kernel/sched.c              |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c          |    2 +-
 mm/oom_kill.c               |    4 +++-
 8 files changed, 96 insertions(+), 8 deletions(-)

Index: linux/arch/i386/kernel/ioport.c
===================================================================
--- linux.orig/arch/i386/kernel/ioport.c
+++ linux/arch/i386/kernel/ioport.c
@@ -64,9 +64,17 @@ asmlinkage long sys_ioperm(unsigned long
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
+	if (turn_on) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		/*
+		 * Task will be accessing hardware IO ports,
+		 * mark it as special with the scheduler too:
+		 */
+#ifdef CONFIG_BOOST_PRIVILEGED_TASKS
+		sched_privileged_task(current);
+#endif
+	}
 	/*
 	 * If it's the first ioperm() call in this thread's lifetime, set the
 	 * IO bitmap up. ioperm() is much less timing critical than clone(),
@@ -145,6 +153,9 @@ asmlinkage long sys_iopl(unsigned long u
 	if (level > old) {
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+#ifdef CONFIG_BOOST_PRIVILEGED_TASKS
+		sched_privileged_task(current);
+#endif
 	}
 	t->iopl = level << 12;
 	regs->eflags = (regs->eflags & ~X86_EFLAGS_IOPL) | t->iopl;
Index: linux/arch/x86_64/kernel/ioport.c
===================================================================
--- linux.orig/arch/x86_64/kernel/ioport.c
+++ linux/arch/x86_64/kernel/ioport.c
@@ -41,8 +41,13 @@ asmlinkage long sys_ioperm(unsigned long
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
+	if (turn_on) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+#ifdef CONFIG_BOOST_PRIVILEGED_TASKS
+		sched_privileged_task(current);
+#endif
+	}
 
 	/*
 	 * If it's the first ioperm() call in this thread's lifetime, set the
@@ -113,6 +118,9 @@ asmlinkage long sys_iopl(unsigned int le
 	if (level > old) {
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+#ifdef CONFIG_BOOST_PRIVILEGED_TASKS
+		sched_privileged_task(current);
+#endif
 	}
 	regs->eflags = (regs->eflags &~ X86_EFLAGS_IOPL) | (level << 12);
 	return 0;
Index: linux/drivers/block/loop.c
===================================================================
--- linux.orig/drivers/block/loop.c
+++ linux/drivers/block/loop.c
@@ -577,7 +577,12 @@ static int loop_thread(void *data)
 	struct loop_device *lo = data;
 	struct bio *bio;
 
	set_user_nice(current, -20);
+
+	/*
+	 * The loop thread is important enough to be given a boost:
+	 */
+	sched_privileged_task(current);
 
 	while (!kthread_should_stop() || lo->lo_bio) {
 
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1336,6 +1336,13 @@ static inline int rt_mutex_getprio(struc
 #endif
 
 extern void set_user_nice(struct task_struct *p, long nice);
+/*
+ * Task has special privileges, give it more CPU power:
+ */
+extern void sched_privileged_task(struct task_struct *p);
+
+extern int sysctl_sched_privileged_nice_level;
+
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
 extern int can_nice(const struct task_struct *p, const int nice);
Index: linux/kernel/Kconfig.preempt
===================================================================
--- linux.orig/kernel/Kconfig.preempt
+++ linux/kernel/Kconfig.preempt
@@ -63,3 +63,20 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config BOOST_PRIVILEGED_TASKS
+	bool "Boost privileged tasks"
+	default y
+	help
+	  This option instructs the kernel to guarantee more CPU time to
+	  some privileged tasks (like X), which is useful if you want to have a
+	  faster desktop even under high system load.
+
+	  This option works by automatically boosting task's priority via
+	  renicing it. NOTE: CFS does not suffer from "overscheduling"
+	  problems when some tasks are reniced, so if this is a
+	  predominantly desktop box it makes sense to select this
+	  option.
+
+	  Say Y here if you are building a kernel for a desktop system.
+	  Say N if you want X to be treated as a normal task.
+
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3608,6 +3608,53 @@ out_unlock:
 EXPORT_SYMBOL(set_user_nice);
 
 /*
+ * Nice level for privileged tasks. (can be set to 0 for this
+ * to be turned off)
+ */
+int sysctl_sched_privileged_nice_level __read_mostly = -10;
+
+static int __init privileged_nice_level_setup(char *str)
+{
+	sysctl_sched_privileged_nice_level = simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("privileged_nice_level=", privileged_nice_level_setup);
+
+/*
+ * Tasks with special privileges call this and gain extra nice
+ * levels:
+ */
+void sched_privileged_task(struct task_struct *p)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	long new_nice = sysctl_sched_privileged_nice_level;
+	long old_nice = TASK_NICE(p);
+
+	if (new_nice >= old_nice)
+		return;
+	/*
+	 * Setting the sysctl to 0 turns off the boosting:
+	 */
+	if (unlikely(!new_nice))
+		return;
+
+	if (new_nice < -20)
+		new_nice = -20;
+	else if (new_nice > 19)
+		new_nice = 19;
+
+	set_user_nice(p, new_nice);
+
+	/* Set real-time policy */
+	if (!task_has_rt_policy(p)) {
+		sched_setscheduler(p, SCHED_FIFO, &param);
+		p->ioprio = (IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT) | 4;
+	}
+}
+
+EXPORT_SYMBOL(sched_privileged_task);
+
+/*
  * can_nice - check if a task can reduce its nice value
  * @p: task
  * @nice: nice value
Index: linux/kernel/workqueue.c
===================================================================
--- linux.orig/kernel/workqueue.c
+++ linux/kernel/workqueue.c
@@ -285,7 +285,8 @@ static int worker_thread(void *__cwq)
 	if (cwq->wq->freezeable)
 		set_freezable();
 
 	set_user_nice(current, -5);
+	sched_privileged_task(current);
 
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
Index: linux/mm/oom_kill.c
===================================================================
--- linux.orig/mm/oom_kill.c
+++ linux/mm/oom_kill.c
@@ -295,7 +295,9 @@ static void __oom_kill_task(struct task_
 	 * all the memory it needs. That way it should be able to
 	 * exit() and clear out its resources quickly...
 	 */
-	p->time_slice = HZ;
+	if (p->policy == SCHED_NORMAL || p->policy == SCHED_BATCH)
+		sched_privileged_task(p);
+
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 
 	force_sig(SIGKILL, p);
Index: linux/fs/jbd/journal.c
===================================================================
--- linux.orig/fs/jbd/journal.c
+++ linux/fs/jbd/journal.c
@@ -131,6 +132,8 @@ static int kjournald(void *arg)
 	printk(KERN_INFO "kjournald starting.  Commit interval %ld seconds\n",
 			journal->j_commit_interval / HZ);
 
+	sched_privileged_task(current);
+
 	/*
 	 * And now, wait forever for commit wakeup events.
 	 */

--------------020402080701000302020407
Content-Type: text/x-diff;
 name="sched-cfs-tunables-2.6.23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched-cfs-tunables-2.6.23.patch"

Index: linux-2.6.23-cfs/init/Kconfig
===================================================================
--- linux-2.6.23-cfs.orig/init/Kconfig
+++ linux-2.6.23-cfs/init/Kconfig
@@ -1,3 +1,5 @@
+source "init/Kconfig.cfs"
+
 config DEFCONFIG_LIST
 	string
 	depends on !UML
Index: linux-2.6.21-cfs/init/Kconfig.cfs
===================================================================
--- linux-2.6.23-cfs.orig/init/Kconfig.cfs
+++ linux-2.6.23-cfs/init/Kconfig.cfs
@@ -0,0 +1,130 @@
+menu "Completely Fair Scheduler Tunables"
+
+choice
+	prompt "CFS predefined setups"
+	default INTERACTIVE_DESKTOP
+
+config FAIR_DESKTOP
+	bool "Fair Desktop/Server"
+	help
+	  Fair Desktop.
+	  Use this option if you want a stable and fair desktop.
+
+	  Privileged tasks won't be reniced and "preemption latency" won't be
+	  modified.
+
+config INTERACTIVE_DESKTOP
+	bool "Interactive Desktop (Recommended)"
+	select BOOST_PRIVILEGED_TASKS
+	help
+	  Interactive Desktop.
+	  Use this option if you want a interactive desktop.
+
+	  Privileged tasks will be reniced to -10 value and "preemption latency"
+	  will be decreased in 0.5 msec.
+
+config HIGHLY_INTERACTIVE_DESKTOP	
+	bool "Highly Interactive Desktop"
+	select BOOST_PRIVILEGED_TASKS
+	help
+	  Highly Interactive Desktop.
+	  Use this option if you want a very high interactive desktop.
+
+	  Privileged tasks will be reniced to -19 value and "preemption latency"
+	  will be decreased in 1 msec.
+
+	  This option is not recommended, UNLESS you have really high latencies.
+
+config CUSTOM_SCHED_SETUP
+	bool "Custom scheduler Setup"
+	select BOOST_PRIVILEGED_TASKS
+	help
+	  Custom setup.
+	  Manual setup of "Completely Fair Scheduler" by the user.
+
+endchoice
+
+config CUSTOM_PRIVILEGED_TASKS_NICE_VALUE
+	int "Custom nice value for privileged tasks"
+	depends CUSTOM_SCHED_SETUP
+	range -20 20
+	default -10
+	help
+	  Privileged tasks default nice value.
+
+config CUSTOM_SCHED_LATENCY
+	int "Custom targeted preemption latency"
+	depends CUSTOM_SCHED_SETUP
+	range 0 100000
+	default 20000
+	help
+	  Targeted preemption latency value (in microseconds).
+
+config CUSTOM_SCHED_MIN_GRANULARITY
+	int "Custom minimal preemption granularity"
+	depends CUSTOM_SCHED_SETUP
+	range 0 10000
+	default 2000
+	help
+	  Minimal targeted preemption latency value (in microseconds).
+
+config CUSTOM_SCHED_WAKEUP_GRANULARITY
+	int "Custom SCHED_OTHER wakeup granularity"
+	depends CUSTOM_SCHED_SETUP
+	range 0 100000
+	default 1000
+	help
+	  SCHED_OTHER wakeup granularity value (in microseconds).
+
+config CUSTOM_SCHED_BATCH_WAKEUP_GRANULARITY
+	int "Custom SCHED_BATCH wakeup granularity"
+	depends CUSTOM_SCHED_SETUP
+	range 0 100000
+	default 25000
+	help
+	  SCHED_BATCH wakeup granularity value (in microseconds).
+
+config SYSCTL_PRIVILEGED_NICE_LEVEL
+	bool "Change privileged tasks nice level through sysctl"
+	default n
+	help
+	  If this option is enabled, a file called "sched_privileged_nice_level" will be created
+	  on /proc/sys/kernel that will allow to modify the privileged tasks priority.
+
+	  This *ONLY* will take effect on tasks that are executed after the change.
+
+endmenu
+
+config PRIVILEGED_TASKS_NICE_LEVEL
+	int
+	default 0 if FAIR_DESKTOP
+	default -10 if INTERACTIVE_DESKTOP
+	default -19 if HIGHLY_INTERACTIVE_DESKTOP
+	default CUSTOM_PRIVILEGED_TASKS_NICE_VALUE if CUSTOM_SCHED_SETUP
+
+config SCHED_LATENCY
+	int
+	default 20000 if FAIR_DESKTOP
+	default 15000 if INTERACTIVE_DESKTOP
+	default 10000 if HIGHLY_INTERACTIVE_DESKTOP
+	default CUSTOM_SCHED_LATENCY if CUSTOM_SCHED_SETUP
+
+config SCHED_MIN_GRANULARITY
+	int
+	default 2000 if FAIR_DESKTOP
+	default 1500 if INTERACTIVE_DESKTOP
+	default 1000 if HIGHLY_INTERACTIVE_DESKTOP
+	default CUSTOM_SCHED_MIN_GRANULARITY if CUSTOM_SCHED_SETUP
+
+config SCHED_WAKEUP_GRANULARITY
+	int
+	default 1000 if FAIR_DESKTOP
+	default 500 if INTERACTIVE_DESKTOP
+	default 100 if HIGHLY_INTERACTIVE_DESKTOP
+	default CUSTOM_SCHED_WAKEUP_GRANULARITY if CUSTOM_SCHED_SETUP
+
+config SCHED_BATCH_WAKEUP_GRANULARITY
+	int
+	default 25000 if FAIR_DESKTOP
+	default 20000 if INTERACTIVE_DESKTOP
+	default 15000 if HIGHLY_INTERACTIVE_DESKTOP
+	default CUSTOM_SCHED_BATCH_WAKEUP_GRANULARITY if CUSTOM_SCHED_SETUP
Index: linux-2.6.23-cfs/kernel/sched.c
===================================================================
--- linux-2.6.23-cfs.orig/kernel/sched.c
+++ linux-2.6.23-cfs/kernel/sched.c
@@ -3326,7 +3326,8 @@
  * Nice level for privileged tasks. (can be set to 0 for this
  * to be turned off)
  */
-int sysctl_sched_privileged_nice_level __read_mostly = -10;
+int sysctl_sched_privileged_nice_level	__read_mostly =
+					CONFIG_PRIVILEGED_TASKS_NICE_LEVEL;
 
 static int __init privileged_nice_level_setup(char *str)
 {
Index: linux-2.6.23-cfs/kernel/sched_fair.c
===================================================================
--- linux-2.6.23-cfs.orig/kernel/sched_fair.c
+++ linux-2.6.23-cfs/kernel/sched_fair.c
@@ -34,13 +34,15 @@
  * systems, 4x on 8-way systems, 5x on 16-way systems, etc.)
  * Targeted preemption latency for CPU-bound tasks:
  */
-unsigned int sysctl_sched_latency __read_mostly = 20000000ULL;
+unsigned int sysctl_sched_latency __read_mostly =
+				CONFIG_SCHED_LATENCY * 1000ULL;
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
  * (default: 2 msec, units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity __read_mostly = 2000000ULL;
+unsigned int sysctl_sched_min_granularity __read_mostly =
+				CONFIG_SCHED_MIN_GRANULARITY * 1000ULL;
 
 /*
  * sys_sched_yield() compat mode
@@ -58,7 +60,8 @@
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_batch_wakeup_granularity __read_mostly = 25000000UL;
+unsigned int sysctl_sched_batch_wakeup_granularity __read_mostly =
+				CONFIG_SCHED_BATCH_WAKEUP_GRANULARITY * 1000UL;
 
 /*
  * SCHED_OTHER wake-up granularity.
@@ -68,7 +71,8 @@
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity __read_mostly = 1000000UL;
+unsigned int sysctl_sched_wakeup_granularity __read_mostly =
+				CONFIG_SCHED_WAKEUP_GRANULARITY * 1000UL;
 
 unsigned int sysctl_sched_stat_granularity __read_mostly;
 
Index: linux-2.6.23-cfs/kernel/sysctl.c
===================================================================
--- linux-2.6.23-cfs.orig/kernel/sysctl.c
+++ linux-2.6.23-cfs/kernel/sysctl.c
@@ -123,5 +123,9 @@
 #ifdef CONFIG_RT_MUTEXES
 extern int max_lock_depth;
 #endif
+
+#ifdef CONFIG_SYSCTL_PRIVILEGED_TASKS_NICE_LEVEL
+extern int sysctl_sched_privileged_nice_level;
+#endif
 
 #ifdef CONFIG_SYSCTL_SYSCALL
@@ -594,6 +598,17 @@
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
 	},
+#if defined(CONFIG_SYSCTL_PRIVILEGED_TASKS_NICE_LEVEL)
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "sched_privileged_nice_level",
+		.data           = &sysctl_sched_privileged_nice_level,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec_minmax,
+		.strategy       = &sysctl_intvec,
+	},
+#endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
 		.ctl_name       = KERN_UNKNOWN_NMI_PANIC,

--------------020402080701000302020407--
