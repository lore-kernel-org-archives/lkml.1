Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbZCZOq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbZCZOq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZCZOql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:46:41 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:22384 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758556AbZCZOqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:46:39 -0400
Message-ID: <49CB94E9.5040808@panasas.com>
Date: Thu, 26 Mar 2009 16:44:57 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/14] block: implement blk_rq_map_kern_prealloc()
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-4-git-send-email-tj@kernel.org> <49CA4B4B.50408@panasas.com> <49CAE425.5050009@kernel.org> <49CB31DB.2040608@gmail.com> <49CB3765.4070406@panasas.com> <49CB387A.3000006@panasas.com> <49CB56AD.3080101@gmail.com> <49CB65CB.1030905@panasas.com> <49CB6FF8.7050701@gmail.com>
In-Reply-To: <49CB6FF8.7050701@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2009 14:46:35.0077 (UTC) FILETIME=[A916D750:01C9AE21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2009 02:07 PM, Tejun Heo wrote:
> Hello, Boaz.
> 
> Boaz Harrosh wrote:
>>> For the latter, the APIs are blk_rq_map_{user[_iov]|kern}().  To add
>>> to the fun, we have blk_rq_map_sg() which does a completely different
>>> thing of mapping an rq's bios to sg and is usually called from low
>>> level do_request() when starting to process a request.
>> Lets just remove for a moment blk_rq_map_sg() from the discussion.
>> That one is totally bogus name that gives me the crips every time
>> I read its name. If using the same terminology then at minimum it should have
>> been blk_sg_map_request() (Which I agree is even more cryptic but at least
>> it gets the source-destination right).
> 
> Ah... yeah, one of the two definitely needs to get a different name.
> 
>>> You're suggesting to add blk_rq_map_bio() which doesn't really map
>>> anything but rather allocates and initializes an rq from bio and
>>> basically boils down to blk_rq_bio_prep() and blk_queue_bounce().
>> Yes, as I said, I completely agree. It does not map anything and
>> should not be named blk_rq_map_. It should have a different better
>> name. Hell it exists today, as blk_rq_append_bio(), but that one
>> suggests usage in ways some people don't like, and they want to
>> remove it. My opinion is that: Both me and you could just use the
>> good old blk_rq_append_bio() and be happy.
>>
>> So basically in practice it just comes down to renaming
>> blk_rq_append_bio() to something. We both just don't know how to call
>> it?
> 
> Subtly different.  blk_rq_append_bio() doesn't bounce.  It seems we
> really need to figure out who needs what and how to provide the
> interface in uniform way.
> 
>>> I think it's about time to cool it a bit and try to see what's going
>>> on.  We don't really want blk_rq_map_*() to do three completely
>>> different things, right?  Usage of blk_rq_map_{user[_iov]|kern}()
>>> isn't too wide spread, so cleaning up the API shouldn't be difficult.
>> Currently blk_rq_map_sg() is the only odd ball, renaming that to something
>> sane will fix the current situation.
>>
>> What additionally we both want is just plain old blk_rq_append_bio and
>> maybe with a better name?
> 
> Yeah, basically, something similar to that but without the subtle
> traps.  :-)
> 
>>> The difference explains why we have two different
>>> initialization directions, so to me, the current API seems logical
>>> although we really should be using different names.
>>>
>>> Can you please explain what your need is?  Why do you want
>>> blk_make_request()?
>>>
>> I don't need blk_make_request per-se, I just need a way to
>> allocate a request and then associate a pre built bio with it,
>> that was prepared by an upper filesystem.
>>
>> (Which talks OSD, which does not fit the block device model at all,
>> but this is too much information for you)
>>
>> Farther more, My life is more complicated then that because, I need
>> a bidi-request which is second request hanging on the first one. And
>> each request can map up to 6 segments of source information that
>> are finally laid linear on the wire. So my bio can not be built
>> with a single blk_rq_map_xxx call.
>>
>> To make the story short blk_rq_append_bio() can be used by your
>> code and mine, perhaps with a better name.
>>
>> I feel I took to much of your time with my petty problems, Just
>> that I felt that if adding an associate-this-request-with-this-bio
>> API to blkdev.h could be done in a way that makes both of us happy.
> 
> Thanks for the explanation.
> 
> I think the problem is unclear distinction between bio initialization
> and rq initialization.  Ideally, blk_rq_map*() functions should
> initialize rq, call appropriate bio map function, link the result into
> rq and be done with it, but currently blk_rq_map*() functions do more
> than that and that makes cutting out the bio initialization apart
> difficult, so in case where bios need to be initialized separately
> from rq, the interface gets weird.  What level of bio initialization
> should the init-rq-from-bio function should expect?  Is it already
> bounced?  Does it have aligned buffer and etc?
> 
> If we can define cleaner bio mapping interface and make rq mapping
> functions thinner wrapper around those, it will be much better, but
> that doesn't seem to be a trivial thing.  Is it possible for you to
> stay with blk_rq_append_bio() for the time being?  I'll revisit the
> mapping API once the current pile of patches I'm sitting on settle
> down a bit.
> 

Yes sure, I'll be thinking about this some more too. Once your patch
pile settles we can sort out an additional cleanup that unifies some
of today's exported functions, just like you did with the blk_end_request.

> Thanks.
> 

Do you have a public tree I can inspect the all lot in one central
place? That should be the IDE tree you published few days ago
right? I'll look for it.

Thanks
Boaz
