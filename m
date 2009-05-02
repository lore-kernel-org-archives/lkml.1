Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbZEBTJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbZEBTJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZEBTIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:08:12 -0400
Received: from www.tglx.de ([62.245.132.106]:33810 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbZEBTII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:08:08 -0400
Message-Id: <20090502190545.567689834@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 19:06:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 3/3] tiemrs: cleanup avenrun users
References: <20090502190500.513452861@linutronix.de>
Content-Disposition: inline; filename=calc-load-cleanup-users.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avenrun is an rough estimate so we don't have to worry about
consistency of the three avenrun values. Remove the xtime lock
dependency and provide a function to scale the values. Cleanup the
users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/loadavg.c     |   16 +++++-----------
 include/linux/sched.h |    1 +
 kernel/timer.c        |   47 +++++++++++++++++++++--------------------------
 3 files changed, 27 insertions(+), 37 deletions(-)

Index: linux-2.6/fs/proc/loadavg.c
===================================================================
--- linux-2.6.orig/fs/proc/loadavg.c
+++ linux-2.6/fs/proc/loadavg.c
@@ -12,20 +12,14 @@
 
 static int loadavg_proc_show(struct seq_file *m, void *v)
 {
-	int a, b, c;
-	unsigned long seq;
+	int avnrun[3];
 
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		a = avenrun[0] + (FIXED_1/200);
-		b = avenrun[1] + (FIXED_1/200);
-		c = avenrun[2] + (FIXED_1/200);
-	} while (read_seqretry(&xtime_lock, seq));
+	get_avenrun(avnrun, FIXED_1/200, 0);
 
 	seq_printf(m, "%d.%02d %d.%02d %d.%02d %ld/%d %d\n",
-		LOAD_INT(a), LOAD_FRAC(a),
-		LOAD_INT(b), LOAD_FRAC(b),
-		LOAD_INT(c), LOAD_FRAC(c),
+		LOAD_INT(avnrun[0]), LOAD_FRAC(avnrun[0]),
+		LOAD_INT(avnrun[1]), LOAD_FRAC(avnrun[1]),
+		LOAD_INT(avnrun[2]), LOAD_FRAC(avnrun[2]),
 		nr_running(), nr_threads,
 		task_active_pid_ns(current)->last_pid);
 	return 0;
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -116,6 +116,7 @@ struct fs_struct;
  *    11 bit fractions.
  */
 extern unsigned long avenrun[];		/* Load averages */
+extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
 
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1135,6 +1135,21 @@ static atomic_t avenrun_ticks;
 static DEFINE_SPINLOCK(avenrun_lock);
 static DEFINE_PER_CPU(int, avenrun_calculate);
 
+/**
+ * get_avenrun - get the load average array
+ * @loads:	pointer to dest load array
+ * @offset:	offset to add
+ * @shift:	shift count to shift the result left
+ *
+ * These values are estimates at best, so no need for locking.
+ */
+void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
+{
+	loads[0] = (avenrun[0] + offset) << shift;
+	loads[1] = (avenrun[1] + offset) << shift;
+	loads[2] = (avenrun[2] + offset) << shift;
+}
+
 static unsigned long
 calc_load(unsigned long load, unsigned long exp, unsigned long active)
 {
@@ -1432,37 +1447,17 @@ int do_sysinfo(struct sysinfo *info)
 {
 	unsigned long mem_total, sav_total;
 	unsigned int mem_unit, bitcount;
-	unsigned long seq;
+	struct timespec tp;
 
 	memset(info, 0, sizeof(struct sysinfo));
 
-	do {
-		struct timespec tp;
-		seq = read_seqbegin(&xtime_lock);
-
-		/*
-		 * This is annoying.  The below is the same thing
-		 * posix_get_clock_monotonic() does, but it wants to
-		 * take the lock which we want to cover the loads stuff
-		 * too.
-		 */
-
-		getnstimeofday(&tp);
-		tp.tv_sec += wall_to_monotonic.tv_sec;
-		tp.tv_nsec += wall_to_monotonic.tv_nsec;
-		monotonic_to_bootbased(&tp);
-		if (tp.tv_nsec - NSEC_PER_SEC >= 0) {
-			tp.tv_nsec = tp.tv_nsec - NSEC_PER_SEC;
-			tp.tv_sec++;
-		}
-		info->uptime = tp.tv_sec + (tp.tv_nsec ? 1 : 0);
+	ktime_get_ts(&tp);
+	monotonic_to_bootbased(&tp);
+	info->uptime = tp.tv_sec + (tp.tv_nsec ? 1 : 0);
 
-		info->loads[0] = avenrun[0] << (SI_LOAD_SHIFT - FSHIFT);
-		info->loads[1] = avenrun[1] << (SI_LOAD_SHIFT - FSHIFT);
-		info->loads[2] = avenrun[2] << (SI_LOAD_SHIFT - FSHIFT);
+	get_avenrun(info->loads, 0, SI_LOAD_SHIFT - FSHIFT);
 
-		info->procs = nr_threads;
-	} while (read_seqretry(&xtime_lock, seq));
+	info->procs = nr_threads;
 
 	si_meminfo(info);
 	si_swapinfo(info);


