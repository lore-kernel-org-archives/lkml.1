Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYK0Jaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYK0Jaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYK0JaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:30:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49380 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbYK0JaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:30:10 -0500
Date: Thu, 27 Nov 2008 10:29:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] sched: prevent divide by zero error in
	cpu_avg_load_per_task
Message-ID: <20081127092941.GA630@elte.hu>
References: <20081127020423.460116740@goodmis.org> <20081127020554.533035163@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127020554.533035163@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Impact: fix to divide by zero
> 
> While testing the branch profiler, I hit this crash:
> 
> divide error: 0000 [#1] PREEMPT SMP
> [...]
> Call Trace:
>  <IRQ> <0> [<ffffffff8024fd43>] find_busiest_group+0x3e5/0xcaa
>  [<ffffffff8025da75>] rebalance_domains+0x2da/0xa21

> The code for cpu_avg_load_per_task has:
> 
> 	if (rq->nr_running)
> 		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
> 
> The runqueue lock is not held here, and there is nothing that 
> prevents the rq->nr_running from going to zero after it passes the 
> if condition.
> 
> The branch profiler simply made the race window bigger.
> 
> This patch saves off the rq->nr_running to a local variable and uses 
> that for both the condition and the division.

good catch! Applied to tip/sched/urgent, thanks Steve!

the rebalancer scans remote runqueues without holding the runqueue 
lock for performance reasons, so nr_running indeed has to be loaded 
into a local variable here.

I think it could hit anywhere upstream as well, even without the 
branch tracer: depends on the register pressure and GCC's choices for 
reloading that register. If say FRAME_POINTER is enabled and we are 
running with some more agressive optimization or just an older/suckier 
GCC that does a spurious reload, then this might happen too.

it's not a classic race, it's an SMP bug that will either trigger or 
not trigger at all, depending on compiler behavior.

	Ingo
