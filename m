Return-Path: <linux-kernel-owner+w=401wt.eu-S968064AbXEHOFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968064AbXEHOFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967870AbXEHOFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:05:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:42221 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934621AbXEHOF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:05:28 -0400
Date: Tue, 8 May 2007 18:05:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070508140517.GA1105@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <20070508071544.GA1772@ff.dom.local> <20070508123102.GB968@tv-sign.ru> <20070508135648.GG1772@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508135648.GG1772@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Jarek Poplawski wrote:
>
> On Tue, May 08, 2007 at 04:31:02PM +0400, Oleg Nesterov wrote:
> > 
> > I thought about adding such a parameter, and I don't like this. This is
> > a matter of taste, of course, but _imho_ this uglifies the code.
> > 
> > In any case, unless we do completely different patch, the sequence should be
> > 
> > 	del_timer()	- a pending timer is the most common case
> > 
> > 	test_and_set_bit(WORK_STRUCT_PENDING) - the work is idle
> > 
> > 	try-to-steal-the-queued-work
> > 
> > This is what we are doing now.
> 
> I simply don't like to call del_timer(), where not needed, but maybe
> it's not so expensive and we can afford it... 

But this is the most common case, that was my point.

Look, we can add

	if (!get_wq_data(work))
		/* it was never queued */
		return;

at the very start of cancel_xxx() functions. This will optimize out
del_timer + try_to_grab_pending() _sometimes_. Should we do this?
I don't think so. I think it is better to save a couple of bytes
from i-cache, but not to try to optimize the unlikely case.

> > 
> > > > +
> > > > +	/*
> > > > +	 * The queueing is in progress, or it is already queued. Try to
> > > > +	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
> > > > +	 */
> > > > +
> > > > +	cwq = get_wq_data(work);
> > > > +	if (!cwq)
> > > > +		return ret;
> > > 
> > > Probably you meant:
> > > 		return 1;
> > 
> > No, we should return 0. This can happen if the queueing of the freshly-
> > initialized @dwork is in progress.
> > 
> > NOTE: right now try_to_grab_pending() is called from cancel_xxx() only, so
> > this can't happen (it would be meaningless to do cancel_xxx if somebody else
> > can queue this work or start the timer), but I'd like try_to_grab_pending()
> > to be as generic as possible.
> > 
> > So, we should either return 0, or add BUG_ON(!cwq).
> 
> ...And you prefer endless loop. Seems brave!

No, no, the loop won't be endless. Why do you think so? We spin until the timer
is started, or until the work is queued.

Oleg.

