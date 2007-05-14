Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXENXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXENXXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXENXXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:23:12 -0400
Received: from holomorphy.com ([66.93.40.71]:50638 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXENXXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:23:12 -0400
Date: Mon, 14 May 2007 16:23:52 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514232352.GX19966@holomorphy.com>
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com> <20070514115049.GA28721@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514115049.GA28721@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 12:31:20PM +0200, Ingo Molnar wrote:
>>> please clarify - exactly what is a mistake? Thanks,

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> The variability in ->fair_clock advancement rate was the mistake, at 
>> least according to my way of thinking. [...]

On Mon, May 14, 2007 at 01:50:49PM +0200, Ingo Molnar wrote:
> you are quite wrong. Lets consider the following example:
> we have 10 tasks running (all at nice 0). The current task spends 20 
> msecs on the CPU and a new task is picked. How much CPU time did that 
> waiting task get entitled to during its 20 msecs wait? If fair_clock was 
> constant as you suggest then we'd give it 20 msecs - but its true 'fair 
> expectation' of CPU time was only 20/10 == 2 msecs!

The amount of time to which the task was entitled remains the same,
delta_exec*curr->load_weight/get_rq_load(rq). Where the timekeeping
goes wrong is when trying to divide out changes in the virtual time.

Where I'm actually wrong is that using wall clock time doesn't resolve
it because there still isn't an integral to divide out. The running
average is a closer approximation. Possibly better would be to update
an explicit integral at the time of changes to ->raw_weighted_load and
to store a starting value of the integral for use as a subtrahend to
form a difference to use in lieu of computations now used for delta_fair.
It's a step function so it's not computationally intensive. What's now
used is somewhat more ad hoc.


On Mon, May 14, 2007 at 01:50:49PM +0200, Ingo Molnar wrote:
> So a 'constant' fair_clock would turn the whole equilibrium upside down 
> (it would inflate p->wait_runtime values and the global sum would not be 
> roughly constant anymore but would run up very fast), especially during 
> fluctuating loads.
> the fair_clock is the fundamental expression of "fair CPU timeline", and 
> task's expected runtime is always measured by that, not by the real 
> clock. The only time when we measure the true time is when a _single_ 
> task runs on the CPU - but in that case the task truly spent a small 
> amount of time on the CPU, exclusively. See the exec_time calculations 
> in kernel/sched_fair.c.

My thought here revolves around the divisor of p->wait_runtime.

The interest in the global sum is interesting. It suggests an \ell^1
(sum of absolute values) aggregate lag metric but it appears you're
looking at them as signed in this sum. The field is at least signed.
More typical is attempting to minimize \ell^\infty (maximum absolute
value) aggregate lag metrics.

I'm suspicious of this global sum of signed lags. I would expect it
to deviate from this constraint significantly due to arriving and
departing tasks. The vector of lags is merely restricted to lie near a
plane i.e. |\sum_t lag(t)| < K as opposed to within some distance from
the origin in some \ell^p norm i.e. \sum_t |lag(t)|^p < K with the
usual limiting convention for p = \infty. The latter is the requirement
for constant lag bounds.

Of course, this sum treatment will largely work out anyway given that
tasks with larger positive lags are favored and larger negative lags
penalized.


-- wli
