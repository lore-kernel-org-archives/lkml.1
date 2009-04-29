Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZD2NQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZD2NQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbZD2NJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:09:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758468AbZD2NJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:09:27 -0400
Date: Wed, 29 Apr 2009 15:09:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: powerpc: allow use of limited-function
	counters
Message-ID: <20090429130915.GA23563@elte.hu>
References: <18936.19035.163066.892208@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18936.19035.163066.892208@cargo.ozlabs.ibm.com>
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

> POWER5+ and POWER6 have two hardware counters with limited 
> functionality: PMC5 counts instructions completed in run state and 
> PMC6 counts cycles in run state.  (Run state is the state when a 
> hardware RUN bit is 1; the idle task clears RUN while waiting for 
> work to do and sets it when there is work to do.)
> 
> These counters can't be written to by the kernel, can't generate 
> interrupts, and don't obey the freeze conditions.  That means we 
> can only use them for per-task counters (where we know we'll 
> always be in run state; we can't put a per-task counter on an idle 
> task), and only if we don't want interrupts and we do want to 
> count in all processor modes.
> 
> Obviously some counters can't go on a limited hardware counter, 
> but there are also situations where we can only put a counter on a 
> limited hardware counter - if there are already counters on that 
> exclude some processor modes and we want to put on a per-task 
> cycle or instruction counter that doesn't exclude any processor 
> mode, it could go on if it can use a limited hardware counter.
> 
> To keep track of these constraints, this adds a flags argument to 
> the processor-specific get_alternatives() functions, with three 
> bits defined: one to say that we can accept alternative event 
> codes that go on limited counters, one to say we only want 
> alternatives on limited counters, and one to say that this is a 
> per-task counter and therefore events that are gated by run state 
> are equivalent to those that aren't (e.g. a "cycles" event is 
> equivalent to a "cycles in run state" event).  These flags are 
> computed for each counter and stored in the 
> counter->hw.counter_base field (slightly wonky name for what it 
> does, but it was an existing unused field).
> 
> Since the limited counters don't freeze when we freeze the other 
> counters, we need some special handling to avoid getting skew 
> between things counted on the limited counters and those counted 
> on normal counters.  To minimize this skew, if we are using any 
> limited counters, we read PMC5 and PMC6 immediately after setting 
> and clearing the freeze bit.  This is done in a single asm in the 
> new write_mmcr0() function.
> 
> The code here is specific to PMC5 and PMC6 being the limited 
> hardware counters.  Being more general (e.g. having a bitmap of 
> limited hardware counter numbers) would have meant more complex 
> code to read the limited counters when freezing and unfreezing the 
> normal counters, with conditional branches, which would have 
> increased the skew.  Since it isn't necessary for the code to be 
> more general at this stage, it isn't.
> 
> This also extends the back-ends for POWER5+ and POWER6 to be able 
> to handle up to 6 counters rather than the 4 they previously 
> handled.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  arch/powerpc/include/asm/perf_counter.h |   13 ++-
>  arch/powerpc/kernel/perf_counter.c      |  297 +++++++++++++++++++++++++++----
>  arch/powerpc/kernel/power4-pmu.c        |    3 +-
>  arch/powerpc/kernel/power5+-pmu.c       |  117 ++++++++++--
>  arch/powerpc/kernel/power5-pmu.c        |    3 +-
>  arch/powerpc/kernel/power6-pmu.c        |  119 +++++++++++--
>  arch/powerpc/kernel/ppc970-pmu.c        |    3 +-
>  7 files changed, 479 insertions(+), 76 deletions(-)

Applied, thanks Paul!

[ Note, i saw some fuzz in those files. It applied fine but maybe 
  you have some local changes in them that are not in 
  tip:perfcounters/core yet? You might want to double check that. ]

	Ingo
