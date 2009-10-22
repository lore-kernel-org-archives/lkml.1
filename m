Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZJVMl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZJVMl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZJVMl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:41:28 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39953 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbZJVMlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:22 -0400
Message-Id: <20091022124112.965719267@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:59 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 16/17] sched: Deal with low-load in wake_affine()
Content-Disposition: inline; filename=wake_affine_low_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    wake_affine() would always fail under low-load situations where
    both prev and this were idle, because adding a single task will
    always be a significant imbalance, even if there's nothing
    around that could balance it.
    
    Deal with this by allowing imbalance when there's nothing you
    can do about it.
    
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>

Index: linux-2.6.31.4-rt14-lb1/kernel/sched_fair.c
===================================================================
--- linux-2.6.31.4-rt14-lb1.orig/kernel/sched_fair.c	2009-10-21 10:49:02.000000000 -0400
+++ linux-2.6.31.4-rt14-lb1/kernel/sched_fair.c	2009-10-21 10:49:04.000000000 -0400
@@ -1264,7 +1264,17 @@
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
-	balanced = 100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
+	/*
+	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
+	 * due to the sync cause above having dropped tl to 0, we'll always have
+	 * an imbalance, but there's really nothing you can do about that, so
+	 * that's good too.
+	 *
+	 * Otherwise check if either cpus are near enough in load to allow this
+	 * task to be woken on this_cpu.
+	 */
+	balanced = !tl ||
+		100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
 
 	/*

--
