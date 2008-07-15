Return-Path: <linux-kernel-owner+w=401wt.eu-S1763362AbYGOVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763362AbYGOVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbYGOVOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33437 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755624AbYGOVOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:31 -0400
Message-Id: <20080715211430.173661000@polaris-admin.engr.sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:34 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/8] cpumask: Optimize cpumask_of_cpu in kernel/time/tick-common.c
Content-Disposition: inline; filename=optimize-cpu_mask_of_cpu-in-kernel_time_tick-common_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Optimize various places where a pointer to the cpumask_of_cpu value
    will result in reducing stack pressure.

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-common.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.tip.orig/kernel/time/tick-common.c
+++ linux-2.6.tip/kernel/time/tick-common.c
@@ -135,7 +135,7 @@ void tick_setup_periodic(struct clock_ev
  */
 static void tick_setup_device(struct tick_device *td,
 			      struct clock_event_device *newdev, int cpu,
-			      cpumask_t cpumask)
+			      const cpumask_t *cpumask)
 {
 	ktime_t next_event;
 	void (*handler)(struct clock_event_device *) = NULL;
@@ -169,8 +169,8 @@ static void tick_setup_device(struct tic
 	 * When the device is not per cpu, pin the interrupt to the
 	 * current cpu:
 	 */
-	if (!cpus_equal(newdev->cpumask, cpumask))
-		irq_set_affinity(newdev->irq, cpumask);
+	if (!cpus_equal(newdev->cpumask, *cpumask))
+		irq_set_affinity(newdev->irq, *cpumask);
 
 	/*
 	 * When global broadcasting is active, check if the current
@@ -196,20 +196,20 @@ static int tick_check_new_device(struct 
 	struct tick_device *td;
 	int cpu, ret = NOTIFY_OK;
 	unsigned long flags;
-	cpumask_t cpumask;
+	cpumask_of_cpu_ptr_declare(cpumask);
 
 	spin_lock_irqsave(&tick_device_lock, flags);
 
 	cpu = smp_processor_id();
+	cpumask_of_cpu_ptr_next(cpumask, cpu);
 	if (!cpu_isset(cpu, newdev->cpumask))
 		goto out_bc;
 
 	td = &per_cpu(tick_cpu_device, cpu);
 	curdev = td->evtdev;
-	cpumask = cpumask_of_cpu(cpu);
 
 	/* cpu local device ? */
-	if (!cpus_equal(newdev->cpumask, cpumask)) {
+	if (!cpus_equal(newdev->cpumask, *cpumask)) {
 
 		/*
 		 * If the cpu affinity of the device interrupt can not
@@ -222,7 +222,7 @@ static int tick_check_new_device(struct 
 		 * If we have a cpu local device already, do not replace it
 		 * by a non cpu local device
 		 */
-		if (curdev && cpus_equal(curdev->cpumask, cpumask))
+		if (curdev && cpus_equal(curdev->cpumask, *cpumask))
 			goto out_bc;
 	}
 

-- 
