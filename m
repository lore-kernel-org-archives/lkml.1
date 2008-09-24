Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYIXCq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYIXCq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 22:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYIXCqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 22:46:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:54840 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYIXCqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 22:46:11 -0400
From: Neil Brown <neilb@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 24 Sep 2008 12:46:08 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18649.43504.157272.351801@notabene.brown>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: Add support for data integrity to MD
In-Reply-To: message from Martin K. Petersen on Saturday September 20
References: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday September 20, martin.petersen@oracle.com wrote:
> 
> If all subdevices support the same protection format the MD device is
> flagged as capable.

But what if we subsequently add a different device to that array which
uses a different protection format.   Would we be able to tell the
filesystem that integrity protection isn't available any more?
Or can we detect if the filesystem is using integrity protection, and
reject the new device if it doesn't match?

In either case, some extra handling is needed in bind_rdev_to_array.

NeilBrown


> 
> Depends on d7533ad0e132f92e75c1b2eb7c26387b25a583c1 being reverted.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/md/md.c |   32 +++++++++++++++++++++++++++++++-
>  1 files changed, 31 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 45521da..b038581 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3497,7 +3497,7 @@ static int do_md_run(mddev_t * mddev)
>  	int err;
>  	int chunk_size;
>  	struct list_head *tmp;
> -	mdk_rdev_t *rdev;
> +	mdk_rdev_t *rdev, *prev;
>  	struct gendisk *disk;
>  	struct mdk_personality *pers;
>  	char b[BDEVNAME_SIZE];
> @@ -3759,6 +3759,35 @@ static int do_md_run(mddev_t * mddev)
>  	sysfs_notify(&mddev->kobj, NULL, "sync_action");
>  	sysfs_notify(&mddev->kobj, NULL, "degraded");
>  	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +
> +	/* Data integrity passthrough not supported on RAID 4, 5 and 6 */
> +	if (pers->level >= 4 && pers->level <= 6)
> +		return 0;
> +
> +	prev = NULL;
> +
> +	rdev_for_each(rdev, tmp, mddev) {
> +
> +		if (prev && blk_integrity_compare(prev->bdev, rdev->bdev) < 0) {
> +			printk(KERN_ERR "%s: %s %s Integrity mismatch!\n",
> +			       __func__, prev->bdev->bd_disk->disk_name,
> +			       rdev->bdev->bd_disk->disk_name);
> +			return 0;
> +		}
> +
> +		prev = rdev;
> +	}
> +
> +	if (prev && bdev_get_integrity(prev->bdev)) {
> +
> +		if (blk_integrity_register(disk, prev->bdev->bd_disk->integrity))
> +			printk(KERN_ERR "%s: %s Could not register integrity!\n",
> +			       __func__, disk->disk_name);
> +		else
> +			printk(KERN_INFO "Enabling data integrity on %s\n",
> +			       disk->disk_name);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -3947,6 +3976,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
>  		printk(KERN_INFO "md: %s switched to read-only mode.\n",
>  			mdname(mddev));
>  	err = 0;
> +	blk_integrity_unregister(disk);
>  	md_new_event(mddev);
>  	sysfs_notify(&mddev->kobj, NULL, "array_state");
>  out:
> -- 
> 1.5.5.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
