Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYKAUOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYKAUOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 16:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYKAUO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 16:14:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:10395 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYKAUO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 16:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=aLuothYa/fZKXezdSMQlT1uJ5nRlL/jFfmwUXmm1HbvvR4KYM4hRxfnB0qNQfVCBqQ
         qhHQiUYkxlqPSlw7f7WF5J5Ks0xs8BD0QeMWbWOxCol/7kmkLQJ7zNEj7Qw+aoP7tmPL
         QpCGdHPjivyiFkn82nFD8e1gi+CiNP+w+uJ18=
Date: Sat, 1 Nov 2008 21:14:20 +0100
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ide-floppy partitions
Message-ID: <20081101201419.GA29462@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	axboe@kernel.dk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20081029071319.GA9205@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029071319.GA9205@gollum.tnic>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 08:13:19AM +0100, Borislav Petkov wrote:
> Hi Tejun,
> 
> recent changes at 0762b8bde9729f10f8e6249809660ff2ec3ad735 and around
> break ide-floppy. Since it is a removable media drive and the partition
> scan during boot returns empty (no media in the drive), when you later
> put in a disk and try to mount it, mount returns saying
> 
> /dev/hdc4 is not a valid block device.
> 
> Which brings me to the other possible issue: Since having a hdc4
> partition as a single FAT16 partition on a ZIP drive is the "factory
> default" you could fabricate a case where you have a partition number> 1
> as the only partition on a hard drive too, i.e. no continuous
> partition numbering and the mount would theoretically fail there too
> since, for example, there's a check in disk_get_part() which does:
> 
> if (likely(partno < ptbl->len)) {
> 
> and in this case the check will fail if partno >= 1 while you have only
> one partition on the disk with a number higher than the partition table
> length and the above described failure will happen too. Anyways, this is
> just a hypothesis, but it happens with the ZIP drive here so other block
> devices should behave similarly.
> 
> Here's a patch that fixes the ide-floppy case a bit clumsily, I admit.
> 
> ---
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 88a776f..b798ea0 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1011,6 +1011,23 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  	disk = get_gendisk(bdev->bd_dev, &partno);
>  	if (!disk)
>  		goto out_unlock_kernel;
> +
> +	part = disk_get_part(disk, partno);
> +	if (!part) {
> +		struct block_device *whole;
> +
> +		mutex_lock_nested(&bdev->bd_mutex, for_part);
> +		whole = bdget_disk(disk, 0);
> +		ret = -ENOMEM;
> +		if (!whole)
> +			goto out_clear;
> +		ret = __blkdev_get(whole, mode, 1);
> +		if (ret)
> +			goto out_clear;
> +		bdev->bd_contains = whole;
> +		mutex_unlock(&bdev->bd_mutex);
> +	}
> +
>  	part = disk_get_part(disk, partno);
>  	if (!part)
>  		goto out_unlock_kernel;

Tejun, Jens,

can you guys please ACK/NACK this so that we can have an agreed upon solution
and so that I can stop applying it ontop of current git before testing any
further.

Thanks.

-- 
Regards/Gruss,
    Boris.
