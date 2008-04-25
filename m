Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbYDYL0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbYDYL0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYDYLZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:25:49 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15896 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408AbYDYLZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:25:48 -0400
Date: Fri, 25 Apr 2008 13:25:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
Message-ID: <20080425112543.GQ12774@kernel.dk>
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk> <48107891.5000308@hp.com> <20080425083809.GG12774@kernel.dk> <4811BDBB.8010604@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4811BDBB.8010604@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25 2008, Alan D. Brunelle wrote:
> >>
> >> I'll look into retaining the one-hit cache merge functionality, remove
> >> the errant elv_rqhas_del code, and repost w/ the results from the other
> >> tests I've run.
> > 
> > Also please do a check where you only disable the front merge logic, as
> > that is the most expensive bit (and the least likely to occur). I would
> > not be surprised if just removing the front merge bit would get you the
> > majority of the gain already. I have in the past considered just getting
> > rid of that bit, as it rarely triggers and it is a costly rbtree lookup
> > for each IO. The back merge lookup+merge should be cheaper, it's just a
> > hash lookup.
> > 
> 
> I have the results from leaving in just the one-hit cache merge
> attempts, and started a run leaving in both that and the back-merge
> rq_hash checks. (The patch below basically undoes patch 3/3 - putting
> back in the addition of rqs onto the hash list, and moves the nomerges
> check below the back merge attempts.)
> 
> We /could/ change the tunable to a dial (or a mask) - enabling/disabling
> specific merge attempts, but that seems a bit confusing/complex.
> 
> Jens: What do you think?

I think we should keep it simple. I don't particularly like having a
switch to toggle merges, no one will ever use it. So I'm more inclined
to just disable front merges unconditionally if the theory of where
the cycles are spent holds up. We'll still do front merges on the
one-hit cache, just not spend time looking up an io context and request
in the rbtree for basically no gain.

-- 
Jens Axboe

