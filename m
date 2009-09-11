Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZIKSOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZIKSOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZIKSOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:14:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33026 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZIKSO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:14:29 -0400
Date: Fri, 11 Sep 2009 20:14:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, tytso@mit.edu, akpm@linux-foundation.org,
       jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 3/4] writeback: only use bdi_writeback_all() for
	WB_SYNC_NONE writeout
Message-ID: <20090911181431.GN14984@kernel.dk>
References: <1252669832-13553-1-git-send-email-jens.axboe@oracle.com> <1252669832-13553-4-git-send-email-jens.axboe@oracle.com> <20090911180940.GC19598@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911180940.GC19598@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Christoph Hellwig wrote:
> > -static struct bdi_work *bdi_alloc_work(struct writeback_control *wbc)
> > +static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
> > +				 struct writeback_control *wbc)
> >  {
> >  	struct bdi_work *work;
> >  
> > @@ -195,7 +196,7 @@ static struct bdi_work *bdi_alloc_work(struct writeback_control *wbc)
> >  	if (work)
> >  		bdi_work_init(work, wbc);
> >  
> > -	return work;
> > +	bdi_queue_work(bdi, work);
> 
> This is now the only caller of bdi_queue_work that has a NULL work
> argument.  I would recommend removing the !work half of bdi_queue_work
> and just inline it into this function (or make it a separate helper).

Yep agreed.

> >  /*
> > + * Schedule writeback for all backing devices. Can only be used for
> > + * WB_SYNC_NONE writeback, WB_SYNC_ALL should use bdi_start_writeback()
> > + * and pass in the superblock.
> >   */
> >  static void bdi_writeback_all(struct writeback_control *wbc)
> >  {
> >  	struct backing_dev_info *bdi;
> >  
> > +	WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
> > +
> >  	spin_lock(&bdi_lock);
> >  
> >  	list_for_each_entry(bdi, &bdi_list, bdi_list) {
> >  		if (!bdi_has_dirty_io(bdi))
> >  			continue;
> >  
> > +		bdi_alloc_queue_work(bdi, wbc);
> >  	}
> 
> 
> Much nicer than before.  Could be even further simplified to:
> 
> 		if (bdi_has_dirty_io(bdi))
> 			bdi_alloc_queue_work(bdi, wbc);

Sure, matter of style.

> > @@ -1157,6 +1115,7 @@ long sync_inodes_sb(struct super_block *sb)
> >  {
> >  	struct writeback_control wbc = {
> >  		.sb		= sb,
> > +		.bdi		= sb->s_bdi,
> >  		.sync_mode	= WB_SYNC_ALL,
> >  		.range_start	= 0,
> >  		.range_end	= LLONG_MAX,
> > @@ -1164,7 +1123,7 @@ long sync_inodes_sb(struct super_block *sb)
> >  	long nr_to_write = LONG_MAX; /* doesn't actually matter */
> >  
> >  	wbc.nr_to_write = nr_to_write;
> > -	bdi_writeback_all(&wbc);
> > +	bdi_start_writeback(&wbc);
> 
> So here we have a WB_SYNC_ALL caller of bdi_writeback_all and the
> only other caller is WB_SYNC_NONE.  Given that after patch two those
> are entirely different codepathes in bdi_start_writeback I would just
> split bdi_start_writeback into two separate functions.

Sure, it'll draw a sharper line between WB_SYNC_NONE and WB_SYNC_ALL.
I'll work on this and the bdi cap dirty flag removal as a follow up.

-- 
Jens Axboe

