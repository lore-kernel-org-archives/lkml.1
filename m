Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZEYGQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZEYGQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbZEYGPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:15:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35279 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZEYGPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:15:51 -0400
Date: Mon, 25 May 2009 08:15:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Neil Brown <neilb@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, raz ben yehuda <raziebe@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: linux-next: md tree build failure
Message-ID: <20090525061552.GH11363@kernel.dk>
References: <20090525153346.758483fc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525153346.758483fc.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25 2009, Stephen Rothwell wrote:
> Hi Neil,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> drivers/md/raid0.c: In function 'create_strip_zones':
> drivers/md/raid0.c:243: error: 'struct request_queue' has no member named 'hardsect_size'
> 
> Caused by commit e1defc4ff0cf57aca6c5e3ff99fa503f5943c1f1 ("block: Do
> away with the notion of hardsect_size") from the block tree interacting
> with commit 131e4477401ae76a9cbe8539e4b7819e04cfba36 ("md: raid0: chunk
> size check in raid0_run") from the md tree.

Martin, this is starting to look like a disaster :-(

> 
> I applied the following patch.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index b8a0747..0bf275d 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -240,7 +240,7 @@ static int create_strip_zones(mddev_t *mddev)
>  	 * now since we have the hard sector sizes, we can make sure
>  	 * chunk size is a multiple of that sector size
>  	 */
> -	if (mddev->chunk_size % mddev->queue->hardsect_size) {
> +	if (mddev->chunk_size % queue_logical_block_size(mddev->queue)) {
>  		printk(KERN_ERR "%s chunk_size of %d not valid\n",
>  		       mdname(mddev),
>  		       mddev->chunk_size);

-- 
Jens Axboe

