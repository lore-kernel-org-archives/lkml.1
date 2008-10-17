Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYJQISZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYJQISZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYJQISM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:18:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYJQISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:18:10 -0400
Subject: [PATCH] lockstat: contend with points
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 10:18:25 +0200
Message-Id: <1224231505.28131.71.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockstat: contend with points
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Oct 16 23:17:09 CEST 2008

We currently only provide points that have to wait on contention, also
lists the points we have to wait for.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/lockstat.txt |   50 ++++++++++++++++++++++++++++-----------------
 include/linux/lockdep.h    |   13 ++++++++---
 kernel/lockdep.c           |   33 ++++++++++++++++++-----------
 kernel/lockdep_proc.c      |   21 +++++++++++++++++-
 kernel/mutex.c             |    2 -
 5 files changed, 82 insertions(+), 37 deletions(-)

Index: linux-2.6/Documentation/lockstat.txt
===================================================================
--- linux-2.6.orig/Documentation/lockstat.txt
+++ linux-2.6/Documentation/lockstat.txt
@@ -71,34 +71,48 @@ Look at the current lock statistics:
 
 # less /proc/lock_stat
 
-01 lock_stat version 0.2
+01 lock_stat version 0.3
 02 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 03                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
 04 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 05
-06               &inode->i_data.tree_lock-W:            15          21657           0.18     1093295.30 11547131054.85             58          10415           0.16          87.51        6387.60
-07               &inode->i_data.tree_lock-R:             0              0           0.00           0.00           0.00          23302         231198           0.25           8.45       98023.38
-08               --------------------------
-09                 &inode->i_data.tree_lock              0          [<ffffffff8027c08f>] add_to_page_cache+0x5f/0x190
-10
-11 ...............................................................................................................................................................................................
-12
-13                              dcache_lock:          1037           1161           0.38          45.32         774.51           6611         243371           0.15         306.48       77387.24
-14                              -----------
-15                              dcache_lock            180          [<ffffffff802c0d7e>] sys_getcwd+0x11e/0x230
-16                              dcache_lock            165          [<ffffffff802c002a>] d_alloc+0x15a/0x210
-17                              dcache_lock             33          [<ffffffff8035818d>] _atomic_dec_and_lock+0x4d/0x70
-18                              dcache_lock              1          [<ffffffff802beef8>] shrink_dcache_parent+0x18/0x130
+06                          &mm->mmap_sem-W:           233            538 18446744073708       22924.27      607243.51           1342          45806           1.71        8595.89     1180582.34
+07                          &mm->mmap_sem-R:           205            587 18446744073708       28403.36      731975.00           1940         412426           0.58      187825.45     6307502.88
+08                          ---------------
+09                            &mm->mmap_sem            487          [<ffffffff8053491f>] do_page_fault+0x466/0x928
+10                            &mm->mmap_sem            179          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
+11                            &mm->mmap_sem            279          [<ffffffff80210a57>] sys_mmap+0x75/0xce
+12                            &mm->mmap_sem             76          [<ffffffff802a490b>] sys_munmap+0x32/0x59
+13                          ---------------
+14                            &mm->mmap_sem            270          [<ffffffff80210a57>] sys_mmap+0x75/0xce
+15                            &mm->mmap_sem            431          [<ffffffff8053491f>] do_page_fault+0x466/0x928
+16                            &mm->mmap_sem            138          [<ffffffff802a490b>] sys_munmap+0x32/0x59
+17                            &mm->mmap_sem            145          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
+18
+19 ...............................................................................................................................................................................................
+20
+21                              dcache_lock:           621            623           0.52         118.26        1053.02           6745          91930           0.29         316.29      118423.41
+22                              -----------
+23                              dcache_lock            179          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
+24                              dcache_lock            113          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
+25                              dcache_lock             99          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
+26                              dcache_lock            104          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
+27                              -----------
+28                              dcache_lock            192          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
+29                              dcache_lock             98          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
+30                              dcache_lock             72          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
+31                              dcache_lock            112          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
 
 This excerpt shows the first two lock class statistics. Line 01 shows the
 output version - each time the format changes this will be updated. Line 02-04
-show the header with column descriptions. Lines 05-10 and 13-18 show the actual
+show the header with column descriptions. Lines 05-18 and 20-31 show the actual
 statistics. These statistics come in two parts; the actual stats separated by a
-short separator (line 08, 14) from the contention points.
+short separator (line 08, 13) from the contention points.
 
-The first lock (05-10) is a read/write lock, and shows two lines above the
+The first lock (05-18) is a read/write lock, and shows two lines above the
 short separator. The contention points don't match the column descriptors,
-they have two: contentions and [<IP>] symbol.
+they have two: contentions and [<IP>] symbol. The second set of contention
+points are the points we're contending with.
 
 
 View the top contending locks:
Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -73,6 +73,8 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
+#define LOCKSTAT_POINTS		4
+
 /*
  * The lock-class itself:
  */
@@ -119,7 +121,8 @@ struct lock_class {
 	int				name_version;
 
 #ifdef CONFIG_LOCK_STAT
-	unsigned long			contention_point[4];
+	unsigned long			contention_point[LOCKSTAT_POINTS];
+	unsigned long			contending_point[LOCKSTAT_POINTS];
 #endif
 };
 
@@ -144,6 +147,7 @@ enum bounce_type {
 
 struct lock_class_stats {
 	unsigned long			contention_point[4];
+	unsigned long			contending_point[4];
 	struct lock_time		read_waittime;
 	struct lock_time		write_waittime;
 	struct lock_time		read_holdtime;
@@ -165,6 +169,7 @@ struct lockdep_map {
 	const char			*name;
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
+	unsigned long			ip;
 #endif
 };
 
@@ -355,7 +360,7 @@ struct lock_class_key { };
 #ifdef CONFIG_LOCK_STAT
 
 extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
-extern void lock_acquired(struct lockdep_map *lock);
+extern void lock_acquired(struct lockdep_map *lock, unsigned long ip);
 
 #define LOCK_CONTENDED(_lock, try, lock)			\
 do {								\
@@ -363,13 +368,13 @@ do {								\
 		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
 		lock(_lock);					\
 	}							\
-	lock_acquired(&(_lock)->dep_map);			\
+	lock_acquired(&(_lock)->dep_map, _RET_IP_);			\
 } while (0)
 
 #else /* CONFIG_LOCK_STAT */
 
 #define lock_contended(lockdep_map, ip) do {} while (0)
-#define lock_acquired(lockdep_map) do {} while (0)
+#define lock_acquired(lockdep_map, ip) do {} while (0)
 
 #define LOCK_CONTENDED(_lock, try, lock) \
 	lock(_lock)
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -136,16 +136,16 @@ static inline struct lock_class *hlock_c
 #ifdef CONFIG_LOCK_STAT
 static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
 
-static int lock_contention_point(struct lock_class *class, unsigned long ip)
+static int lock_point(unsigned long points[], unsigned long ip)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(class->contention_point); i++) {
-		if (class->contention_point[i] == 0) {
-			class->contention_point[i] = ip;
+	for (i = 0; i < LOCKSTAT_POINTS; i++) {
+		if (points[i] == 0) {
+			points[i] = ip;
 			break;
 		}
-		if (class->contention_point[i] == ip)
+		if (points[i] == ip)
 			break;
 	}
 
@@ -185,6 +185,9 @@ struct lock_class_stats lock_stats(struc
 		for (i = 0; i < ARRAY_SIZE(stats.contention_point); i++)
 			stats.contention_point[i] += pcs->contention_point[i];
 
+		for (i = 0; i < ARRAY_SIZE(stats.contending_point); i++)
+			stats.contending_point[i] += pcs->contending_point[i];
+
 		lock_time_add(&pcs->read_waittime, &stats.read_waittime);
 		lock_time_add(&pcs->write_waittime, &stats.write_waittime);
 
@@ -209,6 +212,7 @@ void clear_lock_stats(struct lock_class 
 		memset(cpu_stats, 0, sizeof(struct lock_class_stats));
 	}
 	memset(class->contention_point, 0, sizeof(class->contention_point));
+	memset(class->contending_point, 0, sizeof(class->contending_point));
 }
 
 static struct lock_class_stats *get_lock_stats(struct lock_class *class)
@@ -3001,7 +3005,7 @@ __lock_contended(struct lockdep_map *loc
 	struct held_lock *hlock, *prev_hlock;
 	struct lock_class_stats *stats;
 	unsigned int depth;
-	int i, point;
+	int i, contention_point, contending_point;
 
 	depth = curr->lockdep_depth;
 	if (DEBUG_LOCKS_WARN_ON(!depth))
@@ -3025,18 +3029,22 @@ __lock_contended(struct lockdep_map *loc
 found_it:
 	hlock->waittime_stamp = sched_clock();
 
-	point = lock_contention_point(hlock_class(hlock), ip);
+	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
+	contending_point = lock_point(hlock_class(hlock)->contending_point,
+				      lock->ip);
 
 	stats = get_lock_stats(hlock_class(hlock));
-	if (point < ARRAY_SIZE(stats->contention_point))
-		stats->contention_point[point]++;
+	if (contention_point < LOCKSTAT_POINTS)
+		stats->contention_point[contention_point]++;
+	if (contending_point < LOCKSTAT_POINTS)
+		stats->contending_point[contending_point]++;
 	if (lock->cpu != smp_processor_id())
 		stats->bounces[bounce_contended + !!hlock->read]++;
 	put_lock_stats(stats);
 }
 
 static void
-__lock_acquired(struct lockdep_map *lock)
+__lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
@@ -3085,6 +3093,7 @@ found_it:
 	put_lock_stats(stats);
 
 	lock->cpu = cpu;
+	lock->ip = ip;
 }
 
 void lock_contended(struct lockdep_map *lock, unsigned long ip)
@@ -3106,7 +3115,7 @@ void lock_contended(struct lockdep_map *
 }
 EXPORT_SYMBOL_GPL(lock_contended);
 
-void lock_acquired(struct lockdep_map *lock)
+void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
@@ -3119,7 +3128,7 @@ void lock_acquired(struct lockdep_map *l
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
-	__lock_acquired(lock);
+	__lock_acquired(lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -556,7 +556,7 @@ static void seq_stats(struct seq_file *m
 	if (stats->read_holdtime.nr)
 		namelen += 2;
 
-	for (i = 0; i < ARRAY_SIZE(class->contention_point); i++) {
+	for (i = 0; i < LOCKSTAT_POINTS; i++) {
 		char sym[KSYM_SYMBOL_LEN];
 		char ip[32];
 
@@ -573,6 +573,23 @@ static void seq_stats(struct seq_file *m
 				stats->contention_point[i],
 				ip, sym);
 	}
+	for (i = 0; i < LOCKSTAT_POINTS; i++) {
+		char sym[KSYM_SYMBOL_LEN];
+		char ip[32];
+
+		if (class->contending_point[i] == 0)
+			break;
+
+		if (!i)
+			seq_line(m, '-', 40-namelen, namelen);
+
+		sprint_symbol(sym, class->contending_point[i]);
+		snprintf(ip, sizeof(ip), "[<%p>]",
+				(void *)class->contending_point[i]);
+		seq_printf(m, "%40s %14lu %29s %s\n", name,
+				stats->contending_point[i],
+				ip, sym);
+	}
 	if (i) {
 		seq_puts(m, "\n");
 		seq_line(m, '.', 0, 40 + 1 + 10 * (14 + 1));
@@ -582,7 +599,7 @@ static void seq_stats(struct seq_file *m
 
 static void seq_header(struct seq_file *m)
 {
-	seq_printf(m, "lock_stat version 0.2\n");
+	seq_printf(m, "lock_stat version 0.3\n");
 	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
 	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
 			"%14s %14s\n",
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -184,7 +184,7 @@ __mutex_lock_common(struct mutex *lock, 
 	}
 
 done:
-	lock_acquired(&lock->dep_map);
+	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 	debug_mutex_set_owner(lock, task_thread_info(task));


