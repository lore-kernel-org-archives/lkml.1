Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZJAPOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZJAPOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZJAPOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:14:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:35129 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZJAPOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,488,1249282800"; 
   d="scan'208";a="193992736"
Date: Thu, 1 Oct 2009 23:14:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20091001151429.GB9469@localhost>
References: <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org> <20090928140756.GC17514@mit.edu> <20090930052657.GA17268@localhost> <20090930141158.GG24383@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930141158.GG24383@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted,

On Wed, Sep 30, 2009 at 10:11:58PM +0800, Theodore Ts'o wrote:
> On Wed, Sep 30, 2009 at 01:26:57PM +0800, Wu Fengguang wrote:
> > It's good to increase MAX_WRITEBACK_PAGES, however I'm afraid
> > max_contig_writeback_mb may be a burden in future: either it is not
> > necessary, or a per-bdi counterpart must be introduced for all
> > filesystems.
> 
> The per-filesystem tunable was just a short-term hack; the reason why
> I did it that way was it was clear that a global tunable wouldn't fly,
> and rightly so --- what might be suitable for a slow USB stick might
> be very different than a super-fast RAID array, and someone might very
> well have both on the same system.

Ah Yes.

> > And it's preferred to automatically handle slow devices well with the
> > increased chunk size, instead of adding another parameter.
> 
> Agreed; long-term what we probably need is something which is
> automatically tunable.  My thinking was that we should tune the the
> initial nr_to_write parameter based on how many blocks could be
> written in some time interval, which is tunable.  So if we decide that
> 1 second is a suitable time period to be writing out one inode's dirty
> pages, then for a fast server-class SATA disk, we might want to set
> nr_to_write to be around 128mb worth of pages.  For a laptop SATA
> disk, it might be around 64mb, and for a really slow USB stick, it
> might be more like 16mb.  For super-fast enterprise RAID array, 128mb
> might be too small!

Yes, 128MB may be too small :)

> If we get timing and/or congestion information from the block layer,
> it wouldn't be hard to figure out the optimal number of pages that
> should be sent down to the filesystem, and to tune this automatically.

Sure, it's possible.

> > I scratched up a patch to demo the ideas collected in recent discussions.
> > Can you check if it serves your needs? Thanks.
> 
> Sure, I'll definitely play with it, thanks.

Thanks :)

> > The wbc.timeout (when used per-file) is mainly a safeguard against slow
> > devices, which may take too long time to sync 128MB data.
> 
> Maybe I'm missing something, but I don't think the wbc.timeout
> approach is sufficient.  Consider the scenario of someone who is
> ripping a DVD disc to an 8 gig USB stick.  The USB stick will be very
> slow, but since the file is contiguous the filesystem will very
> happily try to push it out there 128MB at a time, and wbc.timeout
> value isn't really going to help since a single call to writepages
> could easily cause 128MB worth of data to be streamed out to the USB
> stick.

Yes and no. Yes if the queue was empty for the slow device. No if the
queue was full, in which case IO submission speed = IO complete speed
for previously queued requests.

So wbc.timeout will be accurate for IO submission time, and mostly
accurate for IO completion time. The transient queue fill up phase
shall not be a big problem?

> This is why the MAX_WRITEBACK_PAGES really needs to be tuned on a
> per-bdi basis; either manually, via a sysfs tunable, or automatically,
> by auto-tuning based on how fast the storage device is or by some kind
> of congestion-based approach.  This is certainly the best long-term
> solution; my concern was that it might take a long-time for us to get
> the auto-tunable just right, so in the meantime I added a
> per-mounted-filesystem tunable and put the hack in the filesystem
> layer.  I would like nothing better than to rip it out, once we have a
> long-term solution.

Thanks,
Fengguang
