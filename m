Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbZDAWZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbZDAWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761270AbZDAWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:25:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbZDAWZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:25:14 -0400
Message-ID: <49D3E9EF.8010407@kernel.org>
Date: Thu, 02 Apr 2009 07:25:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 13/17] blk-map: implement blk_rq_map_kern_sgl()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-14-git-send-email-tj@kernel.org> <49D39B6C.7080707@panasas.com>
In-Reply-To: <49D39B6C.7080707@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 22:25:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
>> -	do_copy = !blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf);
>> -	if (do_copy)
>> -		bio = bio_copy_kern(q, kbuf, len, gfp, rw);
>> -	else
>> -		bio = bio_map_kern(q, kbuf, len, gfp);
>> -
>> +	bio = bio_map_kern_sg(q, sgl, nents, rw, gfp);
>> +	if (IS_ERR(bio))
>> +		bio = bio_copy_kern_sg(q, sgl, nents, rw, gfp);
>>  	if (IS_ERR(bio))
>>  		return PTR_ERR(bio);
> 
> You might want to call bio_copy_kern_sg from within bio_map_kern_sg
> and remove yet another export from bio layer
> 
> Same thing with bio_map_user_iov/bio_copy_user_iov

Right, that makes sense.  Will incorporate it.

>>  
>> -	if (rq_data_dir(rq) == WRITE)
>> -		bio->bi_rw |= (1 << BIO_RW);
>> -
>> -	if (do_copy)
>> +	if (!bio_flagged(bio, BIO_USER_MAPPED))
>>  		rq->cmd_flags |= REQ_COPY_USER;
>>  
>> +	blk_queue_bounce(q, &bio);
>>  	blk_rq_bio_prep(q, rq, bio);
> 
> It could be nice to call blk_rq_append_bio() here
> and support multiple calls to this member.
> This will solve half of my problem with osd_initiator
> 
> Hmm .. but you wanted to drop multiple bio chaining
> perhaps you would reconsider.

I don't want to drop multiple bio chaining at all in itself.  I just
didn't see the current uses as, well, useful.  If building a sgl for a
request at once is difficult for your purpose, making blk_rq_map_*()
functions accumulate bios sounds like a good idea.  The primary goal
was to remove direct bio visibility/manipulation from low level
driver's POV.

>> +int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
>> +		    unsigned int len, gfp_t gfp)
>> +{
>> +	struct scatterlist sg;
>> +
>> +	sg_init_one(&sg, kbuf, len);
>> +
>> +	return blk_rq_map_kern_sg(q, rq, &sg, 1, gfp);
>> +}
>>  EXPORT_SYMBOL(blk_rq_map_kern);
> 
> could be inline like with the end_request functions

Yeap, will make it inline.

Thanks.

-- 
tejun
