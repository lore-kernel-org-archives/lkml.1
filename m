Return-Path: <linux-kernel-owner+w=401wt.eu-S1764393AbZCNCIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764393AbZCNCIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765428AbZCNB4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:56:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:39342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765373AbZCNB4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:56:31 -0400
Message-ID: <49BB0ECB.6090003@kernel.org>
Date: Sat, 14 Mar 2009 10:56:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 11/14] block: implement and use [__]blk_end_request_all()
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <1236920578-2179-12-git-send-email-tj@kernel.org> <200903132021.55921.bzolnier@gmail.com>
In-Reply-To: <200903132021.55921.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 01:56:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bartlomiej.  :-)

Bartlomiej Zolnierkiewicz wrote:
>>  end_request:
>>  	if (blk_pc_request(rq)) {
>> -		unsigned int dlen = rq->data_len;
>> -
>>  		if (dma)
>>  			rq->data_len = 0;
> 
> Since rq->data_len is modified here...
> 
>> -
>> -		if (blk_end_request(rq, 0, dlen))
>> -			BUG();
>> -
>> +		blk_end_request_all(rq, 0);
> 
> ...this won't fly.
> 
> [ IIRC ->data_len modification is needed for SG_IO ]

Thanks for catching this.  I'll take further look into this.

>> @@ -190,9 +190,7 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
>>  
>>  	rq->errors = err;
>>  
>> -	if (unlikely(blk_end_request(rq, (rq->errors ? -EIO : 0),
>> -				     blk_rq_bytes(rq))))
>> -		BUG();
>> +	blk_end_request_all(rq, (rq->errors ? -EIO : 0));
> 
> How's about dropping needless parentheses while at it?

Sure.

>> diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
>> index 60538d9..d3d2d29 100644
>> --- a/drivers/ide/ide-pm.c
>> +++ b/drivers/ide/ide-pm.c
>> @@ -194,8 +194,7 @@ void ide_complete_pm_request(ide_drive_t *drive, struct request *rq)
>>  
>>  	drive->hwif->rq = NULL;
>>  
>> -	if (blk_end_request(rq, 0, 0))
>> -		BUG();
>> +	blk_end_request_all(rq, 0);
> 
> 0 => ide_rq_bytes() _not_ blk_rq_bytes()

Can you elaborate a bit?  Isn't the request supposed to always
completely finish here?  If the request isn't zero-length, completion
with 0 byte length doesn't make any sense.

> Please convert ide_complete_pm_request() to use blk_rq_bytes() in
> the separate pre-patch first.

Alright, will do.

> More generic comment follows -> this patch is guaranteed to clash
> with at least linux-next/pata-2.6 tree so why not introduce block
> layer helpers now, then push all driver updates through respective
> driver maintainers and deal with end_request() later (after all
> driver updates are in-tree)?

Most of the lld changes being trivial, I was hoping to push things
through blk tree, but IDE seems to be the most intertwined with the
block layer and it's likely to see quite some amount of not-so-trivial
changes to subtle paths.  How about pushing !IDE parts into blk tree
and pulling blk into pata-2.6, make IDE related changes there and
pulling back into blk tree so that further progresses can be made?

Thanks.

-- 
tejun
