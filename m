Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYFAOTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYFAOTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYFAORY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:17:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4389 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752456AbYFAORD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:17:03 -0400
Date: Sat, 31 May 2008 10:14:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jes Sorensen <jes@sgi.com>
Cc: benh@kernel.crashing.org, Roland Dreier <rdreier@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, Jeremy Higdon <jeremy@sgi.com>
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080531081450.GI5405@ucw.cz>
References: <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net> <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop> <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop> <adaiqwzsa83.fsf@cisco.com> <yq0iqwxrwuh.fsf@jaguar.mkp.net> <1212097223.8888.55.camel@pasglop> <483FCD5C.208@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483FCD5C.208@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>The only way to guarantee ordering in the above setup, 
> >>is to either
> >>make writel() fully ordered or adding the mmiowb()'s 
> >>inbetween the two
> >>writel's. On Altix you have to go and read from the 
> >>PCI brige to
> >>ensure all writes to it have been flushed, which is 
> >>also what mmiowb()
> >>is doing. If writel() was to guarantee this ordering, 
> >>it would make
> >>every writel() call extremely expensive :-(
> >
> >Interesting. I've always been taught by ia64 people 
> >that mmiowb() was
> >intended to be used solely between writel() and 
> >spin_unlock().
> >
> >I think in the above case, you really should make 
> >writel() ordered.
> >Anything else is asking for trouble, for the exact same 
> >reasons that I
> >made it fully ordered on powerpc at least vs. previous 
> >stores. I only
> >kept it relaxed vs. subsequent cacheable stores (ie, 
> >spin_unlock), for
> >which I use the trick mentioned before.
> 
> Hmmm I hope I didn't mess up the description of this and 
> added to the
> confusion.
> 
> The net result of that would be to kill performance 
> completely, I really
> don't like that idea.... Having each writel() go out and 
> poll the PCI
> bridge is going to make every driver used on Altix slow 
> as a dog.
> 
> In addition it's still not going to solve the problem 
> for userland
> mapped stuff such as infinibug.
> 
> >Yes, this has some cost (can be fairly significant on 
> >powerpc too) but
> >I think it's a very basic assumption from drivers that 
> >consecutive
> >writel's, especially issued by the same CPU, will get 
> >to the device
> >in order.
> 
> In this case the cost is more than just significant, 
> it's pretty
> crippling.
> 
> >If this is a performance problem, then provide relaxed 
> >variants and
> >use them in selected drivers.
> 
> We'd have to make major changes to drivers like e1000, 
> tg3, mptsas, the
> qla2/3/4xxx and a bunch of others to get performance 
> back. I really
> think the code maintenance issue there will get far 
> worse than what we
> have today :(

Still better than changing semantics of writel for _all_ drivers.

If you are really sure driver does not depend on writel order, it is
just a sed/// command, so I don't see any big code maintenance
issues...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
