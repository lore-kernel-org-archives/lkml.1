Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbYLLNvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbYLLNvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbYLLNvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:51:44 -0500
Received: from brick.kernel.dk ([93.163.65.50]:7161 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208AbYLLNvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:51:44 -0500
Date: Fri, 12 Dec 2008 14:51:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] loop: Do not call loop_unplug for not configured loop device.
Message-ID: <20081212135123.GY23742@kernel.dk>
References: <49426B2C.9070100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49426B2C.9070100@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12 2008, Milan Broz wrote:
> Do not call loop_unplug for not configured loop device.
> 
> In loop_unplug() function is expected that mapping is set
> and lo->lo_backing_file is not NULL.
> 
> Unfortunately loop_set_fd() set the request queue unplug function,
> but loop_clr_fd() doesn't clear that.
> 
> Loop device allows open of non-configured loop in some situations.
> If the unplug on request queue is called, loop module oopses because
> of missing lo_backing_file.
> 
> Simple reproducer:
> 	losetup /dev/loop0 /xxx
> 	losetup -d /dev/loop0
> 	dmsetup create x --table "0 1 linear /dev/loop0 0"
> 
>  EIP is at loop_unplug+0x1d/0x3b
>  ...
>   Call Trace:
>    blk_unplug+0x57/0x5e
>    dm_table_unplug_all+0x34/0x77 [dm_mod]
>    destroy_inode+0x27/0x38
>    generic_delete_inode+0xd5/0xd9
>    iput+0x4b/0x4e
>    dm_resume+0xca/0xfe [dm_mod]
>    dev_suspend+0x143/0x165 [dm_mod]
>    dm_ctl_ioctl+0x18e/0x1cf [dm_mod]
>    dev_suspend+0x0/0x165 [dm_mod]
>    dm_ctl_ioctl+0x0/0x1cf [dm_mod]
>    vfs_ioctl+0x22/0x69
>    do_vfs_ioctl+0x39d/0x3c7
>    trace_hardirqs_on+0xb/0xd
>    remove_vma+0x50/0x56
>    do_munmap+0x21c/0x237
>    sys_ioctl+0x2c/0x45
>    sysenter_do_call+0x12/0x31
> 
> Several reports here
> http://www.kerneloops.org/search.php?search=loop_unplug
> 
> Fix it by simply clear unplug function together with
> removing of backing file.
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  drivers/block/loop.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 90d19df..1e4b41e 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -919,6 +919,7 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
>  
>  	kthread_stop(lo->lo_thread);
>  
> +	lo->lo_queue->unplug_fn = NULL;
>  	lo->lo_backing_file = NULL;
>  
>  	loop_release_xfer(lo);
> 
> 

Thanks, applied.

-- 
Jens Axboe

