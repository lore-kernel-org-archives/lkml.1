Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab0BQWVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:21:01 -0500
Received: from ozlabs.org ([203.10.76.45]:40525 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0BQWVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:21:00 -0500
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for Power7
In-reply-to: <1266142340.5273.418.camel@laptop>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264548495.12239.56.camel@jschopp-laptop> <1264720855.9660.22.camel@jschopp-laptop> <1264721088.10385.1.camel@jschopp-laptop> <1265403478.6089.41.camel@jschopp-laptop> <1266142340.5273.418.camel@laptop>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Sun, 14 Feb 2010 11:12:20 +0100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 18 Feb 2010 09:20:58 +1100
Message-ID: <25851.1266445258@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Suppose for a moment we have 2 threads (hot-unplugged thread 1 and 3, we
> can construct an equivalent but more complex example for 4 threads), and
> we have 4 tasks, 3 SCHED_OTHER of equal nice level and 1 SCHED_FIFO, the
> SCHED_FIFO task will consume exactly 50% walltime of whatever cpu it
> ends up on.
> 
> In that situation, provided that each cpu's cpu_power is of equal
> measure, scale_rt_power() ensures that we run 2 SCHED_OTHER tasks on the
> cpu that doesn't run the RT task, and 1 SCHED_OTHER task next to the RT
> task, so that each task consumes 50%, which is all fair and proper.
> 
> However, if you do the above, thread 0 will have +75% = 1.75 and thread
> 2 will have -75% = 0.25, then if the RT task will land on thread 0,
> we'll be having: 0.875 vs 0.25, or on thread 3, 1.75 vs 0.125. In either
> case thread 0 will receive too many (if not all) SCHED_OTHER tasks.
> 
> That is, unless these threads 2 and 3 really are _that_ weak, at which
> point one wonders why IBM bothered with the silicon ;-)

Peter,

2 & 3 aren't weaker than 0 & 1 but.... 

The core has dynamic SMT mode switching which is controlled by the
hypervisor (IBM's PHYP).  There are 3 SMT modes:
	SMT1 uses thread  0
	SMT2 uses threads 0 & 1
	SMT4 uses threads 0, 1, 2 & 3
When in any particular SMT mode, all threads have the same performance
as each other (ie. at any moment in time, all threads perform the same).  

The SMT mode switching works such that when linux has threads 2 & 3 idle
and 0 & 1 active, it will cede (H_CEDE hypercall) threads 2 and 3 in the
idle loop and the hypervisor will automatically switch to SMT2 for that
core (independent of other cores).  The opposite is not true, so if
threads 0 & 1 are idle and 2 & 3 are active, we will stay in SMT4 mode.

Similarly if thread 0 is active and threads 1, 2 & 3 are idle, we'll go
into SMT1 mode.  

If we can get the core into a lower SMT mode (SMT1 is best), the threads
will perform better (since they share less core resources).  Hence when
we have idle threads, we want them to be the higher ones.

So to answer your question, threads 2 and 3 aren't weaker than the other
threads when in SMT4 mode.  It's that if we idle threads 2 & 3, threads
0 & 1 will speed up since we'll move to SMT2 mode.

I'm pretty vague on linux scheduler details, so I'm a bit at sea as to
how to solve this.  Can you suggest any mechanisms we currently have in
the kernel to reflect these properties, or do you think we need to
develop something new?  If so, any pointers as to where we should look?

Thanks,
Mikey
