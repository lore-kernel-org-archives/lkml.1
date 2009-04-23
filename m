Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZDWJ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZDWJ7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 05:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZDWJ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 05:58:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:19234 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZDWJ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 05:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=T74Gkv6oQxRnulXu22HTkW7+cwhv68S6HNcqx8OaRvC/ufJeWypdW7n7ca96UCHaUN
         Srmgk6kDLUOxngzOTcVCOIDz3lSLo1e/p8+kJCyxDQi88+ZKBZCCdSrTKJVt3wEie5oH
         hCoerF86TDluOWBHC+Axfgs0TqI0V64Pmf4O0=
Message-ID: <49F03C12.1040507@gmail.com>
Date: Thu, 23 Apr 2009 18:59:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH UPDATED 09/14] block: clean up request completion API
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-10-git-send-email-tj@kernel.org> <20090421175919.GA11671@infradead.org> <49EFC360.3010109@kernel.org> <49EFCD82.4050000@gmail.com> <49F0382A.6050306@panasas.com>
In-Reply-To: <49F0382A.6050306@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> Rrrr.
> 
> This patch could be nice, but not after I've seen the previous one.
> The first one was much^3 nicer.

Heh... can't make everyone happy.  :-)

> Maybe all you need to do is push the lock flag into blk_finish_request()
> 
> <original patch>
> +	if (!locked) {
>> +		spin_lock_irqsave(q->queue_lock, flags);
>> +		finish_request(rq, error);
>> +		spin_unlock_irqrestore(q->queue_lock, flags);
>> +	} else
>> +		finish_request(rq, error);
>>
> </original patch>
> 
> Then you have only one call site to finish_request() inside blk_end_io().
> 
> finish_request() will become the ugly site, but if looking at the
> alternative I think it is worth it. Code is smaller, cleaner, and
> clearer. (Sometimes principles must be sacrificed)
> 
> At the end, I hate that lock around finish_request(), I wish the
> req->end_io() was not called with the lock held and the plain
> blk_put_request() (locking version) could be called. Having
> req->end_io() under lock is a pain in the ass that makes you go
> through loops when you need proper error handling. One day I will
> get rid of it.
>
> Tejun? now that you done both, which one do you like better? or is
> it just me?

Frankly, I don't care one way or the other as long as there's no
duplication in code paths.  Pros and cons of both approaches are
minimal and/or cosmetic.  One might remove a branch at the cost of
minutely larger code.  It just doesn't matter all that much.

I think it's best to let the maintainer have his/her way on things
like this.  I mean, maintainership is a hard work.  There gotta be
some perks.  :-)

Joke aside, I think it's a good idea to follow maintainer's decisions
on things like this as it helps making the subsystem code more
consistent which is usually way more important than minute technical
or cosmetic advantages.

Thanks.

-- 
tejun
