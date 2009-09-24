Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZIXPi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZIXPi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZIXPi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:38:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZIXPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:38:25 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <20090924083342.GA15918@localhost>
References: <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think>
	 <1252428983.7746.140.camel@twins> <20090908172842.GC2975@think>
	 <1252431974.7746.151.camel@twins> <1252432501.7746.156.camel@twins>
	 <1252434746.7035.7.camel@laptop> <20090909142315.GA7949@duck.suse.cz>
	 <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz>
	 <20090924083342.GA15918@localhost>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 17:38:16 +0200
Message-Id: <1253806696.18939.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 16:33 +0800, Wu Fengguang wrote:

> Yeah, FIFO queuing should be good enough.
> 
> I'd like to propose one more data structure for evaluation :)
> 
> - bdi->throttle_lock
> - bdi->throttle_list    pages to sync for each waiting task, taken from sync_writeback_pages()
> - bdi->throttle_pages   (counted down) pages to sync for the head task, shall be atomic_t
> 
> In balance_dirty_pages(), it would do
> 
>         nr_to_sync = sync_writeback_pages()
>         if (list_empty(bdi->throttle_list))  # I'm the only task
>                 bdi->throttle_pages = nr_to_sync
>         append nr_to_sync to bdi->throttle_list
>         kick off background writeback
>         wait
>         remove itself from bdi->throttle_list and wait list
>         set bdi->throttle_pages for new head task (or LONG_MAX)
> 
> In __bdi_writeout_inc(), it would do
> 
>         if (--bdi->throttle_pages <= 0)
>                 check and wake up head task
> 
> In wb_writeback(), it would do
> 
>         if (args->for_background && exiting)
>                 wake up all throttled tasks
> 
> To prevent wake up too many tasks at the same time, it can relax the
> background threshold a bit, so that __bdi_writeout_inc() become the
> only wake up point in normal cases.
> 
>         if (args->for_background && !list_empty(bdi->throttle_list) &&
>                 over background_thresh - background_thresh / 32)
>                 keep write pages;

Right, something like that ought to work well, or at least sounds like
worth a try ;-)

