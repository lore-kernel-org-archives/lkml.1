Return-Path: <linux-kernel-owner+w=401wt.eu-S968147AbXEHO0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968147AbXEHO0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967710AbXEHO0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:26:07 -0400
Received: from mx12.go2.pl ([193.17.41.142]:51457 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967562AbXEHO0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:26:05 -0400
Date: Tue, 8 May 2007 16:32:17 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070508143217.GA1011@ff.dom.local>
References: <20070503204226.GA212@tv-sign.ru> <20070508071544.GA1772@ff.dom.local> <20070508123102.GB968@tv-sign.ru> <20070508135648.GG1772@ff.dom.local> <20070508140517.GA1105@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508140517.GA1105@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 06:05:17PM +0400, Oleg Nesterov wrote:
> On 05/08, Jarek Poplawski wrote:
> >
> > On Tue, May 08, 2007 at 04:31:02PM +0400, Oleg Nesterov wrote:
> > > 
> > > I thought about adding such a parameter, and I don't like this. This is
> > > a matter of taste, of course, but _imho_ this uglifies the code.
> > > 
> > > In any case, unless we do completely different patch, the sequence should be
> > > 
> > > 	del_timer()	- a pending timer is the most common case
> > > 
> > > 	test_and_set_bit(WORK_STRUCT_PENDING) - the work is idle
> > > 
> > > 	try-to-steal-the-queued-work
> > > 
> > > This is what we are doing now.
> > 
> > I simply don't like to call del_timer(), where not needed, but maybe
> > it's not so expensive and we can afford it... 
> 
> But this is the most common case, that was my point.

And I agree it should start... 

> 
> Look, we can add
> 
> 	if (!get_wq_data(work))
> 		/* it was never queued */
> 		return;
> 
> at the very start of cancel_xxx() functions. This will optimize out
> del_timer + try_to_grab_pending() _sometimes_. Should we do this?
> I don't think so. I think it is better to save a couple of bytes
> from i-cache, but not to try to optimize the unlikely case.

But the most of our test is already done in test_and_set_bit.
I think it's more about taste, so let's forget...

> > > So, we should either return 0, or add BUG_ON(!cwq).
> > 
> > ...And you prefer endless loop. Seems brave!
> 
> No, no, the loop won't be endless. Why do you think so? We spin until the timer
> is started, or until the work is queued.

Probably you are right - I was afraid about some inactive
work with no timer to come.

So, I think this all looks fine, and maybe one more needless ack
won't do any harm here:

Acked-by: Jarek Poplawski <jarkao2@o2.pl>
