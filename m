Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbZE0Ryz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbZE0Ryz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764082AbZE0RuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:50:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57185 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764013AbZE0RuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:50:19 -0400
Date: Wed, 27 May 2009 19:50:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 04/11] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090527175019.GN11363@kernel.dk>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <1243417312-7444-5-git-send-email-jens.axboe@oracle.com> <20090527151452.GI16006@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527151452.GI16006@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27 2009, Jan Kara wrote:
>   The patch set seems easier to read now. Thanks for cleaning it up.

No problem. The issue is mainly that I have to maintain these
intermediate steps, and as code gets added and bugs fixed, things have
to be shuffled back and forth. Now that things are stabilizing more,
it's easier.

> > +void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
> > +{
> > +	struct backing_dev_info *bdi, *tmp;
> > +
> > +	mutex_lock(&bdi_lock);
> > +
> > +	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
> > +		if (!bdi_has_dirty_io(bdi))
> > +			continue;
> > +		bdi_start_writeback(bdi, sb, wbc->nr_to_write, wbc->sync_mode);
> > +	}
> > +
> > +	mutex_unlock(&bdi_lock);
> > +}
> > +
>   Looking at this function, I've realized that wbc->nr_to_write has a bit
> silly meaning here. Each BDI will be kicked to write nr_to_write pages
> which is not what it used to mean originally. I don't think it really matters
> but we should have this in mind...

Yes, I know about that difference. I don't think it matters a whole lot,
since we typically just use MAX_WRITEBACK_PAGES which is only 4MB of IO.
And in the case of writing back the world, we'll just come short on each
bdi.

> > @@ -591,13 +715,10 @@ static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> >  void generic_sync_sb_inodes(struct super_block *sb,
> >  				struct writeback_control *wbc)
> >  {
> > -	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
> > -	struct backing_dev_info *bdi;
> > -
> > -	mutex_lock(&bdi_lock);
> > -	list_for_each_entry(bdi, &bdi_list, bdi_list)
> > -		generic_sync_bdi_inodes(bdi, wbc, sb, is_blkdev_sb);
> > -	mutex_unlock(&bdi_lock);
> > +	if (wbc->bdi)
> > +		generic_sync_bdi_inodes(sb, wbc);
> > +	else
> > +		bdi_writeback_all(sb, wbc);
>   I guess this asynchronousness is just transient...

Right, if it bothers you, I can fix that up too :-)

> > +static int bdi_forker_task(void *ptr)
> > +{
> > +	struct backing_dev_info *me = ptr;
> > +	DEFINE_WAIT(wait);
> > +
> > +	for (;;) {
> > +		struct backing_dev_info *bdi, *tmp;
> > +
> > +		/*
> > +		 * Do this periodically, like kupdated() did before.
> > +		 */
> > +		sync_supers();
>   Ugh, this looks nasty. Moreover I'm afraid of forker_task() getting stuck
> (and thus not being able to start new threads) in sync_supers() when some
> fs is busy and other needs to create flusher thread...
>   Why not just having a separate thread for this? I know we have lots of
> kernel threads already but this one seems like a useful one... Or do you
> plan getting rid of this completely sometime in the near future and sync
> supers also from per-bdi thread (which would make a lot of sence to me)?

It's ugly, and I think this is precisely what Ted hit. He's in umount,
has ->s_umount sem held and waiting for IO.

So there's definitely trouble brewing there. As a short term solution, a
separate thread will do. Longer term, the sync_supers_bdi() type setup I
mentioned earlier would probably be the best. But once we start dealing
with the super blocks, we have to be more careful with referencing.
Which we also discussed in a previous mail :-)

-- 
Jens Axboe

