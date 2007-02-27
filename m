Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXB0OdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXB0OdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXB0OdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:33:23 -0500
Received: from brick.kernel.dk ([62.242.22.158]:25660 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbXB0OdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:33:22 -0500
Date: Tue, 27 Feb 2007 15:33:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: Fix soft lockup with iSeries viocd driver
Message-ID: <20070227143334.GB4731@kernel.dk>
References: <20070227055529.GO4575@bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227055529.GO4575@bakeyournoodle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Tony Breeds wrote:
> From: Tony Breeds <tony@bakeyournoodle.com>
> 
> Fix soft lockup with iSeries viocd driver, caused by eventually calling
> end_that_request_first() with nr_bytes 0.
> 
> The lockup is triggered by hald, interrogating the device.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> 
> ---
> Implementation based on drivers/ide/ide-io.c:ide_end_request()
> 
>  viocd.c |   24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.20-rc5/drivers/cdrom/viocd.c
> ===================================================================
> --- linux-2.6.20-rc5.orig/drivers/cdrom/viocd.c
> +++ linux-2.6.20-rc5/drivers/cdrom/viocd.c
> @@ -376,6 +376,22 @@ static int send_request(struct request *
>         return 0;
>  }
>  
> +static void viocd_end_request(struct request *req, int uptodate)
> +{
> +       int nsectors = req->hard_cur_sectors;
> +
> +       /* Make sure it's fully ended */
> +       if (blk_pc_request(req))
> +               nsectors = (req->data_len + 511) >> 9;
> +       if (!nsectors)
> +               nsectors = 1;
> +
> +       if (!end_that_request_first(req, uptodate, nsectors)) {
> +               add_disk_randomness(req->rq_disk);
> +               blkdev_dequeue_request(req);
> +               end_that_request_last(req, uptodate);
> +       }
> +}

It looks ok (better than end_request()), though it would still be nice
to properly end requests. See the recent thread on the lguest block
driver.

-- 
Jens Axboe

