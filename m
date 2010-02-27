Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965988Ab0B0WtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:49:03 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38924 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964920Ab0B0WtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:49:00 -0500
Date: Sat, 27 Feb 2010 14:48:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] rcu: fixes for RCU lockdep
Message-ID: <20100227224859.GB6846@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100225220624.GA7013@linux.vnet.ibm.com> <20100226115018.GA4519@elte.hu> <20100226174248.GF6733@linux.vnet.ibm.com> <20100227095115.GF31794@elte.hu> <20100227125953.GA15880@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100227125953.GA15880@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 01:59:53PM +0100, Ingo Molnar wrote:
> 
> here's another one:
> 
> [    0.000000] Memory: 914996k/1047744k available (15146k kernel code, 452k absent, 131584k reserved, 12516k data, 2552k init)
> [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.000000] 
> [    0.000000] ===================================================
> [    0.000000] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    0.000000] ---------------------------------------------------
> [    0.000000] include/linux/cgroup.h:492 invoked rcu_dereference_check() without protection!
> [    0.000000] 
> [    0.000000] other info that might help us debug this:
> [    0.000000] 
> [    0.000000] 1 lock held by swapper/0:
> [    0.000000]  #0:  (&rq->lock){......}, at: [<ffffffff81ec0bad>] init_idle+0x31/0x1ee
> [    0.000000] 
> [    0.000000] stack backtrace:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-tip+ #10563
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff810ad1c1>] lockdep_rcu_dereference+0xa1/0xb0
> [    0.000000]  [<ffffffff81ec0cbd>] init_idle+0x141/0x1ee
> [    0.000000]  [<ffffffff82ceff40>] sched_init+0x43a/0x4b6
> [    0.000000]  [<ffffffff82cdcceb>] start_kernel+0x1b3/0x49e
> [    0.000000]  [<ffffffff82cdc319>] x86_64_start_reservations+0x120/0x124
> [    0.000000]  [<ffffffff82cdc46b>] x86_64_start_kernel+0x14e/0x15d
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] RCU-based detection of stalled CPUs is enabled.
> [    0.000000] NR_IRQS:4352
> 
> on:
> 
> 1bc9767: Merge branch 'tracing/core'

Thank you very much, found it trivially this time.  ;-)

> Config attached. This too seems to a sched-init artifact. Could we use 
> inc_preempt_count() perhaps to make sure we have the preempt count disabled 
> even on !PREEMPT? Instead of hacking more 'the scheduler is not initialized 
> yet' checks into various debug checks?

This is based on plain RCU rather than RCU-sched, so inc_preempt_count()
won't help in this case (though I expect that it might work very well
in other cases).  So I hack another 'the scheduler is not initialized
yet' check in a separate set of patches. :-(

							Thanx, Paul
