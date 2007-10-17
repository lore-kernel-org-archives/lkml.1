Return-Path: <linux-kernel-owner+w=401wt.eu-S936084AbXJQRxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936084AbXJQRxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbXJQRx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:53:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757309AbXJQRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:53:27 -0400
Date: Wed, 17 Oct 2007 10:52:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <20071017170804.GG15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171022340.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
> 
> OK, the below should actually be safe, I don't know why I talked myself
> into the next_sg stuff in the beginning. It's always safe to zero sg,
> since it's a valid entry - nothing to save in ->page. Ingo, does this
> work for you?

I really don't think this should work.

Doing "sg_next()" on a valid sg is *always* ok. So if the old code didn't 
work, then "sg" wasn't valid to start with (and the code *after* the 
sg_next() would have oopsed even if you try to avoid using sg_next.

So avoiding the "sg_next()" on the last entry is pointless. 

Also, your patch makes the code almost totally unreadable, with that 
subtle issue of the "if (bvprv && cluster)" case not triggering on the 
first case, so the NULL initial sg is "safe".

So at a guess, I think the *real* problem is simply that the passed-in 
sglist was just too small. What guarantees that the sg list allocation 
(apparently done by scsi_alloc_sgtable()) is big enough? 

If I read things right, scsi_alloc_sgtable() will allocate "cmd->use_sg" 
SG enties, no? But I also notice that it does not seem to initialize the 
SG allocation, so those SG entries contain random crap - including, 
perhaps, a random - and bogus - chain pointer in sg->page..

Yes, we set sh->page *if* we create a chain, but if we don't chain, we 
leave the old random contents around which in turn may include old and 
stale chain pointers. Or am I missing something?

So when you added that "memset(sg, 0, sizeof(*sg))" into blk_rq_map_sg(), 
you did it way too late - it needs to be done when the sg chain is 
allocated, and for every entry (and then the "link" entry needs to be 
linked in separately)

I think.

		Linus

