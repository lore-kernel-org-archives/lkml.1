Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZICPiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZICPiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZICPiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800AbZICPiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:38:10 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com>
	<x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 03 Sep 2009 11:38:05 -0400
In-Reply-To: <x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Thu, 03 Sep 2009 09:01:12 -0400")
Message-ID: <x49ab1cxcma.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> When the number of processes performing I/O concurrently increases,  a
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
> Interesting approach.  I'm not sure what the benefits will be on SSDs,
> as the idling logic is disabled for them (when nonrot is set and they
> support ncq).  See cfq_arm_slice_timer.
>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail-com>
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index fd7080e..cff4ca8 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -306,7 +306,15 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct
>> cfq_queue *cfqq)
>>  static inline void
>>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  {
>> -       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
>> +       unsigned low_slice = cfqd->cfq_slice_idle * (1 + cfq_cfqq_sync(cfqq));
>> +       unsigned interested_queues = cfq_class_rt(cfqq) ?
>> cfqd->busy_rt_queues : cfqd->busy_queues;
>
> Either my mailer displayed this wrong, or yours wraps lines.
>
>> +       unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
>> +       if (interested_queues > 3) {
>> +               slice *= 3;
>
> How did you come to this magic number of 3, both for the number of
> competing tasks and the multiplier for the slice time?  Did you
> experiment with this number at all?
>
>> +               slice /= interested_queues;
>
> Of course you realize this could disable the idling logic completely,
> right?  I'll run this patch through some tests and let you know how it
> goes.

I missed that you updated the slice end based on a max of slice and
low_slice.  Sorry about that.

This patch does not fare well when judging fairness between processes.
I have several fio jobs that generate read workloads, and I try to
figure out whether the I/O scheduler is providing fairness based on the
I/O priorities of the processes.  With your patch applied, we get the
following results:

total priority: 880
total data transferred: 1045920
class   prio    ideal   xferred %diff
be      0       213938  352500  64
be      1       190167  193012  1
be      2       166396  123380  -26
be      3       142625  86260   -40
be      4       118854  62964   -48
be      5       95083   40180   -58
be      6       71312   74484   4
be      7       47541   113140  137

Class and prio should be self-explanatory.  ideal is my cooked up
version of the ideal number of bytes the given priority should have
transferred based on the total data transferred and all processes
weighted by priority competing for the disk.  xferred is the actual
amount of data transferred, and %diff is the difference between those
last two columns.

Notice that best effort priority 7 managed to transfer more data than be
prio 3.  That's bad.  Now, let's look at 8 processes all at the same
priority level:

total priority: 800
total data transferred: 1071036
class   prio    ideal   xferred %diff
be      4       133879  222452  66
be      4       133879  243188  81
be      4       133879  187380  39
be      4       133879  42512   -69
be      4       133879  39156   -71
be      4       133879  47604   -65
be      4       133879  37364   -73
be      4       133879  251380  87

Hmm.  That doesn't look good.

For comparison, here is the output from the vanilla kernel for those two
runs:

total priority: 880
total data transferred: 954272
class   prio    ideal   xferred %diff
be      0       195192  229108  17
be      1       173504  202740  16
be      2       151816  156660  3
be      3       130128  152052  16
be      4       108440  91636   -16
be      5       86752   64244   -26
be      6       65064   34292   -48
be      7       43376   23540   -46

total priority: 800
total data transferred: 887264
class   prio    ideal   xferred %diff
be      4       110908  124404  12
be      4       110908  123380  11
be      4       110908  118004  6
be      4       110908  113396  2
be      4       110908  107252  -4
be      4       110908  98356   -12
be      4       110908  96244   -14
be      4       110908  106228  -5

It's worth noting that the overall throughput went up in the patched
kernel for this second case.  However, if we care at all about the
notion of I/O priorities, I think your patch needs more work.

Cheers,
Jeff
