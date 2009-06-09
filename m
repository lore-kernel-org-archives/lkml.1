Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbZFIEid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbZFIEid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 00:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZFIEi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 00:38:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbZFIEiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 00:38:25 -0400
Date: Mon, 8 Jun 2009 21:38:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       hifumi.hisashi@oss.ntt.co.jp, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (readahead)
Message-Id: <20090608213817.999143dd.akpm@linux-foundation.org>
In-Reply-To: <20090609035915.GW11363@kernel.dk>
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org>
	<4A25F3FF.5060404@oracle.com>
	<20090603134739.97d8a461.akpm@linux-foundation.org>
	<20090609035915.GW11363@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 05:59:16 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> ...
> > Doing a block-specific call from inside page_cache_async_readahead() is
> > a bit of a layering violation - this may not be a block-backed
> > filesystem at all.
> > 
> > otoh, perhaps blk_run_backing_dev() is wrongly named and defined in the
> > wrong place.  Perhaps non-block-backed backing_devs want to implement
> > an unplug-style function too?  In which case the whole thing should be
> > renamed and moved outside blkdev.h.
> > 
> > If we don't want to do that, shouldn't backing_dev_info.unplug* be
> > wrapped in #ifdef CONFIG_BLOCK?  And wasn't it a layering violation to
> > put block-specific things into the backing_dev_info?
> > 
> > Jens, talk to me!
> > 
> > From the readahead POV: does it make sense to call the backing-dev's
> > "unplug" function even if that isn't a block-based device?  Or was this
> > just a weird block-device-only performance problem?  Hard to say.
> 
> Layering wise, I don't think it's that bad. It would have looked cleaner
> to do:
> 
>         blk_run_address_space(mapping);
> 
> instead, but we would still need to make that available outside of
> CONFIG_BLOCK as well.
> 
> What I don't like about the patch is that it's a heuristic, a "I poked
> this and it made that faster" with nobody really understanding why.

Well.  I _think_ we understand it.  I'm not sure that we understand why
it made scst faster though.

> And
> it's second guessing the block layer unplugging, so perhaps the real fix
> should be going on there. Or perhaps it's just fine and this micro
> optimization just helps this one case and that's great.
> 
> So ho humm, not terribly excited about it, but I guess we can shove it
> in there for testing. But lets please use blk_run_address_space() and
> add an empty stub for that.

But blk_anything() shouldn't be in the readahead code - readahead isn't
specific to block-based devices!

y:/usr/src/25> egrep "blk|block" mm/readahead.c 
#include <linux/blkdev.h>
 * block layer to abandon the readahead if request allocation would block.
 * force_page_cache_readahead() will ignore queue congestion and will block on
y:/usr/src/25> 


>From a layering POV we should have some mapping_start_io(address_space
*) which of course calls blk_run_address_space() if it's a block-backed
and calls <something else> if it's not block-backed.  Problem is, if
the backing device is, say, NFS then we have no reason to believe that
starting IO at this time is beneficial to NFS.

But sure, the world wouldn't end if we put a block-specific IO hint in
there.  It just isn't quite right.
