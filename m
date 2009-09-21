Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZIUNyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZIUNyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbZIUNyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:54:16 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:52914 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbZIUNyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:54:15 -0400
Date: Mon, 21 Sep 2009 09:53:21 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090921135321.GD6259@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"jack@suse.cz" <jack@suse.cz>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com>
 <20090911134241.GB19707@mit.edu>
 <20090911141659.GA3508@infradead.org>
 <20090911142926.GI14984@kernel.dk>
 <20090911143929.GA25499@localhost>
 <20090918175252.GF26991@mit.edu>
 <20090919035835.GA9921@localhost>
 <20090919040051.GA10245@localhost>
 <20090919042607.GA19752@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919042607.GA19752@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AB7855F.0182:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 12:26:07PM +0800, Wu Fengguang wrote:
> On Sat, Sep 19, 2009 at 12:00:51PM +0800, Wu Fengguang wrote:
> > On Sat, Sep 19, 2009 at 11:58:35AM +0800, Wu Fengguang wrote:
> > > On Sat, Sep 19, 2009 at 01:52:52AM +0800, Theodore Tso wrote:
> > > > On Fri, Sep 11, 2009 at 10:39:29PM +0800, Wu Fengguang wrote:
> > > > > 
> > > > > That would be good. Sorry for the late work. I'll allocate some time
> > > > > in mid next week to help review and benchmark recent writeback works,
> > > > > and hope to get things done in this merge window.
> > > > 
> > > > Did you have some chance to get more work done on the your writeback
> > > > patches?
> > > 
> > > Sorry for the delay, I'm now testing the patches with commands
> > > 
> > >  cp /dev/zero /mnt/test/zero0 &
> > >  dd if=/dev/zero of=/mnt/test/zero1 &
> > > 
> > > and the attached debug patch.
> > > 
> > > One problem I found with ext3/4 is, redirty_tail() is called repeatedly
> > > in the traces, which could slow down the inode writeback significantly.
> > 
> > FYI, it's this redirty_tail() called in writeback_single_inode():
> > 
> >                         /*
> >                          * Someone redirtied the inode while were writing back
> >                          * the pages.
> >                          */
> >                         redirty_tail(inode);
> 
> Hmm, this looks like an old fashioned problem get blew up by the
> 128MB MAX_WRITEBACK_PAGES.

I'm starting to rethink the 128MB MAX_WRITEBACK_PAGES.  128MB is the
right answer for the flusher thread on sequential IO, but definitely not
on random IO.  We don't want the flusher to get bogged down on random
writeback and start ignoring every other file.

My btrfs performance branch has long had a change to bump the
nr_to_write up based on the size of the delayed allocation that we're
doing.  It helped, but not as much as I really expected it too, and a
similar patch from Christoph for XFS was good but not great.

It turns out the problem is in write_cache_pages.  It processes a whole
pagevec at a time, something like this:

while(!done) {
	for each page in the pagegvec {
		writepage()
		if (wbc->nr_to_write <= 0)
			done = 1;
	}
}

If the filesystem decides to bump nr_to_write to cover a whole
extent (or a max reasonable size), the new value of nr_to_write may
be ignored if nr_to_write had already gone done to zero.

I fixed btrfs to recheck nr_to_write every time, and the results are
much smoother.  This is what it looks like to write out all the .o files
in the kernel.

http://oss.oracle.com/~mason/seekwatcher/btrfs-nr-to-write.png

In this graph, Btrfs is writing the full extent or 8192 pages, whichever
is smaller.  The write_cache_pages change is here, but it is local to
the btrfs copy of write_cache_pages:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=f85d7d6c8f2ad4a86a1f4f4e3791f36dede2fa76

I'd rather see a more formal use of hints from the FS about efficient IO
than a blanket increase of the writeback max.  It's more work than
bumping a single #define, but even with the #define at 1GB, we're going
to end up splitting extents and seeking when nr_to_write does finally
get down to zero.

Btrfs currently only bumps the nr_to_write when it creates the extent, I
need to change it to also bump it when it finds an existing extent.

-chris

