Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZDWJnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZDWJnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 05:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZDWJnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 05:43:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:24359 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZDWJnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 05:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cw75ydPJYcL9EFedpXbRvgaIKsbe/zy9tXo3D9YKkNxo4wfVQOtQr4qe6NN1xkTiRv
         xy+eP9wv4SMZ16bhoIStsp/4WlhR1dX6ynwmjvyJqc4YoXGIW4nuon01x31JWTEj1XGw
         yx+66JcPDHbe4WLgFNUG+tghXqog7xK2LPlrM=
Message-ID: <49F0382A.6050306@panasas.com>
Date: Thu, 23 Apr 2009 12:43:06 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH UPDATED 09/14] block: clean up request completion API
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-10-git-send-email-tj@kernel.org> <20090421175919.GA11671@infradead.org> <49EFC360.3010109@kernel.org> <49EFCD82.4050000@gmail.com>
In-Reply-To: <49EFCD82.4050000@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2009 05:08 AM, Tejun Heo wrote:
> Request completion has gone through several changes and became a bit
> messy over the time.  Clean it up.
> 
> 1. end_that_request_data() is a thin wrapper around
>    end_that_request_data_first() which checks whether bio is NULL
>    before doing anything and handles bidi completion.
>    blk_update_request() is a thin wrapper around
>    end_that_request_data() which clears nr_sectors on the last
>    iteration but doesn't use the bidi completion.
> 
>    Clean it up by moving the initial bio NULL check and nr_sectors
>    clearing on the last iteration into end_that_request_data() and
>    renaming it to blk_update_request(), which makes blk_end_io() the
>    only user of end_that_request_data().  Collapse
>    end_that_request_data() into blk_end_io().
> 
> 2. There are four visible completion variants - blk_end_request(),
>    __blk_end_request(), blk_end_bidi_request() and end_request().
>    blk_end_request() and blk_end_bidi_request() uses blk_end_request()
>    as the backend but __blk_end_request() and end_request() use
>    separate implementation in __blk_end_request() due to different
>    locking rules.
> 
>    blk_end_bidi_request() is identical to blk_end_io().  Collapse
>    blk_end_io() into blk_end_bidi_request(), separate out request
>    update into internal helper blk_update_bidi_request() and add
>    __blk_end_bidi_request().  Redefine [__]blk_end_request() as thin
>    inline wrappers around [__]blk_end_bidi_request().
> 
> 3. As the whole request issue/completion usages are about to be
>    modified and audited, it's a good chance to convert completion
>    functions return bool which better indicates the intended meaning
>    of return values.
> 
> 4. The function name end_that_request_last() is from the days when it
>    was a public interface and slighly confusing.  Give it a proper
>    internal name - blk_finish_request().
> 
> 5. Add description explaning that blk_end_bidi_request() can be safely
>    used for uni requests as suggested by Boaz Harrosh.
> 
> The only visible behavior change is from #1.  nr_sectors counts are
> cleared after the final iteration no matter which function is used to
> complete the request.  I couldn't find any place where the code
> assumes those nr_sectors counters contain the values for the last
> segment and this change is good as it makes the API much more
> consistent as the end result is now same whether a request is
> completed using [__]blk_end_request() alone or in combination with
> blk_update_request().
> 
> API further cleaned up per Christoph's suggestion.
> 

Rrrr.

This patch could be nice, but not after I've seen the previous one.
The first one was much^3 nicer.

Maybe all you need to do is push the lock flag into blk_finish_request()

<original patch>
+	if (!locked) {
> +		spin_lock_irqsave(q->queue_lock, flags);
> +		finish_request(rq, error);
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +	} else
> +		finish_request(rq, error);
> 
</original patch>

Then you have only one call site to finish_request() inside blk_end_io().

finish_request() will become the ugly site, but if looking at the alternative
I think it is worth it. Code is smaller, cleaner, and clearer. (Sometimes principles
must be sacrificed)

At the end, I hate that lock around finish_request(), I wish the req->end_io()
was not called with the lock held and the plain blk_put_request() (locking version)
could be called. Having req->end_io() under lock is a pain in the ass that makes
you go through loops when you need proper error handling. One day I will get rid of
it.

Tejun? now that you done both, which one do you like better? or is it just me?

Thanks
Boaz
