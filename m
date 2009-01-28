Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZA1J1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZA1J1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZA1J1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:27:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38509 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZA1J1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:27:20 -0500
Date: Wed, 28 Jan 2009 10:27:10 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 1/1] PM/Hibernate: fix "swap breaks after hibernation
	failures"
Message-ID: <20090128092709.GA27210@elf.ucw.cz>
References: <200901272317.43512.rjw@sisk.pl> <200901272319.00102.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901272319.00102.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-27 23:18:59, Rafael J. Wysocki wrote:
> From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12239
> 
> The image writing code dropped a reference to the current swap device.
> This doesn't show up if the hibernation succeeds - because it doesn't
> affect the image which gets resumed.  But it means multiple _failed_
> hibernations end up freeing the swap device while it is still use!
> 
> swsusp_write() finds the block device for the swap file using swap_type_of().
> It then uses blkdev_get() / blkdev_put() to open and close the block device.
> 
> Unfortunately, blkdev_get() assumes ownership of the inode of the block_device
> passed to it.  So blkdev_put() calls iput() on the inode.  This is by design
> and other callers expect this behaviour.  The fix is for swap_type_of() to take
> a reference on the inode using bdget().
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <pavel@suse.cz>

> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index f48b831..7740478 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -635,7 +635,7 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
>  
>  		if (!bdev) {
>  			if (bdev_p)
> -				*bdev_p = sis->bdev;
> +				*bdev_p = bdget(sis->bdev->bd_dev);
>  
>  			spin_unlock(&swap_lock);
>  			return i;
> @@ -647,7 +647,7 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
>  					struct swap_extent, list);
>  			if (se->start_block == offset) {
>  				if (bdev_p)
> -					*bdev_p = sis->bdev;
> +					*bdev_p = bdget(sis->bdev->bd_dev);
>  
>  				spin_unlock(&swap_lock);
>  				bdput(bdev);
> 
> 
> 
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
