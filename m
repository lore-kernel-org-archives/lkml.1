Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbYFXOgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbYFXOgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYFXOgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:36:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbYFXOgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:36:31 -0400
Date: Tue, 24 Jun 2008 10:36:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
In-Reply-To: <18528.36687.631672.462076@notabene.brown>
Message-ID: <Pine.LNX.4.64.0806241029120.23052@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
 <18528.36687.631672.462076@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Neil Brown wrote:

> On Tuesday June 24, mpatocka@redhat.com wrote:
>> Hi
>>
>> bio_endio calls bi_end_io callback. In case of stacked devices (raid, dm),
>> bio_end_io may call bio_endio again, up to an unspecified length.
>>
>> The crash because of stack overflow was really observed on sparc64. And
>> this recursion was one of the contributing factors (using 9 stack frames
>> --- that is 1728 bytes).
>>
>> This patch removes the recursion.
>
> This is very cool, thanks!  A close mirror of the recursion
> avoidance in generic_make_request.
>
> You use a per-cpu queue were generic_make_request uses a per-task
> queue.  This is fitting as bi_end_io doesn't have a process context,
> but is supposed to be fast and able to run with interrupts disabled,
> so tying to a cpu is no problem.

Yes. I think "current" variable can't be used in irq context, it would 
blow with irq-stacks (or access some weird unknown memory).

I had another version of the patch that doesn't disable interrupts and 
only disables preempt and uses local_t atomic cpu-local variables. It is 
somehow more tricky, because interrupt can be triggered any time while 
processing the queue and it can add anything to the queue. Then I realized 
that bio_endio runs most time with disabled interrupts anyway, so it'd be 
better to just disable interrupts and don't do that local_cmpxchg 
trickery.

Mikulas

>> +
>> +	bio_queue = NULL;
>> +queue_empty_next_bio:
>> +	*bio_end_queue_ptr = &bio_queue;
>> +next_bio:
>> +
>>   	if (error)
>>   		clear_bit(BIO_UPTODATE, &bio->bi_flags);
>>   	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
>> @@ -1175,6 +1196,17 @@
>>
>>   	if (bio->bi_end_io)
>>   		bio->bi_end_io(bio, error);
>> +
>> +	if (bio_queue) {
>> +		bio = bio_queue;
>> +		bio_queue = bio->bi_next;
>> +		if (!bio_queue) goto queue_empty_next_bio;
>> +		goto next_bio;
>
> checkpatch.pl doesn't like that:
> ERROR: trailing statements should be on next line
>
> and I don't either.  I would not bother with the mini-optimisation at
> all.
> Discard the queue_empty_next_bio label and replace the "if () goto"
> with
>       if (!bio_queue)
> 		*bio_end_queue_ptr = &bio_queue;
>
> and leave gcc to optimise the assignment if it wants to.
>
> Reviewed-by: NeilBrown <neilb@suse.de>
>
> Thanks,
> NeilBrown
>
