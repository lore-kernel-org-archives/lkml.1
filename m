Return-Path: <linux-kernel-owner+w=401wt.eu-S964876AbXHOWsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbXHOWsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937358AbXHOWqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:46:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45171 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937356AbXHOWqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:46:34 -0400
Subject: [PATCH] Use num_possible_cpus() instead of NR_CPUS for timer
	distribution
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 15:46:17 -0700
Message-Id: <1187217977.6062.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew requested this fixup awhile back, and I just now got to it
(apologies for being slow).

To avoid lock contention, we distribute the sched_timer calls across the
cpus so they do not trigger at the same instant. However, I used
NR_CPUS, which can cause needless grouping on small smp systems
depending on your kernel config. This patch converts to using
num_possible_cpus() so we spread it as evenly as possible on every
machine.

Briefly tested w/ NR_CPUS=255 and verified reduced contention.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

Index: 2.6-rt/kernel/time/tick-sched.c
===================================================================
--- 2.6-rt.orig/kernel/time/tick-sched.c
+++ 2.6-rt/kernel/time/tick-sched.c
@@ -586,7 +586,7 @@ void tick_setup_sched_timer(void)
 	/* Get the next period (per cpu) */
 	ts->sched_timer.expires = tick_init_jiffy_update();
 	offset = ktime_to_ns(tick_period) >> 1;
-	do_div(offset, NR_CPUS);
+	do_div(offset, num_possible_cpus());
 	offset *= smp_processor_id();
 	ts->sched_timer.expires = ktime_add_ns(ts->sched_timer.expires, offset);
 


