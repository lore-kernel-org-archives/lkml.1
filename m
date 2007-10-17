Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbXJQSUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbXJQSUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXJQSUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:20:34 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2863 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757657AbXJQSUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:20:33 -0400
Date: Wed, 17 Oct 2007 20:20:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017182013.GR15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org> <20071017180218.GQ15552@kernel.dk> <alpine.LFD.0.999.0710171111040.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710171111040.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Oct 2007, Jens Axboe wrote:
> > >
> > >  - remove the "memset()" you had added earlier. It's bogus. It cannot be 
> > >    the right thing. If the sg list wasn't initialized correctly much 
> > >    earlier, trying to initialize it late is pointless - it contains crap.
> > 
> > It's required to clear output members (like dma_len and so on), since
> > some of the IOMU code really wants that initialized.
> 
> No it's NOT!
> 
> The whole point here is that the sg had *already* better be cleared.
> 
> If it wasn't cleared before, that's a bug regardless of anything else. So 
> a memset() is guaranteed to be either a no-op or hiding another bug!
> 
> So yes, those members had better be zero. It's just that they had better 
> be zero long before that memset! The memset should have been done when 
> allocating the SG list.

For the chain elements - yes, definitely! But we also want to clear dma
mapping output values, at least sparc64 wants that. You could argue that
the IOMMU code should be fixed up, but I don't think we should mix the
two.

So we need the memset() in blk_rq_map_sg() AS WELL AS the initial sg
table clear. I'm not arguing about the latter, we clearly do need that.

> > If you prefer the old next_sg approach to my alternative, that is fine
> > with me. But we do need the memset().
> 
> Really? Explain why. Entering that code with a non-initialized SG list is 
> a bug to begin with.

Not for the output members, they will be filled AFTER blk_rq_map_sg()
returns and someone use iommu_map_sg() to re-iterate the sglist and map
the pages appropriately.

-- 
Jens Axboe

