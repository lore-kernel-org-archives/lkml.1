Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZJLJIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZJLJIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZJLJH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:07:59 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:35363 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbZJLJH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:07:58 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
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
In-Reply-To: <20091012012609.GA7553@localhost>
References: <20091007073818.318088777@intel.com>
	 <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz>
	 <1255101512.8802.65.camel@laptop> <20091009154759.GJ7654@duck.suse.cz>
	 <20091011022813.GA21315@localhost> <1255247080.11081.3.camel@twins>
	 <20091011105012.GB10409@localhost> <1255260317.8967.204.camel@laptop>
	 <20091012012609.GA7553@localhost>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 11:07:10 +0200
Message-Id: <1255338430.11081.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 09:26 +0800, Wu Fengguang wrote:
> On Sun, Oct 11, 2009 at 07:25:17PM +0800, Peter Zijlstra wrote:
> > On Sun, 2009-10-11 at 18:50 +0800, Wu Fengguang wrote:
> > > 
> > > Sorry for the confusion, but I mean, filesystems have to limit
> > > nr_writeback (directly or indirectly via the block io queue),
> > > otherwise it either hit nr_dirty to 0 (with the loop), or let
> > > nr_writeback grow out of control (without the loop).
> > 
> > Doesn't this require the writeback queue to have a limit < dirty_thresh?
> 
> Yes, this is the key (open) issue. For now we have nothing to limit
> 
>         nr_writeback < dirty_thresh
> 
> > Or more specifically, for the bdi case:
> > 
> >  bdi_dirty + bdi_writeback + bdi_unstable <= bdi_thresh
> > 
> > we require that the writeback queue be smaller than bdi_thresh, which
> > could be quite difficult, since bdi_thresh can easily be 0.
> 
> We could apply a MIN_BDI_DIRTY_THRESH. Because the bdi threshold is
> estimated from writeback events, so bdi_thresh must be non-zero to
> allow some writeback pages in flight :)

Not really, suppose you have 1000 NFS clients, of which you only use a
hand full at a time.

Then the bdi_thresh will be 0 for most of them, and only when you switch
to one it'll start growing. But it's perfectly reasonable to expect
bdi_thresh=0 to work. It just reverts to sync behaviour, we write out
everything and block until they're all gone from writeback state.

MIN_BDI_DIRTY_THRESH != 0, will have a side effect of imposing a max
number of BDIs on the system, I'm not sure you want to go there.

> > Without observing the bdi_thresh constraint we can have:
> > 
> >   \Sum_(over bdis) writeback_queue_size
> > 
> > dirty pages outstanding, which could be significantly higher than
> > dirty_thresh.
>  
> Yes.  Maybe we could do some per-bdi and/or global writeback wait
> queue (ie. some generalized version of the patch 20: NFS: introduce
> writeback wait queue).
> 
> The per-bdi writeback queue size should ideally be proportional to its
> available writeback bandwidth. MIN_BDI_DIRTY_THRESH could be defined
> to (2*bdi_writeback_bandwidth) or something close. And if the resulted
> bdi limits turn out to be too large for a small memory system, we just
> let the global limit kick in. For such small memory systems, it is
> very likely there are only one bdi. So it is not likely to lose
> fairness to base its limits on available memory instead of device
> capability.

I'm not seeing why. By simply keeping that loop we're good again, and
can have a writeback queue that works well in the saturated case.

