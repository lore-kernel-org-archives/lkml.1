Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZEVKLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZEVKLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZEVKLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:11:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54038 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZEVKLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:11:45 -0400
Date: Fri, 22 May 2009 12:11:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
	identical inherited contexts
Message-ID: <20090522101128.GC13482@elte.hu>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com> <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> When monitoring a process and its descendants with a set of 
> inherited counters, we can often get the situation in a context 
> switch where both the old (outgoing) and new (incoming) process 
> have the same set of counters, and their values are ultimately 
> going to be added together. In that situation it doesn't matter 
> which set of counters are used to count the activity for the new 
> process, so there is really no need to go through the process of 
> reading the hardware counters and updating the old task's counters 
> and then setting up the PMU for the new task.
> 
> This optimizes the context switch in this situation.  Instead of 
> scheduling out the perf_counter_context for the old task and 
> scheduling in the new context, we simply transfer the old context 
> to the new task and keep using it without interruption.  The new 
> context gets transferred to the old task.  This means that both 
> tasks still have a valid perf_counter_context, so no special case 
> is introduced when the old task gets scheduled in again, either on 
> this CPU or another CPU.
> 
> The equivalence of contexts is detected by keeping a pointer in 
> each cloned context pointing to the context it was cloned from. To 
> cope with the situation where a context is changed by adding or 
> removing counters after it has been cloned, we also keep a 
> generation number on each context which is incremented every time 
> a context is changed.  When a context is cloned we take a copy of 
> the parent's generation number, and two cloned contexts are 
> equivalent only if they have the same parent and the same 
> generation number.  In order that the parent context pointer 
> remains valid (and is not reused), we increment the parent 
> context's reference count for each context cloned from it.
> 
> Since we don't have individual fds for the counters in a cloned
> context, the only thing that can make two clones of a given parent
> different after they have been cloned is enabling or disabling all
> counters with prctl.  To account for this, we keep a count of the
> number of enabled counters in each context.  Two contexts must have
> the same number of enabled counters to be considered equivalent.
> 
> Here are some measurements of the context switch time as measured with
> the lat_ctx benchmark from lmbench, comparing the times obtained with
> and without this patch series:
> 
> 		        -----Unmodified-----	With this patch series
> Counters:	        none	2 HW	4H+4S	none	2 HW	4H+4S
>
> 2 processes:
> Average		3.44	6.45	11.24	3.12	3.39	3.60
> St dev		0.04	0.04	0.13	0.05	0.17	0.19
>
> 8 processes:
> Average		6.45	8.79	14.00	5.57	6.23	7.57
> St dev		1.27	1.04	0.88	1.42	1.46	1.42
> 
> 32 processes:
> Average		5.56	8.43	13.78	5.28	5.55	7.15
> St dev		0.41	0.47	0.53	0.54	0.57	0.81
> 
> The numbers are the mean and standard deviation of 20 runs of 
> lat_ctx.  The "none" columns are lat_ctx run directly without any 
> counters.  The "2 HW" columns are with lat_ctx run under perfstat, 
> counting cycles and instructions.  The "4H+4S" columns are lat_ctx 
> run under perfstat with 4 hardware counters and 4 software 
> counters (cycles, instructions, cache references, cache misses, 
> task clock, context switch, cpu migrations, and page faults).
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  include/linux/perf_counter.h |   12 ++++-
>  kernel/perf_counter.c        |  109 ++++++++++++++++++++++++++++++++++++-----
>  kernel/sched.c               |    2 +-
>  3 files changed, 107 insertions(+), 16 deletions(-)

Impressive!

I'm wondering where the sensitivity of lat_ctx on the number of 
counters comes from. I'd expect there to be constant (and very low) 
overhead. It could be measurement noise - lat_ctx is very sensitive 
on L2 layout and memory allocation patterns - those are very hard to 
eliminate and are not measured via the stddev numbers. (many of 
those effects are per bootup specific, and bootups dont randomize 
them - so there's no easy way to measure their statistical impact.)

	Ingo
