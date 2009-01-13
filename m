Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZAMKok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZAMKok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbZAMKlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:41:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:49018 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZAMKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:41:08 -0500
Message-ID: <496C6FBA.2090709@kernel.org>
Date: Tue, 13 Jan 2009 19:40:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: new barrier warnings in 2.6.29-rc1
References: <20090112154634.GA15730@lst.de> <496C0915.6000107@kernel.org> <20090113084229.GL30821@kernel.dk>
In-Reply-To: <20090113084229.GL30821@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:41:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> On Tue, Jan 13 2009, Tejun Heo wrote:
>> I think the right thing to do is setting REQ_QUIET on the trial
>> barrier request.
> 
> It would surely work, but XFS doesn't really have a way to do that. Then
> we would have to add a bio quiet flag and inherit that.
> 
> I kind of liked the old behaviour. What about something like the below?
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a824e49..eddba4a 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1448,6 +1448,11 @@ static inline void __generic_make_request(struct bio *bio)
>  			err = -EOPNOTSUPP;
>  			goto end_io;
>  		}
> +		if (bio_barrier(bio) && bio_has_data(bio) &&
> +		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
> +			err = -EOPNOTSUPP;
> +			goto end_io;
> +		}
>  
>  		ret = q->make_request_fn(q, bio);
>  	} while (ret);

I have no objection against it.  I kind of like having single test
point but it's a corner case anyway so no biggie.

Thanks.

-- 
tejun
