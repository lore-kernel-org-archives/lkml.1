Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZFID7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZFID7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZFID7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:59:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34226 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZFID7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:59:14 -0400
Date: Tue, 9 Jun 2009 05:59:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       hifumi.hisashi@oss.ntt.co.jp, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (readahead)
Message-ID: <20090609035915.GW11363@kernel.dk>
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org> <4A25F3FF.5060404@oracle.com> <20090603134739.97d8a461.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603134739.97d8a461.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03 2009, Andrew Morton wrote:
> On Tue, 02 Jun 2009 20:54:39 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2009-06-02-16-11 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > 
> > readahead-add-blk_run_backing_dev.patch:
> > 
> > mm/readahead.c: In function 'page_cache_async_readahead':
> > mm/readahead.c:559: error: implicit declaration of function 'blk_run_backing_dev'
> 
> hm, yeah, CONFIG_BLOCK=n.
> 
> Doing a block-specific call from inside page_cache_async_readahead() is
> a bit of a layering violation - this may not be a block-backed
> filesystem at all.
> 
> otoh, perhaps blk_run_backing_dev() is wrongly named and defined in the
> wrong place.  Perhaps non-block-backed backing_devs want to implement
> an unplug-style function too?  In which case the whole thing should be
> renamed and moved outside blkdev.h.
> 
> If we don't want to do that, shouldn't backing_dev_info.unplug* be
> wrapped in #ifdef CONFIG_BLOCK?  And wasn't it a layering violation to
> put block-specific things into the backing_dev_info?
> 
> Jens, talk to me!
> 
> From the readahead POV: does it make sense to call the backing-dev's
> "unplug" function even if that isn't a block-based device?  Or was this
> just a weird block-device-only performance problem?  Hard to say.

Layering wise, I don't think it's that bad. It would have looked cleaner
to do:

        blk_run_address_space(mapping);

instead, but we would still need to make that available outside of
CONFIG_BLOCK as well.

What I don't like about the patch is that it's a heuristic, a "I poked
this and it made that faster" with nobody really understanding why. And
it's second guessing the block layer unplugging, so perhaps the real fix
should be going on there. Or perhaps it's just fine and this micro
optimization just helps this one case and that's great.

So ho humm, not terribly excited about it, but I guess we can shove it
in there for testing. But lets please use blk_run_address_space() and
add an empty stub for that.

-- 
Jens Axboe

