Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYI2SE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYI2SE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYI2SC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:02:58 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54297 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752406AbYI2SCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:51 -0400
Message-Id: <20080929180251.096807000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:57 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/31] cpumask: changes to compile init/main.c
Content-Disposition: inline; filename=init_main
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 include/linux/sched.h    |    6 +++---
 include/linux/seq_file.h |    4 ++--
 init/main.c              |   11 ++++++-----
 kernel/cpu.c             |    5 +++++
 4 files changed, 16 insertions(+), 10 deletions(-)

--- struct-cpumasks.orig/include/linux/sched.h
+++ struct-cpumasks/include/linux/sched.h
@@ -1583,10 +1583,10 @@ extern cputime_t task_gtime(struct task_
 
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed_ptr(struct task_struct *p,
-				const cpumask_t *new_mask);
+				const cpumask_t new_mask);
 #else
 static inline int set_cpus_allowed_ptr(struct task_struct *p,
-				       const cpumask_t *new_mask)
+				       const cpumask_t new_mask)
 {
 	if (!cpu_isset(0, *new_mask))
 		return -EINVAL;
@@ -1595,7 +1595,7 @@ static inline int set_cpus_allowed_ptr(s
 #endif
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
-	return set_cpus_allowed_ptr(p, &new_mask);
+	return set_cpus_allowed_ptr(p, new_mask);
 }
 
 extern unsigned long long sched_clock(void);
--- struct-cpumasks.orig/include/linux/seq_file.h
+++ struct-cpumasks/include/linux/seq_file.h
@@ -50,9 +50,9 @@ int seq_dentry(struct seq_file *, struct
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc);
 int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits);
-static inline int seq_cpumask(struct seq_file *m, cpumask_t *mask)
+static inline int seq_cpumask(struct seq_file *m, cpumask_t mask)
 {
-	return seq_bitmap(m, mask->bits, NR_CPUS);
+	return seq_bitmap(m, mask->bits, nr_cpu_ids);
 }
 
 static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
--- struct-cpumasks.orig/init/main.c
+++ struct-cpumasks/init/main.c
@@ -367,12 +367,8 @@ static inline void smp_prepare_cpus(unsi
 
 #else
 
-#if NR_CPUS > BITS_PER_LONG
-cpumask_t cpu_mask_all __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_mask_all);
-#endif
-
 /* Setup number of possible processor ids */
+#ifndef nr_cpu_ids
 int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
@@ -386,6 +382,11 @@ static void __init setup_nr_cpu_ids(void
 
 	nr_cpu_ids = highest_cpu + 1;
 }
+#else
+static inline void setup_nr_cpu_ids(void)
+{
+}
+#endif
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
--- struct-cpumasks.orig/kernel/cpu.c
+++ struct-cpumasks/kernel/cpu.c
@@ -24,6 +24,11 @@
 cpumask_t cpu_present_map __read_mostly;
 EXPORT_SYMBOL(cpu_present_map);
 
+#if NR_CPUS > BITS_PER_LONG
+cpumask_map_t cpu_mask_all __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_mask_all);
+#endif
+
 #ifndef CONFIG_SMP
 
 /*

-- 
