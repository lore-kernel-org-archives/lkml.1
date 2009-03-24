Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbZCXLao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbZCXLao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZCXLaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:30:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40669 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbZCXLae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:30:34 -0400
Date: Tue, 24 Mar 2009 12:30:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: zdenek.kabelac@gmail.com, bunk@kernel.org, jirislaby@gmail.com,
       hidave.darkstar@gmail.com, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, nikanth@gmail.com
Subject: Re: [PATCH] Fix Bug 10504 - losetup possible circular locking
Message-ID: <20090324113032.GK27476@kernel.dk>
References: <200903121341.13173.knikanth@suse.de> <200903241122.32599.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903241122.32599.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24 2009, Nikanth Karthikesan wrote:
> Hi Jens
> 
> Did you get to look at this? Can you ACK/NACK this one?

It looks fine, I have applied it.

> 
> Thanks
> Nikanth
> 
> On Thursday 12 March 2009 13:41:12 Nikanth Karthikesan wrote:
> > With CONFIG_PROVE_LOCKING enabled
> >
> > $ losetup /dev/loop0 file
> > $ losetup -o 32256 /dev/loop1 /dev/loop0
> >
> > $ losetup -d /dev/loop1
> > $ losetup -d /dev/loop0
> >
> > triggers a [ INFO: possible circular locking dependency detected ]
> >
> > I think this warning is a false positive.
> >
> > Open/close on a loop device acquires bd_mutex of the device before
> > acquiring lo_ctl_mutex of the same device. For ioctl(LOOP_CLR_FD) after
> > acquiring lo_ctl_mutex, fput on the backing_file might acquire the bd_mutex
> > of a device, if backing file is a device and this is the last reference to
> > the file being dropped . But it is guaranteed that it is impossible to have
> > a circular list of backing devices.(say loop2->loop1->loop0->loop2 is not
> > possible), which guarantees that this can never deadlock.
> >
> > So this warning should be suppressed. It is very difficult to annotate
> > lockdep not to warn here in the correct way. A simple way to silence
> > lockdep could be to mark the lo_ctl_mutex in ioctl to be a sub class, but
> > this might mask some other real bugs.
> >
> > --- a/drivers/block/loop.c
> > +++ b/drivers/block/loop.c
> > @@ -1164,7 +1164,7 @@ static int lo_ioctl(struct block_device *bdev,
> > fmode_t mode, struct loop_device *lo = bdev->bd_disk->private_data;
> >  	int err;
> >
> > -	mutex_lock(&lo->lo_ctl_mutex);
> > +	mutex_lock_nested(&lo->lo_ctl_mutex, 1);
> >  	switch (cmd) {
> >  	case LOOP_SET_FD:
> >  		err = loop_set_fd(lo, mode, bdev, arg);
> >
> > Or actually marking the bd_mutex after lo_ctl_mutex as a sub class could be
> > a better solution.
> >
> > Luckily it is easy to avoid calling fput on backing file with lo_ctl_mutex
> > held, so no lockdep annotation is required.
> >
> > If you do not like the special handling of the lo_ctl_mutex just for the
> > LOOP_CLR_FD ioctl in lo_ioctl(), the mutex handling could be moved inside
> > each of the individual ioctl handlers and I could send you another patch.
> >
> > Thanks
> > Nikanth Karthikesan
> >
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> >
> > ---
> >
> > Fix Bug 10504 - losetup possible circular locking
> >
> > Avoid triggering a circular dependency warning by calling fput on the
> > backing file with lo_ctl_mutex held. If the backing file is a device, fput
> > might try to acquire bd_mutex of a that device which triggers a circular
> > dependency warning.
> >
> > diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> > index edbaac6..5588f67 100644
> > --- a/drivers/block/loop.c
> > +++ b/drivers/block/loop.c
> > @@ -942,11 +942,18 @@ static int loop_clr_fd(struct loop_device *lo, struct
> > block_device *bdev) bd_set_size(bdev, 0);
> >  	mapping_set_gfp_mask(filp->f_mapping, gfp);
> >  	lo->lo_state = Lo_unbound;
> > -	fput(filp);
> >  	/* This is safe: open() is still holding a reference. */
> >  	module_put(THIS_MODULE);
> >  	if (max_part > 0)
> >  		ioctl_by_bdev(bdev, BLKRRPART, 0);
> > +	mutex_unlock(&lo->lo_ctl_mutex);
> > +	/*
> > +	 * Need not hold lo_ctl_mutex to fput backing file.
> > +	 * Calling fput holding lo_ctl_mutex triggers a circular
> > +	 * lock dependency possibility warning as fput can take
> > +	 * bd_mutex which is usually taken before lo_ctl_mutex.
> > +	 */
> > +	fput(filp);
> >  	return 0;
> >  }
> >
> > @@ -1173,7 +1180,10 @@ static int lo_ioctl(struct block_device *bdev,
> > fmode_t mode, err = loop_change_fd(lo, bdev, arg);
> >  		break;
> >  	case LOOP_CLR_FD:
> > +		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
> >  		err = loop_clr_fd(lo, bdev);
> > +		if (!err)
> > +			goto out_unlocked;
> >  		break;
> >  	case LOOP_SET_STATUS:
> >  		err = loop_set_status_old(lo, (struct loop_info __user *) arg);
> > @@ -1191,6 +1201,8 @@ static int lo_ioctl(struct block_device *bdev,
> > fmode_t mode, err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
> >  	}
> >  	mutex_unlock(&lo->lo_ctl_mutex);
> > +
> > +out_unlocked:
> >  	return err;
> >  }
> 
> 

-- 
Jens Axboe

