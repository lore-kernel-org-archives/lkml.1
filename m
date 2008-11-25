Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYKYJTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYKYJTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYKYJSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:18:49 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55108 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYKYJSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:18:48 -0500
Date: Tue, 25 Nov 2008 10:16:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Tejun Heo <teheo@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com
Subject: Re: about TRIM/DISCARD support and barriers
Message-ID: <20081125091649.GT26308@kernel.dk>
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de> <20081123123514.GI5707@parisc-linux.org> <1227447584.4901.405.camel@macbook.infradead.org> <1227480776.25499.3.camel@localhost.localdomain> <1227517430.26957.20.camel@macbook.infradead.org> <1227552171.25499.30.camel@localhost.localdomain> <1227552765.25385.129.camel@macbook.infradead.org> <20081124185747.GN26308@kernel.dk> <1227553703.25499.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227553703.25499.40.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24 2008, James Bottomley wrote:
> On Mon, 2008-11-24 at 19:57 +0100, Jens Axboe wrote:
> > On Mon, Nov 24 2008, David Woodhouse wrote:
> > > On Mon, 2008-11-24 at 13:42 -0500, James Bottomley wrote:
> > > > On Mon, 2008-11-24 at 09:03 +0000, David Woodhouse wrote:
> > > > > On Mon, 2008-11-24 at 07:52 +0900, James Bottomley wrote:
> > > > > > On Sun, 2008-11-23 at 13:39 +0000, David Woodhouse wrote:
> > > > > > > > We don't attempt to put non-contiguous ranges into a single TRIM yet.
> > > > > > > 
> > > > > > > We don't even merge contiguous ranges -- I still need to fix the
> > > > > > > elevators to stop writes crossing writes,
> > > > > > 
> > > > > > I don't think we want to do that ... it's legal if the write isn't a
> > > > > > barrier and it will inhibit merging.  That may be just fine for a SSD,
> > > > > > but it's not for spinning media since they get better performance out of
> > > > > > merged writes.
> > > > > 
> > > > > No, I just mean writes _to the same sector_. At the moment, we happily
> > > > > let those cross each other in the queue.
> > >  ...
> > > > It's not a bug ... but changing it might be feasible ... as long as it
> > > > doesn't affect write performance too much (which I don't think it will),
> > > > since it is in the critical path.
> > > 
> > > We could argue about how much sense it makes to let two writes to the
> > > same sector actually happen in reverse order.
> > > 
> > > Especially given the fact that we actually _do_ preserve ordering in
> > > some cases; just not in others. (We preserve ordering only if the start
> > > and end of the duplicate writes are _precisely_ matching; if it's just
> > > overlapping (which may well happen in the presence of merges), then this
> > > check doesn't trigger.
> > > 
> > > But that's just semantics. Yes, changing it should be feasible. I talked
> > > to Jens about that at the kernel summit, and we agreed that it should
> > > probably be done.
> > 
> > The way this currently works is that we sort based on the first sector
> > in the request. So if you have have an overlap condition between rq1 and
> > rq2 and then a write gets merged into rq1, then you may have passing
> > writes. Linux has never guarenteed any write ordering for non-barriers,
> > so we've never attempted to handle it. Direct aliases (matching first
> > sectors) are handled as you mention, but that's more of an algorithmic
> > thing than by design.
> > 
> > My main worry is that this will add considerable overhead to request
> > sorting. For the rbtree based sorting, we'd have to do a rb_next/rb_prev
> > to look at adjacent requests. For CFQ it's even worse, since there's no
> > per-queue big rbtree for sorting.
> 
> Which is why I suggest special casing:  Only invoke the expensive
> overlap checking if one of the requests is a discard.  Otherwise use the
> standard path for writes.

Good point, we can easily track if we have discard requests pending.
That doesn't really make it a lot better for CFQ though, currently it'll
still have to dump all queues if a discard comes in.

-- 
Jens Axboe

