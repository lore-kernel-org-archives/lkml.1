Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbYDYMOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbYDYMOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYDYMOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:14:34 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23672 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbYDYMOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:14:33 -0400
Date: Fri, 25 Apr 2008 14:14:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
Message-ID: <20080425121427.GR12774@kernel.dk>
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk> <48107891.5000308@hp.com> <20080425083809.GG12774@kernel.dk> <4811BDBB.8010604@hp.com> <20080425112543.GQ12774@kernel.dk> <4811C93F.70001@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4811C93F.70001@cse.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25 2008, Aaron Carroll wrote:
> Jens Axboe wrote:
> >>I have the results from leaving in just the one-hit cache merge
> >>attempts, and started a run leaving in both that and the back-merge
> >>rq_hash checks. (The patch below basically undoes patch 3/3 - putting
> >>back in the addition of rqs onto the hash list, and moves the nomerges
> >>check below the back merge attempts.)
> >>
> >>We /could/ change the tunable to a dial (or a mask) - enabling/disabling
> >>specific merge attempts, but that seems a bit confusing/complex.
> >>
> >>Jens: What do you think?
> >
> >I think we should keep it simple. I don't particularly like having a
> >switch to toggle merges, no one will ever use it. So I'm more inclined
> >to just disable front merges unconditionally if the theory of where
> >the cycles are spent holds up. We'll still do front merges on the
> >one-hit cache, just not spend time looking up an io context and request
> >in the rbtree for basically no gain.
> 
> Front merging is probably a waste of time, but it could also be a hash table
> lookup if you think the rbtree traversal is sinking too many cycles.

The front merges weren't considered important enough to add space for a
seperate hash table, that is why they are (re)using the normal rb sort
tree for lookups.

> I wonder if there's any merit in junking the merge hash (and
> front-merging in the ioscheds proper) and just having per-process
> one-hit caches.  That's going to catch the majority of merge cases.
> For requests that happen to be adjacent by chance, they are just as
> likely to be back or front merges.

It's a possibility, the per-process plugging does that. The merge hash
is fairly cheap though, so unless we ever merge the per-process
plugging, I don't think it's a good idea to change it.

-- 
Jens Axboe

