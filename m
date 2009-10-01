Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbZJAVfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbZJAVfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZJAVfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:35:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:41265 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbZJAVfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:35:21 -0400
Date: Thu, 1 Oct 2009 23:35:23 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20091001213523.GA21982@duck.suse.cz>
References: <20090909142315.GA7949@duck.suse.cz> <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz> <20090924083342.GA15918@localhost> <20090929173506.GE11573@duck.suse.cz> <20090930012406.GB6311@localhost> <20090930115539.GA16074@duck.suse.cz> <20091001133610.GA7228@localhost> <20091001142243.GD24027@duck.suse.cz> <20091001145443.GA9469@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001145443.GA9469@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-10-09 22:54:43, Wu Fengguang wrote:
> > > >   You probably didn't understand my comment in the previous email. This is
> > > > too late to wakeup all the tasks. There are two limits - background_limit
> > > > (set to 5%) and dirty_limit (set to 10%). When amount of dirty data is
> > > > above background_limit, we start the writeback but we don't throttle tasks
> > > > yet. We start throttling tasks only when amount of dirty data on the bdi
> > > > exceeds the part of the dirty limit belonging to the bdi. In case of a
> > > > single bdi, this means we start throttling threads only when 10% of memory
> > > > is dirty. To keep this behavior, we have to wakeup waiting threads as soon
> > > > as their BDI gets below the dirty limit or when global number of dirty
> > > > pages gets below (background_limit + dirty_limit) / 2.
> > > 
> > > Sure, but the design goal is to wakeup the throttled tasks in the
> > > __bdi_writeout_inc() path instead of here. As long as some (background)
> > > writeback is running, __bdi_writeout_inc() will be called to wakeup
> > > the tasks.  This "unthrottle all on exit of background writeback" is
> > > merely a safeguard, since once background writeback (which could be
> > > queued by the throttled task itself, in bdi_writeback_wait) exits, the
> > > calls to __bdi_writeout_inc() is likely to stop.
> >   The thing is: In the old code, tasks returned from balance_dirty_pages()
> > as soon as we got below dirty_limit, regardless of how much they managed to
> > write. So we want to wake them up from waiting as soon as we get below the
> > dirty limit (maybe a bit later so that they don't immediately block again
> > but I hope you get the point).
> 
> Ah good catch!  However overhitting the threshold by 1MB (maybe more with
> concurrent dirtiers) should not be a problem. As you said, that avoids the
> task being immediately blocked again.
> 
> The old code does the dirty_limit check in an opportunistic manner. There were
> no guarantee. 2.6.32 further weakens it with the removal of congestion back off.
  Sure, there are no guarantees but if we let threads sleep in
balance_dirty_pages longer than necessary it will have a performance impact
(application will sleep instead of doing useful work). So we should better
make sure applications sleep as few as necessary in balance_dirty_pages.

> @@ -756,8 +811,11 @@ static long wb_writeback(struct bdi_writ
>  		 * For background writeout, stop when we are below the
>  		 * background dirty threshold
>  		 */
> -		if (args->for_background && !over_bground_thresh())
> +		if (args->for_background && !over_bground_thresh()) {
> +			while (bdi_writeback_wakeup(wb->bdi))
> +				;  /* unthrottle all tasks */
>  			break;
> +		}
  Thus the check here should rather be
if (args->for_background && !over_dirty_limit())

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
