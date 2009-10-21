Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZJUQcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZJUQcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZJUQce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:32:34 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:37496 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZJUQcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HrCZI65sYqC0t+K86DsDKRK7idvecANGTVg7tZxKUvi2cqLwD1uPKWh7EOssZLmfb5
         HBnbgFtrtP7jf9yKtd7XV/STVXL7jXmtWq8Y0eDXvvxxufLrpj9OIfjwSLFWGniS+tAK
         6XUgsN6UF9xHQEUuBmoAybM1UjvSLjkceICY8=
MIME-Version: 1.0
In-Reply-To: <x49aazk91uj.fsf@segfault.boston.devel.redhat.com>
References: <200910202011.53858.czoccolo@gmail.com>
	 <x49aazk91uj.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 21 Oct 2009 18:32:37 +0200
Message-ID: <4e5e476b0910210932l2dffdabdv67a449ca162efd0f@mail.gmail.com>
Subject: Re: [RFC V2 PATCH 1/5] cfq-iosched: adapt slice to number of 
	processes doing I/O
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
On Wed, Oct 21, 2009 at 5:57 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi, Corrado!
>
> Sorry if folks receive this twice, but my mailer and I had an argument
> about this message.  ;-)
>
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> When the number of processes performing I/O concurrently increases,
>> a fixed time slice per process will cause large latencies.
>>
>> This patch, if low_latency mode is enabled,  will scale the time slice
>> assigned to each process according to a 300ms target latency.
>>
>> In order to keep fairness among processes:
>> * The number of active processes is computed using a special form of
>> running average, that quickly follows sudden increases (to keep latency low),
>> and decrease slowly (to have fairness in spite of rapid decreases of this
>> value).
>>
>> To safeguard sequential bandwidth, we impose a minimum time slice
>> (computed using 2*cfq_slice_idle as base, adjusted according to priority
>> and async-ness).
>
> I like the idea as well, but I have a question and some nits to pick.
>
>>  static inline void
>>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  {
>> -     cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
>> +     unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
>> +     if (cfqd->cfq_latency) {
>> +             unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
>> +             unsigned process_thr = cfq_target_latency / cfqd->cfq_slice[1];
>> +             if (iq > process_thr) {
>> +                     unsigned low_slice = 2 * slice * cfqd->cfq_slice_idle
>> +                             / cfqd->cfq_slice[1];
>> +                     slice = max(slice * cfq_target_latency /
>> +                             (cfqd->cfq_slice[1] * iq),
>
> Couldn't you have just divided the slice by iq?  And why iq?  Why not
> nr_qs or avg_qlen or something?  It's a minor nit; I can live with it.

iq stands for interested queues, because we are restricting the count
just to the same priority class, not all queues in the system.

>
>> +                             min(slice, low_slice));
>> +             }
>> +     }
>> +     cfqq->slice_end = jiffies + slice;
>>       cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
>
> Wow.  That function is *dense*.  I tried to write it in a more
> readable fashion, but please chime in if I misinterpreted anything.
>
> static inline void
> cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> {
>        unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
>
>        if (cfqd->cfq_latency) {
>                unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
>                unsigned slice_sync = cfqd->cfq_slice[1];
>                unsigned process_thr = cfq_target_latency / slice_sync;
>
>                if (iq > process_thr) {
>                        /*
>                         * Minimum slice is computed using 2*slice_idle as
>                         * a base, and then scaling it by priority and
>                         * async-ness.
>                         */
>                        unsigned total_sync = slice_sync * iq;
>                        unsigned slice_fraction = cfq_target_latency / total_sync;
>                        unsigned min_slice = (2 * cfqd->cfq_slice_idle) *
>                                (slice / slice_sync);
>                        min_slice = min(slice, min_slice);
>                        slice *= slice_fraction;
>                        slice = max(slice, min_slice);
>                }
>        }
>        cfqq->slice_end = jiffies + slice;
>        cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
> }
>
I don't think this is equivalent. You seem to compute some divisions
too early, losing in precision.
slice * cfq_target_latency / (cfqd->cfq_slice[1] * iq)
is not generally equivalent to:
slice * (cfq_target_latency / (cfqd->cfq_slice[1] * iq))
that is what you are computing.
There is an other such case in your simplification.

Corrado

>
> Cheers,
> Jeff
>
