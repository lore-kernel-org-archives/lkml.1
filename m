Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYKCVje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYKCVje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYKCVj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:39:26 -0500
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2423 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYKCVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:39:25 -0500
Subject: Re: disk statistics issue in 2.6.27
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, mikevs@xs4all.net
In-Reply-To: <20081031124743.GH31673@kernel.dk>
References: <20081019113102.GA18440@xs4all.net>
	 <20081020171248.GE19428@kernel.dk>
	 <1224686272.25437.14.camel@n2o.xs4all.nl>
	 <20081022171712.GO22217@kernel.dk>
	 <1224777902.26805.17.camel@n2o.xs4all.nl>
	 <20081031124743.GH31673@kernel.dk>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 22:39:12 +0100
Message-Id: <1225748352.15785.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 13:47 +0100, Jens Axboe wrote:
> On Thu, Oct 23 2008, Miquel van Smoorenburg wrote:
>
> > I added some debug statements to block/blk-core.c, and it appears that
> > blk_end_io() is always called with nr_bytes == 16320 Kbytes (16711680).
> > 
> > Ofcourse I should have noticed earlier that iostat -x 2 always prints
> > 32640 as "average request size" (in sectors).
> 
> You didn't happen to log a backtrace from that, did you? That's a weird
> nr_bytes, it's 0xff0000.
> 
> I'm assuming this then fixes it, just wondering what the heck is going
> on here.
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 33c8d4b..a372618 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1712,11 +1710,12 @@ static int __end_that_request_first(struct request *req, int error,
>  	if (blk_fs_request(req) && req->rq_disk) {
>  		const int rw = rq_data_dir(req);
>  		struct hd_struct *part;
> -		int cpu;
> +		int cpu, sectors;
>  
> +		sectors = min_t(int, nr_bytes >> 9, req->hard_nr_sectors);
>  		cpu = part_stat_lock();
>  		part = disk_map_sector_rcu(req->rq_disk, req->sector);
> -		part_stat_add(cpu, part, sectors[rw], nr_bytes >> 9);
> +		part_stat_add(cpu, part, sectors[rw], sectors);
>  		part_stat_unlock();
>  	}

I didn't try the above patch yet (it might work), but I did find the
cause. I bisected the problem and it was caused by commit
427e59f09fdba387547106de7bab980b7fff77be , something in the scsi layer.
More on linux-scsi (I'll Cc you)

Thanks

Mike.

