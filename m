Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZGXUuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZGXUuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZGXUuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:50:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZGXUuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:50:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=p9MssEmTFqP/AQehRgVjoywChAg7s4yCvwIapMjwksC8pSWnU5ush9G/2pBND2avd
	PqOzSmOMj3CtdIYgIWHrA==
MIME-Version: 1.0
In-Reply-To: <20090715215214.GA3994@redhat.com>
References: <20090715212553.8349.51342.stgit@hyd-omgvisitor1.hyd.corp.google.com> 
	<20090715215214.GA3994@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 24 Jul 2009 13:49:40 -0700
Message-ID: <af41c7c40907241349r6a1ba386le64c526ea1b9a60e@mail.gmail.com>
Subject: Re: [PATCH] block: Improve think time sampling for CFQ
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       mrubin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 2:52 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Thu, Jul 16, 2009 at 02:56:54AM +0530, Divyesh Shah wrote:
>> Avoid taking a think time sample when the cfqq is not a sync queue or not
>> currently active or till its first request in the ongoing timeslice
>> completes.
>>
>
> Hi Divyesh,
>
> It would be nice to give some more details in changelog regarding why are
> you donig this change.

Hi Vivek,
    It seems like I misunderstood the last_end_request and the
io_thinktime calculations. Please ignore this patch.

>
>
>> Signed-off by: Divyesh Shah <dpshah@google.com>
>> ---
>> This applies to Linus's kernel tree.
>>
>>  block/cfq-iosched.c |   15 +++++++++++----
>>  1 files changed, 11 insertions(+), 4 deletions(-)
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index fd7080e..1657d4f 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1904,10 +1904,17 @@ err:
>>  }
>>
>>  static void
>> -cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_io_context *cic)
>> +cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>> +                     struct cfq_io_context *cic)
>>  {
>> -     unsigned long elapsed = jiffies - cic->last_end_request;
>> -     unsigned long ttime = min(elapsed, 2UL * cfqd->cfq_slice_idle);
>> +     unsigned long elapsed, ttime;
>> +
>> +     if (!cfq_cfqq_sync(cfqq) || cfqq != cfqd->active_queue ||
>> +         cfq_cfqq_slice_new(cfqq))
>> +             return;
>
> If we take a valid sample only when cfqq is the active queue, I think it
> will take a long time before idling is enabled back?
>
> For example consider a queue for which idling got disabled for some
> reason. Now that queue will be scheduled in and after completion of
> request, we will not idle and immediately expire the queue. For sequential
> readers, next request most likely will come after the expiry of the queue.
> Now this queue is not active, so when next request comes in, that sample
> will not be valid and we will never enable the idling on this queue?
>
> I am not sure what are you trying to solve here. I guess that you are
> concerned about the case where a reader can drive queue depth more than 1.
> So after first request when next request comes in, it is probably not very
> fair to compare it with cic->last_end_request. Instead it should be
> compared with arrival time of previous request?
>
> If yes, then we can probably maintain another variable, cic->last_req_arrival
> and calculate elapsed time based on last_req_arrival only if it is after
> the last_end_request. May be something like as follows.
>
>        if (time_after(cic->last_req_arrival, cic->last_end_request))
>                elapsed = jiffies - cic->last_req_arrival;
>        else
>                elapsed = jiffies - cic->last_end_request;
>
> One more question, why are you not considering a sample valid if slice_new
> is set for the active queue? I think with introduction of
> last_req_arrival, we probably would not need it.
>
> Thanks
> Vivek
>
>> +
>> +     elapsed = jiffies - cic->last_end_request;
>> +     ttime = min(elapsed, 2UL * cfqd->cfq_slice_idle);
>>
>>       cic->ttime_samples = (7*cic->ttime_samples + 256) / 8;
>>       cic->ttime_total = (7*cic->ttime_total + 256*ttime) / 8;
>> @@ -2072,7 +2079,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>       if (rq_is_meta(rq))
>>               cfqq->meta_pending++;
>>
>> -     cfq_update_io_thinktime(cfqd, cic);
>> +     cfq_update_io_thinktime(cfqd, cfqq, cic);
>>       cfq_update_io_seektime(cfqd, cic, rq);
>>       cfq_update_idle_window(cfqd, cfqq, cic);
>>
>
