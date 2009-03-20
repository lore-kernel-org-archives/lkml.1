Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZCTKyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZCTKyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZCTKyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:54:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbZCTKyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:54:23 -0400
Date: Fri, 20 Mar 2009 11:53:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: peterz@infradead.org, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [patch] don't preempt not TASK_RUNNING tasks
Message-ID: <20090320105306.GG6256@elte.hu>
References: <E1LkbGe-00039U-Hc@pomaz-ex.szeredi.hu> <1237543392.24626.49.camel@twins> <E1Lkc6U-0003II-W1@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Lkc6U-0003II-W1@pomaz-ex.szeredi.hu>
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


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Fri, 20 Mar 2009, Peter Zijlstra wrote:
> > On Fri, 2009-03-20 at 10:43 +0100, Miklos Szeredi wrote:
> > > Ingo,
> > > 
> > > I tested this one, and I think it makes sense in any case as an
> > > optimization.  It should also be good for -stable kernels.
> > > 
> > > Does it look OK?
> > 
> > The idea is good, but there is a risk of preemption latencies here. Some
> > code paths aren't real quick between setting ->state != TASK_RUNNING and
> > calling schedule.
> > 
> > [ Both quick: as in O(1) and few instructions ]
> > 
> > So if we're going to do this, we'd need to audit all such code paths --
> > and there be lots.
> 
> Oh, yes.
> 
> In a random sample the most common pattern is something like this:
> 
> 	spin_lock(&some_lock);
> 	/* do something */
> 	set_task_state(TASK_SOMESLEEP);
> 	/* do something more */
> 	spin_unlock(&some_lock);
> 	schedule();
> 	...
> 
> Which should only positively be impacted by the change.  But I can 
> imagine rare cases where it's more complex.

I'd suggest spin_unlock_no_resched() and task_unlock_no_resched() 
instead of open-coding preempt-disable sequences.

> > The first line of attack for this problem is making 
> > wait_task_inactive() sucks less, which shouldn't be too hard, 
> > that unconditional 1 jiffy sleep is simply retarded.
> 
> I completely agree.  However, I'd like to have a non-invasive 
> solution that can go into current and stable kernels so UML users 
> don't need to suffer any more.

Agreed. task_unlock_no_resched() should do that i think.

	Ingo
