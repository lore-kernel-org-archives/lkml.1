Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbZA2SQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbZA2SQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZA2SQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:16:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:57789 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZA2SQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:16:38 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Jan 2009 10:16:31 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: Re: [patch 1/2] epoll fix own poll()
In-Reply-To: <20090129000120.da7d249d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901290956530.15448@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com> <20090129000120.da7d249d.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Andrew Morton wrote:

> >  fs/eventpoll.c |  510 +++++++++++++++++++++++++++++++++------------------------
> >  1 file changed, 304 insertions(+), 206 deletions(-)
> 
> Holy cow man, this patch is HUGE!  I don't have a clue what it does nor
> how it does it.  I'd be somewhat scared to merge it into 2.6.29.  How
> serious is this bug?

It is a 3 in a scale of 5. The reason the patch is HUGE is because the 
epoll ->poll() code now has to perform an operation similar to what was 
performing in epoll_wait(), and under the same constraints (check out for 
recursions and too long nesting chains) that were checked in the wakeups.
So instead of duplicating the code, I made the two core operations such 
that they get a function pointer for the core operation they have to 
perform. That required some code movement.



> Please use checkpatch?  The patch attempts to add a large amount of
> crap, must notably lots of lines which for some reason start with
> space-space-tab-tab-tab.  I doubt if you meant to do that (editor brain
> damage), and checkpatch's main purpose is to tell you about things
> which you didn't mean to do.

I know why. Don't ask :)


> > +{
> > +	int error, pwake = 0;
> > +	unsigned long flags;
> > +	struct epitem *epi, *nepi;
> > +	struct list_head txlist;
> > +
> > +	INIT_LIST_HEAD(&txlist);
> 
> Could use
> 
> 	LIST_HEAD(tx_list);

ACK


> > +	list_splice(&ep->rdllist, &txlist);
> > +	INIT_LIST_HEAD(&ep->rdllist);
> 
> list_splice_init()?

ACK



> Some places the code uses ep_is_linked(&ep->rdllist), other places it
> uses open-coded list_empty().
> 
> ep_is_linked() is a fairly poor helper, really - it could be passed any
> list_head at all.  I think that it would be better to do
> 
> static inline int ep_is_linked(struct epitem *ep)
> {
> 	return !list_empty(&ep->rdllist);
> }
> 
> and then use this consistently.

Seems they're used the same, but they aren't. There are two different 
entities, even though characterized by the same structure. One are the 
lists head itself (like ep->rdllist), that is a list, checked with list_empty, 
the others are the elements chained to the list (like epi->rdllink), 
checked with the helper. 



> > +		else
> > +			/*
> > +			 * Item has been dropped into the ready list by the poll
> > +			 * callback, but it's not actually ready, as far as
> > +			 * caller requested events goes. We can remove it here.
> > +			 */
> > +			list_del_init(&epi->rdllink);
> 
> Please use braces around the comment and code when doing this. 
> Otherwise readers can lose track of the fact that we're in a
> single-statement leg of an `if' here.

ACK


> > -	} else {
> > +	} else
> >  		/* We have to signal that an error occurred */
> >  		epi->nwait = -1;
> > -	}
> 
> Please put the braces back?  The `if' clause has them, and most people
> prefer that the `else' clause have them too.  Plus they nicely enclose
> the comment as well, as described above.

ACK


You always confuse me with your comments. Before you comment, then you 
merge w/out giving me time to change.
Would you like the updated patches?



- Davide


