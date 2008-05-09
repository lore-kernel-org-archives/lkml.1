Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYEIJjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYEIJjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYEIJjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:39:37 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:42645 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYEIJjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:39:36 -0400
Subject: Re: CONFIG_PRINTK_TIME broken on git HEAD ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4822E23F.8040101@googlemail.com>
References: <48222C7C.2050807@googlemail.com>
	 <20080507154155.2b472bb1.akpm@linux-foundation.org>
	 <482233CD.70502@googlemail.com>  <4822DD4E.3010000@googlemail.com>
	 <1210245238.13978.199.camel@twins>  <4822E23F.8040101@googlemail.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 11:39:33 +0200
Message-Id: <1210325973.13978.216.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 13:21 +0200, Gabriel C wrote:

> > Ok, so the issue is that the clock doesn't start at 0, but at:
> > 4294014.506571 ?
> 
> At least on my box , yes.
> 

Does this work for you?

---

Subject: sched: fixup sched-clock offset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

It could happen that ktime doesn't start at 0.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_clock.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6-2/kernel/sched_clock.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_clock.c
+++ linux-2.6-2/kernel/sched_clock.c
@@ -59,21 +59,23 @@ static inline struct sched_clock_data *c
 	return &per_cpu(sched_clock_data, cpu);
 }
 
+static __read_mostly u64 ktime_offset;
+
 void sched_clock_init(void)
 {
-	u64 ktime_now = ktime_to_ns(ktime_get());
-	u64 now = 0;
 	int cpu;
 
+	ktime_offset = ktime_to_ns(ktime_get());
+
 	for_each_possible_cpu(cpu) {
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 		scd->prev_jiffies = jiffies;
-		scd->prev_raw = now;
-		scd->tick_raw = now;
-		scd->tick_gtod = ktime_now;
-		scd->clock = ktime_now;
+		scd->prev_raw = 0;
+		scd->tick_raw = 0;
+		scd->tick_gtod = 0;
+		scd->clock = 0;
 	}
 }
 
@@ -177,7 +179,7 @@ void sched_clock_tick(void)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	now = sched_clock();
-	now_gtod = ktime_to_ns(ktime_get());
+	now_gtod = ktime_to_ns(ktime_get()) - ktime_offset;
 
 	__raw_spin_lock(&scd->lock);
 	__update_sched_clock(scd, now);


