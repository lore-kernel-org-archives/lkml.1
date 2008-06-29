Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYF2Qtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYF2Qtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 12:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYF2Qti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 12:49:38 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40390 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYF2Qti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 12:49:38 -0400
Date: Sun, 29 Jun 2008 20:51:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] S390 topology: don't use kthread() for arch_reinit_sched_domains()
Message-ID: <20080629165132.GA11218@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested, needs Heiko's ack.

Now that it is safe to use get_online_cpus() we can revert

	[S390] cpu topology: Fix possible deadlock.
	commit: fd781fa25c9e9c6fd1599df060b05e7c4ad724e5

and call arch_reinit_sched_domains() directly from topology_work_fn().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/arch/s390/kernel/topology.c~WQ_5_TOPOLOGY	2008-05-18 15:43:28.000000000 +0400
+++ 26-rc2/arch/s390/kernel/topology.c	2008-06-29 20:42:38.000000000 +0400
@@ -9,7 +9,6 @@
 #include <linux/device.h>
 #include <linux/bootmem.h>
 #include <linux/sched.h>
-#include <linux/kthread.h>
 #include <linux/workqueue.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
@@ -230,20 +229,9 @@ void arch_update_cpu_topology(void)
 	}
 }
 
-static int topology_kthread(void *data)
-{
-	arch_reinit_sched_domains();
-	return 0;
-}
-
 static void topology_work_fn(struct work_struct *work)
 {
-	/* We can't call arch_reinit_sched_domains() from a multi-threaded
-	 * workqueue context since it may deadlock in case of cpu hotplug.
-	 * So we have to create a kernel thread in order to call
-	 * arch_reinit_sched_domains().
-	 */
-	kthread_run(topology_kthread, NULL, "topology_update");
+	arch_reinit_sched_domains();
 }
 
 void topology_schedule_update(void)

