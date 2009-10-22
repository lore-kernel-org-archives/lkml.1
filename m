Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZJVMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZJVMnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZJVMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:43:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46287 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbZJVMlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:11 -0400
Message-Id: <20091022124113.193125254@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:08:00 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 17/17] sched: Fix dynamic power-balancing crash
Content-Disposition: inline; filename=fix_power_bal_crash.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
    This crash:
    
    [ 1774.088275] divide error: 0000 [#1] SMP
    [ 1774.100355] CPU 13
    [ 1774.102498] Modules linked in:
    [ 1774.105631] Pid: 30881, comm: hackbench Not tainted 2.6.31-rc8-tip-01308-g484d664-dirty #1629 X8DTN
    [ 1774.114807] RIP: 0010:[<ffffffff81041c38>]  [<ffffffff81041c38>]
    sched_balance_self+0x19b/0x2d4
    
    Triggers because update_group_power() modifies the sd tree and does
    temporary calculations there - not considering that other CPUs
    could observe intermediate values, such as the zero initial value.
    
    Calculate it in a temporary variable instead. (we need no memory
    barrier as these are all statistical values anyway)
    
Got the same oops with the backport to -rt
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>

Index: linux-2.6.31.4-rt14-lb1/kernel/sched.c
===================================================================
--- linux-2.6.31.4-rt14-lb1.orig/kernel/sched.c	2009-10-21 10:49:03.000000000 -0400
+++ linux-2.6.31.4-rt14-lb1/kernel/sched.c	2009-10-22 01:48:41.000000000 -0400
@@ -3864,19 +3864,22 @@
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
+	unsigned long power;
 
 	if (!child) {
 		update_cpu_power(sd, cpu);
 		return;
 	}
 
-	sdg->cpu_power = 0;
+	power = 0;
 
 	group = child->groups;
 	do {
-		sdg->cpu_power += group->cpu_power;
+		power += group->cpu_power;
 		group = group->next;
 	} while (group != child->groups);
+
+	sdg->cpu_power = power;
 }
 
 /**

--
