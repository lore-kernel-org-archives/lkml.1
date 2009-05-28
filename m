Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbZE1CXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbZE1CXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 22:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZE1CXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 22:23:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56985 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZE1CXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 22:23:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
In-Reply-To: <6.0.0.20.2.20090528095927.06dfc1c8@172.19.0.2>
References: <20090527043601.GA26361@localhost> <6.0.0.20.2.20090528095927.06dfc1c8@172.19.0.2>
Message-Id: <20090528112247.F0E7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 28 May 2009 11:23:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Andrew.
> Please merge following patch.
> Thanks.
> 
> ---
> 
> I added blk_run_backing_dev on page_cache_async_readahead
> so readahead I/O is unpluged to improve throughput on 
> especially RAID environment. 
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
> My testing environment is as follows:
> Hardware: HP DL580 
> CPU:Xeon 3.2GHz *4 HT enabled
> Memory:8GB
> Storage: Dothill SANNet2 FC (7Disks RAID-0 Array)
> 
> The normal case is, if page N become uptodate at time T(N), then
> T(N) <= T(N+1) holds. With RAID (and NFS to some degree), there 
> is no strict ordering, the data arrival time depends on
> runtime status of individual disks, which breaks that formula. So
> in do_generic_file_read(), just after submitting the async readahead IO
> request, the current page may well be uptodate, so the page won't be locked,
> and the block device won't be implicitly unplugged:

Please attach blktrace analysis ;)


> 
>                if (PageReadahead(page))
>                         page_cache_async_readahead()
>                 if (!PageUptodate(page))
>                                 goto page_not_up_to_date;
>                 //...
> page_not_up_to_date:
>                 lock_page_killable(page);
> 
> Therefore explicit unplugging can help.
> 
> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com> 
> 
> 
>  mm/readahead.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --- linux.orig/mm/readahead.c
> +++ linux/mm/readahead.c
> @@ -490,5 +490,15 @@ page_cache_async_readahead(struct addres
>  
>  	/* do read-ahead */
>  	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
> +
> +	/*
> +	* Normally the current page is !uptodate and lock_page() will be
> +	* immediately called to implicitly unplug the device. However this
> +	* is not always true for RAID conifgurations, where data arrives
> +	* not strictly in their submission order. In this case we need to
> +	* explicitly kick off the IO.
> +	*/
> +	if (PageUptodate(page))
> +		blk_run_backing_dev(mapping->backing_dev_info, NULL);
>  }
>  EXPORT_SYMBOL_GPL(page_cache_async_readahead); 
> 



