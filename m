Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZJAWRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZJAWRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZJAWRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:17:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:42533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZJAWRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:17:39 -0400
Date: Fri, 2 Oct 2009 00:17:39 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>
Subject: Re: regression in page writeback
Message-ID: <20091001221738.GA25580@duck.suse.cz>
References: <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org> <20090928140756.GC17514@mit.edu> <20090930052657.GA17268@localhost> <20090930053223.GA14368@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930053223.GA14368@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-09-09 13:32:23, Wu Fengguang wrote:
> writeback: bump up writeback chunk size to 128MB
> 
> Adjust the writeback call stack to support larger writeback chunk size.
> 
> - make wbc.nr_to_write a per-file parameter
> - init wbc.nr_to_write with MAX_WRITEBACK_PAGES=128MB
>   (proposed by Ted)
> - add wbc.nr_segments to limit seeks inside sparsely dirtied file
>   (proposed by Chris)
> - add wbc.timeout which will be used to control IO submission time
>   either per-file or globally.
>   
> The wbc.nr_segments is now determined purely by logical page index
> distance: if two pages are 1MB apart, it makes a new segment.
> 
> Filesystems could do this better with real extent knowledges.
> One possible scheme is to record the previous page index in
> wbc.writeback_index, and let ->writepage compare if the current and
> previous pages lie in the same extent, and decrease wbc.nr_segments
> accordingly. Care should taken to avoid double decreases in writepage
> and write_cache_pages.
> 
> The wbc.timeout (when used per-file) is mainly a safeguard against slow
> devices, which may take too long time to sync 128MB data.
> 
> The wbc.timeout (when used globally) could be useful when we decide to
> do two sync scans on dirty pages and dirty metadata. XFS could say:
> please return to sync dirty metadata after 10s. Would need another
> b_io_metadata queue, but that's possible.
> 
> This work depends on the balance_dirty_pages() wait queue patch.
  I don't know, I think it gets too complicated... I'd either use the
segments idea or the timeout idea but not both (unless you can find real
world tests in which both help). Also when we'll assure fairness via
timeout, maybe nr_to_write isn't needed anymore? WB_SYNC_ALL writeback
doesn't use nr_to_write. WB_SYNC_NONE writeback either sets it to some
large value (like LONG_MAX) or number of dirty pages (to effectively write
back as much as possible) or to MAX_WRITEBACK_PAGES to assure fairness
in kupdate style writeback. There are a few exceptions in btrfs but I
belive nr_to_write isn't really needed there either...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
