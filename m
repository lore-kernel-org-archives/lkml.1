Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246Ab0ADIbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0ADIbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 03:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130Ab0ADIbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 03:31:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:15442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab0ADIbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 03:31:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,497,1257148800"; 
   d="scan'208";a="481019986"
Subject: volano ~30% regression with 2.6.33-rc1 & -rc2
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 16:15:58 +0800
Message-Id: <1262592958.22471.104.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike & Peter,

Compared with 2.6.32, volano has ~30% regression with 2.6.33-rc1 & -rc2.
Testing machine: Tigerton Xeon, 16cpus(4P/4Core), 16G memory

Bisect to below commit,

commit a1f84a3ab8e002159498814eaa7e48c33752b04b
Author: Mike Galbraith <efault@gmx.de>
Date:   Tue Oct 27 15:35:38 2009 +0100

    sched: Check for an idle shared cache in select_task_rq_fair()

    When waking affine, check for an idle shared cache, and if
    found, wake to that CPU/sibling instead of the waker's CPU.

    This improves pgsql+oltp ramp up by roughly 8%. Possibly more
    for other loads, depending on overlap. The trade-off is a
    roughly 1% peak downturn if tasks are truly synchronous.

    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Cc: Arjan van de Ven <arjan@infradead.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: <stable@kernel.org>
    LKML-Reference: <1256654138.17752.7.camel@marge.simson.net>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


This commit can't be reverted due to conflict, so I reverted below 4
commits related to idle-shared-cache in 2.6.33-rc2, and then the
performance was restored to 2.6.32.

fe3bcfe (sched: More generic WAKE_AFFINE vs select_idle_sibling())
a50bde5 (sched: Cleanup select_task_rq_fair())
fd21073 (sched: Fix affinity logic in select_task_rq_fair())
a1f84a3 (sched: Check for an idle shared cache in select_task_rq_fair())

This regression seems caused by cache misses of access to per cpu data.
(see below perf top cache-misses data for detail)

select_idle_sibling(...)
{
        ....
        for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
                if (!cpu_rq(i)->cfs.nr_running) {
                        target = i;
                        break;
                }
        }
	....
}

The performance can be restored to 2.6.32 as well if SD_PREFER_SIBLING
is not set, so select_idle_sibling will not be called.

perf top data as follow,

2.6.33-rc1 cache-misses data (note 11.8% select_task_rq_fair)
------------------------------------------------------------------------------------
   PerfTop:   12262 irqs/sec  kernel:90.6% [1000Hz cache-misses],  (all, 16 CPUs)
------------------------------------------------------------------------------------

             samples  pcnt function                      DSO
             _______ _____ _____________________________ ________________

            18272.00 11.8% select_task_rq_fair           [kernel.kallsyms]       
            15499.00 10.0% schedule                      [kernel.kallsyms]       
             9447.00  6.1% update_curr                   [kernel.kallsyms]       
             9255.00  6.0% _raw_spin_lock                [kernel.kallsyms]       
             5161.00  3.3% tcp_sendmsg                   [kernel.kallsyms] 

2.6.32 cache-misses data
--------------------------------------------------------------------------------------
   PerfTop:   11749 irqs/sec  kernel:88.2% [1000Hz cache-misses],  (all, 16 CPUs)
--------------------------------------------------------------------------------------

             samples  pcnt function                      DSO
             _______ _____ _____________________________ _________________
            11974.00 11.5% schedule                      [kernel.kallsyms]                                                                        
             6656.00  6.4% _spin_lock                    [kernel.kallsyms]                                                                        
             5852.00  5.6% update_curr                   [kernel.kallsyms]                                                                        
             3140.00  3.0% enqueue_entity                [kernel.kallsyms]                                                                        
             2846.00  2.7% tcp_sendmsg                   [kernel.kallsyms] 
    
2.6.33-rc1 cycles data (note 6.5% select_task_rq_fair)        
-------------------------------------------------------------------------------
   PerfTop:   11106 irqs/sec  kernel:99.7% [1000Hz cycles],  (all, 16 CPUs)
-------------------------------------------------------------------------------

             samples  pcnt function                  DSO
             _______ _____ _________________________ _________________

            11658.00 10.0% schedule                  [kernel.kallsyms]
            10870.00  9.4% _raw_spin_lock            [kernel.kallsyms]
             7576.00  6.5% select_task_rq_fair       [kernel.kallsyms]
             3696.00  3.2% tcp_sendmsg               [kernel.kallsyms]
             3000.00  2.6% update_curr               [kernel.kallsyms]

2.6.32 cycles data
------------------------------------------------------------------------------------
   PerfTop:   10462 irqs/sec  kernel:99.8% [1000Hz cycles],  (all, 16 CPUs)
------------------------------------------------------------------------------------

             samples  pcnt function                  DSO
             _______ _____ _________________________ _________________

            13364.00  9.9% schedule                  [kernel.kallsyms]
            13140.00  9.8% _spin_lock                [kernel.kallsyms]
             4903.00  3.6% tcp_sendmsg               [kernel.kallsyms]
             4017.00  3.0% update_curr               [kernel.kallsyms]
             3395.00  2.5% _spin_lock_bh             [kernel.kallsyms]


Lin Ming


