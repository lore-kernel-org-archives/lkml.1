Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZJAStG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZJAStG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZJAStF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:49:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51753 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbZJAStF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:49:05 -0400
Date: Thu, 1 Oct 2009 20:48:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
Message-ID: <20091001184824.GA21357@elte.hu>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 1 Oct 2009, Tejun Heo wrote:
> >
> > Implement workqueue scheduler class.  Workqueue sched_class inherits 
> > fair sched_class and behaves exactly the same as sched_class except 
> > that it has two callback functions which get called when a task is 
> > put to sleep and wakes up and doesn't allow switching to different 
> > scheduler class.
> 
> So this looks odd to me.
> 
> I agree completely with the callback functions, but what I don't agree 
> with is that this is somehow workqueue-related. I bet that others 
> could use this, and in fact, I suspect that it should not be tied to 
> the scheduler class at all, but to the _thread_.
> 
> Just as an example, I could imagine that we would do lock_kernel() 
> releasing the kernel lock on scheduling (and re-taking it on wakeup) 
> as a callback. Or async IO handling - both done independently of any 
> "workqueue" logic.
> 
> So tying this to the scheduler class seems a bit odd. But maybe I'm 
> missing something?

We could do what Avi suggested: not use scheduler classes at all for 
this (that brings in other limitations like lack of p->policy freedom), 
but use the existing preempt-notifications callbacks.

They are per task - we would simply make preempt notifiers 
unconditional, i.e. remove CONFIG_PREEMPT_NOTIFIERS and make it all 
unconditional scheduler logic.

( Sidenote: we could even unify that logic with the perf event 
  sched-in/sched-out logic which is per task in a similar fashion and 
  which can have callback properties as well. That would mean a single,
  well-defined callback facility for scheduler events. )

	Ingo
