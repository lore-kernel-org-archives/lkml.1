Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYKJMGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYKJMGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYKJMGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:06:38 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36234 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbYKJMGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:06:37 -0500
X-BigFish: VPS-5(zz936fOzzzzz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KA49MH-01-GWT-01
Date: Mon, 10 Nov 2008 13:06:06 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] TSC: resync TSCs on AMD cpus
Message-ID: <20081110120606.GA7476@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Nov 2008 12:06:09.0760 (UTC) FILETIME=[B7C60600:01C9432C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, hi Thomas,

would you consider the patch below for inclusion into the .28 lineup due
to its non-invasive nature for CPUs other than AMD Fam10h and above,
i.e. code flow remains unchanged for them. In addition, extensive
testing here at AMD (both on single and multi-socket systems) showed no
regressions or clock drifts so far and even in the worst case scenario
the application processors will fail the tsc sync check and move to
using another timesource, which is the old behavior of the code.

Thanks.

---
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 10 Nov 2008 12:55:55 +0100
Subject: [PATCH] TSC: resync TSCs on AMD CPUs

Although AMD Fam10h CPUs and later have an invariant timestamp counter,
there's the distant possibility for the application processors to start
their TSCs shortly after the bootstrapping CPU thus causing a delta
between the timestamps and fail the initial TSC check. This patch fixes
that by updating the TSC of each AP with a delta value relative to the
BSP and then restarting the TSC synchronization test.

update_tsc bits reused from Michael Davidson's patch
(http://www.gossamer-threads.com/lists/linux/kernel/977166)

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/tsc.h |   14 +++++++
 arch/x86/kernel/tsc_sync.c |   94 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 98 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 9cd83a8..f1e871f 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -9,6 +9,20 @@
 #define NS_SCALE	10 /* 2^10, carefully chosen */
 #define US_SCALE	32 /* 2^32, arbitralrily chosen */
 
+
+#define update_tsc(wrmsr, delta)	\
+({									\
+	asm volatile(							\
+			"movl $0x10, %%ecx\n\t"				\
+			"rdmsr\n\t"					\
+			"addl %%edi, %%eax\n\t"				\
+			"adcl %%esi, %%edx\n\t"				\
+			wrmsr "\n\t"					\
+			: /* no output */				\
+			: "D" ((u32)delta), "S"((u32)(delta >> 32))	\
+			: "ax", "cx", "dx", "cc");			\
+})
+
 /*
  * Standard way to access the cycle counter.
  */
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9ffb01c..9a3c92e 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -28,15 +28,28 @@
 static __cpuinitdata atomic_t start_count;
 static __cpuinitdata atomic_t stop_count;
 
+/* resync counters */
+static __cpuinitdata atomic_t resync, resync_ran;
+
 /*
  * We use a raw spinlock in this exceptional case, because
  * we want to have the fastest, inlined, non-debug version
  * of a critical section, to be able to prove TSC time-warps:
  */
 static __cpuinitdata raw_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static __cpuinitdata raw_spinlock_t resync_lock = __RAW_SPIN_LOCK_UNLOCKED;
 static __cpuinitdata cycles_t last_tsc;
 static __cpuinitdata cycles_t max_warp;
-static __cpuinitdata int nr_warps;
+static __cpuinitdata int nr_warps, last_cpu;
+
+int cpu_can_resync(void)
+{
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+	    boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return 1;
+
+	return 0;
+}
 
 /*
  * TSC-warp measurement loop running on both CPUs:
@@ -85,6 +98,13 @@ static __cpuinit void check_tsc_warp(void)
 			__raw_spin_lock(&sync_lock);
 			max_warp = max(max_warp, prev - now);
 			nr_warps++;
+
+			/*
+			 * handle the highly unlikely event of some application
+			 * processor starting its tsc earlier than the
+			 * bootstrapping one.
+			 */
+			last_cpu = raw_smp_processor_id();
 			__raw_spin_unlock(&sync_lock);
 		}
 	}
@@ -93,6 +113,36 @@ static __cpuinit void check_tsc_warp(void)
 			now-start, end-start);
 }
 
+void __cpuinit resync_tsc(void)
+{
+	cycles_t sample_start, sample_stop;
+	unsigned long flags;
+	long long delta;
+	int sign = last_cpu ? 1 : -1;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&resync_lock);
+
+	/* sample ops timing taking to write the TSC msr */
+	sample_start = get_cycles();
+	update_tsc("", max_warp);
+	sample_stop = get_cycles();
+
+	delta = sign * ((sample_stop - sample_start) + max_warp);
+
+	update_tsc("wrmsr", delta);
+
+	atomic_set(&resync_ran, 1);
+	atomic_set(&resync, 0);
+
+	nr_warps = 0;
+	max_warp = 0;
+	last_tsc = 0;
+
+	__raw_spin_unlock(&resync_lock);
+	local_irq_restore(flags);
+}
+
 /*
  * Source CPU calls into this - it waits for the freshly booted
  * target CPU to arrive and then starts the measurement:
@@ -101,6 +151,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 {
 	int cpus = 2;
 
+restart_src:
 	/*
 	 * No need to check if we already know that the TSC is not
 	 * synchronized:
@@ -132,26 +183,42 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		cpu_relax();
 
 	if (nr_warps) {
-		printk("\n");
-		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
-				    " turning off TSC clock.\n", max_warp);
-		mark_tsc_unstable("check_tsc_sync_source failed");
+		if (cpu_can_resync() && !atomic_read(&resync_ran)) {
+
+			printk(KERN_CONT " failed.\n");
+			printk(KERN_WARNING "TSC out of sync, resynching.\n");
+			atomic_set(&start_count, 0);
+
+			/* start resync sequence */
+			atomic_set(&resync, 1);
+
+			goto restart_src;
+		} else {
+			printk(KERN_CONT "\n");
+			printk(KERN_WARNING "Measured %lld cycles TSC warp "
+			       "between CPUs, turning off TSC clock.\n",
+			       max_warp);
+			mark_tsc_unstable("check_tsc_sync_source failed");
+		}
 	} else {
 		printk(" passed.\n");
 	}
 
 	/*
+	 * Let the target continue with the bootup:
+	 */
+	atomic_inc(&stop_count);
+
+	/*
 	 * Reset it - just in case we boot another CPU later:
 	 */
 	atomic_set(&start_count, 0);
+	atomic_set(&resync_ran, 0);
 	nr_warps = 0;
 	max_warp = 0;
 	last_tsc = 0;
 
-	/*
-	 * Let the target continue with the bootup:
-	 */
-	atomic_inc(&stop_count);
+
 }
 
 /*
@@ -161,6 +228,10 @@ void __cpuinit check_tsc_sync_target(void)
 {
 	int cpus = 2;
 
+restart_tgt:
+	if (atomic_read(&resync))
+		resync_tsc();
+
 	if (unsynchronized_tsc())
 		return;
 
@@ -182,8 +253,11 @@ void __cpuinit check_tsc_sync_target(void)
 	/*
 	 * Wait for the source CPU to print stuff:
 	 */
-	while (atomic_read(&stop_count) != cpus)
+	while (atomic_read(&stop_count) != cpus) {
+		if (atomic_read(&resync) && (!atomic_read(&resync_ran)))
+			goto restart_tgt;
 		cpu_relax();
+	}
 }
 #undef NR_LOOPS
 
-- 
1.6.0.2

-- 
Regards/Gruss,
Boris.

AMD Saxony, Dresden, Germany
Operating System Research Center

