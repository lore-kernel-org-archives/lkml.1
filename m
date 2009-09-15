Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZIOM65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZIOM65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZIOM6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:58:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:40898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbZIOM6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:58:54 -0400
Date: Tue, 15 Sep 2009 14:58:55 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, tytso@mit.edu, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: Re: [PATCH 6/7] writeback: separate starting of sync vs
	opportunistic writeback
Message-ID: <20090915125855.GF12169@duck.suse.cz>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-7-git-send-email-jens.axboe@oracle.com> <20090914133307.GJ24075@duck.suse.cz> <20090914134207.GA14830@infradead.org> <20090914192803.GL14984@kernel.dk> <20090914194242.GM14984@kernel.dk> <20090915090847.GA12169@duck.suse.cz> <20090915091402.GG23126@kernel.dk> <20090915114426.GJ23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915114426.GJ23126@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-09-09 13:44:26, Jens Axboe wrote:
> On Tue, Sep 15 2009, Jens Axboe wrote:
> > On Tue, Sep 15 2009, Jan Kara wrote:
> > > On Mon 14-09-09 21:42:43, Jens Axboe wrote:
> > > > On Mon, Sep 14 2009, Jens Axboe wrote:
> > > > > On Mon, Sep 14 2009, Christoph Hellwig wrote:
> > > > > > On Mon, Sep 14, 2009 at 03:33:07PM +0200, Jan Kara wrote:
> > > > > > > On Mon 14-09-09 11:36:33, Jens Axboe wrote:
> > > > > > > > bdi_start_writeback() is currently split into two paths, one for
> > > > > > > > WB_SYNC_NONE and one for WB_SYNC_ALL. Add bdi_sync_writeback()
> > > > > > > > for WB_SYNC_ALL writeback and let bdi_start_writeback() handle
> > > > > > > > only WB_SYNC_NONE.
> > > > > > >   What I don't like about this patch is that if somebody sets up
> > > > > > > writeback_control with WB_SYNC_ALL mode set and then submits it to disk via
> > > > > > > bdi_start_writeback() it will just silently convert his writeback to an
> > > > > > > asynchronous one.
> > > > > > >   So I'd maybe leave setting of sync_mode to the caller and just WARN_ON if
> > > > > > > it does not match the purpose of the function...
> > > > > > 
> > > > > > Or initialize the wb entirely inside these functions.  For the sync case
> > > > > > we really only need a superblock as argument, and for writeback it's
> > > > > > bdi + nr_pages.  And also make sure they consistenly return void as
> > > > > > no one cares about the return value.
> > > > > 
> > > > > Yes, I thought about doing that and like that better than the warning.
> > > > > Just pass in the needed args and allocate+fill the wbc on stack. I'll
> > > > > make that change.
> > > > 
> > > > That works out much better, imho:
> > > > 
> > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=270c12655d7d11e234d335a8ab0540c02c034b66
> > >   Yeah, the code looks better. BTW, how about converting also
> > > bdi_writeback_all() to get superblock and nr_pages as an argument?
> > > Currently it seems to be the only place "above" flusher thread which uses
> > > wbc and it's just constructed in the callers of bdi_writeback_all() and
> > > then disassembled inside the function...
> > 
> > Yes good point, I'll include that too. Thanks!
> 
> One small problem there, though... Currently all queued writeback is
> range cyclic, however with this change then we drop that bit from
> sync_inodes_sb() which isn't range_cyclic and instead just specifies the
> whole range.
  I'm not sure I understand your comment but I see a problem that even
writeback queued from sync_inodes_sb() is processed by wb_writeback() which
sets range_cyclic. That's a bug even in your old patchset.
  Let's have a look at the flags in wbc:
  nonblocking - Currently only set by direct callers of ->writepage() BUT
                originally wb_kupdate() and background_writeout() also
                set this flag. Since filesystems and write_cache_pages()
		use the flag we should set it for equivalent writeouts as
                well. This should be fixed...
  encountered_congestion - Checked only by AFS, probably we can get rid of
                it now.
  for_kupdate - Used, we set it properly in wb_writeback() so that is fine.
  for_reclaim - Used by direct callers of ->writepage(). OK.
  for_writepages - Only set. Get rid of it.
  range_cyclic - Used. Set also when a caller didn't want it - should be
                 fixed.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
