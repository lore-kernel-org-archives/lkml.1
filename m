Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZFCUr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZFCUr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZFCUrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:47:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbZFCUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:47:48 -0400
Date: Wed, 3 Jun 2009 13:47:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hifumi.hisashi@oss.ntt.co.jp,
       Jens Axboe <jens.axboe@oracle.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (readahead)
Message-Id: <20090603134739.97d8a461.akpm@linux-foundation.org>
In-Reply-To: <4A25F3FF.5060404@oracle.com>
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org>
	<4A25F3FF.5060404@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Jun 2009 20:54:39 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-06-02-16-11 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> readahead-add-blk_run_backing_dev.patch:
> 
> mm/readahead.c: In function 'page_cache_async_readahead':
> mm/readahead.c:559: error: implicit declaration of function 'blk_run_backing_dev'

hm, yeah, CONFIG_BLOCK=n.

Doing a block-specific call from inside page_cache_async_readahead() is
a bit of a layering violation - this may not be a block-backed
filesystem at all.

otoh, perhaps blk_run_backing_dev() is wrongly named and defined in the
wrong place.  Perhaps non-block-backed backing_devs want to implement
an unplug-style function too?  In which case the whole thing should be
renamed and moved outside blkdev.h.

If we don't want to do that, shouldn't backing_dev_info.unplug* be
wrapped in #ifdef CONFIG_BLOCK?  And wasn't it a layering violation to
put block-specific things into the backing_dev_info?

Jens, talk to me!

>From the readahead POV: does it make sense to call the backing-dev's
"unplug" function even if that isn't a block-based device?  Or was this
just a weird block-device-only performance problem?  Hard to say.
