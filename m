Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbXG0IJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbXG0IJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 04:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbXG0IJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 04:09:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37285 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbXG0IJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 04:09:17 -0400
Message-ID: <46A9A81C.1070309@oracle.com>
Date: Fri, 27 Jul 2007 13:39:00 +0530
From: gurudas pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Jin <joe.jin@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       wen.gang.wang@oracle.com, Badari Pulavarty <pbadari@us.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org>
In-Reply-To: <20070726221307.3d7b3446.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Thu, 26 Jul 2007 17:04:00 +0800 Joe Jin <joe.jin@oracle.com> wrote:
>
>> This is the patch for check do_direct_IO() return val.
>>
>> At do_direct_IO(), sometimes dio_get_page() will return -EFAULT/-ENOMEM,
>> according to orig source, it will go on left work. buf for dio_get_page()
>> return a error will made many useful member of dio not initialized like
>> dio->map_bh and others, at this point, kernel will panic.
>>
>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>>
>>
>> ---
>> --- linux-2.6.22/fs/direct-io.c.orig	2007-07-26 11:32:27.000000000 +0800
>> +++ linux-2.6.22/fs/direct-io.c	2007-07-26 11:33:58.000000000 +0800
>> @@ -1031,7 +1031,9 @@ direct_io_worker(int rw, struct kiocb *i
>>  			((dio->final_block_in_request - dio->block_in_file) <<
>>  					blkbits);
>>  
>> -		if (ret) {
>> +		if (ret == -EFAULT || ret == -ENOMEM) 
>> +			goto out;
>> +		else if (ret) {
>>  			dio_cleanup(dio);
>>  			break;
>>  		}
>> @@ -1113,6 +1115,7 @@ direct_io_worker(int rw, struct kiocb *i
>>  	} else
>>  		BUG_ON(ret != -EIOCBQUEUED);
>>  
>> +out:
>>  	return ret;
>>  }
>>  
>
> I think we still want to run dio_cleanup() if do_direct_IO() failed? 
> Otherwise we can leak pages.
>
> And there's nothing special about EFAULT or ENOMEM here: if do_direct_IO()
> returns any error then that's it: we bale out, yes?
>
> In fact I'm suspecting that this is what the code in there used to do. 
> Something like:
>
> 	for (...) {
> 		...
> 		ret = do_direct_IO(...);
> 		...
> 		if (ret) {
> 			dio_dleanup(dio);
> 			break
> 		}
> 	}
> 	return ret;
>
> but then someone later came along and added more code between the end of
> the for loop and the `return' statement.
>
> <I do miss the BK diffviewer sometimes>
>
> <does a binary search>
>
> yep, that's exactly what happened.  We broke it in the 2.5.45 release back
> in October 2002. (Where "we" == "Badari")
>
> So I think what we need to do is something close to this:
>
> --- a/fs/direct-io.c~add-check-do_direct_io-return-val
> +++ a/fs/direct-io.c
> @@ -1033,7 +1033,7 @@ direct_io_worker(int rw, struct kiocb *i
>  
>  		if (ret) {
>  			dio_cleanup(dio);
> -			break;
> +			goto out;
>  		}
>  	} /* end iovec loop */
>  
> @@ -1112,7 +1112,7 @@ direct_io_worker(int rw, struct kiocb *i
>  		kfree(dio);
>  	} else
>  		BUG_ON(ret != -EIOCBQUEUED);
> -
> +out:
>  	return ret;
>  }
>  
> _
>
> However I'd like to ask you guys to carefully review and test that please.
Tested Andrew's patch , works! . My test case passed without any panic. 
But got couple of ENOTBLK.


Thanks,
-Guru
