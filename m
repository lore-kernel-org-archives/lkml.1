Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZHaR3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZHaR3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZHaR3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:29:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37900 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbZHaR3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:29:10 -0400
Date: Mon, 31 Aug 2009 19:29:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 02/10] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090831172912.GW12579@kernel.dk>
References: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com> <1251720891-19793-3-git-send-email-jens.axboe@oracle.com> <20090831125840.GA20465@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831125840.GA20465@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31 2009, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 02:14:43PM +0200, Jens Axboe wrote:
> > -static void generic_sync_bdi_inodes(struct backing_dev_info *bdi,
> > -				    struct writeback_control *wbc,
> > -				    struct super_block *sb,
> > -				    int is_blkdev_sb)
> > +void generic_sync_bdi_inodes(struct super_block *sb,
> > +			     struct writeback_control *wbc)
> 
> I think we're better off having the sb also in the writeback control.
> Now that the inodes actually hang off the backing device it's just
> another parameter to limit the amount of writeback done.

Sure no problem, I'll shove that in there.

> > +		/*
> > +		 * If this fs is currently being u/remounted, leave the
> > +		 * inode alone
> > +		 */
> > +		if (!down_read_trylock(&inode->i_sb->s_umount)) {
> > +			requeue_io(inode);
> > +			continue;
> > +		}
> 
> This looks correct to me, but I wonder if the increased traffic on
> s_umount will hurt us in some way for the writeback of lots of small
> files.

I didn't spot anything today, but I didn't have that many files in
flight (lots of cpus, though). But yes, something to keep an eye on.

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
> 
> With the sb in writeback_control this gem would also be gone.

Yeah :)

> Btw, some ordering in the patch series seems odd, e.g. you have 
> most of the high level flushing code above generic_sync_wb_inodes
> which makes reading fs-writeback.c rather inconvenient.  And also
> leads to having two forward declarations for generic_sync_wb_inodes
> beeing added inside the file.

OK, will look into cleaning that up.

-- 
Jens Axboe

