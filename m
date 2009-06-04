Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZFDBZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZFDBZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 21:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZFDBZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 21:25:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34145 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZFDBZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 21:25:39 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (readahead)
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, hifumi.hisashi@oss.ntt.co.jp,
       Jens Axboe <jens.axboe@oracle.com>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090603134739.97d8a461.akpm@linux-foundation.org>
References: <4A25F3FF.5060404@oracle.com> <20090603134739.97d8a461.akpm@linux-foundation.org>
Message-Id: <20090604102144.084A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  4 Jun 2009 10:25:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

More problematic.

The patch comment says 

+	/*
+	* Normally the current page is !uptodate and lock_page() will be
+	* immediately called to implicitly unplug the device. However this
+	* is not always true for RAID conifgurations, where data arrives
+	* not strictly in their submission order. In this case we need to
+	* explicitly kick off the IO.


However, hifumi-san's test result doesn't have IO reordering log.
At least the comment is wrong. and We still don't know why nobody can
reproduce his issue.




