Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYEaH5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYEaH5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 03:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYEaH5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 03:57:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52589 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751375AbYEaH5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 03:57:21 -0400
Date: Sat, 31 May 2008 00:57:18 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jes Sorensen <jes@sgi.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Roland Dreier <rdreier@cisco.com>, benh@kernel.crashing.org,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080531075718.GD108600@sgi.com>
References: <1211852026.3286.36.camel@pasglop> <1212073289.3428.30.camel@localhost.localdomain> <483FCA94.1060506@sgi.com> <200805301021.00883.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805301021.00883.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 10:21:00AM -0700, Jesse Barnes wrote:
> On Friday, May 30, 2008 2:36 am Jes Sorensen wrote:
> > James Bottomley wrote:
> > >> The only way to guarantee ordering in the above setup, is to either
> > >> make writel() fully ordered or adding the mmiowb()'s inbetween the two
> > >> writel's. On Altix you have to go and read from the PCI brige to
> > >> ensure all writes to it have been flushed, which is also what mmiowb()
> > >> is doing. If writel() was to guarantee this ordering, it would make
> > >> every writel() call extremely expensive :-(
> > >
> > > So if a read from the bridge achieves the same effect, can't we just put
> > > one after the writes within the spinlock (an unrelaxed one).  That way

A relaxed readX would be sufficient.  It's the next lowest cost way (after
mmiowb) of ensuring write ordering between CPUs.  Regular readX is the
most expensive method (well, we could probably come up with something worse,
but we'd have to work at it  :).

> > > this whole sequence will look like a well understood PCI posting flush
> > > rather than have to muck around with little understood (at least by most
> > > driver writers) io barriers?
> >
> > Hmmm,
> >
> > I think mmiowb() does some sort of status read from the bridge, I am not
> > sure if it's enough to just do a regular readl().
> >
> > I'm adding Jeremy to the list, he should know for sure.
> 
> I think a read from the target host bridge is enough.  What mmiowb() does 
> though is to read a *local* host bridge register, which contains a count of 
> the number of PIO ops still "in flight" on their way to their target bridge.  
> When it reaches 0, all PIOs have arrived at the target host bridge (they 
> still may be bufferd), so ordering is guaranteed.


Note that is the main advantage over a read.  There is no round trip across
the NUMA fabric.

jeremy
