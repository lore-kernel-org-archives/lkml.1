Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbZJTKBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbZJTKBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 06:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZJTKBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 06:01:39 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59890 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZJTKBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 06:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sIpt/HbgSSTAltm9e893kKTaNFqo51NEu3hUNEi/QuYZ4z3dIgeLbHhg+PhyWbSCoi
         P0/ZKVXi61HgwWcyUx9hPNh9UyrzwXriT6XyQETokaHWivJnAPeOaka+7lyCcbfrQ0cO
         Ls2rxShoDZKB5+WRCAT3W7Q8rcay77VS9etFs=
MIME-Version: 1.0
In-Reply-To: <20091020005446.GB10727@kernel.dk>
References: <200910192221.03805.czoccolo@gmail.com>
	 <20091020005446.GB10727@kernel.dk>
Date: Tue, 20 Oct 2009 12:01:43 +0200
Message-ID: <4e5e476b0910200301w4ae2725ch37b81c1529bdcfec@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] cfq-iosched: adapt slice to number of processes 
	doing I/O
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 2:54 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Oct 19 2009, Corrado Zoccolo wrote:
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
> Generally, this looks good. Just one minor style nit:
>
>> +static inline unsigned
>> +cfq_get_avg_queues(struct cfq_data *cfqd, bool rt) {
>> +     unsigned min_q, max_q;
>> +     unsigned mult  = cfq_hist_divisor - 1;
>> +     unsigned round = cfq_hist_divisor / 2;
>> +     unsigned busy  = rt ? cfqd->busy_rt_queues :
>> +             (cfqd->busy_queues - cfqd->busy_rt_queues);
>> +     min_q = min(cfqd->busy_queues_avg[rt], busy);
>> +     max_q = max(cfqd->busy_queues_avg[rt], busy);
>> +     cfqd->busy_queues_avg[rt] = (mult * max_q + min_q + round) /
>> +             cfq_hist_divisor;
>> +     return cfqd->busy_queues_avg[rt];
>> +}
>
> A lot of your code suffers from the specific problem of being largely
> unreadable. To me, as the maintainer of that code, that is a maintenance
> issue. I already asked you to get rid of the ?: constructs for earlier
> patches, this series even takes it to the extreme of doing nested ?:
> clauses. Don't do it! It's unreadable.

Ok. I'll resubmit a revised version of the patches that address this
stile issue, as well as your concern with too large functions and
lacking comments.
I didn't realize that you hated ?: so much :).
To me, it seems a good way to achieve a different readability goal,
i.e. define the value of a variable in a single place, instead of
scattering it around on multiple lines.
>
>> @@ -2152,10 +2186,9 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
>>       cfq_log_cfqq(cfqd, cfqq, "insert_request");
>>       cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
>>
>> -     cfq_add_rq_rb(rq);
>> -
>>       rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
>>       list_add_tail(&rq->queuelist, &cfqq->fifo);
>> +     cfq_add_rq_rb(rq);
>>
>>       cfq_rq_enqueued(cfqd, cfqq, rq);
>
> If the fifo vs service tree ordering is now important, you should
> comment on why.
It's not important for the patches per se, but I found odd (and it
caused me some headache while debugging) that in cfq_add_rq_rb the
fifo was still empty.
In the new form, the rq will be complete when added, while in the
previous, it still had some empty fields.

Corrado
>
> --
> Jens Axboe
>
>



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
