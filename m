Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbYEOQtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbYEOQtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYEOQtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:49:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbYEOQtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:49:01 -0400
Subject: Re: [Bug 10648] CONFIG_PRINTK_TIME broken on git HEAD ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bugme-daemon@bugzilla.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080515162703.D4970108060@picon.linux-foundation.org>
References: <20080515162703.D4970108060@picon.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 15 May 2008 18:48:46 +0200
Message-Id: <1210870126.6524.16.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: fix sched_clock_cpu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Make sched_clock_cpu() return 0 before it has been initialised and avoid
corrupting its state due to doing so.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_clock.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_clock.c
===================================================================
--- linux-2.6.orig/kernel/sched_clock.c	2008-05-13 18:40:35.000000000 +0200
+++ linux-2.6/kernel/sched_clock.c	2008-05-13 18:42:05.000000000 +0200
@@ -60,22 +60,26 @@
 	return &per_cpu(sched_clock_data, cpu);
 }
 
+static __read_mostly int sched_clock_running;
+
 void sched_clock_init(void)
 {
 	u64 ktime_now = ktime_to_ns(ktime_get());
-	u64 now = 0;
+	unsigned long now_jiffies = jiffies;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		scd->prev_jiffies = jiffies;
-		scd->prev_raw = now;
-		scd->tick_raw = now;
+		scd->prev_jiffies = now_jiffies;
+		scd->prev_raw = 0;
+		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
 	}
+
+	sched_clock_running = 1;
 }
 
 /*
@@ -137,6 +141,9 @@
 	struct sched_clock_data *scd = cpu_sdc(cpu);
 	u64 now, clock;
 
+	if (unlikely(!sched_clock_running))
+		return 0ull;
+
 	/*
 	 * Normally this is not called in NMI context - but if it is,
 	 * trying to do any locking here is totally lethal.
@@ -182,6 +189,9 @@
 	struct sched_clock_data *scd = this_scd();
 	u64 now, now_gtod;
 
+	if (unlikely(!sched_clock_running))
+		return;
+
 	WARN_ON_ONCE(!irqs_disabled());
 
 	now = sched_clock();


