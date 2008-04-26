Return-Path: <linux-kernel-owner+w=401wt.eu-S933874AbYDZAUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874AbYDZAUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762278AbYDZAQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:16:01 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59193 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758288AbYDZAPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:51 -0400
Message-Id: <20080426001550.674731000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:58 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] x86: Use performance variant next_cpu_nr
Content-Disposition: inline; filename=use-next_cpu_nr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Change references from for_each_cpu_mask to for_each_cpu_mask_nr
    where appropriate.

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Reviewed-by: Paul Jackson <pj@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    4 ++--
 kernel/time/clocksource.c             |    4 ++--
 kernel/time/tick-broadcast.c          |    3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

--- linux-2.6.sched.orig/drivers/infiniband/hw/ehca/ehca_irq.c
+++ linux-2.6.sched/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -637,8 +637,8 @@ static inline int find_next_online_cpu(s
 		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = next_cpu(pool->last_cpu, cpu_online_map);
-	if (cpu == NR_CPUS)
+	cpu = next_cpu_nr(pool->last_cpu, cpu_online_map);
+	if (cpu >= nr_cpu_ids)
 		cpu = first_cpu(cpu_online_map);
 	pool->last_cpu = cpu;
 	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
--- linux-2.6.sched.orig/kernel/time/clocksource.c
+++ linux-2.6.sched/kernel/time/clocksource.c
@@ -145,9 +145,9 @@ static void clocksource_watchdog(unsigne
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = next_cpu_nr(raw_smp_processor_id(), cpu_online_map);
 
-		if (next_cpu >= NR_CPUS)
+		if (next_cpu >= nr_cpu_ids)
 			next_cpu = first_cpu(cpu_online_map);
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
 		add_timer_on(&watchdog_timer, next_cpu);
--- linux-2.6.sched.orig/kernel/time/tick-broadcast.c
+++ linux-2.6.sched/kernel/time/tick-broadcast.c
@@ -397,8 +397,7 @@ again:
 	mask = CPU_MASK_NONE;
 	now = ktime_get();
 	/* Find all expired events */
-	for (cpu = first_cpu(tick_broadcast_oneshot_mask); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, tick_broadcast_oneshot_mask)) {
+	for_each_cpu_mask_nr(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpu_set(cpu, mask);

-- 
