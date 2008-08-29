Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYH2HFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYH2HFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYH2HFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:05:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53081 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbYH2HFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:05:19 -0400
Date: Fri, 29 Aug 2008 09:05:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for August 27
Message-ID: <20080829070515.GL20055@kernel.dk>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com> <200808272145.20627.bzolnier@gmail.com> <200808290210.37211.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808290210.37211.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> [ Thanks to Ingo for handling x86-vs-UP build fix ]
> 
> On Wednesday 27 August 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> [...]
> 
> > However now I'm getting device-mapper errors on 'cryptsetup create':
> > 
> > dmesg:
> > ...
> > device-mapper: core: bdget failed in dm_suspend
> > device-mapper: ioctl: device doesn't appear to be in the dev hash table.
> > ...
> > 
> > cryptsetup:
> > ...
> > Command failed: device-mapper: resume ioctl failed: Invalid argument
> > ...
> > 
> > next-20080826 is fine
> 
> next-20080828 still isn't, The Lucky Winner is:
> 
> commit 9617fc8f8e599166590fe339de78a50bc5ab5e93
> Author: Tejun Heo <tj@kernel.org>
> Date:   Mon Aug 25 19:56:08 2008 +0900
> 
>     block: move __dev from disk to part0
> 
>     Move disk->__dev to part0->__dev.  This simplifies bdget_disk() and
>     lookup_devt() and allows common sysfs attributes to be unified.
>     part_to_disk() is updated to handle part0 -> disk.
> 
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Fix:
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] block: fix part0 handling in bdget_disk() / blk_lookup_devt()
> 
> part0 is a "special" partition and doesn't need to have capacity set - this
> fixes regression caused by "block: move __dev from disk to part0" commit.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Jens, please integrate it into the original commit if feasible.

Thanks Bart, I folded it into the original commit.

> 
>  block/genhd.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/block/genhd.c
> ===================================================================
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -543,7 +543,7 @@ extern struct block_device *bdget_disk(s
>  	struct block_device *bdev = NULL;
>  
>  	part = disk_get_part(disk, partno);
> -	if (part && part->nr_sects)
> +	if (part && (part->nr_sects || partno == 0))
>  		bdev = bdget(part_devt(part));
>  	disk_put_part(part);
>  
> @@ -1001,7 +1001,7 @@ dev_t blk_lookup_devt(const char *name, 
>  			continue;
>  
>  		part = disk_get_part(disk, partno);
> -		if (part && part->nr_sects) {
> +		if (part && (part->nr_sects || partno == 0)) {
>  			devt = part_devt(part);
>  			disk_put_part(part);
>  			break;
> --
> 
> On the somehow related topic - CONFIG_DEBUG_BLOCK_EXT_DEVT which is
> introduced by commit 3e5ba59bbab878f60b8b87004ac55a464bddc819 ("block:
> implement CONFIG_DEBUG_BLOCK_EXT_DEVT") is way too intrusive to be
> enabled by default if CONFIG_DEBUG_KERNEL is set as it easily results
> in no longer bootable systems (+ help entry for the new option says
> "Say N if you are unsure.").
> 
> Tejun/Jens: please consider changing this.

I have change the default to 'n' for now.

-- 
Jens Axboe

