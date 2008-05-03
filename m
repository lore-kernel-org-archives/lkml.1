Return-Path: <linux-kernel-owner+w=401wt.eu-S1764844AbYECRCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764844AbYECRCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760882AbYECRBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:01:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760128AbYECRBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:01:48 -0400
Date: Sat, 3 May 2008 19:01:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       Guillaume Chazarain <guichaz@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] sched_clock_cpu()
Message-ID: <20080503170130.GB21967@elte.hu>
References: <1209832169.6929.42.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209832169.6929.42.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> it _DOESN'T_ boot ;-/ and I seem to have caught a flu that makes my
> whole body hurt like hell, so I'm not getting anything done.

i think i see where your boot problem comes from:

> +struct sched_clock_data {
> +	spinlock_t lock;

that wont work very well when sched_clock() is called from within 
CONFIG_LOCK_STAT instrumentation. Does the patch below solve the boot 
problems for you?

	Ingo

-------------------->
Subject: sched: sched_clock() fix
From: Ingo Molnar <mingo@elte.hu>
Date: Sat May 03 18:41:11 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c       |    2 --
 kernel/sched_clock.c |   42 ++++++++++++++++++++++++------------------
 2 files changed, 24 insertions(+), 20 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1074,8 +1074,6 @@ static struct rq *this_rq_lock(void)
 	return rq;
 }
 
-	WARN_ON(!irqs_disabled());
-	WARN_ON(!irqs_disabled());
 static void __resched_task(struct task_struct *p, int tif_bit);
 
 static inline void resched_task(struct task_struct *p)
Index: linux/kernel/sched_clock.c
===================================================================
--- linux.orig/kernel/sched_clock.c
+++ linux/kernel/sched_clock.c
@@ -33,12 +33,18 @@
 #ifndef CONFIG_HAVE_STABLE_CLOCK
 
 struct sched_clock_data {
-	spinlock_t lock;
-	unsigned long prev_jiffies;
-	u64 prev_raw;
-	u64 tick_raw;
-	u64 tick_gtod;
-	u64 clock;
+	/*
+	 * Raw spinlock - this is a special case: this might be called
+	 * from within instrumentation code so we dont want to do any
+	 * instrumentation ourselves.
+	 */
+	raw_spinlock_t		lock;
+
+	unsigned long		prev_jiffies;
+	u64			prev_raw;
+	u64			tick_raw;
+	u64			tick_gtod;
+	u64			clock;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
@@ -62,7 +68,7 @@ void sched_clock_init(void)
 	for_each_possible_cpu(cpu) {
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
-		spin_lock_init(&scd->lock);
+		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 		scd->prev_jiffies = jiffies;
 		scd->prev_raw = now;
 		scd->tick_raw = now;
@@ -116,11 +122,11 @@ static void lock_double_clock(struct sch
 			      struct sched_clock_data *data2)
 {
 	if (data1 < data2) {
-		spin_lock(&data1->lock);
-		spin_lock_nested(&data2->lock, SINGLE_DEPTH_NESTING);
+		__raw_spin_lock(&data1->lock);
+		__raw_spin_lock(&data2->lock);
 	} else {
-		spin_lock(&data2->lock);
-		spin_lock_nested(&data1->lock, SINGLE_DEPTH_NESTING);
+		__raw_spin_lock(&data2->lock);
+		__raw_spin_lock(&data1->lock);
 	}
 }
 
@@ -147,14 +153,14 @@ u64 sched_clock_cpu(int cpu)
 		now -= my_scd->tick_gtod;
 		now += scd->tick_gtod;
 
-		spin_unlock(&my_scd->lock);
+		__raw_spin_unlock(&my_scd->lock);
 	} else
-		spin_lock(&scd->lock);
+		__raw_spin_lock(&scd->lock);
 
 	__update_sched_clock(scd, now);
 	clock = scd->clock;
 
-	spin_unlock(&scd->lock);
+	__raw_spin_unlock(&scd->lock);
 
 	return clock;
 }
@@ -164,7 +170,7 @@ void sched_clock_tick(void)
 	struct sched_clock_data *scd = this_scd();
 	u64 now;
 
-	spin_lock(&scd->lock);
+	__raw_spin_lock(&scd->lock);
 	now = sched_clock();
 	__update_sched_clock(scd, now);
 	/*
@@ -174,7 +180,7 @@ void sched_clock_tick(void)
 	 */
 	scd->tick_raw = now;
 	scd->tick_gtod = ktime_to_ns(ktime_get()); // XXX get from regular tick
-	spin_unlock(&scd->lock);
+	__raw_spin_unlock(&scd->lock);
 }
 
 /*
@@ -199,10 +205,10 @@ void sched_clock_idle_wakeup_event(u64 d
 	 * and use the PM-provided delta_ns to advance the
 	 * rq clock:
 	 */
-	spin_lock(&scd->lock);
+	__raw_spin_lock(&scd->lock);
 	scd->prev_raw = sched_clock();
 	scd->clock += delta_ns;
-	spin_unlock(&scd->lock);
+	__raw_spin_unlock(&scd->lock);
 
 	touch_softlockup_watchdog();
 }
