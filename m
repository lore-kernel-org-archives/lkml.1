Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbZETBrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbZETBrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 21:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZETBrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 21:47:47 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59814 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZETBrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 21:47:47 -0400
Message-Id: <6.0.0.20.2.20090520104202.071d0be8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Wed, 20 May 2009 10:43:18 +0900
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090520100602.7438.A69D9226@jp.fujitsu.com>
References: <6.0.0.20.2.20090518183752.0581fdc0@172.19.0.2>
 <20090520100602.7438.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 10:07 09/05/20, KOSAKI Motohiro wrote:
>(cc to Wu and linux-mm)
>
>> Hi.
>> 
>> I wrote a patch that adds blk_run_backing_dev on page_cache_async_readahead
>> so readahead I/O is unpluged to improve throughput.
>> 
>> Following is the test result with dd.
>> 
>> #dd if=testdir/testfile of=/dev/null bs=16384
>> 
>> -2.6.30-rc6
>> 1048576+0 records in
>> 1048576+0 records out
>> 17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s
>> 
>> -2.6.30-rc6-patched
>> 1048576+0 records in
>> 1048576+0 records out
>> 17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s
>> 
>> Sequential read performance on a big file was improved.
>> Please merge my patch.
>
>I guess the improvement depend on readahead window size.
>Have you mesure random access workload?

I tried with iozone. But there was no difference.

>
>> 
>> Thanks.
>> 
>> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>> 
>> diff -Nrup linux-2.6.30-rc6.org/mm/readahead.c 
>linux-2.6.30-rc6.unplug/mm/readahead.c
>> --- linux-2.6.30-rc6.org/mm/readahead.c	2009-05-18 10:46:15.000000000 +0900
>> +++ linux-2.6.30-rc6.unplug/mm/readahead.c	2009-05-18 13:00:42.000000000 +0900
>> @@ -490,5 +490,7 @@ page_cache_async_readahead(struct addres
>>  
>>  	/* do read-ahead */
>>  	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
>> +
>> +	blk_run_backing_dev(mapping->backing_dev_info, NULL);
>>  }
>>  EXPORT_SYMBOL_GPL(page_cache_async_readahead);
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

