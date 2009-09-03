Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbZICQ0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbZICQ0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZICQ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:26:14 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:3612 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbZICQ0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LhERxXLBTGDSAu7hP6XmqPBzX0SL6+a6+E1PD2UV20sNyGqWM7kMnC3kFlTNKJXnPZ
         TA0Zk8+xYVb5aUWZIDUY1r1liXipYcf5wMwocKvcLiy9MDfYzqbFyPt4OICpRrBKQZjQ
         7SAGKiPSAfTU7Yst1+OdplmM0zK4S8/41812Q=
MIME-Version: 1.0
In-Reply-To: <x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com>
	 <x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 3 Sep 2009 18:26:15 +0200
Message-ID: <4e5e476b0909030926i35ee1b39l3f300426748974b5@mail.gmail.com>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Thu, Sep 3, 2009 at 3:01 PM, Jeff Moyer<jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> When the number of processes performing I/O concurrently increases,  a
>> fixed time slice per process will cause large latencies.
>> In the patch, if there are more than 3 processes performing concurrent
>> I/O, we scale the time slice down proportionally.
>> To safeguard sequential bandwidth, we impose a minimum time slice,
>> computed from cfq_slice_idle (the idea is that cfq_slice_idle
>> approximates the cost for a seek).
>>
>> I performed two tests, on a rotational disk:
>> * 32 concurrent processes performing random reads
>> ** the bandwidth is improved from 466KB/s to 477KB/s
>> ** the maximum latency is reduced from 7.667s to 1.728
>> * 32 concurrent processes performing sequential reads
>> ** the bandwidth is reduced from 28093KB/s to 24393KB/s
>> ** the maximum latency is reduced from 3.781s to 1.115s
>>
>> I expect numbers to be even better on SSDs, where the penalty to
>> disrupt sequential read is much less.
>
> Interesting approach.  I'm not sure what the benefits will be on SSDs,
> as the idling logic is disabled for them (when nonrot is set and they
> support ncq).  See cfq_arm_slice_timer.
>

Yes, I know. Unfortunately, not all SSD devices have ncq.
Moreover, idling is disabled only for seeky processes, and the current
threshold to identify seeky processes is so high, that it rarely kicks
in.

>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail-com>
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index fd7080e..cff4ca8 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -306,7 +306,15 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct
>> cfq_queue *cfqq)
>>  static inline void
>>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  {
>> -       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
>> +       unsigned low_slice = cfqd->cfq_slice_idle * (1 + cfq_cfqq_sync(cfqq));
>> +       unsigned interested_queues = cfq_class_rt(cfqq) ?
>> cfqd->busy_rt_queues : cfqd->busy_queues;
>
> Either my mailer displayed this wrong, or yours wraps lines.
>
>> +       unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
>> +       if (interested_queues > 3) {
>> +               slice *= 3;
>
> How did you come to this magic number of 3, both for the number of
> competing tasks and the multiplier for the slice time?  Did you
> experiment with this number at all?
>

The number is quickly explained. The base slice is 100ms, and on the
mailing list it was mentioned that the latency becomes  annoing for an
user when it is above 300ms.
This means that, up to 3 processes, the current thresholds are good,
and for more we have to scale.
This is good, because we don't change the behaviour unless we have
many competing processes.

>> +               slice /= interested_queues;
>
> Of course you realize this could disable the idling logic completely,
> right?  I'll run this patch through some tests and let you know how it
> goes.
>
You already found that this is not the case.

Thanks for the interest
Corrado
> Thanks!
>
> -Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
