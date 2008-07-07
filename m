Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYGGXtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYGGXtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbYGGXto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:49:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbYGGXtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:49:43 -0400
Date: Mon, 7 Jul 2008 19:49:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched_clock: fix calculation of other CPU
Message-ID: <Pine.LNX.4.58.0807071947070.24502@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The algorithm to calculate the 'now' of another CPU is not correct.
At each scheduler tick, each CPU records the last sched_clock and
gtod (tick_raw and tick_gtod respectively). If the TSC is somewhat the
same in speed between two clocks the algorithm would be:

  tick_gtod1 + (now1 - tick_raw1) = tick_gtod2 + (now2 - tick_raw2)

To calculate now2 we would have:

  now2 = (tick_gtod1 - tick_gtod2) + (tick_raw2 - tick_raw1) + now1

Currently the algorithm is:

  now2 = (tick_gtod1 - tick_gtod2) + (tick_raw1 - tick_raw2) + now1

This solves most of the rest of the issues I've had with timestamps in
ftace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-tip.git/kernel/sched_clock.c
===================================================================
--- linux-tip.git.orig/kernel/sched_clock.c	2008-07-07 18:18:56.000000000 -0400
+++ linux-tip.git/kernel/sched_clock.c	2008-07-07 18:19:44.000000000 -0400
@@ -203,8 +203,8 @@ u64 sched_clock_cpu(int cpu)
 		now -= my_scd->tick_raw;
 		now += scd->tick_raw;

-		now -= my_scd->tick_gtod;
-		now += scd->tick_gtod;
+		now += my_scd->tick_gtod;
+		now -= scd->tick_gtod;

 		__raw_spin_unlock(&my_scd->lock);
 	} else {

