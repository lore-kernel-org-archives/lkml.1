Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZIVNeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZIVNeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZIVNeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:34:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:64349 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbZIVNeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:34:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,431,1249282800"; 
   d="scan'208";a="190306284"
Date: Tue, 22 Sep 2009 21:33:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090922133358.GC7675@localhost>
References: <20090911141659.GA3508@infradead.org> <20090911142926.GI14984@kernel.dk> <20090911143929.GA25499@localhost> <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost> <20090921135321.GD6259@think> <20090922101335.GA27432@localhost> <20090922113055.GA13887@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922113055.GA13887@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 07:30:55PM +0800, Jan Kara wrote:
> On Tue 22-09-09 18:13:35, Wu Fengguang wrote:
> > Yes a more general solution would help. I'd like to propose one which
> > works in the other way round. In brief,
> > (1) the VFS give a large enough per-file writeback quota to btrfs;
> > (2) btrfs tells VFS "here is a (seek) boundary, stop voluntarily",
> >     before exhausting the quota and be force stopped.
> > 
> > There will be two limits (the second one is new):
> > 
> > - total nr to write in one wb_writeback invocation
> > - _max_ nr to write per file (before switching to sync the next inode)
> > 
> > The per-invocation limit is useful for balance_dirty_pages().
> > The per-file number can be accumulated across successive wb_writeback
> > invocations and thus can be much larger (eg. 128MB) than the legacy
> > per-invocation number. 
>   Actually, it doesn't make much sence to have a per-file limit in number
> of pages. I've been playing with an idea that we could have a per-file
> *time* quota. That would have an advantage that if a file generates random
> IO, we wouldn't block for longer time on it than when it generates linear
> IO.

Heh, FYI recently I tried per-file submission time quota:

        http://lkml.org/lkml/2009/9/10/54

Though I didn't take randomness of IO into account, which definitely
deserves some attention.

>   I imagine that in ->writepage we would substract from given time quota in
> wbc the time it takes to write the current page. It would need some context
> in wbc so that it is able to tell whether the IO is linear or random to
> properly account for some seek penalty but generally it seems to be
> doable...

Yeah, maybe page segments that are distant enough could be treated as "seeks".

>   Filesystems implementing ->writepages can then make decision whether they
> have enough time quota to seek to next extent and write it out or whether
> they should rather yield to other inodes...

Yeah, it's possible. VFS provides (one or more) quota info and
file systems decide when to yield.

Thanks,
Fengguang

> > The file system will only see the per-file numbers. The "max" means
> > if btrfs find the current page to be the last page in the extent,
> > it could indicate this fact to VFS by setting wbc->would_seek=1. The
> > VFS will then switch to write the next inode.
> > 
> > The benefit of early voluntarily yield is, it reduced the possibility
> > to be force stopped half way in an extent. When next time VFS returns
> > to sync this inode, it will again be honored the full 128MB quota,
> > which should be enough to cover a big fresh extent.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
