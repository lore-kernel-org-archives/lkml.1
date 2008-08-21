Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYHUUNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYHUUNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYHUUNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:13:14 -0400
Received: from gw.goop.org ([64.81.55.164]:58422 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbYHUUNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:13:14 -0400
Message-ID: <48ADCC54.1000907@goop.org>
Date: Thu, 21 Aug 2008 13:13:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Xen: Fix warning when hot-unplugging virtual block devices
References: <48AD5373.201@citrix.com>
In-Reply-To: <48AD5373.201@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> From: Alex Nixon <alex.nixon@citrix.com>
> Date: Thu, 21 Aug 2008 12:30:54 +0100
> Subject: [PATCH] Xen: Fix warning when hot-unplugging virtual block devices
>
> WARNING: at kernel/softirq.c:136 local_bh_enable+0x3f/0x8a()
>
> del_gendisk needs IRQs enabled, as the code path eventually reaches local_bh_enable.
> blk_stop_queue needs them disabled - so do so temporarily.
>
> It shouldn't matter if an interrupt comes in whilst blkif_io_lock is held, as it will block on the lock.  Upon acquisition, it'll realise the device is down and exit cleanly.
>
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
>   
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Send a clean copy to Jens with my ack.

    J
> ---
>  drivers/block/xen-blkfront.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index d5e7532..95cee2c 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -899,16 +899,18 @@ static void blkfront_closing(struct xenbus_device *dev)
>  	if (info->rq == NULL)
>  		goto out;
>  
> -	spin_lock_irqsave(&blkif_io_lock, flags);
> +	spin_lock(&blkif_io_lock);
>  
>  	del_gendisk(info->gd);
>  
> +	local_irq_save(flags);
>  	/* No more blkif_request(). */
>  	blk_stop_queue(info->rq);
> +	local_irq_restore(flags);
>  
>  	/* No more gnttab callback work. */
>  	gnttab_cancel_free_callback(&info->callback);
> -	spin_unlock_irqrestore(&blkif_io_lock, flags);
> +	spin_unlock(&blkif_io_lock);
>  
>  	/* Flush gnttab callback work. Must be done with no locks held. */
>  	flush_scheduled_work();
>   

