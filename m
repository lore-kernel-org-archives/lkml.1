Return-Path: <linux-kernel-owner+w=401wt.eu-S966632AbXEGUbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966632AbXEGUbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966613AbXEGUbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:31:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:43681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966626AbXEGUbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:31:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="225362276"
Date: Mon, 7 May 2007 13:28:54 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 2/8] Change the broadcast timer based on rating of clockevent dev
Message-ID: <20070507202854.GB3926@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Change the broadcast timer, if a timer with higher rating becomes available.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-tolkml/kernel/time/tick-common.c
===================================================================
--- linux-2.6.21-tolkml.orig/kernel/time/tick-common.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-tolkml/kernel/time/tick-common.c	2007-05-07 09:52:55.000000000 -0700
@@ -200,7 +200,7 @@
 
 	cpu = smp_processor_id();
 	if (!cpu_isset(cpu, newdev->cpumask))
-		goto out;
+		goto out_bc;
 
 	td = &per_cpu(tick_cpu_device, cpu);
 	curdev = td->evtdev;
@@ -265,7 +265,7 @@
 	 */
 	if (tick_check_broadcast_device(newdev))
 		ret = NOTIFY_STOP;
-out:
+
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 
 	return ret;
Index: linux-2.6.21-tolkml/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.21-tolkml.orig/kernel/time/tick-broadcast.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-tolkml/kernel/time/tick-broadcast.c	2007-05-07 09:54:32.000000000 -0700
@@ -58,8 +58,9 @@
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
@@ -483,11 +484,9 @@
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
