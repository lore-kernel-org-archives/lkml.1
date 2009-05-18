Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZERRxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZERRxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZERRxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:53:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46976 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZERRw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:52:59 -0400
Date: Mon, 18 May 2009 19:53:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090518175259.GL4140@kernel.dk>
References: <6.0.0.20.2.20090518183752.0581fdc0@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090518183752.0581fdc0@172.19.0.2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18 2009, Hisashi Hifumi wrote:
> Hi.
> 
> I wrote a patch that adds blk_run_backing_dev on page_cache_async_readahead
> so readahead I/O is unpluged to improve throughput.
> 
> Following is the test result with dd.
> 
> #dd if=testdir/testfile of=/dev/null bs=16384
> 
> -2.6.30-rc6
> 1048576+0 records in
> 1048576+0 records out
> 17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s
> 
> -2.6.30-rc6-patched
> 1048576+0 records in
> 1048576+0 records out
> 17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s
> 
> Sequential read performance on a big file was improved.
> Please merge my patch.
> 
> Thanks.
> 
> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> 
> diff -Nrup linux-2.6.30-rc6.org/mm/readahead.c linux-2.6.30-rc6.unplug/mm/readahead.c
> --- linux-2.6.30-rc6.org/mm/readahead.c	2009-05-18 10:46:15.000000000 +0900
> +++ linux-2.6.30-rc6.unplug/mm/readahead.c	2009-05-18 13:00:42.000000000 +0900
> @@ -490,5 +490,7 @@ page_cache_async_readahead(struct addres
>  
>  	/* do read-ahead */
>  	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
> +
> +	blk_run_backing_dev(mapping->backing_dev_info, NULL);
>  }
>  EXPORT_SYMBOL_GPL(page_cache_async_readahead);

I'm surprised this makes much of a difference. It seems correct to me to
NOT unplug the device, since it will get unplugged when someone ends up
actually waiting for a page. And that will then kick off the remaining
IO as well. For this dd case, you'll be hitting lock_page() for the
readahead page really soon, definitely not long enough to warrant such a
big difference in speed.

So, are these numbers 100% reproducible? Could you capture blktrace data
for both with and without the patch, so we can take a closer look at the
generated IO for each case?

-- 
Jens Axboe

