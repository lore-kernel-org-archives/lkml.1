Return-Path: <linux-kernel-owner+w=401wt.eu-S1762701AbYEICPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762701AbYEICPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 22:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYEICPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 22:15:40 -0400
Received: from mail.suse.de ([195.135.220.2]:35138 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYEICPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 22:15:38 -0400
From: Neil Brown <neilb@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 May 2008 12:15:27 +1000
Message-ID: <18467.46015.146700.695469@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jacek Luczak <difrost.kernel@gmail.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
In-Reply-To: message from Dan Williams on Thursday May 8
References: <200805031151.44287.prakash@punnoor.de>
	<18462.46639.578272.994939@notabene.brown>
	<20080505190159.GA329@kernel.dk>
	<200805082039.01316.rjw@sisk.pl>
	<1210272379.9697.3.camel@dwillia2-linux.ch.intel.com>
	<1210288690.9697.14.camel@dwillia2-linux.ch.intel.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 8, dan.j.williams@intel.com wrote:
> On Thu, 2008-05-08 at 11:46 -0700, Dan Williams wrote:
> Subject: md: tell blk-core about device_lock for protecting the queue flags
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Now that queue flags are no longer atomic (commit:
> 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e) blk-core checks the queue is locked
> via ->queue_lock.  As noticed by Neil conf->device_lock already satisfies this
> requirement.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  drivers/md/linear.c         |    6 ++++++
>  drivers/md/multipath.c      |    6 ++++++
>  drivers/md/raid0.c          |    6 ++++++
>  drivers/md/raid1.c          |    7 ++++++-
>  drivers/md/raid10.c         |    7 ++++++-
>  drivers/md/raid5.c          |    2 ++
>  include/linux/raid/linear.h |    3 ++-
>  include/linux/raid/raid0.h  |    1 +
>  8 files changed, 35 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 0b85117..d026f08 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -122,6 +122,10 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
>  	cnt = 0;
>  	conf->array_size = 0;
>  
> +	spin_lock_init(&conf->device_lock);
> +	/* blk-core uses queue_lock to verify protection of the queue flags */
> +	mddev->queue->queue_lock = &conf->device_lock;
> +
>  	rdev_for_each(rdev, tmp, mddev) {
>  		int j = rdev->raid_disk;
>  		dev_info_t *disk = conf->disks + j;
> @@ -133,8 +137,10 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
>  
>  		disk->rdev = rdev;
>  
> +		spin_lock(&conf->device_lock);
>  		blk_queue_stack_limits(mddev->queue,
>  				       rdev->bdev->bd_disk->queue);
> +		spin_unlock(&conf->device_lock);
>  		/* as we don't honour merge_bvec_fn, we must never risk
>  		 * violating it, so limit ->max_sector to one PAGE, as
>  		 * a one page request is never in violation.

This shouldn't be necessary.
There is no actual race here -- mddev->queue->queue_flags is not going to be
accessed by anyone else until do_md_run does
	mddev->queue->make_request_fn = mddev->pers->make_request;
which is much later.
So we only need to be sure that "queue_is_locked" doesn't complain.
And as q->queue_lock is still NULL at this point, it won't complain.

I think that the *only* change that is needs is to put

> +	/* blk-core uses queue_lock to verify protection of the queue flags */
> +	mddev->queue->queue_lock = &conf->device_lock;

after each
> +	spin_lock_init(&conf->device_lock);

i.e. in raid1.c, raid10.c and raid5.c

??

NeilBrown
