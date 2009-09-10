Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZIJPPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZIJPPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZIJPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:15:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:48997 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbZIJPPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:15:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="186190261"
Date: Thu, 10 Sep 2009 23:14:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH 7/7] writeback: balance_dirty_pages() shall write
	more than dirtied pages
Message-ID: <20090910151458.GA10767@localhost>
References: <20090909145141.293229693@intel.com> <20090909150601.159061863@intel.com> <20090909154413.GC7949@duck.suse.cz> <20090910014201.GB10957@localhost> <20090910125742.GH5106@think> <20090910132154.GA6446@localhost> <1252594564.7205.36.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252594564.7205.36.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 10:56:04PM +0800, Peter Zijlstra wrote:
> On Thu, 2009-09-10 at 21:21 +0800, Wu Fengguang wrote:
> > On Thu, Sep 10, 2009 at 08:57:42PM +0800, Chris Mason wrote:
> > > On Thu, Sep 10, 2009 at 09:42:01AM +0800, Wu Fengguang wrote:
> > > > On Wed, Sep 09, 2009 at 11:44:13PM +0800, Jan Kara wrote:
> > > > > On Wed 09-09-09 22:51:48, Wu Fengguang wrote:
> > > > > > Some filesystem may choose to write much more than ratelimit_pages
> > > > > > before calling balance_dirty_pages_ratelimited_nr(). So it is safer to
> > > > > > determine number to write based on real number of dirtied pages.
> > > > > > 
> > > > > > The increased write_chunk may make the dirtier more bumpy.  This is
> > > > > > filesystem writers' duty not to dirty too much at a time without
> > > > > > checking the ratelimit.
> > > > >   I don't get this. balance_dirty_pages_ratelimited_nr() is called when we
> > > > > dirty the page, not when we write it out. So a problem would only happen if
> > > > > filesystem dirties pages by set_page_dirty() and won't call
> > > > > balance_dirty_pages_ratelimited_nr(). But e.g. generic_perform_write()
> > > > > and do_wp_page() takes care of that. So where's the problem?
> > > > 
> > > > It seems that btrfs_file_write() is writing in chunks of up to 1024-pages
> > > > (1024 is the computed nrptrs value in a 32bit kernel). And it calls
> > > > balance_dirty_pages_ratelimited_nr() each time it dirtied such a chunk.
> > > 
> > > I can easily change this to call more often, but we do always call
> > > balance_dirty_pages to reflect how much ram we've really sent down.
> > 
> > Btrfs is doing OK. 2MB/4MB looks like reasonable chunk sizes. The
> > need-change part is balance_dirty_pages_ratelimited_nr(), hence this
> > patch :)
> 
> I'm not getting it, it calls set_page_dirty() for each page, right? and
> then it calls into balance_dirty_pages_ratelimited_nr(), that sounds
> right. What is the problem with that?

It looks like btrfs_file_write() eventually calls
__set_page_dirty_buffers() which in turn won't call
balance_dirty_pages*(). This is why do_wp_page() calls
set_page_dirty_balance() to do balance_dirty_pages*().

So btrfs_file_write() explicitly calls
balance_dirty_pages_ratelimited_nr() to get throttled.

Thanks,
Fengguang
