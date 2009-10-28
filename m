Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZJ1TdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZJ1TdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 15:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZJ1TdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 15:33:01 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36921 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbZJ1TdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 15:33:00 -0400
Date: Wed, 28 Oct 2009 20:33:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block fixes for 2.6.32-rc
Message-ID: <20091028193304.GV10727@kernel.dk>
References: <20091028185101.GS10727@kernel.dk> <alpine.LFD.2.01.0910281157160.31845@localhost.localdomain> <20091028191004.GU10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028191004.GU10727@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28 2009, Jens Axboe wrote:
> On Wed, Oct 28 2009, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 28 Oct 2009, Jens Axboe wrote:
> > > 
> > > Neil Brown (1):
> > >       block: use after free bug in __blkdev_get
> > >
> > > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > > index 9cf4b92..8bed055 100644
> > > --- a/fs/block_dev.c
> > > +++ b/fs/block_dev.c
> > > @@ -1248,8 +1248,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
> > >  			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
> > >  		}
> > >  	} else {
> > > -		put_disk(disk);
> > >  		module_put(disk->fops->owner);
> > > +		put_disk(disk);
> > >  		disk = NULL;
> > >  		if (bdev->bd_contains == bdev) {
> > >  			if (bdev->bd_disk->fops->open) {
> > 
> > Is this really right? You do the module-put while the disk is still 
> > available..
> > 
> > I get the feeling that it might have been better to do
> > 
> > 	struct module *mod = disk->fops->owner;
> > 	put_disk(disk);
> > 	module_put(mod);
> > 
> > instead, which tries to make sure that the module is put only after we've 
> > gotten rid of the disk entirely.
> > 
> > But I dunno. Maybe there is some reason why it's safe either way. You're 
> > sure the kobject_put() in put_disk will never call to the module?
> 
> Hmm good point. The general use case in block_dev.c is indeed to put the
> module after the disk, which does seem a bit backwards (at least
> logically). I'd say pull the patch since it fixes Neil's problem and
> follows the general pattern, then I'll investigate whether that use
> pattern is indeed safe. It wont make things worse and the current usage
> being fixed is definitely wrong.

So if I'm following the convoluted mazes of the kobjects correctly, the
release is disk_release() and it only does a free+release of the disk,
partition, and related partition table. So doing the module_put() before
the put_disk() is safe, even if it does look odd.

-- 
Jens Axboe

