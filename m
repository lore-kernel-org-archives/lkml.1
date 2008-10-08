Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYJHNBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYJHNBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 09:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYJHNBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 09:01:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50552 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYJHNBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 09:01:15 -0400
Subject: [PATCH] sched_clock: prevent scd->clock from moving backwards
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1223470773.6336.13.camel@norville.austin.ibm.com>
References: <48D959E8.4000303@goop.org>
	 <1223470773.6336.13.camel@norville.austin.ibm.com>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 08:00:54 -0500
Message-Id: <1223470854.6336.15.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_clock: prevent scd->clock from moving backwards

When sched_clock_cpu() couples the clocks between two cpus, it may
increment scd->clock beyond the GTOD tick window that __update_sched_clock()
uses to clamp the clock.  A later call to __update_sched_clock() may move
the clock back to scd->tick_gtod + TICK_NSEC, violating the clock's
monotonic property.

This patch ensures that scd->clock will not be set backward.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e8ab096..a989d64 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -118,13 +118,13 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
-	 * 		      max(scd->tick_gtod, scd->clock),
-	 * 		      scd->tick_gtod + TICK_NSEC);
+	 *		      max(scd->tick_gtod, scd->clock),
+	 *		      min(scd->clock, scd->tick_gtod + TICK_NSEC));
 	 */
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_min(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);


