Return-Path: <linux-kernel-owner+w=401wt.eu-S1763292AbXG0Mis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763292AbXG0Mis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbXG0Mij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:38:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36550 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbXG0Mii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:38:38 -0400
Message-ID: <46A9E6F9.20603@oracle.com>
Date: Fri, 27 Jul 2007 18:07:13 +0530
From: gurudas pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Joe Jin <joe.jin@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       wen.gang.wang@oracle.com, Badari Pulavarty <pbadari@us.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org> <20070727071547.GA25084@joejin-pc.cn.oracle.com>
In-Reply-To: <20070727071547.GA25084@joejin-pc.cn.oracle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Joe Jin wrote:
>> I think we still want to run dio_cleanup() if do_direct_IO() failed? 
>> Otherwise we can leak pages.
>>
>> And there's nothing special about EFAULT or ENOMEM here: if do_direct_IO()
>> returns any error then that's it: we bale out, yes?
>>
>
> Yes, I think we'll out from here if get EFAULT/ENOMEM error, also maybe -EIO
> return, return diretly should ok.
>
>> In fact I'm suspecting that this is what the code in there used to do. 
>> Something like:
>>
>> 	for (...) {
>> 		...
>> 		ret = do_direct_IO(...);
>> 		...
>> 		if (ret) {
>> 			dio_dleanup(dio);
>> 			break
>> 		}
>> 	}
>> 	return ret;
>>
>
> Yes, we need call dio_cleanup() to release page cache, I lost it.
>
> However, we need do more while return -ENOTBLK, right?
> so I think the patch maybe like following:
>
>
> --- linux-2.6.22/fs/direct-io.c.orig	2007-07-27 14:39:15.000000000 +0800
> +++ linux-2.6.22/fs/direct-io.c	2007-07-27 15:08:58.000000000 +0800
> @@ -1032,18 +1032,19 @@ direct_io_worker(int rw, struct kiocb *i
>  					blkbits);
>  
>  		if (ret) {
> +			if (ret == -ENOTBLK && (rw & WRITE)) {
> +				/*
> +				 * The remaining part of the request will be
> +				 * be handled by buffered I/O when we return
> +				 */
> +				ret = 0;
> +				break;
> +			}
>  			dio_cleanup(dio);
> -			break;
> +			goto out;
>  		}
>  	} /* end iovec loop */
>  
> -	if (ret == -ENOTBLK && (rw & WRITE)) {
> -		/*
> -		 * The remaining part of the request will be
> -		 * be handled by buffered I/O when we return
> -		 */
> -		ret = 0;
> -	}
>  	/*
>  	 * There may be some unwritten disk at the end of a part-written
>  	 * fs-block-sized block.  Go zero that now.
>
>
>
>
>> _
>>
>> However I'd like to ask you guys to carefully review and test that please.
>>
> Gurudas, would you please give more test of this patch?
I tested Andrew's patch and panic was gone but got few ENOTBLK.
So I tried with Joe's patch , both panic and ENOTBLK are gone now.
But in Joe's patch if (ret == -ENOTBLK && (rw & WRITE)), dio_cleanup(dio)
was not getting called because of break. So I moved dio_cleanup just 
after if (ret).
I tested with this patch, both panic and ENOTBLK are gone now.


Here is the modified patch:

--- linux-2.6.22/fs/direct-io.c.orig 2007-07-27 03:06:39.000000000 -0700
+++ linux-2.6.22/fs/direct-io.c 2007-07-27 03:24:55.000000000 -0700
@@ -1033,17 +1033,18 @@

if (ret) {
dio_cleanup(dio);
- break;
+ if (ret == -ENOTBLK && (rw & WRITE)) {
+ /*
+ * The remaining part of the request will be
+ * be handled by buffered I/O when we return
+ */
+ ret = 0;
+ break;
+ }
+ goto out;
}
} /* end iovec loop */

- if (ret == -ENOTBLK && (rw & WRITE)) {
- /*
- * The remaining part of the request will be
- * be handled by buffered I/O when we return
- */
- ret = 0;
- }
/*
* There may be some unwritten disk at the end of a part-written
* fs-block-sized block. Go zero that now.
@@ -1112,7 +1113,7 @@
kfree(dio);
} else
BUG_ON(ret != -EIOCBQUEUED);
-
+out:
return ret;
}


