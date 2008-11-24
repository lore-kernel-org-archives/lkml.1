Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbYKXSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbYKXSnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKXSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:43:08 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52169 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbYKXSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:43:07 -0500
Subject: Re: about TRIM/DISCARD support and barriers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Tejun Heo <teheo@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com
In-Reply-To: <1227517430.26957.20.camel@macbook.infradead.org>
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>
	 <20081123123514.GI5707@parisc-linux.org>
	 <1227447584.4901.405.camel@macbook.infradead.org>
	 <1227480776.25499.3.camel@localhost.localdomain>
	 <1227517430.26957.20.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 13:42:51 -0500
Message-Id: <1227552171.25499.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 09:03 +0000, David Woodhouse wrote:
> On Mon, 2008-11-24 at 07:52 +0900, James Bottomley wrote:
> > On Sun, 2008-11-23 at 13:39 +0000, David Woodhouse wrote:
> > > > We don't attempt to put non-contiguous ranges into a single TRIM yet.
> > > 
> > > We don't even merge contiguous ranges -- I still need to fix the
> > > elevators to stop writes crossing writes,
> > 
> > I don't think we want to do that ... it's legal if the write isn't a
> > barrier and it will inhibit merging.  That may be just fine for a SSD,
> > but it's not for spinning media since they get better performance out of
> > merged writes.
> 
> No, I just mean writes _to the same sector_. At the moment, we happily
> let those cross each other in the queue.

That's legal ... if you want the ordering to matter, you either wait or
insert a barrier.

> We do notice this situation and preserve the ordering if the two
> requests cover _precisely_ the same range, but _overlapping_ writes may
> happen in any order.
> 
> We should fix that, and it's only for _that_ purpose that I'm saying we
> treat writes and discards as identical. And then we can drop the barrier
> flag on discards.

It's not a bug ... but changing it might be feasible ... as long as it
doesn't affect write performance too much (which I don't think it will),
since it is in the critical path.

> And _then_ we can think about special cases which let us merge
> non-contiguous discards.

I still think that treating discards as a special command from the
outset is the better way forwards.

James


