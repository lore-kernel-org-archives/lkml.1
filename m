Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZETBH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZETBH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 21:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZETBHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 21:07:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44711 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZETBHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 21:07:47 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <6.0.0.20.2.20090518183752.0581fdc0@172.19.0.2>
References: <6.0.0.20.2.20090518183752.0581fdc0@172.19.0.2>
Message-Id: <20090520100602.7438.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 May 2009 10:07:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to Wu and linux-mm)

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

I guess the improvement depend on readahead window size.
Have you mesure random access workload?

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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



