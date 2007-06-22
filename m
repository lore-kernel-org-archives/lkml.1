Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbXFVUmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbXFVUmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXFVUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:42:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:29320 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbXFVUmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:42:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,452,1175497200"; 
   d="scan'208";a="257799028"
Date: Fri, 22 Jun 2007 13:38:22 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/7] ICH Force HPET: Make generic time capable of switching broadcast timer
Message-ID: <20070622203822.GA22807@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Auto-detect the presence of HPET on ICH5 or newer platforms and enable
HPET for broadcast timer. This gives a bigger upperlimit for tickless time
tick and improves the power consumption in comparison to PIT as broadcast timer.

This patch:

Change the broadcast timer, if a timer with higher rating becomes available.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---

Applies over linux-2.6.22-rc4-mm2 +
tglx's  patch-2.6.22-rc4-mm2-hrt4 patch

The patchset had been baking for a while along with patch-2.6.22-rc*-hrt* for
a while without breaking anything and redusing the number of
timer interrupts with tickless on various platforms.

 kernel/time/tick-broadcast.c |   13 ++++++-------
 kernel/time/tick-common.c    |    4 ++--
 2 files changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6.22-rc5/kernel/time/tick-common.c
===================================================================
--- linux-2.6.22-rc5.orig/kernel/time/tick-common.c	2007-06-17 08:52:07.000000000 +0200
+++ linux-2.6.22-rc5/kernel/time/tick-common.c	2007-06-17 08:52:10.000000000 +0200
@@ -200,7 +200,7 @@ static int tick_check_new_device(struct 
 
 	cpu = smp_processor_id();
 	if (!cpu_isset(cpu, newdev->cpumask))
-		goto out;
+		goto out_bc;
 
 	td = &per_cpu(tick_cpu_device, cpu);
 	curdev = td->evtdev;
@@ -265,7 +265,7 @@ out_bc:
 	 */
 	if (tick_check_broadcast_device(newdev))
 		ret = NOTIFY_STOP;
-out:
+
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 
 	return ret;
Index: linux-2.6.22-rc5/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.22-rc5.orig/kernel/time/tick-broadcast.c	2007-06-17 08:52:07.000000000 +0200
+++ linux-2.6.22-rc5/kernel/time/tick-broadcast.c	2007-06-17 08:52:10.000000000 +0200
@@ -64,8 +64,9 @@ static void tick_broadcast_start_periodi
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
-	if (tick_broadcast_device.evtdev ||
-	    (dev->features & CLOCK_EVT_FEAT_C3STOP))
+	if ((tick_broadcast_device.evtdev &&
+	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
+	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
 
 	clockevents_exchange_device(NULL, dev);
@@ -519,11 +520,9 @@ static void tick_broadcast_clear_oneshot
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
-	if (bc->mode != CLOCK_EVT_MODE_ONESHOT) {
-		bc->event_handler = tick_handle_oneshot_broadcast;
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-		bc->next_event.tv64 = KTIME_MAX;
-	}
+	bc->event_handler = tick_handle_oneshot_broadcast;
+	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+	bc->next_event.tv64 = KTIME_MAX;
 }
 
 /*
