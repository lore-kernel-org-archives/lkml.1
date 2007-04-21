Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbXDUDbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbXDUDbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 23:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXDUDbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 23:31:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33093 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754075AbXDUDbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 23:31:43 -0400
Date: Fri, 20 Apr 2007 20:31:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] KMEM_CACHE() simplify slab cache creation
Message-ID: <Pine.LNX.4.64.0704202029540.16322@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a new macro

KMEM_CACHE(<struct>, <flags>)

to simplify slab creation. KMEM_CACHE creates a slab with the name of the
struct, with the size of the struct and with the alignment of the struct.
Additional slab flags may be specified if necessary.

Example



struct test_slab {
	int a,b,c;
	struct list_head;
} __cacheline_aligned_in_smp;

test_slab_cache = KMEM_CACHE(test_slab, SLAB_PANIC)



willl create a new slab named "test_slab" of the size
sizeof(struct test_slab) and aligned to the alignment of test
slab. If it fails then we panic.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc6/include/linux/slab.h
===================================================================
--- linux-2.6.21-rc6.orig/include/linux/slab.h	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/include/linux/slab.h	2007-04-20 20:24:03.000000000 -0700
@@ -55,6 +55,18 @@ unsigned int kmem_cache_size(struct kmem
 const char *kmem_cache_name(struct kmem_cache *);
 int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 
+/*
+ * Please use this macro to create slab caches. Simply specify the
+ * name of the structure and maybe some flags that are listed above.
+ *
+ * The alignment of the struct determines object alignment. If you
+ * f.e. add ____cacheline_aligned_in_smp to the struct declaration
+ * then the objects will be properly aligned in SMP configurations.
+ */
+#define KMEM_CACHE(__struct, __flags) kmem_cache_create(#__struct,\
+		sizeof(struct __struct), __alignof__(struct __struct),\
+		(__flags), NULL, NULL)
+
 #ifdef CONFIG_NUMA
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 #else
Index: linux-2.6.21-rc6/kernel/delayacct.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/delayacct.c	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/kernel/delayacct.c	2007-04-20 20:17:47.000000000 -0700
@@ -31,11 +31,7 @@ __setup("nodelayacct", delayacct_setup_d
 
 void delayacct_init(void)
 {
-	delayacct_cache = kmem_cache_create("delayacct_cache",
-					sizeof(struct task_delay_info),
-					0,
-					SLAB_PANIC,
-					NULL, NULL);
+	delayacct_cache = KMEM_CACHE(task_delay_info, SLAB_PANIC);
 	delayacct_tsk_init(&init_task);
 }
 
Index: linux-2.6.21-rc6/kernel/pid.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/pid.c	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/kernel/pid.c	2007-04-20 20:17:47.000000000 -0700
@@ -412,7 +412,5 @@ void __init pidmap_init(void)
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
 
-	pid_cachep = kmem_cache_create("pid", sizeof(struct pid),
-					__alignof__(struct pid),
-					SLAB_PANIC, NULL, NULL);
+	pid_cachep = KMEM_CACHE(pid, SLAB_PANIC);
 }
Index: linux-2.6.21-rc6/kernel/signal.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/signal.c	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/kernel/signal.c	2007-04-20 20:17:47.000000000 -0700
@@ -2636,9 +2636,5 @@ __attribute__((weak)) const char *arch_v
 
 void __init signals_init(void)
 {
-	sigqueue_cachep =
-		kmem_cache_create("sigqueue",
-				  sizeof(struct sigqueue),
-				  __alignof__(struct sigqueue),
-				  SLAB_PANIC, NULL, NULL);
+	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
 }
Index: linux-2.6.21-rc6/kernel/taskstats.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/taskstats.c	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/kernel/taskstats.c	2007-04-20 20:17:47.000000000 -0700
@@ -524,9 +524,7 @@ void __init taskstats_init_early(void)
 {
 	unsigned int i;
 
-	taskstats_cache = kmem_cache_create("taskstats_cache",
-						sizeof(struct taskstats),
-						0, SLAB_PANIC, NULL, NULL);
+	taskstats_cache = KMEM_CACHE(taskstats, SLAB_PANIC);
 	for_each_possible_cpu(i) {
 		INIT_LIST_HEAD(&(per_cpu(listener_array, i).list));
 		init_rwsem(&(per_cpu(listener_array, i).sem));
Index: linux-2.6.21-rc6/block/cfq-iosched.c
===================================================================
--- linux-2.6.21-rc6.orig/block/cfq-iosched.c	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/block/cfq-iosched.c	2007-04-20 20:17:47.000000000 -0700
@@ -2222,13 +2222,11 @@ static void cfq_slab_kill(void)
 
 static int __init cfq_slab_setup(void)
 {
-	cfq_pool = kmem_cache_create("cfq_pool", sizeof(struct cfq_queue), 0, 0,
-					NULL, NULL);
+	cfq_pool = KMEM_CACHE(cfq_queue, 0);
 	if (!cfq_pool)
 		goto fail;
 
-	cfq_ioc_pool = kmem_cache_create("cfq_ioc_pool",
-			sizeof(struct cfq_io_context), 0, 0, NULL, NULL);
+	cfq_ioc_pool = KMEM_CACHE(cfq_io_context, 0);
 	if (!cfq_ioc_pool)
 		goto fail;
 
Index: linux-2.6.21-rc6/fs/aio.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/aio.c	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/fs/aio.c	2007-04-20 20:17:47.000000000 -0700
@@ -68,10 +68,8 @@ static void aio_queue_work(struct kioctx
  */
 static int __init aio_setup(void)
 {
-	kiocb_cachep = kmem_cache_create("kiocb", sizeof(struct kiocb),
-				0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
-	kioctx_cachep = kmem_cache_create("kioctx", sizeof(struct kioctx),
-				0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
+	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
+	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
 	aio_wq = create_workqueue("aio");
 
Index: linux-2.6.21-rc6/fs/bio.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/bio.c	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/fs/bio.c	2007-04-20 20:17:47.000000000 -0700
@@ -1199,8 +1199,7 @@ static int __init init_bio(void)
 	int megabytes, bvec_pool_entries;
 	int scale = BIOVEC_NR_POOLS;
 
-	bio_slab = kmem_cache_create("bio", sizeof(struct bio), 0,
-				SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
+	bio_slab = KMEM_CACHE(bio, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
 	biovec_init_slabs();
 
Index: linux-2.6.21-rc6/fs/dcache.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/dcache.c	2007-04-20 20:15:14.000000000 -0700
+++ linux-2.6.21-rc6/fs/dcache.c	2007-04-20 20:18:10.000000000 -0700
@@ -2057,12 +2057,8 @@ static void __init dcache_init(unsigned 
 	 * but it is probably not worth it because of the cache nature
 	 * of the dcache. 
 	 */
-	dentry_cache = kmem_cache_create("dentry_cache",
-					 sizeof(struct dentry),
-					 0,
-					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-					 SLAB_MEM_SPREAD),
-					 NULL, NULL);
+	dentry_cache = KMEM_CACHE(dentry,
+		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
 
 	register_shrinker(&dcache_shrinker);
 
