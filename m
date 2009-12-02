Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZLBOOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZLBOOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZLBOOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:14:24 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:39757 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZLBOOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CX5Wx297CEM9Oq/yW6YUwIu9inAAh+5444FagRjertFTthtuwDrjzU0cE1lgZ2jtQ2
         Uz9exNvlNKVAB+o/M3/KUF0+uXeg2/BCQ2i5mYBdGC44AFgrNXsU6+Tuy2viS6sV++34
         uZdDqe0EalHQTGllBD4+NhFpDQk1qVqsjOVL8=
MIME-Version: 1.0
In-Reply-To: <x49zl61lcg8.fsf@segfault.boston.devel.redhat.com>
References: <200911241449.36336.czoccolo@gmail.com>
	 <x49zl61lcg8.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 2 Dec 2009 15:14:22 +0100
Message-ID: <4e5e476b0912020614r7352727an62f441e191ae6609@mail.gmail.com>
Subject: Re: [PATCH 4/4] cfq-iosched: fix corner cases in idling logic
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On Wed, Dec 2, 2009 at 2:42 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> Idling logic was disabled in some corner cases, leading to unfair share
>> for noidle queues.
>> * the idle timer was not armed if there were other requests in the
>>   driver. unfortunately, those requests could come from other workloads,
>>   or queues for which we don't enable idling. So we will check only
>>   pending requests from the active queue
>> * rq_noidle check on no-idle queue could disable the end of tree idle if
>>   the last completed request was rq_noidle. Now, we will disable that
>>   idle only if all the queues served in the no-idle tree had rq_noidle
>>   requests.
>>
>> Reported-by: Vivek Goyal <vgoyal@redhat.com>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>
>> @@ -2606,17 +2608,27 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>>                       cfq_clear_cfqq_slice_new(cfqq);
>>               }
>>               /*
>> -              * If there are no requests waiting in this queue, and
>> -              * there are other queues ready to issue requests, AND
>> -              * those other queues are issuing requests within our
>> -              * mean seek distance, give them a chance to run instead
>> -              * of idling.
>> +              * Idling is not enabled on:
>> +              * - expired queues
>> +              * - idle-priority queues
>> +              * - async queues
>> +              * - queues with still some requests queued
>> +              * - when there is a close cooperator
>>                */
>
> I'm not sure this logic is correct.  Is this for the 2.6.33 branch?
Yes.
> If so, the coop flag now means that multiple processes share the same
> cfqq.  Are you sure this is the right thing to do for close cooperators?
I'm not sure. I didn't change the logic for close cooperators:
-               else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq) &&
-                        sync && !rq_noidle(rq))
-                       cfq_arm_slice_timer(cfqd);
+               else if (sync && cfqq_empty &&
+                        !cfq_close_cooperator(cfqd, cfqq)) {
+                       cfqd->noidle_tree_requires_idle |= !rq_noidle(rq);

I changed the rq_noidle part, and rewrote the comment to be aligned
with the code.
So I don't mind if you improve (or just remove) the close cooperator part.
Probably, you should do a test where close cooperating processes are competing
with a sequential reader, to see the effect of idling or not on them.

Thanks
Corrado

>
> Cheers,
> Jeff

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
