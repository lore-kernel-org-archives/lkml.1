Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbZFVL7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbZFVL7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:59:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZFVL6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:58:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZFVL6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:58:52 -0400
Date: Mon, 22 Jun 2009 13:58:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: III.1 - Sampling period randomization
Message-ID: <20090622115806.GO24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> III/ Requests
>
> 1/ Sampling period randomization
>
> It is our experience (on Itanium, for instance), that for certain
> sampling measurements, it is beneficial to randomize the sampling
> period a bit. This is in particular the case when sampling on an
> event that happens very frequently and which is not related to
> timing, e.g., branch_instructions_retired. Randomization helps
> mitigate the bias. You do not need something sophisticated. But
> when you are using a kernel-level sampling buffer, you need to
> have the kernel randomize. Randomization needs to be supported per
> event.

This is on the todo list, it should be pretty straight forward to
implement. Basically add a u64 randomize:1 flag and a u64 rand_size,
and add some noise to hwc->sample_period in perf_counter_overflow(),
just like the .freq path does.

In fact the auto-freq sampling counters effectively randomize
already, as the path of stabilization/convergence is never exactly
the same. We could add a little bit of constant noise to the freq
counter and it would auto-correct automatically.

Since you seem to care abut this sub-feature, would you be
interested in sending a patch for that? The essential steps are:

 - Take a new bit off perf_counter_attr::__reserved_1 and name
   it attr.randomize.

 - Inject a few bits of trivial noise into the period calculated
   in kernel/perf_counter.c:perf_adjust_period(). The best place
   would be to add it right before this line:

        hwc->sample_period = sample_period;

   If you add a small relative fuzz of below 1% to sample_period
   then the code will auto-correct.

 - All the tools deal just fine with variable periods already, so
   there's no tooling updates needed, beyond adding a --randomize
   flag to tools/perf/builtin-record.c.

Let us know if you need any help with any of this!
