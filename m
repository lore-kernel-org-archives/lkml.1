Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXENNQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXENNQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXENNQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:16:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51248 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbXENNQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:16:02 -0400
Date: Mon, 14 May 2007 15:15:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: efault@gmx.de, tingy@cs.umass.edu, wli@holomorphy.com,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514131552.GA13928@elte.hu>
References: <20070514083358.GA29775@in.ibm.com> <20070514111051.GB23766@elte.hu> <20070514130412.GA6103@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514130412.GA6103@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> On Mon, May 14, 2007 at 01:10:51PM +0200, Ingo Molnar wrote:
> > but let me give you some more CFS design background:
> 
> Thanks for this excellent explanation. Things are much clearer now to
> me. I just want to clarify one thing below:
> 
> > > 2. Preemption granularity - sysctl_sched_granularity
> 
> [snip]
> 
> > This granularity value does not depend on the number of tasks running. 
> 
> Hmm ..so does sysctl_sched_granularity represents granularity in 
> real/wall-clock time scale then? AFAICS that doesnt seem to be the 
> case.

there's only this small detail i mentioned:

> > ( small detail: the granularity value is currently dependent on the
> >   nice level, making it easier for higher-prio tasks to preempt 
> >   lower-prio tasks. )

> __check_preempt_curr_fair() compares for the distance between the two 
> task's (current and next-to-be-run task) fair_key values for deciding 
> preemption point.
> 
> Let's say that to begin with, at real time t0, both current task Tc 
> and next task Tn's fair_key values are same, at value K. Tc will keep 
> running until its fair_key value reaches atleast K + 2000000. The 
> *real/wall-clock* time taken for Tc's fair_key value to reach K + 
> 2000000 - is surely dependent on N, the number of tasks on the queue 
> (more the load, more slowly the fair clock advances)?

well, it's somewhere in the [ granularity .. granularity*2 ] wall-clock 
scale. Basically the slowest way it can reach it is 'half speed' (two 
tasks running), the slowest way is 'near full speed' (lots of tasks 
running).

> This is what I meant by my earlier remark: "If there a million cpu 
> hungry tasks, then the (real/wall-clock) time taken to switch between 
> two tasks is more compared to the case where just two cpu hungry tasks 
> are running".

the current task is recalculated at scheduler tick time and put into the 
tree at its new position. At a million tasks the fair-clock will advance 
little (or not at all - which at these load levels is our smallest 
problem anyway) so during a scheduling tick in kernel/sched_fair.c 
update_curr() we will have a 'delta_mine' and 'delta_fair' of near zero 
and a 'delta_exec' of ~1 million, so curr->wait_runtime will be 
decreased at 'full speed': delta_exec-delta_mine, by almost a full tick. 
So preemption will occur every sched_granularity (rounded up to the next 
tick) points in time, in wall-clock time.

with 2 tasks running delta_exec-delta_mine is 0.5 million, so preemption 
will occur in 2*sched_granularity (rounded up to the next timer tick) 
wall-clock time.

	Ingo
