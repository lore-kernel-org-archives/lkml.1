Return-Path: <linux-kernel-owner+w=401wt.eu-S1752410AbZJLB0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbZJLB0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 21:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZJLB0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 21:26:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:20492 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZJLB0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 21:26:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,544,1249282800"; 
   d="scan'208";a="197739698"
Date: Mon, 12 Oct 2009 09:26:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
	balance_dirty_pages()
Message-ID: <20091012012609.GA7553@localhost>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz> <1255101512.8802.65.camel@laptop> <20091009154759.GJ7654@duck.suse.cz> <20091011022813.GA21315@localhost> <1255247080.11081.3.camel@twins> <20091011105012.GB10409@localhost> <1255260317.8967.204.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255260317.8967.204.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 07:25:17PM +0800, Peter Zijlstra wrote:
> On Sun, 2009-10-11 at 18:50 +0800, Wu Fengguang wrote:
> > 
> > Sorry for the confusion, but I mean, filesystems have to limit
> > nr_writeback (directly or indirectly via the block io queue),
> > otherwise it either hit nr_dirty to 0 (with the loop), or let
> > nr_writeback grow out of control (without the loop).
> 
> Doesn't this require the writeback queue to have a limit < dirty_thresh?

Yes, this is the key (open) issue. For now we have nothing to limit

        nr_writeback < dirty_thresh

> Or more specifically, for the bdi case:
> 
>  bdi_dirty + bdi_writeback + bdi_unstable <= bdi_thresh
> 
> we require that the writeback queue be smaller than bdi_thresh, which
> could be quite difficult, since bdi_thresh can easily be 0.

We could apply a MIN_BDI_DIRTY_THRESH. Because the bdi threshold is
estimated from writeback events, so bdi_thresh must be non-zero to
allow some writeback pages in flight :)

> Without observing the bdi_thresh constraint we can have:
> 
>   \Sum_(over bdis) writeback_queue_size
> 
> dirty pages outstanding, which could be significantly higher than
> dirty_thresh.
 
Yes.  Maybe we could do some per-bdi and/or global writeback wait
queue (ie. some generalized version of the patch 20: NFS: introduce
writeback wait queue).

The per-bdi writeback queue size should ideally be proportional to its
available writeback bandwidth. MIN_BDI_DIRTY_THRESH could be defined
to (2*bdi_writeback_bandwidth) or something close. And if the resulted
bdi limits turn out to be too large for a small memory system, we just
let the global limit kick in. For such small memory systems, it is
very likely there are only one bdi. So it is not likely to lose
fairness to base its limits on available memory instead of device
capability.

Thanks,
Fengguang
