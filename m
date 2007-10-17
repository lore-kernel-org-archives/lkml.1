Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbXJQTDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbXJQTDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbXJQTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:03:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9517 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbXJQTDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:03:45 -0400
Date: Wed, 17 Oct 2007 21:03:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017190340.GW15552@kernel.dk>
References: <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org> <20071017180218.GQ15552@kernel.dk> <alpine.LFD.0.999.0710171111040.26902@woody.linux-foundation.org> <20071017182013.GR15552@kernel.dk> <alpine.LFD.0.999.0710171156060.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710171156060.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Oct 2007, Jens Axboe wrote:
> > 
> > For the chain elements - yes, definitely! But we also want to clear dma
> > mapping output values, at least sparc64 wants that. You could argue that
> > the IOMMU code should be fixed up, but I don't think we should mix the
> > two.
> > 
> > So we need the memset() in blk_rq_map_sg() AS WELL AS the initial sg
> > table clear. I'm not arguing about the latter, we clearly do need that.
> 
> I still don't see your argument.
> 
> The SG table is *already*zeroed*.
> 
> The fact that output values will be changed later is irrelevant. They 
> haven't been changed *before* - or at least you haven't given a reasonable 
> explanation for why they should have.
> 
> So explain to me why the memset() in blk_rq_map_sg() helps, considering 
> that the memory must have been zeroed at allocation time anyway? Tell me 
> what it is that fills any of the fields we don't already initialize, and 
> that can happen *before* that memset?

Ah ok, I see why you are confused. The SCSI case is one, it allocs and
frees the sg table each time. The entries are thus always initialized
when they end up in blk_rq_map_sg(). However, other drivers allocate one
at driver init time and use that one all the time. It needs to be
initially cleared, but it wont be cleared before each request mapping.
And that is fine, as long as we do clear entries in blk_rq_map_sg().

-- 
Jens Axboe

