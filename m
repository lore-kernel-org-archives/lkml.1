Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbYJISVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbYJISVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYJISVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:21:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57085 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbYJISVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:21:35 -0400
Subject: [PATCH] sched_clock: prevent scd->clock from moving backwards
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1223574862.6407.16.camel@norville.austin.ibm.com>
References: <48D959E8.4000303@goop.org>
	 <1223470773.6336.13.camel@norville.austin.ibm.com>
	 <1223470854.6336.15.camel@norville.austin.ibm.com>
	 <1223507104.7382.6.camel@lappy.programming.kicks-ass.net>
	 <20081009090605.GA21798@elte.hu>  <20081009151703.GA8010@elte.hu>
	 <1223574862.6407.16.camel@norville.austin.ibm.com>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 13:21:30 -0500
Message-Id: <1223576490.6394.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 12:54 -0500, Dave Kleikamp wrote:

> I'll fix the patch and retest it before sending it again.

I'm definitely running with the new patch now.  Here goes:
 -------------------------------------------------
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
index e8ab096..8178724 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -118,13 +118,13 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
-	 * 		      max(scd->tick_gtod, scd->clock),
-	 * 		      scd->tick_gtod + TICK_NSEC);
+	 *		      max(scd->tick_gtod, scd->clock),
+	 *		      max(scd->clock, scd->tick_gtod + TICK_NSEC));
 	 */
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);

-- 
David Kleikamp
IBM Linux Technology Center

