Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZBILtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZBILtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbZBILtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:49:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34719 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZBILtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:49:04 -0500
Date: Mon, 9 Feb 2009 12:48:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Make software counters work as per-cpu
	counters
Message-ID: <20090209114852.GF18757@elte.hu>
References: <18832.5815.706605.434454@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18832.5815.706605.434454@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

> Impact: kernel crash fix
> 
> Yanmin Zhang reported that using a PERF_COUNT_TASK_CLOCK software
> counter as a per-cpu counter would reliably crash the system, because
> it calls __task_delta_exec with a null pointer.  The page fault,
> context switch and cpu migration counters also won't function
> correctly as per-cpu counters since they reference the current task.
> 
> This fixes the problem by redirecting the task_clock counter to the
> cpu_clock counter when used as a per-cpu counter, and by implementing
> per-cpu page fault, context switch and cpu migration counters.
> 
> Along the way, this:
> 
> - Initializes counter->ctx earlier, in perf_counter_alloc, so that
>   sw_perf_counter_init can use it
> - Adds code to kernel/sched.c to count task migrations into each
>   cpu, in rq->nr_migrations_in
> - Exports the per-cpu context switch and task migration counts
>   via new functions added to kernel/sched.c
> - Makes sure that if sw_perf_counter_init fails, we don't try to
>   initialize the counter as a hardware counter.  Since the user has
>   passed a negative, non-raw event type, they clearly don't intend
>   for it to be interpreted as a hardware event.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Very nice, thanks Paul!

> I'm a little concerned about the use of u64 for the existing
> rq->nr_switches and the new rq->nr_migrations_in.  On 32-bit machines
> this will get updated in two halves, so there is a very small but
> non-zero probability that reading it will give a bogus value.  It's
> not clear to me what the best way to fix it is, since not all 32-bit
> platforms have atomic64_t.  Maybe make nr_switches and
> nr_migrations_in unsigned long, or atomic_t?

It used to be 'just stats' so we dont really mind. But now that we
expose it in a bit more systematic way i agree that it should be
fixed. Updating to 'unsigned long' sounds good to me.

> I have some sort of git problem with my perfcounters.git repository.
> I'll let you know when I have that sorted out.

ok - i've applied your patch from email to allow Yanmin to test tip:master.

	Ingo
