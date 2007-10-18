Return-Path: <linux-kernel-owner+w=401wt.eu-S1763062AbXJRJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763062AbXJRJmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXJRJmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:42:07 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29635 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbXJRJmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:42:04 -0400
Date: Thu, 18 Oct 2007 11:41:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018094128.GP5063@kernel.dk>
References: <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4717281B.6070301@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Jeff Garzik wrote:
> Jens Axboe wrote:
>> The sata_mv construct looks a bit odd. Does this work? That last
>
> The sata_mv construct worked just fine before sg chaining :)

Yes I know, but I'm trying to works towards getting rid of sg_last() and
ata_sg_is_last() anyway :-)

>> end_mv_sg test should always be true, just being paranoid...
>> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
>> index 4df8311..5397eea 100644
>> --- a/drivers/ata/sata_mv.c
>> +++ b/drivers/ata/sata_mv.c
>> @@ -1138,8 +1138,9 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
>>  {
>>  	struct mv_port_priv *pp = qc->ap->private_data;
>>  	struct scatterlist *sg;
>> -	struct mv_sg *mv_sg;
>> +	struct mv_sg *mv_sg, *end_mv_sg;
>>  +	end_mv_sg = NULL;
>>  	mv_sg = pp->sg_tbl;
>>  	ata_for_each_sg(sg, qc) {
>>  		dma_addr_t addr = sg_dma_address(sg);
>> @@ -1158,14 +1159,12 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
>>   			sg_len -= len;
>>  			addr += len;
>> -
>> -			if (!sg_len && ata_sg_is_last(sg, qc))
>> -				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
>> -
>> +			end_mv_sg = mv_sg;
>>  			mv_sg++;
>>  		}
>> -
>>  	}
>> +	if (end_mv_sg)
>> +		end_mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
>>  }
>>  
>
> I'm testing a similar patch based on ata_fill_sg()'s method, which 
> basically does something similar to what you've done here (see attached).  
> I had noticed that ata_fill_sg() did not call ata_sg_is_last().
>
> If this fixes the problem, I think the best solution would be to delete 
> ata_sg_is_last().  In the few users that exist, we should be able to 
> eliminate the test programmatically as you and ata_fill_sg() have done -- 
> thereby eliminating a branch per loop in a hotpath.
>
> Off to test the attached...  if that doesn't work I'll try your version, 
> though there shouldn't be much difference.

That should work as well. WRT ata_sg_is_last(), if we go ahead with my
recent sg chaining updates, we can keep the test as it would be a single
conditional and not require any looping.

Let me know when you have tested this!

-- 
Jens Axboe

