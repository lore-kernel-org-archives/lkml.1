Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbZKFHS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbZKFHS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZKFHS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:18:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59668 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZKFHS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:18:27 -0500
Date: Fri, 6 Nov 2009 08:17:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
Message-ID: <20091106071711.GA20946@elte.hu>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF3B9BD.9050300@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: lockdep: avoid false positives about irq-safety
> > 
> > Commit 403a91b1 ("percpu: allow pcpu_alloc() to be called
> > with IRQs off") introduced this warning:
> > 
> > 	=========================================================
> > 	[ INFO: possible irq lock inversion dependency detected ]
> > 	2.6.32-rc5-tip-04815-g12f0f93-dirty #745
> > 	---------------------------------------------------------
> > 	hub 1-3:1.0: state 7 ports 2 chg 0000 evt 0004
> > 	ksoftirqd/65/199 just changed the state of lock:
> > 	 (pcpu_lock){..-...}, at: [<ffffffff81130e04>] free_percpu+0x38/0x104
> > 	but this lock took another, SOFTIRQ-unsafe lock in the past:
> > 	 (vmap_area_lock){+.+...}
> > 
> > 	and interrupts could create inverse lock ordering between them.
> > 
> > This warning is bogus -- sched_init() is being called very early with IRQs
> > disabled, and the irqsave/restore code paths in pcpu_alloc() are only for early
> > init. The path can never be called from irq context once the early init
> > finishes. Rationale for this is explained in changelog of the commit mentioned
> > above.
> > 
> > This problem can be encountered generally in any other early code running
> > with IRQs off and using irqsave/irqrestore.
> > 
> > Reported-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Looks good to me.  Ingo, what do you think?

Ugh, this explanation is _BOGUS_. As i said, taking a lock with irqs 
disabled does _NOT_ mark a lock as 'irq safe' - if it did, we'd have 
false positives left and right.

Read the lockdep message please, consider all the backtraces it prints, 
it says something different.

	Ingo
