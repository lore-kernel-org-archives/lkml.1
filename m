Return-Path: <linux-kernel-owner+w=401wt.eu-S1762631AbXJRM3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631AbXJRM3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbXJRM3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:29:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20230 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbXJRM3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:29:30 -0400
Date: Thu, 18 Oct 2007 14:28:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: bhalevy@panasas.com, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071018122852.GA5063@kernel.dk>
References: <20071017182206.GS15552@kernel.dk> <47173B00.3070303@panasas.com> <20071018105516.GT5063@kernel.dk> <20071018.050327.59654383.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018.050327.59654383.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, 18 Oct 2007 12:55:17 +0200
> 
> > Things have progressed a lot since, see my recent posting based on
> > Davem's proposal. Will post another patch soonish, that is also
> > tested.
> 
> One core issue here is that we need to decide whether this thing to be
> iterated like an array or like a linked list.  It's trying to be both.
> 
> If we decide upon a looping construct for consumers and stick to it,
> we'll be in much better shape than we are now and bugs will be eaiser
> to spot.  It would be so much simpler to audit if all we saw in the
> consumers were things like:
> 
> 	while (sg) {
> 		do_stuff(sg);
> 		sg = sg_next(sg);
> 	}
> 
> I would suggest that we just get it over with and convert the whole
> tree now rather than trying to do this kind of thing in stages.
> Because then we can say that ever scatterlist creator has to set
> the "end" bit and therefore you use well established patterns
> for scatterlist iteration such as "traverse sg_next() until NULL"
> as shown above.

The above should work now, PROVIDED that the end has been marked
properly. I have added some helpers to init an sglist (or sg entry).
You can still use

        for_each_sg()

and pass in the number of entries, that'll work even with an end marker.
So, it does both.

> I also noticed that there is the issue of on-stack and embedded
> scatterlist users.  We'll need some sort of "DECLARE_SCATTERLIST"
> and a "scatterlist_init()" thing so that we can keep DEBUG_SG
> working even in those cases.  But for all I know Jens could be
> working on that already :-)

Heh, got some of it covered! The stack usage is generally just converted
to either use sg_init_one() if we can, or sg_init_table(). Adding some
soft of DECLARE_SCATTERLIST() sounds like a good idea, though. I'll take
patches :-)

> The only other real option if we don't convert the whole tree now to
> the "end" marker stuff, is to enforce that every scatterlist iterator
> only traverse the number of entries there were told are in the one
> given to them.

Driver that do all their own sg management typically still use a manual
loop over the number of entries they know are there. I didn't change
those, and the original sg chaining didn't convert those either. Some
manual labor is required in utilizing chained sg lists, unless you are
part of a subsystem (like SCSI) that allocates and inits themf or you.
So I still think that baby steps are a good idea - only convert things
that matter. Leave the rest to janitors or others willing to dive in.

-- 
Jens Axboe

