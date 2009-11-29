Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZK2JWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZK2JWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 04:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZK2JWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 04:22:43 -0500
Received: from smtp4.welho.com ([213.243.153.38]:39839 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbZK2JWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 04:22:41 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] SLAB: Make synthetic benchmark output more readable
Date: Sun, 29 Nov 2009 11:22:33 +0200
Message-Id: <1259486553-4037-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the synthetic SLAB benchmark output easier to read by hymans
and easier to post-process with scripts. The output looks as follows:

  Single thread testing
  =====================
  1. Kmalloc: Repeatedly allocate then free test
  Times	Size	kmalloc	kfree
  10000	8	181	170
  10000	16	185	173
  10000	32	129	161
  10000	64	141	156
  10000	128	179	183
  10000	256	204	246
  10000	512	242	374
  10000	1024	267	470
  10000	2048	290	506
  10000	4096	376	559
  10000	8192	508	664
  10000	16384	800	887
  2. Kmalloc: alloc/free test
  Times	Size	kmalloc/kfree
  10000	8	197
  10000	16	186
  10000	32	195
  10000	64	176
  10000	128	176
  10000	256	183
  10000	512	186
  10000	1024	186
  10000	2048	198
  10000	4096	186
  10000	8192	186
  10000	16384	882
  Concurrent allocs
  =================
  Kmalloc N*alloc N*free
  Size	CPU0	CPU1	Average
  8	129/181	124/180	126/180
  16	150/166	158/164	154/165
  32	154/190	151/192	152/191
  64	195/215	192/211	193/213
  128	341/375	229/306	285/341
  256	263/472	297/484	280/478
  512	356/588	348/597	352/593
  1024	375/625	375/623	375/624
  2048	451/593	377/638	414/615
  4096	546/816	545/853	545/835
  Kmalloc N*(alloc free)
  Size	CPU0	CPU1	Average
  8	256	209	233
  16	200	186	193
  32	235	196	216
  64	217	177	197
  128	186	186	186
  256	256	233	244
  512	215	189	202
  1024	203	186	195
  2048	292	248	270
  4096	211	211	211
  Remote free test
  ================
  N*remote free
  Size	CPU0	CPU1	Average
  8	7/180	128/0	67/90
  16	7/183	131/0	69/91
  32	32/186	150/0	91/93
  64	7/225	186/0	97/112
  128	7/213	225/0	116/106
  256	7/271	241/0	124/135
  512	7/397	294/0	150/198
  1024	7/510	271/0	139/255
  2048	7/480	296/0	151/240
  4096	7/565	394/0	200/282
  1 alloc N free test
  ===================
  1 alloc N free
  Size	CPU0	CPU1	Average
  8	182	129	155
  16	212	148	180
  32	222	150	186
  64	370	265	318
  128	686	491	588
  256	406	264	335
  512	798	646	722
  1024	379	218	299
  2048	405	243	324
  4096	539	321	430

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 tests/slab_test.c |   51 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/tests/slab_test.c b/tests/slab_test.c
index 467b928..e97afc4 100644
--- a/tests/slab_test.c
+++ b/tests/slab_test.c
@@ -194,9 +194,20 @@ static int test_func(void *private)
 	return 0;
 }
 
+static void print_concurrent_test_header(const char *name)
+{
+	int cpu;
+
+	printk(KERN_ALERT "%s\n", name);
+	printk(KERN_ALERT "Size\t");
+	for_each_online_cpu(cpu)
+		printk(KERN_CONT "CPU%d\t", cpu);
+	printk(KERN_CONT "Average\n");
+}
+
 static void do_concurrent_test(void (*p1)(struct test_struct *),
 		void (*p2)(struct test_struct *),
-		int size, const char *name)
+		int size)
 {
 	int cpu;
 	unsigned long time1 = 0;
@@ -247,7 +258,7 @@ static void do_concurrent_test(void (*p1)(struct test_struct *),
 	for_each_online_cpu(cpu)
 		kthread_stop(test[cpu].task);
 
-	printk(KERN_ALERT "%s(%d):", name, size);
+	printk(KERN_ALERT "%d\t", size);
 	for_each_online_cpu(cpu) {
 		struct test_struct *t = &test[cpu];
 
@@ -255,14 +266,15 @@ static void do_concurrent_test(void (*p1)(struct test_struct *),
 		time2 = t->stop2 - t->start2;
 		sum1 += time1;
 		sum2 += time2;
-		printk(" %d=%lu", cpu, time1 / TEST_COUNT);
+		printk(KERN_CONT "%lu", time1 / TEST_COUNT);
 		if (p2)
-			printk("/%lu", time2 / TEST_COUNT);
+			printk(KERN_CONT "/%lu", time2 / TEST_COUNT);
+		printk(KERN_CONT "\t");
 	}
-	printk(" Average=%lu", sum1 / num_online_cpus() / TEST_COUNT);
+	printk(KERN_CONT "%lu", sum1 / num_online_cpus() / TEST_COUNT);
 	if (p2)
-		printk("/%lu", sum2 / num_online_cpus() / TEST_COUNT);
-	printk("\n");
+		printk(KERN_CONT "/%lu", sum2 / num_online_cpus() / TEST_COUNT);
+	printk(KERN_CONT "\n");
 	schedule_timeout(200);
 }
 #endif
@@ -280,6 +292,7 @@ static int slab_test_init(void)
 	printk(KERN_ALERT "Single thread testing\n");
 	printk(KERN_ALERT "=====================\n");
 	printk(KERN_ALERT "1. Kmalloc: Repeatedly allocate then free test\n");
+	printk(KERN_ALERT "Times\tSize\tkmalloc\tkfree\n");
 	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
 		time1 = get_cycles();
 		for (i = 0; i < TEST_COUNT; i++) {
@@ -291,9 +304,9 @@ static int slab_test_init(void)
 		time2 = get_cycles();
 		time = time2 - time1;
 
-		printk(KERN_ALERT "%i times kmalloc(%d) ", i, size);
+		printk(KERN_ALERT "%i\t%d\t", i, size);
 		time = div_u64_rem(time, TEST_COUNT, &rem);
-		printk("-> %llu cycles ", time);
+		printk("%llu\t", time);
 
 		time1 = get_cycles();
 		for (i = 0; i < TEST_COUNT; i++) {
@@ -305,12 +318,12 @@ static int slab_test_init(void)
 		time2 = get_cycles();
 		time = time2 - time1;
 
-		printk("kfree ");
 		time = div_u64_rem(time, TEST_COUNT, &rem);
-		printk("-> %llu cycles\n", time);
+		printk("%llu\n", time);
 	}
 
 	printk(KERN_ALERT "2. Kmalloc: alloc/free test\n");
+	printk(KERN_ALERT "Times\tSize\tkmalloc/kfree\n");
 	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
 		time1 = get_cycles();
 		for (i = 0; i < TEST_COUNT; i++) {
@@ -321,38 +334,42 @@ static int slab_test_init(void)
 		time2 = get_cycles();
 		time = time2 - time1;
 
-		printk(KERN_ALERT "%i times kmalloc(%d)/kfree ", i, size);
+		printk(KERN_ALERT "%i\t%d\t", i, size);
 		time = div_u64_rem(time, TEST_COUNT, &rem);
-		printk("-> %llu cycles\n", time);
+		printk("%llu\n", time);
 	}
 	kfree(v);
 #ifdef CONFIG_SMP
 	printk(KERN_INFO "Concurrent allocs\n");
 	printk(KERN_INFO "=================\n");
+	print_concurrent_test_header("Kmalloc N*alloc N*free");
 	for (i = 3; i <= PAGE_SHIFT; i++) {
 		do_concurrent_test(kmalloc_alloc_then_free_test_p1,
 			kmalloc_alloc_then_free_test_p2,
-			1 << i, "Kmalloc N*alloc N*free");
+			1 << i);
 	}
+	print_concurrent_test_header("Kmalloc N*(alloc free)");
 	for (i = 3; i <= PAGE_SHIFT; i++) {
 		do_concurrent_test(kmalloc_alloc_free_test_p1, NULL,
-			1 << i, "Kmalloc N*(alloc free)");
+			1 << i);
 	}
 
 	printk(KERN_INFO "Remote free test\n");
 	printk(KERN_INFO "================\n");
+	print_concurrent_test_header("N*remote free");
 	for (i = 3; i <= PAGE_SHIFT; i++) {
 		do_concurrent_test(remote_free_test_p1,
 				remote_free_test_p2,
-			1 << i, "N*remote free");
+			1 << i);
 	}
 
 	printk(KERN_INFO "1 alloc N free test\n");
 	printk(KERN_INFO "===================\n");
+	print_concurrent_test_header("1 alloc N free");
 	for (i = 3; i <= PAGE_SHIFT; i++) {
 		do_concurrent_test(alloc_n_free_test_p1,
 				NULL,
-			1 << i, "1 alloc N free");
+			1 << i);
 	}
 
 #endif
-- 
1.6.3.3

