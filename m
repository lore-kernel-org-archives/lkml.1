Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479Ab0AYKTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0AYKTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 05:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453Ab0AYKTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 05:19:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:46908 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab0AYKTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 05:19:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="236423988"
Subject: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Jan 2010 18:03:46 +0800
Message-Id: <1264413826.3642.88.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

The netperf lookback regression comes back again.
UDP stream test has ~50% regression with 2.6.33-rc1 compared to 2.6.32.

Testing machine: Nehalem, 2 sockets, 4 cores, hyper thread, 4G mem
Server and client are bind to different physical cpu. 

taskset -c 15 ./netserver
taskset -c 0 ./netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5
-- -P 12384,12888 -s 32768 -S 32768 -m 1024

Bisect to below commit,

commit 1b9508f6831e10d53256825de8904caa22d1ca2c
Author: Mike Galbraith <efault@gmx.de>
Date:   Wed Nov 4 17:53:50 2009 +0100

    sched: Rate-limit newidle
    
    Rate limit newidle to migration_cost. It's a win for all
    stages of sysbench oltp tests.
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <new-submission>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Interesting, this commit was originally fixed the similar UDP stream
test regression on a tulsa machine in 2.6.32-rc1, see below threads
http://marc.info/?t=125722014400001&r=1&w=2
But now it introduces a regression on a Nehalem machine.

This regression seems caused by a lot of rescheduling IPI.

Perf top data as below, note "default_send_IPI_mask_sequence_phys"

             samples  pcnt function                            DSO
             _______ _____ ___________________________________ _________________

             1407.00  6.8% _spin_lock_bh                       [kernel.kallsyms]
             1330.00  6.4% copy_user_generic_string            [kernel.kallsyms]
             1017.00  4.9% _spin_lock_irq                      [kernel.kallsyms]
              968.00  4.7% default_send_IPI_mask_sequence_phys [kernel.kallsyms]
              891.00  4.3% acpi_os_read_port                   [kernel.kallsyms]
              818.00  4.0% sock_alloc_send_pskb                [kernel.kallsyms]
              776.00  3.8% _spin_lock_irqsave                  [kernel.kallsyms]
              757.00  3.7% __udp4_lib_lookup                   [kernel.kallsyms]

/proc/interrupts shows a lot of "Rescheduling interrupts" that are send
from CPU 0(client) to CPU 15(server).

With above commit, the idle balance was rate limited, so CPU 15(server,
waiting data from client) is idle at most time.

CPU0(client) executes as below,

try_to_wake_up
   check_preempt_curr_idle
      resched_task
         smp_send_reschedule

This causes a lot of rescheduling IPI.

This commit can't be reverted due to conflict, so I just add below code
to disable "Rate-limit newidle" and the performance was recovered.

diff --git a/kernel/sched.c b/kernel/sched.c
index 18cceee..588fdef 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4421,9 +4421,6 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 
 	this_rq->idle_stamp = this_rq->clock;
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
-
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 

Lin Ming

