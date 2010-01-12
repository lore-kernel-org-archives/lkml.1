Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839Ab0ALUFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab0ALUFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 15:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642Ab0ALUFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 15:05:33 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:38998 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0ALUFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 15:05:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZDOioIiodUWI5kfJTHsY+xhQPS78miBcSyX/xOtKm9pGbSr8YPTJwI9YK3tzpzUJJk
         40hYDNV91d0TSoyzlXZkWLn0JCWGfn6u2XmjMPtd8bwbHWtkiW+WbcDBS0bSSXbywc2c
         AN7xt3HE0RCrpPu3iLYq9COKyH0K5T6+aJKJo=
MIME-Version: 1.0
In-Reply-To: <20100112191257.GE3065@redhat.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
	 <20100112191257.GE3065@redhat.com>
Date: Tue, 12 Jan 2010 21:05:29 +0100
Message-ID: <4e5e476b1001121205u4fd487b7o2ee6dd42c8740955@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Tue, Jan 12, 2010 at 8:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Jan 09, 2010 at 04:59:17PM +0100, Corrado Zoccolo wrote:
>> Current seeky detection is based on average seek lenght.
>> This is suboptimal, since the average will not distinguish between:
>> * a process doing medium sized seeks
>> * a process doing some sequential requests interleaved with larger seeks
>> and even a medium seek can take lot of time, if the requested sector
>> happens to be behind the disk head in the rotation (50% probability).
>>
>> Therefore, we change the seeky queue detection to work as follows:
>> * each request can be classified as sequential if it is very close to
>>   the current head position, i.e. it is likely in the disk cache (disks
>>   usually read more data than requested, and put it in cache for
>>   subsequent reads). Otherwise, the request is classified as seeky.
>> * an history window of the last 32 requests is kept, storing the
>>   classification result.
>> * A queue is marked as seeky if more than 1/8 of the last 32 requests
>>   were seeky.
>>
>> This patch fixes a regression reported by Yanmin, on mmap 64k random
>> reads.
>>
>
> Ok, I did basic testing of this patch on my hardware. I got a RAID-0
> configuration and there are 12 disks behind it. I ran 8 fio mmap random
> read processes with block size 64K and following are the results.
>
> Vanilla (3 runs)
> ===============
> aggrb=3,564KB/s (cfq)
> aggrb=3,600KB/s (cfq)
> aggrb=3,607KB/s (cfq)
>
> aggrb=3,992KB/s,(deadline)
> aggrb=3,953KB/s (deadline)
> aggrb=3,991KB/s (deadline)
>
> Patched kernel (3 runs)
> =======================
> aggrb=2,080KB/s (cfq)
> aggrb=2,100KB/s (cfq)
> aggrb=2,124KB/s (cfq)
>
> My fio script
> =============
> [global]
> directory=/mnt/sda/fio/
> size=8G
> direct=0
> runtime=30
> ioscheduler=cfq
> exec_prerun="echo 3 > /proc/sys/vm/drop_caches"
> group_reporting=1
> ioengine=mmap
> rw=randread
> bs=64K
>
> [randread]
> numjobs=8
> =================================
>
> There seems to be around more than 45% regression in this case.
>
> I have not run the blktrace, but I suspect it must be coming from the fact
> that we are now treating a random queue as sync-idle hence driving queue
> depth as 1. But the fact is that read ahead much not be kicking in, so
> we are not using the power of parallel processing this striped set of
> disks can do for us.
>
Yes. Those results are expected, and are the other side of the medal.
If we handle those queues as sync-idle, we get better performance
on single disk (and regression on RAIDs), and viceversa if we handle
them as sync-noidle.

Note that this is limited to mmap with large block size. Normal read/pread
is not affected.

> So treating this kind of cfqq as sync-idle seems to be a bad idea atleast
> on configurations where multiple disks are in raid configuration.

The fact is, can we reliably determine which of those two setups we
have from cfq?
Until we can, we should optimize for the most common case.

Also, does the performance drop when the number of processes
approaches 8*number of spindles?
I think it should, so we will need to identify exacly the number of
spindles to be able to
allow only the right amount of parallelism.

> For yanmin's case, he seems to be running a case where there is only single
> spindle and mulitple processes doing IO on that spindle. So I guess it
> does not suffer from the fact that we are driving queue depth as 1.

Yes. Yanmin's configuration is a JBOD, i.e. a multi disk configuration
in which no partition spans multiple disks, so you have at most 1 spindle
per partition, possibly shared with others.

>
> Why did I include some "deadline" numbers also? Just like that. Recently
> I have also become interested in comaparing CFQ with "deadline" for
> various workloads and see which one performs better in what
> circumstances.
>
Sounds sensible, especially for RAID configurations it can be a good comparison.

Thanks,
Corrado

> Thanks
> Vivek
>
>> Reported-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>> ---
>>  block/cfq-iosched.c |   54 +++++++++++++-------------------------------------
>>  1 files changed, 14 insertions(+), 40 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index c6d5678..4e203c4 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -133,9 +133,7 @@ struct cfq_queue {
>>       unsigned short ioprio, org_ioprio;
>>       unsigned short ioprio_class, org_ioprio_class;
>>
>> -     unsigned int seek_samples;
>> -     u64 seek_total;
>> -     sector_t seek_mean;
>> +     u32 seek_history;
>>       sector_t last_request_pos;
>>       unsigned long seeky_start;
>>
>> @@ -1658,22 +1656,13 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
>>               return cfqd->last_position - blk_rq_pos(rq);
>>  }
>>
>> -#define CFQQ_SEEK_THR                8 * 1024
>> -#define CFQQ_SEEKY(cfqq)     ((cfqq)->seek_mean > CFQQ_SEEK_THR)
>> +#define CFQQ_SEEK_THR                (sector_t)(8 * 100)
>> +#define CFQQ_SEEKY(cfqq)     (hweight32(cfqq->seek_history) > 32/8)
>>
>>  static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>                              struct request *rq, bool for_preempt)
>>  {
>> -     sector_t sdist = cfqq->seek_mean;
>> -
>> -     if (!sample_valid(cfqq->seek_samples))
>> -             sdist = CFQQ_SEEK_THR;
>> -
>> -     /* if seek_mean is big, using it as close criteria is meaningless */
>> -     if (sdist > CFQQ_SEEK_THR && !for_preempt)
>> -             sdist = CFQQ_SEEK_THR;
>> -
>> -     return cfq_dist_from_last(cfqd, rq) <= sdist;
>> +     return cfq_dist_from_last(cfqd, rq) <= CFQQ_SEEK_THR;
>>  }
>>
>>  static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>> @@ -2971,30 +2960,16 @@ static void
>>  cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>                      struct request *rq)
>>  {
>> -     sector_t sdist;
>> -     u64 total;
>> -
>> -     if (!cfqq->last_request_pos)
>> -             sdist = 0;
>> -     else if (cfqq->last_request_pos < blk_rq_pos(rq))
>> -             sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
>> -     else
>> -             sdist = cfqq->last_request_pos - blk_rq_pos(rq);
>> -
>> -     /*
>> -      * Don't allow the seek distance to get too large from the
>> -      * odd fragment, pagein, etc
>> -      */
>> -     if (cfqq->seek_samples <= 60) /* second&third seek */
>> -             sdist = min(sdist, (cfqq->seek_mean * 4) + 2*1024*1024);
>> -     else
>> -             sdist = min(sdist, (cfqq->seek_mean * 4) + 2*1024*64);
>> +     sector_t sdist = 0;
>> +     if (cfqq->last_request_pos) {
>> +             if (cfqq->last_request_pos < blk_rq_pos(rq))
>> +                     sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
>> +             else
>> +                     sdist = cfqq->last_request_pos - blk_rq_pos(rq);
>> +     }
>>
>> -     cfqq->seek_samples = (7*cfqq->seek_samples + 256) / 8;
>> -     cfqq->seek_total = (7*cfqq->seek_total + (u64)256*sdist) / 8;
>> -     total = cfqq->seek_total + (cfqq->seek_samples/2);
>> -     do_div(total, cfqq->seek_samples);
>> -     cfqq->seek_mean = (sector_t)total;
>> +     cfqq->seek_history <<= 1;
>> +     cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
>>
>>       /*
>>        * If this cfqq is shared between multiple processes, check to
>> @@ -3032,8 +3007,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>               cfq_mark_cfqq_deep(cfqq);
>>
>>       if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>> -         (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
>> -          && CFQQ_SEEKY(cfqq)))
>> +         (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
>>               enable_idle = 0;
>>       else if (sample_valid(cic->ttime_samples)) {
>>               if (cic->ttime_mean > cfqd->cfq_slice_idle)
>> --
>> 1.6.4.4
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
