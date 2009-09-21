Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZIUKCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZIUKCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 06:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbZIUKCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 06:02:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZIUKCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 06:02:41 -0400
Date: Mon, 21 Sep 2009 12:02:42 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090921100242.GA1099@duck.suse.cz>
References: <20090911143929.GA25499@localhost> <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost> <20090919150351.GA19880@localhost> <20090920190006.GD16919@duck.suse.cz> <20090921030402.GC6331@localhost> <20090921053546.GA16932@localhost> <20090921095326.GA32281@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921095326.GA32281@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-09-09 17:53:26, Wu Fengguang wrote:
> On Mon, Sep 21, 2009 at 01:35:46PM +0800, Wu Fengguang wrote:
> > On Mon, Sep 21, 2009 at 11:04:02AM +0800, Wu Fengguang wrote:
> > > On Mon, Sep 21, 2009 at 03:00:06AM +0800, Jan Kara wrote:
> > > > On Sat 19-09-09 23:03:51, Wu Fengguang wrote:
> > > > > On Sat, Sep 19, 2009 at 12:26:07PM +0800, Wu Fengguang wrote:
> > > > > > On Sat, Sep 19, 2009 at 12:00:51PM +0800, Wu Fengguang wrote:
> > > > > > > On Sat, Sep 19, 2009 at 11:58:35AM +0800, Wu Fengguang wrote:
> > > > > > > > On Sat, Sep 19, 2009 at 01:52:52AM +0800, Theodore Tso wrote:
> > > > > > > > > On Fri, Sep 11, 2009 at 10:39:29PM +0800, Wu Fengguang wrote:
> > > > > > > > > > 
> > > > > > > > > > That would be good. Sorry for the late work. I'll allocate some time
> > > > > > > > > > in mid next week to help review and benchmark recent writeback works,
> > > > > > > > > > and hope to get things done in this merge window.
> > > > > > > > > 
> > > > > > > > > Did you have some chance to get more work done on the your writeback
> > > > > > > > > patches?
> > > > > > > > 
> > > > > > > > Sorry for the delay, I'm now testing the patches with commands
> > > > > > > > 
> > > > > > > >  cp /dev/zero /mnt/test/zero0 &
> > > > > > > >  dd if=/dev/zero of=/mnt/test/zero1 &
> > > > > > > > 
> > > > > > > > and the attached debug patch.
> > > > > > > > 
> > > > > > > > One problem I found with ext3/4 is, redirty_tail() is called repeatedly
> > > > > > > > in the traces, which could slow down the inode writeback significantly.
> > > > > > > 
> > > > > > > FYI, it's this redirty_tail() called in writeback_single_inode():
> > > > > > > 
> > > > > > >                         /*
> > > > > > >                          * Someone redirtied the inode while were writing back
> > > > > > >                          * the pages.
> > > > > > >                          */
> > > > > > >                         redirty_tail(inode);
> > > > > > 
> > > > > > Hmm, this looks like an old fashioned problem get blew up by the
> > > > > > 128MB MAX_WRITEBACK_PAGES.
> > > > > > 
> > > > > > The inode was redirtied by the busy cp/dd processes. Now it takes much
> > > > > > more time to sync 128MB, so that a heavy dirtier can easily redirty
> > > > > > the inode in that time window.
> > > > > > 
> > > > > > One single invocation of redirty_tail() could hold up the writeback of
> > > > > > current inode for up to 30 seconds.
> > > > > 
> > > > > It seems that this patch helps. However I'm afraid it's too late to
> > > > > risk merging such kind of patches now..
> > > >   Fenguang, could we maybe write down how the logic should look like
> > > > and then look at the code and modify it as needed to fit the logic?
> > > > Because I couldn't find a compact description of the logic anywhere
> > > > in the code.
> > > 
> > > Good idea. It makes sense to write something down in Documentation/
> > > or embedded as code comments.
> > > 
> > > >   Here is how I'd imaging the writeout logic should work:
> > > > We would have just two lists - b_dirty and b_more_io. Both would be
> > > > ordered by dirtied_when.
> > > 
> > > Andrew has a very good description for the dirty/io/more_io queues:
> > > 
> > > http://lkml.org/lkml/2006/2/7/5
> > > 
> > > | So the protocol would be:
> > > |
> > > | s_io: contains expired and non-expired dirty inodes, with expired ones at
> > > | the head.  Unexpired ones (at least) are in time order.
> > > |
> > > | s_more_io: contains dirty expired inodes which haven't been fully written. 
> > > | Ordering doesn't matter (unless someone goes and changes
> > > | dirty_expire_centisecs - but as long as we don't do anything really bad in
> > > | response to this we'll be OK).
> > > |
> > > | s_dirty: contains expired and non-expired dirty inodes.  The non-expired
> > > | ones are in time-of-dirtying order.
> > > 
> > > Since then s_io was changed to hold only _expired_ dirty inodes at the
> > > beginning of a full scan. It serves as a bounded set of dirty inodes.
> > > So that when finished a full scan of it, the writeback can go on to
> > > the next superblock, and old dirty files' writeback won't be delayed
> > > infinitely by poring in newly dirty files.
> > > 
> > > It seems that the boundary could also be provided by some
> > > older_than_this timestamp. So removal of b_io is possible
> > > at least on this purpose.
> > 
> > Yeah, this is a scratch patch to remove b_io, I see no obvious
> > difficulties in doing so.
> 
> However the removal of b_io is not that good for possible b_dirty
> optimizations. For example, we could use a tree for b_dirty for more
> flexible ordering. Or can introduce a b_dirty_atime to hold the inodes
> dirtied by atime and expire them much lazily:
> 
>                        expire > 30m
>         b_dirty_atime --------------+
>                                     |
>                                     +--- b_io ---> writeback
>                                     |
>         b_dirty --------------------+
>                        expire > 30s
  Well, you can still implement the above without a need for b_io list. The
kupdate-style writeback can for example check the first inode in both lists
and process the inode which is expired for a longer time.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
