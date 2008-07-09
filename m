Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYGIESu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYGIESu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYGIES2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:18:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYGIES1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:18:27 -0400
Message-Id: <20080709041825.355150582@goodmis.org>
References: <20080709041530.668120406@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 00:15:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] sched_clock: record TSC after gtod
Content-Disposition: inline; filename=sched_clock-reverse-order-raw-gtod.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To read the gtod we need to grab the xtime lock for read. Reading the gtod
before the TSC can cause a bigger gab if the xtime lock is contended.

This patch simply reverses the order to read the TSC after the gtod.
The locking in the reading of the gtod handles any barriers one might
think is needed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/kernel/sched_clock.c
===================================================================
--- linux-tip.git.orig/kernel/sched_clock.c	2008-07-08 11:03:05.000000000 -0400
+++ linux-tip.git/kernel/sched_clock.c	2008-07-08 16:53:34.000000000 -0400
@@ -237,8 +237,8 @@ void sched_clock_tick(void)
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	now = sched_clock();
 	now_gtod = ktime_to_ns(ktime_get());
+	now = sched_clock();
 
 	__raw_spin_lock(&scd->lock);
 	__update_sched_clock(scd, now, NULL);

-- 
