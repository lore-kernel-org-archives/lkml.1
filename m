Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYFCIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYFCIQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbYFCIQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:16:01 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39652 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754162AbYFCIP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:15:56 -0400
Date: Tue, 3 Jun 2008 01:15:52 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jes Sorensen <jes@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       benh@kernel.crashing.org, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080603081552.GC117059@sgi.com>
References: <1211852026.3286.36.camel@pasglop> <20080531075242.GC108600@sgi.com> <4843C3D7.7000609@sgi.com> <200806031433.12460.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806031433.12460.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 02:33:11PM +1000, Nick Piggin wrote:
> On Monday 02 June 2008 19:56, Jes Sorensen wrote:
> > Jeremy Higdon wrote:
> > > We don't actually have that problem on the Altix.  All writes issued
> > > by CPU X will be ordered with respect to each other.  But writes by
> > > CPU X and CPU Y will not be, unless an mmiowb() is done by the
> > > original CPU before the second CPU writes.  I.e.
> > >
> > > 	CPU X	writel
> > > 	CPU X	writel
> > > 	CPU X	mmiowb
> > >
> > > 	CPU Y	writel
> > > 	...
> > >
> > > Note that this implies some sort of locking.  Also note that if in
> > > the above, CPU Y did the mmiowb, that would not work.
> >
> > Hmmm,
> >
> > Then it's less bad than I thought - my apologies for the confusion.
> >
> > Would we be able to use Ben's trick of setting a per cpu flag in
> > writel() then and checking that in spin unlock issuing the mmiowb()
> > there if needed?
> 
> Yes you could, but your writels would still not be strongly ordered
> within (or outside) spinlock regions, which is what Linus wants (and
> I kind of agree with).

Yes they would be.  Writes from the same CPU are always ordered.  Writes
from different CPUs are not, but that's only a concern if you protect
writing via some sort of lock.  If the lock release forces a barrier,
that should take care of the problem.

jeremy
