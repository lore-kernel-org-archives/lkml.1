Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZESR4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZESR4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZESR4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:56:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58422 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZESR4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:56:46 -0400
Date: Tue, 19 May 2009 19:56:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       peterz@infradead.org
Subject: Re: [PATCH 02/11] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090519175646.GF4140@kernel.dk>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242649192-16263-3-git-send-email-jens.axboe@oracle.com> <4A1287FC.9020401@rsk.demon.co.uk> <20090519122324.GY4140@kernel.dk> <1242740758.2754.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242740758.2754.33.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19 2009, Richard Kennedy wrote:
> On Tue, 2009-05-19 at 14:23 +0200, Jens Axboe wrote:
> > On Tue, May 19 2009, Richard Kennedy wrote:
> > > Jens Axboe wrote:
> > > > This gets rid of pdflush for bdi writeout and kupdated style cleaning.
> > > > <snip>
> > > > index 2296ff4..76269f8 100644
> > > > --- a/mm/page-writeback.c
> > > > +++ b/mm/page-writeback.c
> > > > @@ -541,7 +530,7 @@ static void balance_dirty_pages(struct address_space *mapping)
> > > >  		 * been flushed to permanent storage.
> > > >  		 */
> > > >  		if (bdi_nr_reclaimable) {
> > > > -			writeback_inodes(&wbc);
> > > > +			generic_sync_bdi_inodes(NULL, &wbc);
> > > >  			pages_written += write_chunk - wbc.nr_to_write;
> > > >  			get_dirty_limits(&background_thresh, &dirty_thresh,
> > > >  				       &bdi_thresh, bdi);
> > > > @@ -592,7 +581,7 @@ static void balance_dirty_pages(struct address_space *mapping)
> > > >  			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
> > > >  					  + global_page_state(NR_UNSTABLE_NFS)
> > > >  					  > background_thresh)))
> > > > -		pdflush_operation(background_writeout, 0);
> > > > +		bdi_start_writeback(bdi, NULL, 0);
> > > >  }
> > > >  
> > > Hi Jens,
> > > 
> > > I'm interested in this slight change of behaviour, when over the
> > > background dirty limit background_writeout will write any dirty pages
> > > while bdi_start_writeout writes only pages for the current bdi. Are
> > > there any benefits in making this change?
> > > 
> > > Thinking about the case of 2 apps writing to different bdis. When app A
> > > stops writing, then next time app B goes over the background dirty
> > > threshold it will only be able to write its own pages, leaving any from
> > > app A dirty until they reach their age limit.
> > 
> > The function in question balances dirty pages against a specific address
> > space, which has a specific mapping. The async part of the background
> > writeout could be global as you mention. The whole thing is a bit weird
> > in balance_dirty_pages(), for instance it checks for writeout against a
> > given queue then proceeds to do a global writeout if not busy. At least
> > it's consistent now.
> > 
> > > So we may be keeping dirty pages for the app that's finished longer than
> > > necessary. Keeping pages for a finished app while flushing pages from a
> > > running app seems a bit strange. I guess this is an odd corner case and
> > > may not be worth worrying about, but I'd be interested to hear what you
> > > think.
> > 
> > The kupdated() initiated background writeout will take care of that, if
> > nobody does a sync on that data first. If nobody is dirtying new data on
> > the given bdi, then it seems perfectly fine to let normal background
> > writeout handle it.
> > 
> > > Do you think your new code will require any changes to the per bdi dirty
> > > limits? It may be informative & interesting to run some tests writing to
> > > fast & slow devices at the same time.
> > 
> > Generally the code should behave fairly closely to the existing pdflush
> > based code, so I don't think bdi dirty limit tweaking will be necessary.
> > I'd definitely welcome some testing though, particularly slow vs fast as
> > you mention. I've mainly been doing benchmarking to make sure we don't
> > regress on performance, and that has been for fairly similar hardware.
> > Since testing does take a lot of time, it would be nice if someone else
> > would gather their own experiences, especially in areas that have been
> > problematic in the past (slow vs fast devices, for instance!).
> 
> Thanks for the explanation.
> I'm definitely going to test this, although I don't have any interesting
> hardware, only a basic workstation. But I'll let you know if I turn up
> anything useful.

Any testing is useful, so go for it.

> Balance_dirty_pages contains Peter Zijlstra's per bdi write throttling
> code and I wonder if it will need tuning for best performance with your
> changes, just because some of its assumptions may have changed. I'll run
> some tests here and see what happens. Peter may have some insight and
> possibly useful test cases.

I'm assuming those are setting in -mm? I'll take a look.

-- 
Jens Axboe

