Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbXEKPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbXEKPsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbXEKPsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:48:09 -0400
Received: from mail.screens.ru ([213.234.233.54]:52370 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929AbXEKPsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:48:08 -0400
Date: Fri, 11 May 2007 18:53:45 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070511145345.GA240@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46448965.7070500@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Tejun Heo wrote:
>
> Oleg Nesterov wrote:
> >
> > However, I agree, this smp_wmb() in insert_work() should die. We can
> > introduce "smp_mb__before_spinlock()" (no-op on x86 at least) to kill it.
> 
> Yeah, right, we allow cwq pointer to change without holding the lock.
> Although I still think that is where we should fix the problem.  Taking
> down CPU is a cold cold path.  We can afford a lot of overhead there.
> IMHO, if we can do that, it would be far better than memory barrier
> dance which tends to be difficult to understand and thus prove/maintain
> correctness.  I'll think about it more.

Yes I hate this barrier too. That is why changelog explicitly mentions it.

With some trivial code modifications we can move set_wq_data() from insert_work()
to __queue_work(), then

	void set_wq_data(work, cwq)
	{
		struct cpu_workqueue_struct *old = get_wq_data(work);

		if (likely(cwq == old))
			return;

		if (old)
			spin_lock(old->lock);

		atomic_long_set(&work->data, ...);

		if (old)
			spin_lock(old->lock);
	}

I can't say I like this very much, though. I'd prefer use smp_mb__before_spinlock().
Probably we can do something else.

But first I'd like to kill cwq_should_stop(). (Gautham, Srivatsa, you were
right, but I was blind, deaf, and stupid).

Oleg.

