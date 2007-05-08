Return-Path: <linux-kernel-owner+w=401wt.eu-S967771AbXEHNuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967771AbXEHNuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967414AbXEHNub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:50:31 -0400
Received: from mx2.go2.pl ([193.17.41.42]:52071 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967407AbXEHNub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:50:31 -0400
Date: Tue, 8 May 2007 15:56:49 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070508135648.GG1772@ff.dom.local>
References: <20070503204226.GA212@tv-sign.ru> <20070508071544.GA1772@ff.dom.local> <20070508123102.GB968@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508123102.GB968@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:31:02PM +0400, Oleg Nesterov wrote:
> On 05/08, Jarek Poplawski wrote:
> > 
> > On Fri, May 04, 2007 at 12:42:26AM +0400, Oleg Nesterov wrote:
> > ...
> > > +static int try_to_grab_pending(struct work_struct *work)
> > > +{
> > > +	struct cpu_workqueue_struct *cwq;
> > > +	int ret = 0;
> > > +
> > > +	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
> > > +		return 1;
> > 
> > Previous version used this check to run del_timer, and I think, it
> > was good idea. So, maybe, try something like this:
> > 
> > - run once del_timer before the loop (in cancel_rearming_ only),
> 
> hmm, cancel_rearming_ does del_timer() before try_to_grab_pending().
> 
> > - add a parmeter to try_to_grab_pending, e.g. "rearming",
> > - add here something like this:
> > 
> > 	else if (rearming && del_timer(&work->timer)
> > 		return 1;
> 
> I thought about adding such a parameter, and I don't like this. This is
> a matter of taste, of course, but _imho_ this uglifies the code.
> 
> In any case, unless we do completely different patch, the sequence should be
> 
> 	del_timer()	- a pending timer is the most common case
> 
> 	test_and_set_bit(WORK_STRUCT_PENDING) - the work is idle
> 
> 	try-to-steal-the-queued-work
> 
> This is what we are doing now.

I simply don't like to call del_timer(), where not needed, but maybe
it's not so expensive and we can afford it... 

> 
> > > +
> > > +	/*
> > > +	 * The queueing is in progress, or it is already queued. Try to
> > > +	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
> > > +	 */
> > > +
> > > +	cwq = get_wq_data(work);
> > > +	if (!cwq)
> > > +		return ret;
> > 
> > Probably you meant:
> > 		return 1;
> 
> No, we should return 0. This can happen if the queueing of the freshly-
> initialized @dwork is in progress.
> 
> NOTE: right now try_to_grab_pending() is called from cancel_xxx() only, so
> this can't happen (it would be meaningless to do cancel_xxx if somebody else
> can queue this work or start the timer), but I'd like try_to_grab_pending()
> to be as generic as possible.
> 
> So, we should either return 0, or add BUG_ON(!cwq).

...And you prefer endless loop. Seems brave!

...
> Yes, please, and thank you very much for review!

You welcome & my pleasure,

Bye,
Jarek P.
