Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbXLLVkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbXLLVkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbXLLVjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:39:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760118AbXLLVjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:39:47 -0500
Date: Wed, 12 Dec 2007 22:39:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86, timer, genirq updates
Message-ID: <20071212213927.GA27762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

x86: an AMD/Barcelona bugfix, timers: two bugfixes, genirq: 
missing inline function added. Tested on 32-bit and 64-bit x86.

	Ingo

------------------>
Adrian Bunk (1):
      timer: kernel/timer.c section fixes

Barry Kasindorf (1):
      oprofile: op_model_athlon.c support for AMD family 10h barcelona performance counters

Kevin Hilman (1):
      genirq: add unlocked version of set_irq_handler()

Thomas Gleixner (1):
      clockevents: fix reprogramming decision in oneshot broadcast

 arch/x86/oprofile/op_model_athlon.c |   22 ++++++++++----
 include/linux/irq.h                 |    7 ++++
 kernel/time/tick-broadcast.c        |   56 +++++++++++++-----------------------
 kernel/timer.c                      |    4 +-
 4 files changed, 46 insertions(+), 43 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 3057a19..c3ee433 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -1,6 +1,6 @@
 /**
  * @file op_model_athlon.h
- * athlon / K7 model-specific MSR operations
+ * athlon / K7 / K8 / Family 10h model-specific MSR operations
  *
  * @remark Copyright 2002 OProfile authors
  * @remark Read the file COPYING
@@ -31,12 +31,16 @@
 #define CTRL_WRITE(l,h,msrs,c) do {wrmsr(msrs->controls[(c)].addr, (l), (h));} while (0)
 #define CTRL_SET_ACTIVE(n) (n |= (1<<22))
 #define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR(x) (x &= (1<<21))
+#define CTRL_CLEAR_LO(x) (x &= (1<<21))
+#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
 #define CTRL_SET_ENABLE(val) (val |= 1<<20)
 #define CTRL_SET_USR(val,u) (val |= ((u & 1) << 16))
 #define CTRL_SET_KERN(val,k) (val |= ((k & 1) << 17))
 #define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT(val, e) (val |= e)
+#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
+#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
+#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
+#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
 static unsigned long reset_value[NUM_COUNTERS];
  
@@ -70,7 +74,8 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
 			continue;
 		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR(low);
+		CTRL_CLEAR_LO(low);
+		CTRL_CLEAR_HI(high);
 		CTRL_WRITE(low, high, msrs, i);
 	}
 
@@ -89,12 +94,17 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 			CTR_WRITE(counter_config[i].count, msrs, i);
 
 			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR(low);
+			CTRL_CLEAR_LO(low);
+			CTRL_CLEAR_HI(high);
 			CTRL_SET_ENABLE(low);
 			CTRL_SET_USR(low, counter_config[i].user);
 			CTRL_SET_KERN(low, counter_config[i].kernel);
 			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT(low, counter_config[i].event);
+			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
+			CTRL_SET_HOST_ONLY(high, 0);
+			CTRL_SET_GUEST_ONLY(high, 0);
+
 			CTRL_WRITE(low, high, msrs, i);
 		} else {
 			reset_value[i] = 0;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index efc8853..4669be0 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -339,6 +339,13 @@ extern void
 __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name);
 
+/* caller has locked the irq_desc and both params are valid */
+static inline void __set_irq_handler_unlocked(int irq,
+					      irq_flow_handler_t handler)
+{
+	irq_desc[irq].handle_irq = handler;
+}
+
 /*
  * Set a highlevel flow handler for a given IRQ:
  */
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index aa82d7b..5b86698 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -384,45 +384,19 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 }
 
 /*
- * Reprogram the broadcast device:
- *
- * Called with tick_broadcast_lock held and interrupts disabled.
- */
-static int tick_broadcast_reprogram(void)
-{
-	ktime_t expires = { .tv64 = KTIME_MAX };
-	struct tick_device *td;
-	int cpu;
-
-	/*
-	 * Find the event which expires next:
-	 */
-	for (cpu = first_cpu(tick_broadcast_oneshot_mask); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, tick_broadcast_oneshot_mask)) {
-		td = &per_cpu(tick_cpu_device, cpu);
-		if (td->evtdev->next_event.tv64 < expires.tv64)
-			expires = td->evtdev->next_event;
-	}
-
-	if (expires.tv64 == KTIME_MAX)
-		return 0;
-
-	return tick_broadcast_set_event(expires, 0);
-}
-
-/*
  * Handle oneshot mode broadcasting
  */
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
 	cpumask_t mask;
-	ktime_t now;
+	ktime_t now, next_event;
 	int cpu;
 
 	spin_lock(&tick_broadcast_lock);
 again:
 	dev->next_event.tv64 = KTIME_MAX;
+	next_event.tv64 = KTIME_MAX;
 	mask = CPU_MASK_NONE;
 	now = ktime_get();
 	/* Find all expired events */
@@ -431,19 +405,31 @@ again:
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpu_set(cpu, mask);
+		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+			next_event.tv64 = td->evtdev->next_event.tv64;
 	}
 
 	/*
-	 * Wakeup the cpus which have an expired event. The broadcast
-	 * device is reprogrammed in the return from idle code.
+	 * Wakeup the cpus which have an expired event.
+	 */
+	tick_do_broadcast(mask);
+
+	/*
+	 * Two reasons for reprogram:
+	 *
+	 * - The global event did not expire any CPU local
+	 * events. This happens in dyntick mode, as the maximum PIT
+	 * delta is quite small.
+	 *
+	 * - There are pending events on sleeping CPUs which were not
+	 * in the event mask
 	 */
-	if (!tick_do_broadcast(mask)) {
+	if (next_event.tv64 != KTIME_MAX) {
 		/*
-		 * The global event did not expire any CPU local
-		 * events. This happens in dyntick mode, as the
-		 * maximum PIT delta is quite small.
+		 * Rearm the broadcast device. If event expired,
+		 * repeat the above
 		 */
-		if (tick_broadcast_reprogram())
+		if (tick_broadcast_set_event(next_event, 0))
 			goto again;
 	}
 	spin_unlock(&tick_broadcast_lock);
diff --git a/kernel/timer.c b/kernel/timer.c
index a05817c..d4527dc 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1219,11 +1219,11 @@ asmlinkage long sys_sysinfo(struct sysinfo __user *info)
  */
 static struct lock_class_key base_lock_keys[NR_CPUS];
 
-static int __devinit init_timers_cpu(int cpu)
+static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
 	tvec_base_t *base;
-	static char __devinitdata tvec_base_done[NR_CPUS];
+	static char __cpuinitdata tvec_base_done[NR_CPUS];
 
 	if (!tvec_base_done[cpu]) {
 		static char boot_done;
