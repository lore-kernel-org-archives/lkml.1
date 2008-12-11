Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbYLKSSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbYLKSSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbYLKSSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:18:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbYLKSSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:18:20 -0500
Message-ID: <4941592E.8070303@vlnb.net>
Date: Thu, 11 Dec 2008 21:17:18 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH][RFC 13/23]: Export of alloc_io_context() function
References: <494009D7.4020602@vlnb.net> <49400F2F.4050603@vlnb.net> <20081211133424.GU23742@kernel.dk>
In-Reply-To: <20081211133424.GU23742@kernel.dk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19UxRl678ApofNAkSQA+3M4u1+WLTs/6nF6bdR
 j9cHbM15yiCf1ngSKoCDGP/kv5Vf0P3AMf6MpchcvIM2MbUgf+
 93BDWFV8VtWIvEfHGNBYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Dec 10 2008, Vladislav Bolkhovitin wrote:
>> This patch exports alloc_io_context() function. For performance reasons 
>> SCST queues commands using a pool of IO threads. It is considerably 
>> better for performance (>30% increase on sequential reads) if threads in 
>>   a pool have the same IO context. Since SCST can be built as a module, 
>> it needs alloc_io_context() function exported.
>>
>> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
>> ---
>>   block/blk-ioc.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff -upkr linux-2.6.27.2/block/blk-ioc.c linux-2.6.27.2/block/blk-ioc.c
>> --- linux-2.6.27.2/block/blk-ioc.c	2008-10-10 02:13:53.000000000 +0400
>> +++ linux-2.6.27.2/block/blk-ioc.c	2008-11-25 21:27:01.000000000 +0300
>> @@ -105,6 +105,7 @@ struct io_context *alloc_io_context(gfp_
>>  
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL(alloc_io_context);
> 
> Why is this needed, can't you just use CLONE_IO?

There are two reasons for that:

1. kthread interface doesn't support passing CLONE_IO flag.

2. Each (virtual) device has own pool of threads, which serves it. 
Threads in each such pools should have a common IO context, but 
different pools should have different IO contexts. So, it would be 
necessary to implement two levels start of IO threads in each pool. At 
first, one thread would be started. Then it would call get_io_context() 
to gain io_context. Then it would create the remaining threads with 
CLONE_IO flag. Definitely, it's a lot more complicated than a simple 
call of alloc_io_context() and assignment of the returned context to 
each just created thread in a loop before they were ran.

Thanks,
Vlad

