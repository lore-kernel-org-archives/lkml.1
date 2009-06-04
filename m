Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZFDB7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZFDB7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 21:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZFDB7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 21:59:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:57840 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZFDB7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 21:59:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,301,1241420400"; 
   d="scan'208";a="150431796"
Date: Thu, 4 Jun 2009 09:59:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (readahead)
Message-ID: <20090604015904.GA13228@localhost>
References: <4A25F3FF.5060404@oracle.com> <20090603134739.97d8a461.akpm@linux-foundation.org> <20090604102144.084A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604102144.084A.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 09:25:37AM +0800, KOSAKI Motohiro wrote:
> > On Tue, 02 Jun 2009 20:54:39 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > akpm@linux-foundation.org wrote:
> > > > The mm-of-the-moment snapshot 2009-06-02-16-11 has been uploaded to
> > > > 
> > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > 
> > > > and will soon be available at
> > > > 
> > > >    git://git.zen-sources.org/zen/mmotm.git
> > > 
> > > 
> > > readahead-add-blk_run_backing_dev.patch:
> > > 
> > > mm/readahead.c: In function 'page_cache_async_readahead':
> > > mm/readahead.c:559: error: implicit declaration of function 'blk_run_backing_dev'
> > 
> > hm, yeah, CONFIG_BLOCK=n.
> > 
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
> More problematic.
> 
> The patch comment says 
> 
> +	/*
> +	* Normally the current page is !uptodate and lock_page() will be
> +	* immediately called to implicitly unplug the device. However this
> +	* is not always true for RAID conifgurations, where data arrives
> +	* not strictly in their submission order. In this case we need to
> +	* explicitly kick off the IO.
> 
> 
> However, hifumi-san's test result doesn't have IO reordering log.
> At least the comment is wrong. and We still don't know why nobody can
> reproduce his issue.

Right, as much as I believe the comment documents a legitimate case,
it does not actually explains hifumi's case.

Hifumi, can you help retest with some large readahead size?

Your readahead size (128K) is smaller than your max_sectors_kb (256K),
so two readahead IO requests get merged into one real IO, that means
half of the readahead requests are delayed.

The IO completion size goes down from 512 to 256 sectors:

before patch:
  8,0    3   177955    50.050313976     0  C   R 8724991 + 512 [0]
  8,0    3   177966    50.053380250     0  C   R 8725503 + 512 [0]
  8,0    3   177977    50.056970395     0  C   R 8726015 + 512 [0]
  8,0    3   177988    50.060326743     0  C   R 8726527 + 512 [0]
  8,0    3   177999    50.063922341     0  C   R 8727039 + 512 [0]

after patch:
  8,0    3   257297    50.000760847     0  C   R 9480703 + 256 [0]
  8,0    3   257306    50.003034240     0  C   R 9480959 + 256 [0]
  8,0    3   257307    50.003076338     0  C   R 9481215 + 256 [0]
  8,0    3   257323    50.004774693     0  C   R 9481471 + 256 [0]
  8,0    3   257332    50.006865854     0  C   R 9481727 + 256 [0]

Thanks,
Fengguang
