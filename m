Return-Path: <linux-kernel-owner+w=401wt.eu-S1422800AbXBALNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422800AbXBALNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422799AbXBALMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:12:42 -0500
Received: from styx.suse.cz ([82.119.242.94]:53743 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751734AbXBALMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:12:35 -0500
Message-Id: <20070201103753.753349000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 10:59:56 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 4/9] Remove the TSC synchronization on SMP machines
Content-Disposition: inline; filename=remove_tsc_synchronization
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TSC is either synchronized by design or not reliable
to be used for anything, let alone timekeeping.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

Index: linux-2.6.20-rc5/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/smpboot.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/smpboot.c
@@ -148,217 +148,6 @@ static void __cpuinit smp_store_cpu_info
 	print_cpu_info(c);
 }
 
-/*
- * New Funky TSC sync algorithm borrowed from IA64.
- * Main advantage is that it doesn't reset the TSCs fully and
- * in general looks more robust and it works better than my earlier
- * attempts. I believe it was written by David Mosberger. Some minor
- * adjustments for x86-64 by me -AK
- *
- * Original comment reproduced below.
- *
- * Synchronize TSC of the current (slave) CPU with the TSC of the
- * MASTER CPU (normally the time-keeper CPU).  We use a closed loop to
- * eliminate the possibility of unaccounted-for errors (such as
- * getting a machine check in the middle of a calibration step).  The
- * basic idea is for the slave to ask the master what itc value it has
- * and to read its own itc before and after the master responds.  Each
- * iteration gives us three timestamps:
- *
- *	slave		master
- *
- *	t0 ---\
- *             ---\
- *		   --->
- *			tm
- *		   /---
- *	       /---
- *	t1 <---
- *
- *
- * The goal is to adjust the slave's TSC such that tm falls exactly
- * half-way between t0 and t1.  If we achieve this, the clocks are
- * synchronized provided the interconnect between the slave and the
- * master is symmetric.  Even if the interconnect were asymmetric, we
- * would still know that the synchronization error is smaller than the
- * roundtrip latency (t0 - t1).
- *
- * When the interconnect is quiet and symmetric, this lets us
- * synchronize the TSC to within one or two cycles.  However, we can
- * only *guarantee* that the synchronization is accurate to within a
- * round-trip time, which is typically in the range of several hundred
- * cycles (e.g., ~500 cycles).  In practice, this means that the TSCs
- * are usually almost perfectly synchronized, but we shouldn't assume
- * that the accuracy is much better than half a micro second or so.
- *
- * [there are other errors like the latency of RDTSC and of the
- * WRMSR. These can also account to hundreds of cycles. So it's
- * probably worse. It claims 153 cycles error on a dual Opteron,
- * but I suspect the numbers are actually somewhat worse -AK]
- */
-
-#define MASTER	0
-#define SLAVE	(SMP_CACHE_BYTES/8)
-
-/* Intentionally don't use cpu_relax() while TSC synchronization
-   because we don't want to go into funky power save modi or cause
-   hypervisors to schedule us away.  Going to sleep would likely affect
-   latency and low latency is the primary objective here. -AK */
-#define no_cpu_relax() barrier()
-
-static __cpuinitdata DEFINE_SPINLOCK(tsc_sync_lock);
-static volatile __cpuinitdata unsigned long go[SLAVE + 1];
-static int notscsync __cpuinitdata;
-
-#undef DEBUG_TSC_SYNC
-
-#define NUM_ROUNDS	64	/* magic value */
-#define NUM_ITERS	5	/* likewise */
-
-/* Callback on boot CPU */
-static __cpuinit void sync_master(void *arg)
-{
-	unsigned long flags, i;
-
-	go[MASTER] = 0;
-
-	local_irq_save(flags);
-	{
-		for (i = 0; i < NUM_ROUNDS*NUM_ITERS; ++i) {
-			while (!go[MASTER])
-				no_cpu_relax();
-			go[MASTER] = 0;
-			rdtscll(go[SLAVE]);
-		}
-	}
-	local_irq_restore(flags);
-}
-
-/*
- * Return the number of cycles by which our tsc differs from the tsc
- * on the master (time-keeper) CPU.  A positive number indicates our
- * tsc is ahead of the master, negative that it is behind.
- */
-static inline long
-get_delta(long *rt, long *master)
-{
-	unsigned long best_t0 = 0, best_t1 = ~0UL, best_tm = 0;
-	unsigned long tcenter, t0, t1, tm;
-	int i;
-
-	for (i = 0; i < NUM_ITERS; ++i) {
-		rdtscll(t0);
-		go[MASTER] = 1;
-		while (!(tm = go[SLAVE]))
-			no_cpu_relax();
-		go[SLAVE] = 0;
-		rdtscll(t1);
-
-		if (t1 - t0 < best_t1 - best_t0)
-			best_t0 = t0, best_t1 = t1, best_tm = tm;
-	}
-
-	*rt = best_t1 - best_t0;
-	*master = best_tm - best_t0;
-
-	/* average best_t0 and best_t1 without overflow: */
-	tcenter = (best_t0/2 + best_t1/2);
-	if (best_t0 % 2 + best_t1 % 2 == 2)
-		++tcenter;
-	return tcenter - best_tm;
-}
-
-static __cpuinit void sync_tsc(unsigned int master)
-{
-	int i, done = 0;
-	long delta, adj, adjust_latency = 0;
-	unsigned long flags, rt, master_time_stamp, bound;
-#ifdef DEBUG_TSC_SYNC
-	static struct syncdebug {
-		long rt;	/* roundtrip time */
-		long master;	/* master's timestamp */
-		long diff;	/* difference between midpoint and master's timestamp */
-		long lat;	/* estimate of tsc adjustment latency */
-	} t[NUM_ROUNDS] __cpuinitdata;
-#endif
-
-	printk(KERN_INFO "CPU %d: Syncing TSC to CPU %u.\n",
-		smp_processor_id(), master);
-
-	go[MASTER] = 1;
-
-	/* It is dangerous to broadcast IPI as cpus are coming up,
-	 * as they may not be ready to accept them.  So since
-	 * we only need to send the ipi to the boot cpu direct
-	 * the message, and avoid the race.
-	 */
-	smp_call_function_single(master, sync_master, NULL, 1, 0);
-
-	while (go[MASTER])	/* wait for master to be ready */
-		no_cpu_relax();
-
-	spin_lock_irqsave(&tsc_sync_lock, flags);
-	{
-		for (i = 0; i < NUM_ROUNDS; ++i) {
-			delta = get_delta(&rt, &master_time_stamp);
-			if (delta == 0) {
-				done = 1;	/* let's lock on to this... */
-				bound = rt;
-			}
-
-			if (!done) {
-				unsigned long t;
-				if (i > 0) {
-					adjust_latency += -delta;
-					adj = -delta + adjust_latency/4;
-				} else
-					adj = -delta;
-
-				rdtscll(t);
-				wrmsrl(MSR_IA32_TSC, t + adj);
-			}
-#ifdef DEBUG_TSC_SYNC
-			t[i].rt = rt;
-			t[i].master = master_time_stamp;
-			t[i].diff = delta;
-			t[i].lat = adjust_latency/4;
-#endif
-		}
-	}
-	spin_unlock_irqrestore(&tsc_sync_lock, flags);
-
-#ifdef DEBUG_TSC_SYNC
-	for (i = 0; i < NUM_ROUNDS; ++i)
-		printk("rt=%5ld master=%5ld diff=%5ld adjlat=%5ld\n",
-		       t[i].rt, t[i].master, t[i].diff, t[i].lat);
-#endif
-
-	printk(KERN_INFO
-	       "CPU %d: synchronized TSC with CPU %u (last diff %ld cycles, "
-	       "maxerr %lu cycles)\n",
-	       smp_processor_id(), master, delta, rt);
-}
-
-static void __cpuinit tsc_sync_wait(void)
-{
-	/*
-	 * When the CPU has synchronized TSCs assume the BIOS
-  	 * or the hardware already synced.  Otherwise we could
-	 * mess up a possible perfect synchronization with a
-	 * not-quite-perfect algorithm.
-	 */
-	if (notscsync || !cpu_has_tsc || !unsynchronized_tsc())
-		return;
-	sync_tsc(0);
-}
-
-static __init int notscsync_setup(char *s)
-{
-	notscsync = 1;
-	return 1;
-}
-__setup("notscsync", notscsync_setup);
-
 static atomic_t init_deasserted __cpuinitdata;
 
 /*
@@ -565,14 +354,6 @@ void __cpuinit start_secondary(void)
 	 */
 	set_cpu_sibling_map(smp_processor_id());
 
-	/* 
-  	 * Wait for TSC sync to not schedule things before.
-	 * We still process interrupts, which could see an inconsistent
-	 * time in that window unfortunately. 
-	 * Do this here because TSC sync has global unprotected state.
- 	 */
-	tsc_sync_wait();
-
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of

--
