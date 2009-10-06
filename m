Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZJFMz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZJFMz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbZJFMz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:55:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbZJFMz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:55:58 -0400
Date: Tue, 6 Oct 2009 14:55:19 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20091006125519.GB22781@duck.suse.cz>
References: <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org> <20090928140756.GC17514@mit.edu> <20090930052657.GA17268@localhost> <20090930053223.GA14368@localhost> <20091001221738.GA25580@duck.suse.cz> <20091002032714.GB14246@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002032714.GB14246@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-10-09 11:27:14, Wu Fengguang wrote:
> On Fri, Oct 02, 2009 at 06:17:39AM +0800, Jan Kara wrote:
> > On Wed 30-09-09 13:32:23, Wu Fengguang wrote:
> > > writeback: bump up writeback chunk size to 128MB
> > > 
> > > Adjust the writeback call stack to support larger writeback chunk size.
> > > 
> > > - make wbc.nr_to_write a per-file parameter
> > > - init wbc.nr_to_write with MAX_WRITEBACK_PAGES=128MB
> > >   (proposed by Ted)
> > > - add wbc.nr_segments to limit seeks inside sparsely dirtied file
> > >   (proposed by Chris)
> > > - add wbc.timeout which will be used to control IO submission time
> > >   either per-file or globally.
> > >   
> > > The wbc.nr_segments is now determined purely by logical page index
> > > distance: if two pages are 1MB apart, it makes a new segment.
> > > 
> > > Filesystems could do this better with real extent knowledges.
> > > One possible scheme is to record the previous page index in
> > > wbc.writeback_index, and let ->writepage compare if the current and
> > > previous pages lie in the same extent, and decrease wbc.nr_segments
> > > accordingly. Care should taken to avoid double decreases in writepage
> > > and write_cache_pages.
> > > 
> > > The wbc.timeout (when used per-file) is mainly a safeguard against slow
> > > devices, which may take too long time to sync 128MB data.
> > > 
> > > The wbc.timeout (when used globally) could be useful when we decide to
> > > do two sync scans on dirty pages and dirty metadata. XFS could say:
> > > please return to sync dirty metadata after 10s. Would need another
> > > b_io_metadata queue, but that's possible.
> > > 
> > > This work depends on the balance_dirty_pages() wait queue patch.
> >   I don't know, I think it gets too complicated... I'd either use the
> > segments idea or the timeout idea but not both (unless you can find real
> > world tests in which both help).
  I'm sorry for a delayed reply but I had to work on something else.

> Maybe complicated, but nr_segments and timeout each has their target
> application.  nr_segments serves two major purposes:
> - fairness between two large files, one is continuously dirtied,
>   another is sparsely dirtied. Given the same amount of dirty pages,
>   it could take vastly different time to sync them to the _same_
>   device. The nr_segments check helps to favor continuous data.
> - avoid seeks/fragmentations. To give each file fair chance of
>   writeback, we have to abort a file when some nr_to_write or timeout
>   is reached. However they are both not good abort conditions.
>   The best is for filesystem to abort earlier in seek boundaries,
>   and treat nr_to_write/timeout as large enough bottom lines.
> timeout is mainly a safeguard in case nr_to_write is too large for
> slow devices. It is not necessary if nr_to_write is auto-computed,
> however timeout in itself serves as a simple throughput adapting
> scheme.
  I understand why you have introduced both segments and timeout value
and a completely agree with your reasons to introduce them. I just think
that when the system gets too complex (there will be several independent
methods of determining when writeback should be terminated, and even
though each method is simple on its own, their interactions needn't be
simple...) it will be hard to debug all the corner cases - even more
because they will manifest "just" by slow or unfair writeback. So I'd
prefer a single metric to determine when to stop writeback of an inode
even though it might be a bit more complicated.
  For example terminating on writeout does not really get a file fair
chance of writeback because it might have been blocked just because we were
writing some heavily fragmented file just before. And your nr_segments
check is just a rough guess of whether a writeback is going to be
fragmented or not.
  So I'd rather implement in mpage_ functions a proper detection of how
fragmented the writeback is and give each inode a limit on number of
fragments which mpage_ functions would obey. We could even use a queue's
NONROT flag (set for solid state disks) to detect whether we should expect
higher or lower seek times.
								Honza
