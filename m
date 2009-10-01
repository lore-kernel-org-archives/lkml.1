Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZJAPRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZJAPRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZJAPRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:17:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:8154 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbZJAPRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:17:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,488,1249282800"; 
   d="scan'208";a="193993956"
Date: Thu, 1 Oct 2009 23:17:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20091001151723.GA8028@localhost>
References: <1252432501.7746.156.camel@twins> <1252434746.7035.7.camel@laptop> <20090909142315.GA7949@duck.suse.cz> <1252597750.7205.82.camel@laptop> <20090914111721.GA24075@duck.suse.cz> <20090924083342.GA15918@localhost> <20090929173506.GE11573@duck.suse.cz> <20090930012406.GB6311@localhost> <20090930115539.GA16074@duck.suse.cz> <20090930121029.GA14918@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930121029.GA14918@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 08:10:30PM +0800, Jens Axboe wrote:
> On Wed, Sep 30 2009, Jan Kara wrote:
> > > +void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages)
> > > +{
> > > +	struct dirty_throttle_task tt = {
> > > +		.nr_pages = nr_pages,
> > > +		.complete = COMPLETION_INITIALIZER_ONSTACK(tt.complete),
> > > +	};
> > > +	struct wb_writeback_args args = {
> > > +		.sync_mode	= WB_SYNC_NONE,
> > > +		.nr_pages	= LONG_MAX,
> > > +		.range_cyclic	= 1,
> > > +		.for_background	= 1,
> > > +	};
> > > +	struct bdi_work work;
> > > +
> > > +	bdi_work_init(&work, &args);
> > > +	work.state |= WS_ONSTACK;
> > > +
> > > +	/*
> > > +	 * make sure we will be waken up by someone
> > > +	 */
> > > +	bdi_queue_work(bdi, &work);
> >   This is wrong, you shouldn't submit the work like this because you'll
> > have to wait for completion (wb_clear_pending below is just bogus). You
> > should rather do bdi_start_writeback(bdi, NULL, 0).
> 
> Indeed, the above will die a horrible death fairly soon. But we can add
> some "barrier" like synchronization, if you just wish to wait for
> previously submitted work to have been completed.

Thanks, I just purged that hack and go for bdi_start_writeback :)

Thanks,
Fengguang

