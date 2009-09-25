Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZIYIGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZIYIGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZIYIF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:05:58 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:36837 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZIYIFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q1AVR+0UFAo5rccQMwbrodlyzfDEuG+B6kuCX2XrDC4Zh4MMS7+mkYsO8J+6KcYAS3
         t/Gyldg6DDOYB+gebtH51+z1WfIAe5ianqEd7ltNEn9hvMlhqQny8nUR+2PFkadJo5bj
         OgTXfLYgC33GP+49sCUbFyX7CG8EBLa9T1YsM=
MIME-Version: 1.0
In-Reply-To: <4ABB3A0E.2090204@cn.fujitsu.com>
References: <4AB74629.1030109@cn.fujitsu.com> <4ABB3A0E.2090204@cn.fujitsu.com>
Date: Fri, 25 Sep 2009 10:05:52 +0200
Message-ID: <4e5e476b0909250105m18983420g20e39cb2b124af04@mail.gmail.com>
Subject: Re: [Fwd: [RFC] cfq: adapt slice to number of processes doing I/O 
	(v2.1)]
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-kernel@vger.kernel.org, Tobias Oetiker <tobi@oetiker.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shan,
On Thu, Sep 24, 2009 at 11:21 AM, Shan Wei <shanwei@cn.fujitsu.com> wrote:
>> Subject:
>> [RFC] cfq: adapt slice to number of processes doing I/O (v2.1)
>>
>> When the number of processes performing I/O concurrently increases,
>> a fixed time slice per process will cause large latencies.
>>
>> This (v2.1) patch will scale the time slice assigned to each process,
>> according to a target latency (tunable from sysfs, default 300ms).
>>
>> In order to keep fairness among processes, we adopt two devices, w.r.t. v1.
>>
>> * The number of active processes is computed using a special form of
>> running average, that quickly follows sudden increases (to keep latency low),
>> and decrease slowly (to have fairness in spite of rapid decreases of this
>> value).
>>
>> * The idle time is computed using remaining slice as a maximum.
>>
>> To safeguard sequential bandwidth, we impose a minimum time slice
>> (computed using 2*cfq_slice_idle as base, adjusted according to priority
>> and async-ness).
>>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>>
>
> I'm interested in the idea of dynamically tuning the time slice according to the number of
> processes. I have tested your patch using Jeff's tool on kernel-2.6.30-rc4.
> From the following test result, after applying your patch, the fairness is not good
> as original kernel, e.g. io priority of 4 vs 5 in be0-through-7.fio case.

In Jeff's test, the results are always in the same order, so you can
compare different runs, e.g. be4-x-8.fio with be0-through-7.fio.
If we compare the processes that caused the priority inversion, i.e.
5th and 6th process, in the equal priority case we have:

for original cfq:
(5th) be      4       64548   42388   -35
(6th) be      4       64548   73780   14

for patched cfq:
(5th) be      4       57384   55028   -5
(6th) be      4       57384   69620   21

It is clear that the 5th file has slower (between 30% and 50%) access
than the 6th (maybe caused by fragmentation, or bad disk placement),
so this can easily explain the 11% priority inversion.
(5th) be      4       56116   18420   -68
(6th) be      5       44893   19700   -57

BTW, with smaller slices, even a single seek while performing
sequential read may cause a bigger degradation, so the effect on the
patched cfq can be more evident.

>From your numbers, actually, I see much better fairness than what Jeff
experienced with the first version of my patch, so the improvements
have actually paid out.

> And the throughout(total data transferred) becomes lower.
That is expected. We trade some throughput for better latency. You can
increase the target_latency to have back your throughput (e.g. for
non-interactive servers). Decreasing target_latency too much will not
improve the latency indefinitely, since we have a lower bound for the
slice, though (and hardware limitations).

> Have you tested buffered write, multi-threads?
Yes. One interesting test was done by Tobias Oetiker
(http://oss.oetiker.ch/optools/wiki/fsopbench) on his Areca HW Raid6
with ext3. He put target_latency to 200ms, and used a lower
slice_idle, to match his faster disks.

Here the writers are creating many files (metadata & journal writes)
of varying sizes (the distribution is a realistic one, that simulates
an user home), writing to them (this will cause buffered writes for
big files), and then syncing them (also sync writes, both to data and
metadata), so this is a torture test for ext3.
There is just 1 reader, instead, that is trying to access files and
measuring the latencies in doing so.

On 2.6.31 with cfq and ordered data it gives the following results

 ./fsopbench.pl --writers=6 --continuous /tmp/mnt/home_a/fsopbench_tree/

In-Competition with 6 Writers - Mode  30s Interval
-----------------------------------------------------------------
A read dir        cnt    371    min    0.001 ms    max  348.297 ms
mean    2.499 ms    stdev  22.800
B stat file       cnt    351    min    0.007 ms    max 1130.490 ms
mean    4.881 ms    stdev  61.887
C open file       cnt    293    min    0.014 ms    max    0.195 ms
mean    0.022 ms    stdev   0.017
D rd 1st byte     cnt    293    min    0.178 ms    max 1117.346 ms
mean   57.902 ms    stdev 153.807
E read rate       1.123 MB/s

On 2.6.31 with my cfq patch

In-Competition with 6 Writers - Mode  31s Interval
-----------------------------------------------------------------
A read dir        cnt    388    min    0.001 ms    max  240.531 ms
mean    1.145 ms    stdev  12.878
B stat file       cnt    366    min    0.006 ms    max  199.893 ms
mean    0.920 ms    stdev  10.840
C open file       cnt    300    min    0.014 ms    max    0.340 ms
mean    0.025 ms    stdev   0.028
D rd 1st byte     cnt    300    min    0.184 ms    max 1443.066 ms
mean   69.599 ms    stdev 193.984
E read rate       1.023 MB/s

As you can see, my patch inproved both average and maximum latency for
readdir and stat, while reading the first byte needed more time, and
read throughput decreased 10%.
The total time in the worst case to reach a file and read data from it
decreased from 2.5s to about 1.8s, and also average case gained few
ms.

>
> Additionally i have a question about the minimum time slice, see the comment in your patch.
>
> *Original*(2.6.30-rc4 without patch):
> /cfq-regression-tests/2.6.30-rc4-log/be0-through-7.fio
> total priority: 880
> total data transferred: 535872
> class   prio    ideal   xferred %diff
> be      0       109610  149748  36
> be      1       97431   104436  7
> be      2       85252   91124   6
> be      3       73073   64244   -13
> be      4       60894   59028   -4
> be      5       48715   38132   -22
> be      6       36536   21492   -42
> be      7       24357   7668    -69
>
> /cfq-regression-tests/2.6.30-rc4-log/be0-vs-be1.fio
> total priority: 340
> total data transferred: 556008
> class   prio    ideal   xferred %diff
> be      0       294357  402164  36
> be      1       261650  153844  -42
>
> /cfq-regression-tests/2.6.30-rc4-log/be0-vs-be7.fio
> total priority: 220
> total data transferred: 537064
> class   prio    ideal   xferred %diff
> be      0       439416  466164  6
> be      7       97648   70900   -28
>
> /cfq-regression-tests/2.6.30-rc4-log/be4-x-3.fio
> total priority: 300
> total data transferred: 532964
> class   prio    ideal   xferred %diff
> be      4       177654  199260  12
> be      4       177654  149748  -16
> be      4       177654  183956  3
>
> /cfq-regression-tests/2.6.30-rc4-log/be4-x-8.fio
> total priority: 800
> total data transferred: 516384
> class   prio    ideal   xferred %diff
> be      4       64548   78580   21
> be      4       64548   76436   18
> be      4       64548   75764   17
> be      4       64548   70900   9
> be      4       64548   42388   -35
> be      4       64548   73780   14
> be      4       64548   30708   -53
> be      4       64548   67828   5
>
>
> *Applied patch*(2.6.30-rc4 with patch):
>
> /cfq-regression-tests/log-result/be0-through-7.fio
> total priority: 880
> total data transferred: 493824
> class   prio    ideal   xferred %diff
> be      0       101009  224852  122
> be      1       89786   106996  19
> be      2       78562   70388   -11
> be      3       67339   38900   -43
> be      4       56116   18420   -68
> be      5       44893   19700   -57
> be      6       33669   9972    -71
> be      7       22446   4596    -80
>
> /cfq-regression-tests/log-result/be0-vs-be1.fio
> total priority: 340
> total data transferred: 537064
> class   prio    ideal   xferred %diff
> be      0       284328  375540  32
> be      1       252736  161524  -37
>
> /cfq-regression-tests/log-result/be0-vs-be7.fio
> total priority: 220
> total data transferred: 551912
> class   prio    ideal   xferred %diff
> be      0       451564  499956  10
> be      7       100347  51956   -49
>
> /cfq-regression-tests/log-result/be4-x-3.fio
> total priority: 300
> total data transferred: 509404
> class   prio    ideal   xferred %diff
> be      4       169801  196596  15
> be      4       169801  198388  16
> be      4       169801  114420  -33
>
> /cfq-regression-tests/log-result/be4-x-8.fio
> total priority: 800
> total data transferred: 459072
> class   prio    ideal   xferred %diff
> be      4       57384   70644   23
> be      4       57384   52980   -8
> be      4       57384   62356   8
> be      4       57384   60660   5
> be      4       57384   55028   -5
> be      4       57384   69620   21
> be      4       57384   51956   -10
> be      4       57384   35828   -38
>
>
> Hardware infos.:
> CPU: GenuineIntel Intel(R) Xeon(TM) CPU 3.00GHz
>     (4 logic cpus with hyper-thread on)
> memory:2G
> HDD:scsi
>
>> ---
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 0e3814b..ca90d42 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -27,6 +27,8 @@ static const int cfq_slice_sync = HZ / 10;
>>  static int cfq_slice_async = HZ / 25;
>>  static const int cfq_slice_async_rq = 2;
>>  static int cfq_slice_idle = HZ / 125;
>> +static int cfq_target_latency = HZ * 3/10; /* 300 ms */
>> +static int cfq_hist_divisor = 4;
>>
>>  /*
>>   * offset from end of service tree
>> @@ -134,6 +136,9 @@ struct cfq_data {
>>       struct rb_root prio_trees[CFQ_PRIO_LISTS];
>>
>>       unsigned int busy_queues;
>> +     unsigned int busy_queues_avg;
>> +     unsigned int busy_rt_queues;
>> +     unsigned int busy_rt_queues_avg;
>>
>>       int rq_in_driver[2];
>>       int sync_flight;
>> @@ -173,6 +178,8 @@ struct cfq_data {
>>       unsigned int cfq_slice[2];
>>       unsigned int cfq_slice_async_rq;
>>       unsigned int cfq_slice_idle;
>> +     unsigned int cfq_target_latency;
>> +     unsigned int cfq_hist_divisor;
>>
>>       struct list_head cic_list;
>>
>> @@ -301,10 +308,40 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>       return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
>>  }
>>
>> +static inline unsigned
>> +cfq_get_interested_queues(struct cfq_data *cfqd, bool rt) {
>> +     unsigned min_q, max_q;
>> +     unsigned mult = cfqd->cfq_hist_divisor - 1;
>> +     unsigned round = cfqd->cfq_hist_divisor / 2;
>> +     if (rt) {
>> +             min_q = min(cfqd->busy_rt_queues_avg, cfqd->busy_rt_queues);
>> +             max_q = max(cfqd->busy_rt_queues_avg, cfqd->busy_rt_queues);
>> +             cfqd->busy_rt_queues_avg = (mult * max_q + min_q + round) /
>> +                     cfqd->cfq_hist_divisor;
>> +             return cfqd->busy_rt_queues_avg;
>> +     } else {
>> +             min_q = min(cfqd->busy_queues_avg, cfqd->busy_queues);
>> +             max_q = max(cfqd->busy_queues_avg, cfqd->busy_queues);
>> +             cfqd->busy_queues_avg = (mult * max_q + min_q + round) /
>> +                     cfqd->cfq_hist_divisor;
>> +             return cfqd->busy_queues_avg;
>> +     }
>> +}
>> +
>>  static inline void
>>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  {
>> -     cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
>> +     unsigned process_thr = cfqd->cfq_target_latency / cfqd->cfq_slice[1];
>> +     unsigned iq = cfq_get_interested_queues(cfqd, cfq_class_rt(cfqq));
>> +     unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
>> +
>> +     if (iq > process_thr) {
>> +             unsigned low_slice = 2 * slice * cfqd->cfq_slice_idle
>> +                     / cfqd->cfq_slice[1];
>
> For sync queue, the minimum time slice is decided by slice_idle, base time slice and io priority.
> But for async queue, why is the minimum time slice also limited by base time slice of sync queue?

You should consider that slice, computed calling cfq_prio_to_slice,
will already be:
for sync:  cfqd->cfq_slice[1] altered to consider the priority
for async: cfqd->cfq_slice[0] altered to consider the priority
Now, I take that number, and multiply it by twice the slice_idle, and
divide it by cfqd->cfq_slice[1].
So it becomes (approximately):
for sync: 2 * slice altered to considet the priority
for async: 2 * slice * cfqd->cfq_slice[0]/cfqd->cfq_slice[1] altered
to considet the priority
Now if we ignore priorities for a while, we can see that the ratio
between sync slice and async slice in original cfq is:
cfqd->cfq_slice[1]/cfqd->cfq_slice[0]
and in my patch:
 2 * slice / (2 * slice * cfqd->cfq_slice[0]/cfqd->cfq_slice[1]) =
cfqd->cfq_slice[1]/cfqd->cfq_slice[0]
i.e. exactly the same.
So the intent is to preserve the ratio between sync and async slices.

Corrado

>
>
> Best Regards
> -----
> Shan Wei
>
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
