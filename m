Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbXJQSBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbXJQSBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbXJQSAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:00:50 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24517 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbXJQSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:00:49 -0400
Date: Wed, 17 Oct 2007 20:00:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017180042.GP15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <alpine.LFD.0.999.0710171022340.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710171022340.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Oct 2007, Jens Axboe wrote:
> > 
> > OK, the below should actually be safe, I don't know why I talked myself
> > into the next_sg stuff in the beginning. It's always safe to zero sg,
> > since it's a valid entry - nothing to save in ->page. Ingo, does this
> > work for you?
> 
> I really don't think this should work.
> 
> Doing "sg_next()" on a valid sg is *always* ok. So if the old code didn't 
> work, then "sg" wasn't valid to start with (and the code *after* the 
> sg_next() would have oopsed even if you try to avoid using sg_next.
> 
> So avoiding the "sg_next()" on the last entry is pointless. 

Yeah, I didn't quite understand why if sg was valid, why dereferencing
*(sg + 1)->page would crap out :/

> Also, your patch makes the code almost totally unreadable, with that 
> subtle issue of the "if (bvprv && cluster)" case not triggering on the 
> first case, so the NULL initial sg is "safe".

Hmm I think it's quite readable, but perhaps that's just me :-). The
first is much cleaner, and the last part just reads 'if sg is not set
yet, set to list. otherwise, goto next entry'.

> So at a guess, I think the *real* problem is simply that the passed-in 
> sglist was just too small. What guarantees that the sg list allocation 
> (apparently done by scsi_alloc_sgtable()) is big enough? 
> 
> If I read things right, scsi_alloc_sgtable() will allocate "cmd->use_sg" 
> SG enties, no? But I also notice that it does not seem to initialize the 
> SG allocation, so those SG entries contain random crap - including, 
> perhaps, a random - and bogus - chain pointer in sg->page..

Right, we allocate an sgtable that will hold ->use_sg entries, which
contains request->nr_phys_segments. And that should definitely fit.

Regarding the init of the sglist, that was the revert I was talking
about. We do need that memset() in there, so all those sg entries will
be properly zeroed.

> Yes, we set sh->page *if* we create a chain, but if we don't chain, we 
> leave the old random contents around which in turn may include old and 
> stale chain pointers. Or am I missing something?
> 
> So when you added that "memset(sg, 0, sizeof(*sg))" into blk_rq_map_sg(), 
> you did it way too late - it needs to be done when the sg chain is 
> allocated, and for every entry (and then the "link" entry needs to be 
> linked in separately)
> 
> I think.

Yep, and that is what Ingo did test as well and it worked. For that
case, now libata is crapping out elsewhere in sg_next().

-- 
Jens Axboe

