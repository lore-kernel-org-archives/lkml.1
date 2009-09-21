Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZIUKTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZIUKTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 06:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZIUKTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 06:19:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:34498 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbZIUKTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 06:19:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,424,1249282800"; 
   d="scan'208";a="189814681"
Date: Mon, 21 Sep 2009 18:18:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090921101850.GA7045@localhost>
References: <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost> <20090919150351.GA19880@localhost> <20090920190006.GD16919@duck.suse.cz> <20090921030402.GC6331@localhost> <20090921053546.GA16932@localhost> <20090921095326.GA32281@localhost> <20090921100242.GA1099@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921100242.GA1099@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 06:02:42PM +0800, Jan Kara wrote:
> On Mon 21-09-09 17:53:26, Wu Fengguang wrote:
> > On Mon, Sep 21, 2009 at 01:35:46PM +0800, Wu Fengguang wrote:
> > > > >   Here is how I'd imaging the writeout logic should work:
> > > > > We would have just two lists - b_dirty and b_more_io. Both would be
> > > > > ordered by dirtied_when.
> > > > 
> > > > Andrew has a very good description for the dirty/io/more_io queues:
> > > > 
> > > > http://lkml.org/lkml/2006/2/7/5
> > > > 
> > > > | So the protocol would be:
> > > > |
> > > > | s_io: contains expired and non-expired dirty inodes, with expired ones at
> > > > | the head.  Unexpired ones (at least) are in time order.
> > > > |
> > > > | s_more_io: contains dirty expired inodes which haven't been fully written. 
> > > > | Ordering doesn't matter (unless someone goes and changes
> > > > | dirty_expire_centisecs - but as long as we don't do anything really bad in
> > > > | response to this we'll be OK).
> > > > |
> > > > | s_dirty: contains expired and non-expired dirty inodes.  The non-expired
> > > > | ones are in time-of-dirtying order.
> > > > 
> > > > Since then s_io was changed to hold only _expired_ dirty inodes at the
> > > > beginning of a full scan. It serves as a bounded set of dirty inodes.
> > > > So that when finished a full scan of it, the writeback can go on to
> > > > the next superblock, and old dirty files' writeback won't be delayed
> > > > infinitely by poring in newly dirty files.
> > > > 
> > > > It seems that the boundary could also be provided by some
> > > > older_than_this timestamp. So removal of b_io is possible
> > > > at least on this purpose.
> > > 
> > > Yeah, this is a scratch patch to remove b_io, I see no obvious
> > > difficulties in doing so.
> > 
> > However the removal of b_io is not that good for possible b_dirty
> > optimizations. For example, we could use a tree for b_dirty for more
> > flexible ordering. Or can introduce a b_dirty_atime to hold the inodes
> > dirtied by atime and expire them much lazily:
> > 
> >                        expire > 30m
> >         b_dirty_atime --------------+
> >                                     |
> >                                     +--- b_io ---> writeback
> >                                     |
> >         b_dirty --------------------+
> >                        expire > 30s
>   Well, you can still implement the above without a need for b_io list. The
> kupdate-style writeback can for example check the first inode in both lists
> and process the inode which is expired for a longer time.

OK. Given that rel_atime is default now, such optimization seems less
useful anyway.

Thanks,
Fengguang
