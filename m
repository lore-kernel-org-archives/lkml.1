Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZIWNky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZIWNky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZIWNkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:40:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:39347 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZIWNkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:40:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190753481"
Date: Wed, 23 Sep 2009 21:40:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jan Kara <jack@suse.cz>,
       Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] writeback: don't delay inodes redirtied by a fast
	dirtier
Message-ID: <20090923134039.GA1196@localhost>
References: <20090923123337.990689487@intel.com> <20090923124028.060887241@intel.com> <20090923132008.GB32347@localhost> <20090923132351.GA32404@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923132351.GA32404@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:23:51PM +0800, Christoph Hellwig wrote:
> On Wed, Sep 23, 2009 at 09:20:08PM +0800, Wu Fengguang wrote:
> > I noticed that
> > - the write chunk size of balance_dirty_pages() is 12, which is pretty
> >   small and inefficient.
> > - during copy, the inode is sometimes redirty_tail (old behavior) and
> >   sometimes requeue_io (new behavior).
> > - during copy, the directory inode will always be synced and then
> >   redirty_tail.
> > - after copy, the inode will be redirtied after sync.
> 
> Yeah, XFS uses generic_file_uffered_write and the heuristics in there
> for balance_dirty_pages turned out to be really bad.  So far we didn't
> manage to sucessfully get that fixed, though.

Ah sorry. It's because of the first patch, it does not always "bump up"
the write chunk. In your case it is obviously decreased (the original
ratelimit_pages=4096 is much larger value).  I'll fix it.

> > It shall not be a problem to use requeue_io for XFS, because whether
> > it be requeue_io or redirty_tail, write_inode() will be called once
> > for every 4MB.
> > 
> > It would be inefficient if XFS really tries to write inode and
> > directory inode's metadata every time it synced 4MB page. If
> > that write attempt is turned into _real_ IO, that would be bad
> > and kill performance. Increasing MAX_WRITEBACK_PAGES may help
> > reduce the frequency of write_inode() though.
> 
> The way we call write_inode for XFS is extremly inefficient for XFS.  As
> you noticed XFS tends to redirty the inode on I/O completion, and we
> also cluster inode writeouts.  For XFS we'd really prefer to not
> intermix data and inode writeout, but first do the data writeout and
> then later push out the inodes, preferably with as many as possible
> inodes to sweep out in one go.

I guess the difficult part would be possible policy requirements
on the max batch size (max number of inodes or pages to write before
switching to write metadata) and the delay time (between the sync of
data and metadata). It may take a long time to make a full scan of
the dirty list.

Thanks,
Fengguang
